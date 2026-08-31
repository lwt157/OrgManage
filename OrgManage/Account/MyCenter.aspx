<%@ Page Title="个人中心 - 高校组织综合线上管理平台" Language="C#" MasterPageFile="../Site.master"
         AutoEventWireup="true" CodeFile="MyCenter.aspx.cs" Inherits="OrgManage.Account_MyCenter" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" EnablePartialRendering="true"></asp:ScriptManager>
    <script src="<%= ResolveUrl("~/Scripts/jquery-3.7.1.min.js") %>"></script>
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

        .glass-card {
            background: rgba(255, 255, 255, 0.08) !important;
            backdrop-filter: blur(12px) !important;
            border: 1px solid rgba(255, 255, 255, 0.15) !important;
            border-radius: 18px !important;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3) !important;
            color: #fff !important;
            animation: cardUp 0.8s ease forwards;
            transform: translateY(20px);
            opacity: 0;
        }

        @keyframes cardUp {
            to { transform: translateY(0); opacity: 1; }
        }

        .list-group {
            background: transparent !important;
        }

        .list-group-item {
            background: rgba(255, 255, 255, 0.08) !important;
            border: 1px solid rgba(255, 255, 255, 0.12) !important;
            color: rgba(255,255,255,0.9) !important;
            transition: all 0.3s;
            border-radius: 10px !important;
            margin-bottom: 6px;
            text-align: left;
        }

        .list-group-item.active {
            background: rgba(255, 139, 167, 0.2) !important;
            border-color: #ff8ba7 !important;
            color: #ff8ba7 !important;
            font-weight: bold;
        }

        .list-group-item:hover:not(.active) {
            background: rgba(255, 255, 255, 0.15) !important;
            transform: translateX(4px);
        }

        .form-control {
            background: rgba(255, 255, 255, 0.1) !important;
            border: 1px solid rgba(255, 255, 255, 0.2) !important;
            color: #fff !important;
            border-radius: 8px !important;
            transition: all 0.3s;
        }

        .form-control:focus {
            background: rgba(255, 255, 255, 0.15) !important;
            border-color: #ff8ba7 !important;
            box-shadow: 0 0 10px rgba(255,139,167,0.3) !important;
            outline: none;
        }

        .text-muted {
            color: rgba(255,255,255,0.65) !important;
        }

        .form-label {
            color: rgba(255,255,255,0.9) !important;
        }

        .btn-primary {
            background: linear-gradient(90deg, #e94560, #ff8ba7) !important;
            border: none !important;
            color: #fff !important;
            transition: all 0.3s;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(233,69,96,0.3);
        }

        .btn-danger {
            background: #e94560 !important;
            border: none !important;
        }

        .avatar-container {
            position: relative;
            width: 80px;
            height: 80px;
            margin: 0 auto;
        }
        .avatar-circle {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: rgba(255,139,167,0.2) !important;
            color: #ff8ba7 !important;
            border: 2px solid #ff8ba7;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            overflow: hidden;
            transition: all 0.3s ease;
        }
        .avatar-circle:hover {
            transform: scale(1.05);
            box-shadow: 0 0 15px rgba(255,139,167,0.4);
        }
        .avatar-circle img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .avatar-upload-btn {
            position: absolute;
            bottom: 0;
            right: 0;
            background: #ff8ba7;
            border-radius: 50%;
            width: 26px;
            height: 26px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 0.8rem;
            color: #fff;
            transition: all 0.3s ease;
        }
        .avatar-upload-btn:hover {
            transform: scale(1.1);
        }

        .bg-primary {
            background: #ff8ba7 !important;
        }

        .card-header {
            background: transparent !important;
            border-bottom: 1px solid rgba(255,255,255,0.1) !important;
            color: #fff !important;
        }

        .border-bottom {
            border-color: rgba(255,255,255,0.1) !important;
        }

        .alert-success {
            background: rgba(25,135,84,0.2) !important;
            border-color: rgba(25,135,84,0.3) !important;
            color: #fff !important;
        }

        .message-badge {
            position: absolute;
            top: -5px;
            right: -5px;
            background: #e94560;
            color: white;
            border-radius: 50%;
            width: 18px;
            height: 18px;
            font-size: 0.7rem;
            display: flex;
            align-items: center;
            justify-content: center;
            animation: pulse 1.5s infinite;
        }
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.1); }
        }
        .message-dropdown {
            position: absolute;
            top: 100%;
            right: 0;
            width: 320px;
            max-height: 420px;
            background: rgba(30, 30, 50, 0.98);
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            display: none;
            z-index: 9999;
            overflow: hidden;
            flex-direction: column;
        }
        .message-dropdown.show {
            display: flex;
        }
        #messageList {
            max-height: 360px;
            overflow-y: auto;
            flex: 1;
        }
        #messageList::-webkit-scrollbar {
            width: 6px;
        }
        #messageList::-webkit-scrollbar-track {
            background: transparent;
        }
        #messageList::-webkit-scrollbar-thumb {
            background: rgba(255, 255, 255, 0.15);
            border-radius: 3px;
        }
        #messageList::-webkit-scrollbar-thumb:hover {
            background: rgba(255, 255, 255, 0.3);
        }
        #messageList .empty-state {
            text-align: center;
            padding: 40px 15px;
            color: rgba(255, 255, 255, 0.4);
        }
        #messageList .empty-state i {
            font-size: 2rem;
            display: block;
            margin-bottom: 8px;
        }
        .message-item {
            padding: 12px 15px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            transition: background 0.2s ease;
        }
        .message-item:hover {
            background: rgba(255, 255, 255, 0.05);
        }
        .message-item.unread {
            background: rgba(255, 139, 167, 0.1);
            border-left: 3px solid #ff8ba7;
        }
        .message-time {
            font-size: 0.75rem;
            color: rgba(255,255,255,0.6);
        }
    </style>

    <div class="container my-4">
        <div class="row g-4">
            <div class="col-lg-3">
                <div class="card border-0 shadow-sm rounded-4 mb-3 glass-card">
                    <div class="card-body text-center py-4">
                        <div class="avatar-container mb-3">
                            <div class="avatar-circle">
                                <asp:Image ID="imgAvatar" runat="server" />
                                <asp:Literal ID="litAvatarText" runat="server" />
                            </div>
                            <div class="avatar-upload-btn" onclick="document.getElementById('<%= fuAvatar.ClientID %>').click()">
                                <i class="bi bi-camera"></i>
                            </div>
                            <asp:FileUpload ID="fuAvatar" runat="server" CssClass="d-none" />
                        </div>
                        <asp:Button ID="btnSaveAvatar" runat="server" Text="保存头像" CssClass="btn btn-sm btn-primary mt-2 w-100" OnClick="btnSaveAvatar_Click" />

                        <h5 class="fw-bold mb-1 mt-3"><asp:Literal ID="litUserName" runat="server" /></h5>
                        <p class="text-muted small mb-2"><asp:Literal ID="litStudentNo" runat="server" /></p>
                        <span class="badge bg-primary"><asp:Literal ID="litRole" runat="server" /></span>
                    </div>
                </div>

                <div class="list-group border-0 shadow-sm rounded-4">
                    <a href="#tab-profile" data-bs-toggle="tab" class="list-group-item list-group-item-action active">
                        <i class="bi bi-person me-2"></i>基本资料
                    </a>
                    <a href="#tab-orgs" data-bs-toggle="tab" class="list-group-item list-group-item-action">
                        <i class="bi bi-building me-2"></i>我的组织
                    </a>
                    <a href="#tab-activities" data-bs-toggle="tab" class="list-group-item list-group-item-action">
                        <i class="bi bi-calendar-check me-2"></i>我的活动
                    </a>
                    <a href="#tab-applies" data-bs-toggle="tab" class="list-group-item list-group-item-action">
                        <i class="bi bi-file-text me-2"></i>招新记录
                    </a>
                    <a href="#tab-favorites" data-bs-toggle="tab" class="list-group-item list-group-item-action">
                        <i class="bi bi-star me-2"></i>我的收藏
                    </a>
                    <a href="#tab-password" data-bs-toggle="tab" class="list-group-item list-group-item-action">
                        <i class="bi bi-shield-lock me-2"></i>修改密码
                    </a>
                </div>
            </div>

            <div class="col-lg-9">
                <div class="d-flex justify-content-end mb-3 position-relative" style="z-index:999;">
                    <div class="position-relative">
                      <button class="btn btn-outline-light rounded-circle p-2" onclick="toggleMessages(event)">
                    <i class="bi bi-bell"></i>
                     </button>
                        <span class="message-badge" id="msgBadge">0</span>
                        <div class="message-dropdown" id="messageDropdown">
                            <div class="p-3 border-bottom d-flex justify-content-between align-items-center">
                                <h6 class="mb-0">消息通知</h6>
                                <div class="d-flex gap-2">
                                    <button type="button" class="btn btn-sm btn-outline-light" onclick="markAllRead(event)">全部已读</button>
                                    <button type="button" class="btn btn-sm btn-outline-danger" onclick="clearAllMessages(event)">清空</button>
                                </div>
                            </div>
                            <div id="messageList">
                                <asp:Repeater ID="rptMessages" runat="server">
                                    <ItemTemplate>
                                        <div class="message-item <%# Convert.ToBoolean(Eval("IsRead")) ? "" : "unread" %>" data-id="<%# Eval("MsgID") %>">
                                            <div class="d-flex justify-content-between align-items-start">
                                                <div class="flex-grow-1 me-2">
                                                    <p class="mb-1"><%# System.Web.HttpUtility.HtmlEncode(Eval("Title").ToString()) %></p>
                                                    <p class="text-muted small mb-1"><%# System.Web.HttpUtility.HtmlEncode(Eval("Content").ToString()) %></p>
                                                    <span class="message-time"><%# Convert.ToDateTime(Eval("CreateTime")).ToString("yyyy-MM-dd HH:mm") %></span>
                                                </div>
                                                <div class="d-flex gap-1">
                                                  <!-- 对勾按钮 -->
                                                <button type="button" class="btn btn-sm btn-outline-light mark-read" runat="server" Visible='<%# !Convert.ToBoolean(Eval("IsRead")) %>'>
                                                 <i class="bi bi-check"></i>
                                                   </button>
                                                   <!-- 删除按钮 -->
                                                 <button type="button" class="btn btn-sm btn-outline-danger delete-msg">
                                             <i class="bi bi-trash"></i>
                                                   </button>
                                                </div>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="tab-content">
                    <div class="tab-pane fade show active" id="tab-profile">
                        <div class="card border-0 shadow-sm rounded-4 glass-card">
                            <div class="card-header fw-bold">
                                <i class="bi bi-person-lines-fill me-2"></i>基本资料
                            </div>
                            <div class="card-body p-4">
                                <asp:Panel ID="panelProfileMsg" runat="server" Visible="false" CssClass="alert alert-success small mb-3">
                                    资料已更新成功！
                                </asp:Panel>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">学号</label>
                                        <asp:TextBox ID="txtStudentNo" runat="server" CssClass="form-control" ReadOnly="true" />
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">姓名</label>
                                        <asp:TextBox ID="txtRealName" runat="server" CssClass="form-control" ReadOnly="true" />
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">邮箱</label>
                                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" />
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">手机号</label>
                                        <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" />
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label fw-bold">所在学院</label>
                                        <asp:TextBox ID="txtCollege" runat="server" CssClass="form-control" />
                                    </div>
                                </div>
                                <asp:Button ID="btnSaveProfile" runat="server" Text="保存修改" CssClass="btn btn-primary mt-3" OnClick="BtnSaveProfile_Click" />
                            </div>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="tab-orgs">
                        <div class="card border-0 shadow-sm rounded-4 glass-card">
                            <div class="card-header fw-bold">
                                <i class="bi bi-building me-2"></i>我加入的组织
                            </div>
                            <div class="card-body p-0">
                                <asp:Repeater ID="rptMyOrgs" runat="server">
                                    <ItemTemplate>
                                        <div class="d-flex align-items-center px-4 py-3 border-bottom">
                                            <div class="flex-grow-1">
                                                <h6 class="fw-bold mb-0"><%# Eval("OrgName") %></h6>
                                                <small class="text-muted">
                                                    <%# Eval("CategoryName") %> |
                                                    <%# (Convert.ToInt32(Eval("MemberRole")) == 3) ? "负责人" : ((Convert.ToInt32(Eval("MemberRole")) == 2) ? "干部" : "成员") %> |
                                                    加入于 <%# Convert.ToDateTime(Eval("JoinDate")).ToString("yyyy-MM-dd") %>
                                                </small>
                                            </div>
                                            <a href='<%# ResolveUrl("~/Orgs/Detail.aspx?id=" + Eval("OrgID")) %>' class="btn btn-outline-primary btn-sm">查看</a>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                                <asp:Panel ID="panelNoOrg" runat="server" CssClass="text-center text-muted py-4">
                                    <i class="bi bi-building" style="font-size:2rem;"></i>
                                    <p class="mt-2 small">暂未加入任何组织</p>
                                </asp:Panel>
                            </div>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="tab-activities">
                        <div class="card border-0 shadow-sm rounded-4 glass-card">
                            <div class="card-header fw-bold">
                                <i class="bi bi-calendar-check me-2"></i>我报名的活动
                            </div>
                            <div class="card-body p-0">
                                <asp:Repeater ID="rptMyActivities" runat="server">
                                    <ItemTemplate>
                                        <div class="d-flex align-items-center px-4 py-3 border-bottom">
                                            <div class="flex-grow-1">
                                                <h6 class="fw-bold mb-0"><%# Eval("Title") %></h6>
                                                <small class="text-muted">
                                                    <%# Eval("OrgName") %> |
                                                    <%# Convert.ToDateTime(Eval("StartTime")).ToString("yyyy-MM-dd HH:mm") %> |
                                                    <%# Eval("Location") %>
                                                </small>
                                            </div>
                                            <span class='badge'><%# GetActivityStatus(Convert.ToInt32(Eval("Status"))) %></span>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                                <asp:Panel ID="panelNoAct" runat="server" CssClass="text-center text-muted py-4">
                                    <i class="bi bi-calendar" style="font-size:2rem;"></i>
                                    <p class="mt-2 small">暂未报名任何活动</p>
                                </asp:Panel>
                            </div>
                        </div>
                    </div>

             <div class="tab-pane fade" id="tab-applies">
    <div class="card border-0 shadow-sm rounded-4 glass-card">
        <div class="card-header fw-bold">
            <i class="bi bi-file-text me-2"></i>我的招新报名记录
        </div>
        <div class="card-body p-0">
            <asp:Repeater ID="rptMyApplies" runat="server">
                <ItemTemplate>
                    <div class="d-flex align-items-center px-4 py-3 border-bottom">
                        <div class="flex-grow-1">
                            <h6 class="fw-bold mb-0"><%# Eval("Title") %></h6>
                            <small class="text-muted">
                                <%# Eval("OrgName") %> |
                                <%# Convert.ToDateTime(Eval("ApplyTime")).ToString("yyyy-MM-dd") %>
                            </small>
                        </div>
                        <span class='badge <%# (Convert.ToInt32(Eval("Status")) == 0) ? "bg-warning" : (Convert.ToInt32(Eval("Status")) == 1 ? "bg-success" : "bg-danger") %>'>
                            <%# (Convert.ToInt32(Eval("Status")) == 0) ? "待审核" : (Convert.ToInt32(Eval("Status")) == 1 ? "已录用" : "已拒绝") %>
                        </span>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <asp:Panel ID="panelNoApply" runat="server" CssClass="text-center text-muted py-4">
                <p class="small">暂无报名记录</p>
            </asp:Panel>
        </div>
    </div>
