using System;
using System.Data;
using System.Web.UI;
using OrgManage.APP_Code;
using System.IO;
using System.Web.Services;

namespace OrgManage
{
    /// <summary>
    /// 个人中心页面
    /// 功能：展示用户信息、修改资料、修改密码、头像上传、查看我的组织/活动/消息
    /// </summary>
    public partial class Account_MyCenter : Page
    {
        /// <summary>
        /// 页面加载
        /// 1. 检查是否登录（未登录则拦截）
        /// 2. 首次加载时加载用户数据和消息
        /// </summary>
        protected void Page_Load(object sender, EventArgs e)
        {
            // 登录验证：必须登录才能访问
            Utils.RequireLogin();

            if (!IsPostBack)
            {
                LoadData();      // 加载用户基础信息、我的组织、活动等
                LoadMessages(); // 加载系统消息
            }
        }

        /// <summary>
        /// 获取活动状态文本（供前台绑定调用）
        /// </summary>
        public string GetActivityStatus(int status)
        {
            return Utils.GetActivityStatusName(status);
        }

        /// <summary>
        /// 加载个人中心所有数据
        /// 包括：用户信息、头像、我的组织、我的活动、招新记录、我的收藏
        /// </summary>
        private void LoadData()
        {
            int uid = Utils.GetCurrentUserId();
            DataRow user = UserBLL.GetUser(uid);

            // 用户不存在则退出登录
            if (user == null) { Response.Redirect("~/Account/Logout.aspx"); return; }

            // ========== 头像显示逻辑：有头像则显示图片，无头像则显示名字首字 ==========
            string avatarUrl = user["AvatarUrl"] != DBNull.Value ? user["AvatarUrl"].ToString() : "";
            if (!string.IsNullOrEmpty(avatarUrl))
            {
                imgAvatar.ImageUrl = avatarUrl;
                imgAvatar.Visible = true;
                litAvatarText.Visible = false;
            }
            else
            {
                litAvatarText.Text = user["UserName"].ToString().Substring(0, 1);
                imgAvatar.Visible = false;
                litAvatarText.Visible = true;
            }

            // 绑定用户基本信息到页面
            litUserName.Text = Utils.HtmlEncode(user["UserName"].ToString());
            litStudentNo.Text = user["StudentNo"].ToString();
            litRole.Text = Utils.GetRoleName(Convert.ToInt32(user["Role"]));

            // 绑定信息到修改资料表单
            txtStudentNo.Text = user["StudentNo"].ToString();
            txtRealName.Text = user["UserName"].ToString();
            txtEmail.Text = user["Email"] == DBNull.Value ? "" : user["Email"].ToString();
            txtPhone.Text = user["Phone"] == DBNull.Value ? "" : user["Phone"].ToString();
            txtCollege.Text = user["College"] == DBNull.Value ? "" : user["College"].ToString();

            // 绑定【我的组织】列表
            var orgs = OrgBLL.GetMyJoinedOrgs(uid);
            rptMyOrgs.DataSource = orgs;
            rptMyOrgs.DataBind();
            panelNoOrg.Visible = orgs.Rows.Count == 0;

            // 绑定【我的活动】列表
            var acts = ActivityBLL.GetMyEnrolledActivities(uid);
            rptMyActivities.DataSource = acts;
            rptMyActivities.DataBind();
            panelNoAct.Visible = acts.Rows.Count == 0;
            //=========【招新记录绑定：直接SQL查询】=========
            string sqlApp = @"
SELECT ra.*,o.OrgName,r.Title
FROM RecruitApps ra
LEFT JOIN Organizations o ON ra.OrgID = o.OrgID
LEFT JOIN Recruitments r ON ra.RecruitID = r.RecruitID
WHERE ra.UserID=@UID
ORDER BY ra.ApplyTime DESC";
            DataTable dtApp = DbHelper.ExecuteQuery(sqlApp, new System.Data.SqlClient.SqlParameter("@UID", uid));
            rptMyApplies.DataSource = dtApp;
            rptMyApplies.DataBind();
            panelNoApply.Visible = dtApp.Rows.Count == 0;

            // 绑定【我的收藏】列表
            var favs = OrgBLL.GetMyFavorites(uid);
            rptFavorites.DataSource = favs;
            rptFavorites.DataBind();
            panelNoFav.Visible = favs.Rows.Count == 0;
        }

        /// <summary>
        /// 加载系统消息
        /// 1. 查询当前用户所有消息并展示
        /// 2. 计算未读消息数量，更新角标
        /// </summary>
        private void LoadMessages()
        {
            int uid = Utils.GetCurrentUserId();
            var msgs = MessageBLL.GetUserMessages(uid);
            rptMessages.DataSource = msgs;
            rptMessages.DataBind();

            // 更新未读消息数量（前端JS显示）
            int unreadCount = MessageBLL.GetUnreadCount(uid);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "updateBadge",
                string.Format("document.getElementById('msgBadge').innerText = {0};", unreadCount), true);
        }

