using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;

namespace OrgManage.APP_Code
{
    /// <summary>
    /// 组织业务逻辑类 — 处理组织创建、审核、成员管理、收藏、解散等全部业务操作
    /// </summary>
    public class OrgBLL
    {

        /// <summary>直接添加成员到组织（跳过申请审核流程，通常由管理员操作）</summary>
        /// <param name="orgId">组织ID</param>
        /// <param name="studentNo">成员学号</param>
        /// <param name="userName">成员姓名</param>
        /// <param name="college">所属学院</param>
        public static void AddMemberDirect(int orgId, string studentNo, string userName, string college)
        {
            string sql = @"INSERT INTO OrgMembers (OrgID, StudentNo, UserName, College, MemberRole, JoinDate)
                   VALUES (@OrgID, @StudentNo, @UserName, @College, 1, GETDATE())";
            DbHelper.ExecuteNonQuery(sql,
                new SqlParameter("@OrgID", orgId),
                new SqlParameter("@StudentNo", studentNo),
                new SqlParameter("@UserName", userName),
                new SqlParameter("@College", college));
        }
        /// <summary>按成员ID删除成员（委托给 RemoveMemberById）</summary>
        /// <param name="memberId">成员记录ID</param>
        public static void RemoveMember(int memberId)
        {
            RemoveMemberById(memberId);
        }

        /// <summary>按成员ID从数据库物理删除</summary>
        /// <param name="memberId">成员记录ID</param>
        public static void RemoveMemberById(int memberId)
        {
            string sql = "DELETE FROM OrgMembers WHERE MemberID=@id";
            DbHelper.ExecuteNonQuery(sql, new System.Data.SqlClient.SqlParameter("@id", memberId));
        }

        /// <summary>发布组织公告</summary>
        /// <param name="title">公告标题</param>
        /// <param name="content">公告内容</param>
        /// <param name="publisherId">发布人用户ID</param>
        public static void PublishOrgAnnouncement(int orgId, string title, string content, int publisherId)
        {
            string sql = @"INSERT INTO OrgAnnouncements (OrgID, Title, Content, PublisherID, PublishTime)
                   VALUES (@orgId, @title, @content, @publisherId, GETDATE())";
            DbHelper.ExecuteNonQuery(sql,
                new SqlParameter("@orgId", orgId),
                new SqlParameter("@title", title),
                new SqlParameter("@content", content),
                new SqlParameter("@publisherId", publisherId));
        }

        public static DataTable GetOrgAnnouncements(int orgId)
        {
            string sql = @"SELECT a.AnnouncementID, a.Title, a.Content, a.PublishTime, u.UserName AS PublisherName
                   FROM OrgAnnouncements a
                   LEFT JOIN Users u ON a.PublisherID = u.UserID
                   WHERE a.OrgID = @OrgID
                   ORDER BY a.PublishTime DESC";
            return DbHelper.ExecuteQuery(sql, new SqlParameter("@OrgID", orgId));
        }

        /// <summary>删除组织公告（仅限该组织的负责人操作，删除时校验所属组织）</summary>
        public static void DeleteOrgAnnouncement(int announcementId, int orgId)
        {
            string sql = "DELETE FROM OrgAnnouncements WHERE AnnouncementID=@ID AND OrgID=@OrgID";
            DbHelper.ExecuteNonQuery(sql,
                new SqlParameter("@ID", announcementId),
                new SqlParameter("@OrgID", orgId));
        }

