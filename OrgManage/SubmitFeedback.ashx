<%@ WebHandler Language="C#" Class="OrgManage.SubmitFeedback" %>
using System;
using System.Web;
using System.Web.SessionState;
using OrgManage.APP_Code;

namespace OrgManage
{
    public class SubmitFeedback : IHttpHandler, IRequiresSessionState
    {
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";
        context.Response.Charset = "UTF-8";

        try
        {
            // 检查登录
            if (!Utils.IsLoggedIn())
            {
                context.Response.Write("{\"ok\":false,\"msg\":\"请先登录\"}");
                return;
            }

            int userId = Utils.GetCurrentUserId();

            // 读取 POST 数据（支持 JSON 和表单两种格式）
            string type = context.Request.Form["type"];
            string content = context.Request.Form["content"];
            string contact = context.Request.Form["contact"];

            if (string.IsNullOrEmpty(content))
            {
                context.Response.Write("{\"ok\":false,\"msg\":\"内容不能为空\"}");
                return;
            }

            // 确保数据库有 Contact 和 Type 列（首次自动添加）
            try
            {
                DbHelper.ExecuteNonQuery(
                    "IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Feedbacks' AND COLUMN_NAME='Contact') " +
                    "ALTER TABLE Feedbacks ADD Contact NVARCHAR(100) NULL");
                DbHelper.ExecuteNonQuery(
                    "IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Feedbacks' AND COLUMN_NAME='Type') " +
                    "ALTER TABLE Feedbacks ADD Type NVARCHAR(20) NULL");
            }
            catch { }

            string sql = "INSERT INTO Feedbacks(UserID, Type, Content, Contact, Status, CreateTime) VALUES(@uid, @type, @content, @contact, 0, GETDATE())";
            DbHelper.ExecuteNonQuery(sql,
                new System.Data.SqlClient.SqlParameter("@uid", userId),
                new System.Data.SqlClient.SqlParameter("@type", type ?? ""),
                new System.Data.SqlClient.SqlParameter("@content", content ?? ""),
                new System.Data.SqlClient.SqlParameter("@contact", contact ?? ""));

            context.Response.Write("{\"ok\":true,\"msg\":\"已收到\"}");
        }
        catch (Exception)
        {
            context.Response.Write("{\"ok\":false,\"msg\":\"提交失败\"}");
        }
    }

    public bool IsReusable
    {
        get { return false; }
    }
}
}
