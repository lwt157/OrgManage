<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ForgotPassword.aspx.cs" Inherits="OrgManage.Account.ForgotPassword" MasterPageFile="~/Site.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        body {
            background: url('/images/bg-night.jpg') no-repeat center center fixed !important;
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
            -webkit-backdrop-filter: blur(12px) !important;
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

        .glass-card .form-label {
            color: rgba(255, 255, 255, 0.9) !important;
            font-weight: 500;
        }

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

        .btn-outline-secondary {
            background: rgba(255, 255, 255, 0.1) !important;
            border: 1px solid rgba(255, 255, 255, 0.2) !important;
            color: #fff !important;
            transition: all 0.3s ease;
        }

        .btn-outline-secondary:hover {
            background: rgba(255, 255, 255, 0.2) !important;
            border-color: #ff8ba7 !important;
            color: #ff8ba7 !important;
        }

        .text-danger {
            font-weight: 500;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow-sm glass-card">
                <div class="card-body p-4">
                    <h3 class="text-center mb-4">忘记密码</h3>

                    <asp:Panel ID="panelStep1" runat="server">
                        <div class="mb-3">
                            <label class="form-label">登录账号 *</label>
                            <asp:TextBox ID="txtLoginName" runat="server" CssClass="form-control" placeholder="请输入你的登录账号"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvLoginName" runat="server" ControlToValidate="txtLoginName" ErrorMessage="请输入账号" CssClass="text-danger small"></asp:RequiredFieldValidator>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">绑定邮箱 *</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="请输入注册时绑定的邮箱"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="请输入邮箱" CssClass="text-danger small"></asp:RequiredFieldValidator>
                        </div>
                        <div class="mb-3 text-center">
                            <asp:Button ID="btnCheckUser" runat="server" Text="查验账号" CssClass="btn btn-glow w-100" OnClick="btnCheckUser_Click"></asp:Button>
                        </div>
                        <span class="small text-center d-block text-center">
                            <asp:Literal ID="litStatus" runat="server"></asp:Literal>
                        </span>
                    </asp:Panel>

                    <asp:Panel ID="panelStep2" runat="server" Visible="false">
                        <div class="mb-3">
                            <label class="form-label">邮箱验证码 *</label>
                            <div class="input-group">
                                <asp:TextBox ID="txtCode" runat="server" CssClass="form-control" placeholder="输入邮箱收到的6位验证码" MaxLength="6"></asp:TextBox>
                                <asp:Button ID="btnSendCode" runat="server" Text="获取验证码" CssClass="btn btn-outline-secondary" OnClick="btnSendCode_Click"></asp:Button>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvCode" runat="server" ControlToValidate="txtCode" ErrorMessage="请输入验证码" CssClass="text-danger small"></asp:RequiredFieldValidator>
                        </div>
                        <div class="mb-3 text-center">
                            <asp:Button ID="btnVerifyCode" runat="server" Text="验证并重置密码" CssClass="btn btn-glow w-100" OnClick="btnVerifyCode_Click"></asp:Button>
                        </div>
                    </asp:Panel>
                </div>
            </div>
        </div>
    </div>
</div>

</asp:Content>