        public static DataTable GetActiveOrgs(int categoryID = 0, string keyword = "")
        {
            string sql = @"SELECT o.OrgID, o.OrgName, o.Description, o.LogoUrl, o.FoundedDate, o.CreateTime, o.MaxMembers, o.Status, c.CategoryName, u.UserName AS LeaderName, (SELECT COUNT(1) FROM OrgMembers m WHERE m.OrgID=o.OrgID AND m.Status=1) AS MemberCount,
                   (SELECT TOP 1 Title FROM OrgAnnouncements a WHERE a.OrgID=o.OrgID ORDER BY a.PublishTime DESC) AS LatestAnnTitle,
                   (SELECT TOP 1 PublishTime FROM OrgAnnouncements a WHERE a.OrgID=o.OrgID ORDER BY a.PublishTime DESC) AS LatestAnnTime
                   FROM Organizations o 
                   JOIN OrgCategories c ON o.CategoryID=c.CategoryID 
                   LEFT JOIN Users u ON o.LeaderID=u.UserID 
                   WHERE o.Status=1";

            if (categoryID > 0) sql += " AND o.CategoryID=@CatID";
            if (!string.IsNullOrEmpty(keyword)) sql += " AND (o.OrgName LIKE @KW OR o.Description LIKE @KW)";
            sql += " ORDER BY o.CreateTime DESC";

            var ps = new List<SqlParameter>();
            if (categoryID > 0) ps.Add(new SqlParameter("@CatID", categoryID));
            if (!string.IsNullOrEmpty(keyword)) ps.Add(new SqlParameter("@KW", "%" + keyword + "%"));

            return DbHelper.ExecuteQuery(sql, ps.ToArray());
        }

        public static DataRow GetOrgDetail(int orgID)
        {
            string sql = @"SELECT o.*, c.CategoryName, ul.UserName AS LeaderName, ua.UserName AS AdvisorName, (SELECT COUNT(1) FROM OrgMembers m WHERE m.OrgID=o.OrgID AND m.Status=1) AS MemberCount, (SELECT COUNT(1) FROM Activities a WHERE a.OrgID=o.OrgID AND a.Status IN(1,2,3)) AS ActivityCount FROM Organizations o JOIN OrgCategories c ON o.CategoryID=c.CategoryID LEFT JOIN Users ul ON o.LeaderID=ul.UserID LEFT JOIN Users ua ON o.AdvisorID=ua.UserID WHERE o.OrgID=@ID";
            var dt = DbHelper.ExecuteQuery(sql, new SqlParameter("@ID", orgID));
            return dt.Rows.Count > 0 ? dt.Rows[0] : null;
        }

        public static DataRow GetOrgById(int orgID)
        {
            string sql = "SELECT * FROM Organizations WHERE OrgID=@ID";
            DataTable dt = DbHelper.ExecuteQuery(sql, new SqlParameter("@ID", orgID));
            return dt.Rows.Count > 0 ? dt.Rows[0] : null;
        }

        public static int CreateOrg(string orgName, int categoryID, string description, int leaderID, string contactInfo, int maxMembers, string logoUrl)
        {
            // ========== 自动分配审核角色 ==========
            int auditorRole;
            if (categoryID == 1 || categoryID == 3)
            {
                auditorRole = 4; // 校级组织/校级社团 → role=4 审核
            }
            else
            {
                auditorRole = 5; // 院级组织/院级社团 → role=5 审核
            }

            string sql = @"INSERT INTO Organizations(OrgName, CategoryID, Description, MaxMembers, ContactInfo, LeaderID, Status, LogoUrl, AuditorRole) 
                   VALUES(@Name, @CatID, @Desc, @Max, @Contact, @Leader, 0, @LogoUrl, @AuditorRole)";
            int orgId = DbHelper.ExecuteInsertReturnID(sql,
                new SqlParameter("@Name", orgName),
                new SqlParameter("@CatID", categoryID),
                new SqlParameter("@Desc", (object)description ?? DBNull.Value),
                new SqlParameter("@Max", maxMembers),
                new SqlParameter("@Contact", (object)contactInfo ?? DBNull.Value),
                new SqlParameter("@Leader", leaderID),
                new SqlParameter("@LogoUrl", (object)logoUrl ?? DBNull.Value),
                new SqlParameter("@AuditorRole", auditorRole));

            if (orgId > 0)
            {
                MessageBLL.SendMessage(leaderID, "组织申请已提交", string.Format("你提交的【{0}】组织成立申请已成功提交，等待管理员审核！", orgName));
            }
            return orgId;
        }

