using System;
using System.Data;
using System.Data.SqlClient;

namespace OrgManage.APP_Code
{
    /// <summary>
    /// 活动业务逻辑（已加入消息通知）
    /// </summary>
    public class ActivityBLL
    {
        /// <summary>获取已发布活动列表（首页）</summary>
        public static DataTable GetPublishedActivities(int orgID = 0, string keyword = "")
        {
            string sql = @"SELECT a.ActivityID, a.Title, a.Description, a.Location, a.StartTime, a.EndTime,
                                  a.MaxEnroll, a.Status, a.CoverUrl, o.OrgName, o.OrgID,
                                  (SELECT COUNT(1) FROM ActivityEnrollments e WHERE e.ActivityID=a.ActivityID AND e.Status=1) AS EnrolledCount
                           FROM Activities a
                           JOIN Organizations o ON a.OrgID=o.OrgID
                           WHERE a.Status IN(1,2,3)";
            var ps = new System.Collections.Generic.List<SqlParameter>();
            if (orgID > 0) { sql += " AND a.OrgID=@OID"; ps.Add(new SqlParameter("@OID", orgID)); }
            if (!string.IsNullOrEmpty(keyword)) { sql += " AND a.Title LIKE @KW"; ps.Add(new SqlParameter("@KW", "%" + keyword + "%")); }
            sql += " ORDER BY a.StartTime ASC";
            return DbHelper.ExecuteQuery(sql, ps.ToArray());
        }

        /// <summary>获取活动详情</summary>
        public static DataRow GetActivityDetail(int activityID)
        {
            string sql = @"SELECT a.*, o.OrgName, o.OrgID, u.UserName AS CreateByName,
                                  (SELECT COUNT(1) FROM ActivityEnrollments e WHERE e.ActivityID=a.ActivityID AND e.Status=1) AS EnrolledCount
                           FROM Activities a
                           JOIN Organizations o ON a.OrgID=o.OrgID
                           JOIN Users u ON a.CreateBy=u.UserID
                           WHERE a.ActivityID=@ID";
            var dt = DbHelper.ExecuteQuery(sql, new SqlParameter("@ID", activityID));
            return dt.Rows.Count > 0 ? dt.Rows[0] : null;
        }

        /// <summary>发布新活动（提交审批）</summary>
        public static int CreateActivity(int orgID, string title, string description,
                                         string location, DateTime startTime, DateTime endTime,
                                         int maxEnroll, int createBy)
        {
            string sql = @"INSERT INTO Activities(OrgID, Title, Description, Location, StartTime, EndTime, MaxEnroll, Status, CreateBy)
                           VALUES(@OID, @Title, @Desc, @Loc, @ST, @ET, @Max, 0, @CreateBy)";
            return DbHelper.ExecuteInsertReturnID(sql,
                new SqlParameter("@OID", orgID),
                new SqlParameter("@Title", title),
                new SqlParameter("@Desc", (object)description ?? DBNull.Value),
                new SqlParameter("@Loc", (object)location ?? DBNull.Value),
                new SqlParameter("@ST", startTime),
                new SqlParameter("@ET", endTime),
                new SqlParameter("@Max", maxEnroll),
                new SqlParameter("@CreateBy", createBy));
        }

        /// <summary>审批活动（指导老师/管理层）</summary>
        public static bool ApproveActivity(int activityID, bool approved, string note, int approverID)
        {
            int status = approved ? 1 : 5;
            int rows = DbHelper.ExecuteNonQuery(
                @"UPDATE Activities SET Status=@S, ApproveNote=@N, ApproveBy=@A, ApproveTime=GETDATE()
                  WHERE ActivityID=@ID",
                new SqlParameter("@S", status),
                new SqlParameter("@N", (object)note ?? DBNull.Value),
                new SqlParameter("@A", approverID),
                new SqlParameter("@ID", activityID));

            // ===================== 活动审批结果通知 =====================
            var activity = GetActivityDetail(activityID);
            if (activity != null)
            {
                int createUserID = Convert.ToInt32(activity["CreateBy"]);
                string activityTitle = activity["Title"].ToString();

                if (approved)
                {
                    // 审批通过
                    MessageBLL.SendMessage(
                        createUserID,
                        "活动审批通过",
                        string.Format("你发布的活动【{0}】已通过审批，现已正常开放报名！", activityTitle)
                    );
                }
                else
                {
                    // 审批拒绝
                    MessageBLL.SendMessage(
                        createUserID,
                        "活动审批未通过",
                        string.Format("你发布的活动【{0}】未通过审批，原因：{1}", activityTitle, note)
                    );
                }
            }
            // ============================================================

            return rows > 0;
        }

