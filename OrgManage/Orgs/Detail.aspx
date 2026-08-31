<%@ Page Title="组织详情 - 高校组织综合线上管理平台" Language="C#" MasterPageFile="../Site.master"
         AutoEventWireup="true" CodeFile="Detail.aspx.cs" Inherits="OrgManage.Orgs_Detail" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

<style>
    /* 全局背景 */
    body {
        background: url('<%= ResolveUrl("~/images/bg-night.jpg") %>') no-repeat center center fixed !important;
        background-size: cover !important;
        min-height: 100vh !important;
        color: #fff !important;
        animation: pageFade 1s ease forwards;
    }

    @keyframes pageFade {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }

    /* 毛玻璃卡片 —— 高级浮动动画 */
    .card {
        background: rgba(255, 255, 255, 0.08) !important;
        backdrop-filter: blur(12px) !important;
        border: 1px solid rgba(255, 255, 255, 0.15) !important;
        border-radius: 16px !important;
        box-shadow: 0 8px 32px rgba(0,0,0,0.2) !important;
        color: #fff !important;
        opacity: 0;
        animation: cardFloatUp 0.8s ease forwards;
        overflow: hidden !important;
    }

    /* 卡片依次出现 */
    .card:nth-child(1) { animation-delay: 0.2s; }
    .card:nth-child(2) { animation-delay: 0.3s; }
    .card:nth-child(3) { animation-delay: 0.4s; }
    .card:nth-child(4) { animation-delay: 0.5s; }
    .sidebar-card { animation-delay: 0.6s !important; }

    @keyframes cardFloatUp {
        from { opacity: 0; transform: translateY(30px) scale(0.95); }
        to { opacity: 1; transform: translateY(0) scale(1); }
    }

    /* 卡片悬停 3D 效果 */
    .card:hover {
        transform: translateY(-4px);
        box-shadow: 0 12px 35px rgba(0,0,0,0.25) !important;
        border-color: rgba(255,139,167,0.3) !important;
    }

    /* 头部 */
    .card-header {
        background: transparent !important;
        border-bottom: 1px solid rgba(255,255,255,0.1) !important;
        color: #fff !important;
    }

    /* 文字清晰度修复 */
    .text-muted {
        color: rgba(255,255,255,0.7) !important;
    }

    .small, .text-sm {
        color: rgba(255,255,255,0.8) !important;
    }

    /* 链接高亮 */
    a.text-dark, a.fw-bold {
        color: #fff !important;
        transition: all 0.2s ease;
    }

    a.text-dark:hover {
        color: #ff8ba7 !important;
    }

    /* 面包屑动画 */
    .breadcrumb {
        background: rgba(255,255,255,0.05) !important;
        border-radius: 10px;
        padding: 10px 15px;
        backdrop-filter: blur(10px);
        animation: breadcrumbSlide 0.8s ease;
    }

    .breadcrumb a {
        color: #ff8ba7 !important;
        text-decoration: none;
    }

    @keyframes breadcrumbSlide {
        from { opacity: 0; transform: translateX(-20px); }
        to { opacity: 1; transform: translateX(0); }
    }

    /* 统计数字脉冲动画 */
    .fw-bold.text-primary, .fw-bold.text-success, .fw-bold.text-warning {
        animation: countPulse 1.2s ease;
    }

    @keyframes countPulse {
        0% { transform: scale(0.8); opacity: 0.5; }
        50% { transform: scale(1.1); opacity: 1; }
        100% { transform: scale(1); }
    }

    /* 列表项滑入动画 */
    .d-flex.align-items-center.px-3.py-2 {
        animation: itemSlide 0.5s ease forwards;
        opacity: 0;
    }

    .d-flex.align-items-center.px-3.py-2:nth-child(1) { animation-delay: 0.3s; }
    .d-flex.align-items-center.px-3.py-2:nth-child(2) { animation-delay: 0.4s; }
    .d-flex.align-items-center.px-3.py-2:nth-child(3) { animation-delay: 0.5s; }

    @keyframes itemSlide {
        from { opacity: 0; transform: translateX(-20px); }
        to { opacity: 1; transform: translateX(0); }
    }

    /* 边框 */
    .border-bottom {
        border-color: rgba(255,255,255,0.08) !important;
    }

    /* 按钮 */
    .btn-outline-warning {
        border-color: #ffc107 !important;
        color: #ffc107 !important;
    }

    .btn-outline-warning:hover {
        background: #ffc107 !important;
        color: #000 !important;
    }

    /* 招新模块 */
    .bg-light.rounded-3 {
        background: rgba(255,255,255,0.08) !important;
        border: 1px solid rgba(255,255,255,0.1);
        color: #fff !important;
    }

    /* 表格 */
    .table {
        color: #fff !important;
    }

    .table th {
        color: rgba(255,255,255,0.7) !important;
    }

    /* 成员头像 */
    .rounded-circle.bg-primary {
        background: #ff8ba7 !important;
        animation: avatarPop 0.6s ease;
    }

    @keyframes avatarPop {
        from { transform: scale(0); opacity: 0; }
        to { transform: scale(1); opacity: 1; }
    }

    /* 警告框 */
    .alert-danger {
        background: rgba(220,53,69,0.2) !important;
        border-color: rgba(220,53,69,0.4);
        color: #fff !important;
        animation: shakeIn 0.5s ease;
    }

    @keyframes shakeIn {
        0% { transform: scale(0.9); opacity: 0; }
        100% { transform: scale(1); opacity: 1; }
    }
