using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using OrgManage.APP_Code;

namespace OrgManage
{
    public partial class Manage_MyOrg : Page
    {
        private int CurrentOrgID
        {
            get
            {
                // ✅ 防止 hfCurrentOrgID 为空时直接抛异常
                int id;
                return int.TryParse(hfCurrentOrgID.Value, out id) ? id : 0;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            Utils.RequireLogin();
            int userId = Utils.GetCurrentUserId();
            var userData = UserBLL.GetUser(userId);
            if (userData == null || Convert.ToInt32(userData["Role"]) != 2)
            {
                Response.Redirect("~/Default.aspx");
                return;
            }
            if (!IsPostBack)
            {
                LoadMyOrgs();
            }

            // 确保所有嵌套控件都走异步回发，避免整页刷新
            if (ScriptManager.GetCurrent(this) != null)
            {
                ScriptManager.GetCurrent(this).RegisterAsyncPostBackControl(rptMyOrgs);
                ScriptManager.GetCurrent(this).RegisterAsyncPostBackControl(rptRecruitList);
                ScriptManager.GetCurrent(this).RegisterAsyncPostBackControl(rptActivityList);
                ScriptManager.GetCurrent(this).RegisterAsyncPostBackControl(gvApps);
            }
        }

        private void LoadMyOrgs()
        {
            int uid = Utils.GetCurrentUserId();
            DataTable dt = OrgBLL.GetMyManageOrgs(uid);
            rptMyOrgs.DataSource = dt;
            rptMyOrgs.DataBind();

            ddlMyOrgSelect.DataSource = dt;
            ddlMyOrgSelect.DataTextField = "OrgName";
            ddlMyOrgSelect.DataValueField = "OrgID";
            ddlMyOrgSelect.DataBind();
        }

        protected void btnGoEditSelect_Click(object sender, EventArgs e)
        {
            panelOrgSelectRow.Style["display"] = "block";
            hfOperType.Value = "edit";
        }

        protected void btnGoDisbandSelect_Click(object sender, EventArgs e)
        {
            panelOrgSelectRow.Style["display"] = "block";
            hfOperType.Value = "disband";
        }

        protected void btnGoAnnounceSelect_Click(object sender, EventArgs e)
        {
            panelOrgSelectRow.Style["display"] = "block";
            hfOperType.Value = "announce";
        }

        protected void btnConfirmOrg_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlMyOrgSelect.SelectedValue))
                return;

            int orgId = int.Parse(ddlMyOrgSelect.SelectedValue);
            hfCurrentOrgID.Value = orgId.ToString();
            string oper = hfOperType.Value;

            if (oper == "edit")
            {
                DataRow org = OrgBLL.GetOrgById(orgId);
                if (org != null)
                {
                    txtEditOrgName.Text = org["OrgName"].ToString();
                    txtEditDesc.Text = org["Description"].ToString();
                    txtEditContact.Text = org["ContactInfo"].ToString();
                    txtEditMaxMembers.Text = org["MaxMembers"].ToString();
                }
            }

            panelOrgSelectRow.Style["display"] = "none";

            string script = "";
            if (oper == "edit")
                script = "setTimeout(function(){ openModal('panelEdit'); }, 100);";
            else if (oper == "disband")
                script = "setTimeout(function(){ openModal('panelDisband'); }, 100);";
            else if (oper == "announce")
            {
                LoadAnnouncements(orgId);
                script = "setTimeout(function(){ openModal('panelAnnounce'); }, 100);";
            }

