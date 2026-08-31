using System;
using System.Web.UI;
using OrgManage.APP_Code;

namespace OrgManage
{
    public partial class SiteMaster : System.Web.UI.MasterPage
    {
        // ==============================================
        // ✅✅✅ CSRF 防护：ViewStateUserKey 绑定到用户会话 ✅✅✅
        // ==============================================
        protected void Page_Init(object sender, EventArgs e)
        {
            // 将 ViewState 绑定到用户 SessionID，防止跨站请求伪造
            // 必须在 Page_Init 中设置，确保所有控件都继承该绑定
            if (Session != null)
            {
                // 确保 SessionID 已生成
                string sessionKey = Session.SessionID;
                if (!string.IsNullOrEmpty(sessionKey))
                {
                    Page.ViewStateUserKey = sessionKey;
                }
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // ==============================================
            // ✅✅✅ 安全响应头（保护所有使用此母版页的页面）✅✅✅
            // ==============================================
            Response.AddHeader("X-Frame-Options", "SAMEORIGIN");                    // 防点击劫持
            Response.AddHeader("X-Content-Type-Options", "nosniff");                // 防止MIME类型嗅探
            Response.AddHeader("X-XSS-Protection", "1; mode=block");              // XSS过滤器（兼容旧浏览器）
            Response.AddHeader("Referrer-Policy", "strict-origin-when-cross-origin"); // 限制Referrer泄漏

            if (Utils.IsLoggedIn())
            {
                phLogin.Visible = true;
                phNotLogin.Visible = false;

                int userID = Utils.GetCurrentUserId();
                string userName = Session["UserName"] as string;
                int role = -1;

                if (Session["Role"] != null)
                    int.TryParse(Session["Role"].ToString(), out role);

                if (userName == null || role == -1)
                {
                    var userData = UserBLL.GetUser(userID);
                    if (userData != null)
                    {
                        userName = userData["UserName"].ToString();
                        role = Convert.ToInt32(userData["Role"]);
                        Session["UserName"] = userName;
                        Session["Role"] = role;
                    }
                }

                if (userName != null)
                {
                    litUserName.Text = userName;

                    // ====================== 权限导航逻辑 ======================
                    phOrgManage.Visible = false;
                    phAdmin.Visible = false;

                    switch (role)
                    {
                        case 1:
                            break;

                        case 2:
                            phOrgManage.Visible = true;
                            lnkMyOrg.NavigateUrl = "~/Manage/MyOrg.aspx";
                            phAdmin.Visible = false;
                            break;

                        case 3:
                            // 院级管理员：显示我的组织，不显示后台
                            phOrgManage.Visible = true;
                            lnkMyOrg.NavigateUrl = "~/Admin/OrgAuditDept.aspx";
                            phAdmin.Visible = false; // ✅ 隐藏
                            break;

                        case 4:
                            // 校级管理员：显示我的组织，✅ 不显示后台
                            phOrgManage.Visible = true;
                            lnkMyOrg.NavigateUrl = "~/Admin/SchoolOrgManage.aspx";
                            phAdmin.Visible = false;
                            break;

                        case 5:
                            // 超级管理员：不显示我的组织，显示后台
                            phOrgManage.Visible = false;
                            phAdmin.Visible = true;
                            break;
                    }
                }
            }
            else
            {
                phLogin.Visible = false;
                phNotLogin.Visible = true;
                Session.Remove("UserName");
                Session.Remove("Role");
            }

            SetActiveNav();

            // ================== 加载系统配置：LOGO + 名称 ==================
            try
            {
                System.Data.DataTable dt = Utils.GetDataTable("SELECT ConfigKey,ConfigValue FROM SystemConfig WHERE ConfigKey IN('SystemLogo','SystemName')");
                if (dt != null && dt.Rows.Count > 0)
                {
                    foreach (System.Data.DataRow row in dt.Rows)
                    {
                        string key = row["ConfigKey"].ToString();
                        string val = row["ConfigValue"].ToString();

                        if (key == "SystemLogo")
                            imgSystemLogo.ImageUrl = ResolveUrl(val);

                        if (key == "SystemName")
                            litSystemName.Text = val;
                    }
                }
            }
            catch { }
        }

        private void SetActiveNav()
        {
            string url = Request.Url.AbsolutePath.ToLower();

            if (url.Contains("/default.aspx"))
                navHome.CssClass = "nav-link active";
            else if (url.Contains("/orgs/list.aspx"))
                navOrgs.CssClass = "nav-link active";
            else if (url.Contains("/activities/list.aspx"))
                navActivities.CssClass = "nav-link active";
            else if (url.Contains("/orgs/recruit.aspx"))
                navRecruit.CssClass = "nav-link active";
        }
    }
}