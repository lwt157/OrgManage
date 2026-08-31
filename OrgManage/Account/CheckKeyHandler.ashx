<%@ WebHandler Language="C#" Class="CheckKeyHandler" %>

using System;
using System.Web;
using System.Web.SessionState;
using System.Data.SqlClient;

public class CheckKeyHandler : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";
        try
        {
            string keyCode = context.Request["key"] ?? "";

            if (string.IsNullOrEmpty(keyCode))
            {
                context.Response.Write("{\"ok\":false,\"msg\":\"请输入邀请密钥\",\"role\":0}");
                return;
            }

            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["OrgManageDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string sql = @"SELECT TargetRole FROM InviteKeys 
                               WHERE KeyCode=@KeyCode 
                               AND IsUsed=0 
                               AND (ExpireDate IS NULL OR ExpireDate > GETDATE())";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@KeyCode", keyCode);
                object res = cmd.ExecuteScalar();

                if (res != null)
                {
                    int role = Convert.ToInt32(res);
                    context.Response.Write("{\"ok\":true,\"msg\":\"密钥有效，已解锁高级权限\",\"role\":" + role + "}");
                }
                else
                {
                    context.Response.Write("{\"ok\":false,\"msg\":\"密钥无效、已使用或已过期\",\"role\":0}");
                }
            }
        }
        catch (Exception ex)
        {
            string errMsg = ex.Message
                .Replace("\\", "\\\\")
                .Replace("\"", "\\\"")
                .Replace("\r", "")
                .Replace("\n", " ");

            context.Response.Write("{\"ok\":false,\"msg\":\"服务器错误：" + errMsg + "\",\"role\":0}");
        }
    }

    public bool IsReusable
    {
        get { return false; }
    }
}