<%@ Page Title="校级组织管理中心" Language="C#" MasterPageFile="~/Site.master"
         AutoEventWireup="true" CodeFile="SchoolOrgManage.aspx.cs" Inherits="OrgManage.Admin_SchoolOrgManage" %>
<%@ Register Assembly="System.Web.Extensions" Namespace="System.Web.UI" TagPrefix="asp" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet" />
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <style>
        body {
            background: url('<%= ResolveUrl("~/images/bg-night.jpg") %>') no-repeat center center fixed !important;
            background-size: cover !important;
            min-height: 100vh !important;
            color: #fff !important;
        }

        /* ===== 玻璃质感卡片（立体感加深边框） ===== */
        .glass-card {
            background: rgba(0, 0, 0, 0.06) !important;
            backdrop-filter: none !important;
            -webkit-backdrop-filter: none !important;
            border: 2px solid rgba(255, 193, 7, 0.7) !important;
            border-radius: 14px !important;
            box-shadow: 
                0 6px 28px rgba(0,0,0,0.45),
                0 0 0 1px rgba(255,193,7,0.08),
                inset 0 1px 0 rgba(255,193,7,0.3),
                inset 0 -3px 0 rgba(0,0,0,0.4) !important;
            transition: all 0.35s ease;
        }
        .glass-card:hover {
            border-color: #ffc107 !important;
            box-shadow: 
                0 12px 40px rgba(0,0,0,0.5),
                0 0 0 1px rgba(255,193,7,0.15),
                0 0 24px rgba(255,193,7,0.15),
                inset 0 1px 0 rgba(255,193,7,0.35),
                inset 0 -3px 0 rgba(0,0,0,0.4) !important;
            transform: translateY(-3px);
        }

        .card-header {
            border-bottom: 2px solid rgba(255,193,7,0.25) !important;
            font-weight: 500;
            letter-spacing: 0.3px;
            background: transparent !important;
        }

        @keyframes borderPulse {
            0%   { border-color: #ffc107; box-shadow: 0 0 10px rgba(255,193,7,0.2); }
            50%  { border-color: #ffdd57; box-shadow: 0 0 25px rgba(255,193,7,0.4); }
            100% { border-color: #ffc107; box-shadow: 0 0 10px rgba(255,193,7,0.2); }
        }
        .card:hover {
            animation: borderPulse 1.5s ease-in-out infinite;
        }

        /* ===== 表格样式 ===== */
        .table { 
            color: rgba(255,255,255,0.9) !important; 
            margin-bottom: 0 !important; 
            border-color: rgba(255,255,255,0.15) !important;
        }
        .table th { 
            color: rgba(255,255,255,0.75) !important; 
            border-color: rgba(255,255,255,0.1) !important; 
            font-weight: 500; 
        }
        .table td { 
            border-color: rgba(255,255,255,0.08) !important; 
            vertical-align: middle !important;
            color: rgba(255,255,255,0.9) !important;
        }
        .table-hover tbody tr:hover {
            background-color: rgba(255,193,7,0.18) !important;
            color: #fff !important;
        }
        .table-hover tbody tr:hover td {
            color: #fff !important;
        }

        /* ===== 按钮 ===== */
        .btn { 
            transition: all 0.2s !important; 
        }
        .btn:hover { 
            transform: translateY(-1px) !important; 
        }
        .btn:active { 
            transform: translateY(0) !important; 
        }

        /* ===== 动画 ===== */
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(16px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .page-header, .glass-card {
            animation: fadeInUp 0.45s cubic-bezier(0.19, 1, 0.22, 1);
        }

        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: rgba(255,255,255,0.5);
        }
        .empty-state i {
            font-size: 48px;
            margin-bottom: 15px;
            opacity: 0.5;
        }

        .role-badge {
            padding: 6px 14px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: bold;
            color: #fff;
            display: inline-block;
        }
        .role-president {
            background: rgba(220, 53, 69, 0.9);
        }
        .role-member {
            background: rgba(108, 117, 125, 0.9);
        }

        /* ===== 统计小卡片 ===== */
        .stat-card {
            background: rgba(0, 0, 0, 0.06);
            border: 1px solid rgba(255,193,7,0.45);
            border-radius: 10px;
            padding: 16px 20px;
            text-align: center;
            transition: all 0.3s ease;
        }
        .stat-card:hover {
            border-color: #ffc107;
            box-shadow: 0 6px 20px rgba(0,0,0,0.35), 0 0 0 1px rgba(255,193,7,0.1);
            transform: translateY(-2px);
        }
        .stat-card .stat-number {
            font-size: 28px;
            font-weight: 700;
            color: #ffc107;
        }
        .stat-card .stat-label {
            font-size: 13px;
            color: rgba(255,255,255,0.6);
            margin-top: 4px;
        }
        .stat-card .stat-icon {
            font-size: 24px;
            margin-bottom: 6px;
        }

        /* ===== 成员弹窗（全透明 + 玻璃质感） ===== */
        .member-modal {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%) scale(0.9);
            width: 850px;
            max-width: 90%;
            max-height: 85vh;
            background: transparent !important;
            backdrop-filter: blur(30px) !important;
            -webkit-backdrop-filter: blur(30px);
            border: 2px solid rgba(255, 193, 7, 0.7) !important;
            border-radius: 14px !important;
            box-shadow: 0 15px 50px rgba(0,0,0,0.6), 0 0 0 1px rgba(255,193,7,0.1), 0 0 24px rgba(255,193,7,0.08), inset 0 1px 0 rgba(255,193,7,0.3) !important;
            z-index: 9999;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
        }
        .member-modal.open {
            opacity: 1;
            visibility: visible;
            transform: translate(-50%, -50%) scale(1);
        }
        .member-modal .modal-header {
            padding: 24px 30px;
            border-bottom: 2px solid rgba(255,193,7,0.3) !important;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .member-modal .modal-header h4 {
            margin: 0;
            color: #ffc107;
            font-size: 20px;
            font-weight: 600;
            text-shadow: 0 0 10px rgba(255,193,7,0.3);
        }
        .member-modal .modal-close {
            background: none;
            border: none;
            color: #ffc107;
            font-size: 28px;
            cursor: pointer;
            opacity: 0.8;
            transition: all 0.2s;
        }
        .member-modal .modal-close:hover {
            opacity: 1;
            transform: scale(1.1) rotate(90deg);
        }
        .member-modal .modal-body {
            flex: 1;
            padding: 30px;
            overflow-y: auto;
        }
        .member-modal .table {
            color: #fff !important;
        }
        .member-modal .table th {
            color: rgba(255,193,7,0.85) !important;
            border-color: rgba(255,193,7,0.15) !important;
        }
        .member-modal .table td {
            color: #fff !important;
            border-color: rgba(255,193,7,0.1) !important;
        }
        .member-modal .table-hover tbody tr:hover {
            background-color: rgba(255,193,7,0.22) !important;
            color: #fff !important;
        }
        .member-modal .table-hover tbody tr:hover td {
            color: #fff !important;
        }
        .member-modal .role-badge {
            font-size: 12px;
            padding: 4px 12px;
        }

        .overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100vh;
            background: rgba(0,0,0,0.6);
            z-index: 9998;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
        }
        .overlay.show {
            opacity: 1;
            visibility: visible;
        }

        /* Toast */
        .toast-notification {
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(32, 201, 151, 0.95);
            color: white;
            padding: 12px 24px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
            z-index: 99999;
            opacity: 0;
            transition: opacity 0.3s ease, top 0.3s ease;
        }
        .toast-notification.error {
            background: rgba(233, 69, 96, 0.95);
        }
        .toast-notification.show {
            opacity: 1;
            top: 30px;
        }

        .form-control {
            background: rgba(255,255,255,0.1) !important;
            border: 1px solid rgba(255,193,7,0.2) !important;
            color: #fff !important;
        }
        .form-control:focus {
            background: rgba(255,255,255,0.15) !important;
            border-color: rgba(255,193,7,0.5) !important;
            box-shadow: 0 0 0 0.2rem rgba(255,193,7,0.2) !important;
        }

        /* 加载动画 */
        .modal-loading {
            text-align: center;
            padding: 30px;
            color: rgba(255,193,7,0.6);
        }
        .modal-loading .spinner {
            width: 36px;
            height: 36px;
            border: 3px solid rgba(255,193,7,0.15);
            border-top-color: #ffc107;
            border-radius: 50%;
            animation: spin 0.8s linear infinite;
            display: inline-block;
            margin-bottom: 10px;
        }
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
    </style>

    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </asp:ScriptManager>

    <div class="container py-4">
        <!-- 标题区 -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold mb-0 page-header">
                <i class="bi bi-building me-2"></i>校级组织管理中心
            </h3>
            <span class="badge bg-warning text-dark fs-6 px-3 py-2 rounded-pill">
                <i class="bi bi-shield-fill-check me-1"></i>校级管理员
            </span>
        </div>

        <!-- Toast提示 -->
        <div id="toast" class="toast-notification"></div>

        <!-- ===== 统计概览卡片（新增） ===== -->
        <div class="row mb-4">
            <div class="col-md-3 col-6 mb-3">
                <div class="stat-card">
                    <div class="stat-icon"><i class="bi bi-hourglass-split text-warning"></i></div>
                    <div class="stat-number" id="statPending"><%= pendingCount %></div>
                    <div class="stat-label">待审核组织</div>
                </div>
            </div>
            <div class="col-md-3 col-6 mb-3">
                <div class="stat-card">
                    <div class="stat-icon"><i class="bi bi-archive text-danger"></i></div>
                    <div class="stat-number" id="statDisband"><%= disbandCount %></div>
                    <div class="stat-label">解散申请</div>
                </div>
            </div>
            <div class="col-md-3 col-6 mb-3">
                <div class="stat-card">
                    <div class="stat-icon"><i class="bi bi-building text-success"></i></div>
                    <div class="stat-number" id="statOrg"><%= orgCount %></div>
                    <div class="stat-label">已通过组织</div>
                </div>
            </div>
            <div class="col-md-3 col-6 mb-3">
                <div class="stat-card">
                    <div class="stat-icon"><i class="bi bi-people-fill text-info"></i></div>
                    <div class="stat-number" id="statMember"><%= totalMemberCount %></div>
                    <div class="stat-label">总成员数</div>
                </div>
            </div>
        </div>

        <!-- 双列卡片 -->
        <div class="row mb-4">
            <div class="col-md-6 mb-4 mb-md-0">
                <div class="card h-100 glass-card">
                    <div class="card-header d-flex justify-content-between align-items-center py-3">
                        <span><i class="bi bi-hourglass-split me-2"></i>待审核组织申请（全部）</span>
                        <span class="badge bg-warning text-dark rounded-pill"><%= pendingCount %></span>
                    </div>
                    <div class="card-body p-4">
                        <asp:GridView ID="gvPending" runat="server" 
                            AutoGenerateColumns="false"
                            CssClass="table table-hover table-bordered text-center align-middle"
                            DataKeyNames="OrgID"
                            EmptyDataText=" ">
                            <Columns>
                                <asp:BoundField DataField="OrgID" HeaderText="ID" />
                                <asp:BoundField DataField="OrgName" HeaderText="组织名称" />
                                <asp:BoundField DataField="CategoryName" HeaderText="类型" />
                                <asp:BoundField DataField="LeaderName" HeaderText="负责人" />
                                <asp:BoundField DataField="ContactInfo" HeaderText="联系方式" />
                                <asp:BoundField DataField="CreateTime" HeaderText="申请时间" DataFormatString="{0:yyyy-MM-dd}" />
                                <asp:TemplateField HeaderText="操作">
                                    <ItemTemplate>
                                        <button type="button" class="btn btn-sm btn-success" onclick="Approve(<%# Eval("OrgID") %>)">
                                            <i class="bi bi-check"></i> 通过
                                        </button>
                                        <button type="button" class="btn btn-sm btn-danger ms-1" onclick="Reject(<%# Eval("OrgID") %>)">
                                            <i class="bi bi-x"></i> 驳回
                                        </button>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        <asp:Panel ID="pnlPendingEmpty" runat="server" Visible="false" class="empty-state">
                            <i class="bi bi-inbox"></i>
                            <p class="mb-0">暂无待审核申请</p>
                        </asp:Panel>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="card h-100 glass-card">
                    <div class="card-header d-flex justify-content-between align-items-center py-3">
                        <span><i class="bi bi-trash3 me-2"></i>组织解散申请审核</span>
                        <span class="badge bg-danger text-white rounded-pill"><%= disbandCount %></span>
                    </div>
                    <div class="card-body p-4">
                        <asp:GridView ID="gvDisbandRequests" runat="server" 
                            AutoGenerateColumns="false"
                            CssClass="table table-hover table-bordered text-center align-middle"
                            DataKeyNames="RequestID"
                            EmptyDataText=" "
                            OnRowDataBound="gvDisbandRequests_RowDataBound">
                            <Columns>
                                <asp:BoundField DataField="RequestID" HeaderText="申请ID" />
                                <asp:BoundField DataField="OrgName" HeaderText="组织名称" />
                                <asp:BoundField DataField="LeaderName" HeaderText="申请人" />
                                <asp:BoundField DataField="Reason" HeaderText="解散原因" />
                                <asp:BoundField DataField="CreateTime" HeaderText="申请时间" DataFormatString="{0:yyyy-MM-dd}" />
                                <asp:TemplateField HeaderText="操作">
                                    <ItemTemplate>
                                        <button type="button" class="btn btn-sm btn-success" onclick="ApproveDisband(<%# Eval("RequestID") %>)">
                                            <i class="bi bi-check"></i> 同意
                                        </button>
                                        <button type="button" class="btn btn-sm btn-warning ms-1" onclick="RejectDisband(<%# Eval("RequestID") %>)">
                                            <i class="bi bi-x"></i> 拒绝
                                        </button>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        <asp:Panel ID="pnlDisbandEmpty" runat="server" Visible="false" class="empty-state">
                            <i class="bi bi-archive"></i>
                            <p class="mb-0">暂无解散申请</p>
                        </asp:Panel>
                    </div>
                </div>
            </div>
        </div>

        <!-- 组织列表 -->
        <div class="card glass-card">
            <div class="card-header d-flex justify-content-between align-items-center py-3">
                <span><i class="bi bi-list-check me-2"></i>校级组织 & 社团</span>
                <div>
                    <!-- 【新增】搜索框 + 刷新 -->
                    <input type="text" id="searchOrg" class="form-control form-control-sm d-inline-block" 
                           style="width:200px; display:inline-block !important;" 
                           placeholder="搜索组织名称..." onkeyup="filterOrgTable(event)" />
                    <button type="button" class="btn btn-sm btn-outline-warning ms-1" onclick="refreshAllData()">
                        <i class="bi bi-arrow-clockwise"></i> 刷新
                    </button>
                </div>
            </div>
            <div class="card-body p-4">
                <asp:GridView ID="gvOrgList" runat="server" 
                    AutoGenerateColumns="false"
                    CssClass="table table-hover table-bordered text-center align-middle"
                    DataKeyNames="OrgID">
                    <Columns>
                        <asp:BoundField DataField="OrgID" HeaderText="ID" />
                        <asp:BoundField DataField="OrgName" HeaderText="组织名称" />
                        <asp:BoundField DataField="CategoryName" HeaderText="类型" />
                        <asp:BoundField DataField="LeaderName" HeaderText="负责人" />
                        <asp:BoundField DataField="ContactInfo" HeaderText="联系方式" />
                        <asp:BoundField DataField="MemberCount" HeaderText="成员数" />
                        <asp:TemplateField HeaderText="成员">
                            <ItemTemplate>
                                <!-- AJAX异步加载成员，无整页刷新 -->
                                <button type="button" class="btn btn-sm btn-primary" 
                                        onclick="loadMembers(<%# Eval("OrgID") %>, '<%# Eval("OrgName") %>')">
                                    <i class="bi bi-people"></i> 查看
                                </button>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="操作">
                            <ItemTemplate>
                                <button type="button" class="btn btn-sm btn-danger" onclick="openDeleteModal(<%# Eval("OrgID") %>)">
                                    <i class="bi bi-trash"></i> 删除
                                </button>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

    <!-- 遮罩层 -->
    <div id="overlay" class="overlay" onclick="closeAllModals()"></div>

    <!-- 成员弹窗（全透明玻璃质感） -->
    <div class="member-modal" id="memberModal">
        <div class="modal-header">
            <h4><i class="bi bi-people-fill me-2"></i><span id="modalOrgTitle">组织成员列表</span></h4>
            <button class="modal-close" onclick="closeModal()">&times;</button>
        </div>
        <div class="modal-body">
            <!-- 加载动画 -->
            <div id="memberLoading" class="modal-loading">
                <div class="spinner"></div>
                <p>正在加载成员数据...</p>
            </div>
            <!-- 成员表格容器 -->
            <div id="memberTableContainer" style="display:none;">
                <div class="mb-3 text-end">
                    <span class="text-white-50 me-2">共 <strong id="memberTotalCount" class="text-warning">0</strong> 名成员</span>
                </div>
                <table class="table table-hover table-bordered text-center" id="memberTable">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>学号</th>
                            <th>姓名</th>
                            <th>学院</th>
                            <th>角色</th>
                            <th>加入日期</th>
                        </tr>
                    </thead>
                    <tbody id="memberTableBody">
                        <!-- 由JavaScript动态填充 -->
                    </tbody>
                </table>
            </div>
            <!-- 空状态 -->
            <div id="memberEmptyState" class="empty-state" style="display:none;">
                <i class="bi bi-people"></i>
                <p class="mb-0">该组织暂无成员</p>
            </div>
        </div>
    </div>

    <!-- 删除弹窗 -->
    <div class="member-modal" id="deleteModal" style="width:500px;">
        <div class="modal-header">
            <h4><i class="bi bi-exclamation-triangle me-2"></i>删除组织</h4>
            <button class="modal-close" onclick="closeDeleteModal()">&times;</button>
        </div>
        <div class="modal-body">
            <div class="mb-3">
                <label class="form-label text-white">删除原因 <span class="text-danger">*</span></label>
                <asp:TextBox ID="txtDeleteReason" runat="server" TextMode="MultiLine" 
                    CssClass="form-control" 
                    Rows="4" placeholder="请输入删除原因..."></asp:TextBox>
            </div>
            <div class="d-flex justify-content-end gap-2">
                <button type="button" class="btn btn-secondary" onclick="closeDeleteModal()">取消</button>
                <button type="button" class="btn btn-danger" onclick="confirmDelete()">确定删除</button>
            </div>
        </div>
    </div>

    <asp:HiddenField ID="hfOrgID" runat="server" />
    <asp:HiddenField ID="hfDeleteOrgID" runat="server" />
    <asp:HiddenField ID="hfAction" runat="server" />
    <asp:HiddenField ID="hfRequestID" runat="server" />

    <asp:Button ID="btnSubmit" runat="server" OnClick="DoAudit" style="display:none" />
    <asp:Button ID="btnSubmitDisband" runat="server" OnClick="DoDisbandAudit" style="display:none" />
    <asp:Button ID="btnDeleteOrg" runat="server" OnClick="DeleteOrg_Click" style="display:none" />

    <script type="text/javascript">
        // ===== Toast提示 =====
        function showToast(message, isSuccess) {
            const toast = document.getElementById('toast');
            toast.className = 'toast-notification ' + (isSuccess ? '' : 'error');
            toast.textContent = message;
            toast.classList.add('show');
            setTimeout(function () { toast.classList.remove('show'); }, 3000);
        }

        // ===== 弹窗控制 =====
        function closeAllModals() {
            document.getElementById('memberModal').classList.remove('open');
            document.getElementById('deleteModal').classList.remove('open');
            document.getElementById('overlay').classList.remove('show');
        }
        function closeModal() {
            document.getElementById('memberModal').classList.remove('open');
            document.getElementById('overlay').classList.remove('show');
        }
        function closeDeleteModal() {
            document.getElementById('deleteModal').classList.remove('open');
            document.getElementById('overlay').classList.remove('show');
        }

        // ===== AJAX异步加载成员数据（无整页刷新） =====
        function loadMembers(orgId, orgName) {
            document.getElementById('modalOrgTitle').textContent = orgName + ' - 成员列表';
            document.getElementById('memberLoading').style.display = 'block';
            document.getElementById('memberTableContainer').style.display = 'none';
            document.getElementById('memberEmptyState').style.display = 'none';
            document.getElementById('memberModal').classList.add('open');
            document.getElementById('overlay').classList.add('show');

            if (typeof PageMethods !== 'undefined' && PageMethods.GetOrgMembers) {
                PageMethods.GetOrgMembers(orgId, function (result) {
                    document.getElementById('memberLoading').style.display = 'none';
                    var data = JSON.parse(result);
                    if (data && data.length > 0) {
                        renderMemberTable(data);
                        document.getElementById('memberTableContainer').style.display = 'block';
                    } else {
                        document.getElementById('memberEmptyState').style.display = 'block';
                    }
                }, function (error) {
                    document.getElementById('memberLoading').style.display = 'none';
                    showToast('加载成员数据失败', false);
                    document.getElementById('memberEmptyState').style.display = 'block';
                    document.getElementById('memberEmptyState').querySelector('p').textContent = '加载失败，请重试';
                });
            } else {
                document.getElementById('memberLoading').style.display = 'none';
                showToast('AJAX组件不可用', false);
                __doPostBack('ShowMembers|' + orgId, '');
            }
        }

        function renderMemberTable(data) {
            var tbody = document.getElementById('memberTableBody');
            tbody.innerHTML = '';
            document.getElementById('memberTotalCount').textContent = data.length;
            for (var i = 0; i < data.length; i++) {
                var m = data[i];
                var roleClass = m.MemberRole == 3 ? 'role-president' : 'role-member';
                var roleText = m.MemberRole == 3 ? '社长/负责人' : '成员';
                tbody.innerHTML += '<tr>' +
                    '<td>' + (i + 1) + '</td>' +
                    '<td>' + htmlEncode(m.StudentNo) + '</td>' +
                    '<td>' + htmlEncode(m.UserName) + '</td>' +
                    '<td>' + htmlEncode(m.College) + '</td>' +
                    '<td><span class="role-badge ' + roleClass + '">' + roleText + '</span></td>' +
                    '<td>' + m.JoinDate + '</td>' +
                    '</tr>';
            }
        }

        function htmlEncode(str) {
            if (!str) return '-';
            return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
        }

        // ===== 审核操作 =====
        function Approve(id) {
            if (confirm("确定通过？")) {
                document.getElementById('<%=hfOrgID.ClientID%>').value = id;
                document.getElementById('<%=hfAction.ClientID%>').value = "approve";
                document.getElementById('<%=btnSubmit.ClientID%>').click();
            }
        }
        function Reject(id) {
            if (confirm("确定驳回？")) {
                document.getElementById('<%=hfOrgID.ClientID%>').value = id;
                document.getElementById('<%=hfAction.ClientID%>').value = "reject";
                document.getElementById('<%=btnSubmit.ClientID%>').click();
            }
        }

        // ===== 解散审核 =====
        function ApproveDisband(id) {
            if (confirm("确定同意该解散申请？此操作将删除组织数据，无法恢复。")) {
                document.getElementById('<%=hfRequestID.ClientID%>').value = id;
                document.getElementById('<%=hfAction.ClientID%>').value = "approveDisband";
                document.getElementById('<%=btnSubmitDisband.ClientID%>').click();
            }
        }
        function RejectDisband(id) {
            if (confirm("确定拒绝该解散申请？")) {
                document.getElementById('<%=hfRequestID.ClientID%>').value = id;
                document.getElementById('<%=hfAction.ClientID%>').value = "rejectDisband";
                document.getElementById('<%=btnSubmitDisband.ClientID%>').click();
            }
        }

        // ===== 删除组织 =====
        function openDeleteModal(orgId) {
            document.getElementById('<%=hfDeleteOrgID.ClientID%>').value = orgId;
            document.getElementById('<%=txtDeleteReason.ClientID%>').value = '';
            document.getElementById('deleteModal').classList.add('open');
            document.getElementById('overlay').classList.add('show');
        }
        function confirmDelete() {
            var reason = document.getElementById('<%=txtDeleteReason.ClientID%>').value.trim();
            if (!reason) {
                showToast('请输入删除原因！', false);
                return;
            }
            if (confirm("是否确定删除？一旦删除，无法恢复")) {
                closeDeleteModal();
                document.getElementById('<%=btnDeleteOrg.ClientID%>').click();
            }
        }

        // ===== 搜索筛选 =====
        function filterOrgTable(e) {
            var keyword = document.getElementById('searchOrg').value.trim().toLowerCase();
            var table = document.getElementById('<%=gvOrgList.ClientID%>');
            if (!table) return;
            var rows = table.getElementsByTagName('tr');
            for (var i = 1; i < rows.length; i++) {
                var cell = rows[i].getElementsByTagName('td')[1];
                if (cell) {
                    var text = cell.textContent || cell.innerText;
                    rows[i].style.display = (keyword === '' || text.toLowerCase().indexOf(keyword) > -1) ? '' : 'none';
                }
            }
        }

        // ===== 一键刷新 =====
        function refreshAllData() {
            showToast('正在刷新数据...', true);
            setTimeout(function () {
                __doPostBack('RefreshAll', '');
            }, 500);
        }
    </script>
</asp:Content>
