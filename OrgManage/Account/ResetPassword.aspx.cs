using System;
using System.Data.SqlClient;
using OrgManage.APP_Code;
using System.Configuration;

namespace OrgManage.Account
{
    /// <summary>
    /// 重置密码页面
    /// 功能：用户忘记密码后，验证通过在此设置新密码
    /// </summary>
    public partial class ResetPassword : System.Web.UI.Page
    {
        /// <summary>
        /// 页面加载：安全校验
        /// 如果没有经过“忘记密码”验证流程，直接跳转回验证页
        /// </summary>
        protected void Page_Load(object sender, EventArgs e)
        {
            // 必须从 ForgotPassword.aspx 验证跳转过来，否则禁止访问
            if (Session["ForgotLoginName"] == null)
            {
                Response.Redirect("ForgotPassword.aspx");
            }
        }

        /// <summary>
        /// 重置密码按钮（核心方法）
        /// 1. 获取Session中保存的用户名
        /// 2. 获取用户输入的新密码
        /// 3. 密码哈希加密（安全存储）
        /// 4. 更新数据库密码
        /// 5. 清除会话，提示成功并跳转到登录页
        /// </summary>
        protected void btnReset_Click(object sender, EventArgs e)
        {
            // 从Session取出验证通过的用户名
            string loginName = Session["ForgotLoginName"].ToString();

            // 获取用户输入的新密码
            string newPwd = txtNewPwd.Text.Trim();

            // 密码加密：哈希处理，不存明文，保证安全
            string hashedPwd = Utils.HashPassword(newPwd);

            // 连接数据库执行更新
            string connStr = ConfigurationManager.ConnectionStrings["OrgManageDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                // SQL更新语句：根据用户名修改密码
                string sql = "UPDATE Users SET PasswordHash=@Password WHERE LoginName=@LoginName";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@Password", hashedPwd); // 加密后的密码
                cmd.Parameters.AddWithValue("@LoginName", loginName); // 用户名
                cmd.ExecuteNonQuery();
            }

            // 清除所有忘记密码相关的会话信息
            Session.Clear();

            // 提示成功并跳转到登录页
            Response.Write("<script>alert('✅ 密码修改成功！即将返回登录页');location.href='Login.aspx';</script>");
            Response.End();
        }
    }
}