        public static bool UpdateOrg(int orgID, string orgName, int categoryID, string description, string contactInfo, int maxMembers)
        {
            int rows = DbHelper.ExecuteNonQuery(@"UPDATE Organizations SET OrgName=@Name, CategoryID=@CatID, Description=@Desc, ContactInfo=@Contact, MaxMembers=@Max WHERE OrgID=@ID",
                new SqlParameter("@Name", orgName),
                new SqlParameter("@CatID", categoryID),
                new SqlParameter("@Desc", (object)description ?? DBNull.Value),
                new SqlParameter("@Contact", (object)contactInfo ?? DBNull.Value),
                new SqlParameter("@Max", maxMembers),
                new SqlParameter("@ID", orgID));
            return rows > 0;
        }

        public static void UpdateOrgInfo(int orgId, string name, string desc, string contact, int max, string logoUrl)
        {
            string sql = "UPDATE Organizations SET OrgName=@Name, Description=@Desc, ContactInfo=@Contact, MaxMembers=@Max";
            if (logoUrl != null) sql += ", LogoUrl=@Logo";
            sql += " WHERE OrgID=@OrgID";
            List<SqlParameter> ps = new List<SqlParameter>
            {
                new SqlParameter("@OrgID", orgId),
                new SqlParameter("@Name", name),
                new SqlParameter("@Desc", (object)desc ?? DBNull.Value),
                new SqlParameter("@Contact", (object)contact ?? DBNull.Value),
                new SqlParameter("@Max", max)
            };
            if (logoUrl != null) ps.Add(new SqlParameter("@Logo", logoUrl));
            DbHelper.ExecuteNonQuery(sql, ps.ToArray());
        }

        public static bool AddMember(int orgId, int userId)
        {
            string chk = "SELECT COUNT(*) FROM OrgMembers WHERE OrgID=@O AND UserID=@U";
            object cnt = DbHelper.ExecuteScalar(chk, new SqlParameter("@O", orgId), new SqlParameter("@U", userId));
            if (cnt != null && Convert.ToInt32(cnt) > 0)
                return false;

            string sql = "INSERT INTO OrgMembers(OrgID, UserID, JoinDate, MemberRole, Status) VALUES(@O, @U, GETDATE(), 1, 1)";
            return DbHelper.ExecuteNonQuery(sql, new SqlParameter("@O", orgId), new SqlParameter("@U", userId)) > 0;
        }

        public static void EnsureLeaderMember(int orgId, int leaderId)
        {
            string chk = "SELECT COUNT(*) FROM OrgMembers WHERE OrgID=@O AND UserID=@U";
            object cnt = DbHelper.ExecuteScalar(chk, new SqlParameter("@O", orgId), new SqlParameter("@U", leaderId));
            if (cnt != null && Convert.ToInt32(cnt) > 0)
            {
                DbHelper.ExecuteNonQuery(
                    "UPDATE OrgMembers SET MemberRole=3, Status=1 WHERE OrgID=@O AND UserID=@U",
                    new SqlParameter("@O", orgId), new SqlParameter("@U", leaderId));
            }
            else
            {
                DbHelper.ExecuteNonQuery(
                    "INSERT INTO OrgMembers(OrgID, UserID, JoinDate, MemberRole, Status) VALUES(@O, @U, GETDATE(), 3, 1)",
                    new SqlParameter("@O", orgId), new SqlParameter("@U", leaderId));
            }
        }

