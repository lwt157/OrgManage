<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AnnounceDetail.aspx.cs" Inherits="AnnounceDetail" %>

<!DOCTYPE html>
<html>
<head>
    <title>公告详情</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body style="background:#f8f9fa;padding:20px;">
    <div class="container">
        <div class="card p-4">
            <h3><asp:Literal ID="litTitle" runat="server" /></h3>
            <hr />
            <div><asp:Literal ID="litContent" runat="server" /></div>
        </div>
    </div>
</body>
</html>