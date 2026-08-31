<%@ Page Title="活动详情 - 高校组织综合线上管理平台" Language="C#" MasterPageFile="../Site.master"
         AutoEventWireup="true" CodeFile="Detail.aspx.cs" Inherits="OrgManage.Activities_Detail" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

<style>
    /* 全局背景 + 淡入动画 */
    body {
        background: url('<%= ResolveUrl("~/images/bg-night.jpg") %>') no-repeat center center fixed !important;
        background-size: cover !important;
        min-height: 100vh !important;
        color: #fff !important;
        animation: pageFadeIn 1s ease forwards;
    }

    @keyframes pageFadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }

    /* 毛玻璃卡片 + 滑入动画 */
    .glass-card {
        background: rgba(255, 255, 255, 0.08) !important;
        backdrop-filter: blur(12px) !important;
        border: 1px solid rgba(255, 255, 255, 0.15) !important;
        border-radius: 16px !important;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3) !important;
        color: #fff !important;
        opacity: 0;
        transform: translateY(30px);
        animation: cardSlideUp 0.9s ease forwards;
    }

    .glass-card:nth-child(1) { animation-delay: 0.2s; }
    .glass-card:nth-child(2) { animation-delay: 0.4s; }
    .glass-card:nth-child(3) { animation-delay: 0.6s; }

    @keyframes cardSlideUp {
        to { opacity: 1; transform: translateY(0); }
    }

    /* 文字颜色 */
    .text-muted, .table th {
        color: rgba(255, 255, 255, 0.7) !important;
    }

    /* 表格适配深色 */
    .table {
        color: rgba(255,255,255,0.9) !important;
        border-color: rgba(255,255,255,0.1) !important;
    }

    .table-hover > tbody > tr:hover {
        background-color: rgba(32,201,151,0.18) !important;
    }
    .table-hover > tbody > tr:hover td {
        color: #fff !important;
    }

    /* 输入框 / 按钮 */
    .btn-success {
        background: linear-gradient(90deg, #20c997, #00b894) !important;
        border: none !important;
        transition: all 0.3s ease;
    }

    .btn-success:hover {
        transform: translateY(-3px);
        box-shadow: 0 6px 15px rgba(32, 201, 151, 0.3);
    }

    .btn-outline-danger {
        border-color: #e94560 !important;
        color: #e94560 !important;
    }

    .btn-outline-danger:hover {
        background: #e94560 !important;
        color: #fff !important;
    }

    .btn-outline-primary {
        border-color: #ff8ba7 !important;
        color: #ff8ba7 !important;
    }

    .btn-outline-primary:hover {
        background: #ff8ba7 !important;
        color: #fff !important;
    }

    /* 标题动画 */
    h4 {
        position: relative;
        animation: titleFade 1.2s ease;
    }

    @keyframes titleFade {
        from { opacity: 0; transform: translateX(-20px); }
        to { opacity: 1; transform: translateX(0); }
    }

    /* 状态标签呼吸灯效果 */
    .badge {
        animation: badgePulse 2s infinite alternate;
        background: #ff8ba7 !important;
        color: #fff !important;
    }

    @keyframes badgePulse {
        from { box-shadow: 0 0 8px #ff8ba7; }
        to { box-shadow: 0 0 16px #ff8ba7; }
    }

    /* 提示框 */
    .alert-success {
        background: rgba(25,135,84,0.2) !important;
        border-color: rgba(25,135,84,0.3) !important;
        color: #fff !important;
    }

    .alert-warning {
        background: rgba(255,193,7,0.2) !important;
        border-color: rgba(255,193,7,0.3) !important;
        color: #fff !important;
    }

    /* 面包屑 */
    .breadcrumb {
        background: transparent !important;
        color: rgba(255,255,255,0.7) !important;
    }

    .breadcrumb a {
        color: #ff8ba7 !important;
        text-decoration: none;
    }
</style>

<div class="container my-4">
    <nav aria-label="breadcrumb" class="mb-3">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="~/Default.aspx" runat="server">首页</a></li>
            <li class="breadcrumb-item"><a href="~/Activities/List.aspx" runat="server">活动中心</a></li>
            <li class="breadcrumb-item active"><asp:Literal ID="litTitle" runat="server" /></li>
        </ol>
    </nav>

    <asp:Panel ID="panelNotFound" runat="server" Visible="false">
        <div class="alert alert-danger">活动不存在。</div>
    </asp:Panel>

    <asp:Panel ID="panelMain" runat="server">
        <div class="row g-4">
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm mb-4 glass-card">
                    <div class="card-body p-4">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <h4 class="fw-bold mb-0"><asp:Literal ID="litTitleMain" runat="server" /></h4>
                            <span class="badge fs-6"><asp:Literal ID="litStatus" runat="server" /></span>
                        </div>
                        <p class="text-muted"><asp:Literal ID="litOrg" runat="server" /></p>
                        <hr style="border-color: rgba(255,255,255,0.1);" />
                        <h6 class="fw-bold mb-2">活动介绍</h6>
                        <p class="mb-0"><asp:Literal ID="litDescription" runat="server" /></p>
                    </div>
                </div>

                <asp:Panel ID="panelEnrollList" runat="server" CssClass="card border-0 shadow-sm glass-card">
                    <div class="card-header bg-transparent border-0 fw-bold pt-3">
                        <i class="bi bi-people me-2"></i>已报名人员（<asp:Literal ID="litEnrollCount" runat="server" />人）
                    </div>
                    <div class="card-body p-0">
                        <asp:GridView ID="gvEnrolls" runat="server" CssClass="table table-sm table-hover mb-0"
                                      AutoGenerateColumns="false" GridLines="None">
                            <Columns>
                                <asp:BoundField DataField="StudentNo" HeaderText="学号" />
                                <asp:BoundField DataField="UserName" HeaderText="姓名" />
                                <asp:BoundField DataField="College" HeaderText="学院" />
                                <asp:BoundField DataField="EnrollTime" HeaderText="报名时间" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                            </Columns>
                            <EmptyDataTemplate>
                                <p class="text-center text-muted py-3">暂无报名</p>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </asp:Panel>
            </div>

            <div class="col-lg-4">
                <div class="card border-0 shadow-sm mb-4 glass-card">
                    <div class="card-body">
                        <h6 class="fw-bold mb-3">活动信息</h6>
                        <table class="table table-sm table-borderless small mb-0">
                            <tr><th class="text-muted" width="80">开始时间</th><td><asp:Literal ID="litStartTime" runat="server" /></td></tr>
                            <tr><th class="text-muted">结束时间</th><td><asp:Literal ID="litEndTime" runat="server" /></td></tr>
                            <tr><th class="text-muted">活动地点</th><td><asp:Literal ID="litLocation" runat="server" /></td></tr>
                            <tr><th class="text-muted">报名人数</th><td><asp:Literal ID="litEnrolled" runat="server" /></td></tr>
                            <tr><th class="text-muted">名额上限</th><td><asp:Literal ID="litMax" runat="server" /></td></tr>
                            <tr><th class="text-muted">主办组织</th><td><asp:Literal ID="litOrgName" runat="server" /></td></tr>
                        </table>
                    </div>
                </div>

                <asp:Panel ID="panelEnrollBtn" runat="server" CssClass="card border-0 shadow-sm glass-card">
                    <div class="card-body text-center">
                        <asp:Panel ID="panelEnrolled" runat="server" Visible="false" CssClass="alert alert-success small mb-3">
                            <i class="bi bi-check-circle me-1"></i>您已报名参加此活动
                        </asp:Panel>
                        <asp:Panel ID="panelMsg" runat="server" Visible="false" CssClass="alert alert-warning small mb-3">
                            <asp:Literal ID="litMsg" runat="server" />
                        </asp:Panel>
                        <asp:Button ID="btnEnroll" runat="server" Text="立即报名" CssClass="btn btn-success w-100 fw-bold" OnClick="BtnEnroll_Click" />
                        <asp:Button ID="btnCancel" runat="server" Text="取消报名" CssClass="btn btn-outline-danger w-100 mt-2" OnClick="BtnCancel_Click" Visible="false" />
                        <asp:HyperLink ID="hlLogin" runat="server" NavigateUrl="~/Account/Login.aspx" CssClass="btn btn-outline-primary w-100 fw-bold" Visible="false">
                            登录后报名
                        </asp:HyperLink>
                    </div>
                </asp:Panel>
            </div>
        </div>
    </asp:Panel>
</div>
    <script>
          // ==================== 防复制/防查看源码 ====================
          // 1. 禁用右键菜单
          document.addEventListener('contextmenu', function (e) {
              e.preventDefault();
              return false;
          });

          // 2. 禁用 F12 / Ctrl+U / Ctrl+Shift+I 等调试快捷键
          document.addEventListener('keydown', function (e) {
              // 禁止 F12
              if (e.key === 'F12') {
                  e.preventDefault();
                  return false;
              }
              // 禁止 Ctrl+U（查看网页源代码）
              if (e.ctrlKey && e.key === 'u') {
                  e.preventDefault();
                  return false;
              }
              // 禁止 Ctrl+Shift+I / Ctrl+Shift+J（开发者工具）
              if (e.ctrlKey && e.shiftKey && (e.key === 'I' || e.key === 'J')) {
                  e.preventDefault();
                  return false;
              }
          });

// 3. 禁止选中文字
document.addEventListener('selectstart', function(e) {
e.preventDefault();
 });
    </script>
</asp:Content>