        public static void ApplyDisband(int orgId, string reason)
        {
            int userId = Utils.GetCurrentUserId();

            string getOrgSql = @"
        SELECT 
            o.OrgID, o.OrgName, o.LeaderID, 
            oc.CategoryName
        FROM Organizations o
        JOIN OrgCategories oc ON o.CategoryID = oc.CategoryID
        WHERE o.OrgID = @OrgID
    ";
            DataTable dt = DbHelper.ExecuteQuery(getOrgSql, new SqlParameter("@OrgID", orgId));

            if (dt.Rows.Count == 0)
                throw new Exception("组织不存在");

            DataRow org = dt.Rows[0];

            int leaderId = Convert.ToInt32(org["LeaderID"]);
            if (leaderId != userId)
                throw new Exception("只有社长才能提交解散申请！");

            string insertSql = @"
        INSERT INTO OrgDisbandRequests(OrgID, RequestUserID, Reason, Status, CreateTime) 
        VALUES(@OrgID, @RequestUserID, @Reason, 0, GETDATE())
    ";
            DbHelper.ExecuteNonQuery(insertSql,
                new SqlParameter("@OrgID", orgId),
                new SqlParameter("@RequestUserID", userId),
                new SqlParameter("@Reason", reason));

            string orgType = org["CategoryName"].ToString();
            string msg = string.Format("组织【{0}】(ID:{1}) 提交了解散申请，申请人（社长）ID：{2}，原因：{3}",
                org["OrgName"], orgId, userId, reason);

            if (orgType.Contains("校级"))
            {
                MessageBLL.SendAdminMessage("校级组织解散申请", msg, 4);
            }
            else
            {
                MessageBLL.SendAdminMessage("院级组织解散申请", msg, 3);
            }
        }
        public static bool ApproveOrg(int orgID, bool approved, string note, int approverID)
        {
            DataRow org = GetOrgDetail(orgID);
            string orgName = org != null ? org["OrgName"].ToString() : "组织";
            int leaderID = org != null ? Convert.ToInt32(org["LeaderID"]) : 0;
            int status = approved ? 1 : 3;

            int rows = DbHelper.ExecuteNonQuery(@"UPDATE Organizations SET Status=@S, ApproveNote=@N, ApproverID=@A, ApproveTime=GETDATE() WHERE OrgID=@ID",
                new SqlParameter("@S", status),
                new SqlParameter("@N", (object)note ?? DBNull.Value),
                new SqlParameter("@A", approverID),
                new SqlParameter("@ID", orgID));

            if (rows > 0 && leaderID > 0)
            {
                if (approved)
                {
                    DbHelper.ExecuteNonQuery(@"UPDATE Users SET Role=2 WHERE UserID=@ID AND Role=1",
                        new SqlParameter("@ID", leaderID));

                    EnsureLeaderMember(orgID, leaderID);

                    MessageBLL.SendMessage(leaderID, "组织申请已通过", string.Format("恭喜！你申请的【{0}】组织已成立成功，可开始运营！", orgName));
                }
                else
                {
                    MessageBLL.SendMessage(leaderID, "组织申请未通过", string.Format("你申请的【{0}】组织未通过审核，原因：{1}", orgName, note));
                }
            }
            return rows > 0;
        }

        public static DataTable GetPendingOrgs()
        {
            return DbHelper.ExecuteQuery(@"SELECT o.OrgID, o.OrgName, c.CategoryName, u.UserName AS LeaderName, o.CreateTime FROM Organizations o JOIN OrgCategories c ON o.CategoryID=c.CategoryID LEFT JOIN Users u ON o.LeaderID=u.UserID WHERE o.Status=0 ORDER BY o.CreateTime ASC");
        }

        public static DataTable GetAllOrgs()
        {
            return DbHelper.ExecuteQuery(@"SELECT o.OrgID, o.OrgName, c.CategoryName, o.Status, o.CreateTime, (SELECT COUNT(1) FROM OrgMembers m WHERE m.OrgID=o.OrgID AND m.Status=1) AS MemberCount FROM Organizations o JOIN OrgCategories c ON o.CategoryID=c.CategoryID ORDER BY o.Status, o.CreateTime DESC");
        }

        public static DataTable GetMyManagedOrgs(int userID)
        {
            return DbHelper.ExecuteQuery(@"SELECT o.OrgID, o.OrgName, c.CategoryName, o.Status, o.Description, o.LogoUrl, (SELECT COUNT(1) FROM OrgMembers m WHERE m.OrgID=o.OrgID AND m.Status=1) AS MemberCount FROM Organizations o JOIN OrgCategories c ON o.CategoryID=c.CategoryID WHERE o.LeaderID=@UID ORDER BY o.OrgName", new SqlParameter("@UID", userID));
        }