            if (!string.IsNullOrEmpty(script))
                ScriptManager.RegisterStartupScript(this, this.GetType(), "modal_" + Guid.NewGuid().ToString("N"), script, true);
        }

        // ✅ 核心修复：改用 asp:LinkButton 后，CommandName 和 CommandArgument 均正确传递
        protected void RptMyOrgs_ItemCommand(object sender, RepeaterCommandEventArgs e)
        {
            string cmd = e.CommandName;                     // "Members" / "Recruit" / "Activity"
            int orgId = Convert.ToInt32(e.CommandArgument); // OrgID 数字
            hfCurrentOrgID.Value = orgId.ToString();

            var org = OrgBLL.GetOrgById(orgId);
            litCurrentOrg.Text = org["OrgName"].ToString();
            int orgStatus = Convert.ToInt32(org["Status"]);

            string modalScript = "";

            if (cmd == "Members")
            {
                LoadMembers(orgId);
                modalScript = "setTimeout(function(){ openModal('panelMembers'); }, 100);";
            }
            else if (cmd == "Recruit")
            {
                if (orgStatus != 1)
                {
                    btnPublishRecruit.Enabled = false;
                    panelRecruitMsg.Visible = true;
                    panelRecruitMsg.CssClass = "alert alert-danger small";
                    panelRecruitMsg.Controls.Clear();
                    panelRecruitMsg.Controls.Add(new LiteralControl("组织状态异常，无法发布招新！"));
                }
                else
                {
                    btnPublishRecruit.Enabled = true;
                    panelRecruitMsg.Visible = false;
                }
                LoadRecruitList(orgId);
                modalScript = "setTimeout(function(){ openModal('panelRecruit'); }, 100);";
            }
            else if (cmd == "Activity")
            {
                if (orgStatus != 1)
                {
                    panelOrgNotActive.Visible = true;
                    btnPublishAct.Enabled = false;
                }
                else
                {
                    panelOrgNotActive.Visible = false;
                    btnPublishAct.Enabled = true;
                }
                LoadActivityList(orgId);
                modalScript = "setTimeout(function(){ openModal('panelActivity'); }, 100);";
            }
            else if (cmd == "Announce")
            {
                LoadAnnouncements(orgId);
                modalScript = "setTimeout(function(){ openModal('panelAnnounce'); }, 100);";
            }

            if (!string.IsNullOrEmpty(modalScript))
                ScriptManager.RegisterStartupScript(this, this.GetType(), "modal_" + Guid.NewGuid().ToString("N"), modalScript, true);
        }

        private void LoadMembers(int orgId)
        {
            DataTable dt = OrgBLL.GetOrgMembers(orgId);
            DataRow orgRow = OrgBLL.GetOrgById(orgId);

            if (orgRow != null)
            {
                int leaderId = Convert.ToInt32(orgRow["LeaderID"]);
                bool leaderExists = false;
                foreach (DataRow r in dt.Rows)
                {
                    if (Convert.ToInt32(r["UserID"]) == leaderId && Convert.ToInt32(r["MemberRole"]) == 3)
                    {
                        leaderExists = true;
                        break;
                    }
                }
                if (!leaderExists)
                {
                    OrgBLL.EnsureLeaderMember(orgId, leaderId);
                    dt = OrgBLL.GetOrgMembers(orgId);
                }
            }

            gvMembers.DataSource = dt;
            gvMembers.DataBind();
        }

        protected void gvMembers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Remove")
            {
                int memberId = int.Parse(e.CommandArgument.ToString());
                OrgBLL.RemoveMember(memberId);
                LoadMembers(CurrentOrgID);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "modal_members", "setTimeout(function(){ openModal('panelMembers'); }, 100);", true);
            }
        }

        protected void btnAddMember_Click(object sender, EventArgs e)
        {
            panelAddMsg.Visible = false;
            string studentNo = txtAddStudentNo.Text.Trim();

            if (string.IsNullOrEmpty(studentNo))
            {
                panelAddMsg.Visible = true;
                panelAddMsg.CssClass = "alert alert-danger small";
                panelAddMsg.Controls.Clear();
                panelAddMsg.Controls.Add(new LiteralControl("请输入学号"));
                ScriptManager.RegisterStartupScript(this, this.GetType(), "modal_members", "setTimeout(function(){ openModal('panelMembers'); }, 100);", true);
                return;
            }

            DataRow user = UserBLL.GetUserByStudentNo(studentNo);
            if (user == null)
            {
                panelAddMsg.Visible = true;
                panelAddMsg.CssClass = "alert alert-danger small";
                panelAddMsg.Controls.Clear();
                panelAddMsg.Controls.Add(new LiteralControl("未找到该学号用户"));
                ScriptManager.RegisterStartupScript(this, this.GetType(), "modal_members", "setTimeout(function(){ openModal('panelMembers'); }, 100);", true);
                return;
            }

            int userId = Convert.ToInt32(user["UserID"]);
            bool ok = OrgBLL.AddMember(CurrentOrgID, userId);

            panelAddMsg.Visible = true;
            if (ok)
            {
                panelAddMsg.CssClass = "alert alert-success small";
                panelAddMsg.Controls.Clear();
                panelAddMsg.Controls.Add(new LiteralControl("添加成功！"));
                txtAddStudentNo.Text = "";
                LoadMembers(CurrentOrgID);
            }
            else
            {
                panelAddMsg.CssClass = "alert alert-danger small";
                panelAddMsg.Controls.Clear();
                panelAddMsg.Controls.Add(new LiteralControl("添加失败：已在组织中"));
            }
            ScriptManager.RegisterStartupScript(this, this.GetType(), "modal_members", "setTimeout(function(){ openModal('panelMembers'); }, 100);", true);
        }

        protected void btnCancelAdd_Click(object sender, EventArgs e)
        {
            txtAddStudentNo.Text = "";
            panelAddMsg.Visible = false;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "modal_members", "setTimeout(function(){ openModal('panelMembers'); }, 100);", true);
        }

        private void LoadRecruitList(int orgId)
        {
            rptRecruitList.DataSource = OrgBLL.GetRecruitListByOrg(orgId);
            rptRecruitList.DataBind();
        }

        protected void RptRecruitList_ItemCommand(object sender, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ViewApps")
            {
                int rid = int.Parse(e.CommandArgument.ToString());
                gvApps.DataSource = OrgBLL.GetRecruitApplications(rid);
                gvApps.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "modal_apps", "setTimeout(function(){ openModal('panelApps'); }, 100);", true);
            }
        }

        protected void GvApps_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int appId = int.Parse(e.CommandArgument.ToString());
            try
            {
                if (e.CommandName == "Approve")
                    OrgBLL.AcceptApply(appId);
                else if (e.CommandName == "Reject")
                    OrgBLL.RejectApply(appId);

                int recruitId = OrgBLL.GetRecruitIDByApplyID(appId);
                gvApps.DataSource = OrgBLL.GetRecruitApplications(recruitId);
                gvApps.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "modal_apps", "setTimeout(function(){ openModal('panelApps'); }, 100);", true);
            }
            catch (UnauthorizedAccessException)
            {
                panelRecruitMsg.Visible = true;
                panelRecruitMsg.CssClass = "alert alert-danger small";
                panelRecruitMsg.Controls.Clear();
                panelRecruitMsg.Controls.Add(new LiteralControl("操作失败：您没有权限执行此操作。"));
                ScriptManager.RegisterStartupScript(this, this.GetType(), "modal_recruit", "setTimeout(function(){ openModal('panelRecruit'); }, 100);", true);
            }
        }

        protected void BtnPublishRecruit_Click(object sender, EventArgs e)
        {
            OrgBLL.CreateRecruit(
                CurrentOrgID, txtRecruitTitle.Text, txtRecruitContent.Text,
                txtRecruitReq.Text, DateTime.Parse(txtRecruitStart.Text),
                DateTime.Parse(txtRecruitEnd.Text), int.Parse(txtRecruitQuota.Text));
            LoadRecruitList(CurrentOrgID);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "modal_recruit", "setTimeout(function(){ openModal('panelRecruit'); }, 100);", true);
        }

        protected void BtnPublishAct_Click(object sender, EventArgs e)
        {
            // ✅ 加防空判断
            if (CurrentOrgID == 0)
            {
                panelActMsg.Visible = true;
                panelActMsg.CssClass = "alert alert-danger small";
                panelActMsg.Controls.Clear();
                panelActMsg.Controls.Add(new LiteralControl("请先选择组织！"));
                ScriptManager.RegisterStartupScript(this, this.GetType(), "modal_activity", "setTimeout(function(){ openModal('panelActivity'); }, 100);", true);
                return;
            }

            var org = OrgBLL.GetOrgById(CurrentOrgID);
            if (Convert.ToInt32(org["Status"]) != 1)
            {
                panelActMsg.Visible = true;
                panelActMsg.CssClass = "alert alert-danger small";
                panelActMsg.Controls.Clear();
                panelActMsg.Controls.Add(new LiteralControl("组织状态异常，无法发布活动！"));
                ScriptManager.RegisterStartupScript(this, this.GetType(), "modal_activity", "setTimeout(function(){ openModal('panelActivity'); }, 100);", true);
                return;
            }

            int scope = int.Parse(ddlParticipationScope.SelectedValue);

            OrgBLL.CreateActivity(
                CurrentOrgID,
                txtActTitle.Text,
                txtActDesc.Text,
                txtActLocation.Text,
                DateTime.Parse(txtActStart.Text),
                DateTime.Parse(txtActEnd.Text),
                int.Parse(txtActMax.Text),
                scope);

            panelActMsg.Visible = true;
            panelActMsg.CssClass = "alert alert-success small";
            panelActMsg.Controls.Clear();
            panelActMsg.Controls.Add(new LiteralControl("活动发布成功！"));
            LoadActivityList(CurrentOrgID);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "modal_activity", "setTimeout(function(){ openModal('panelActivity'); }, 100);", true);
        }

        private void LoadActivityList(int orgId)
        {
            rptActivityList.DataSource = OrgBLL.GetActivityListByOrg(orgId);
            rptActivityList.DataBind();
        }

        protected void RptActivityList_ItemCommand(object sender, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ViewEnrolls")
            {
                int actId = int.Parse(e.CommandArgument.ToString());
                gvActivityEnrolls.DataSource = OrgBLL.GetActivityEnrollList(actId);
                gvActivityEnrolls.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "modal_enrolls", "setTimeout(function(){ openModal('panelActivityEnrolls'); }, 100);", true);
            }
        }

        private void LoadAnnouncements(int orgId)
        {
            DataRow orgRow = OrgBLL.GetOrgById(orgId);
            if (orgRow != null)
                litAnnounceOrg.Text = " - " + orgRow["OrgName"].ToString();

            DataTable dt = OrgBLL.GetOrgAnnouncements(orgId);
            rptAnnounceList.DataSource = dt;
            rptAnnounceList.DataBind();
            lblNoAnnounce.Visible = (dt.Rows.Count == 0);
        }

        protected void RptAnnounceList_ItemCommand(object sender, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Delete" && CurrentOrgID != 0)
            {
                int annId = int.Parse(e.CommandArgument.ToString());
                OrgBLL.DeleteOrgAnnouncement(annId, CurrentOrgID);
                LoadAnnouncements(CurrentOrgID);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "modal_announce", "setTimeout(function(){ openModal('panelAnnounce'); }, 100);", true);
            }
        }

        protected void btnSaveAnnounce_Click(object sender, EventArgs e)
        {
            // ✅ 防空判断：公告需要先选择组织
            if (CurrentOrgID == 0)
            {
                panelAnnounceMsg.Visible = true;
                panelAnnounceMsg.CssClass = "alert alert-danger small mb-3";
                panelAnnounceMsg.Controls.Clear();
                panelAnnounceMsg.Controls.Add(new LiteralControl("请先通过组织卡片的\u0022公告\u0022按钮或上方\u0022发布公告\u0022选择组织，再发布公告!"));
                ScriptManager.RegisterStartupScript(this, this.GetType(), "modal_announce", "setTimeout(function(){ openModal('panelAnnounce'); }, 100);", true);
                return;
            }

            if (string.IsNullOrWhiteSpace(txtAnnTitle.Text.Trim()))
            {
                panelAnnounceMsg.Visible = true;
                panelAnnounceMsg.CssClass = "alert alert-danger small mb-3";
                panelAnnounceMsg.Controls.Clear();
                panelAnnounceMsg.Controls.Add(new LiteralControl("公告标题不能为空！"));
                ScriptManager.RegisterStartupScript(this, this.GetType(), "modal_announce", "setTimeout(function(){ openModal('panelAnnounce'); }, 100);", true);
                return;
            }

            OrgBLL.PublishAnnounce(CurrentOrgID, txtAnnTitle.Text.Trim(), txtAnnContent.Text);
            txtAnnTitle.Text = "";
            txtAnnContent.Text = "";
            LoadAnnouncements(CurrentOrgID);
            panelAnnounceMsg.Visible = true;
            panelAnnounceMsg.CssClass = "alert alert-success small mb-3";
            panelAnnounceMsg.Controls.Clear();
            panelAnnounceMsg.Controls.Add(new LiteralControl("公告发布成功！"));
            ScriptManager.RegisterStartupScript(this, this.GetType(), "modal_announce", "setTimeout(function(){ openModal('panelAnnounce'); }, 100);", true);
        }

        protected void btnSaveEdit_Click(object sender, EventArgs e)
        {
            string logoUrl = null;
            if (fuEditLogo.HasFile)
            {
                if (fuEditLogo.PostedFile.ContentLength > 2 * 1024 * 1024)
                {
                    panelEditMsg.Visible = true;
                    panelEditMsg.CssClass = "alert alert-danger";
                    panelEditMsg.Controls.Clear();
                    panelEditMsg.Controls.Add(new LiteralControl("Logo不能超过2MB"));
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "modal_edit", "setTimeout(function(){ openModal('panelEdit'); }, 100);", true);
                    return;
                }

                string ext = Path.GetExtension(fuEditLogo.FileName).ToLower();
                if (ext != ".jpg" && ext != ".jpeg" && ext != ".png" && ext != ".gif")
                {
                    panelEditMsg.Visible = true;
                    panelEditMsg.CssClass = "alert alert-danger";
                    panelEditMsg.Controls.Clear();
                    panelEditMsg.Controls.Add(new LiteralControl("仅支持JPG/PNG/GIF"));
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "modal_edit", "setTimeout(function(){ openModal('panelEdit'); }, 100);", true);
                    return;
                }

                string file = Guid.NewGuid() + ext;
                string dir = Server.MapPath("~/Uploads/OrgLogos/");
                if (!Directory.Exists(dir)) Directory.CreateDirectory(dir);
                fuEditLogo.SaveAs(Path.Combine(dir, file));
                logoUrl = "/Uploads/OrgLogos/" + file;
            }

            OrgBLL.UpdateOrgInfo(
                CurrentOrgID,
                txtEditOrgName.Text.Trim(),
                txtEditDesc.Text.Trim(),
                txtEditContact.Text.Trim(),
                int.Parse(txtEditMaxMembers.Text),
                logoUrl
            );

            panelEditMsg.Visible = true;
            panelEditMsg.CssClass = "alert alert-success";
            panelEditMsg.Controls.Clear();
            panelEditMsg.Controls.Add(new LiteralControl("修改成功！"));
            LoadMyOrgs();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "modal_edit", "setTimeout(function(){ openModal('panelEdit'); }, 100);", true);
        }

        protected void btnSubmitDisband_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtDisbandReason.Text))
            {
                panelDisbandMsg.Visible = true;
                panelDisbandMsg.CssClass = "alert alert-danger";
                panelDisbandMsg.Controls.Clear();
                panelDisbandMsg.Controls.Add(new LiteralControl("请填写解散原因"));
                ScriptManager.RegisterStartupScript(this, this.GetType(), "modal_disband", "setTimeout(function(){ openModal('panelDisband'); }, 100);", true);
                return;
            }

            OrgBLL.ApplyDisband(CurrentOrgID, txtDisbandReason.Text.Trim());

            panelDisbandMsg.Visible = true;
            panelDisbandMsg.CssClass = "alert alert-success";
            panelDisbandMsg.Controls.Clear();
            panelDisbandMsg.Controls.Add(new LiteralControl("解散申请已提交！"));
            btnSubmitDisband.Enabled = false;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "modal_disband", "setTimeout(function(){ openModal('panelDisband'); }, 100);", true);
        }
    }
}