</div>

                    <div class="tab-pane fade" id="tab-favorites">
                        <div class="card border-0 shadow-sm rounded-4 glass-card">
                            <div class="card-header fw-bold">
                                <i class="bi bi-star me-2"></i>我收藏的组织
                            </div>
                            <div class="card-body p-0">
                                <asp:Repeater ID="rptFavorites" runat="server">
                                    <ItemTemplate>
                                        <div class="d-flex align-items-center px-4 py-3 border-bottom">
                                            <div class="flex-grow-1">
                                                <h6 class="fw-bold mb-0"><%# Eval("OrgName") %></h6>
                                                <small class="text-muted"><%# Eval("CategoryName") %></small>
                                            </div>
                                            <a href='<%# ResolveUrl("~/Orgs/Detail.aspx?id=" + Eval("OrgID")) %>' class="btn btn-outline-primary btn-sm">查看</a>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                                <asp:Panel ID="panelNoFav" runat="server" CssClass="text-center text-muted py-4">
                                    <p class="small">暂无收藏</p>
                                </asp:Panel>
                            </div>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="tab-password">
                        <div class="card border-0 shadow-sm rounded-4 glass-card">
                            <div class="card-header fw-bold">
                                <i class="bi bi-shield-lock me-2"></i>修改密码
                            </div>
                            <div class="card-body p-4">
                                <asp:Panel ID="panelPwdMsg" runat="server" Visible="false" />
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">当前密码</label>
                                        <asp:TextBox ID="txtOldPwd" runat="server" CssClass="form-control" TextMode="Password" />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">新密码</label>
                                        <asp:TextBox ID="txtNewPwd" runat="server" CssClass="form-control" TextMode="Password" />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">确认新密码</label>
                                        <asp:TextBox ID="txtConfirmPwd" runat="server" CssClass="form-control" TextMode="Password" />
                                    </div>
                                    <asp:Button ID="btnChangePwd" runat="server" Text="确认修改" CssClass="btn btn-danger" OnClick="BtnChangePwd_Click" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
