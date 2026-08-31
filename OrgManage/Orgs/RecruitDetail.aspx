<%@ Page Title="招新报名 - 高校组织综合线上管理平台" Language="C#" MasterPageFile="../Site.master"
         AutoEventWireup="true" CodeFile="RecruitDetail.aspx.cs" Inherits="OrgManage.Orgs_RecruitDetail" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

<style>
    /* 全局背景 + 渐变淡入 */
    body {
        background: url('<%= ResolveUrl("~/images/bg-night.jpg") %>') no-repeat center center fixed !important;
        background-size: cover !important;
        min-height: 100vh !important;
        color: #fff !important;
        animation: pageFade 1.1s ease forwards;
    }

    @keyframes pageFade {
        from { opacity: 0; transform: translateY(15px) scale(0.98); }
        to { opacity: 1; transform: translateY(0) scale(1); }
    }

    /* 毛玻璃卡片 - 弹性弹出动画 */
    .card {
        background: rgba(255, 255, 255, 0.08) !important;
        backdrop-filter: blur(14px) !important;
        border: 1px solid rgba(255, 255, 255, 0.15) !important;
        border-radius: 18px !important;
        box-shadow: 0 8px 32px rgba(0,0,0,0.2) !important;
        color: #fff !important;
        opacity: 0;
        animation: cardBounceUp 0.8s cubic-bezier(0.22, 1, 0.68, 1) forwards;
        overflow: hidden;
    }

    /* 两个卡片依次弹出 */
    .card:nth-child(1) { animation-delay: 0.2s; }
    .card:nth-child(2) { animation-delay: 0.4s; }

    @keyframes cardBounceUp {
        0% { opacity: 0; transform: translateY(40px) scale(0.9); }
        100% { opacity: 1; transform: translateY(0) scale(1); }
    }

    /* 卡片悬停微动效果 */
    .card:hover {
        transform: translateY(-4px);
        box-shadow: 0 12px 35px rgba(0,0,0,0.25) !important;
        border-color: rgba(255,193,7,0.25) !important;
    }

    /* 标题头部流光动画 */
    .card-header.bg-warning {
        background: linear-gradient(90deg, #ffc107, #ff8ba7, #ffc107) !important;
        background-size: 200% !important;
        animation: headerFlow 3s linear infinite !important;
        color: #000 !important;
        font-weight: bold !important;
        border: none !important;
    }

    @keyframes headerFlow {
        0% { background-position: 0% 50%; }
        50% { background-position: 100% 50%; }
        100% { background-position: 0% 50%; }
    }

    /* 文字清晰度 */
    .text-muted, small {
        color: rgba(255,255,255,0.75) !important;
    }

    .form-label {
        color: rgba(255,255,255,0.95) !important;
        margin-bottom: 8px !important;
    }

    /* 输入框高级样式 */
    .form-control {
        background: rgba(255,255,255,0.12) !important;
        border: 1px solid rgba(255,255,255,0.2) !important;
        color: #fff !important;
        border-radius: 12px !important;
        transition: all 0.3s ease;
    }

    .form-control:focus {
        background: rgba(255,255,255,0.18) !important;
        border-color: #ffc107 !important;
        box-shadow: 0 0 12px rgba(255,193,7,0.3) !important;
        transform: translateY(-2px);
        outline: none;
    }

    /* 占位符高亮 */
    ::placeholder {
        color: rgba(255,255,255,0.7) !important;
        opacity: 1 !important;
    }

    /* 分割线 */
    hr {
        border-color: rgba(255,255,255,0.1) !important;
        margin: 16px 0;
    }

    /* 按钮高级动效 */
    .btn-warning {
        background: #ffc107 !important;
        border: none !important;
        color: #000 !important;
        font-weight: bold !important;
        border-radius: 12px !important;
        padding: 12px !important;
        transition: all 0.3s ease;
    }

    .btn-warning:hover {
        transform: translateY(-2px) scale(1.02);
        box-shadow: 0 6px 15px rgba(255,193,7,0.25);
    }

    .btn-primary {
        background: #ff8ba7 !important;
        border: none !important;
        border-radius: 12px !important;
        padding: 12px !important;
        transition: all 0.3s ease;
    }

    .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 15px rgba(255,139,167,0.3);
    }

    /* 提示框动画 */
    .alert {
        border-radius: 12px !important;
        animation: alertPop 0.6s ease forwards;
    }

    .alert-danger {
        background: rgba(220,53,69,0.15) !important;
        border-color: rgba(220,53,69,0.3) !important;
        color: #fff !important;
    }

    .alert-info {
        background: rgba(13,202,240,0.15) !important;
        border-color: rgba(13,202,240,0.3) !important;
        color: #fff !important;
    }

    @keyframes alertPop {
        from { opacity: 0; transform: scale(0.9); }
        to { opacity: 1; transform: scale(1); }
    }

    /* 表单项依次出现 */
    .mb-3 {
        opacity: 0;
        animation: formItemFade 0.6s ease forwards;
    }

    .mb-3:nth-child(1) { animation-delay: 0.5s; }
    .mb-3:nth-child(2) { animation-delay: 0.6s; }

    @keyframes formItemFade {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }

    /* 错误提示抖动 */
    .text-danger {
        animation: errorShake 0.4s ease;
    }

    @keyframes errorShake {
        0%,100% { transform: translateX(0); }
        25% { transform: translateX(-3px); }
        75% { transform: translateX(3px); }
    }

    /* 标签 */
    .badge.bg-warning {
        background: #ffc107 !important;
        color: #000 !important;
        font-weight: 600;
        border-radius: 6px;
    }
