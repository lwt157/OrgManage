<%@ Page Title="系统管理中心 - 高校组织综合线上管理平台" Language="C#" MasterPageFile="../Site.master"
    AutoEventWireup="true" CodeFile="Dashboard.aspx.cs" Inherits="OrgManage.Admin_Dashboard" %>
<%@ Import Namespace="System.Data" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
   <link rel="stylesheet" href="<%= ResolveUrl("~/Content/bootstrap-icons/font/bootstrap-icons.min.css") %>" />
    <style>
        body {
            background: url('<%= ResolveUrl("~/images/bg-night.jpg") %>') no-repeat center center fixed !important;
            background-size: cover !important;
            min-height: 100vh !important;
            color: #fff !important;
        }
        /* ========== 卡片样式 - 黄色边框立体设计 ========== */
        .glass-card {
            background: rgba(0, 0, 0, 0.06) !important;
            backdrop-filter: none !important;
            -webkit-backdrop-filter: none !important;
            border: 2px solid rgba(255, 193, 7, 0.35) !important;
            border-radius: 14px !important;
            box-shadow: 
                0 4px 24px rgba(0,0,0,0.35),
                inset 0 1px 0 rgba(255,193,7,0.1),
                inset 0 -2px 0 rgba(0,0,0,0.25) !important;
            transition: all 0.35s ease;
        }
        .glass-card:hover {
            border-color: #ffc107 !important;
            box-shadow: 
                0 8px 36px rgba(0,0,0,0.4),
                0 0 20px rgba(255,193,7,0.2),
                inset 0 1px 0 rgba(255,193,7,0.15) !important;
            transform: translateY(-3px);
        }

        /* 统计卡片 - 黄金边框立体感 + 动画 */
        .stat-card {
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.19, 1, 0.22, 1);
            position: relative;
            overflow: hidden;
            background: rgba(0, 0, 0, 0.06) !important;
            border: 2px solid rgba(255, 193, 7, 0.4) !important;
            box-shadow: 
                0 6px 28px rgba(0,0,0,0.35),
                inset 0 2px 0 rgba(255,193,7,0.12),
                inset 0 -3px 0 rgba(0,0,0,0.3) !important;
        }
        .stat-card::before {
            content: '';
            position: absolute;
            top: -50%; left: -50%;
            width: 200%; height: 200%;
            background: radial-gradient(circle at center, rgba(255,193,7,0.04) 0%, transparent 60%);
            opacity: 0;
            transition: opacity 0.5s;
        }
        .stat-card:hover {
            transform: translateY(-6px) scale(1.02);
            border-color: #ffc107 !important;
            box-shadow: 
                0 20px 48px rgba(0,0,0,0.4),
                0 0 30px rgba(255,193,7,0.2),
                inset 0 1px 0 rgba(255,193,7,0.2) !important;
        }
        .stat-card:hover::before { opacity: 1; }
        .stat-card:active { transform: scale(0.97); }
        .stat-card .stat-label {
            font-size: 0.8rem;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            color: #ffffff !important;
        }
        .stat-card .stat-value {
            font-size: 2.4rem;
            font-weight: 700;
            line-height: 1.1;
            background: linear-gradient(135deg, #ffffff 0%, rgba(255,255,255,0.85) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .stat-card .stat-icon {
            font-size: 2.5rem;
            opacity: 0.7;
            transition: opacity 0.3s, transform 0.3s;
        }
        /* 问题3：统计图标各自颜色 */
        .stat-card:nth-child(1) .stat-icon { color: #60a5fa; }  /* 总用户数 - 蓝 */
        .stat-card:nth-child(2) .stat-icon { color: #34d399; }  /* 正常组织 - 绿 */
        .stat-card:nth-child(3) .stat-icon { color: #fbbf24; }  /* 总活动数 - 金 */
        .stat-card:nth-child(4) .stat-icon { color: #f87171; }  /* 禁用账号 - 红 */
        .stat-card:hover .stat-icon {
            opacity: 0.35;
            transform: scale(1.15) rotate(-5deg);
        }

        /* ========== 表格 hover 保持白色 ========== */
        .table { color: rgba(255,255,255,0.9); margin-bottom: 0; }
        .table th { color: rgba(255,255,255,0.75); border-color: rgba(255,255,255,0.1); font-weight: 500; }
        .table td { border-color: rgba(255,255,255,0.08); vertical-align: middle; }
        .table-hover tbody tr { transition: background-color 0.2s; }
        .table-hover tbody tr:hover {
            background-color: rgba(255,193,7,0.18) !important;
        }
        .table-hover tbody tr:hover td,
        .table-hover tbody tr:hover th {
            color: #fff !important;
        }

        /* ========== Tab导航 ========== */
        .nav-tabs { border-bottom: 1px solid rgba(255,193,7,0.15); }
        .nav-tabs .nav-link {
            color: rgba(255,255,255,0.65);
            border: none;
            background: transparent;
            transition: all 0.3s ease;
            padding: 0.75rem 1.25rem;
            font-weight: 500;
        }
        .nav-tabs .nav-link:hover {
            color: #fff;
            background: rgba(255,193,7,0.06);
        }
        .nav-tabs .nav-link.active {
            color: #ffc107;
            background: rgba(255,193,7,0.08);
            border-bottom: 2px solid #ffc107;
        }

        /* ========== 表单控件 ========== */
        .form-control, .form-select {
            background: rgba(255,255,255,0.1);
            border: 1px solid rgba(255,193,7,0.2);
            color: #fff;
            transition: all 0.2s;
        }
        .form-control::placeholder { color: rgba(255,255,255,0.4); }
        .form-control:focus, .form-select:focus {
            background: rgba(255,255,255,0.15);
            border-color: rgba(255,193,7,0.5);
            color: #fff;
            box-shadow: 0 0 0 0.2rem rgba(255,193,7,0.2);
        }

        /* 下拉选项背景修复（关键！解决白色背景） */
        .form-select option {
            background-color: rgba(30, 30, 50, 0.95) !important;
            color: #fff !important;
        }

        /* 强制禁用/启用按钮白色文字（最高优先级） */
        td .btn.btn-sm,
        td .btn.btn-sm:hover,
        td .btn.btn-sm:active,
        td .btn.btn-sm:focus,
        td .btn.btn-sm.btn-danger,
        td .btn.btn-sm.btn-success,
        td .btn.btn-sm.btn-info {
            color: #fff !important;
        }

        /* 状态徽章文字强制纯白 */
        .badge {
            font-weight: 500;
            padding: 0.5em 0.75em;
            font-size: 0.8em;
            color: #ffffff !important;
        }

        /* ========== 按钮 ========== */
        .btn-outline-primary {
            border-color: #ffc107;
            color: #ffc107;
            transition: all 0.25s;
        }
        .btn-outline-primary:hover {
            background: #ffc107;
            color: #000;
            border-color: #ffc107;
            box-shadow: 0 4px 16px rgba(255,193,7,0.3);
        }
        .btn-outline-primary:active {
            background: #ffca2c !important;
        }
        .btn { transition: all 0.2s; }
        .btn:hover { transform: translateY(-1px); }
        .btn:active { transform: translateY(0); }

        /* ========== Tab入场动画 ========== */
        .tab-pane {
            animation: fadeInUp 0.45s cubic-bezier(0.19, 1, 0.22, 1);
        }
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(16px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .card-header {
            border-bottom: 1px solid rgba(255,193,7,0.12);
            font-weight: 500;
            letter-spacing: 0.3px;
            background: transparent !important;
        }

        /* 问题2：内容撑满视口，防止footer错位 */
        .admin-content { min-height: calc(100vh - 140px); }

        /* 面板标题图标颜色 */
        .card-header .bi-building { color: #60a5fa; }       /* 组织 - 蓝 */
        .card-header .bi-person-lock { color: #a78bfa; }   /* 用户 - 紫 */
        .card-header .bi-calendar-event { color: #fbbf24; }/* 活动 - 金 */
        .card-header .bi-journal-bookmark-fill { color: #34d399; } /* 日志 - 绿 */
        .card-header .bi-shield-check { color: #f472b6; }   /* 安全 - 粉 */

        /* 更多卡片微交互 */
        .card-header i {
            transition: transform 0.3s ease, color 0.3s ease;
            display: inline-block;
        }
        .card-header:hover i {
            transform: scale(1.2) rotate(-5deg);
            filter: brightness(1.3);
        }
        /* 表格行点击脉冲 */
        .table-hover tbody tr:active td {
            background-color: rgba(255,193,7,0.15) !important;
        }

        /* 简约4列网格 */
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1.25rem;
        }
        @media (max-width: 991px) {
            .dashboard-grid { grid-template-columns: repeat(2, 1fr); gap: 1rem; }
        }
        @media (max-width: 575px) {
            .dashboard-grid { grid-template-columns: 1fr; }
        }

        /* 黄色边框脉冲动画 - hover时边框发光 */
        @keyframes borderPulse {
            0%   { border-color: #ffc107; box-shadow: 0 0 10px rgba(255,193,7,0.2); }
            50%  { border-color: #ffdd57; box-shadow: 0 0 25px rgba(255,193,7,0.4); }
            100% { border-color: #ffc107; box-shadow: 0 0 10px rgba(255,193,7,0.2); }
        }
        .card:hover {
            animation: borderPulse 1.5s ease-in-out infinite;
        }
        .stat-card:hover {
            animation: borderPulse 1.5s ease-in-out infinite;
        }
    </style>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <!-- 如果母版页已经有ScriptManager，请注释下面这一行 -->
    <asp:ScriptManager ID="sm" runat="server" EnablePartialRendering="true" />

    <asp:UpdatePanel ID="upMain" runat="server" UpdateMode="Always">
        <Triggers>
            <asp:PostBackTrigger ControlID="btnExportOrgs" />
            <asp:PostBackTrigger ControlID="btnExportActivities" />
            <asp:PostBackTrigger ControlID="btnExportUsers" />
        <asp:PostBackTrigger ControlID="btnUploadLogo" />
        </Triggers>
    <ContentTemplate>
    <div class="container my-4 admin-content">
        <!-- 标题区 -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold mb-0"><i class="bi bi-shield-lock me-2"></i>系统管理中心</h3>
            <span class="badge bg-warning text-dark fs-6 px-3 py-2 rounded-pill"><i class="bi bi-shield-fill-check me-1"></i>系统管理员</span>
        </div>

        <!-- 统计卡片 - 4列网格 -->
        <div class="dashboard-grid mb-4">
            <div class="card stat-card p-3" onclick="pulseCard(this)">
                <div class="d-flex justify-content-between align-items-center h-100 position-relative" style="z-index:1;">
                    <div>
                        <p class="stat-label mb-1">总用户数</p>
                        <div class="stat-value"><asp:Literal ID="litUserCount" runat="server">0</asp:Literal></div>
                    </div>
                    <i class="bi bi-people stat-icon"></i>
                </div>
            </div>
            <div class="card stat-card p-3" onclick="pulseCard(this)">
                <div class="d-flex justify-content-between align-items-center h-100 position-relative" style="z-index:1;">
                    <div>
                        <p class="stat-label mb-1">正常组织</p>
                        <div class="stat-value"><asp:Literal ID="litOrgCount" runat="server">0</asp:Literal></div>
                    </div>
                    <i class="bi bi-building stat-icon"></i>
                </div>
            </div>
            <div class="card stat-card p-3" onclick="pulseCard(this)">
                <div class="d-flex justify-content-between align-items-center h-100 position-relative" style="z-index:1;">
                    <div>
                        <p class="stat-label mb-1">总活动数</p>
                        <div class="stat-value"><asp:Literal ID="litActCount" runat="server">0</asp:Literal></div>
                    </div>
                    <i class="bi bi-calendar3 stat-icon"></i>
                </div>
            </div>
            <div class="card stat-card p-3" onclick="pulseCard(this)">
                <div class="d-flex justify-content-between align-items-center h-100 position-relative" style="z-index:1;">
                    <div>
                        <p class="stat-label mb-1">禁用账号</p>
                        <div class="stat-value"><asp:Literal ID="litBanCount" runat="server">0</asp:Literal></div>
                    </div>
                    <i class="bi bi-person-x stat-icon"></i>
                </div>
            </div>
        </div>

        <!-- Tab 导航 -->
        <ul class="nav nav-tabs mb-3" id="adminTab" role="tablist">
            <li class="nav-item"><a class="nav-link active" data-bs-toggle="tab" href="#orgs" role="tab">🏢 组织管理</a></li>
            <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#users" role="tab">👥 用户管理</a></li>
            <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#activities" role="tab">📅 活动管理</a></li>
            <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#announce" role="tab">📢 系统公告</a></li>
            <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#config" role="tab">⚙️ 系统配置</a></li>
            <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#logs" role="tab">📜 操作日志</a></li>
            <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#batch" role="tab">📎 批量操作</a></li>
            <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#appeal" role="tab">💬 申诉反馈</a></li>
            <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#invitekeys" role="tab">🔑 密钥生成</a></li>
        </ul>

        <div class="tab-content">
            <!-- 1. 组织管理 -->
            <div class="tab-pane fade show active" id="orgs" role="tabpanel">
                <div class="card glass-card">
                    <div class="card-header d-flex justify-content-between align-items-center py-3">
                        <span><i class="bi bi-building me-2"></i>全平台组织管理</span>
                        <asp:Button ID="btnExportOrgs" runat="server" Text="导出组织报表" CssClass="btn btn-sm btn-outline-primary" OnClick="BtnExportOrgs_Click" />
                    </div>
                    <div class="card-body p-0">
                        <asp:GridView ID="gvAllOrgs" runat="server" CssClass="table table-hover table-sm" AutoGenerateColumns="false" GridLines="None" OnRowCommand="GvAllOrgs_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="OrgName" HeaderText="组织名称" />
                                <asp:BoundField DataField="CategoryName" HeaderText="类型" />
                                <asp:BoundField DataField="LeaderName" HeaderText="负责人" />
                                <asp:TemplateField HeaderText="状态">
                                    <ItemTemplate><span class='badge <%# Convert.ToInt32(Eval("Status")) == 1 ? "bg-success" : "bg-danger" %>'><%# Convert.ToInt32(Eval("Status")) == 1 ? "正常" : "已禁用" %></span></ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="操作">
                                    <ItemTemplate><asp:LinkButton runat="server" CssClass='btn btn-sm <%# Convert.ToInt32(Eval("Status")) == 1 ? "btn-danger" : "btn-success" %>' CommandName='<%# Convert.ToInt32(Eval("Status")) == 1 ? "DisableOrg" : "EnableOrg" %>' CommandArgument='<%# Eval("OrgID") %>'><%# Convert.ToInt32(Eval("Status")) == 1 ? "禁用" : "启用" %></asp:LinkButton></ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>

            <!-- 2. 用户管理 -->
            <div class="tab-pane fade" id="users" role="tabpanel">
                <div class="card glass-card">
                    <div class="card-header d-flex justify-content-between align-items-center py-3">
                        <span><i class="bi bi-person-lock me-2"></i>全平台用户管理</span>
                        <div class="input-group w-50"><asp:TextBox ID="txtSearch" runat="server" CssClass="form-control form-control-sm" placeholder="学号/姓名" /><asp:Button ID="btnSearch" runat="server" Text="搜索" CssClass="btn btn-sm btn-outline-primary" OnClick="BtnSearch_Click" /></div>
                    </div>
                    <div class="card-body p-0">
                        <asp:GridView ID="gvUsers" runat="server" CssClass="table table-hover table-sm" AutoGenerateColumns="false" GridLines="None" OnRowCommand="GvUsers_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="StudentNo" HeaderText="学号" />
                                <asp:BoundField DataField="UserName" HeaderText="姓名" />
                                <asp:TemplateField HeaderText="角色"><ItemTemplate><%# GetRoleName(Convert.ToInt32(Eval("Role"))) %></ItemTemplate></asp:TemplateField>
                                <asp:BoundField DataField="College" HeaderText="学院" />
                                <asp:TemplateField HeaderText="状态"><ItemTemplate><span class='badge <%# Convert.ToBoolean(Eval("IsActive")) ? "bg-success" : "bg-danger" %>'><%# Convert.ToBoolean(Eval("IsActive")) ? "正常" : "禁用" %></span></ItemTemplate></asp:TemplateField>
                                <asp:TemplateField HeaderText="操作"><ItemTemplate><asp:LinkButton runat="server" CssClass='btn btn-sm <%# Convert.ToBoolean(Eval("IsActive")) ? "btn-danger" : "btn-success" %>' CommandName='<%# Convert.ToBoolean(Eval("IsActive")) ? "Disable" : "Enable" %>' CommandArgument='<%# Eval("UserID") %>'><%# Convert.ToBoolean(Eval("IsActive")) ? "禁用" : "启用" %></asp:LinkButton></ItemTemplate></asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>

            <!-- 3. 活动管理 -->
            <div class="tab-pane fade" id="activities" role="tabpanel">
                <div class="card glass-card">
                    <div class="card-header d-flex justify-content-between align-items-center py-3">
                        <span><i class="bi bi-calendar-event me-2"></i>全部活动管理</span>
                        <asp:Button ID="btnExportActivities" runat="server" Text="导出活动报表" CssClass="btn btn-sm btn-outline-primary" OnClick="BtnExportActivities_Click" />
                    </div>
                    <div class="card-body p-0">
                        <asp:GridView ID="gvActivities" runat="server" CssClass="table table-hover table-sm" AutoGenerateColumns="false" GridLines="None" OnRowCommand="GvActivities_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="Title" HeaderText="活动名称" />
                                <asp:BoundField DataField="OrgName" HeaderText="主办组织" />
                                <asp:BoundField DataField="StartTime" HeaderText="开始时间" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                                <asp:TemplateField HeaderText="状态"><ItemTemplate><%# GetActivityStatus(Convert.ToInt32(Eval("Status"))) %></ItemTemplate></asp:TemplateField>
                                <asp:TemplateField HeaderText="报名人数"><ItemTemplate><%# GetEnrollCount(Convert.ToInt32(Eval("ActivityID"))) %></ItemTemplate></asp:TemplateField>
                                <asp:TemplateField HeaderText="操作">
                                    <ItemTemplate>
                                        <asp:LinkButton runat="server" CssClass="btn btn-sm btn-danger" CommandName="CancelActivity" CommandArgument='<%# Eval("ActivityID") %>' Visible='<%# Convert.ToInt32(Eval("Status")) != 4 %>' OnClientClick="return confirm('确定取消该活动？')">强制取消</asp:LinkButton>
                                        <asp:LinkButton runat="server" CssClass="btn btn-sm btn-success" CommandName="RestoreActivity" CommandArgument='<%# Eval("ActivityID") %>' Visible='<%# Convert.ToInt32(Eval("Status")) == 4 %>' OnClientClick="return confirm('确定恢复该活动？')">恢复</asp:LinkButton>
                                        <asp:LinkButton runat="server" CssClass="btn btn-sm btn-info ms-1" CommandName="ViewEnrolls" CommandArgument='<%# Eval("ActivityID") %>'>查看报名</asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>

            <!-- 4. 系统公告管理 -->
            <div class="tab-pane fade" id="announce" role="tabpanel">
                <div class="card glass-card mb-3">
                    <div class="card-header py-3">发布新公告</div>
                    <div class="card-body">
                        <div class="row g-2">
                            <div class="col-md-3"><asp:TextBox ID="txtAnnTitle" runat="server" CssClass="form-control" placeholder="标题" /></div>
                            <div class="col-md-6"><asp:TextBox ID="txtAnnContent" runat="server" CssClass="form-control" placeholder="内容" /></div>
                            <div class="col-md-3"><asp:Button ID="btnAddAnn" runat="server" Text="发布公告" CssClass="btn btn-primary w-100" OnClick="BtnAddAnn_Click" /></div>
                        </div>
                    </div>
                </div>
                <div class="card glass-card">
                    <div class="card-header py-3">现有公告列表</div>
                    <div class="card-body p-0">
                        <asp:GridView ID="gvAnnouncements" runat="server" CssClass="table table-hover table-sm" AutoGenerateColumns="false" GridLines="None" OnRowCommand="GvAnnouncements_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="Title" HeaderText="标题" />
                                <asp:BoundField DataField="Content" HeaderText="内容" />
                                <asp:BoundField DataField="PublishByName" HeaderText="发布人" />
                                <asp:BoundField DataField="CreateTime" HeaderText="发布时间" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                                <asp:TemplateField HeaderText="操作"><ItemTemplate><asp:LinkButton runat="server" CommandName="DeleteAnn" CommandArgument='<%# Eval("AnnID") %>' CssClass="btn btn-sm btn-danger" OnClientClick="return confirm('删除公告？')">删除</asp:LinkButton></ItemTemplate></asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>

            
            <!-- 5. 系统配置 -->
<div class="tab-pane fade" id="config" role="tabpanel">
    <div class="row g-4">
        <!-- 系统名称 -->
        <div class="col-md-6">
            <div class="card glass-card h-100">
                <div class="card-header py-3">
                    <i class="bi bi-text-font me-2"></i>系统名称设置
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <label class="form-label">系统显示名称</label>
                        <asp:TextBox ID="txtSystemName" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <asp:Button ID="btnSaveName" runat="server" 
                        Text="保存名称" 
                        CssClass="btn btn-primary"
                        OnClick="btnSaveName_Click" />
                </div>
            </div>
        </div>

        <!-- LOGO上传 -->
        <div class="col-md-6">
            <div class="card glass-card h-100">
                <div class="card-header py-3">
                    <i class="bi bi-image me-2"></i>系统LOGO上传
                </div>
                <div class="card-body text-center">
                    <div class="mb-3">
                        <label class="form-label">当前LOGO</label>
                        <div>
                            <asp:Image ID="imgCurrentLogo" runat="server" 
                                style="height:60px;width:60px;object-fit:cover;border-radius:50%;border:1px solid #ddd;" />
                        </div>
                    </div>

                    <div class="mb-3">
                        <asp:FileUpload ID="fuLogo" runat="server" CssClass="form-control" accept="image/*" />
                        <div class="form-text text-white-50">支持png/jpg，建议32x32，最大200KB</div>
                    </div>

                    <asp:Button ID="btnUploadLogo" runat="server" 
                        Text="上传并保存LOGO" 
                        CssClass="btn btn-success"
                        OnClick="btnUploadLogo_Click" />
                </div>
            </div>
        </div>
    </div>
</div>

            <!-- 6. 操作日志 -->
            <div class="tab-pane fade" id="logs" role="tabpanel">
                <div class="card glass-card">
                    <div class="card-header d-flex justify-content-between align-items-center py-3">
                        <span><i class="bi bi-journal-bookmark-fill me-2"></i>管理员操作日志</span>
                        <asp:Button ID="btnClearLogs" runat="server" Text="清空日志(30天前)" CssClass="btn btn-sm btn-warning" OnClick="BtnClearLogs_Click" OnClientClick="return confirm('清空30天前的操作日志？')" />
                    </div>
                    <div class="card-body p-0">
                        <asp:GridView ID="gvOperationLogs" runat="server" CssClass="table table-sm table-hover" AutoGenerateColumns="true" GridLines="None" AllowPaging="true" PageSize="15" OnPageIndexChanging="GvOperationLogs_PageIndexChanging">
                        </asp:GridView>
                    </div>
                </div>
            </div>

            <!-- 7. 批量操作 -->
            <div class="tab-pane fade" id="batch" role="tabpanel">
                <div class="card glass-card mb-3">
                    <div class="card-header py-3">批量导入用户 (Excel CSV)</div>
                    <div class="card-body">
                        <asp:FileUpload ID="fuUserImport" runat="server" CssClass="form-control mb-2" />
                        <asp:Button ID="btnImportUsers" runat="server" Text="上传并导入" CssClass="btn btn-success" OnClick="BtnImportUsers_Click" />
                        <asp:Label ID="lblImportResult" runat="server" CssClass="ms-2"></asp:Label>
                    </div>
                </div>
                <div class="card glass-card mb-3">
                    <div class="card-header py-3">批量导出用户</div>
                    <div class="card-body"><asp:Button ID="btnExportUsers" runat="server" Text="导出为CSV" CssClass="btn btn-info" OnClick="BtnExportUsers_Click" /></div>
                </div>
                <div class="card glass-card">
                    <div class="card-header py-3">备份全部数据 (CSV)</div>
                    <div class="card-body"><asp:Button ID="btnBackupAll" runat="server" Text="立即备份" CssClass="btn btn-primary" OnClick="BtnBackupAll_Click" /> <asp:Label ID="lblBackupMsg" runat="server" CssClass="ms-2"></asp:Label></div>
                </div>
            </div>

            <!-- 8. 申诉反馈 -->
            <div class="tab-pane fade" id="appeal" role="tabpanel">
                <ul class="nav nav-pills mb-2" id="appealTab" role="tablist">
                    <li class="nav-item"><a class="nav-link" data-bs-toggle="pill" href="#feedbacks">用户反馈</a></li>
                </ul>
                <div class="tab-content">
                    <div class="tab-pane active" id="appeals">
                        <asp:GridView ID="gvAppeals" runat="server" CssClass="table table-hover" AutoGenerateColumns="false" OnRowCommand="GvAppeals_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="UserName" HeaderText="申诉人" />
                                <asp:BoundField DataField="Content" HeaderText="申诉内容" />
                                <asp:TemplateField HeaderText="状态"><ItemTemplate><%# GetAppealStatus(Convert.ToInt32(Eval("Status"))) %></ItemTemplate></asp:TemplateField>
                                <asp:TemplateField HeaderText="处理">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtReply" runat="server" CssClass="form-control form-control-sm" placeholder="回复内容" />
                                        <asp:LinkButton runat="server" CommandName="HandleAppeal" CommandArgument='<%# Eval("AppealID") %>' CssClass="btn btn-sm btn-primary mt-1">通过</asp:LinkButton>
                                        <asp:LinkButton runat="server" CommandName="RejectAppeal" CommandArgument='<%# Eval("AppealID") %>' CssClass="btn btn-sm btn-danger mt-1 ms-1">驳回</asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                    <div class="tab-pane" id="feedbacks">
                        <asp:GridView ID="gvFeedbacks" runat="server" CssClass="table table-hover table-sm" AutoGenerateColumns="false" OnRowCommand="GvFeedbacks_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="UserName" HeaderText="反馈人" />
                                <asp:BoundField DataField="Type" HeaderText="类型" />
                                <asp:BoundField DataField="Content" HeaderText="反馈内容" />
                                <asp:BoundField DataField="Contact" HeaderText="联系方式" />
                                <asp:BoundField DataField="CreateTime" HeaderText="时间" HtmlEncode="false" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                                <asp:TemplateField HeaderText="状态"><ItemTemplate><%# Convert.ToBoolean(Eval("Status")) ? "已读" : "未读" %></ItemTemplate></asp:TemplateField>
                                <asp:TemplateField><ItemTemplate><asp:LinkButton runat="server" CommandName="MarkRead" CommandArgument='<%# Eval("FeedbackID") %>' CssClass="btn btn-sm btn-info">标记已读</asp:LinkButton></ItemTemplate></asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>

            <!-- 9. 邀请密钥生成管理（和系统公告结构完全一致） -->
            <div class="tab-pane fade" id="invitekeys" role="tabpanel">
                <!-- 生成密钥卡片 -->
                <div class="card glass-card mb-3">
                    <div class="card-header py-3">生成邀请密钥</div>
                    <div class="card-body">
                        <div class="row g-2 align-items-end">
                            <div class="col-md-4">
                                <label class="form-label fw-bold">选择角色</label>
                                <asp:DropDownList ID="ddlKeyRole" runat="server" CssClass="form-select">
                                    <asp:ListItem Value="3">院级管理员 (3)</asp:ListItem>
                                    <asp:ListItem Value="4">校级管理员 (4)</asp:ListItem>
                                    <asp:ListItem Value="5">系统管理员 (5)</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-bold">生成的密钥</label>
                                <asp:TextBox ID="txtNewKey" runat="server" CssClass="form-control" ReadOnly="true" placeholder="点击生成按钮后显示" />
                            </div>
                            <div class="col-md-4">
                                <asp:Button ID="btnGenerateKey" runat="server" Text="生成密钥" CssClass="btn btn-primary w-100" OnClick="BtnGenerateKey_Click" />
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 密钥列表卡片 -->
                <div class="card glass-card">
                    <div class="card-header py-3">已生成密钥列表</div>
                    <div class="card-body p-0">
                        <asp:GridView ID="gvInviteKeys" runat="server" CssClass="table table-hover table-sm" AutoGenerateColumns="false" GridLines="None">
                            <Columns>
                                <asp:BoundField DataField="KeyCode" HeaderText="密钥" />
                                <asp:TemplateField HeaderText="对应角色">
                                    <ItemTemplate>
                                        <%# GetRoleName(Convert.ToInt32(Eval("TargetRole"))) %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="状态">
                                    <ItemTemplate>
                                        <span class='badge <%# Convert.ToBoolean(Eval("IsUsed")) ? "bg-secondary" : "bg-success" %>'>
                                            <%# Convert.ToBoolean(Eval("IsUsed")) ? "已使用" : "未使用" %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="CreatedTime" HeaderText="生成时间" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                                <asp:BoundField DataField="ExpireDate" HeaderText="过期时间" DataFormatString="{0:yyyy-MM-dd HH:mm}" NullDisplayText="永久有效" />
                                <asp:BoundField DataField="UsedTime" HeaderText="使用时间" DataFormatString="{0:yyyy-MM-dd HH:mm}" NullDisplayText="-" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
    </div>

    </ContentTemplate>
    </asp:UpdatePanel>

    <script>
        // 数字滚动动画
        function animateCounter(el, target, duration) {
            var start = 0;
            var startTime = null;
            function step(timestamp) {
                if (!startTime) startTime = timestamp;
                var progress = Math.min((timestamp - startTime) / duration, 1);
                var value = Math.floor(progress * (target - start) + start);
                el.textContent = value;
                if (progress < 1) {
                    window.requestAnimationFrame(step);
                } else {
                    el.textContent = target;
                }
            }
            window.requestAnimationFrame(step);
        }

        function initCounters() {
            var statValues = document.querySelectorAll('.stat-value');
            statValues.forEach(function (el) {
                var target = parseInt(el.textContent.trim()) || 0;
                if (target > 0) {
                    el.textContent = '0';
                    animateCounter(el, target, 1000);
                }
            });
        }

        // 卡片点击脉冲
        function pulseCard(card) {
            card.style.transform = 'scale(0.96)';
            setTimeout(function () {
                card.style.transform = '';
            }, 120);
        }

        // Tab持久化
        function initTabRestore() {
            var tabList = document.querySelectorAll('#adminTab a[data-bs-toggle="tab"]');
            tabList.forEach(function (tabEl) {
                tabEl.addEventListener('shown.bs.tab', function (e) {
                    sessionStorage.setItem('adminActiveTab', e.target.getAttribute('href'));
                });
            });
            var savedTab = sessionStorage.getItem('adminActiveTab');
            if (savedTab) {
                var targetTab = document.querySelector('#adminTab a[href="' + savedTab + '"]');
                if (targetTab) {
                    var bsTab = new bootstrap.Tab(targetTab);
                    bsTab.show();
                }
            }
        }

        // 初始加载
        document.addEventListener('DOMContentLoaded', function () {
            initCounters();
            initTabRestore();
        });

        // UpdatePanel异步回发后重新初始化动效
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        if (prm) {
            prm.add_endRequest(function () {
                initCounters();
                initTabRestore();
            });
        }
    </script>
   
</asp:Content>