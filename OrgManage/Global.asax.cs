using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using System.Web.UI;

namespace OrgManage
{
    public partial class Global : System.Web.HttpApplication
    {
        protected void Application_Start(object sender, EventArgs e)
        {
            // 注册本地 jQuery 映射
            ScriptManager.ScriptResourceMapping.AddDefinition("jquery",
            new ScriptResourceDefinition
            {
                Path = "~/Scripts/jquery-3.7.1.min.js",
                DebugPath = "~/Scripts/jquery-3.7.1.min.js",
                CdnPath = null,
                CdnDebugPath = null
            });
        }

        // ==============================================
        // ✅✅✅ URL 重写：隐藏 .aspx 扩展名 ✅✅✅
        // 浏览器访问 /Account/Login 自动映射到 Login.aspx
        // 完全不影响 PostBack、ViewState 等 ASP.NET 机制
        // ==============================================
        protected void Application_BeginRequest(object sender, EventArgs e)
        {
            string path = Request.Url.AbsolutePath.ToLower();

            // 跳过有扩展名的请求（.css/.js/.png/.jpg 等静态资源）
            if (path.Contains(".")) return;

            // 跳过根路径
            if (path == "/" || string.IsNullOrEmpty(path)) return;

            // 尝试映射到 .aspx 文件
            string aspxPath = path + ".aspx";
            string physicalPath = Server.MapPath(aspxPath);
            if (File.Exists(physicalPath))
            {
                Context.RewritePath(aspxPath);
            }
        }

        protected void Session_Start(object sender, EventArgs e)
        {
            // ✅ 会话固定防护：每个新会话生成随机会话ID
            Session["SessionInitTime"] = DateTime.Now.Ticks;
        }

        // ==============================================
        // ✅✅✅ 全局异常处理（防止内部错误泄露给用户）✅✅✅
        // ==============================================
        protected void Application_Error(object sender, EventArgs e)
        {
            Exception ex = Server.GetLastError();
            if (ex == null) return;

            string url = Request.Url.ToString().ToLower();

            // 防循环保护：如果错误页面/登录页本身出错，直接输出简单HTML，不再重定向
            if (url.Contains("/error.aspx") || url.Contains("/login.aspx"))
            {
                Server.ClearError();
                Response.Write("<html><body style='font-family:Microsoft YaHei,sans-serif;padding:40px;text-align:center;background:#1a1a2e;color:#fff'><h1>发生错误</h1><p>系统遇到错误且错误页面不可用。</p><p><a href='/' style='color:#4da6ff'>返回首页</a></p></body></html>");
                Response.End();
                return;
            }

            // 记录日志（包装try/catch防止日志写入失败导致二次异常）
            try
            {
                string logPath = Server.MapPath("~/App_Data/error.log");
                string logDir = Path.GetDirectoryName(logPath);
                if (!Directory.Exists(logDir)) Directory.CreateDirectory(logDir);

                string logEntry = string.Format(
                    "[{0}] {1}\n  URL: {2}\n  User: {3}\n  Stack: {4}\n---\n",
                    DateTime.Now, ex.Message,
                    Request.Url, Request.UserHostAddress,
                    ex.StackTrace);
                File.AppendAllText(logPath, logEntry);
            }
            catch { /* 日志写入失败不影响主流程 */ }

            if (ex is UnauthorizedAccessException)
            {
                // 未授权访问 → 跳转登录
                Server.ClearError();
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            // 对于404、500及其他异常：不手动重定向，不调用Server.ClearError()
            // 让Web.config中的customErrors自动处理用户友好的错误页面
            // 这样可以避免Application_Error与customErrors的双重重定向冲突和循环
        }
    }
}