</style>

<div class="container my-4">
    <!-- 面包屑导航 -->
    <nav aria-label="breadcrumb" class="mb-3">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="~/Default.aspx" runat="server">首页</a></li>
            <li class="breadcrumb-item"><a href="~/Orgs/List.aspx" runat="server">组织大厅</a></li>
            <li class="breadcrumb-item active"><asp:Literal ID="litOrgName" runat="server" /></li>
        </ol>
    </nav>

    <asp:Panel ID="panelNotFound" runat="server" Visible="false">
        <div class="alert alert-danger">组织不存在或已注销。</div>
    </asp:Panel>

    <asp:Panel ID="panelDetail" runat="server">
        <div class="row g-4">
            <!-- 左侧主要内容 -->
            <div class="col-lg-8">
                <!-- 组织信息卡 -->
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-body p-4">
                        <div class="d-flex gap-4 align-items-start">
                            <div class="flex-shrink-0">
                                <asp:Image ID="imgLogo" runat="server" CssClass="rounded-3 border" Width="90" Height="90" />
                            </div>
                            <div class="flex-grow-1">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <h3 class="fw-bold mb-1"><asp:Literal ID="litName" runat="server" /></h3>
                                        <span class="badge bg-primary me-1"><asp:Literal ID="litCategory" runat="server" /></span>
                                        <span class="badge bg-success"><asp:Literal ID="litStatus" runat="server" /></span>
                                    </div>
                                    <asp:Button ID="btnFav" runat="server" CssClass="btn btn-outline-warning btn-sm" OnClick="BtnFav_Click" />
                                </div>
                                <div class="row mt-3 text-center">
                                    <div class="col-4">
                                        <h5 class="fw-bold text-primary mb-0"><asp:Literal ID="litMemberCount" runat="server" /></h5>
                                        <small class="text-muted">成员</small>
                                    </div>
                                    <div class="col-4">
                                        <h5 class="fw-bold text-success mb-0"><asp:Literal ID="litActivityCount" runat="server" /></h5>
                                        <small class="text-muted">活动</small>
                                    </div>
                                    <div class="col-4">
                                        <h5 class="fw-bold text-warning mb-0"><asp:Literal ID="litFounded" runat="server" /></h5>
                                        <small class="text-muted">成立年份</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 组织简介 -->
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-header bg-white border-0 fw-bold pt-3">
                        <i class="bi bi-info-circle text-primary me-2"></i>组织简介
                    </div>
                    <div class="card-body">
                        <p class="mb-0"><asp:Literal ID="litDescription" runat="server" /></p>
                    </div>
                </div>

                <!-- 组织公告 -->
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-header bg-white border-0 fw-bold pt-3">
                        <i class="bi bi-megaphone text-danger me-2"></i>组织公告
                    </div>
                    <div class="card-body p-0">
                        <asp:Repeater ID="rptAnnouncements" runat="server">
                            <ItemTemplate>
                                <div class="px-3 py-3 border-bottom">
                                    <div class="d-flex justify-content-between align-items-start mb-1">
                                        <h6 class="fw-bold mb-0"><%# Eval("Title") %></h6>
                                        <small class="text-muted text-nowrap ms-2"><%# Convert.ToDateTime(Eval("PublishTime")).ToString("yyyy-MM-dd HH:mm") %></small>
                                    </div>
                                    <p class="small mb-1" style="white-space:pre-wrap;"><%# Eval("Content") %></p>
                                    <small class="text-muted">发布人：<%# Eval("PublisherName") %></small>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:Panel ID="panelNoAnn" runat="server" CssClass="text-center text-muted py-3 small">暂无公告</asp:Panel>
                    </div>
                </div>

                <!-- 近期活动 -->
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-header bg-white border-0 fw-bold pt-3 d-flex justify-content-between">
                        <span><i class="bi bi-calendar2-event text-success me-2"></i>近期活动</span>
                        <a href='../Activities/List.aspx?org=<%= Request.QueryString["id"] %>' class="btn btn-sm btn-outline-success">查看详情</a>
                    </div>
                    <div class="card-body p-0">
                        <asp:Repeater ID="rptActivities" runat="server">
                            <ItemTemplate>
                                <div class="d-flex align-items-center px-3 py-2 border-bottom">
                                    <div class="act-date me-3" style="min-width:48px;">
                                        <div class="day text-center fw-bold text-primary">
                                            <%# Convert.ToDateTime(Eval("StartTime")).Day %>
                                        </div>
                                        <div class="mon text-center small text-muted">
                                            <%# Convert.ToDateTime(Eval("StartTime")).ToString("MM月") %>
                                        </div>
                                    </div>
                                    <div>
                                       <a href='<%# ResolveUrl("~/Activities/Detail.aspx?id=" + Eval("ActivityID")) %>'
                                       class="fw-bold text-decoration-none">
                                        <%# Eval("Title") %>
                                             </a>
                                        <p class="small text-muted mb-0">
                                            <i class="bi bi-geo-alt me-1"></i><%# Eval("Location") %>
                                        </p>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:Panel ID="panelNoAct" runat="server" CssClass="text-center text-muted py-3 small">暂无活动</asp:Panel>
                    </div>
                </div>

                <!-- 招新公告 -->
                <asp:Panel ID="panelRecruit" runat="server" CssClass="card border-0 shadow-sm mb-4">
                    <div class="card-header bg-white border-0 fw-bold pt-3">
                        <i class="bi bi-person-plus text-warning me-2"></i>招新中
                    </div>
                    <div class="card-body">
                        <asp:Repeater ID="rptRecruit" runat="server">
                            <ItemTemplate>
                                <div class="mb-3 p-3 bg-light rounded-3">
                                    <h6 class="fw-bold"><%# Eval("Title") %></h6>
                                    <p class="small text-muted mb-2">
                                        <i class="bi bi-clock me-1"></i>截止 <%# Convert.ToDateTime(Eval("EndDate")).ToString("yyyy-MM-dd") %>
                                        <span class="ms-3">名额：<%# Convert.ToInt32(Eval("Quota")) == 0 ? "不限" : Eval("Quota").ToString() %></span>
                                    </p>
                                    <a href='RecruitDetail.aspx?id=<%# Eval("RecruitID") %>' class="btn btn-warning btn-sm">立即报名</a>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </asp:Panel>
            </div>

            <!-- 右侧信息 -->
            <div class="col-lg-4">
                <div class="card border-0 shadow-sm sidebar-card mb-4">
                    <div class="card-body">
                        <h6 class="fw-bold mb-3"><i class="bi bi-info-circle me-2"></i>基本信息</h6>
                        <table class="table table-sm table-borderless small mb-0">
                            <tr><th class="text-muted" width="90">负责人</th><td><asp:Literal ID="litLeader" runat="server" /></td></tr>
                            <tr><th class="text-muted">指导老师</th><td><asp:Literal ID="litAdvisor" runat="server" /></td></tr>
                            <tr><th class="text-muted">成员上限</th><td><asp:Literal ID="litMax" runat="server" />人</td></tr>
                            <tr><th class="text-muted">联系方式</th><td><asp:Literal ID="litContact" runat="server" /></td></tr>
                        </table>
                    </div>
                </div>

                <!-- 成员名单 -->
                <div class="card border-0 shadow-sm sidebar-card">
                    <div class="card-header bg-white border-0 fw-bold pt-3">
                        <i class="bi bi-people me-2"></i>部分成员
                    </div>
                    <div class="card-body p-0">
                        <asp:Repeater ID="rptMembers" runat="server">
                            <ItemTemplate>
                                <div class="d-flex align-items-center px-3 py-2 border-bottom">
                                    <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center me-2"
                                         style="width:32px;height:32px;font-size:.8rem;flex-shrink:0;">
                                        <%# Eval("UserName").ToString().Substring(0, 1) %>
                                    </div>
                                    <div>
                                        <div class="small fw-bold"><%# Eval("UserName") %></div>
                                        <div class="text-muted" style="font-size:.75rem;">
                                            <%# Convert.ToInt32(Eval("MemberRole")) == 3 ? "负责人" : Convert.ToInt32(Eval("MemberRole")) == 2 ? "干部" : "成员" %>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </div>
        </div>
    </asp:Panel>
</div>
    
    <script>
        // ==================== 基础防复制/防查看源码====================
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
        document.addEventListener('selectstart', function (e) {
            e.preventDefault();
        });
    </script>

</asp:Content>