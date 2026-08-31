using System;
using System.Data.SqlClient;
using System.Net;
using System.Net.Mail;
using OrgManage.APP_Code;
using System.Configuration;

namespace OrgManage.Account
{
    /// <summary>
    /// 忘记密码页面（三步流程：验证账号 → 发送邮箱验证码 → 验证验证码 → 跳转到重置密码）
    /// </summary>
    public partial class ForgotPassword : System.Web.UI.Page
    {
        private string validLoginName; // 验证通过的用户名
        private string validEmail;     // 验证通过的邮箱

        /// <summary>
        /// 页面初始化：默认显示第一步（验证账号邮箱）
        /// </summary>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                panelStep1.Visible = true;  // 显示：验证用户名+邮箱
                panelStep2.Visible = false; // 隐藏：获取验证码
            }
        }

        /// <summary>
        /// 统一弹窗提示（安全：防止攻击者判断是用户名错还是邮箱错）
        /// </summary>
        private void ShowAlert(string msg)
        {
            ClientScript.RegisterStartupScript(this.GetType(), "alert",
                "alert('" + msg.Replace("'", "\\'") + "');", true);
        }

        /// <summary>
        /// 第一步：验证【用户名 + 邮箱】是否匹配数据库
        /// 安全点：使用参数化SQL防注入，统一模糊提示防枚举攻击
        /// </summary>
        protected void btnCheckUser_Click(object sender, EventArgs e)
        {
            string loginName = txtLoginName.Text.Trim();
            string email = txtEmail.Text.Trim();

            string connStr = ConfigurationManager.ConnectionStrings["OrgManageDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                // 一条SQL同时验证用户名和邮箱，不单独返回信息
                string sql = "SELECT COUNT(*) FROM Users WHERE LoginName=@LoginName AND Email=@Email";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@LoginName", loginName);
                cmd.Parameters.AddWithValue("@Email", email);
                int matchCount = Convert.ToInt32(cmd.ExecuteScalar());

                if (matchCount == 0)
                {
                    ShowAlert("信息验证失败，请检查输入后重试。");
                    return;
                }

                // 验证通过，存入Session，进入第二步
                Session["ForgotLoginName"] = loginName;
                Session["ForgotEmail"] = email;

                ShowAlert("验证通过，请获取邮箱验证码。");
                panelStep1.Visible = false;
                panelStep2.Visible = true;
            }
        }

        /// <summary>
        /// 第二步：发送6位邮箱验证码
        /// 功能：生成验证码 → 存入Session → 调用QQ邮箱SMTP发送
        /// 安全：验证码有效期5分钟，支持环境变量/配置文件双读取
        /// </summary>
        protected void btnSendCode_Click(object sender, EventArgs e)
        {
            if (Session["ForgotEmail"] == null)
            {
                ShowAlert("请先完成账号验证。");
                return;
            }

            string email = Session["ForgotEmail"].ToString();
            // 生成6位数字验证码
            string code = new Random().Next(100000, 999999).ToString();
            Session["ForgotCode"] = code;
            Session["ForgotCodeTime"] = DateTime.Now;

            try
            {
                // 读取发件邮箱账号（优先环境变量，更安全）
                string sendMail = Environment.GetEnvironmentVariable("ORGMAIL_ACCOUNT");
                if (string.IsNullOrEmpty(sendMail))
                    sendMail = ConfigurationManager.AppSettings["MailAccount"];

                // 读取邮箱授权码
                string authCode = Environment.GetEnvironmentVariable("ORGMAIL_AUTHCODE");
                if (string.IsNullOrEmpty(authCode))
                    authCode = ConfigurationManager.AppSettings["MailAuthCode"];

                // 构造邮件
                MailMessage msg = new MailMessage();
                msg.From = new MailAddress(sendMail, "高校组织管理平台");
                msg.To.Add(email);
                msg.Subject = "找回密码验证码";
                msg.Body = string.Format("您好！您的找回密码验证码为：{0}\n有效期5分钟，请勿泄露给他人。", code);

                // SMTP发送（QQ邮箱）
                SmtpClient smtp = new SmtpClient("smtp.qq.com", 587);
                smtp.Credentials = new NetworkCredential(sendMail, authCode);
                smtp.EnableSsl = true;
                smtp.Send(msg);

                ShowAlert("验证码已发送，请查收邮箱。");
            }
            catch (Exception)
            {
                ShowAlert("邮件发送失败，请稍后重试。");
            }
        }

        /// <summary>
        /// 第三步：校验验证码是否正确 + 是否过期
        /// 验证通过 → 跳转到重置密码页面 ResetPassword.aspx
        /// </summary>
        protected void btnVerifyCode_Click(object sender, EventArgs e)
        {
            // 校验验证码是否正确
            if (Session["ForgotCode"] == null || Session["ForgotCode"].ToString() != txtCode.Text.Trim())
            {
                ShowAlert("验证码错误，请重新输入。");
                return;
            }

            // 校验是否超过5分钟有效期
            if (Session["ForgotCodeTime"] != null)
            {
                double minute = (DateTime.Now - Convert.ToDateTime(Session["ForgotCodeTime"])).TotalMinutes;
                if (minute > 5)
                {
                    ShowAlert("验证码已过期，请重新获取。");
                    return;
                }
            }

            ShowAlert("验证通过，正在进入密码重置页面...");
            Response.Redirect("ResetPassword.aspx");
        }
    }
}