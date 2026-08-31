using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using OrgManage.APP_Code;




namespace OrgManage.APP_Code

{
    /// <summary>
    /// 数据库访问辅助类 - 封装常用ADO.NET操作
    /// </summary>
    public class DbHelper
    {
        private static readonly string _connStr =
            ConfigurationManager.ConnectionStrings["OrgManageDB"].ConnectionString;

        /// <summary>获取新的数据库连接</summary>
        public static SqlConnection GetConnection()
        {
            return new SqlConnection(_connStr);
        }

        /// <summary>执行查询，返回DataTable</summary>
        public static DataTable ExecuteQuery(string sql, params SqlParameter[] parameters)
        {
            var dt = new DataTable();
            using (var conn = GetConnection())
            using (var cmd = new SqlCommand(sql, conn))
            {
                if (parameters != null)
                    cmd.Parameters.AddRange(parameters);
                conn.Open();
                using (var adapter = new SqlDataAdapter(cmd))
                    adapter.Fill(dt);
            }
            return dt;
        }

        /// <summary>执行非查询命令（INSERT/UPDATE/DELETE），返回受影响行数</summary>
        public static int ExecuteNonQuery(string sql, params SqlParameter[] parameters)
        {
            using (var conn = GetConnection())
            using (var cmd = new SqlCommand(sql, conn))
            {
                if (parameters != null)
                    cmd.Parameters.AddRange(parameters);
                conn.Open();
                return cmd.ExecuteNonQuery();
            }
        }

        /// <summary>执行查询，返回第一行第一列值</summary>
        public static object ExecuteScalar(string sql, params SqlParameter[] parameters)
        {
            using (var conn = GetConnection())
            using (var cmd = new SqlCommand(sql, conn))
            {
                if (parameters != null)
                    cmd.Parameters.AddRange(parameters);
                conn.Open();
                return cmd.ExecuteScalar();
            }
        }

        /// <summary>执行SQL并返回新插入行的ID（SCOPE_IDENTITY）</summary>
        public static int ExecuteInsertReturnID(string sql, params SqlParameter[] parameters)
        {
            sql = sql.TrimEnd(';') + "; SELECT SCOPE_IDENTITY();";
            using (var conn = GetConnection())
            using (var cmd = new SqlCommand(sql, conn))
            {
                if (parameters != null)
                    cmd.Parameters.AddRange(parameters);
                conn.Open();
                var result = cmd.ExecuteScalar();
                return result != null && result != DBNull.Value ? Convert.ToInt32(result) : 0;
            }
        }

        /// <summary>执行存储过程，返回DataTable</summary>
        public static DataTable ExecuteStoredProc(string procName, params SqlParameter[] parameters)
        {
            var dt = new DataTable();
            using (var conn = GetConnection())
            using (var cmd = new SqlCommand(procName, conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                if (parameters != null)
                    cmd.Parameters.AddRange(parameters);
                conn.Open();
                using (var adapter = new SqlDataAdapter(cmd))
                    adapter.Fill(dt);
            }
            return dt;
        }
    }
}