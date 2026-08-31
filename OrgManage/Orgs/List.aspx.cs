using System;
using System.Data;
using System.Web.UI;
using OrgManage.APP_Code;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Configuration;

namespace OrgManage
{
    public partial class Orgs_List : Page
    {
        // 数据库连接字符串
        string connStr = ConfigurationManager.ConnectionStrings["OrgManageDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategories();

                if (!string.IsNullOrEmpty(Request.QueryString["cat"]))
                    ddlCategory.SelectedValue = Request.QueryString["cat"];

                LoadOrgs();

                // ↓↓↓ 只加了这一行 ↓↓↓
                BindTopStats();
            }
        }

        // =========================
        // 绑定顶部统计：组织总数、覆盖成员、正在招新
        // =========================
        private void BindTopStats()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // 1. 组织总数（正常状态 Status=1）
                SqlCommand cmd1 = new SqlCommand(@"SELECT COUNT(*) FROM Organizations WHERE Status=1", conn);
                litOrgCount.Text = cmd1.ExecuteScalar().ToString();

                // 2. 覆盖成员（在任成员 Status=1）
                SqlCommand cmd2 = new SqlCommand(@"SELECT COUNT(*) FROM OrgMembers WHERE Status=1", conn);
                litMemberCount.Text = cmd2.ExecuteScalar().ToString();

                // 3. 正在招新（招新中 Status=1）
                SqlCommand cmd3 = new SqlCommand(@"SELECT COUNT(*) FROM Recruitments WHERE Status=1", conn);
                litRecruiting.Text = cmd3.ExecuteScalar().ToString();
            }
        }

        protected string GetCategoryIcon(string categoryName)
        {
            Dictionary<string, string> icons = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
            icons.Add("学术", "bi bi-book");
            icons.Add("艺术", "bi bi-palette");
            icons.Add("体育", "bi bi-dribbble");
            icons.Add("志愿", "bi bi-heart");
            icons.Add("科技", "bi bi-cpu");
            icons.Add("音乐", "bi bi-music-note");

            foreach (var kv in icons)
                if (categoryName.Contains(kv.Key))
                    return kv.Value;

            return "";
        }

        protected int GetMemberPercent(object memberCount)
        {
            int m = Convert.ToInt32(memberCount);
            return Math.Min(m / 5, 100);
        }

        protected string GetShortMemberCount(object memberCount)
        {
            int m = Convert.ToInt32(memberCount);
            return m >= 100 ? (m / 100) + "百+" : m.ToString();
        }

        protected bool IsHotOrg(object memberCount)
        {
            return Convert.ToInt32(memberCount) >= 200;
        }

        protected bool IsNewOrg(object createTime)
        {
            if (createTime == DBNull.Value) return false;
            DateTime dt = Convert.ToDateTime(createTime);
            return (DateTime.Now - dt).TotalDays <= 90;
        }

        private void LoadCategories()
        {
            DataTable cats = OrgBLL.GetCategories();
            ddlCategory.Items.Clear();
            ddlCategory.Items.Add(new System.Web.UI.WebControls.ListItem("-- 全部组织类型 --", "0"));
            foreach (DataRow row in cats.Rows)
                ddlCategory.Items.Add(new System.Web.UI.WebControls.ListItem(row["CategoryName"].ToString(), row["CategoryID"].ToString()));
        }

        private void LoadOrgs()
        {
            int c;
            int catID = int.TryParse(ddlCategory.SelectedValue, out c) ? c : 0;
            string keyword = txtKeyword.Text.Trim();
            DataTable orgs = OrgBLL.GetActiveOrgs(catID, keyword);
            litCount.Text = orgs.Rows.Count.ToString();

            if (orgs.Rows.Count == 0)
            {
                rptOrgs.DataSource = null;
                rptOrgs.DataBind();
                panelEmpty.Visible = true;
            }
            else
            {
                rptOrgs.DataSource = orgs;
                rptOrgs.DataBind();
                panelEmpty.Visible = false;
            }

            DataTable cats = OrgBLL.GetCategories();
            rptCategories.DataSource = cats;
            rptCategories.DataBind();
        }

        protected void BtnSearch_Click(object sender, EventArgs e)
        {
            LoadOrgs();
        }
    }
}