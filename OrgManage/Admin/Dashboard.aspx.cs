using System;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Text;
using OrgManage.APP_Code;
using System.Linq; 

namespace OrgManage
{
    public partial class Admin_Dashboard : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Utils.RequireLogin();
            Utils.RequireRole(5);
            if (!IsPostBack)
            {
                LoadStats();
                LoadOrganizations();
                LoadUsers();
                LoadActivities();
                LoadAnnouncements();
                LoadOperationLogs();
                LoadAppeals();
                LoadFeedbacks();
                LoadSystemConfigInfo();
                LoadInviteKeys();
            }
        }

        #region 系统名称 + LOGO配置
        private void LoadSystemConfigInfo()
        {
            var dt = Utils.GetDataTable("SELECT ConfigKey,ConfigValue FROM SystemConfig WHERE ConfigKey IN('SystemName','SystemLogo')");
            if (dt == null || dt.Rows.Count == 0) return;

            foreach (System.Data.DataRow row in dt.Rows)
            {
                string k = row["ConfigKey"].ToString();
                string v = row["ConfigValue"].ToString();

                if (k == "SystemName")
                    txtSystemName.Text = v;

                if (k == "SystemLogo")
                    imgCurrentLogo.ImageUrl = ResolveUrl(v);
            }
        }

        protected void btnSaveName_Click(object sender, EventArgs e)
        {
            string name = txtSystemName.Text.Trim();
            if (string.IsNullOrEmpty(name))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "msg", "alert('系统名称不能为空！');", true);
                return;
            }

            Utils.ExecuteSql("UPDATE SystemConfig SET ConfigValue=@v WHERE ConfigKey='SystemName'",
                new SqlParameter("@v", name));

            WriteLog("UpdateSystemName", "System", 0, "修改系统名称为：" + name);
            ScriptManager.RegisterStartupScript(this, GetType(), "ok", "alert('保存成功！刷新页面生效');", true);
        }

        protected void btnUploadLogo_Click(object sender, EventArgs e)
        {
            if (!fuLogo.HasFile)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "msg", "alert('请选择图片！');", true);
                return;
            }

            string ext = System.IO.Path.GetExtension(fuLogo.FileName).ToLower();
            if (ext != ".png" && ext != ".jpg" && ext != ".jpeg")
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "msg", "alert('仅支持PNG/JPG！');", true);
                return;
            }

            if (fuLogo.PostedFile.ContentLength > 200 * 1024)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "msg", "alert('图片不能超过200KB！');", true);
                return;
            }

            // ==============================================
            // 自动删除旧LOGO文件
            // ==============================================
            try
            {
                object oldLogoObj = Utils.ExecuteScalar("SELECT ConfigValue FROM SystemConfig WHERE ConfigKey='SystemLogo'");
                if (oldLogoObj != null)
                {
                    string oldLogoPath = oldLogoObj.ToString();
                    if (!string.IsNullOrEmpty(oldLogoPath))
                    {
                        string fullOldPath = Server.MapPath(oldLogoPath);
                        if (System.IO.File.Exists(fullOldPath))
                        {
                            System.IO.File.Delete(fullOldPath); // 删除旧文件
                        }
                    }
                }
            }
            catch { }

            // 生成新LOGO（随机名字，不重复）
            string fileName = "logo_" + Guid.NewGuid().ToString("N").Substring(0, 8) + ext;
            string savePath = Server.MapPath("~/images/");
            if (!System.IO.Directory.Exists(savePath))
                System.IO.Directory.CreateDirectory(savePath);

            string fullPath = System.IO.Path.Combine(savePath, fileName);
            fuLogo.SaveAs(fullPath);

            string webPath = "/images/" + fileName;
            Utils.ExecuteSql("UPDATE SystemConfig SET ConfigValue=@v WHERE ConfigKey='SystemLogo'",
                new SqlParameter("@v", webPath));

            imgCurrentLogo.ImageUrl = ResolveUrl(webPath);
            WriteLog("UploadSystemLogo", "System", 0, "上传新LOGO：" + webPath);

            ScriptManager.RegisterStartupScript(this, GetType(), "ok", "alert('LOGO上传成功！刷新页面生效');", true);
        }
        #endregion
        #region 统计卡片
        private void LoadStats()
        {
            litUserCount.Text = Utils.ExecuteScalar("SELECT COUNT(1) FROM Users").ToString();
            litOrgCount.Text = Utils.ExecuteScalar("SELECT COUNT(1) FROM Organizations WHERE Status=1").ToString();
            litActCount.Text = Utils.ExecuteScalar("SELECT COUNT(1) FROM Activities WHERE Status IN (1,2,3)").ToString();
            litBanCount.Text = Utils.ExecuteScalar("SELECT COUNT(1) FROM Users WHERE IsActive=0").ToString();
        }
        #endregion

        #region 组织管理
        private void LoadOrganizations()
        {
            string sql = @"SELECT o.OrgID, o.OrgName, o.Status, c.CategoryName, u.UserName AS LeaderName 
                           FROM Organizations o 
                           LEFT JOIN OrgCategories c ON o.CategoryID = c.CategoryID 
                           LEFT JOIN Users u ON o.LeaderID = u.UserID";
            gvAllOrgs.DataSource = Utils.GetDataTable(sql);
            gvAllOrgs.DataBind();
        }

        protected void GvAllOrgs_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int orgId = Convert.ToInt32(e.CommandArgument);
            int adminId = Utils.GetCurrentUserId();
            if (e.CommandName == "DisableOrg")
            {
                OrgBLL.ApproveOrg(orgId, false, "系统管理员禁用", adminId);
                WriteLog("DisableOrg", "Org", orgId, string.Format("禁用组织ID {0}", orgId));
            }
            else if (e.CommandName == "EnableOrg")
            {
                OrgBLL.ApproveOrg(orgId, true, "系统管理员启用", adminId);
                WriteLog("EnableOrg", "Org", orgId, string.Format("启用组织ID {0}", orgId));
            }
            LoadOrganizations();
            LoadStats();
        }

        protected void BtnExportOrgs_Click(object sender, EventArgs e)
        {
            string sql = @"SELECT o.OrgName, c.CategoryName, u.UserName AS LeaderName, 
                           CASE o.Status WHEN 1 THEN '正常' ELSE '已禁用' END AS StatusName, 
                           CONVERT(VARCHAR(19), o.CreateTime, 120) AS CreateTime
                           FROM Organizations o 
                           LEFT JOIN OrgCategories c ON o.CategoryID = c.CategoryID 
                           LEFT JOIN Users u ON o.LeaderID = u.UserID";
            DataTable dt = Utils.GetDataTable(sql);
            ExportToCSV(dt, "组织报表.csv");
        }
        #endregion

        #region 用户管理
        private void LoadUsers(string keyword = "")
        {
            string sql = "SELECT UserID, StudentNo, UserName, Role, College, IsActive FROM Users WHERE 1=1";
            if (!string.IsNullOrEmpty(keyword))
            {
                sql += " AND (StudentNo LIKE @kw OR UserName LIKE @kw)";
                gvUsers.DataSource = Utils.GetDataTable(sql, new SqlParameter("@kw", "%" + keyword + "%"));
            }
            else
            {
                gvUsers.DataSource = Utils.GetDataTable(sql);
            }
            gvUsers.DataBind();
        }

        protected void BtnSearch_Click(object sender, EventArgs e)
        {
            LoadUsers(txtSearch.Text.Trim());
        }

        protected void GvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int uid = Convert.ToInt32(e.CommandArgument);
            bool enable = (e.CommandName == "Enable");
            UserBLL.SetUserActive(uid, enable);
            WriteLog(enable ? "EnableUser" : "DisableUser", "User", uid, (enable ? "启用" : "禁用") + string.Format("用户ID {0}", uid));
            LoadUsers(txtSearch.Text.Trim());
            LoadStats();
        }
        #endregion

        #region 活动管理
        private void LoadActivities()
        {
            string sql = @"SELECT a.ActivityID, a.Title, a.Status, a.StartTime, o.OrgName 
                           FROM Activities a 
                           LEFT JOIN Organizations o ON a.OrgID = o.OrgID 
                           ORDER BY a.CreateTime DESC";
            gvActivities.DataSource = Utils.GetDataTable(sql);
            gvActivities.DataBind();
        }

        protected void GvActivities_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int actId = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "CancelActivity")
            {
                ActivityBLL.CancelActivity(actId, "管理员强制取消");
                WriteLog("CancelActivity", "Activity", actId, string.Format("强制取消活动ID {0}", actId));
                LoadActivities();
            }
            else if (e.CommandName == "RestoreActivity")
            {
                ActivityBLL.RestoreActivity(actId);
                WriteLog("RestoreActivity", "Activity", actId, string.Format("恢复活动ID {0}", actId));
                LoadActivities();
            }
            else if (e.CommandName == "ViewEnrolls")
            {
                string sql = @"SELECT u.UserName, u.StudentNo, ae.EnrollTime 
                               FROM ActivityEnrollments ae 
                               JOIN Users u ON ae.UserID = u.UserID 
                               WHERE ae.ActivityID = @aid AND ae.Status = 1";
                DataTable dt = Utils.GetDataTable(sql, new SqlParameter("@aid", actId));
                StringBuilder msg = new StringBuilder("报名名单：\\n");
                foreach (DataRow row in dt.Rows)
                {
                    msg.AppendFormat("{0} - {1} ({2})\\n", row["StudentNo"], row["UserName"], row["EnrollTime"]);
                }
                string js = "alert('" + HttpUtility.JavaScriptStringEncode(msg.ToString()) + "');";
                ScriptManager.RegisterStartupScript(this.Page, GetType(), "alert", js, true);
            }
        }

        protected void BtnExportActivities_Click(object sender, EventArgs e)
        {
            string sql = @"SELECT a.Title, o.OrgName, CONVERT(VARCHAR(19), a.StartTime, 120) AS StartTime, 
                           CASE a.Status 
                               WHEN 0 THEN '待审批' WHEN 1 THEN '已发布' WHEN 2 THEN '进行中' 
                               WHEN 3 THEN '已结束' WHEN 4 THEN '已取消' ELSE '未知' 
                           END AS StatusName
                           FROM Activities a LEFT JOIN Organizations o ON a.OrgID = o.OrgID";
            DataTable dt = Utils.GetDataTable(sql);
            ExportToCSV(dt, "活动报表.csv");
        }

        public string GetActivityStatus(int status)
        {
            switch (status)
            {
                case 0: return "待审批";
                case 1: return "已发布";
                case 2: return "进行中";
                case 3: return "已结束";
                case 4: return "已取消";
                case 5: return "审批拒绝";
                default: return "未知";
            }
        }

        public int GetEnrollCount(int actId)
        {
            object result = Utils.ExecuteScalar("SELECT COUNT(1) FROM ActivityEnrollments WHERE ActivityID=@aid AND Status=1", new SqlParameter("@aid", actId));
            return Convert.ToInt32(result);
        }
        #endregion

        #region 系统公告管理
        private void LoadAnnouncements()
        {
            string sql = @"SELECT a.AnnID, a.Title, a.Content, a.CreateTime, u.UserName AS PublishByName 
                           FROM Announcements a 
                           JOIN Users u ON a.PublishBy = u.UserID 
                           ORDER BY a.CreateTime DESC";
            gvAnnouncements.DataSource = Utils.GetDataTable(sql);
            gvAnnouncements.DataBind();
        }

        protected void BtnAddAnn_Click(object sender, EventArgs e)
        {
            string title = txtAnnTitle.Text.Trim();
            string content = txtAnnContent.Text.Trim();
            if (!string.IsNullOrEmpty(title) && !string.IsNullOrEmpty(content))
            {
                int uid = Utils.GetCurrentUserId();
                string sql = "INSERT INTO Announcements(Title, Content, PublishBy, CreateTime) VALUES(@title, @content, @uid, GETDATE())";
                Utils.ExecuteSql(sql,
                    new SqlParameter("@title", title),
                    new SqlParameter("@content", content),
                    new SqlParameter("@uid", uid));
                WriteLog("AddAnnouncement", "Announcement", 0, string.Format("发布公告：{0}", title));
                LoadAnnouncements();
                txtAnnTitle.Text = "";
                txtAnnContent.Text = "";
            }
        }

        protected void GvAnnouncements_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteAnn")
            {
                int annId = Convert.ToInt32(e.CommandArgument);
                Utils.ExecuteSql("DELETE FROM Announcements WHERE AnnID=@id", new SqlParameter("@id", annId));
                WriteLog("DeleteAnnouncement", "Announcement", annId, "删除公告");
                LoadAnnouncements();
            }
        }
        #endregion

        

        #region 操作日志
        private void LoadOperationLogs()
        {
            string sql = "SELECT * FROM OperationLogs ORDER BY LogTime DESC";
            gvOperationLogs.DataSource = Utils.GetDataTable(sql);
            gvOperationLogs.DataBind();
        }

        protected void BtnClearLogs_Click(object sender, EventArgs e)
        {
            Utils.ExecuteSql("DELETE FROM OperationLogs WHERE LogTime < DATEADD(day, -30, GETDATE())");
            WriteLog("ClearLogs", "System", 0, "清空30天前操作日志");
            LoadOperationLogs();
        }

        protected void GvOperationLogs_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvOperationLogs.PageIndex = e.NewPageIndex;
            LoadOperationLogs();
        }

        private string GetClientIP()
        {
            // 优先取 X-Forwarded-For（有反向代理时携带真实IP）
            string forwarded = Request.Headers["X-Forwarded-For"];
            if (!string.IsNullOrEmpty(forwarded))
            {
                string[] parts = forwarded.Split(',');
                string ip = parts[0].Trim();
                if (!string.IsNullOrEmpty(ip)) return ip;
            }
            string userHost = Request.UserHostAddress;
            // 将 ::1 (IPv6 localhost) 转为 127.0.0.1 更直观
            if (userHost == "::1") return "127.0.0.1";
            return userHost;
        }

        private void WriteLog(string action, string targetType, int targetId, string detail)
        {
            int uid = Utils.GetCurrentUserId();
            string name = Utils.GetString(Utils.ExecuteScalar("SELECT UserName FROM Users WHERE UserID=@uid", new SqlParameter("@uid", uid)));
            string ip = GetClientIP();
            string sql = @"INSERT INTO OperationLogs(OperatorID, OperatorName, ActionType, TargetType, TargetID, Detail, IPAddress, LogTime) 
                           VALUES(@uid, @name, @action, @targetType, @targetId, @detail, @ip, GETDATE())";
            Utils.ExecuteSql(sql,
                new SqlParameter("@uid", uid),
                new SqlParameter("@name", name),
                new SqlParameter("@action", action),
                new SqlParameter("@targetType", targetType),
                new SqlParameter("@targetId", targetId),
                new SqlParameter("@detail", detail),
                new SqlParameter("@ip", ip));
        }
        #endregion

        #region 批量导入导出 / 备份
        protected void BtnImportUsers_Click(object sender, EventArgs e)
        {
            if (!fuUserImport.HasFile)
            {
                lblImportResult.Text = "请选择文件";
                return;
            }
            string ext = Path.GetExtension(fuUserImport.FileName);
            if (ext != ".csv")
            {
                lblImportResult.Text = "仅支持CSV文件";
                return;
            }
            StreamReader sr = new StreamReader(fuUserImport.FileContent, Encoding.Default);
            string line;
            int success = 0, fail = 0;
            while ((line = sr.ReadLine()) != null)
            {
                string[] parts = line.Split(',');
                if (parts.Length >= 6)
                {
                    try
                    {
                        string studentNo = parts[0].Trim('"');
                        string userName = parts[1].Trim('"');
                        string loginName = parts[2].Trim('"');
                        string pwd = parts[3].Trim('"');
                        int role = int.Parse(parts[4]);
                        string college = parts[5].Trim('"');
                        string pwdHash = Utils.HashPassword(pwd);
                        string sql = @"INSERT INTO Users(StudentNo, UserName, LoginName, PasswordHash, Role, College, IsActive) 
                                       VALUES(@sno, @uname, @login, @pwd, @role, @college, 1)";
                        Utils.ExecuteSql(sql,
                            new SqlParameter("@sno", studentNo),
                            new SqlParameter("@uname", userName),
                            new SqlParameter("@login", loginName),
                            new SqlParameter("@pwd", pwdHash),
                            new SqlParameter("@role", role),
                            new SqlParameter("@college", college));
                        success++;
                    }
                    catch { fail++; }
                }
                else fail++;
            }
            sr.Close();
            lblImportResult.Text = string.Format("导入完成：成功{0}，失败{1}", success, fail);
            LoadUsers();
            LoadStats();
        }

        protected void BtnExportUsers_Click(object sender, EventArgs e)
        {
            DataTable dt = Utils.GetDataTable("SELECT StudentNo, UserName, Role, College, IsActive FROM Users");
            ExportToCSV(dt, "全部用户.csv");
        }

        protected void BtnBackupAll_Click(object sender, EventArgs e)
        {
            string path = Server.MapPath("~/Backup/");
            if (!Directory.Exists(path))
                Directory.CreateDirectory(path);
            DataTable dtUsers = Utils.GetDataTable("SELECT * FROM Users");
            DataTable dtOrgs = Utils.GetDataTable("SELECT * FROM Organizations");
            DataTable dtActs = Utils.GetDataTable("SELECT * FROM Activities");
            SaveDataTableToCSV(dtUsers, Path.Combine(path, "Users.csv"));
            SaveDataTableToCSV(dtOrgs, Path.Combine(path, "Orgs.csv"));
            SaveDataTableToCSV(dtActs, Path.Combine(path, "Activities.csv"));
            string fileName = string.Format("backup_{0}.zip", DateTime.Now.ToString("yyyyMMddHHmmss"));
            string logSql = "INSERT INTO BackupRecords(BackupType, FileName, FilePath, OperatorID, BackupTime) VALUES('FullData', @fname, @fpath, @op, GETDATE())";
            Utils.ExecuteSql(logSql,
                new SqlParameter("@fname", fileName),
                new SqlParameter("@fpath", path),
                new SqlParameter("@op", Utils.GetCurrentUserId()));
            lblBackupMsg.Text = "备份已生成 (Backup文件夹下)";
        }

        private void ExportToCSV(DataTable dt, string filename)
        {
            Response.Clear();
            Response.Buffer = true;
            Response.ContentType = "application/octet-stream";
            Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", filename));
            Response.ContentEncoding = Encoding.UTF8;
            // 输出UTF-8 BOM，让Excel直接识别为UTF-8，避免乱码
            Response.BinaryWrite(new byte[] { 0xEF, 0xBB, 0xBF });

            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                sb.AppendFormat("\"{0}\"", dt.Columns[i].ColumnName.Replace("\"", "\"\""));
                if (i != dt.Columns.Count - 1) sb.Append(",");
                else sb.Append("\r\n");
            }
            foreach (DataRow row in dt.Rows)
            {
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    string val = row[i].ToString().Replace("\"", "\"\"");
                    sb.AppendFormat("\"{0}\"", val);
                    if (i != dt.Columns.Count - 1) sb.Append(",");
                    else sb.Append("\r\n");
                }
            }
            Response.Write(sb.ToString());
            Response.End();
        }

        private void SaveDataTableToCSV(DataTable dt, string filePath)
        {
            using (StreamWriter sw = new StreamWriter(filePath, false, Encoding.UTF8))
            {
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    sw.Write(dt.Columns[i].ColumnName);
                    if (i != dt.Columns.Count - 1) sw.Write(",");
                    else sw.Write("\n");
                }
                foreach (DataRow row in dt.Rows)
                {
                    for (int i = 0; i < dt.Columns.Count; i++)
                    {
                        string val = row[i].ToString().Replace(",", "，");
                        sw.Write(val);
                        if (i != dt.Columns.Count - 1) sw.Write(",");
                        else sw.Write("\n");
                    }
                }
                sw.Flush();
            }
        }
        #endregion

        #region 申诉反馈
        private void LoadAppeals()
        {
            string sql = @"SELECT a.AppealID, a.Content, a.Status, u.UserName 
                           FROM UserAppeals a 
                           JOIN Users u ON a.UserID = u.UserID 
                           ORDER BY a.CreateTime DESC";
            gvAppeals.DataSource = Utils.GetDataTable(sql);
            gvAppeals.DataBind();
        }

        protected void GvAppeals_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int appealId = Convert.ToInt32(e.CommandArgument);
            GridViewRow row = (GridViewRow)((LinkButton)e.CommandSource).NamingContainer;
            TextBox txtReply = (TextBox)row.FindControl("txtReply");
            string reply = (txtReply != null) ? txtReply.Text : "";
            int status = (e.CommandName == "HandleAppeal") ? 1 : 2;
            int adminId = Utils.GetCurrentUserId();
            // 修复原SQL语法错误（缺少等号）
            string sql = "UPDATE UserAppeals SET Status=@status, ReplyContent=@reply, HandleBy=@admin, HandleTime=GETDATE() WHERE AppealID=@id";
            Utils.ExecuteSql(sql,
                new SqlParameter("@status", status),
                new SqlParameter("@reply", reply),
                new SqlParameter("@admin", adminId),
                new SqlParameter("@id", appealId));
            WriteLog("HandleAppeal", "Appeal", appealId, string.Format("处理申诉，结果：{0}", (status == 1 ? "通过" : "驳回")));
            LoadAppeals();
        }

        private void LoadFeedbacks()
        {
            string sql = @"SELECT f.FeedbackID, f.Type, f.Content, f.Contact, f.Status, f.CreateTime, u.UserName 
                           FROM Feedbacks f 
                           JOIN Users u ON f.UserID = u.UserID 
                           ORDER BY f.CreateTime DESC";
            gvFeedbacks.DataSource = Utils.GetDataTable(sql);
            gvFeedbacks.DataBind();
        }

        protected void GvFeedbacks_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "MarkRead")
            {
                int fid = Convert.ToInt32(e.CommandArgument);
                Utils.ExecuteSql("UPDATE Feedbacks SET Status=1 WHERE FeedbackID=@id", new SqlParameter("@id", fid));
                LoadFeedbacks();
            }
        }

        public string GetAppealStatus(int status)
        {
            if (status == 0) return "待处理";
            if (status == 1) return "已通过";
            return "已驳回";
        }
        #endregion

        public string GetRoleName(int role)
        {
            return Utils.GetRoleName(role);
        }

        #region 邀请密钥生成
        /// <summary>
        /// 生成8位随机字母数字密钥，确保不重复
        /// </summary>
        private string GenerateUniqueInviteKey()
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            Random rnd = new Random();
            char[] result = new char[8];
            string key;
            do
            {
                for (int i = 0; i < 8; i++)
                {
                    result[i] = chars[rnd.Next(chars.Length)];
                }
                key = new string(result);
            } while (Utils.ExecuteScalar("SELECT COUNT(1) FROM InviteKeys WHERE KeyCode=@key", new SqlParameter("@key", key)).ToString() != "0");
            return key;
        }

        /// <summary>
        /// 加载邀请密钥列表
        /// </summary>
        private void LoadInviteKeys()
        {
            // 注意：这里的字段名必须和数据库一致，叫 TargetRole
            string sql = @"SELECT KeyCode, TargetRole, IsUsed, CreatedTime, ExpireDate, UsedTime 
                   FROM InviteKeys 
                   ORDER BY CreatedTime DESC";
            gvInviteKeys.DataSource = Utils.GetDataTable(sql);
            gvInviteKeys.DataBind();
        }

        /// <summary>
        /// 角色名称转换
        /// </summary>

        /// <summary>
        /// 生成密钥按钮点击事件
        /// </summary>
        protected void BtnGenerateKey_Click(object sender, EventArgs e)
        {
            int role = Convert.ToInt32(ddlKeyRole.SelectedValue);
            string keyCode = GenerateUniqueInviteKey();
            int createdBy = Utils.GetCurrentUserId();

            string sql = @"INSERT INTO InviteKeys(KeyCode, TargetRole, CreatedBy, CreatedTime, ExpireDate) 
                   VALUES(@key, @role, @createdBy, GETDATE(), DATEADD(DAY,7,GETDATE()))";
            Utils.ExecuteSql(sql,
                new SqlParameter("@key", keyCode),
                new SqlParameter("@role", role),
                new SqlParameter("@createdBy", createdBy));

            txtNewKey.Text = keyCode;
            LoadInviteKeys();
            WriteLog("GenerateInviteKey", "System", 0, string.Format("生成邀请密钥：{0}，角色：{1}", keyCode, role));
        }
        #endregion
    }
}
