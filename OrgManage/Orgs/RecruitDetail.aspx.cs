using System;
using System.Data;
using System.Web.UI;
using OrgManage.APP_Code;

namespace OrgManage
{
    public partial class Orgs_RecruitDetail : Page
    {
        private int _recruitID;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!int.TryParse(Request.QueryString["id"], out _recruitID))
            {
                ShowNotFound();
                return;
            }
            if (!IsPostBack)
                LoadData();
        }

        private void LoadData()
        {
            var row = RecruitBLL.GetRecruitDetail(_recruitID);
            if (row == null)
            {
                ShowNotFound();
                return;
            }

            litTitle.Text = Utils.HtmlEncode(row["Title"].ToString());
            litCategory.Text = row["CategoryName"].ToString();
            litOrgName.Text = Utils.HtmlEncode(row["OrgName"].ToString());
            litEndDate.Text = Convert.ToDateTime(row["EndDate"]).ToString("yyyy-MM-dd");
            litQuota.Text = Convert.ToInt32(row["Quota"]) == 0 ? "不限" : row["Quota"].ToString() + "人";
            litContent.Text = Utils.HtmlEncode(row["Content"].ToString()).Replace("\n", "<br/>");
            litRequirements.Text = Utils.HtmlEncode(row["Requirements"].ToString()).Replace("\n", "<br/>");

            panelMain.Visible = true;
            panelNotFound.Visible = false;

            if (!Utils.IsAuthenticated())
            {
                hlLogin.NavigateUrl = "~/Account/Login.aspx?returnUrl=" +
                    Server.UrlEncode(Request.Url.AbsoluteUri);
                hlLogin.Visible = true;
                panelForm.Visible = false;
                return;
            }

            hlLogin.Visible = false;

            // 检查是否已报名
            int uid = Utils.GetCurrentUserId();
            var applied = DbHelper.ExecuteScalar(
                "SELECT COUNT(1) FROM RecruitApps WHERE RecruitID=@R AND UserID=@U",
                new System.Data.SqlClient.SqlParameter("@R", _recruitID),
                new System.Data.SqlClient.SqlParameter("@U", uid));
            if (Convert.ToInt32(applied) > 0)
            {
                panelApplied.Visible = true;
                panelForm.Visible = false;
            }
        }

        protected void BtnApply_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            Utils.RequireLogin();

            bool ok = RecruitBLL.Apply(_recruitID, Utils.GetCurrentUserId(),
                txtSelfIntro.Text.Trim(), txtReason.Text.Trim());

            if (ok)
            {
                panelMsg.Visible = false;
                panelForm.Visible = false;
                panelApplied.Visible = true;
            }
            else
            {
                
                panelMsg.Visible = true;
                panelMsg.CssClass = "alert alert-danger small";
                panelMsg.Controls.Clear();
                panelMsg.Controls.Add(new System.Web.UI.LiteralControl("报名失败，您可能已报名过该活动。"));
            }
        }

        private void ShowNotFound()
        {
            panelNotFound.Visible = true;
            panelMain.Visible = false;
        }
    }
}