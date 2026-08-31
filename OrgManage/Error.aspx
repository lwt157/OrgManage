<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Error.aspx.cs" Inherits="OrgManage.ErrorPage" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>出错了 - 高校组织综合线上管理平台</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            background: linear-gradient(135deg, #0f0c29 0%, #302b63 50%, #24243e 100%);
            color: #e0e0e0;
            font-family: "Microsoft YaHei", "Segoe UI", sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .error-box {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 20px;
            padding: 60px 50px;
            max-width: 520px;
            width: 90%;
            text-align: center;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);
        }
        .error-icon { font-size: 72px; margin-bottom: 20px; display: block; }
        .error-code { font-size: 80px; font-weight: 700; color: rgba(255, 255, 255, 0.1); line-height: 1; margin-bottom: 10px; }
        .error-title { font-size: 24px; font-weight: 600; color: #ffffff; margin-bottom: 16px; }
        .error-desc { font-size: 15px; color: rgba(255, 255, 255, 0.65); line-height: 1.7; margin-bottom: 32px; }
        .error-actions a {
            display: inline-block; padding: 12px 32px; margin: 0 8px;
            border-radius: 8px; text-decoration: none; font-size: 15px;
            transition: all 0.3s ease;
        }
        .btn-home {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff; border: none;
        }
        .btn-home:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4); }
        .btn-back {
            background: transparent; color: rgba(255, 255, 255, 0.8);
            border: 1px solid rgba(255, 255, 255, 0.25);
        }
        .btn-back:hover { background: rgba(255, 255, 255, 0.1); border-color: rgba(255, 255, 255, 0.4); }
    </style>
</head>
<body>
    <div class="error-box">
        <span class="error-icon"><asp:Literal ID="litIcon" runat="server" /></span>
        <div class="error-code"><asp:Literal ID="litCode" runat="server" /></div>
        <div class="error-title"><asp:Literal ID="litTitle" runat="server" /></div>
        <div class="error-desc"><asp:Literal ID="litDesc" runat="server" /></div>
        <div class="error-actions">
            <a href="<%= ResolveUrl("~/Default.aspx") %>" class="btn-home">返回首页</a>
            <a href="javascript:history.back()" class="btn-back">返回上页</a>
        </div>
    </div>
</body>
</html>