</style>

<div class="container my-4">
    <div class="row justify-content-center">
        <div class="col-lg-7">
            <asp:Panel ID="panelNotFound" runat="server" Visible="false">
                <div class="alert alert-danger">招新信息不存在或已结束。</div>
            </asp:Panel>

            <asp:Panel ID="panelMain" runat="server">
                <!-- 招新信息 -->
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-body p-4">
                        <span class="badge bg-warning text-dark mb-2"><asp:Literal ID="litCategory" runat="server" /></span>
                        <h4 class="fw-bold"><asp:Literal ID="litTitle" runat="server" /></h4>
                        <h6 class="text-primary mb-3"><asp:Literal ID="litOrgName" runat="server" /></h6>

                        <div class="row g-2 mb-3">
                            <div class="col-6">
                                <small class="text-muted"><i class="bi bi-calendar me-1"></i>截止：<asp:Literal ID="litEndDate" runat="server" /></small>
                            </div>
                            <div class="col-6">
                                <small class="text-muted"><i class="bi bi-people me-1"></i>名额：<asp:Literal ID="litQuota" runat="server" /></small>
                            </div>
                        </div>

                        <hr />

                        <h6 class="fw-bold">招新介绍</h6>
                        <p><asp:Literal ID="litContent" runat="server" /></p>

                        <h6 class="fw-bold">报名要求</h6>
                        <p class="mb-0"><asp:Literal ID="litRequirements" runat="server" /></p>
                    </div>
                </div>

                <!-- 报名表单 -->
                <asp:Panel ID="panelApplyForm" runat="server" CssClass="card border-0 shadow-sm">
                    <div class="card-header bg-warning text-dark fw-bold pt-3 pb-3">
                        <i class="bi bi-person-plus me-2"></i>填写报名信息
                    </div>
                    <div class="card-body p-4">
                        <asp:Panel ID="panelMsg" runat="server" Visible="false" />
                        
                       <asp:Panel ID="panelApplied" runat="server" Visible="false" CssClass="alert alert-info">
                           <i class="bi bi-check-circle me-2"></i>您已经报名，请耐心等待审核，审核通过自动加入该组织。
                        </asp:Panel>
                        
                        <asp:Panel ID="panelForm" runat="server">
                            <div class="mb-3">
                                <label class="form-label fw-bold">自我介绍 <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtSelfIntro" runat="server" CssClass="form-control" TextMode="MultiLine"
                                             Rows="4" placeholder="简单介绍自己，如专业、特长、性格等" MaxLength="1000" />
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtSelfIntro"
                                    ErrorMessage="请填写自我介绍" CssClass="text-danger small" Display="Dynamic" />
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-bold">申请理由 <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtReason" runat="server" CssClass="form-control" TextMode="MultiLine"
                                             Rows="3" placeholder="为什么想加入这个组织？" MaxLength="500" />
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtReason"
                                    ErrorMessage="请填写申请理由" CssClass="text-danger small" Display="Dynamic" />
                            </div>

                            <asp:Button ID="btnApply" runat="server" Text="提交报名" CssClass="btn btn-warning fw-bold w-100 py-3"
                                        OnClick="BtnApply_Click" />
                        </asp:Panel>

                        <asp:HyperLink ID="hlLogin" runat="server" NavigateUrl="~/Account/Login.aspx"
                                       CssClass="btn btn-primary w-100 py-3" Visible="false">
                            登录后报名
                        </asp:HyperLink>
                    </div>
                </asp:Panel>
            </asp:Panel>
        </div>
    </div>
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