        public static DataTable GetMyJoinedOrgs(int userID)
        {
            return DbHelper.ExecuteQuery(@"SELECT o.OrgID, o.OrgName, c.CategoryName, m.MemberRole, m.JoinDate FROM OrgMembers m JOIN Organizations o ON m.OrgID=o.OrgID JOIN OrgCategories c ON o.CategoryID=c.CategoryID WHERE m.UserID=@UID AND m.Status=1 AND o.Status=1 ORDER BY m.JoinDate DESC", new SqlParameter("@UID", userID));
        }

        public static DataTable GetOrgMembers(int orgID)
        {
            return DbHelper.ExecuteQuery(@"SELECT m.MemberID, m.UserID, u.StudentNo, u.UserName, u.College, m.MemberRole, m.JoinDate, m.Status FROM OrgMembers m JOIN Users u ON m.UserID=u.UserID WHERE m.OrgID=@OID ORDER BY m.MemberRole DESC, m.JoinDate ASC", new SqlParameter("@OID", orgID));
        }

        public static bool ToggleFavorite(int userID, int orgID)
        {
            var exists = DbHelper.ExecuteScalar("SELECT COUNT(1) FROM OrgFavorites WHERE UserID=@U AND OrgID=@O", new SqlParameter("@U", userID), new SqlParameter("@O", orgID));
            if (Convert.ToInt32(exists) > 0) { DbHelper.ExecuteNonQuery("DELETE FROM OrgFavorites WHERE UserID=@U AND OrgID=@O", new SqlParameter("@U", userID), new SqlParameter("@O", orgID)); return false; }
            else { DbHelper.ExecuteNonQuery("INSERT INTO OrgFavorites(UserID, OrgID) VALUES(@U, @O)", new SqlParameter("@U", userID), new SqlParameter("@O", orgID)); return true; }
        }

        public static bool IsFavorited(int userID, int orgID)
        {
            var r = DbHelper.ExecuteScalar("SELECT COUNT(1) FROM OrgFavorites WHERE UserID=@U AND OrgID=@O", new SqlParameter("@U", userID), new SqlParameter("@O", orgID));
            return Convert.ToInt32(r) > 0;
        }

        public static DataTable GetMyFavorites(int userID)
        {
            return DbHelper.ExecuteQuery(@"SELECT o.OrgID, o.OrgName, c.CategoryName, f.FavTime FROM OrgFavorites f JOIN Organizations o ON f.OrgID=o.OrgID JOIN OrgCategories c ON o.CategoryID=c.CategoryID WHERE f.UserID=@UID AND o.Status=1 ORDER BY f.FavTime DESC", new SqlParameter("@UID", userID));
        }

        public static DataTable GetCategories()
        {
            return DbHelper.ExecuteQuery("SELECT * FROM OrgCategories ORDER BY CategoryID");
        }

        public static DataTable GetMyManageOrgs(int uid) { return GetMyManagedOrgs(uid); }
        public static void PublishAnnounce(int currentOrgID, string txtAnnTitle, string txtAnnContent) { PublishOrgAnnouncement(currentOrgID, txtAnnTitle, txtAnnContent, Utils.GetCurrentUserId()); }

        // ===================== 招新功能 =====================
        public static DataTable GetRecruitListByOrg(int currentOrgID)
        {
            string sql = @"SELECT r.RecruitID, r.Title, r.StartDate, r.EndDate,
            (SELECT COUNT(*) FROM RecruitApps WHERE RecruitID = r.RecruitID) AS AppCount
            FROM Recruitments r WHERE r.OrgID = @OID ORDER BY r.RecruitID DESC";
            return DbHelper.ExecuteQuery(sql, new SqlParameter("@OID", currentOrgID));
        }

