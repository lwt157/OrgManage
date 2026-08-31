using System;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.Script.Services;
using System.Web.UI;
using System.Web;
using OrgManage.APP_Code;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace OrgManage
{
    public partial class Admin_OrgAuditDept : System.Web.UI.Page
    {
        // ===== 统计属性 =====
        public int pendingCount = 0;
        public int disbandCount = 0;
        public int orgCount = 0;
        public int totalMemberCount = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            Utils.RequireLogin();
            if (Utils.GetCurrentUserRole() != 3)
            {
                Response.Write("<script>alert('无权限！仅院级管理员可访问');location.href='../Default.aspx';</script>");
                Response.End();
            }

            // ★ 统计数据用内联表达式<%= %>渲染，PostBack后必须重新计算（不能从ViewState恢复）
            LoadStatistics();

            if (!IsPostBack)
            {
                LoadPendingList();
                LoadOrgList();
                LoadDisbandList();
            }
        }

        /// <summary>
        /// 加载所有数据（包括统计信息）
        /// </summary>
        private void LoadAllData()
        {
            LoadPendingList();
            LoadOrgList();
            LoadDisbandList();
            LoadStatistics();
        }

        /// <summary>
        /// 【新增】加载统计信息（兼容现有DbHelper接口）
        /// </summary>
        private void LoadStatistics()
        {
            try
            {
                // 待审核申请数
                DataTable dt1 = DbHelper.ExecuteQuery(
                    "SELECT COUNT(*) AS Cnt FROM Organizations WHERE Status = 0 AND AuditorRole = 3");
                if (dt1.Rows.Count > 0) pendingCount = Convert.ToInt32(dt1.Rows[0]["Cnt"]);

                // 解散申请数
                DataTable dt2 = DbHelper.ExecuteQuery(@"
                    SELECT COUNT(*) AS Cnt FROM OrgDisbandRequests r
                    LEFT JOIN Organizations o ON r.OrgID = o.OrgID
                    WHERE r.Status = 0 AND o.AuditorRole = 3");
                if (dt2.Rows.Count > 0) disbandCount = Convert.ToInt32(dt2.Rows[0]["Cnt"]);

                // 已通过组织数
                DataTable dt3 = DbHelper.ExecuteQuery(
                    "SELECT COUNT(*) AS Cnt FROM Organizations WHERE Status = 1 AND AuditorRole = 3");
                if (dt3.Rows.Count > 0) orgCount = Convert.ToInt32(dt3.Rows[0]["Cnt"]);

                // 总成员数
                DataTable dt4 = DbHelper.ExecuteQuery(@"
                    SELECT ISNULL(SUM(mc.MemberCount), 0) AS Cnt FROM (
                        SELECT COUNT(*) AS MemberCount FROM OrgMembers m
                        INNER JOIN Organizations o ON m.OrgID = o.OrgID
                        WHERE o.Status = 1 AND o.AuditorRole = 3 AND m.Status = 1
                        GROUP BY m.OrgID
                    ) mc");
                if (dt4.Rows.Count > 0) totalMemberCount = Convert.ToInt32(dt4.Rows[0]["Cnt"]);
            }
            catch
            {
                // 统计不阻塞主流程
                pendingCount = gvPending.Rows.Count;
                orgCount = gvOrgList.Rows.Count;
                disbandCount = gvDisband.Rows.Count;
            }
        }

        // 加载待审核院级组织
        private void LoadPendingList()
        {
            string sql = @"
                SELECT o.OrgID, o.OrgName, 
                       ISNULL(c.CategoryName, '未知类型') AS CategoryName, 
                       ISNULL(u.UserName, '暂无') AS LeaderName,
                       o.ContactInfo, o.CreateTime
                FROM Organizations o
                LEFT JOIN OrgCategories c ON o.CategoryID = c.CategoryID
                LEFT JOIN Users u ON o.LeaderID = u.UserID
                WHERE o.Status = 0 
                  AND o.AuditorRole = 3
                ORDER BY o.CreateTime DESC
            ";
            DataTable dt = DbHelper.ExecuteQuery(sql);
            gvPending.DataSource = dt;
            gvPending.DataBind();
            pnlPendingEmpty.Visible = dt.Rows.Count == 0;
        }

        // 加载已通过院级组织
        private void LoadOrgList()
        {
            string sql = @"
                SELECT 
                    o.OrgID, 
                    o.OrgName, 
                    ISNULL(c.CategoryName, '未知类型') AS CategoryName, 
                    ISNULL(u.UserName, '暂无') AS LeaderName,
                    o.ContactInfo,
                    (SELECT COUNT(*) FROM OrgMembers m WHERE m.OrgID = o.OrgID AND m.Status=1) AS MemberCount
                FROM Organizations o
                LEFT JOIN OrgCategories c ON o.CategoryID = c.CategoryID
                LEFT JOIN Users u ON o.LeaderID = u.UserID
                WHERE o.Status = 1 
                  AND o.AuditorRole = 3
                ORDER BY o.OrgName
            ";
            DataTable dt = DbHelper.ExecuteQuery(sql);
            gvOrgList.DataSource = dt;
            gvOrgList.DataBind();
        }

        // 加载解散申请
        private void LoadDisbandList()
        {
            string sql = @"
                SELECT r.RequestID, o.OrgName, 
                       ISNULL(u.UserName, '暂无') AS LeaderName, 
                       r.Reason, r.CreateTime
                FROM OrgDisbandRequests r
                LEFT JOIN Organizations o ON r.OrgID = o.OrgID
                LEFT JOIN Users u ON r.RequestUserID = u.UserID
                WHERE r.Status = 0
                  AND o.AuditorRole = 3
                ORDER BY r.CreateTime DESC
            ";
            DataTable dt = DbHelper.ExecuteQuery(sql);
            gvDisband.DataSource = dt;
            gvDisband.DataBind();
            pnlDisbandEmpty.Visible = dt.Rows.Count == 0;
        }

        // ===== 【新增】WebMethod: 通过AJAX获取组织成员数据，无整页刷新 =====
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string GetOrgMembers(int orgId)
        {
            try
            {
                string sql = @"
                    SELECT u.StudentNo, u.UserName, u.College, m.MemberRole, 
                           CONVERT(NVARCHAR(10), m.JoinDate, 23) AS JoinDate
                    FROM OrgMembers m
                    LEFT JOIN Users u ON m.UserID = u.UserID
                    WHERE m.OrgID = @OrgID AND m.Status = 1
                    ORDER BY m.MemberRole DESC, m.JoinDate ASC
                ";
                DataTable dt = DbHelper.ExecuteQuery(sql, new SqlParameter("@OrgID", orgId));

                StringBuilder json = new StringBuilder();
                json.Append("[");

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    DataRow row = dt.Rows[i];
                    if (json.Length > 1) json.Append(",");

                    json.Append("{");
                    json.AppendFormat("\"StudentNo\":\"{0}\"", EscapeJson(row["StudentNo"]));
                    json.AppendFormat(",\"UserName\":\"{0}\"", EscapeJson(row["UserName"]));
                    json.AppendFormat(",\"College\":\"{0}\"", EscapeJson(row["College"]));
                    json.AppendFormat(",\"MemberRole\":{0}", row["MemberRole"]);
                    json.AppendFormat(",\"JoinDate\":\"{0}\"", EscapeJson(row["JoinDate"]));
                    json.Append("}");
                }

                json.Append("]");
                return json.ToString();
            }
            catch
            {
                return "[]";
            }
        }

        // 辅助：JSON字符串转义
        private static string EscapeJson(object value)
        {
            if (value == null || value == DBNull.Value)
                return "";
            return value.ToString()
                .Replace("\\", "\\\\")
                .Replace("\"", "\\\"")
                .Replace("\n", "\\n")
                .Replace("\r", "\\r")
                .Replace("\t", "\\t");
        }

        // 审核：通过/驳回
        protected void DoAudit(object sender, EventArgs e)
        {
            try
            {
                int orgID = int.Parse(hfOrgID.Value);
                string act = hfAction.Value;
                bool ok = act == "approve";

                bool res = OrgBLL.ApproveOrg(orgID, ok, "院级管理员审核", Utils.GetCurrentUserId());

                string msg = res ? "审核成功！" : "操作失败！";
                ClientScript.RegisterStartupScript(this.GetType(), "toast",
                    "showToast('" + HttpUtility.JavaScriptStringEncode(msg) + "', " + res.ToString().ToLower() + ");", true);

                LoadAllData(); // 刷新所有数据
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "toast",
                    "showToast('" + HttpUtility.JavaScriptStringEncode("审核异常：" + ex.Message) + "', false);", true);
            }
        }

        // 解散审核
        protected void DoDisbandAudit(object sender, EventArgs e)
        {
            int rid = int.Parse(hfRequestID.Value);
            string act = hfAction.Value;
            bool ok = act == "approveDisband";
            string msg = "";
            bool res = false;

            try
            {
                if (ok)
                {
                    string sql = @"
                        DECLARE @OrgID INT;
                        SELECT @OrgID = OrgID FROM OrgDisbandRequests WHERE RequestID = @rid;

                        UPDATE OrgDisbandRequests SET Status=1 WHERE RequestID=@rid;
                        DELETE FROM ActivityEnrollments WHERE ActivityID IN (SELECT ActivityID FROM Activities WHERE OrgID=@OrgID);
                        DELETE FROM Activities WHERE OrgID=@OrgID;
                        DELETE FROM Applications WHERE OrgID=@OrgID;
                        DELETE FROM Recruitments WHERE OrgID=@OrgID;
                        DELETE FROM OrgMembers WHERE OrgID=@OrgID;
                        DELETE FROM OrgFavorites WHERE OrgID=@OrgID;
                        DELETE FROM VenueReservations WHERE OrgID=@OrgID;
                        DELETE FROM Organizations WHERE OrgID=@OrgID;
                    ";
                    DbHelper.ExecuteNonQuery(sql, new SqlParameter("@rid", rid));
                    msg = "解散申请已同意，组织已删除";
                }
                else
                {
                    string sql = "UPDATE OrgDisbandRequests SET Status=2 WHERE RequestID=@rid";
                    DbHelper.ExecuteNonQuery(sql, new SqlParameter("@rid", rid));
                    msg = "解散申请已拒绝";
                }
                res = true;
            }
            catch (Exception ex)
            {
                msg = "操作失败：" + ex.Message;
            }

            ClientScript.RegisterStartupScript(this.GetType(), "toast",
                "showToast('" + HttpUtility.JavaScriptStringEncode(msg) + "', " + res.ToString().ToLower() + ");", true);

            LoadAllData(); // 刷新所有数据
        }

        // ===== 【新增】解散申请表格行绑定事件（截断过长的解散原因） =====
        protected void gvDisband_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // 限制解散原因显示长度
                if (e.Row.Cells.Count > 3)
                {
                    string reason = e.Row.Cells[3].Text;
                    if (reason.Length > 20)
                    {
                        e.Row.Cells[3].Text = reason.Substring(0, 20) + "...";
                        e.Row.Cells[3].ToolTip = reason;
                    }
                }
            }
        }

        // 删除组织
        protected void DeleteOrg_Click(object sender, EventArgs e)
        {
            int orgId = int.Parse(hfDeleteOrgID.Value);
            string reason = txtDeleteReason.Text.Trim();
            bool success = false;
            string msg = "";

            try
            {
                string logSql = @"
                    INSERT INTO OrgDeleteLogs (OrgID, OrgName, DeleteReason, DeleteBy)
                    SELECT @OrgID, OrgName, @Reason, @UserID FROM Organizations WHERE OrgID = @OrgID
                ";
                SqlParameter[] logParams = {
                    new SqlParameter("@OrgID", orgId),
                    new SqlParameter("@Reason", reason),
                    new SqlParameter("@UserID", Utils.GetCurrentUserId())
                };
                DbHelper.ExecuteNonQuery(logSql, logParams);

                string deleteSql = @"
                    DELETE FROM ActivityEnrollments WHERE ActivityID IN (SELECT ActivityID FROM Activities WHERE OrgID = @OrgID);
                    DELETE FROM Activities WHERE OrgID = @OrgID;
                    DELETE FROM Applications WHERE OrgID = @OrgID;
                    DELETE FROM Recruitments WHERE OrgID = @OrgID;
                    DELETE FROM OrgMembers WHERE OrgID = @OrgID;
                    DELETE FROM OrgFavorites WHERE OrgID = @OrgID;
                    DELETE FROM VenueReservations WHERE OrgID = @OrgID;
                    DELETE FROM OrgDisbandRequests WHERE OrgID = @OrgID;
                    DELETE FROM Organizations WHERE OrgID = @OrgID;
                ";
                DbHelper.ExecuteNonQuery(deleteSql, new SqlParameter("@OrgID", orgId));

                success = true;
                msg = "删除成功";
            }
            catch (Exception ex)
            {
                msg = "删除失败：" + ex.Message;
            }

            ClientScript.RegisterStartupScript(this.GetType(), "toast",
                "showToast('" + HttpUtility.JavaScriptStringEncode(msg) + "', " + success.ToString().ToLower() + ");", true);

            LoadAllData(); // 刷新所有数据
        }

        // ===== 处理来自客户端的降级PostBack请求 =====
        protected override void RaisePostBackEvent(IPostBackEventHandler source, string eventArgument)
        {
            // 处理刷新请求
            if (eventArgument == "RefreshAll")
            {
                LoadAllData();
                return;
            }

            // 成员查看降级方案：重新加载页面
            if (eventArgument != null && eventArgument.StartsWith("ShowMembers|"))
            {
                // PageMethods不可用时的降级：整页刷新
                Response.Redirect(Request.RawUrl);
                return;
            }

            base.RaisePostBackEvent(source, eventArgument);
        }
    }
}
