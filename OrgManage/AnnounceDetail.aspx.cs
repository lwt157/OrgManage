using System;
using System.Data;
using OrgManage.APP_Code;

public partial class AnnounceDetail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // 安全的参数解析：无效ID显示友好错误
        int id;
        if (!int.TryParse(Request.QueryString["id"], out id))
        {
            litTitle.Text = "公告不存在";
            litContent.Text = "<p class='text-muted'>您访问的公告不存在或已被删除。</p>";
            return;
        }

        DataTable dt = DbHelper.ExecuteQuery(
            "SELECT Title, Content FROM Announcements WHERE AnnID=@id",
            new System.Data.SqlClient.SqlParameter("@id", id));

        if (dt.Rows.Count > 0)
        {
            // ✅ XSS防护：对用户输入进行HTML编码，保留换行格式
            litTitle.Text = Utils.HtmlEncode(dt.Rows[0]["Title"].ToString());
            litContent.Text = Utils.HtmlEncode(dt.Rows[0]["Content"].ToString()).Replace("\n", "<br>");
        }
        else
        {
            litTitle.Text = "公告不存在";
            litContent.Text = "<p class='text-muted'>您访问的公告不存在或已被删除。</p>";
        }
    }
}