<script type="text/javascript">
    // 头像预览
    function PreviewAvatar(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function (e) {
                document.querySelector('.avatar-circle img').src = e.target.result;
            };
            reader.readAsDataURL(input.files[0]);
        }
    }

    // 铃铛打开消息框
    function toggleMessages(e) {
        e.preventDefault();
        var box = document.getElementById('messageDropdown');
        if (box.classList.contains('show')) {
            box.classList.remove('show');
        } else {
            box.classList.add('show');
        }
    }

    // ==========================================
    // 【标记单条已读】
    // ==========================================
    $(document).on('click', '.mark-read', function (e) {
        e.preventDefault();
        var msgId = $(this).closest('.message-item').data('id');
        var btn = $(this);

        $.ajax({
            type: "POST",
            url: "MyCenter.aspx/MarkAsRead",
            data: JSON.stringify({ msgId: msgId }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function () {
                btn.closest('.message-item').removeClass('unread');
                btn.remove();
                updateBadge();
            },
            error: function (xhr) {
                console.log(xhr.responseText);
            }
        });
    });

    // ==========================================
    // 【删除消息】
    // ==========================================
    $(document).on('click', '.delete-msg', function (e) {
        e.preventDefault();
        if (!confirm("确定删除这条消息吗？")) return;

        var msgId = $(this).closest('.message-item').data('id');
        var item = $(this).closest('.message-item');

        $.ajax({
            type: "POST",
            url: "MyCenter.aspx/DeleteMessage",
            data: JSON.stringify({ msgId: msgId }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function () {
                item.fadeOut(300, function () {
                    $(this).remove();
                    updateBadge();
                });
            }
        });
    });

    // ==========================================
    // 【全部已读】
    // ==========================================
    function markAllRead(e) {
        e.preventDefault();
        $.ajax({
            type: "POST",
            url: "MyCenter.aspx/MarkAllAsRead",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function () {
                $('.message-item').removeClass('unread');
                $('.mark-read').remove();
                updateBadge();
            }
        });
    }

    // 更新未读角标
    function updateBadge() {
        var count = $('.message-item.unread').length;
        $('#msgBadge').text(count);
        if (count === 0) $('#msgBadge').hide();
        else $('#msgBadge').show();
    }

    // ==========================================
    // 【清空所有消息】
    // ==========================================
    function clearAllMessages(e) {
        e.preventDefault();
        e.stopPropagation();
        if (!confirm("确定清空所有消息吗？此操作不可恢复！")) return;

        $.ajax({
            type: "POST",
            url: "MyCenter.aspx/ClearAllMessages",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function () {
                $('#messageList').fadeOut(300, function () {
                    $(this).html('<div class="empty-state"><i class="bi bi-inbox"></i><small>暂无消息</small></div>').fadeIn();
                });
                $('#msgBadge').hide();
            },
            error: function (xhr) {
                console.log(xhr.responseText);
            }
        });
    }

    // 点击外部关闭
    $(document).click(function (e) {
        if (!$(e.target).closest('.btn-outline-light, .message-dropdown').length) {
            $('.message-dropdown').removeClass('show');
        }
    });
</script>
</asp:Content>