        public static DataTable GetRecruitApplications(int rid)
        {
            string sql = @"SELECT a.AppID, a.UserID, u.StudentNo, u.UserName, u.College, a.SelfIntro, a.ApplyTime, a.Status
            FROM RecruitApps a JOIN Users u ON a.UserID=u.UserID WHERE a.RecruitID=@RID ORDER BY a.ApplyTime DESC";
            return DbHelper.ExecuteQuery(sql, new SqlParameter("@RID", rid));
        }
        public static bool AcceptApply(int appId)
        {
            DataRow app = DbHelper.ExecuteQuery("SELECT * FROM RecruitApps WHERE AppID=@ID", new SqlParameter("@ID", appId)).Rows[0];
            int recruitId = Convert.ToInt32(app["RecruitID"]);
            int userId = Convert.ToInt32(app["UserID"]);

            DataRow recruit = DbHelper.ExecuteQuery("SELECT OrgID, Title FROM Recruitments WHERE RecruitID=@RID", new SqlParameter("@RID", recruitId)).Rows[0];
            int orgId = Convert.ToInt32(recruit["OrgID"]);
            string recruitTitle = recruit["Title"].ToString();

            // ✅ 权限校验：当前用户必须是该组织的负责人
            int currentUserId = Utils.GetCurrentUserId();
            DataRow org = GetOrgById(orgId);
            if (org == null || Convert.ToInt32(org["LeaderID"]) != currentUserId)
            {
                throw new UnauthorizedAccessException("无权审批此报名申请");
            }

            int updateStatus = DbHelper.ExecuteNonQuery("UPDATE RecruitApps SET Status=1 WHERE AppID=@ID", new SqlParameter("@ID", appId));
            if (updateStatus <= 0)
                return false;

            bool added = AddMember(orgId, userId);
            if (!added)
            {
                return false;
            }

            // 发送录用通知
            string orgName = org["OrgName"].ToString();
            MessageBLL.SendMessage(
                userId,
                "招新申请已通过",
                string.Format("你报名的【{0} - {1}】已通过审核，欢迎加入！", orgName, recruitTitle)
            );

            return true;
        }

        public static void RejectApply(int appId)
        {
            // ✅ 权限校验：当前用户必须是该组织的负责人
            DataRow app = DbHelper.ExecuteQuery("SELECT a.UserID, a.AppID, r.OrgID, r.Title AS RecruitTitle FROM RecruitApps a JOIN Recruitments r ON a.RecruitID=r.RecruitID WHERE a.AppID=@ID", new SqlParameter("@ID", appId)).Rows[0];
            int orgId = Convert.ToInt32(app["OrgID"]);
            int userId = Convert.ToInt32(app["UserID"]);
            string recruitTitle = app["RecruitTitle"].ToString();

            int currentUserId = Utils.GetCurrentUserId();
            DataRow org = GetOrgById(orgId);
            if (org == null || Convert.ToInt32(org["LeaderID"]) != currentUserId)
            {
                throw new UnauthorizedAccessException("无权审批此报名申请");
            }

            DbHelper.ExecuteNonQuery("UPDATE RecruitApps SET Status=2 WHERE AppID=@ID", new SqlParameter("@ID", appId));

            // 发送拒绝通知
            string orgName = org["OrgName"].ToString();
            MessageBLL.SendMessage(
                userId,
                "招新申请未通过",
                string.Format("你报名的【{0} - {1}】未通过审核。", orgName, recruitTitle)
            );
        }

        public static int GetRecruitIDByApplyID(int appId)
        {
            return Convert.ToInt32(DbHelper.ExecuteScalar("SELECT RecruitID FROM RecruitApps WHERE AppID=@ID", new SqlParameter("@ID", appId)));
        }

