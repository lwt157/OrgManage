<%@ Page Title="我的组织管理 - 高校组织综合线上管理平台" Language="C#" MasterPageFile="../Site.master"
         AutoEventWireup="true" CodeFile="MyOrg.aspx.cs" Inherits="OrgManage.Manage_MyOrg" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" EnablePartialRendering="true"></asp:ScriptManager>
    <script src="<%= ResolveUrl("~/Scripts/jquery-3.7.1.min.js") %>"></script>

    <!-- 弹窗背景遮罩 -->
    <div id="modalBackdrop" class="modal-backdrop" onclick="closeModal();"></div>
    <style>
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

        .page-title {
            animation: titleSlide 0.8s ease;
        }

        @keyframes titleSlide {
            from { opacity: 0; transform: translateY(-15px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .glass-card {
            background: rgba(255, 255, 255, 0.08) !important;
            backdrop-filter: blur(12px) !important;
            border: 1px solid rgba(255, 255, 255, 0.15) !important;
            border-radius: 16px !important;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2) !important;
            color: #fff !important;
            opacity: 0;
            animation: cardUp 0.6s cubic-bezier(0.4, 0, 0.2, 1) forwards;
        }

        @keyframes cardUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* 模态面板 - 丝滑缩放淡入动画 */
        .panel-as-modal {
            position: fixed !important;
            top: 50% !important;
            left: 50% !important;
            transform: translate(-50%, -50%) scale(0.92) !important;
            width: 90% !important;
            max-width: 950px !important;
            max-height: 85vh !important;
            overflow-y: auto !important;
            z-index: 10000 !important;
            background: rgba(0,0,0,0.85) !important;
            backdrop-filter: blur(20px) !important;
            border: 1px solid rgba(255,255,255,0.3) !important;
            border-radius: 20px !important;
            box-shadow: 0 20px 60px rgba(0,0,0,0.6) !important;
            color: #fff !important;
            opacity: 0 !important;
            pointer-events: none;
            transition: opacity 0.3s cubic-bezier(0.4, 0, 0.2, 1),
                        transform 0.35s cubic-bezier(0.34, 1.56, 0.64, 1) !important;
        }

        .panel-as-modal.modal-visible {
            opacity: 1 !important;
            transform: translate(-50%, -50%) scale(1) !important;
            pointer-events: auto;
        }

        /* 弹窗背景遮罩 */
        .modal-backdrop {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.6);
            backdrop-filter: blur(4px);
            z-index: 9999;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.3s ease;
        }

        .modal-backdrop.show {
            opacity: 1;
            pointer-events: auto;
        }

        .action-card {
            transition: all 0.4s ease !important;
            cursor: pointer;
        }

        .action-card:hover {
            transform: translateY(-8px) scale(1.03);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.3) !important;
            border-color: rgba(255, 255, 255, 0.3) !important;
        }

        .action-card .icon-box {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1rem;
            font-size: 1.8rem;
            transition: all 0.3s ease;
        }

        .action-card:hover .icon-box {
            transform: scale(1.1) rotate(5deg);
        }

        .icon-apply { background: rgba(255, 139, 167, 0.2); color: #ff8ba7; }
        .icon-announce { background: rgba(255, 193, 7, 0.2); color: #ffc107; }
        .icon-edit { background: rgba(32, 201, 151, 0.2); color: #20c997; }
        .icon-disband { background: rgba(233, 69, 96, 0.2); color: #e94560; }

        .org-card {
            transition: all 0.35s ease !important;
            position: relative;
            overflow: hidden;
        }

        .org-card:hover {
            transform: translateY(-6px) scale(1.02);
            box-shadow: 0 12px 30px rgba(0,0,0,0.25) !important;
            border-color: #ff8ba7 !important;
        }

        .col:nth-child(1) .glass-card { animation-delay: 0.2s; }
        .col:nth-child(2) .glass-card { animation-delay: 0.3s; }
        .col:nth-child(3) .glass-card { animation-delay: 0.4s; }

        .panel-delay-1 { animation-delay: 0.15s !important; }
        .panel-delay-2 { animation-delay: 0.25s !important; }
        .panel-delay-3 { animation-delay: 0.35s !important; }

        .table { color: rgba(255,255,255,0.9) !important; border-color: rgba(255,255,255,0.1) !important; }
        .table-hover > tbody > tr:hover { background-color: rgba(255,139,167,0.18) !important; }
        .table-hover > tbody > tr:hover td { color: #fff !important; }
        .panel-as-modal .table-hover > tbody > tr:hover { background-color: rgba(255,139,167,0.25) !important; }
        .table th { color: rgba(255,255,255,0.75) !important; border-bottom: 1px solid rgba(255,255,255,0.1) !important; }

        .form-control {
            background: rgba(255,255,255,0.1) !important;
            border: 1px solid rgba(255,255,255,0.2) !important;
            color: #fff !important;
            border-radius: 8px !important;
            transition: all 0.3s;
        }
        .form-control:focus {
            background: rgba(255,255,255,0.15) !important;
            border-color: #ff8ba7 !important;
            box-shadow: 0 0 10px rgba(255,139,167,0.3) !important;
            outline: none;
        }

        .btn-primary {
            background: #ff8ba7 !important;
            border: 2px solid #ff8ba7 !important;
            border-radius: 8px !important;
            font-weight: 500 !important;
            transition: all 0.3s ease !important;
        }
        .btn-primary:hover {
            background: transparent !important;
            color: #ff8ba7 !important;
            transform: translateY(-2px) !important;
            box-shadow: 0 4px 12px rgba(255, 139, 167, 0.3) !important;
        }

        .btn-warning {
            background: #ffc107 !important;
            border: 2px solid #ffc107 !important;
            border-radius: 8px !important;
            color: #000 !important;
            font-weight: 500 !important;
            transition: all 0.3s ease !important;
        }
        .btn-warning:hover {
            background: transparent !important;
            color: #ffc107 !important;
            transform: translateY(-2px) !important;
            box-shadow: 0 4px 12px rgba(255, 193, 7, 0.3) !important;
        }

        .btn-success {
            background: #20c997 !important;
            border: 2px solid #20c997 !important;
            border-radius: 8px !important;
            color: #fff !important;
            font-weight: 500 !important;
            transition: all 0.3s ease !important;
        }
        .btn-success:hover {
            background: transparent !important;
            color: #20c997 !important;
            transform: translateY(-2px) !important;
            box-shadow: 0 4px 12px rgba(32, 201, 151, 0.3) !important;
        }

        .btn-danger {
            background: #e94560 !important;
            border: 2px solid #e94560 !important;
            border-radius: 8px !important;
            color: #fff !important;
            font-weight: 500 !important;
            transition: all 0.3s ease !important;
        }
        .btn-danger:hover {
            background: transparent !important;
            color: #e94560 !important;
            transform: translateY(-2px) !important;
            box-shadow: 0 4px 12px rgba(233, 69, 96, 0.3) !important;
        }

        .btn-outline-primary { border-color: #ff8ba7 !important; color: #ff8ba7 !important; }
        .btn-outline-primary:hover { background: #ff8ba7 !important; color: #fff !important; }

        .list-group-item {
            background: rgba(255,255,255,0.06) !important;
            border-color: rgba(255,255,255,0.1) !important;
            color: #fff !important;
        }

        .badge { animation: badgePulse 2s infinite alternate; }
        @keyframes badgePulse {
            from { box-shadow: 0 0 6px #ff8ba7; }
            to { box-shadow: 0 0 14px #ff8ba7; }
        }

        .text-muted { color: rgba(255,255,255,0.65) !important; }
        .card-header { background: transparent !important; border-bottom: 1px solid rgba(255,255,255,0.1) !important; color: #fff !important; }
        .alert-success { background: rgba(25,135,84,0.2) !important; border-color: rgba(25,135,84,0.3) !important; color: #fff !important; }
        .alert-danger { background: rgba(233,69,96,0.2) !important; border-color: rgba(233,69,96,0.3) !important; color: #fff !important; }

        #imgLogoPreview {
            max-width: 100px;
            max-height: 100px;
            border-radius: 8px;
            object-fit: cover;
            margin-top: 10px;
            display: none;
        }

        .my-org-logo {
            width: 56px;
            height: 56px;
            border-radius: 14px;
            object-fit: cover;
            flex-shrink: 0;
            border: 1px solid rgba(255,255,255,0.25);
        }
        .my-org-logoph {
            width: 56px;
            height: 56px;
            border-radius: 14px;
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,0.06);
            border: 1px dashed rgba(255,255,255,0.28);
            color: rgba(255,255,255,0.55);
            font-size: 11px;
            letter-spacing: 1px;
        }
        .org-meta {
            display: flex;
            align-items: center;
            gap: 6px;
            flex-wrap: wrap;
            margin-top: 8px;
        }
        .org-chip {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 3px 10px;
            border-radius: 20px;
            background: rgba(255,255,255,0.08);
            border: 1px solid rgba(255,255,255,0.12);
            font-size: 12px;
            color: rgba(255,255,255,0.85);
            white-space: nowrap;
        }
        .org-chip i {
            font-size: 12px;
            color: #ff8ba7;
        }
        .org-actions {
            display: flex;
            gap: 8px;
            margin-top: 14px;
            padding-top: 14px;
            border-top: 1px solid rgba(255,255,255,0.1);
        }

        .org-select-row {
            background: rgba(255,255,255,0.08);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255,255,255,0.15);
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 30px;
            display: none;
        }
        .form-select {
            background: rgba(255,255,255,0.15) !important;
            border: 1px solid rgba(255,255,255,0.3) !important;
            color: #fff !important;
            border-radius: 10px !important;
        }
        .form-select option {
            background: #222 !important;
            color: #fff !important;
        }

        /* 日期/时间选择器深色样式 */
        input[type="date"],
        input[type="datetime-local"],
        input[type="time"] {
            background: rgba(255,255,255,0.15) !important;
            border: 1px solid rgba(255,255,255,0.3) !important;
            color: #fff !important;
            border-radius: 10px !important;
            color-scheme: dark;
        }
        input[type="date"]::-webkit-calendar-picker-indicator,
        input[type="datetime-local"]::-webkit-calendar-picker-indicator,
        input[type="time"]::-webkit-calendar-picker-indicator {
            filter: invert(1) brightness(0.9);
            cursor: pointer;
            opacity: 0.8;
            transition: opacity 0.2s;
        }
        input[type="date"]::-webkit-calendar-picker-indicator:hover,
        input[type="datetime-local"]::-webkit-calendar-picker-indicator:hover,
        input[type="time"]::-webkit-calendar-picker-indicator:hover {
            opacity: 1;
        }

        .btn-close-modal {
            background: rgba(255,255,255,0.15);
            border: none;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            color: #fff;
            font-size: 18px;
            cursor: pointer;
            transition: 0.2s;
            line-height: 1;
        }
        .btn-close-modal:hover { background: rgba(233,69,96,0.7); }
    </style>

    <div class="container my-4">
        <h3 class="fw-bold mb-4 page-title"><i class="bi bi-gear me-2"></i>组织管理</h3>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Always" ChildrenAsTriggers="true">
            <Triggers>
                <asp:PostBackTrigger ControlID="btnSaveEdit" />
            </Triggers>
            <ContentTemplate>
                <!-- 顶部快捷模块 -->
                <div class="row g-4 mb-5">
                    <div class="col-md-3">
                        <div class="glass-card action-card p-4 h-100">
                            <div class="icon-box icon-apply"><i class="bi bi-building-add"></i></div>
                            <h5 class="fw-bold mb-2">申请创建组织</h5>
                            <p class="text-muted small mb-3">提交新组织创建申请</p>
                            <a href='<%= ResolveUrl("~/Orgs/Apply.aspx") %>' class="btn btn-primary w-100 py-2">
                                <i class="bi bi-plus-circle me-2"></i>立即申请
                            </a>
                        </div>
                    </div>

                    <div class="col-md-3">
                        <div class="glass-card action-card p-4 h-100">
                            <div class="icon-box icon-announce"><i class="bi bi-megaphone"></i></div>
                            <h5 class="fw-bold mb-2">发布组织公告</h5>
                            <p class="text-muted small mb-3">向成员发布最新动态</p>
                            <asp:Button ID="btnGoAnnounceSelect" runat="server" Text="发布公告" CssClass="btn btn-warning w-100 py-2" OnClick="btnGoAnnounceSelect_Click" />
                        </div>
                    </div>

                    <div class="col-md-3">
                        <div class="glass-card action-card p-4 h-100">
                            <div class="icon-box icon-edit"><i class="bi bi-pencil-square"></i></div>
                            <h5 class="fw-bold mb-2">修改组织信息</h5>
                            <p class="text-muted small mb-3">修改名称、Logo、简介</p>
                            <asp:Button ID="btnGoEditSelect" runat="server" Text="编辑信息" CssClass="btn btn-success w-100 py-2" OnClick="btnGoEditSelect_Click" />
                        </div>
                    </div>

                    <div class="col-md-3">
                        <div class="glass-card action-card p-4 h-100">
                            <div class="icon-box icon-disband"><i class="bi bi-trash3"></i></div>
                            <h5 class="fw-bold mb-2">解散组织申请</h5>
                            <p class="text-muted small mb-3">需上级审核通过</p>
                            <asp:Button ID="btnGoDisbandSelect" runat="server" Text="申请解散" CssClass="btn btn-danger w-100 py-2" OnClick="btnGoDisbandSelect_Click" />
                        </div>
                    </div>
                </div>

                <!-- 组织选择栏 -->
                <asp:Panel ID="panelOrgSelectRow" runat="server" ClientIDMode="Static" CssClass="org-select-row" Style="display:none;">
                    <label class="form-label fw-bold mb-2">请选择要操作的组织</label>
                    <div class="d-flex gap-3 align-items-center">
                        <asp:DropDownList ID="ddlMyOrgSelect" runat="server" CssClass="form-select w-50"></asp:DropDownList>
                        <asp:Button ID="btnConfirmOrg" runat="server" Text="确定选择" CssClass="btn btn-primary" OnClick="btnConfirmOrg_Click" />
                    </div>
                    <asp:HiddenField ID="hfOperType" runat="server" />
                </asp:Panel>

                <!-- 我管理的组织列表 -->
                <h4 class="fw-bold mb-3 mt-5"><i class="bi bi-list-ul me-2"></i>我的组织</h4>
                <div class="row g-4 mb-4">
                    <asp:Repeater ID="rptMyOrgs" runat="server" OnItemCommand="RptMyOrgs_ItemCommand">
                        <ItemTemplate>
                            <div class="col-md-6 col-lg-6">
                                <div class="card border-0 shadow-sm h-100 glass-card org-card">
                                    <div class="card-body p-3">
                                        <div class="d-flex align-items-start gap-3">
                                            <%# string.IsNullOrEmpty(Eval("LogoUrl").ToString())
                                                ? "<div class=\"my-org-logoph\">暂无logo</div>"
                                                : string.Format("<img src=\"{0}\" class=\"my-org-logo\" alt=\"Logo\">", ResolveUrl(Eval("LogoUrl").ToString())) %>
                                            <div class="flex-grow-1">
                                                <div class="d-flex align-items-center justify-content-between gap-2">
                                                    <h6 class="fw-bold mb-0"><%# Eval("OrgName") %></h6>
                                                    <span class='badge <%# Convert.ToInt32(Eval("Status"))==1?"bg-success":"bg-warning text-dark" %>'>
                                                        <%# OrgManage.APP_Code.Utils.GetOrgStatus(Convert.ToInt32(Eval("Status"))) %>
                                                    </span>
                                                </div>
                                                <div class="org-meta">
                                                    <span class="org-chip"><i class="bi bi-diagram-3"></i><%# Eval("CategoryName") %></span>
                                                    <span class="org-chip"><i class="bi bi-people"></i><%# Eval("MemberCount") %>名成员</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="org-actions">
                                            <asp:LinkButton runat="server"
                                                CssClass="btn btn-sm btn-outline-primary flex-fill"
                                                CommandName="Members"
                                                CommandArgument='<%# Eval("OrgID") %>'>
                                                <i class="bi bi-people"></i> 成员
                                            </asp:LinkButton>
                                            <asp:LinkButton runat="server"
                                                CssClass="btn btn-sm btn-outline-warning flex-fill"
                                                CommandName="Recruit"
                                                CommandArgument='<%# Eval("OrgID") %>'>
                                                <i class="bi bi-megaphone"></i> 招新
                                            </asp:LinkButton>
                                            <asp:LinkButton runat="server"
                                                CssClass="btn btn-sm btn-outline-success flex-fill"
                                                CommandName="Activity"
                                                CommandArgument='<%# Eval("OrgID") %>'>
                                                <i class="bi bi-calendar"></i> 活动
                                            </asp:LinkButton>
                                            <asp:LinkButton runat="server"
                                                CssClass="btn btn-sm btn-outline-info flex-fill"
                                                CommandName="Announce"
                                                CommandArgument='<%# Eval("OrgID") %>'>
                                                <i class="bi bi-bell"></i> 公告
                                            </asp:LinkButton>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <!-- 1. 公告面板 -->
                <asp:Panel ID="panelAnnounce" runat="server" ClientIDMode="Static" Style="display:none;" CssClass="card border-0 shadow-sm mb-4 glass-card panel-delay-1">
                    <div class="card-header bg-white border-0 fw-bold pt-3 d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-megaphone me-2"></i>组织公告 <asp:Literal ID="litAnnounceOrg" runat="server" /></span>
                        <button class="btn-close-modal" onclick="closeModal(); return false;">×</button>
                    </div>
                    <div class="card-body p-4">
                        <asp:Panel ID="panelAnnounceMsg" runat="server" Visible="false" CssClass="alert alert-success small mb-3"></asp:Panel>
                        <div class="row g-3 mb-4">
                            <div class="col-12">
                                <label class="form-label">公告标题</label>
                                <asp:TextBox ID="txtAnnTitle" runat="server" CssClass="form-control" MaxLength="200" />
                            </div>
                            <div class="col-12">
                                <label class="form-label">公告内容</label>
                                <asp:TextBox ID="txtAnnContent" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="5" />
                            </div>
                            <div class="col-12">
                                <asp:Button ID="btnSaveAnnounce" runat="server" Text="发布公告" CssClass="btn btn-primary" OnClick="btnSaveAnnounce_Click" />
                            </div>
                        </div>

                        <hr class="border-light opacity-25 mb-4">
                        <h6 class="fw-bold mb-2">已发布公告</h6>
                        <asp:Repeater ID="rptAnnounceList" runat="server" OnItemCommand="RptAnnounceList_ItemCommand">
                            <HeaderTemplate><div class="list-group"></HeaderTemplate>
                            <ItemTemplate>
                                <div class="list-group-item">
                                    <div class="d-flex justify-content-between align-items-start mb-1">
                                        <h6 class="mb-0"><%# Eval("Title") %></h6>
                                        <div class="d-flex align-items-center gap-2 flex-shrink-0">
                                            <small class="text-muted text-nowrap"><%# Convert.ToDateTime(Eval("PublishTime")).ToString("yyyy-MM-dd HH:mm") %></small>
                                            <asp:LinkButton runat="server" CssClass="btn btn-sm btn-danger" CommandName="Delete" CommandArgument='<%# Eval("AnnouncementID") %>' OnClientClick="return confirm('确定删除这条公告？');">删除</asp:LinkButton>
                                        </div>
                                    </div>
                                    <p class="mb-2 small" style="white-space:pre-wrap;"><%# Eval("Content") %></p>
                                    <small class="text-muted">发布人：<%# Eval("PublisherName") %></small>
                                </div>
                            </ItemTemplate>
                            <FooterTemplate></div></FooterTemplate>
                        </asp:Repeater>
                        <asp:Label ID="lblNoAnnounce" runat="server" CssClass="text-center text-muted py-3 d-block" Visible="false">暂无公告</asp:Label>
                    </div>
                </asp:Panel>

                <!-- 2. 成员面板 -->
                <asp:Panel ID="panelMembers" runat="server" ClientIDMode="Static" Style="display:none;" CssClass="card border-0 shadow-sm mb-4 glass-card panel-delay-1">
                    <div class="card-header bg-white border-0 fw-bold pt-3 d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-people me-2"></i>成员管理 - <asp:Literal ID="litCurrentOrg" runat="server" /></span>
                        <button class="btn-close-modal" onclick="closeModal(); return false;">×</button>
                    </div>
                    <div class="card-body p-4">
                        <div class="mb-4">
                            <h6 class="fw-bold mb-3">添加成员（请输入学号）</h6>
                            <div class="d-flex gap-2">
                                <asp:TextBox ID="txtAddStudentNo" runat="server" CssClass="form-control" placeholder="请输入学号" />
                                <asp:Button ID="btnAddMember" runat="server" Text="添加成员" CssClass="btn btn-success" OnClick="btnAddMember_Click" />
                                <asp:Button ID="btnCancelAdd" runat="server" Text="清空" CssClass="btn btn-outline-primary" OnClick="btnCancelAdd_Click" />
                            </div>
                            <asp:Panel ID="panelAddMsg" runat="server" Visible="false" CssClass="mt-2 small"></asp:Panel>
                        </div>
                        <asp:GridView ID="gvMembers" runat="server" CssClass="table table-hover mb-0"
                            AutoGenerateColumns="false" GridLines="None"
                            OnRowCommand="gvMembers_RowCommand"
                            DataKeyNames="MemberID,UserID">
                            <Columns>
                                <asp:BoundField DataField="StudentNo" HeaderText="学号" />
                                <asp:BoundField DataField="UserName" HeaderText="姓名" />
                                <asp:BoundField DataField="College" HeaderText="学院" />
                                <asp:TemplateField HeaderText="角色">
                                    <ItemTemplate>
                                        <%# Convert.ToInt32(Eval("MemberRole"))==3?"<span class='badge bg-danger'>社长</span>":Convert.ToInt32(Eval("MemberRole"))==2?"<span class='badge bg-warning text-dark'>干部</span>":"<span class='badge bg-secondary'>成员</span>" %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="JoinDate" HeaderText="加入日期" DataFormatString="{0:yyyy-MM-dd}" />
                                <asp:TemplateField HeaderText="操作">
                                    <ItemTemplate>
                                        <asp:LinkButton runat="server" CssClass="btn btn-sm btn-danger"
                                            CommandName="Remove"
                                            CommandArgument='<%# Eval("MemberID") %>'
                                            OnClientClick="return confirm('确定移出该成员？');"
                                            Visible='<%# Convert.ToInt32(Eval("MemberRole")) < 3 %>'>
                                            移出
                                        </asp:LinkButton>
                                        <asp:Label runat="server" Text="社长不可移出" CssClass="text-muted small"
                                            Visible='<%# Convert.ToInt32(Eval("MemberRole")) >= 3 %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate><p class="text-center text-muted py-3">暂无成员</p></EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </asp:Panel>

                <!-- 3. 招新面板 -->
                <asp:Panel ID="panelRecruit" runat="server" ClientIDMode="Static" Style="display:none;" CssClass="card border-0 shadow-sm mb-4 glass-card panel-delay-1">
                    <div class="card-header bg-white border-0 fw-bold pt-3 d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-megaphone me-2"></i>招新管理</span>
                        <button class="btn-close-modal" onclick="closeModal(); return false;">×</button>
                    </div>
                    <div class="card-body p-4">
                        <asp:Panel ID="panelRecruitMsg" runat="server" Visible="false" CssClass="alert alert-danger small mb-3"></asp:Panel>
                        <div class="row g-3 mb-4">
                            <div class="col-12"><h6 class="fw-bold">发布新招新</h6></div>
                            <div class="col-md-6">
                                <label class="form-label">标题</label>
                                <asp:TextBox ID="txtRecruitTitle" runat="server" CssClass="form-control" MaxLength="200" />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">开始日期</label>
                                <asp:TextBox ID="txtRecruitStart" runat="server" CssClass="form-control" TextMode="Date" />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">截止日期</label>
                                <asp:TextBox ID="txtRecruitEnd" runat="server" CssClass="form-control" TextMode="Date" />
                            </div>
                            <div class="col-md-12">
                                <label class="form-label">招新内容</label>
                                <asp:TextBox ID="txtRecruitContent" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                            </div>
                            <div class="col-md-8">
                                <label class="form-label">报名要求</label>
                                <asp:TextBox ID="txtRecruitReq" runat="server" CssClass="form-control" MaxLength="1000" />
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">招募名额（0=不限）</label>
                                <asp:TextBox ID="txtRecruitQuota" runat="server" CssClass="form-control" Text="0" />
                            </div>
                            <div class="col-12">
                                <asp:HiddenField ID="hfCurrentOrgID" runat="server" />
                                <asp:Button ID="btnPublishRecruit" runat="server" Text="发布招新" CssClass="btn btn-warning" OnClick="BtnPublishRecruit_Click" OnClientClick="return checkRecruit();" />
                            </div>
                        </div>
                        <h6 class="fw-bold mb-2">报名审核</h6>
                        <asp:Repeater ID="rptRecruitList" runat="server" OnItemCommand="RptRecruitList_ItemCommand">
                            <HeaderTemplate><div class="list-group"></HeaderTemplate>
                            <ItemTemplate>
                                <div class="list-group-item d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="mb-1"><%# Eval("Title") %></h6>
                                        <small class="text-muted">截止 <%# Convert.ToDateTime(Eval("EndDate")).ToString("yyyy-MM-dd") %> | 已报名 <%# Eval("AppCount") %> 人</small>
                                    </div>
                                    <asp:LinkButton runat="server" CssClass="btn btn-sm btn-primary" CommandName="ViewApps" CommandArgument='<%# Eval("RecruitID") %>'>查看报名</asp:LinkButton>
                                </div>
                            </ItemTemplate>
                            <FooterTemplate></div></FooterTemplate>
                        </asp:Repeater>
                    </div>
                </asp:Panel>

                <!-- 4. 报名审核面板 -->
                <asp:Panel ID="panelApps" runat="server" ClientIDMode="Static" Style="display:none;" CssClass="card border-0 shadow-sm mb-4 glass-card panel-delay-2">
                    <div class="card-header bg-white border-0 fw-bold pt-3 d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-file-check me-2"></i>报名名单审核</span>
                        <button class="btn-close-modal" onclick="closeModal(); return false;">×</button>
                    </div>
                    <div class="card-body p-0">
                        <asp:GridView ID="gvApps" runat="server" CssClass="table table-hover mb-0" AutoGenerateColumns="false" GridLines="None" OnRowCommand="GvApps_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="StudentNo" HeaderText="学号" />
                                <asp:BoundField DataField="UserName" HeaderText="姓名" />
                                <asp:BoundField DataField="College" HeaderText="学院" />
                                <asp:BoundField DataField="SelfIntro" HeaderText="自我介绍" />
                                <asp:BoundField DataField="ApplyTime" HeaderText="报名时间" DataFormatString="{0:MM-dd HH:mm}" />
                                <asp:TemplateField HeaderText="状态">
                                    <ItemTemplate>
                                        <span class='badge <%# Convert.ToInt32(Eval("Status"))==0?"bg-warning text-dark":Convert.ToInt32(Eval("Status"))==1?"bg-success":"bg-danger" %>'>
                                            <%# Convert.ToInt32(Eval("Status"))==0?"待审核":Convert.ToInt32(Eval("Status"))==1?"已录用":"已拒绝" %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="操作">
                                    <ItemTemplate>
                                        <asp:LinkButton runat="server" CssClass="btn btn-sm btn-success me-1" CommandName="Approve" CommandArgument='<%# Eval("AppID") %>' Visible='<%# Convert.ToInt32(Eval("Status"))==0 %>'>录用</asp:LinkButton>
                                        <asp:LinkButton runat="server" CssClass="btn btn-sm btn-danger" CommandName="Reject" CommandArgument='<%# Eval("AppID") %>' Visible='<%# Convert.ToInt32(Eval("Status"))==0 %>'>拒绝</asp:LinkButton>
                                        <asp:Label runat="server" CssClass="text-muted small" Style="opacity:0.6;" Text="已处理" Visible='<%# Convert.ToInt32(Eval("Status"))!=0 %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate><p class="text-center text-muted py-3">暂无报名</p></EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </asp:Panel>

                <!-- 5. 活动面板 -->
                <asp:Panel ID="panelActivity" runat="server" ClientIDMode="Static" Style="display:none;" CssClass="card border-0 shadow-sm mb-4 glass-card panel-delay-1">
                    <div class="card-header bg-white border-0 fw-bold pt-3 d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-calendar-event me-2"></i>活动管理</span>
                        <button class="btn-close-modal" onclick="closeModal(); return false;">×</button>
                    </div>
                    <div class="card-body p-4">
                        <asp:Panel ID="panelOrgNotActive" runat="server" Visible="false" CssClass="alert alert-danger mb-3">
                            <i class="bi bi-exclamation-triangle me-2"></i>组织状态异常，无法发布活动！
                        </asp:Panel>
                        <div class="row g-3 mb-4">
                            <div class="col-12"><h6 class="fw-bold">发布新活动（无需审批）</h6></div>
                            <div class="col-md-8">
                                <label class="form-label">活动标题</label>
                                <asp:TextBox ID="txtActTitle" runat="server" CssClass="form-control" MaxLength="200" />
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">活动地点</label>
                                <asp:TextBox ID="txtActLocation" runat="server" CssClass="form-control" MaxLength="200" />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">开始时间</label>
                                <asp:TextBox ID="txtActStart" runat="server" CssClass="form-control" TextMode="DateTimeLocal" />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">结束时间</label>
                                <asp:TextBox ID="txtActEnd" runat="server" CssClass="form-control" TextMode="DateTimeLocal" />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">报名上限</label>
                                <asp:TextBox ID="txtActMax" runat="server" CssClass="form-control" Text="0" />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">参与范围</label>
                                <asp:DropDownList ID="ddlParticipationScope" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="所有人均可参与" Value="0" />
                                    <asp:ListItem Text="仅限本组织成员参与" Value="1" />
                                    <asp:ListItem Text="仅限本学院学生参与" Value="2" />
                                </asp:DropDownList>
                            </div>
                            <div class="col-12">
                                <label class="form-label">活动介绍</label>
                                <asp:TextBox ID="txtActDesc" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                            </div>
                            <div class="col-12">
                                <asp:Button ID="btnPublishAct" runat="server" Text="发布活动" CssClass="btn btn-success" OnClick="BtnPublishAct_Click" OnClientClick="return checkActivity();" />
                                <asp:Panel ID="panelActMsg" runat="server" Visible="false" CssClass="mt-2 alert alert-success small">活动发布成功！</asp:Panel>
                            </div>
                        </div>
                        <hr class="border-light opacity-25 mb-4">
                        <h6 class="fw-bold mb-2">已发布活动列表</h6>
                        <asp:Repeater ID="rptActivityList" runat="server" OnItemCommand="RptActivityList_ItemCommand">
                            <HeaderTemplate><div class="list-group"></HeaderTemplate>
                            <ItemTemplate>
                                <div class="list-group-item d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="mb-1"><%# Eval("Title") %></h6>
                                        <small class="text-muted">
                                            <%# Convert.ToDateTime(Eval("StartTime")).ToString("yyyy-MM-dd HH:mm") %> | 
                                            <%# Eval("Location") %> | 
                                            <%# Eval("EnrollCount") %>/<%# Eval("MaxEnroll") %> 人报名
                                        </small>
                                    </div>
                                    <asp:LinkButton runat="server" CssClass="btn btn-sm btn-primary" CommandName="ViewEnrolls" CommandArgument='<%# Eval("ActivityID") %>'>查看报名</asp:LinkButton>
                                </div>
                            </ItemTemplate>
                            <FooterTemplate></div></FooterTemplate>
                        </asp:Repeater>
                    </div>
                </asp:Panel>

                <!-- 活动报名学生列表面板 -->
                <asp:Panel ID="panelActivityEnrolls" runat="server" ClientIDMode="Static" Style="display:none;" CssClass="card border-0 shadow-sm mb-4 glass-card panel-delay-2">
                    <div class="card-header bg-white border-0 fw-bold pt-3 d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-person-lines-fill me-2"></i>活动报名名单</span>
                        <button class="btn-close-modal" onclick="closeModal(); return false;">×</button>
                    </div>
                    <div class="card-body p-0">
                        <asp:GridView ID="gvActivityEnrolls" runat="server" CssClass="table table-hover mb-0" AutoGenerateColumns="false" GridLines="None">
                            <Columns>
                                <asp:BoundField DataField="StudentNo" HeaderText="学号" />
                                <asp:BoundField DataField="UserName" HeaderText="姓名" />
                                <asp:BoundField DataField="College" HeaderText="学院" />
                                <asp:BoundField DataField="EnrollTime" HeaderText="报名时间" DataFormatString="{0:MM-dd HH:mm}" />
                            </Columns>
                            <EmptyDataTemplate><p class="text-center text-muted py-3">暂无报名</p></EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </asp:Panel>

                <!-- 6. 修改组织信息面板 -->
                <asp:Panel ID="panelEdit" runat="server" ClientIDMode="Static" Style="display:none;" CssClass="card border-0 shadow-sm mb-4 glass-card panel-delay-1">
                    <div class="card-header bg-white border-0 fw-bold pt-3 d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-pencil-square me-2"></i>修改组织信息</span>
                        <button class="btn-close-modal" onclick="closeModal(); return false;">×</button>
                    </div>
                    <div class="card-body p-4">
                        <asp:Panel ID="panelEditMsg" runat="server" Visible="false" CssClass="mb-3 small"></asp:Panel>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">组织名称</label>
                                <asp:TextBox ID="txtEditOrgName" runat="server" CssClass="form-control" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">最大成员数</label>
                                <asp:TextBox ID="txtEditMaxMembers" runat="server" CssClass="form-control" />
                            </div>
                            <div class="col-12">
                                <label class="form-label">组织简介</label>
                                <asp:TextBox ID="txtEditDesc" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                            </div>
                            <div class="col-12">
                                <label class="form-label">联系方式</label>
                                <asp:TextBox ID="txtEditContact" runat="server" CssClass="form-control" />
                            </div>
                            <div class="col-12">
                                <label class="form-label">组织Logo</label>
                                <asp:FileUpload ID="fuEditLogo" runat="server" CssClass="form-control" Accept="image/png,image/jpeg,image/gif" />
                                <img id="imgLogoPreview" alt="预览" />
                                <small class="text-muted d-block mt-1">支持JPG/PNG/GIF，≤2MB</small>
                            </div>
                            <div class="col-12">
                                <asp:Button ID="btnSaveEdit" runat="server" Text="保存修改" CssClass="btn btn-primary" OnClick="btnSaveEdit_Click" />
                            </div>
                        </div>
                    </div>
                </asp:Panel>

                <!-- 7. 解散组织申请面板 -->
                <asp:Panel ID="panelDisband" runat="server" ClientIDMode="Static" Style="display:none;" CssClass="card border-0 shadow-sm mb-4 glass-card panel-delay-1">
                    <div class="card-header bg-white border-0 fw-bold pt-3 d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-trash3 me-2"></i>申请解散组织</span>
                        <button class="btn-close-modal" onclick="closeModal(); return false;">×</button>
                    </div>
                    <div class="card-body p-4">
                        <asp:Panel ID="panelDisbandMsg" runat="server" Visible="false" CssClass="mb-3 small"></asp:Panel>
                        <div class="alert alert-danger small mb-3">提交后需上级管理员审核通过，组织才会正式解散！</div>
                        <div class="mb-3">
                            <label class="form-label">解散原因</label>
                            <asp:TextBox ID="txtDisbandReason" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="请说明解散原因" />
                        </div>
                        <asp:Button ID="btnSubmitDisband" runat="server" Text="提交解散申请" CssClass="btn btn-danger" OnClick="btnSubmitDisband_Click" />
                    </div>
                </asp:Panel>
            </ContentTemplate>
        </asp:UpdatePanel>

        <script type="text/javascript">
            // 当前打开的面板ID
            var currentModalPanelId = null;

            function openModal(panelId) {
                var panel = document.getElementById(panelId);
                if (!panel) return;

                // 如果已经是当前面板且已显示，不重复操作
                if (currentModalPanelId === panelId && panel.classList.contains('modal-visible')) {
                    return;
                }

                // 如果有其他面板开着，立即关闭（无动画切换）
                if (currentModalPanelId && currentModalPanelId !== panelId) {
                    var oldPanel = document.getElementById(currentModalPanelId);
                    if (oldPanel) {
                        oldPanel.classList.remove('modal-visible');
                        oldPanel.classList.remove('panel-as-modal');
                        oldPanel.style.display = 'none';
                    }
                }

                // 显示遮罩
                var backdrop = document.getElementById('modalBackdrop');
                if (backdrop) backdrop.classList.add('show');

                // 设置面板状态
                panel.style.display = 'block';
                panel.classList.add('panel-as-modal');
                document.body.style.overflow = 'hidden';
                currentModalPanelId = panelId;

                // 强制重排，确保 transition 生效
                void panel.offsetWidth;

                // 下一帧添加 visible 类，触发弹性动画
                requestAnimationFrame(function () {
                    panel.classList.add('modal-visible');
                });
            }

            function closeModal() {
                if (!currentModalPanelId) return;

                var panel = document.getElementById(currentModalPanelId);
                var backdrop = document.getElementById('modalBackdrop');

                if (panel) {
                    panel.classList.remove('modal-visible');
                }
                if (backdrop) {
                    backdrop.classList.remove('show');
                }

                // 等动画结束后再完全隐藏
                setTimeout(function () {
                    if (panel) {
                        panel.style.display = 'none';
                        panel.classList.remove('panel-as-modal');
                    }
                    currentModalPanelId = null;
                    document.body.style.overflow = 'auto';
                }, 300);
            }

            function showPanel(panelId) {
                openModal(panelId);
            }

            // 异步回发完成后，恢复当前弹窗的样式（静默恢复，不播动画，避免与服务器新弹窗冲突）
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function (sender, args) {
                if (currentModalPanelId) {
                    var pid = currentModalPanelId;
                    var panel = document.getElementById(pid);
                    if (panel) {
                        // 直接恢复模态状态，不触发动画
                        panel.style.display = 'block';
                        panel.classList.add('panel-as-modal');
                        panel.classList.add('modal-visible');
                        document.body.style.overflow = 'hidden';
                    }
                }
            });

            // 图片预览
            $(function () {
                var fuLogo = $('#<%=fuEditLogo.ClientID%>');
                if (fuLogo.length) {
                    fuLogo.change(function (e) {
                        var reader = new FileReader();
                        reader.onload = function (ev) {
                            $('#imgLogoPreview').attr('src', ev.target.result).show();
                        };
                        reader.readAsDataURL(e.target.files[0]);
                    });
                }
            });

            function checkActivity() {
                var t = $('#<%=txtActTitle.ClientID%>').val().trim(),
                    p = $('#<%=txtActLocation.ClientID%>').val().trim(),
                    s = $('#<%=txtActStart.ClientID%>').val(),
                    e = $('#<%=txtActEnd.ClientID%>').val();
                if (!t || !p || !s || !e) { alert('请填写完整活动信息'); return false; }
                return true;
            }

            function checkRecruit() {
                var t = $('#<%=txtRecruitTitle.ClientID%>').val().trim(),
                    s = $('#<%=txtRecruitStart.ClientID%>').val(),
                    e = $('#<%=txtRecruitEnd.ClientID%>').val();
                if (!t || !s || !e) { alert('请填写完整招新信息'); return false; }
                return true;
            }
        </script>
    </div>
</asp:Content>