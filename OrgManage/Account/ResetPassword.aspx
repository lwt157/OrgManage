<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ResetPassword.aspx.cs" Inherits="OrgManage.Account.ResetPassword" MasterPageFile="~/Site.Master" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <!-- 全站统一星空毛玻璃风格 -->
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

        /* 毛玻璃卡片 */
        .glass-card {
            background: rgba(255, 255, 255, 0.08) !important;
            backdrop-filter: blur(12px) !important;
            border: 1px solid rgba(255, 255, 255, 0.15) !important;
            border-radius: 18px !important;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3) !important;
            color: #fff !important;
            animation: cardSlideUp 1s ease forwards;
            transform: translateY(30px);
            opacity: 0;
        }

        @keyframes cardSlideUp {
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        /* 输入框 */
        .glass-card .form-control {
            background: rgba(255, 255, 255, 0.1) !important;
            border: 1px solid rgba(255, 255, 255, 0.2) !important;
            color: #fff !important;
            border-radius: 8px !important;
            transition: all 0.3s ease;
        }

        .glass-card .form-control:focus {
            background: rgba(255, 255, 255, 0.15) !important;
            border-color: #ff8ba7 !important;
            box-shadow: 0 0 10px rgba(255, 139, 167, 0.4) !important;
            outline: none;
        }

        .glass-card .form-control::placeholder {
            color: rgba(255, 255, 255, 0.6) !important;
        }

        /* 标签文字 */
        .glass-card .form-label {
            color: rgba(255, 255, 255, 0.9) !important;
            font-weight: 500;
        }

        /* 主按钮 */
        .btn-glow {
            background: linear-gradient(90deg, #e94560, #ff8ba7) !important;
            border: none !important;
            color: #fff !important;
            font-weight: bold !important;
            transition: all 0.3s ease;
        }

        .btn-glow:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(233, 69, 96, 0.4);
        }

        /* 错误提示文字 */
        .text-danger {
            font-weight: 500;
        }
    </style>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow-sm glass-card">
                <div class="card-body p-4">
                    <h3 class="text-center mb-4">重置密码</h3>

                    <div class="mb-3">
                        <label class="form-label">新密码 *</label>
                        <asp:TextBox ID="txtNewPwd" runat="server" TextMode="Password" CssClass="form-control" placeholder="请输入新密码" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtNewPwd" ErrorMessage="请输入新密码" CssClass="text-danger small" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">确认新密码 *</label>
                        <asp:TextBox ID="txtConfirmPwd" runat="server" TextMode="Password" CssClass="form-control" placeholder="请再次输入新密码" />
                        <asp:CompareValidator runat="server" ControlToValidate="txtNewPwd" ControlToCompare="txtConfirmPwd" ErrorMessage="两次密码不一致" CssClass="text-danger small" />
                    </div>
                    <div class="text-center">
                        <asp:Button ID="btnReset" runat="server" Text="确认修改" CssClass="btn btn-glow w-100" OnClick="btnReset_Click" />
                    </div>
                </div>
            </div>
        </div>
    </div>
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