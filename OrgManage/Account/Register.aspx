<%@ Page Title="注册" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="OrgManage.Register" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <!-- 全局星空背景 + 动态交互样式（与登录页完全统一 + 增强特效） -->
    <style>
        /* ==================== 1. 全局背景与页面动画 ==================== */
        body {
            background: url('<%= ResolveUrl("~/images/bg-night.jpg") %>') no-repeat center center fixed !important;
            background-size: cover !important;
            min-height: 100vh !important;
            color: #fff !important;
            animation: pageFadeIn 1s ease forwards;
            position: relative;
        }

        /* 全局星光层 - 与登录页完全一致 */
        body::before {
            content: '';
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            pointer-events: none;
            z-index: 0;
            background:
                radial-gradient(1px 1px at 10% 15%, rgba(255,255,255,0.5), transparent),
                radial-gradient(1px 1px at 25% 35%, rgba(255,255,255,0.4), transparent),
                radial-gradient(1.5px 1.5px at 40% 10%, rgba(255,255,255,0.55), transparent),
                radial-gradient(1px 1px at 55% 45%, rgba(255,255,255,0.35), transparent),
                radial-gradient(2px 2px at 70% 20%, rgba(255,200,220,0.5), transparent),
                radial-gradient(1px 1px at 85% 40%, rgba(255,255,255,0.45), transparent),
                radial-gradient(1.5px 1.5px at 15% 60%, rgba(255,200,220,0.4), transparent),
                radial-gradient(1px 1px at 60% 70%, rgba(255,255,255,0.5), transparent),
                radial-gradient(2px 2px at 80% 65%, rgba(255,255,255,0.35), transparent),
                radial-gradient(1px 1px at 35% 80%, rgba(255,200,220,0.5), transparent),
                radial-gradient(1.5px 1.5px at 90% 85%, rgba(255,255,255,0.4), transparent),
                radial-gradient(1px 1px at 5% 90%, rgba(255,255,255,0.45), transparent);
            animation: starsTwinkle 4s ease-in-out infinite alternate;
        }

        @keyframes starsTwinkle {
            0% { opacity: 0.5; }
            100% { opacity: 1; }
        }

        @keyframes pageFadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        /* ==================== 2. 毛玻璃登录卡片（完全统一） ==================== */
        .container.my-5 {
            position: relative;
            z-index: 1;
        }

        .glass-card {
            background: rgba(255, 255, 255, 0.07) !important;
            backdrop-filter: blur(16px) !important;
            -webkit-backdrop-filter: blur(16px) !important;
            border: 1px solid rgba(255, 255, 255, 0.15) !important;
            border-radius: 20px !important;
            box-shadow:
                0 8px 32px rgba(0, 0, 0, 0.35),
                0 0 0 rgba(255, 139, 167, 0) !important;
            color: #fff !important;
            animation: cardSlideUp 0.9s cubic-bezier(0.22, 0.61, 0.36, 1) forwards,
                       glowPulse 5s ease-in-out 1.5s infinite;
            transform: translateY(30px);
            opacity: 0;
            transition: box-shadow 0.6s ease, border-color 0.6s ease;
        }

        .glass-card:hover {
            border-color: rgba(255, 139, 167, 0.35) !important;
        }

        @keyframes cardSlideUp {
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        /* 卡片光晕呼吸 */
        @keyframes glowPulse {
            0%, 100% {
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.35), 0 0 0 rgba(255, 139, 167, 0);
            }
            50% {
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.35), 0 0 40px rgba(255, 139, 167, 0.18);
            }
        }

        /* 卡片微光扫过效果 */
        .glass-card .card-body {
            position: relative;
            overflow: hidden;
        }

        .glass-card .card-body::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -150%;
            width: 80%;
            height: 200%;
            background: linear-gradient(
                105deg,
                transparent 40%,
                rgba(255, 255, 255, 0.03) 45%,
                rgba(255, 255, 255, 0.1) 50%,
                rgba(255, 255, 255, 0.03) 55%,
                transparent 60%
            );
            transform: skewX(-20deg);
            animation: shine 7s ease-in-out 2s infinite;
            pointer-events: none;
            z-index: 0;
        }

        @keyframes shine {
            0% { left: -150%; }
            40% { left: 150%; }
            100% { left: 150%; }
        }

        .glass-card .card-body > * {
            position: relative;
            z-index: 1;
        }

        /* ==================== 3. 漂浮星空粒子 ==================== */
        .particles-container {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 0;
            overflow: hidden;
            border-radius: 20px;
        }

        .particle {
            position: absolute;
            border-radius: 50%;
            pointer-events: none;
            animation: floatParticle 6s ease-in-out infinite;
        }

        .particle:nth-child(1) {
            width: 4px; height: 4px;
            background: rgba(255, 255, 255, 0.7);
            box-shadow: 0 0 6px rgba(255, 255, 255, 0.5);
            top: 12%; left: 8%;
            animation-delay: 0s;
            animation-duration: 5.5s;
        }
        .particle:nth-child(2) {
            width: 3px; height: 3px;
            background: rgba(255, 180, 200, 0.75);
            box-shadow: 0 0 5px rgba(255, 139, 167, 0.5);
            top: 75%; left: 88%;
            animation-delay: -2s;
            animation-duration: 6.5s;
        }
        .particle:nth-child(3) {
            width: 3.5px; height: 3.5px;
            background: rgba(255, 255, 255, 0.65);
            box-shadow: 0 0 7px rgba(255, 255, 255, 0.45);
            top: 45%; left: 5%;
            animation-delay: -4s;
            animation-duration: 7s;
        }
        .particle:nth-child(4) {
            width: 2.5px; height: 2.5px;
            background: rgba(255, 200, 215, 0.7);
            box-shadow: 0 0 4px rgba(255, 139, 167, 0.45);
            top: 22%; left: 92%;
            animation-delay: -1.5s;
            animation-duration: 5.8s;
        }
        .particle:nth-child(5) {
            width: 3px; height: 3px;
            background: rgba(255, 255, 255, 0.6);
            box-shadow: 0 0 5px rgba(255, 255, 255, 0.4);
            top: 82%; left: 18%;
            animation-delay: -3s;
            animation-duration: 6.2s;
        }

        @keyframes floatParticle {
            0%, 100% {
                transform: translateY(0) translateX(0) scale(1);
                opacity: 0.3;
            }
            20% {
                transform: translateY(-18px) translateX(8px) scale(1.4);
                opacity: 0.8;
            }
            40% {
                transform: translateY(-8px) translateX(14px) scale(1);
                opacity: 0.4;
            }
            60% {
                transform: translateY(-22px) translateX(2px) scale(1.5);
                opacity: 0.75;
            }
            80% {
                transform: translateY(-5px) translateX(10px) scale(0.9);
                opacity: 0.35;
            }
        }

        .glass-card:hover .particle {
            animation-duration: 3s !important;
        }

        /* ==================== 4. 输入框样式 + 聚焦发光效果 ==================== */
        .glass-card .form-control {
            background: rgba(255, 255, 255, 0.08) !important;
            border: 1px solid rgba(255, 255, 255, 0.18) !important;
            color: #fff !important;
            border-radius: 10px !important;
            transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);
            font-size: 0.95rem;
            padding: 10px 14px;
        }

        .glass-card .form-control:focus {
            background: rgba(255, 255, 255, 0.14) !important;
            border-color: #ff8ba7 !important;
            box-shadow:
                0 0 14px rgba(255, 139, 167, 0.45),
                inset 0 0 20px rgba(255, 139, 167, 0.04) !important;
            outline: none;
            transform: translateY(-1px);
        }

        .glass-card .form-control::placeholder {
            color: rgba(255, 255, 255, 0.45) !important;
            transition: color 0.3s ease;
        }

        .glass-card .form-control:focus::placeholder {
            color: rgba(255, 255, 255, 0.6) !important;
        }

        .glass-card .input-group-text {
            background: rgba(255, 255, 255, 0.1) !important;
            border: 1px solid rgba(255, 255, 255, 0.18) !important;
            color: rgba(255, 255, 255, 0.7) !important;
            transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);
            border-radius: 10px 0 0 10px !important;
        }

        .input-group:focus-within .input-group-text {
            color: #ff8ba7 !important;
            border-color: #ff8ba7 !important;
            box-shadow: 0 0 10px rgba(255, 139, 167, 0.35);
            background: rgba(255, 139, 167, 0.15) !important;
        }

        /* ==================== 5. 文字颜色 ==================== */
        .glass-card .form-label,
        .glass-card .form-check-label,
        .glass-card .text-muted {
            color: rgba(255, 255, 255, 0.9) !important;
        }

        /* ==================== 6. 按钮样式（完全统一 + 增强） ==================== */
        .btn-glow {
            background: linear-gradient(135deg, #e94560, #c0392b, #16213e) !important;
            background-size: 200% 200% !important;
            border: none !important;
            color: #fff !important;
            font-weight: bold !important;
            letter-spacing: 0.08em;
            transition: all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1.2);
            position: relative;
            overflow: hidden;
            border-radius: 10px !important;
            font-size: 1rem;
            padding: 10px 0;
        }

        .btn-glow::before {
            content: '';
            position: absolute;
            top: 0; left: -100%;
            width: 100%; height: 100%;
            background: linear-gradient(90deg,
                transparent,
                rgba(255,255,255,0.15),
                transparent);
            transition: left 0.6s ease;
        }

        .btn-glow:hover::before {
            left: 100%;
        }

        .btn-glow:hover {
            transform: translateY(-3px) scale(1.03);
            box-shadow: 0 10px 28px rgba(233, 69, 96, 0.5), 0 0 40px rgba(255, 139, 167, 0.2);
            background-position: 100% 50% !important;
        }

        .btn-glow:active {
            transform: translateY(0) scale(0.97);
            box-shadow: 0 4px 14px rgba(233, 69, 96, 0.4);
            transition: all 0.1s ease;
        }

        /* 按钮涟漪效果 */
        .btn-glow .ripple-effect {
            position: absolute;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.35);
            transform: scale(0);
            animation: ripple 0.6s ease-out forwards;
            pointer-events: none;
        }

        @keyframes ripple {
            to { transform: scale(4); opacity: 0; }
        }

        /* 按钮加载状态 */
        .btn-glow.btn-loading {
            pointer-events: none;
            opacity: 0.85;
            letter-spacing: 0.04em;
        }

        /* 次级按钮样式统一 */
        .btn-outline-secondary {
            background: rgba(255, 255, 255, 0.1) !important;
            border: 1px solid rgba(255, 255, 255, 0.2) !important;
            color: #fff !important;
            border-radius: 10px !important;
            transition: all 0.35s ease;
        }

        .btn-outline-secondary:hover {
            background: rgba(255, 139, 167, 0.15) !important;
            border-color: #ff8ba7 !important;
            color: #ff8ba7 !important;
            transform: translateY(-1px);
        }

        /* ==================== 7. 链接样式 ==================== */
        .glass-card a {
            color: #ff8ba7 !important;
            font-weight: 500 !important;
            transition: all 0.3s ease;
            text-decoration: none;
            position: relative;
        }

        .glass-card a::after {
            content: '';
            position: absolute;
            bottom: -1px;
            left: 0;
            width: 0;
            height: 1px;
            background: #ff8ba7;
            transition: width 0.3s ease;
        }

        .glass-card a:hover {
            color: #ffb3c6 !important;
        }

        .glass-card a:hover::after {
            width: 100%;
        }

        /* ==================== 8. 下拉框样式适配深色 ==================== */
        .glass-card .form-select {
            background: rgba(255, 255, 255, 0.08) !important;
            border: 1px solid rgba(255, 255, 255, 0.18) !important;
            color: #fff !important;
            border-radius: 10px !important;
            transition: all 0.35s ease;
        }

        .glass-card .form-select option {
            background: #16213e !important;
            color: #fff !important;
        }

        .glass-card .form-select:focus {
            border-color: #ff8ba7 !important;
            box-shadow: 0 0 14px rgba(255, 139, 167, 0.45) !important;
        }

        /* ==================== 9. 标题图标动画 ==================== */
        .title-icon {
            color: #ff8ba7 !important;
            animation: iconPulse 2.5s ease-in-out infinite alternate;
            filter: drop-shadow(0 0 10px rgba(255, 139, 167, 0.5));
            transition: filter 0.5s ease;
        }

        .glass-card:hover .title-icon {
            filter: drop-shadow(0 0 20px rgba(255, 139, 167, 0.75));
        }

        @keyframes iconPulse {
            from {
                transform: scale(1);
                filter: drop-shadow(0 0 8px rgba(255, 139, 167, 0.4));
            }
            to {
                transform: scale(1.12);
                filter: drop-shadow(0 0 18px rgba(255, 139, 167, 0.7));
            }
        }

        /* ==================== 10. 错误提示样式 ==================== */
        .text-danger {
            font-weight: 500 !important;
        }
    </style>

    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <!-- 毛玻璃卡片 -->
                <div class="card border-0 shadow-lg rounded-4 glass-card">
                    <!-- 漂浮粒子容器 -->
                    <div class="particles-container">
                        <span class="particle"></span>
                        <span class="particle"></span>
                        <span class="particle"></span>
                        <span class="particle"></span>
                        <span class="particle"></span>
                    </div>

                    <div class="card-body p-4">
                        <div class="text-center mb-4">
                            <i class="bi bi-person-plus title-icon" style="font-size:2.5rem;"></i>
                            <h3 class="fw-bold mt-2">创建账号</h3>
                        </div>

                        <asp:Panel ID="panelForm" runat="server">
                            <div class="row g-3">
                                <!-- 学号：7位纯数字 -->
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">学号 *</label>
                                    <asp:TextBox ID="txtStudentNo" runat="server" CssClass="form-control" MaxLength="7" />
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtStudentNo" ErrorMessage="请输入学号" CssClass="text-danger small" />
                                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtStudentNo" 
                                        ValidationExpression="^\d{7}$" ErrorMessage="学号必须为7位纯数字" CssClass="text-danger small" />
                                </div>

                                <!-- 姓名：中文≥2字 / 英文≥4字母 -->
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">姓名 *</label>
                                    <asp:TextBox ID="txtUserName" runat="server" CssClass="form-control" />
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtUserName" ErrorMessage="请输入姓名" CssClass="text-danger small" />
                                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtUserName" 
                                        ValidationExpression="^([\u4e00-\u9fa5]{2,}|[a-zA-Z]{4,})$" 
                                        ErrorMessage="中文姓名至少2字，英文姓名至少4个字母" CssClass="text-danger small" />
                                </div>

                                <!-- 登录账号：字母数字组合，最长11位 -->
                                <div class="col-12">
                                    <label class="form-label fw-bold">登录账号 *</label>
                                    <asp:TextBox ID="txtLoginName" runat="server" CssClass="form-control" MaxLength="11" />
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtLoginName" ErrorMessage="请设置登录账号" CssClass="text-danger small" />
                                   <asp:RegularExpressionValidator runat="server" ControlToValidate="txtLoginName" 
                                   ValidationExpression="^[a-zA-Z0-9]{4,11}$" 
                                   ErrorMessage="登录账号长度必须为4-11位，可纯数字/纯字母/组合" CssClass="text-danger small" />
                                </div>

                                <!-- 密码：≥6位，含英文字母，区分大小写 -->
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">密码 *</label>
                                    <asp:TextBox ID="txtPwd" runat="server" TextMode="Password" CssClass="form-control" />
                                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPwd" 
                                        ValidationExpression="^(?=.*[a-zA-Z]).{6,}$" ErrorMessage="密码至少6位，且必须包含英文字母" CssClass="text-danger small" />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">确认密码 *</label>
                                    <asp:TextBox ID="txtPwd2" runat="server" TextMode="Password" CssClass="form-control" />
                                    <asp:CompareValidator runat="server" ControlToValidate="txtPwd" ControlToCompare="txtPwd2" ErrorMessage="两次密码不一致" CssClass="text-danger small" />
                                </div>

                                <!-- 邮箱 -->
                                <div class="col-md-7">
                                    <label class="form-label fw-bold">邮箱 *</label>
                                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="请输入QQ邮箱" />
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail" ErrorMessage="请输入邮箱" CssClass="text-danger small" />
                                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtEmail" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ErrorMessage="邮箱格式不正确" CssClass="text-danger small" />
                                </div>
                                <div class="col-md-5 d-flex align-items-end">
                                    <input type="button" id="btnSendCode" class="btn btn-glow w-100" value="获取验证码" onclick="sendVerifyCode()" />
                                </div>

                                <!-- 邮箱验证码 -->
                                <div class="col-12">
                                    <label class="form-label fw-bold">邮箱验证码 *</label>
                                    <asp:TextBox ID="txtCode" runat="server" CssClass="form-control" placeholder="输入6位数字验证码" MaxLength="6" />
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtCode" ErrorMessage="请输入验证码" CssClass="text-danger small" />
                                </div>

                                <!-- 图形验证码区域 -->
                                <div class="col-12">
                                    <label class="form-label fw-bold">图形验证码 *</label>
                                    <div class="input-group">
                                        <asp:TextBox ID="txtCaptcha" runat="server" CssClass="form-control" placeholder="输入图片中的4位数字" MaxLength="4" />
                                        <span class="input-group-text" style="cursor:pointer;" title="点击刷新验证码">
                                            <asp:Image ID="imgCaptcha" runat="server" 
                                                       ImageUrl="~/Account/Captcha.aspx" 
                                                       style="height:38px; display:block;" />
                                        </span>
                                    </div>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtCaptcha" ErrorMessage="请输入图形验证码" CssClass="text-danger small" />
                                </div>

                                <!-- 邀请密钥 -->
                                <div class="col-12">
                                    <label class="form-label fw-bold">邀请密钥（选填）</label>
                                    <div class="input-group">
                                        <asp:TextBox ID="txtInviteKey" runat="server" CssClass="form-control" placeholder="输入密钥获得高级权限" />
                                        <input type="button" id="btnCheckKey" class="btn btn-outline-secondary" value="查验密钥" onclick="checkInviteKey()" />
                                    </div>
                                    <asp:Label ID="litKeyStatus" runat="server" CssClass="small mt-1 d-block" />
                                </div>

                                <!-- 用户级别（自动显示，不可修改） -->
                                <div class="col-12" id="divRoleSelect" runat="server" style="display:none;">
                                    <label class="form-label fw-bold">用户级别</label>
                                    <asp:Label ID="lblRoleDisplay" runat="server" CssClass="form-control bg-light text-dark fw-bold"></asp:Label>
                                    <asp:HiddenField ID="hfRole" runat="server" />
                                </div>

                                <!-- 手机号：11位纯数字，必填 -->
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">手机号 *</label>
                                    <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" MaxLength="11" />
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPhone" ErrorMessage="请输入手机号" CssClass="text-danger small" />
                                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPhone" 
                                        ValidationExpression="^\d{11}$" ErrorMessage="手机号必须为11位纯数字" CssClass="text-danger small" />
                                </div>
                                <!-- 学院：必填 -->
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">所在学院 *</label>
                                    <asp:TextBox ID="txtCollege" runat="server" CssClass="form-control" />
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtCollege" ErrorMessage="请输入所在学院" CssClass="text-danger small" />
                                </div>

                                <!-- 注册按钮 -->
                                <div class="col-12 mt-3">
                                    <asp:Button ID="btnRegister" runat="server" Text="立即注册" CssClass="btn btn-glow w-100 fw-bold py-2" OnClick="BtnRegister_Click" />
                                </div>
                            </div>
                        </asp:Panel>

                        <div class="text-center mt-3 small">
                            已有账号？<a href="Login.aspx" class="fw-bold">直接登录</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="<%= ResolveUrl("~/Scripts/jquery-3.7.1.min.js") %>"></script>
    <script type="text/javascript">
        var countdown = 0;

        // 页面加载完成初始化所有特效
        $(function () {
            // 验证码图片点击刷新
            $('#<%= imgCaptcha.ClientID %>').click(function () {
                var baseUrl = this.src.split('?')[0];
                this.src = baseUrl + '?r=' + Math.random();
            });

            // 注册按钮涟漪效果
            var btnRegister = document.getElementById('<%= btnRegister.ClientID %>');
            if (btnRegister) {
                btnRegister.addEventListener('mousedown', function (e) {
                    var oldRipple = btnRegister.querySelector('.ripple-effect');
                    if (oldRipple) oldRipple.remove();

                    var ripple = document.createElement('span');
                    ripple.className = 'ripple-effect';

                    var rect = btnRegister.getBoundingClientRect();
                    var size = Math.max(rect.width, rect.height);
                    ripple.style.width = ripple.style.height = size + 'px';
                    ripple.style.left = (e.clientX - rect.left - size / 2) + 'px';
                    ripple.style.top = (e.clientY - rect.top - size / 2) + 'px';

                    btnRegister.appendChild(ripple);

                    ripple.addEventListener('animationend', function () {
                        ripple.remove();
                    });
                });

                // 点击加载状态
                btnRegister.addEventListener('click', function (e) {
                    if (typeof Page_ClientValidate === 'function') {
                        if (!Page_ClientValidate()) {
                            return;
                        }
                    }
                    setTimeout(() => {
                        btnRegister.classList.add('btn-loading');
                        btnRegister.value = '注册中...';
                        btnRegister.disabled = true;
                    }, 10);
                });
            }
        });

        // 发送验证码 AJAX
        function sendVerifyCode() {
            var email = document.getElementById('<%= txtEmail.ClientID %>').value.trim();
            if (email === '') {
                alert('请先输入邮箱');
                return;
            }
            var btn = document.getElementById('btnSendCode');
            btn.disabled = true;
            btn.value = '发送中...';

            $.ajax({
                type: 'POST',
                url: 'SendCodeHandler.ashx',
                data: { email: email },
                dataType: 'json',
                success: function (res) {
                    if (res.ok) {
                        alert(res.msg);
                        countdown = 60;
                        SetButtonTime(btn, '获取验证码', '重新发送');
                    } else {
                        alert('发送失败：' + res.msg);
                        btn.value = '获取验证码';
                        btn.disabled = false;
                    }
                },
                error: function () {
                    alert('网络错误，请稍后重试');
                    btn.value = '获取验证码';
                    btn.disabled = false;
                }
            });
        }

        // 查验密钥 AJAX（优化版：自动显示角色，不可修改）
        function checkInviteKey() {
            var key = document.getElementById('<%= txtInviteKey.ClientID %>').value.trim();
            var statusSpan = document.getElementById('<%= litKeyStatus.ClientID %>');
            var divRole = document.getElementById('<%= divRoleSelect.ClientID %>');
            var lblRole = document.getElementById('<%= lblRoleDisplay.ClientID %>');
            var hfRole = document.getElementById('<%= hfRole.ClientID %>');

            if (key === '') {
                statusSpan.innerHTML = '<span class="text-muted">请输入邀请密钥</span>';
                divRole.style.display = 'none';
                return;
            }

            $.ajax({
                type: 'POST',
                url: 'CheckKeyHandler.ashx',
                data: { key: key },
                dataType: 'json',
                success: function (res) {
                    if (res.ok) {
                        statusSpan.innerHTML = '<span class="text-success">✅ ' + res.msg + '</span>';
                        divRole.style.display = 'block';
                        hfRole.value = res.role;

                        // 自动显示角色名称
                        switch (res.role) {
                            case 1: lblRole.innerText = "普通学生"; break;
                            case 2: lblRole.innerText = "组织管理者"; break;
                            case 3: lblRole.innerText = "指导老师"; break;
                            case 5: lblRole.innerText = "系统管理员"; break;
                            default: lblRole.innerText = "普通学生"; break;
                        }
                    } else {
                        statusSpan.innerHTML = '<span class="text-danger">❌ ' + res.msg + '</span>';
                        divRole.style.display = 'none';
                    }
                },
                error: function (xhr) {
                    alert("请求失败：" + xhr.responseText);
                }
            });
        }

        // 倒计时通用函数
        function SetButtonTime(btn, normalText, sendingText) {
            if (countdown > 0) {
                btn.value = sendingText + "(" + countdown + ")";
                btn.disabled = true;
                countdown--;
                setTimeout(function () { SetButtonTime(btn, normalText, sendingText); }, 1000);
            } else {
                btn.value = normalText;
                btn.disabled = false;
            }
        }
    </script>

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
        document.addEventListener('selectstart', function (e) {
            e.preventDefault();
        });
    </script>
</asp:Content>