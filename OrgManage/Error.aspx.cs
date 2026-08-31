using System;

namespace OrgManage
{
    public partial class ErrorPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string code = Request.QueryString["code"] ?? "500";

            if (code == "404")
            {
                Response.StatusCode = 404;
                litIcon.Text = "&#128269;";
                litCode.Text = "404";
                litTitle.Text = "PageNotFound";
                litDesc.Text = "The page you are looking for does not exist or has been removed.";
            }
            else
            {
                Response.StatusCode = 500;
                litIcon.Text = "&#9888;";
                litCode.Text = "500";
                litTitle.Text = "SystemError";
                litDesc.Text = "Sorry, an unexpected error occurred. Please try again later.";
            }
        }
    }
}