        /// <summary>管理员强制取消活动</summary>
        public static bool CancelActivity(int activityID, string reason)
        {
            int rows = DbHelper.ExecuteNonQuery(
                "UPDATE Activities SET Status=4 WHERE ActivityID=@ID",
                new SqlParameter("@ID", activityID));

            if (rows > 0)
            {
                var activity = GetActivityDetail(activityID);
                if (activity != null)
                {
                    int createUserID = Convert.ToInt32(activity["CreateBy"]);
                    string activityTitle = activity["Title"].ToString();
                    MessageBLL.SendMessage(
                        createUserID,
                        "活动已被取消",
                        string.Format("你发布的活动【{0}】已被管理员取消。{1}",
                            activityTitle,
                            string.IsNullOrEmpty(reason) ? "" : "原因：" + reason)
                    );

                    // 通知所有已报名用户
                    string sqlEnrolls = @"SELECT UserID FROM ActivityEnrollments WHERE ActivityID=@AID AND Status=1";
                    DataTable dtEnrolls = DbHelper.ExecuteQuery(sqlEnrolls, new SqlParameter("@AID", activityID));
                    foreach (DataRow row in dtEnrolls.Rows)
                    {
                        int uid = Convert.ToInt32(row["UserID"]);
                        MessageBLL.SendMessage(
                            uid,
                            "活动取消通知",
                            string.Format("你报名的活动【{0}】已被取消，敬请留意。", activityTitle)
                        );
                    }
                }
            }
            return rows > 0;
        }

        /// <summary>管理员恢复活动</summary>
        public static bool RestoreActivity(int activityID)
        {
            int rows = DbHelper.ExecuteNonQuery(
                "UPDATE Activities SET Status=1 WHERE ActivityID=@ID",
                new SqlParameter("@ID", activityID));

            if (rows > 0)
            {
                var activity = GetActivityDetail(activityID);
                if (activity != null)
                {
                    int createUserID = Convert.ToInt32(activity["CreateBy"]);
                    string activityTitle = activity["Title"].ToString();
                    MessageBLL.SendMessage(
                        createUserID,
                        "活动已恢复",
                        string.Format("你发布的活动【{0}】已被管理员恢复，现可正常报名。", activityTitle)
                    );
                }
            }
            return rows > 0;
        }

        /// <summary>活动报名</summary>
        public static bool Enroll(int activityID, int userID)
        {
            // 检查是否已报名
            var exists = DbHelper.ExecuteScalar(
                "SELECT COUNT(1) FROM ActivityEnrollments WHERE ActivityID=@A AND UserID=@U",
                new SqlParameter("@A", activityID), new SqlParameter("@U", userID));
            if (Convert.ToInt32(exists) > 0)
            {
                // 重新激活（如之前取消过）
                DbHelper.ExecuteNonQuery(
                    "UPDATE ActivityEnrollments SET Status=1, EnrollTime=GETDATE() WHERE ActivityID=@A AND UserID=@U",
                    new SqlParameter("@A", activityID), new SqlParameter("@U", userID));

                // ===================== 报名成功通知 =====================
                var activity = GetActivityDetail(activityID);
                if (activity != null)
                {
                    MessageBLL.SendMessage(
                        userID,
                        "活动报名成功",
                        string.Format("你已成功报名活动【{0}】，活动时间：{1:yyyy-MM-dd HH:mm}",
                            activity["Title"], activity["StartTime"])
                    );
                }
                // ========================================================
                return true;
            }

            // 检查名额
            var activityInfo = GetActivityDetail(activityID);
            if (activityInfo == null) return false;
            int maxEnroll = Convert.ToInt32(activityInfo["MaxEnroll"]);
            int enrolled = Convert.ToInt32(activityInfo["EnrolledCount"]);
            if (maxEnroll > 0 && enrolled >= maxEnroll) return false; // 名额已满

            int rowAffected = DbHelper.ExecuteNonQuery(
                "INSERT INTO ActivityEnrollments(ActivityID, UserID) VALUES(@A, @U)",
                new SqlParameter("@A", activityID), new SqlParameter("@U", userID));

            // ===================== 报名成功通知 =====================
            if (rowAffected > 0)
            {
                MessageBLL.SendMessage(
                    userID,
                    "活动报名成功",
                    string.Format("你已成功报名活动【{0}】，活动时间：{1:yyyy-MM-dd HH:mm}",
                        activityInfo["Title"], activityInfo["StartTime"])
                );
            }
            // ========================================================
            return rowAffected > 0;
        }

