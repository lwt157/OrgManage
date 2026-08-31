using System;
using System.Data;
using System.Data.SqlClient;

namespace OrgManage.APP_Code
{
    /// <summary>
    /// 招新业务逻辑（已加入消息通知功能）
    /// </summary>
    public class RecruitBLL
    {
        /// <summary>获取招新中的公告列表</summary>
        public static DataTable GetActiveRecruitments(int orgID = 0)
        {
            string sql = @"SELECT r.RecruitID, r.Title, r.Content, r.Requirements, r.Quota,
                                  r.StartDate, r.EndDate, r.Status, o.OrgName, o.OrgID, c.CategoryName,
                                  (SELECT COUNT(1) FROM RecruitApps a WHERE a.RecruitID=r.RecruitID) AS AppCount
                           FROM Recruitments r
                           JOIN Organizations o ON r.OrgID=o.OrgID
                           JOIN OrgCategories c ON o.CategoryID=c.CategoryID
                           WHERE r.Status=1 AND r.EndDate>=GETDATE()";
            if (orgID > 0) sql += " AND r.OrgID=@OID";
            sql += " ORDER BY r.StartDate DESC";

            if (orgID > 0)
                return DbHelper.ExecuteQuery(sql, new SqlParameter("@OID", orgID));
            return DbHelper.ExecuteQuery(sql);
        }

        /// <summary>获取招新公告详情</summary>
        public static DataRow GetRecruitDetail(int recruitID)
        {
            string sql = @"SELECT r.*, o.OrgName, o.Description AS OrgDesc, c.CategoryName
                           FROM Recruitments r
                           JOIN Organizations o ON r.OrgID=o.OrgID
                           JOIN OrgCategories c ON o.CategoryID=c.CategoryID
                           WHERE r.RecruitID=@ID";
            var dt = DbHelper.ExecuteQuery(sql, new SqlParameter("@ID", recruitID));
            return dt.Rows.Count > 0 ? dt.Rows[0] : null;
        }

        /// <summary>发布招新公告</summary>
        public static int CreateRecruitment(int orgID, string title, string content,
                                            string requirements, int quota,
                                            DateTime startDate, DateTime endDate, int createBy)
        {
            string sql = @"INSERT INTO Recruitments(OrgID, Title, Content, Requirements, Quota, StartDate, EndDate, Status, CreateBy)
                           VALUES(@OID, @Title, @Content, @Req, @Quota, @SD, @ED, 1, @CreateBy)";
            return DbHelper.ExecuteInsertReturnID(sql,
                new SqlParameter("@OID", orgID),
                new SqlParameter("@Title", title),
                new SqlParameter("@Content", (object)content ?? DBNull.Value),
                new SqlParameter("@Req", (object)requirements ?? DBNull.Value),
                new SqlParameter("@Quota", quota),
                new SqlParameter("@SD", startDate),
                new SqlParameter("@ED", endDate),
                new SqlParameter("@CreateBy", createBy));
        }

        /// <summary>报名参加招新</summary>
        public static bool Apply(int recruitID, int userID, string selfIntro, string reason)
        {
            // 检查是否已报名
            var exists = DbHelper.ExecuteScalar(
                "SELECT COUNT(1) FROM RecruitApps WHERE RecruitID=@R AND UserID=@U",
                new SqlParameter("@R", recruitID), new SqlParameter("@U", userID));
            if (Convert.ToInt32(exists) > 0) return false;

            // 获取OrgID
            var orgResult = DbHelper.ExecuteScalar(
                "SELECT OrgID FROM Recruitments WHERE RecruitID=@R",
                new SqlParameter("@R", recruitID));
            if (orgResult == null) return false;
            int orgID = Convert.ToInt32(orgResult);

            int rows = DbHelper.ExecuteNonQuery(
                @"INSERT INTO RecruitApps(RecruitID, OrgID, UserID, SelfIntro, Reason, Status, ApplyTime)
                  VALUES(@R, @O, @U, @SI, @Reason, 0, GETDATE())",
                new SqlParameter("@R", recruitID),
                new SqlParameter("@O", orgID),
                new SqlParameter("@U", userID),
                new SqlParameter("@SI", (object)selfIntro ?? DBNull.Value),
                new SqlParameter("@Reason", (object)reason ?? DBNull.Value));
            return rows > 0;
        }

        /// <summary>获取某组织某招新的报名列表</summary>
        public static DataTable GetApplications(int recruitID)
        {
            return DbHelper.ExecuteQuery(
                @"SELECT a.AppID, u.StudentNo, u.UserName, u.College, a.SelfIntro, a.Reason,
                         a.Status, a.ApplyTime, a.ReviewNote, a.ReviewTime
                  FROM RecruitApps a
                  JOIN Users u ON a.UserID=u.UserID
                  WHERE a.RecruitID=@RID ORDER BY a.ApplyTime ASC",
                new SqlParameter("@RID", recruitID));
        }
    }
}