        /// <summary>
        /// 保存修改资料（邮箱、手机、学院）
        /// </summary>
        protected void BtnSaveProfile_Click(object sender, EventArgs e)
        {
            int uid = Utils.GetCurrentUserId();
            UserBLL.UpdateProfile(uid, txtEmail.Text.Trim(), txtPhone.Text.Trim(), txtCollege.Text.Trim());
            panelProfileMsg.Visible = true; // 显示成功提示
        }

        /// <summary>
        /// 修改密码
        /// 验证原密码正确性，正确则更新为新密码
        /// </summary>
        protected void BtnChangePwd_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int uid = Utils.GetCurrentUserId();
            bool isSuccess = UserBLL.ChangePassword(uid, txtOldPwd.Text, txtNewPwd.Text);

            panelPwdMsg.Visible = true;
            if (isSuccess)
            {
                panelPwdMsg.CssClass = "alert alert-success small";
                panelPwdMsg.Controls.Add(new LiteralControl("密码修改成功！"));
                // 清空输入框
                txtOldPwd.Text = txtNewPwd.Text = txtConfirmPwd.Text = "";
            }
            else
            {
                panelPwdMsg.CssClass = "alert alert-danger small";
                panelPwdMsg.Controls.Add(new LiteralControl("当前密码不正确，请重试。"));
            }
        }

        #region 消息操作（Ajax 静态方法）
        /// <summary>
        /// 标记单条消息为已读
        /// </summary>
        [WebMethod]
        public static void MarkAsRead(int msgId)
        {
            MessageBLL.MarkAsRead(msgId);
        }

        /// <summary>
        /// 全部标为已读
        /// </summary>
        [WebMethod]
        public static void MarkAllAsRead()
        {
            int uid = Utils.GetCurrentUserId();
            MessageBLL.MarkAllAsRead(uid);
        }

        /// <summary>
        /// 删除单条消息
        /// </summary>
        [WebMethod]
        public static void DeleteMessage(int msgId)
        {
            MessageBLL.DeleteMessage(msgId);
        }

        /// <summary>
        /// 清空所有消息
        /// </summary>
        [WebMethod]
        public static void ClearAllMessages()
        {
            int uid = Utils.GetCurrentUserId();
            MessageBLL.ClearAllMessages(uid);
        }
        #endregion

        /// <summary>
        /// 头像上传保存
        /// 包含：格式验证、安全校验、重命名、保存文件、更新数据库
        /// </summary>
        protected void btnSaveAvatar_Click(object sender, EventArgs e)
        {
            try
            {
                if (fuAvatar.HasFile)
                {
                    // 图片安全验证（扩展名、类型、文件头）
                    string validationError = Utils.ValidateImageUpload(fuAvatar.PostedFile);
                    if (validationError != null)
                    {
                        panelProfileMsg.CssClass = "alert alert-danger small";
                        panelProfileMsg.Controls.Add(new LiteralControl(validationError));
                        panelProfileMsg.Visible = true;
                        return;
                    }

                    // 生成唯一文件名，防止重名覆盖
                    string ext = Path.GetExtension(fuAvatar.FileName).ToLower();
                    string fileName = Guid.NewGuid().ToString() + ext;
                    string saveDir = Server.MapPath("~/Uploads/Avatars/");
                    string savePath = Path.Combine(saveDir, fileName);
                    string webPath = "~/Uploads/Avatars/" + fileName;

                    // 创建目录并保存文件
                    if (!Directory.Exists(saveDir))
                        Directory.CreateDirectory(saveDir);
                    fuAvatar.SaveAs(savePath);

                    // 更新数据库头像路径
                    int uid = Utils.GetCurrentUserId();
                    UserBLL.UpdateAvatar(uid, webPath);

                    // 前端实时更新头像显示
                    imgAvatar.ImageUrl = webPath;
                    imgAvatar.Visible = true;
                    litAvatarText.Visible = false;

                    panelProfileMsg.CssClass = "alert alert-success small";
                    panelProfileMsg.Controls.Add(new LiteralControl("头像上传成功！"));
                    panelProfileMsg.Visible = true;
                }
            }
            catch (Exception ex)
            {
                panelProfileMsg.CssClass = "alert alert-danger small";
                panelProfileMsg.Controls.Add(new LiteralControl("上传失败：" + ex.Message));
                panelProfileMsg.Visible = true;
            }
        }
    }
}