<%@ Page Title="申请创建组织" Language="C#" MasterPageFile="../Site.master"
         AutoEventWireup="true" CodeFile="Apply.aspx.cs" Inherits="OrgManage.Orgs_Apply" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

<style>
    /* 全局背景 + 渐变淡入动画 */
    body {
        background: url('<%= ResolveUrl("~/images/bg-night.jpg") %>') no-repeat center center fixed !important;
        background-size: cover !important;
        min-height: 100vh !important;
        color: #fff !important;
        animation: pageFadeGradient 1.2s ease forwards !important;
    }

    /* 渐变扩散入场（独家效果） */
    @keyframes pageFadeGradient {
        0% { opacity: 0; transform: scale(0.96); filter: brightness(0.8); }
        100% { opacity: 1; transform: scale(1); filter: brightness(1); }
    }

    /* 卡片：从中心旋转弹出（独家！） */
    .form-card {
        background: rgba(255, 255, 255, 0.08) !important;
        backdrop-filter: blur(14px) !important;
        border: 1px solid rgba(255, 255, 255, 0.2) !important;
        border-radius: 20px !important;
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.25) !important;
        opacity: 0;
        animation: cardRotatePop 1s ease-out forwards !important;
        animation-delay: 0.3s;
        overflow: hidden;
    }

    /* 旋转弹出动画 */
    @keyframes cardRotatePop {
        0% { opacity: 0; transform: translateY(40px) rotate(-2deg) scale(0.92); }
        100% { opacity: 1; transform: translateY(0) rotate(0) scale(1); }
    }

    /* 头部流光动画（独家！） */
    .card-header {
        background: linear-gradient(90deg, #ff6b9d, #c44569, #f8b500) !important;
        background-size: 200% !important;
        animation: headerFlow 3.5s linear infinite !important;
        color: #fff !important;
        font-weight: 600;
        border: none !important;
        position: relative;
    }

    /* 渐变流光 */
    @keyframes headerFlow {
        0% { background-position: 0% 50%; }
        50% { background-position: 100% 50%; }
        100% { background-position: 0% 50%; }
    }

    /* 表单项：依次上浮动画 */
    .form-item {
        opacity: 0;
        animation: formItemUp 0.6s ease forwards;
    }

    .form-item:nth-child(1) { animation-delay: 0.5s; }
    .form-item:nth-child(2) { animation-delay: 0.6s; }
    .form-item:nth-child(3) { animation-delay: 0.7s; }
    .form-item:nth-child(4) { animation-delay: 0.8s; }
    .form-item:nth-child(5) { animation-delay: 0.9s; }
    .form-item:nth-child(6) { animation-delay: 1.0s; }
    .form-item:nth-child(7) { animation-delay: 1.1s; } /* 新增Logo项动画 */

    @keyframes formItemUp {
        from { opacity: 0; transform: translateY(15px); }
        to { opacity: 1; transform: translateY(0); }
    }

    /* ========== 核心修复：输入框/下拉框 ========== */
    .form-control, .form-select {
        background: rgba(255,255,255,0.15) !important;
        border: 1px solid rgba(255,255,255,0.3) !important;
        color: #ffffff !important;
        border-radius: 10px !important;
        transition: all 0.3s ease !important;
    }

    /* 下拉框展开选项样式 */
    .form-select option {
        background-color: #222 !important;
        color: #ffffff !important;
    }

    .form-control:focus, .form-select:focus {
        background: rgba(255,255,255,0.2) !important;
        border-color: #ff8ba7 !important;
        box-shadow: 0 0 12px rgba(255,139,167,0.4) !important;
        transform: translateY(-2px);
        outline: none;
    }

    /* 修复：占位符（提示词）亮度 */
    ::placeholder {
        color: rgba(255, 255, 255, 0.75) !important;
        opacity: 1;
    }
    ::-webkit-input-placeholder { color: rgba(255, 255, 255, 0.75) !important; }
    ::-moz-placeholder { color: rgba(255, 255, 255, 0.75) !important; }
    :-ms-input-placeholder { color: rgba(255, 255, 255, 0.75) !important; }

    /* 按钮：脉冲放大 + 悬停上浮 */
    .btn-primary {
        background: linear-gradient(90deg, #ff6b9d, #c44569) !important;
        border: none !important;
        border-radius: 10px !important;
        transition: all 0.3s ease !important;
        position: relative;
        overflow: hidden;
    }

    .btn-primary:hover {
        transform: translateY(-3px) scale(1.05);
        box-shadow: 0 6px 15px rgba(255,107,157,0.3);
    }

    /* 提示框动态 */
    .alert-info {
        background: rgba(100, 181, 246, 0.15) !important;
        border-color: rgba(100, 181, 246, 0.3) !important;
        color: #fff !important;
        border-radius: 12px !important;
        animation: alertBounce 1s ease;
        animation-delay: 1.1s;
        opacity: 0;
        animation-fill-mode: forwards;
    }

    @keyframes alertBounce {
        0% { opacity: 0; transform: translateY(10px) scale(0.95); }
        100% { opacity: 1; transform: translateY(0) scale(1); }
    }

    /* 标签文字 */
    .form-label {
        color: rgba(255,255,255,0.9) !important;
        margin-bottom: 6px !important;
    }

    /* 错误提示 */
    .text-danger {
        animation: errorShake 0.4s ease;
    }

    @keyframes errorShake {
        0%,100% { transform: translateX(0); }
        25% { transform: translateX(-3px); }
        75% { transform: translateX(3px); }
    }

    /* Logo预览样式 */
    #imgLogoPreview {
        max-width: 100px;
        max-height: 100px;
        border-radius: 8px;
        object-fit: cover;
        margin-top: 10px;
        display: none;
    }
</style>

<div class="container my-4">
    <div class="row justify-content-center">
        <div class="col-lg-7">
            <div class="card border-0 shadow-sm form-card">
                <div class="card-header pt-3 pb-3">
                    <i class="bi bi-plus-circle me-2"></i>申请创建新组织
                </div>
                <div class="card-body p-4">
                    <asp:Panel ID="panelMsg" runat="server" Visible="false" />

                    <div class="row g-3">
                        <!-- 组织名称 -->
                        <div class="col-md-8 form-item">
                            <label class="form-label fw-bold">组织名称 <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtOrgName" runat="server" CssClass="form-control" MaxLength="100" placeholder="输入组织全称" />
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtOrgName" ErrorMessage="请输入组织名称" CssClass="text-danger small" Display="Dynamic" />
                        </div>

                        <!-- 组织类型 -->
                        <div class="col-md-4 form-item">
                            <label class="form-label fw-bold">组织类型 <span class="text-danger">*</span></label>
                            <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select"  AutoPostBack="true"/>
                        </div>
                             <div class="mb-3">
    <label class="form-label">所属学院</label>
    <asp:TextBox ID="txtCollege" runat="server" CssClass="form-control" placeholder="如：计算机学院" MaxLength="50" />
    <asp:RequiredFieldValidator ID="rfvCollege" runat="server"
        ControlToValidate="txtCollege"
        ErrorMessage="院级组织必须填写所属学院"
        CssClass="text-danger"
        Display="Dynamic" />
    <small class="text-muted">
        院级组织必须填写；校级/社团组织无需填写，会自动禁用
    </small>
</div>

                        <!-- 组织简介 -->
                        <div class="col-12 form-item">
                            <label class="form-label fw-bold">组织简介 <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine"
                                         Rows="4" placeholder="介绍组织的宗旨、活动类型、特色等" MaxLength="2000" />
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtDescription" ErrorMessage="请填写组织简介" CssClass="text-danger small" Display="Dynamic" />
                        </div>

                        <!-- 联系方式 -->
                        <div class="col-md-6 form-item">
                            <label class="form-label fw-bold">联系方式</label>
                            <asp:TextBox ID="txtContact" runat="server" CssClass="form-control" MaxLength="200" placeholder="如QQ群、微信公众号等" />
                        </div>

                        <!-- 最大成员数 -->
                        <div class="col-md-6 form-item">
                            <label class="form-label fw-bold">最大成员数</label>
                            <asp:TextBox ID="txtMaxMembers" runat="server" CssClass="form-control" Text="50" />
                        </div>

                        <!-- 新增：组织Logo上传 -->
                        <div class="col-12 form-item">
                            <label class="form-label fw-bold">组织Logo</label>
                            <asp:FileUpload ID="fuOrgLogo" runat="server" CssClass="form-control" Accept="image/png,image/jpeg,image/gif" />
                            <small class="text-light small mt-1 d-block">支持JPG/PNG/GIF格式，建议尺寸200×200px，大小不超过2MB</small>
                            <img id="imgLogoPreview" alt="Logo预览" />
                        </div>

                        <!-- 提示 -->
                        <div class="col-12 form-item">
                            <div class="alert alert-info small mb-0">
                                <i class="bi bi-info-circle me-1"></i>
                                提交后将进入审批流程，学校/学院管理层审核通过后组织正式创建。审核结果将通过站内消息通知您。
                            </div>
                        </div>
                    </div>

                    <asp:Button ID="btnSubmit" runat="server" Text="提交申请" CssClass="btn btn-primary mt-4 fw-bold px-4 py-2"
                                OnClick="BtnSubmit_Click" />
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Logo预览JS -->
<script type="text/javascript">
    document.getElementById('<%= fuOrgLogo.ClientID %>').onchange = function (e) {
        var reader = new FileReader();
        reader.onload = function (event) {
            var preview = document.getElementById('imgLogoPreview');
            preview.src = event.target.result;
            preview.style.display = 'block';
        };
        reader.readAsDataURL(e.target.files[0]);
    };
</script>

    
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