        /// <summary>取消报名</summary>
        public static bool CancelEnroll(int activityID, int userID)
        {
            int rows = DbHelper.ExecuteNonQuery(
                "UPDATE ActivityEnrollments SET Status=0 WHERE ActivityID=@A AND UserID=@U",
                new SqlParameter("@A", activityID), new SqlParameter("@U", userID));

            // ===================== 取消报名通知 =====================
            if (rows > 0)
            {
                var activity = GetActivityDetail(activityID);
                if (activity != null)
                {
                    MessageBLL.SendMessage(
                        userID,
                        "活动报名已取消",
                        string.Format("你已成功取消活动【{0}】的报名", activity["Title"])
                    );
                }
            }
            // ========================================================
            return rows > 0;
        }

        /// <summary>是否已报名</summary>
        public static bool IsEnrolled(int activityID, int userID)
        {
            var r = DbHelper.ExecuteScalar(
                "SELECT COUNT(1) FROM ActivityEnrollments WHERE ActivityID=@A AND UserID=@U AND Status=1",
                new SqlParameter("@A", activityID), new SqlParameter("@U", userID));
            return Convert.ToInt32(r) > 0;
        }

        /// <summary>获取活动报名人员列表</summary>
        public static DataTable GetActivityEnrollments(int activityID)
        {
            return DbHelper.ExecuteQuery(
                @"SELECT u.StudentNo, u.UserName, u.College, e.EnrollTime
                  FROM ActivityEnrollments e
                  JOIN Users u ON e.UserID=u.UserID
                  WHERE e.ActivityID=@AID AND e.Status=1
                  ORDER BY e.EnrollTime ASC",
                new SqlParameter("@AID", activityID));
        }

        /// <summary>获取待审批活动</summary>
        public static DataTable GetPendingActivities()
        {
            return DbHelper.ExecuteQuery(
                @"SELECT a.ActivityID, a.Title, o.OrgName, a.StartTime, a.EndTime, a.Location, a.CreateTime, u.UserName AS CreateByName
                  FROM Activities a
                  JOIN Organizations o ON a.OrgID=o.OrgID
                  JOIN Users u ON a.CreateBy=u.UserID
                  WHERE a.Status=0 ORDER BY a.CreateTime ASC");
        }

        /// <summary>获取我报名的活动</summary>
        public static DataTable GetMyEnrolledActivities(int userID)
        {
            return DbHelper.ExecuteQuery(
                @"SELECT a.ActivityID, a.Title, a.StartTime, a.EndTime, a.Location, a.Status, o.OrgName, e.EnrollTime
                  FROM ActivityEnrollments e
                  JOIN Activities a ON e.ActivityID=a.ActivityID
                  JOIN Organizations o ON a.OrgID=o.OrgID
                  WHERE e.UserID=@UID AND e.Status=1
                  ORDER BY a.StartTime DESC",
                new SqlParameter("@UID", userID));
        }
    }
}