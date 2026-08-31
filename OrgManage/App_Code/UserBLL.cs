using System;
using System.Data;
using System.Data.SqlClient;
using OrgManage.APP_Code;

namespace OrgManage.APP_Code
{
    /// <summary>
    /// 用户业务逻辑
    /// </summary>
    public class UserBLL
    {


        public static string GetUserCollege(int userId)
        {
            string sql = "SELECT College FROM Users WHERE UserID=@ID";
            object college = DbHelper.ExecuteScalar(sql, new SqlParameter("@ID", userId));
            return college != null ? college.ToString() : "";
        }
        //按学号查询
        public static DataRow GetUserByStudentNo(string studentNo)
        {
            string sql = "SELECT * FROM Users WHERE StudentNo = @StudentNo";
            DataTable dt = DbHelper.ExecuteQuery(sql, new SqlParameter("@StudentNo", studentNo));
            return dt.Rows.Count > 0 ? dt.Rows[0] : null;
        }


        /// <summary>用户登录验证，返回用户信息DataRow（null表示失败）</summary>
        public static DataRow Login(string loginName, string password)
        {
            string sql = @"SELECT UserID, LoginName, UserName, Role, StudentNo, Email, IsActive
                           FROM Users WHERE LoginName = @LoginName";
            var dt = DbHelper.ExecuteQuery(sql,
                new SqlParameter("@LoginName", loginName));

            if (dt.Rows.Count == 0) return null;

            var row = dt.Rows[0];
            if (!(bool)row["IsActive"]) return null; // 账号被禁用

            string storedHash = "";
            // 重新查询密码哈希（不放在上面的查询以减少密码暴露）
            var hashResult = DbHelper.ExecuteScalar(
                "SELECT PasswordHash FROM Users WHERE LoginName = @LoginName",
                new SqlParameter("@LoginName", loginName));
            if (hashResult == null) return null;
            storedHash = hashResult.ToString();

            if (!Utils.VerifyPassword(password, storedHash)) return null;

            // 旧SHA256哈希首次验证成功后，自动升级为PBKDF2
            if (!storedHash.StartsWith("$pbkdf2$"))
            {
                string newHash = Utils.HashPassword(password);
                DbHelper.ExecuteNonQuery(
                    "UPDATE Users SET PasswordHash=@H WHERE LoginName=@L",
                    new SqlParameter("@H", newHash),
                    new SqlParameter("@L", loginName));
            }

            // 更新最后登录时间
            DbHelper.ExecuteNonQuery("UPDATE Users SET LastLogin=GETDATE() WHERE LoginName=@LoginName",
                new SqlParameter("@LoginName", loginName));

            return row;
        }

        /// <summary>注册新用户</summary>
        public static bool Register(string studentNo, string userName, string loginName,
                             string password, string email, string phone, string college, int role = 1)
        {
            var exists = DbHelper.ExecuteScalar(
                "SELECT COUNT(1) FROM Users WHERE LoginName=@L OR StudentNo=@S",
                new SqlParameter("@L", loginName),
                new SqlParameter("@S", studentNo));
            if (Convert.ToInt32(exists) > 0) return false;

            string sql = @"INSERT INTO Users(StudentNo, UserName, LoginName, PasswordHash, Role, Email, Phone, College)
                   VALUES(@StudentNo, @UserName, @LoginName, @PwdHash, @Role, @Email, @Phone, @College)";
            int rows = DbHelper.ExecuteNonQuery(sql,
                new SqlParameter("@StudentNo", studentNo),
                new SqlParameter("@UserName", userName),
                new SqlParameter("@LoginName", loginName),
                new SqlParameter("@PwdHash", Utils.HashPassword(password)),
                new SqlParameter("@Role", role),
                new SqlParameter("@Email", (object)email ?? DBNull.Value),
                new SqlParameter("@Phone", (object)phone ?? DBNull.Value),
                new SqlParameter("@College", (object)college ?? DBNull.Value));
            return rows > 0;
        }

        /// <summary>获取用户信息</summary>
        public static DataRow GetUser(int userID)
        {
            var dt = DbHelper.ExecuteQuery(
                "SELECT * FROM Users WHERE UserID=@ID",
                new SqlParameter("@ID", userID));
            return dt.Rows.Count > 0 ? dt.Rows[0] : null;
        }
        public static string GetUserName(int userId)
        {
            string sql = "SELECT UserName FROM Users WHERE UserID=@id";
            // 用 ExecuteQuery 代替 GetSingle
            var dt = DbHelper.ExecuteQuery(sql, new System.Data.SqlClient.SqlParameter("@id", userId));
            return dt.Rows.Count > 0 ? dt.Rows[0]["UserName"].ToString() : "管理员";
        }
        /// <summary>修改密码</summary>
        public static bool ChangePassword(int userID, string oldPwd, string newPwd)
        {
            var hash = DbHelper.ExecuteScalar(
                "SELECT PasswordHash FROM Users WHERE UserID=@ID",
                new SqlParameter("@ID", userID));
            if (hash == null || !Utils.VerifyPassword(oldPwd, hash.ToString()))
                return false;
            DbHelper.ExecuteNonQuery(
                "UPDATE Users SET PasswordHash=@H WHERE UserID=@ID",
                new SqlParameter("@H", Utils.HashPassword(newPwd)),
                new SqlParameter("@ID", userID));
            return true;
        }

        /// <summary>更新个人资料</summary>
        public static bool UpdateProfile(int userID, string email, string phone, string college)
        {
            int rows = DbHelper.ExecuteNonQuery(
                "UPDATE Users SET Email=@E, Phone=@P, College=@C WHERE UserID=@ID",
                new SqlParameter("@E", (object)email ?? DBNull.Value),
                new SqlParameter("@P", (object)phone ?? DBNull.Value),
                new SqlParameter("@C", (object)college ?? DBNull.Value),
                new SqlParameter("@ID", userID));
            return rows > 0;
        }

        /// <summary>获取全部用户列表（管理员用）</summary>
        public static DataTable GetAllUsers(string keyword = "")
        {
            string sql = @"SELECT UserID, StudentNo, UserName, LoginName, Role, Email, College, IsActive, CreateTime
                           FROM Users WHERE 1=1";
            if (!string.IsNullOrEmpty(keyword))
                sql += " AND (UserName LIKE @KW OR StudentNo LIKE @KW OR LoginName LIKE @KW)";
            sql += " ORDER BY CreateTime DESC";

            if (!string.IsNullOrEmpty(keyword))
                return DbHelper.ExecuteQuery(sql, new SqlParameter("@KW", "%" + keyword + "%"));
            return DbHelper.ExecuteQuery(sql);
        }

        /// <summary>启用/禁用用户</summary>
        public static void SetUserActive(int userID, bool active)
        {
            DbHelper.ExecuteNonQuery(
                "UPDATE Users SET IsActive=@A WHERE UserID=@ID",
                new SqlParameter("@A", active),
                new SqlParameter("@ID", userID));
        }
        public static void UpdateAvatar(int userId, string avatarUrl)
        {
            string sql = @"UPDATE Users 
                  SET AvatarUrl = @AvatarUrl 
                  WHERE UserID = @UserID";

            SqlParameter[] paras = {
        new SqlParameter("@UserID", userId),
        new SqlParameter("@AvatarUrl", avatarUrl)
    };
            OrgManage.APP_Code.DbHelper.ExecuteNonQuery(sql, paras);
        }
    }



}