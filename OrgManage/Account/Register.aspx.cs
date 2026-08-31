using System;
using System.Data.SqlClient;
using System.Net;
using System.Net.Mail;
using OrgManage.APP_Code;
using System.Text.RegularExpressions;

namespace OrgManage
{
    /// <summary>
    /// 注册页面（优化版：密钥自动绑定角色，不可修改）
    /// </summary>
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                divRoleSelect.Style["display"] = "none";
            }
        }

        #region 注册提交（核心：以密钥角色为准）
        protected void BtnRegister_Click(object sender, EventArgs e)
        {
            // 1. 图形验证码校验
            if (Session["CaptchaCode"] == null || Session["CaptchaCode"].ToString() != txtCaptcha.Text.Trim())
            {
                litKeyStatus.Text = "<span class='text-danger'>❌ 图形验证码错误</span>";
                imgCaptcha.ImageUrl = "~/Account/Captcha.aspx?r=" + DateTime.Now.Ticks;
                return;
            }

            // 2. 邮箱验证码校验
            if (Session["VerifyCode"] == null || Session["VerifyCode"].ToString() != txtCode.Text.Trim())
            {
                litKeyStatus.Text = "<span class='text-danger'>❌ 验证码错误</span>";
                return;
            }

            // 3. 验证码有效期（5分钟）
            if (Session["VerifyCodeTime"] != null)
            {
                double minute = (DateTime.Now - Convert.ToDateTime(Session["VerifyCodeTime"])).TotalMinutes;
                if (minute > 5)
                {
                    litKeyStatus.Text = "<span class='text-danger'>❌ 验证码已过期，请重新获取</span>";
                    return;
                }
            }

            if (!Page.IsValid) return;

            // 4. 获取表单
            string studentNo = txtStudentNo.Text.Trim();
            string userName = txtUserName.Text.Trim();
            string loginName = txtLoginName.Text.Trim();
            string password = txtPwd.Text.Trim();
            string email = txtEmail.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string college = txtCollege.Text.Trim();
            string inviteKey = txtInviteKey.Text.Trim();

            // -------------------------- 后端二次校验（防前端绕过） --------------------------
            // 学号：7位纯数字
            if (!Regex.IsMatch(studentNo, @"^\d{7}$"))
            {
                litKeyStatus.Text = "<span class='text-danger'>❌ 学号必须为7位纯数字</span>";
                return;
            }
            // 姓名：中文≥2字 / 英文≥4字母
            if (!Regex.IsMatch(userName, @"^([\u4e00-\u9fa5]{2,}|[a-zA-Z]{4,})$"))
            {
                litKeyStatus.Text = "<span class='text-danger'>❌ 中文姓名至少2字，英文姓名至少4个字母</span>";
                return;
            }
            // 登录账号：字母数字组合，最长11位
            if (!Regex.IsMatch(loginName, @"^[a-zA-Z0-9]{4,11}$"))
            {
                litKeyStatus.Text = "<span class='text-danger'>❌ 登录账号必须为4-11位</span>";
                return;
            }
            // 密码：≥6位，含英文字母
            if (!Regex.IsMatch(password, @"^(?=.*[a-zA-Z]).{6,}$"))
            {
                litKeyStatus.Text = "<span class='text-danger'>❌ 密码至少6位，且必须包含英文字母</span>";
                return;
            }
            // 手机号：11位纯数字
            if (!Regex.IsMatch(phone, @"^\d{11}$"))
            {
                litKeyStatus.Text = "<span class='text-danger'>❌ 手机号必须为11位纯数字</span>";
                return;
            }
            // 学院：非空
            if (string.IsNullOrWhiteSpace(college))
            {
                litKeyStatus.Text = "<span class='text-danger'>❌ 请输入所在学院</span>";
                return;
            }

            // -------------------------- 违禁词检测 --------------------------
            if (ContainsSensitiveWords(userName) || ContainsSensitiveWords(loginName) || ContainsSensitiveWords(college))
            {
                litKeyStatus.Text = "<span class='text-danger'>❌ 输入内容包含违规词汇，请修改后重试</span>";
                return;
            }

            // 5. 角色：优先从密钥获取（安全可靠）
            int role = 1;
            if (!string.IsNullOrEmpty(inviteKey))
            {
                role = GetRoleByInviteKey(inviteKey);
            }

            // 6. 注册
            bool regOk = UserBLL.Register(studentNo, userName, loginName, password, email, phone, college, role);
            if (regOk)
            {
                if (!string.IsNullOrEmpty(inviteKey))
                {
                    MarkKeyUsed(inviteKey);
                }
                Response.Write("<script>alert('注册成功！请登录');location.href='Login.aspx';</script>");
            }
            else
            {
                litKeyStatus.Text = "<span class='text-danger'>❌ 注册失败：学号/账号已存在</span>";
            }
        }
        #endregion

        #region 根据邀请密钥查询对应角色（核心安全方法）
        private int GetRoleByInviteKey(string keyCode)
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["OrgManageDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string sql = @"SELECT ISNULL(TargetRole,1) FROM InviteKeys 
                               WHERE KeyCode=@KeyCode AND IsUsed=0 
                               AND (ExpireDate IS NULL OR ExpireDate>GETDATE())";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@KeyCode", keyCode);
                object o = cmd.ExecuteScalar();
                return o != null ? Convert.ToInt32(o) : 1;
            }
        }
        #endregion

        #region 标记密钥已使用
        private void MarkKeyUsed(string keyCode)
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["OrgManageDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string sql = @"UPDATE InviteKeys 
                       SET IsUsed = 1, UsedBy = @usedBy, UsedTime = GETDATE() 
                       WHERE KeyCode = @KeyCode";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@KeyCode", keyCode);
                // 注册时用户尚未生成UserID，先设为NULL/0，避免类型转换错误
                cmd.Parameters.AddWithValue("@usedBy", DBNull.Value);
                cmd.ExecuteNonQuery();
            }
        }
        #endregion

        #region 违禁词检测方法
        private bool ContainsSensitiveWords(string input)
        {
            if (string.IsNullOrWhiteSpace(input)) return false;

            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["OrgManageDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string sql = @"SELECT Word FROM SensitiveWords WHERE IsActive=1";
                SqlCommand cmd = new SqlCommand(sql, conn);
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    string word = reader["Word"].ToString();
                    if (input.IndexOf(word, StringComparison.OrdinalIgnoreCase) >= 0)
                    {
                        return true;
                    }
                }
            }
            return false;
        }
        #endregion
    }
}