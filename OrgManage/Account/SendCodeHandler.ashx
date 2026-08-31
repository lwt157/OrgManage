<%@ WebHandler Language="C#" Class="SendCodeHandler" %>

using System;
using System.Web;
using System.Web.SessionState;
using System.Net.Mail;
using System.Net;

public class SendCodeHandler : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";
        string email = context.Request["email"];

        if (string.IsNullOrEmpty(email))
        {
            context.Response.Write("{\"ok\":false,\"msg\":\"请输入邮箱\"}");
            return;
        }

        // 生成6位验证码
        Random random = new Random();
        string code = random.Next(100000, 999999).ToString();
        context.Session["VerifyCode"] = code;
        context.Session["VerifyCodeTime"] = DateTime.Now;

        try
        {
            // 从 Web.config 读取配置
            string sendMail = System.Configuration.ConfigurationManager.AppSettings["MailAccount"];
            string authCode = System.Configuration.ConfigurationManager.AppSettings["MailAuthCode"];

            MailMessage msg = new MailMessage();
            msg.From = new MailAddress(sendMail, "高校组织管理平台");
            msg.To.Add(email);
            msg.Subject = "账号注册验证码";
            msg.Body = "您好！您的注册验证码为：" + code + "\n有效期5分钟，请勿泄露给他人。";
            msg.IsBodyHtml = false;

            SmtpClient smtp = new SmtpClient("smtp.qq.com", 587);
            smtp.Credentials = new NetworkCredential(sendMail, authCode);
            smtp.EnableSsl = true;
            smtp.Send(msg);

            context.Response.Write("{\"ok\":true,\"msg\":\"验证码已发送，请查收邮箱\"}");
        }
        catch (Exception ex)
        {
            string errMsg = ex.Message.Replace("\"", "\\\"");
            context.Response.Write("{\"ok\":false,\"msg\":\"发送失败：" + errMsg + "\"}");
        }
    }

    public bool IsReusable
    {
        get { return false; }
    }
}