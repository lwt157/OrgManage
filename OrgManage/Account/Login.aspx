<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="OrgManage.Account_Login" MasterPageFile="~/Site.master" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <!-- 全局星空背景 + 动态交互样式 -->
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

        /* 全局星光层 - 通过body伪元素添加屏幕散落星点 */
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

        /* ==================== 2. 毛玻璃登录卡片 ==================== */
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

        @keyframes glowPulse {
            0%, 100% {
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.35), 0 0 0 rgba(255, 139, 167, 0);
            }
            50% {
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.35), 0 0 40px rgba(255, 139, 167, 0.18);
            }
        }

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
            top: 15%; left: 10%;
            animation-delay: 0s;
            animation-duration: 5.5s;
        }
        .particle:nth-child(2) {
            width: 3px; height: 3px;
            background: rgba(255, 180, 200, 0.75);
            box-shadow: 0 0 5px rgba(255, 139, 167, 0.5);
            top: 70%; left: 85%;
            animation-delay: -2s;
            animation-duration: 6.5s;
        }
        .particle:nth-child(3) {
            width: 3.5px; height: 3.5px;
            background: rgba(255, 255, 255, 0.65);
            box-shadow: 0 0 7px rgba(255, 255, 255, 0.45);
            top: 50%; left: 5%;
            animation-delay: -4s;
            animation-duration: 7s;
        }
        .particle:nth-child(4) {
            width: 2.5px; height: 2.5px;
            background: rgba(255, 200, 215, 0.7);
            box-shadow: 0 0 4px rgba(255, 139, 167, 0.45);
            top: 25%; left: 90%;
            animation-delay: -1.5s;
            animation-duration: 5.8s;
        }
        .particle:nth-child(5) {
            width: 3px; height: 3px;
            background: rgba(255, 255, 255, 0.6);
            box-shadow: 0 0 5px rgba(255, 255, 255, 0.4);
            top: 80%; left: 20%;
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

        .input-group:focus-within .input-group-text i {
            animation: iconGlow 1.5s ease-in-out infinite;
        }

        @keyframes iconGlow {
            0%, 100% { text-shadow: 0 0 0 rgba(255,139,167,0); }
            50% { text-shadow: 0 0 8px rgba(255,139,167,0.7); }
        }

        /* ==================== 5. 文字颜色 ==================== */
        .glass-card .form-label,
        .glass-card .text-muted {
            color: rgba(255, 255, 255, 0.9) !important;
        }

        .glass-card .text-muted {
            color: rgba(255, 255, 255, 0.6) !important;
        }

        /* ==================== 6. 按钮样式 ==================== */
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
            padding: 12px 0;
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

        .btn-glow .ripple-effect {
            position: absolute;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.35);
            transform: scale(0);
            animation: ripple 0.6s ease-out forwards;
            pointer-events: none;
        }

        @keyframes ripple {
            to {
                transform: scale(4);
                opacity: 0;
            }
        }

        .btn-glow.btn-loading {
            pointer-events: none;
            opacity: 0.85;
            letter-spacing: 0.04em;
        }

        .btn-glow.btn-loading::after {
            content: '';
            display: inline-block;
            width: 18px;
            height: 18px;
            margin-left: 10px;
            border: 2px solid rgba(255,255,255,0.4);
            border-top-color: #fff;
            border-radius: 50%;
            animation: btnSpin 0.7s linear infinite;
            vertical-align: middle;
        }

        @keyframes btnSpin {
            to { transform: rotate(360deg); }
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

        /* ==================== 8. 标题图标样式 ==================== */
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

        /* ==================== 9. 记住我复选框样式（彻底去除多余容器） ==================== */
        .remember-me-row {
            display: flex;
            align-items: center;
            padding-left: 0;
            margin: 0;
        }

        .remember-me-checkbox {
            margin: 0 8px 0 0;
            cursor: pointer;
            accent-color: #ff8ba7;
            /* 强制去除所有边框和背景 */
            border: none !important;
            outline: none !important;
            background: transparent !important;
        }

        .remember-me-label {
            cursor: pointer;
            font-size: 0.9rem;
            color: rgba(255, 255, 255, 0.85);
            margin: 0;
        }

        /* ==================== 10. 错误提示面板动画 ==================== */
        .glass-card .alert-danger {
            background: rgba(220, 53, 69, 0.2) !important;
            border: 1px solid rgba(220, 53, 69, 0.4) !important;
            color: #ffb3b3 !important;
            border-radius: 8px !important;
            animation: shakeError 0.5s ease;
            backdrop-filter: blur(4px);
        }

        @keyframes shakeError {
            0%, 100% { transform: translateX(0); }
            10%, 50%, 90% { transform: translateX(-4px); }
            30%, 70% { transform: translateX(4px); }
        }

        /* ==================== 11. 分割线样式 ==================== */
        .glass-card hr {
            border-color: rgba(255, 255, 255, 0.1) !important;
            opacity: 0.6;
        }

        /* ==================== 12. 响应式微调 ==================== */
        @media (max-width: 576px) {
            .glass-card .card-body {
                padding: 1.5rem !important;
            }
        }
    </style>

    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-5">

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

                    <div class="card-body p-5">
                        <div class="text-center mb-4">
                            <i class="bi bi-person-circle title-icon" style="font-size:3rem;"></i>
                            <h4 class="fw-bold mt-2">欢迎登录</h4>
                            <p class="text-muted small">高校组织综合线上管理平台</p>
                        </div>

                        <asp:Panel ID="panelError" runat="server" Visible="false" CssClass="alert alert-danger small">
                            <i class="bi bi-exclamation-circle me-1"></i>
                            <asp:Literal ID="litError" runat="server" />
                        </asp:Panel>

                        <div class="mb-3">
                            <label class="form-label fw-bold">登录账号</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-person"></i></span>
                                <asp:TextBox ID="txtLoginName" runat="server" CssClass="form-control"
                                             placeholder="请输入登录账号" MaxLength="50" />
                            </div>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtLoginName"
                                ErrorMessage="请输入登录账号" CssClass="text-danger small" Display="Dynamic" />
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">密码</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control"
                                             TextMode="Password" placeholder="请输入密码" MaxLength="50" />
                            </div>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPassword"
                                ErrorMessage="请输入密码" CssClass="text-danger small" Display="Dynamic" />
                        </div>

                        <!-- 记住我区域 - 用原生input替代，彻底去除多余容器 -->
                        <div class="mb-4 remember-me-row">
                            <input type="checkbox" id="chkRemember" runat="server" class="remember-me-checkbox" />
                            <label for="chkRemember" class="remember-me-label small">记住我（7天）</label>
                        </div>

                        <!-- 渐变按钮 -->
                        <asp:Button ID="btnLogin" runat="server" Text="登  录"
                                    CssClass="btn btn-glow w-100 fw-bold py-2"
                                    OnClick="BtnLogin_Click" />

                        <hr class="my-4" />

                        <p class="text-center small text-muted mb-0">
                            还没有账号？
                            <a href="~/Account/Register.aspx" runat="server" class="fw-bold">立即注册</a>
                             &nbsp;|&nbsp;
                            <a href="ForgotPassword.aspx" class="text-decoration-none">忘记密码？</a>
                        </p>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <!-- 交互脚本 -->
    <script type="text/javascript">
        (function () {
            function init() {
                var btnLogin = document.getElementById('<%= btnLogin.ClientID %>');
                var chkRemember = document.getElementById('<%= chkRemember.ClientID %>');
                var formCheckLabel = document.querySelector('.remember-me-label');

                // 按钮涟漪效果
                if (btnLogin) {
                    btnLogin.addEventListener('mousedown', function (e) {
                        var oldRipple = btnLogin.querySelector('.ripple-effect');
                        if (oldRipple) oldRipple.remove();

                        var ripple = document.createElement('span');
                        ripple.className = 'ripple-effect';

                        var rect = btnLogin.getBoundingClientRect();
                        var size = Math.max(rect.width, rect.height);
                        ripple.style.width = ripple.style.height = size + 'px';
                        ripple.style.left = (e.clientX - rect.left - size / 2) + 'px';
                        ripple.style.top = (e.clientY - rect.top - size / 2) + 'px';

                        btnLogin.appendChild(ripple);

                        ripple.addEventListener('animationend', function () {
                            ripple.remove();
                        });
                    });

                    btnLogin.addEventListener('click', function (e) {
                        if (typeof Page_ClientValidate === 'function') {
                            if (!Page_ClientValidate()) {
                                return;
                            }
                        }
                        setTimeout(function () {
                            if (btnLogin) {
                                btnLogin.classList.add('btn-loading');
                                btnLogin.value = '登录中';
                                btnLogin.disabled = true;
                            }
                        }, 10);
                    });
                }

                // 复选框点击增强
                if (formCheckLabel && chkRemember) {
                    formCheckLabel.addEventListener('click', function (e) {
                        var labelEl = this;
                        labelEl.style.transform = 'scale(0.97)';
                        setTimeout(function () {
                            labelEl.style.transform = 'scale(1)';
                        }, 150);
                    });

                    formCheckLabel.style.transition = 'transform 0.15s ease';
                }

                // 输入框聚焦时移除错误抖动残留
                var formControls = document.querySelectorAll('.glass-card .form-control');
                formControls.forEach(function (input) {
                    input.addEventListener('focus', function () {
                        var errorPanel = document.querySelector('.glass-card .alert-danger');
                        if (errorPanel) {
                            errorPanel.style.animation = 'none';
                            errorPanel.offsetHeight;
                            errorPanel.style.animation = '';
                        }
                    });
                });
            }

            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', init);
            } else {
                init();
            }
        })();
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
document.addEventListener('selectstart', function(e) {
e.preventDefault();
 });
      </script>

</asp:Content>