        public static void CreateRecruit(int currentOrgID, string txtRecruitTitle, string txtRecruitContent, string txtRecruitReq, DateTime start, DateTime end, int q)
        {
            string sql = @"INSERT INTO Recruitments
            (OrgID, Title, Content, Requirements, StartDate, EndDate, Quota, Status, CreateBy, CreateTime)
            VALUES(@OID,@Title,@Content,@Req,@Start,@End,@Quota,1,@CreateBy,GETDATE())";

            DbHelper.ExecuteNonQuery(sql,
                new SqlParameter("@OID", currentOrgID),
                new SqlParameter("@Title", txtRecruitTitle),
                new SqlParameter("@Content", txtRecruitContent),
                new SqlParameter("@Req", txtRecruitReq),
                new SqlParameter("@Start", start),
                new SqlParameter("@End", end),
                new SqlParameter("@Quota", q),
                new SqlParameter("@CreateBy", Utils.GetCurrentUserId()));
        }

        public static void CreateActivity(int orgId, string title, string desc, string location, DateTime start, DateTime end, int max, int participationScope)
        {
            string sql = @"INSERT INTO Activities
                   (OrgID, Title, Description, Location, StartTime, EndTime, MaxEnroll, Status, CreateBy, CreateTime, ParticipationScope)
                   VALUES(@OID,@Title,@Desc,@Loc,@Start,@End,@Max,1,@CreateBy,GETDATE(),@Scope)";

            DbHelper.ExecuteNonQuery(sql,
                new SqlParameter("@OID", orgId),
                new SqlParameter("@Title", title),
                new SqlParameter("@Desc", desc),
                new SqlParameter("@Loc", location),
                new SqlParameter("@Start", start),
                new SqlParameter("@End", end),
                new SqlParameter("@Max", max),
                new SqlParameter("@CreateBy", Utils.GetCurrentUserId()),
                new SqlParameter("@Scope", participationScope)
            );
        }

        // ===================== 【已修复】活动列表 =====================
        public static DataTable GetActivityListByOrg(int orgId)
        {
            string sql = @"SELECT a.ActivityID, a.Title, a.Location, a.StartTime, 
                          a.MaxEnroll, COUNT(e.EnrollID) AS EnrollCount
                   FROM Activities a
                   LEFT JOIN ActivityEnrollments e ON a.ActivityID = e.ActivityID
                   WHERE a.OrgID = @OID AND a.Status = 1
                   GROUP BY a.ActivityID, a.Title, a.Location, a.StartTime, a.MaxEnroll
                   ORDER BY a.StartTime DESC";
            return DbHelper.ExecuteQuery(sql, new SqlParameter("@OID", orgId));
        }

        // ===================== 【已修复】活动报名名单 =====================
        public static DataTable GetActivityEnrollList(int activityId)
        {
            string sql = @"SELECT e.EnrollID, u.StudentNo, u.UserName, u.College, e.EnrollTime
                   FROM ActivityEnrollments e
                   JOIN Users u ON e.UserID = u.UserID
                   WHERE e.ActivityID = @AID";
            return DbHelper.ExecuteQuery(sql, new SqlParameter("@AID", activityId));
        }

        // 检查用户是否是组织成员
        public static bool IsMember(int orgId, int userId)
        {
            string sql = "SELECT COUNT(1) FROM OrgMembers WHERE OrgID=@O AND UserID=@U AND Status=1";
            object cnt = DbHelper.ExecuteScalar(sql, new SqlParameter("@O", orgId), new SqlParameter("@U", userId));
            return Convert.ToInt32(cnt) > 0;
        }

        // 获取组织所属学院
        public static string GetOrgCollege(int orgId)
        {
            string sql = "SELECT College FROM Organizations WHERE OrgID=@ID";
            object col = DbHelper.ExecuteScalar(sql, new SqlParameter("@ID", orgId));
            return col != null ? col.ToString() : "";
        }
        // ===================== 首页获取所有公告 =====================
        public static DataTable GetAllAnnouncements()
        {
            string sql = @"SELECT TOP 10 a.AnnouncementID, a.Title, a.Content, a.PublishTime, 
                   u.UserName AS PublisherName
                   FROM OrgAnnouncements a
                   LEFT JOIN Users u ON a.PublisherID=u.UserID
                   ORDER BY a.PublishTime DESC";
            return DbHelper.ExecuteQuery(sql);
        }
    }
}