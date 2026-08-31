using System;
using System.Web.UI;
using OrgManage.APP_Code;

namespace OrgManage
{
    public partial class Orgs_Recruit : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var data = RecruitBLL.GetActiveRecruitments();
                rptRecruits.DataSource = data;
                rptRecruits.DataBind();
                panelEmpty.Visible = data.Rows.Count == 0;
            }
        }


        protected int GetQuotaPercent(object appCountObj, object quotaObj)
        {
            int appCount = Convert.ToInt32(appCountObj);
            int quota = Convert.ToInt32(quotaObj);

            // 名额不限（0）时，默认进度 0%
            if (quota == 0)
                return 0;

            double percent = (double)appCount / quota * 100;
            // 进度不超过 100%
            return percent > 100 ? 100 : (int)Math.Round(percent);
        }
    }
}
