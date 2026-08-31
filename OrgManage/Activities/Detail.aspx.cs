using System;
using System.Data;
using System.Web.UI;
using OrgManage.APP_Code;

namespace OrgManage
{
    /// <summary>
    /// 活动详情页
    /// 功能：展示活动信息、权限校验、报名/取消报名、查看报名名单
    /// </summary>
    public partial class Activities_Detail : Page
    {
        private int _actID; // 当前活动ID

        /// <summary>
        /// 页面加载：获取活动ID，加载数据
        /// </summary>
        protected void Page_Load(object sender, EventArgs e)
        {
            // 从URL获取活动ID，校验合法性
            if (!int.TryParse(Request.QueryString["id"], out _actID))
            { ShowNotFound(); return; }

            if (!IsPostBack) LoadData();
        }

        /// <summary>
        /// 加载活动详情 + 权限校验 + 界面控制（核心方法）
        /// 1. 展示活动基本信息
        /// 2. 校验用户登录状态
        /// 3. 校验活动报名权限（全员/本组织/本学院）
        /// 4. 控制报名/取消按钮显示
        /// 5. 管理员可查看报名名单
        /// </summary>
        private void LoadData()
        {
            // 获取活动详情
            var row = ActivityBLL.GetActivityDetail(_actID);
            if (row == null) { ShowNotFound(); return; }

            // 绑定活动信息到页面
            litTitle.Text = Utils.HtmlEncode(row["Title"].ToString());
            litDescription.Text = Utils.HtmlEncode(row["Description"].ToString()).Replace("\n", "<br/>");
            litStartTime.Text = Convert.ToDateTime(row["StartTime"]).ToString("yyyy-MM-dd HH:mm");
            litEndTime.Text = Convert.ToDateTime(row["EndTime"]).ToString("yyyy-MM-dd HH:mm");

            // 已登录用户处理
            if (Utils.IsAuthenticated())
            {
                int userID = Utils.GetCurrentUserId();
                int role = Utils.GetCurrentUserRole();
                bool isEnrolled = ActivityBLL.IsEnrolled(_actID, userID);

                // 控制按钮状态：已报名/未报名
                panelEnrolled.Visible = isEnrolled;
                btnEnroll.Visible = !isEnrolled;
                btnCancel.Visible = isEnrolled;

                // 校验报名权限：仅限本组织 / 仅限本学院
                bool canEnroll = true;
                int scope = Convert.ToInt32(row["ParticipationScope"]);
                int orgId = Convert.ToInt32(row["OrgID"]);

                if (scope == 1) // 仅限本组织成员
                {
                    canEnroll = OrgBLL.IsMember(orgId, userID);
                }
                else if (scope == 2) // 仅限本学院学生
                {
                    string orgCollege = OrgBLL.GetOrgCollege(orgId);
                    string userCollege = UserBLL.GetUserCollege(userID);
                    canEnroll = !string.IsNullOrEmpty(orgCollege) && !string.IsNullOrEmpty(userCollege) && orgCollege == userCollege;
                }

                // 无权限则禁用报名按钮
                if (!canEnroll)
                {
                    btnEnroll.Enabled = false;
                    btnEnroll.Text = "无法报名";
                    panelMsg.Visible = true;
                }

                // 管理员/社长 可见报名名单
                if (role >= 2)
                {
                    panelEnrollList.Visible = true;
                    gvEnrolls.DataSource = ActivityBLL.GetActivityEnrollments(_actID);
                    gvEnrolls.DataBind();
                }
            }
            else
            {
                // 未登录：隐藏操作按钮，显示登录提示
                btnEnroll.Visible = false;
                hlLogin.Visible = true;
            }
        }

        /// <summary>
        /// 报名活动按钮
        /// 1. 校验登录
        /// 2. 后端二次校验报名权限（防止前端绕过）
        /// 3. 执行报名
        /// 4. 刷新页面
        /// </summary>
        protected void BtnEnroll_Click(object sender, EventArgs e)
        {
            Utils.RequireLogin();
            int userID = Utils.GetCurrentUserId();
            var row = ActivityBLL.GetActivityDetail(_actID);

            // 后端二次权限校验
            int scope = Convert.ToInt32(row["ParticipationScope"]);
            int orgId = Convert.ToInt32(row["OrgID"]);
            bool canEnroll = true;

            if (scope == 1) canEnroll = OrgBLL.IsMember(orgId, userID);
            if (scope == 2)
            {
                string orgCollege = OrgBLL.GetOrgCollege(orgId);
                string userCollege = UserBLL.GetUserCollege(userID);
                canEnroll = orgCollege == userCollege;
            }

            if (!canEnroll) { litMsg.Text = "您没有权限报名此活动！"; return; }

            // 执行报名并刷新
            bool ok = ActivityBLL.Enroll(_actID, userID);
            if (ok) Response.Redirect(Request.RawUrl);
        }

        /// <summary>
        /// 取消报名按钮
        /// </summary>
        protected void BtnCancel_Click(object sender, EventArgs e)
        {
            Utils.RequireLogin();
            ActivityBLL.CancelEnroll(_actID, Utils.GetCurrentUserId());
            Response.Redirect(Request.RawUrl);
        }

        /// <summary>
        /// 显示404错误页面
        /// </summary>
        private void ShowNotFound() { panelNotFound.Visible = true; panelMain.Visible = false; }
    }
}