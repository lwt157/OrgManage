using System;
using System.Data;
using System.Web.UI;
using System.Web;
using OrgManage.APP_Code;

namespace OrgManage
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadPageData();

            // 传递登录状态给前端
            bool loggedIn = Utils.IsLoggedIn();
            string js = "document.body.setAttribute('data-loggedin','" + (loggedIn ? "true" : "false") + "');";
            ClientScript.RegisterStartupScript(this.GetType(), "fbLoginStatus", js, true);
        }

        public string GetShortDescription(string desc)
        {
            if (desc == null)
                return "";
            if (desc.Length > 50)
                return desc.Substring(0, 50) + "...";
            else
                return desc;
        }

        private void LoadPageData()
        {
            var orgCount = DbHelper.ExecuteScalar("SELECT COUNT(1) FROM Organizations WHERE Status=1");
            litOrgCount.Text = (orgCount != null) ? orgCount.ToString() : "0";

            var actCount = DbHelper.ExecuteScalar("SELECT COUNT(1) FROM Activities WHERE Status IN(1,2,3)");
            litActivityCount.Text = (actCount != null) ? actCount.ToString() : "0";

            var memberCount = DbHelper.ExecuteScalar("SELECT COUNT(DISTINCT UserID) FROM OrgMembers WHERE Status=1");
            litMemberCount.Text = (memberCount != null) ? memberCount.ToString() : "0";

            var recruitCount = DbHelper.ExecuteScalar("SELECT COUNT(1) FROM Recruitments WHERE Status=1 AND EndDate>=GETDATE()");
            litRecruitCount.Text = (recruitCount != null) ? recruitCount.ToString() : "0";

            DataTable dtAnn = DbHelper.ExecuteQuery(
                "SELECT AnnID, Title, CreateTime FROM Announcements WHERE IsActive=1 ORDER BY CreateTime DESC");
            rpAnnouncements.DataSource = dtAnn;
            rpAnnouncements.DataBind();

            var orgs = DbHelper.ExecuteQuery(
                @"SELECT TOP 8 o.OrgID, o.OrgName, o.Description, o.LogoUrl, c.CategoryName,
                         (SELECT COUNT(1) FROM OrgMembers m WHERE m.OrgID=o.OrgID AND m.Status=1) AS MemberCount
                  FROM Organizations o JOIN OrgCategories c ON o.CategoryID=c.CategoryID
                  WHERE o.Status=1 ORDER BY NEWID()");
            rptOrgs.DataSource = orgs;
            rptOrgs.DataBind();

            var acts = DbHelper.ExecuteQuery(
                @"SELECT TOP 6 a.ActivityID, a.Title, a.Location, a.StartTime, o.OrgName
                  FROM Activities a JOIN Organizations o ON a.OrgID=o.OrgID
                  WHERE a.Status IN(1,2) AND a.EndTime >= GETDATE()
                  ORDER BY a.StartTime ASC");
            rptActivities.DataSource = acts;
            rptActivities.DataBind();

            var recruits = DbHelper.ExecuteQuery(
                @"SELECT TOP 6 r.RecruitID, r.Title, r.EndDate, o.OrgName, c.CategoryName
                  FROM Recruitments r JOIN Organizations o ON r.OrgID=o.OrgID
                  JOIN OrgCategories c ON o.CategoryID=c.CategoryID
                  WHERE r.Status=1 AND r.EndDate>=GETDATE()
                  ORDER BY r.StartDate DESC");
            rptRecruits.DataSource = recruits;
            rptRecruits.DataBind();
        }
    }
}
