using System;
using System.IO;
using System.Data;
using System.Web.UI;
using OrgManage.APP_Code;
using System.Data.SqlClient;

namespace OrgManage
{
    public partial class Orgs_Apply : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Utils.RequireLogin();
            if (!IsPostBack)
            {
                int role = Utils.GetCurrentUserRole();
                if (!(role == 1 || role == 2))
                {
                    panelMsg.Visible = true;
                    panelMsg.CssClass = "alert alert-danger";
                    panelMsg.Controls.Add(new LiteralControl("只有学生和组织管理者可以申请创建组织！"));
                    btnSubmit.Enabled = false;
                    return;
                }

                LoadCategories();
                UpdateCollegeFieldState(); // 初始化学院状态
            }

            // 每次加载都更新状态，确保切换下拉框立刻生效
            UpdateCollegeFieldState();
        }

        /// <summary>
        /// 核心：根据组织类型 自动启用/禁用 学院输入框
        /// 1=校级  2=院级  3=社团  4=院级社团
        /// </summary>
        private void UpdateCollegeFieldState()
        {
            // 先声明变量，再使用 out 参数
            int catID;
            if (!int.TryParse(ddlCategory.SelectedValue, out catID))
            {
                txtCollege.Enabled = false;
                txtCollege.Text = "";
                rfvCollege.Enabled = false;
                return;
            }

            // 校级 / 社团 → 禁用学院，禁止填写
            if (catID == 1 || catID == 3)
            {
                txtCollege.Enabled = false;
                txtCollege.Text = "";
                rfvCollege.Enabled = false;
            }
            // 院级 → 必须填写
            else if (catID == 2 || catID == 4)
            {
                txtCollege.Enabled = true;
                rfvCollege.Enabled = true;
            }
            else
            {
                txtCollege.Enabled = false;
                txtCollege.Text = "";
                rfvCollege.Enabled = false;
            }
        }
        private void LoadCategories()
        {
            var cats = OrgBLL.GetCategories();
            ddlCategory.Items.Clear();
            foreach (DataRow row in cats.Rows)
                ddlCategory.Items.Add(new System.Web.UI.WebControls.ListItem(row["CategoryName"].ToString(), row["CategoryID"].ToString()));
        }

        protected void BtnSubmit_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int role = Utils.GetCurrentUserRole();
            if (!(role == 1 || role == 2))
            {
                panelMsg.Visible = true;
                panelMsg.CssClass = "alert alert-danger";
                panelMsg.Controls.Add(new LiteralControl("权限不足！只有学生和组织管理者可以创建组织。"));
                return;
            }

            int uid = Utils.GetCurrentUserId();
            int catID = int.Parse(ddlCategory.SelectedValue);
            int m;
            int maxMem = int.TryParse(txtMaxMembers.Text, out m) ? m : 50;
            string logoUrl = null;
            if (fuOrgLogo.HasFile)
            {
                if (fuOrgLogo.PostedFile.ContentLength > 2 * 1024 * 1024)
                {
                    panelMsg.Visible = true;
                    panelMsg.CssClass = "alert alert-danger";
                    panelMsg.Controls.Clear();
                    panelMsg.Controls.Add(new LiteralControl("图片大小不能超过2MB！"));
                    return;
                }

                string ext = Path.GetExtension(fuOrgLogo.FileName).ToLower();
                if (ext != ".jpg" && ext != ".jpeg" && ext != ".png" && ext != ".gif")
                {
                    panelMsg.Visible = true;
                    panelMsg.CssClass = "alert alert-danger";
                    panelMsg.Controls.Clear();
                    panelMsg.Controls.Add(new LiteralControl("只支持JPG/PNG/GIF格式的图片！"));
                    return;
                }

                string fileName = Guid.NewGuid().ToString() + ext;
                string saveDir = Server.MapPath("~/Uploads/OrgLogos/");
                if (!Directory.Exists(saveDir))
                    Directory.CreateDirectory(saveDir);

                fuOrgLogo.SaveAs(Path.Combine(saveDir, fileName));
                logoUrl = "/Uploads/OrgLogos/" + fileName;
            }

            int auditorRole = 0;
            if (catID == 1 || catID == 3)
            {
                auditorRole = 4; // 校级组织/校级社团 → 校级管理员审核
            }
            else if (catID == 2 || catID == 4)
            {
                auditorRole = 3; // 院级组织/院级社团 → 院级管理员审核
            }
            else
            {
                auditorRole = 4; // 其他类型默认走校级管理员审核，防止漏审
            }

            // ==============================================
            // 自动处理学院：校级/社团存NULL，院级存输入内容
            // ==============================================
            object collegeValue = DBNull.Value;
            if (catID == 2 || catID == 4)
            {
                string college = txtCollege.Text.Trim();
                if (!string.IsNullOrEmpty(college))
                    collegeValue = college;
            }

            string sql = @"
                INSERT INTO Organizations 
                (OrgName, CategoryID, Description, LeaderID, ContactInfo, MaxMembers, LogoUrl, Status, AuditorRole, CreateTime, College)
                VALUES (@OrgName, @CategoryID, @Description, @LeaderID, @ContactInfo, @MaxMembers, @LogoUrl, 0, @AuditorRole, GETDATE(), @College)
            ";

            SqlParameter[] parameters = {
                new SqlParameter("@OrgName", txtOrgName.Text.Trim()),
                new SqlParameter("@CategoryID", catID),
                new SqlParameter("@Description", txtDescription.Text.Trim()),
                new SqlParameter("@LeaderID", uid),
                new SqlParameter("@ContactInfo", txtContact.Text.Trim()),
                new SqlParameter("@MaxMembers", maxMem),
                new SqlParameter("@LogoUrl", (object)logoUrl ?? DBNull.Value),
                new SqlParameter("@AuditorRole", auditorRole),
                new SqlParameter("@College", collegeValue)
            };

            int orgID = DbHelper.ExecuteInsertReturnID(sql, parameters);

            panelMsg.Visible = true;
            if (orgID > 0)
            {
                // 发送申请提交确认消息
                MessageBLL.SendMessage(
                    uid,
                    "组织申请已提交",
                    string.Format("你提交的【{0}】组织成立申请已成功提交，等待管理员审核！", txtOrgName.Text.Trim())
                );

                panelMsg.CssClass = "alert alert-success";
                panelMsg.Controls.Clear();
                panelMsg.Controls.Add(new LiteralControl(
                    "<i class='bi bi-check-circle me-2'></i>申请已提交，等待管理层审批。"));
                btnSubmit.Enabled = false;
            }
            else
            {
                panelMsg.CssClass = "alert alert-danger";
                panelMsg.Controls.Clear();
                panelMsg.Controls.Add(new LiteralControl("提交失败，请稍后重试。"));
            }
        }
    }
}