using System;
using System.Data;
using System.Web.UI;
using OrgManage.APP_Code;


namespace OrgManage
{
    public partial class Orgs_Detail : Page
    {
        private int _orgID;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!int.TryParse(Request.QueryString["id"], out _orgID))
            { ShowNotFound(); return; }

            if (!IsPostBack)
                LoadData();
        }

        private void LoadData()
        {
            var row = OrgBLL.GetOrgDetail(_orgID);
            if (row == null) { ShowNotFound(); return; }

            panelDetail.Visible = true;
            panelNotFound.Visible = false;

            // 基本信息
            litOrgName.Text = Utils.HtmlEncode(row["OrgName"].ToString());
            litName.Text = Utils.HtmlEncode(row["OrgName"].ToString());
            litCategory.Text = row["CategoryName"].ToString();
            litStatus.Text = Utils.GetOrgStatus(Convert.ToInt32(row["Status"]));
            litDescription.Text = Utils.HtmlEncode(row["Description"].ToString()).Replace("\n", "<br/>");
            litMemberCount.Text = row["MemberCount"].ToString();
            litActivityCount.Text = row["ActivityCount"].ToString();
            litLeader.Text = row["LeaderName"] == DBNull.Value ? "暂无" : Utils.HtmlEncode(row["LeaderName"].ToString());
            litAdvisor.Text = row["AdvisorName"] == DBNull.Value ? "暂无" : Utils.HtmlEncode(row["AdvisorName"].ToString());
            litMax.Text = row["MaxMembers"].ToString();
            litContact.Text = row["ContactInfo"] == DBNull.Value ? "暂无" : Utils.HtmlEncode(row["ContactInfo"].ToString());
            litFounded.Text = row["FoundedDate"] != DBNull.Value ? Convert.ToDateTime(row["FoundedDate"]).Year.ToString() : "--";

            // Logo
            if (row["LogoUrl"] != DBNull.Value && !string.IsNullOrEmpty(row["LogoUrl"].ToString()))
                imgLogo.ImageUrl = ResolveUrl(row["LogoUrl"].ToString());
            else
                imgLogo.ImageUrl = ResolveUrl("~/images/default_org.png");

            // 收藏按钮
            if (Utils.IsAuthenticated())
            {
                bool faved = OrgBLL.IsFavorited(Utils.GetCurrentUserId(), _orgID);
                btnFav.Text = faved ? "★ 已收藏" : "☆ 收藏";
                btnFav.CssClass = faved ? "btn btn-warning btn-sm" : "btn btn-outline-warning btn-sm";
            }
            else btnFav.Visible = false;

            // 组织公告
            var anns = OrgBLL.GetOrgAnnouncements(_orgID);
            rptAnnouncements.DataSource = anns;
            rptAnnouncements.DataBind();
            panelNoAnn.Visible = anns.Rows.Count == 0;

            // 近期活动
            var acts = DbHelper.ExecuteQuery(
                @"SELECT TOP 5 ActivityID, Title, Location, StartTime FROM Activities
              WHERE OrgID=@OID AND Status IN(1,2,3) ORDER BY StartTime ASC",
                new System.Data.SqlClient.SqlParameter("@OID", _orgID));
            rptActivities.DataSource = acts;
            rptActivities.DataBind();
            panelNoAct.Visible = acts.Rows.Count == 0;

            // 招新
            var recruits = RecruitBLL.GetActiveRecruitments(_orgID);
            if (recruits.Rows.Count > 0)
            {
                rptRecruit.DataSource = recruits;
                rptRecruit.DataBind();
                panelRecruit.Visible = true;
            }
            else panelRecruit.Visible = false;

            // 成员（最多10人）
            var members = DbHelper.ExecuteQuery(
                @"SELECT TOP 10 u.UserName, m.MemberRole FROM OrgMembers m
              JOIN Users u ON m.UserID=u.UserID
              WHERE m.OrgID=@OID AND m.Status=1 ORDER BY m.MemberRole DESC",
                new System.Data.SqlClient.SqlParameter("@OID", _orgID));
            rptMembers.DataSource = members;
            rptMembers.DataBind();
        }

        protected void BtnFav_Click(object sender, EventArgs e)
        {
            if (!Utils.IsAuthenticated()) { Response.Redirect("~/Account/Login.aspx"); return; }
            bool faved = OrgBLL.ToggleFavorite(Utils.GetCurrentUserId(), _orgID);
            btnFav.Text = faved ? "★ 已收藏" : "☆ 收藏";
            btnFav.CssClass = faved ? "btn btn-warning btn-sm" : "btn btn-outline-warning btn-sm";
        }

        private void ShowNotFound()
        {
            panelNotFound.Visible = true;
            panelDetail.Visible = false;
        }
    }
}
