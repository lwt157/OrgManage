using System;
using System.Data;
using System.Web.UI;
using OrgManage.APP_Code;
using System.Data.SqlClient;
using System.Configuration;

namespace OrgManage
{
    /// <summary>
    /// 活动列表页面
    /// 功能：展示所有活动、搜索筛选、显示统计数据、活动状态样式控制
    /// </summary>
    public partial class Activities_List : Page
    {
        // 数据库连接字符串
        private static string connStr = ConfigurationManager.ConnectionStrings["OrgManageDB"].ConnectionString;

        /// <summary>
        /// 页面加载：首次访问时加载活动列表和统计数据
        /// </summary>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadActivities();      // 加载活动列表数据
                BindActivityStats();  // 加载顶部统计数字
            }
        }

        /// <summary>
        /// 绑定活动统计数据（总活动数量）
        /// 查询数据库，统计状态为有效（进行中/已结束）的活动总数
        /// </summary>
        private void BindActivityStats()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                // 查询总活动数（排除已删除的）
                SqlCommand cmdTotal = new SqlCommand(@"
                    SELECT COUNT(*) 
                    FROM Activities 
                    WHERE Status IN (1,2,3)", conn);
                litTotal.Text = cmdTotal.ExecuteScalar().ToString();
            }
        }

        /// <summary>
        /// 根据活动状态，返回对应的CSS样式类（控制进度条颜色）
        /// </summary>
        protected string GetStatusBarClass(int status)
        {
            if (status == 1) return "status-open";    // 进行中
            if (status == 0) return "status-pending"; // 未开始
            return "status-closed";                    // 已结束
        }

        /// <summary>
        /// 根据活动状态，返回标签样式（复用上面的逻辑）
        /// </summary>
        protected string GetStatusBadgeClass(int status)
        {
            return GetStatusBarClass(status);
        }

        /// <summary>
        /// 计算报名进度百分比
        /// 用于前端显示报名进度条
        /// </summary>
        protected int GetEnrollPercent(object enrolled, object maxEnroll)
        {
            int e = Convert.ToInt32(enrolled);   // 已报名人数
            int m = Convert.ToInt32(maxEnroll);  // 最大名额

            // 无上限则按比例估算，有上限则计算真实百分比
            if (m <= 0) return Math.Min(e * 3, 80);
            return Math.Min((int)(e * 100.0 / m), 100);
        }

        /// <summary>
        /// 加载活动列表（核心方法）
        /// 支持：按组织筛选、关键词搜索、只显示已发布活动
        /// </summary>
        private void LoadActivities()
        {
            int orgID = 0;
            int.TryParse(Request.QueryString["org"], out orgID); // 可选：按组织筛选
            string kw = txtKeyword.Text.Trim();                  // 搜索关键词

            // 调用BLL层获取数据
            var acts = ActivityBLL.GetPublishedActivities(orgID, kw);
            rptActs.DataSource = acts;  // 绑定到 repeater 控件
            rptActs.DataBind();
            panelEmpty.Visible = acts.Rows.Count == 0; // 无数据时显示空提示
        }

        /// <summary>
        /// 搜索按钮点击：重新加载活动列表
        /// </summary>
        protected void BtnSearch_Click(object sender, EventArgs e)
        {
            LoadActivities();
        }
    }
}