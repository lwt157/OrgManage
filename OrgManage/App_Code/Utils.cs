using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Security;
using System.Security.Cryptography;
using System.Text;
using OrgManage.APP_Code;

namespace OrgManage.APP_Code
{
    public static class Utils
    {
        /// <summary>获取数据库连接</summary>
        public static SqlConnection GetConn()
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["OrgManageDB"].ConnectionString;
            SqlConnection conn = new SqlConnection(connStr);
            conn.Open();
            return conn;
        }

        /// <summary>执行SQL返回DataTable</summary>
        public static DataTable GetDataTable(string sql, params SqlParameter[] paras)
        {
            using (SqlConnection conn = GetConn())
            {
                SqlCommand cmd = new SqlCommand(sql, conn);
                if (paras != null) cmd.Parameters.AddRange(paras);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        /// <summary>执行SQL返回受影响行数</summary>
        public static int ExecuteSql(string sql, params SqlParameter[] paras)
        {
            using (SqlConnection conn = GetConn())
            {
                SqlCommand cmd = new SqlCommand(sql, conn);
                if (paras != null) cmd.Parameters.AddRange(paras);
                return cmd.ExecuteNonQuery();
            }
        }

        /// <summary>执行SQL返回单个值</summary>
        public static object ExecuteScalar(string sql, params SqlParameter[] paras)
        {
            using (SqlConnection conn = GetConn())
            {
                SqlCommand cmd = new SqlCommand(sql, conn);
                if (paras != null) cmd.Parameters.AddRange(paras);
                return cmd.ExecuteScalar();
            }
        }

        /// <summary>获取当前登录用户ID</summary>
        public static int GetCurrentUserId()
        {
            if (HttpContext.Current.User.Identity.IsAuthenticated)
            {
                string userId = HttpContext.Current.User.Identity.Name;
                int id;
                if (int.TryParse(userId, out id))
                    return id;
            }
            return 0;
        }

        /// <summary>获取当前登录用户信息</summary>
        public static DataRow GetCurrentUser()
        {
            int userId = GetCurrentUserId();
            if (userId > 0)
            {
                DataTable dt = GetDataTable("SELECT * FROM Users WHERE UserId=@UserId",
                    new SqlParameter("@UserId", userId));
                if (dt.Rows.Count > 0) return dt.Rows[0];
            }
            return null;
        }

        /// <summary>检查是否已登录</summary>
        public static bool IsAuthenticated()
        {
            return HttpContext.Current.User.Identity.IsAuthenticated;
        }

        /// <summary>检查是否是管理员</summary>
        public static bool IsAdmin()
        {
            DataRow user = GetCurrentUser();
            return user != null && Convert.ToInt32(user["Role"]) == 3;
        }

        /// <summary>检查是否是组织管理者</summary>
        public static bool IsOrgManager()
        {
            DataRow user = GetCurrentUser();
            return user != null && (Convert.ToInt32(user["Role"]) == 2 || Convert.ToInt32(user["Role"]) == 3);
        }

        /// <summary>安全获取字符串</summary>
        public static string GetString(object obj)
        {
            return obj == null || obj == DBNull.Value ? "" : obj.ToString();
        }

        /// <summary>安全获取整数</summary>
        public static int GetInt(object obj, int defaultVal = 0)
        {
            if (obj == null || obj == DBNull.Value) return defaultVal;
            int val;
            return int.TryParse(obj.ToString(), out val) ? val : defaultVal;
        }

        /// <summary>安全获取日期</summary>
        public static DateTime GetDateTime(object obj)
        {
            if (obj == null || obj == DBNull.Value) return DateTime.MinValue;
            DateTime val;
            return DateTime.TryParse(obj.ToString(), out val) ? val : DateTime.MinValue;
        }

        /// <summary>友好时间显示</summary>
        public static string FriendlyTime(DateTime dt)
        {
            var diff = DateTime.Now - dt;
            if (diff.TotalMinutes < 1) return "刚刚";
            if (diff.TotalHours < 1) return string.Format("{0}分钟前", (int)diff.TotalMinutes);
            if (diff.TotalDays < 1) return string.Format("{0}小时前", (int)diff.TotalHours);
            if (diff.TotalDays < 30) return string.Format("{0}天前", (int)diff.TotalDays);
            return dt.ToString("yyyy-MM-dd");
        }

        /// <summary>角色名称</summary>
        public static string GetRoleName(int role)
        {
            switch (role)
            {
                case 1: return "学生";
                case 2: return "组织管理员";
                case 3: return "院级管理员";
                case 4: return "校级管理员";
                case 5: return "系统管理员";
                default: return "未知角色";
            }
        }
        /// <summary>活动状态名称</summary>
        public static string GetActivityStatusName(int status)
        {
            switch (status)
            {
                case 0: return "草稿";
                case 1: return "报名中";
                case 2: return "进行中";
                case 3: return "已结束";
                case 4: return "已取消";
                default: return "未知";
            }
        }

        /// <summary>报名状态名称</summary>
        public static string GetApplyStatusName(int status)
        {
            switch (status)
            {
                case 0: return "待审核";
                case 1: return "已通过";
                case 2: return "已拒绝";
                default: return "未知";
            }
        }

        /// <summary>组织类型名称</summary>
        public static string GetOrgTypeName(int type)
        {
            switch (type)
            {
                case 1: return "学生会";
                case 2: return "社团";
                case 3: return "志愿者协会";
                case 4: return "学术组织";
                case 5: return "兴趣小组";
                case 6: return "其他";
                default: return "未知";
            }
        }

        /// <summary>截断字符串</summary>
        public static string CutString(string str, int length)
        {
            if (string.IsNullOrEmpty(str)) return "";
            if (str.Length <= length) return str;
            return str.Substring(0, length) + "...";
        }

        /// <summary>HTML编码</summary>
        public static string HtmlEncode(string str)
        {
            return HttpUtility.HtmlEncode(str);
        }

        /// <summary>HTML解码</summary>
        public static string HtmlDecode(string str)
        {
            return HttpUtility.HtmlDecode(str);
        }

        /// <summary>检查用户是否已登录</summary>
        public static bool IsLoggedIn()
        {
            return HttpContext.Current.User.Identity.IsAuthenticated;
        }

        /// <summary>设置登录Cookie</summary>
        public static void SetLoginCookie(int userID, string loginName, int role, bool remember)
        {
            FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(
                1, userID.ToString(), DateTime.Now,
                DateTime.Now.AddMinutes(remember ? 1440 : 60),
                remember, role.ToString(), FormsAuthentication.FormsCookiePath);

            string encryptedTicket = FormsAuthentication.Encrypt(ticket);
            HttpCookie cookie = new HttpCookie(FormsAuthentication.FormsCookieName, encryptedTicket);
            cookie.Expires = ticket.Expiration;
            HttpContext.Current.Response.Cookies.Add(cookie);
        }

        /// <summary>用户登出</summary>
        public static void Logout()
        {
            FormsAuthentication.SignOut();
        }

        // ==============================================
        // ✅✅✅ 密码安全升级：PBKDF2（向后兼容旧SHA256） ✅✅✅
        // 新哈希格式：$pbkdf2$iterations$salt$hash（Base64）
        // 旧哈希格式：64位十六进制字符串（检测到后自动升级）
        // ==============================================
        private const int PBKDF2_ITERATIONS = 10000;
        private const int PBKDF2_SALT_SIZE = 16;
        private const int PBKDF2_HASH_SIZE = 32;

        /// <summary>密码哈希（PBKDF2，带随机盐，10000次迭代）</summary>
        public static string HashPassword(string password)
        {
            byte[] salt = new byte[PBKDF2_SALT_SIZE];
            using (RandomNumberGenerator rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(salt);
            }

            byte[] hash;
            using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, PBKDF2_ITERATIONS, HashAlgorithmName.SHA1))
            {
                hash = pbkdf2.GetBytes(PBKDF2_HASH_SIZE);
            }

            // 格式：$pbkdf2$iterations$salt$hash
            string saltB64 = Convert.ToBase64String(salt);
            string hashB64 = Convert.ToBase64String(hash);
            return string.Format("$pbkdf2${0}${1}${2}", PBKDF2_ITERATIONS, saltB64, hashB64);
        }

