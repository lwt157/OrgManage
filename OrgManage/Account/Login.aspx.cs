using System;
using System.Data;
using System.Web.Security;
using System.Web.UI;
using OrgManage.APP_Code;

namespace OrgManage
{
    /// <summary>
    /// 登录页面逻辑类
    /// 功能：用户账号密码验证 + 登录状态设置 + 页面跳转
    /// </summary>
    public partial class Account_Login : Page
    {
        /// <summary>
        /// 页面加载事件
        /// 逻辑：如果用户已经登录，直接跳转到首页，防止重复登录
        /// </summary>
        protected void Page_Load(object sender, EventArgs e)
        {
            // 已登录则跳转
            if (Utils.IsLoggedIn())
                Response.Redirect("~/Default.aspx");
        }

        /// <summary>
        /// 登录按钮点击事件（核心登录逻辑）
        /// 1. 校验页面输入合法性
        /// 2. 调用业务层验证账号密码
        /// 3. 登录成功 → 清除旧会话（防会话固定攻击）
        /// 4. 设置登录Cookie → 跳转到目标页面
        /// </summary>
        protected void BtnLogin_Click(object sender, EventArgs e)
        {
            // 验证页面输入是否通过验证（非空、格式等）
            if (!Page.IsValid) return;

            // 获取用户输入的账号、密码
            string loginName = txtLoginName.Text.Trim();
            string password = txtPassword.Text;

            // 调用登录方法，验证账号密码，返回用户信息
            var userRow = UserBLL.Login(loginName, password);

            // 验证失败：账号或密码错误
            if (userRow == null)
            {
                panelError.Visible = true;
                litError.Text = "账号或密码错误，请重试。";
                return;
            }

            // 登录成功，获取用户ID和角色权限
            int userID = Convert.ToInt32(userRow["UserID"]);
            int role = Convert.ToInt32(userRow["Role"]);
            bool remember = chkRemember.Checked;

            // ==============================================
            // 安全防护：登录前清除旧会话，防止会话固定攻击
            // ==============================================
            Session.Abandon();
            Session.Clear();

            // 设置登录Cookie（记住我功能）
            Utils.SetLoginCookie(userID, loginName, role, remember);

            // 跳转：有返回地址则跳回，没有则去首页
            string returnUrl = Request.QueryString["returnUrl"];
            if (!string.IsNullOrEmpty(returnUrl))
                Response.Redirect(Server.UrlDecode(returnUrl));
            else
                Response.Redirect("~/Default.aspx");
        }
    }
}