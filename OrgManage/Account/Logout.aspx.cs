using System;
using System.Web.Security;
using System.Web.UI;
using OrgManage.APP_Code;

namespace OrgManage
{
    public partial class Account_Logout : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // ✅ 注销时彻底清除会话（Session.Abandon 会在服务端立即失效）
            Session.Clear();
            Session.Abandon();
            FormsAuthentication.SignOut();
            Response.Redirect("~/Default.aspx");
        }
    }
}
