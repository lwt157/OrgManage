using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using OrgManage.APP_Code;
using System.Data;
/// <summary>
/// MessageBLL 的摘要说明
/// </summary>
public static class MessageBLL
{
    // 获取用户所有消息
    public static DataTable GetUserMessages(int userId)
    {
        string sql = @"SELECT MsgID, Title, Content, IsRead, CreateTime 
                      FROM UserMessages 
                      WHERE UserID = @UserID AND IsDeleted = 0
                      ORDER BY CreateTime DESC";
        SqlParameter[] paras = { new SqlParameter("@UserID", userId) };
        return DbHelper.ExecuteQuery(sql, paras);
    }

    // 获取未读消息数量
    public static int GetUnreadCount(int userId)
    {
        string sql = @"SELECT COUNT(*) FROM UserMessages 
                      WHERE UserID = @UserID AND IsRead = 0 AND IsDeleted = 0";
        SqlParameter[] paras = { new SqlParameter("@UserID", userId) };
        return Convert.ToInt32(DbHelper.ExecuteScalar(sql, paras));
    }

    // 标记单条为已读
    public static void MarkAsRead(int msgId)
    {
        string sql = "UPDATE UserMessages SET IsRead = 1 WHERE MsgID = @MsgID";
        SqlParameter[] paras = { new SqlParameter("@MsgID", msgId) };
        DbHelper.ExecuteNonQuery(sql, paras);
    }

    // 全部标为已读
    public static void MarkAllAsRead(int userId)
    {
        string sql = "UPDATE UserMessages SET IsRead = 1 WHERE UserID = @UserID AND IsRead = 0";
        SqlParameter[] paras = { new SqlParameter("@UserID", userId) };
        DbHelper.ExecuteNonQuery(sql, paras);
    }

    // 删除消息（软删除）
    public static void DeleteMessage(int msgId)
    {
        string sql = "UPDATE UserMessages SET IsDeleted = 1 WHERE MsgID = @MsgID";
        SqlParameter[] paras = { new SqlParameter("@MsgID", msgId) };
        DbHelper.ExecuteNonQuery(sql, paras);
    }

    // 清空当前用户所有消息（软删除）
    public static void ClearAllMessages(int userId)
    {
        string sql = "UPDATE UserMessages SET IsDeleted = 1 WHERE UserID = @UserID";
        SqlParameter[] paras = { new SqlParameter("@UserID", userId) };
        DbHelper.ExecuteNonQuery(sql, paras);
    }

    // 发送消息（给其他模块调用）
    public static void SendMessage(int userId, string title, string content)
    {
        string sql = @"INSERT INTO UserMessages (UserID, Title, Content) 
                      VALUES (@UserID, @Title, @Content)";
        SqlParameter[] paras = {
            new SqlParameter("@UserID", userId),
            new SqlParameter("@Title", title),
            new SqlParameter("@Content", content)
        };
        DbHelper.ExecuteNonQuery(sql, paras);
    }

    // 按角色发送管理员消息：3=院级管理员 4=校级管理员
    public static void SendAdminMessage(string title, string content, int targetRole)
    {
        string sql = @"
            INSERT INTO UserMessages (UserID, Title, Content, CreateTime, IsRead)
            SELECT UserID, @Title, @Content, GETDATE(), 0 
            FROM Users 
            WHERE Role = @Role
        ";

        SqlParameter[] paras = {
            new SqlParameter("@Title", title),
            new SqlParameter("@Content", content),
            new SqlParameter("@Role", targetRole)
        };

        DbHelper.ExecuteNonQuery(sql, paras);
    }
}