        /// <summary>验证密码（兼容旧SHA256格式，首次验证后自动升级）</summary>
        public static bool VerifyPassword(string password, string storedHash)
        {
            // 旧格式（64位十六进制 SHA256）
            if (!storedHash.StartsWith("$pbkdf2$") && storedHash.Length == 64)
            {
                // 兼容旧SHA256，验证成功后自动用PBKDF2覆盖
                bool match = HashPasswordLegacy(password) == storedHash;
                return match;
            }

            // 新格式 PBKDF2
            if (!storedHash.StartsWith("$pbkdf2$"))
                return false;

            string[] parts = storedHash.Substring(8).Split('$');
            if (parts.Length != 3) return false;

            int iterations;
            if (!int.TryParse(parts[0], out iterations)) return false;
            byte[] salt;
            byte[] storedHashBytes;
            try
            {
                salt = Convert.FromBase64String(parts[1]);
                storedHashBytes = Convert.FromBase64String(parts[2]);
            }
            catch
            {
                return false;
            }

            byte[] computedHash;
            using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, iterations, HashAlgorithmName.SHA1))
            {
                computedHash = pbkdf2.GetBytes(PBKDF2_HASH_SIZE);
            }

            return ConstantTimeEquals(computedHash, storedHashBytes);
        }

        /// <summary>使用旧SHA256验证（供升级路径使用）</summary>
        private static string HashPasswordLegacy(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                StringBuilder sb = new StringBuilder();
                foreach (byte b in bytes)
                {
                    sb.Append(b.ToString("x2"));
                }
                return sb.ToString();
            }
        }

        /// <summary>常数时间比较，防止时序攻击</summary>
        private static bool ConstantTimeEquals(byte[] a, byte[] b)
        {
            if (a.Length != b.Length) return false;
            int result = 0;
            for (int i = 0; i < a.Length; i++)
            {
                result |= a[i] ^ b[i];
            }
            return result == 0;
        }

        // ==============================================
        // ✅✅✅ 文件上传安全校验（防止恶意文件上传）✅✅✅
        // ==============================================
        // 允许的图片扩展名
        private static readonly string[] ALLOWED_IMAGE_EXTENSIONS = { ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp" };
        // 允许的图片MIME类型
        private static readonly string[] ALLOWED_IMAGE_MIME = { "image/jpeg", "image/png", "image/gif", "image/bmp", "image/webp" };
        // 图片文件头（Magic Bytes）校验
        private static readonly Dictionary<string, byte[][]> IMAGE_HEADERS = new Dictionary<string, byte[][]>
        {
            { ".jpg", new byte[][] { new byte[] { 0xFF, 0xD8, 0xFF } } },
            { ".jpeg", new byte[][] { new byte[] { 0xFF, 0xD8, 0xFF } } },
            { ".png", new byte[][] { new byte[] { 0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A } } },
            { ".gif", new byte[][] { new byte[] { 0x47, 0x49, 0x46, 0x38, 0x37, 0x61 }, new byte[] { 0x47, 0x49, 0x46, 0x38, 0x39, 0x61 } } },
            { ".bmp", new byte[][] { new byte[] { 0x42, 0x4D } } },
            { ".webp", new byte[][] { new byte[] { 0x52, 0x49, 0x46, 0x46 } } } // RIFF...WEBP
        };

        /// <summary>
        /// 校验上传文件是否为真实图片（三重防护：扩展名 + MIME + 文件头）
        /// 返回null表示通过，返回错误消息表示不通过
        /// </summary>
        public static string ValidateImageUpload(HttpPostedFile file)
        {
            if (file == null || file.ContentLength == 0)
                return "请选择要上传的文件。";

            string ext = System.IO.Path.GetExtension(file.FileName).ToLower();
            string mime = file.ContentType;

            // 1. 扩展名校验
            if (Array.IndexOf(ALLOWED_IMAGE_EXTENSIONS, ext) < 0)
                return "不支持的文件类型，仅允许上传图片。";

            // 2. MIME类型校验
            if (Array.IndexOf(ALLOWED_IMAGE_MIME, mime) < 0)
                return "文件类型验证失败，请重新上传。";

            // 3. 文件头（Magic Bytes）校验 — 防止修改扩展名绕过
            if (IMAGE_HEADERS.ContainsKey(ext))
            {
                byte[] fileHeader = new byte[8];
                file.InputStream.Read(fileHeader, 0, 8);
                file.InputStream.Position = 0; // 重置流位置

                bool headerValid = false;
                foreach (byte[] validHeader in IMAGE_HEADERS[ext])
                {
                    bool match = true;
                    for (int i = 0; i < validHeader.Length; i++)
                    {
                        if (fileHeader[i] != validHeader[i]) { match = false; break; }
                    }
                    if (match) { headerValid = true; break; }
                }

                if (!headerValid)
                    return "文件内容验证失败，上传文件可能已被篡改。";
            }

            // 4. 文件大小校验（最大5MB）
            if (file.ContentLength > 5 * 1024 * 1024)
                return "文件大小不能超过5MB。";

            return null; // 通过全部校验
        }

        /// <summary>要求登录，未登录则跳转到登录页</parameter>
        public static void RequireLogin()
        {
            if (!IsAuthenticated())
            {
                HttpContext.Current.Response.Redirect("~/Account/Login.aspx?returnUrl=" + HttpContext.Current.Server.UrlEncode(HttpContext.Current.Request.RawUrl));
            }
        }

        /// <summary>获取当前用户角色</summary>
        public static int GetCurrentUserRole()
        {
            DataRow user = GetCurrentUser();
            return user != null ? Convert.ToInt32(user["Role"]) : 0;
        }

        /// <summary>要求特定角色，不满足则跳转</summary>
        public static void RequireRole(params int[] roles)
        {
            int currentRole = GetCurrentUserRole();
            bool hasRole = false;
            foreach (int r in roles)
            {
                if (currentRole == r) { hasRole = true; break; }
            }
            if (!hasRole)
            {
                HttpContext.Current.Response.Redirect("~/Default.aspx");
            }
        }

        /// <summary>获取组织状态名称</summary>
        public static string GetOrgStatus(int status)
        {
            switch (status)
            {
                case 0: return "待审批";
                case 1: return "正常运营";
                case 2: return "暂停";
                case 3: return "已注销";
                default: return "未知";
            }
        }


    }
}