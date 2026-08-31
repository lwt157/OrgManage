<%@ Page Title="活动中心 - 高校组织综合线上管理平台" Language="C#" MasterPageFile="../Site.master"
         AutoEventWireup="true" CodeFile="List.aspx.cs" Inherits="OrgManage.Activities_List" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

<style>
    /* ========== 全局背景 & 深色遮罩 ========== */
    body {
        background: url('<%= ResolveUrl("~/images/orgs_list_bg.jpg") %>') no-repeat center center fixed !important;
        background-size: cover !important;
        min-height: 100vh !important;
        color: #fff !important;
    }
    body::before {
        content: '';
        position: fixed;
        inset: 0;
        background: linear-gradient(135deg, rgba(5,18,28,0.78) 0%, rgba(10,30,22,0.65) 55%, rgba(5,20,30,0.80) 100%);
        z-index: 0;
        pointer-events: none;
    }
    form {
        min-height: 100vh !important;
        display: flex !important;
        flex-direction: column !important;
        position: relative;
        z-index: 1;
    }
    .container { flex: 1 !important; }

    /* ========== 页面整体淡入 ========== */
    @keyframes pageFadeUp {
        from { opacity: 0; transform: translateY(24px); }
        to   { opacity: 1; transform: translateY(0); }
    }
    .activity-page {
        animation: pageFadeUp 0.85s cubic-bezier(.22,.68,0,1.2) forwards;
    }

    /* ========== Hero 区域 ========== */
    .activity-hero {
        position: relative;
        padding: 48px 0 32px;
        text-align: center;
        overflow: hidden;
    }
    /* 绿色脉冲光圈 */
    .activity-hero::before {
        content: '';
        position: absolute;
        top: -80px; left: 50%;
        transform: translateX(-50%);
        width: 500px; height: 500px;
        border-radius: 50%;
        background: radial-gradient(circle, rgba(32,201,151,0.12) 0%, transparent 70%);
        pointer-events: none;
        animation: heroGlow 4.5s ease-in-out infinite;
    }
    @keyframes heroGlow {
        0%,100% { opacity:0.5; transform:translateX(-50%) scale(1); }
        50%      { opacity:1;   transform:translateX(-50%) scale(1.15); }
    }

    /* Hero 图标 */
    .hero-icon-wrap {
        position: relative;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: 68px; height: 68px;
        border-radius: 22px;
        background: rgba(32,201,151,0.15);
        border: 1px solid rgba(32,201,151,0.35);
        margin-bottom: 20px;
        opacity: 0;
        animation: iconDrop 1s cubic-bezier(.22,.68,0,1.2) 0.1s forwards;
    }
    /* 旋转光环 */
    .hero-icon-wrap::before {
        content: '';
        position: absolute;
        inset: -6px;
        border-radius: 28px;
        border: 1.5px dashed rgba(32,201,151,0.30);
        animation: ringRotate 8s linear infinite;
    }
    @keyframes ringRotate {
        from { transform: rotate(0deg); }
        to   { transform: rotate(360deg); }
    }
    @keyframes iconDrop {
        0%  { opacity:0; transform: scale(0.3) rotate(20deg); }
        65% { opacity:1; transform: scale(1.08) rotate(-4deg); }
        100%{ opacity:1; transform: scale(1) rotate(0); }
    }
    .hero-icon-wrap i {
        font-size: 2rem;
        color: #20c997;
        filter: drop-shadow(0 2px 10px rgba(32,201,151,0.55));
    }

    .hero-title {
        font-size: 2.4rem;
        font-weight: 800;
        letter-spacing: -0.5px;
        color: #fff;
        text-shadow: 0 2px 20px rgba(0,0,0,0.6), 0 0 40px rgba(32,201,151,0.15);
        margin-bottom: 10px;
        opacity: 0;
        animation: textRise 0.8s 0.25s cubic-bezier(.22,.68,0,1.2) forwards;
    }
    .hero-sub {
        font-size: 1rem;
        color: rgba(255,255,255,0.80);
        text-shadow: 0 1px 6px rgba(0,0,0,0.55);
        letter-spacing: 0.3px;
        margin: 0;
        opacity: 0;
        animation: textRise 0.8s 0.42s cubic-bezier(.22,.68,0,1.2) forwards;
    }
    @keyframes textRise {
        from { opacity:0; transform: translateY(14px); }
        to   { opacity:1; transform: translateY(0); }
    }

    /* 装饰分隔线 */
    .hero-divider {
        display: flex;
        align-items: center;
        gap: 12px;
        justify-content: center;
        margin: 20px 0 0;
        opacity: 0;
        animation: textRise 0.7s 0.55s ease forwards;
    }
    .hdl { height: 1px; width: 80px; background: linear-gradient(90deg,transparent,rgba(32,201,151,0.55),transparent); }
    .hdd { width:6px;height:6px;border-radius:50%;background:rgba(32,201,151,0.7);box-shadow:0 0 8px rgba(32,201,151,0.5); }

    /* ========== 统计芯片行 ========== */
    .stats-bar {
        display: flex;
        justify-content: center;
        gap: 16px;
        margin: 22px 0 28px;
        flex-wrap: wrap;
        opacity: 0;
        animation: textRise 0.7s 0.68s ease forwards;
    }
    .stat-chip {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 7px 18px;
        border-radius: 100px;
        background: rgba(255,255,255,0.07);
        border: 1px solid rgba(255,255,255,0.13);
        backdrop-filter: blur(10px);
        font-size: 0.82rem;
        color: rgba(255,255,255,0.88);
        text-shadow: 0 1px 4px rgba(0,0,0,0.4);
        font-weight: 500;
        transition: all 0.25s ease;
        cursor: default;
    }
    .stat-chip:hover {
        background: rgba(32,201,151,0.15);
        border-color: rgba(32,201,151,0.4);
        transform: translateY(-2px);
    }
    .stat-chip i { color: #20c997; }

    /* ========== 搜索栏（创新设计：全宽悬浮条） ========== */
    .search-wrap {
        position: relative;
        max-width: 660px;
        margin: 0 auto 36px;
        opacity: 0;
        animation: textRise 0.7s 0.8s ease forwards;
    }
    .search-inner {
        display: flex;
        align-items: center;
        background: rgba(255,255,255,0.07);
        backdrop-filter: blur(20px);
        border: 1px solid rgba(255,255,255,0.15);
        border-radius: 100px;
        padding: 6px 6px 6px 20px;
        transition: all 0.3s ease;
        box-shadow: 0 4px 24px rgba(0,0,0,0.18);
    }
    .search-inner:focus-within {
        border-color: rgba(32,201,151,0.5);
        background: rgba(255,255,255,0.10);
        box-shadow: 0 4px 28px rgba(0,0,0,0.2), 0 0 0 3px rgba(32,201,151,0.1);
    }
    .search-icon {
        color: rgba(255,255,255,0.5);
        margin-right: 10px;
        font-size: 1rem;
        flex-shrink: 0;
        transition: color 0.3s;
    }
    .search-inner:focus-within .search-icon { color: #20c997; }
    .search-input {
        flex: 1;
        background: transparent !important;
        border: none !important;
        color: #fff !important;
        font-size: 0.92rem;
        outline: none !important;
        box-shadow: none !important;
        padding: 0;
        text-shadow: 0 1px 3px rgba(0,0,0,0.4);
    }
    .search-input::placeholder { color: rgba(255,255,255,0.4); }
    .btn-search {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 10px 26px;
        border-radius: 100px;
        background: linear-gradient(135deg, #20c997 0%, #00b894 100%);
        color: #fff;
        font-size: 0.88rem;
        font-weight: 700;
        border: none;
        cursor: pointer;
        transition: all 0.25s cubic-bezier(.22,.68,0,1.2);
        letter-spacing: 0.3px;
        flex-shrink: 0;
        box-shadow: 0 4px 14px rgba(32,201,151,0.35);
        position: relative;
        overflow: hidden;
    }
    .btn-search::before {
        content:'';
        position:absolute;top:0;left:-100%;
        width:70%;height:100%;
        background:linear-gradient(90deg,transparent,rgba(255,255,255,.3),transparent);
        transition: left 0.4s ease;
    }
    .btn-search:hover { transform: scale(1.06); box-shadow: 0 6px 20px rgba(32,201,151,0.5); }
    .btn-search:hover::before { left: 150%; }
    .btn-search:active { transform: scale(0.97); }

    /* ========== 卡片网格 ========== */
    .activity-grid {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 22px;
        margin-bottom: 40px;
    }
    @media (max-width: 991px) { .activity-grid { grid-template-columns: repeat(2, 1fr); } }
    @media (max-width: 575px) {
        .activity-grid { grid-template-columns: 1fr; }
        .hero-title { font-size: 1.9rem; }
    }

    /* ========== 活动卡片 ========== */
    .act-card {
        position: relative;
        background: rgba(255,255,255,0.06);
        backdrop-filter: blur(18px) saturate(1.4);
        -webkit-backdrop-filter: blur(18px) saturate(1.4);
        border: 1px solid rgba(255,255,255,0.12);
        border-radius: 20px;
        overflow: hidden;
        opacity: 0;
        transition: transform 0.35s cubic-bezier(.22,.68,0,1.2),
                    box-shadow 0.35s ease,
                    border-color 0.35s ease,
                    background 0.35s ease;
        cursor: pointer;
    }
    /* 卡片入场：stagger */
    .act-card:nth-child(1){ animation: cardRise 0.7s 0.20s cubic-bezier(.22,.68,0,1.2) forwards; }
    .act-card:nth-child(2){ animation: cardRise 0.7s 0.30s cubic-bezier(.22,.68,0,1.2) forwards; }
    .act-card:nth-child(3){ animation: cardRise 0.7s 0.40s cubic-bezier(.22,.68,0,1.2) forwards; }
    .act-card:nth-child(4){ animation: cardRise 0.7s 0.50s cubic-bezier(.22,.68,0,1.2) forwards; }
    .act-card:nth-child(5){ animation: cardRise 0.7s 0.60s cubic-bezier(.22,.68,0,1.2) forwards; }
    .act-card:nth-child(6){ animation: cardRise 0.7s 0.70s cubic-bezier(.22,.68,0,1.2) forwards; }
    .act-card:nth-child(n+7){ animation: cardRise 0.7s 0.80s cubic-bezier(.22,.68,0,1.2) forwards; }
    @keyframes cardRise {
        from { opacity:0; transform: translateY(38px) scale(0.93); }
        to   { opacity:1; transform: translateY(0) scale(1); }
    }

    /* 鼠标光晕 */
    .act-card::before {
        content:'';
        position:absolute;inset:0;border-radius:20px;
        background:radial-gradient(circle at var(--mx,50%) var(--my,50%), rgba(32,201,151,0.10) 0%, transparent 60%);
        opacity:0;transition:opacity .35s ease;pointer-events:none;z-index:0;
    }
    .act-card:hover::before { opacity:1; }
    .act-card:hover {
        transform: translateY(-8px) scale(1.015);
        border-color: rgba(32,201,151,0.30);
        background: rgba(255,255,255,0.10);
        box-shadow: 0 20px 48px rgba(0,0,0,.30), 0 0 0 1px rgba(32,201,151,0.15);
    }

    /* ---- 卡片顶部色条（活动状态决定颜色）---- */
    .card-top-bar {
        height: 4px;
        border-radius: 20px 20px 0 0;
        position: relative; overflow: hidden; z-index: 1;
    }
    .card-top-bar.status-open    { background: linear-gradient(90deg,#20c997,#00b894,#5efce8); }
    .card-top-bar.status-pending { background: linear-gradient(90deg,#ffc107,#ffad00,#ffd700); }
    .card-top-bar.status-closed  { background: linear-gradient(90deg,#6c757d,#adb5bd); }
    .card-top-bar::after {
        content:'';position:absolute;top:0;left:-100%;width:60%;height:100%;
        background:linear-gradient(90deg,transparent,rgba(255,255,255,.55),transparent);
        animation: shimmer 2.8s 1.2s ease-in-out infinite;
    }
    @keyframes shimmer { 0%{left:-100%;}100%{left:200%;} }

    .card-body-inner { padding: 18px 20px 20px; position:relative; z-index:1; }

    /* 头部：组织名 + 状态标签 */
    .card-head {
        display: flex;
        align-items: flex-start;
        justify-content: space-between;
        gap: 8px;
        margin-bottom: 12px;
    }
    .badge-org {
        display: inline-flex;
        align-items: center;
        gap: 4px;
        padding: 4px 11px;
        border-radius: 100px;
        background: rgba(255,255,255,0.09);
        border: 1px solid rgba(255,255,255,0.16);
        color: rgba(255,255,255,0.88);
        font-size: 0.73rem;
        font-weight: 600;
        text-shadow: 0 1px 4px rgba(0,0,0,0.5);
        white-space: nowrap;
        max-width: 140px;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .badge-status {
        display: inline-flex;
        align-items: center;
        gap: 4px;
        padding: 4px 10px;
        border-radius: 100px;
        font-size: 0.72rem;
        font-weight: 700;
        flex-shrink: 0;
        letter-spacing: 0.3px;
    }
    .badge-status.open    { background:rgba(32,201,151,0.22);border:1px solid rgba(32,201,151,0.45);color:#5efce8; text-shadow:0 0 8px rgba(32,201,151,0.5); }
    .badge-status.pending { background:rgba(255,193,7,0.20); border:1px solid rgba(255,193,7,0.40); color:#ffe066; }
    .badge-status.closed  { background:rgba(108,117,125,0.22);border:1px solid rgba(108,117,125,0.35);color:rgba(255,255,255,0.55); }
    /* 报名中闪烁点 */
    .status-dot {
        width: 6px;height:6px;border-radius:50%;flex-shrink:0;
    }
    .status-dot.open { background:#20c997;box-shadow:0 0 6px #20c997;animation:dotBlink 1.5s ease-in-out infinite; }
    .status-dot.pending { background:#ffc107; }
    .status-dot.closed  { background:#6c757d; }
    @keyframes dotBlink {
        0%,100%{opacity:1;} 50%{opacity:0.3;}
    }

    /* 活动标题 */
    .card-title-link {
        font-size: 1.02rem;
        font-weight: 800;
        color: #fff;
        text-decoration: none;
        text-shadow: 0 2px 10px rgba(0,0,0,0.6);
        line-height: 1.4;
        letter-spacing: -0.2px;
        display: block;
        margin-bottom: 8px;
        transition: color 0.2s ease;
    }
    .card-title-link:hover { color: #5efce8; }

    /* 描述摘要 */
    .card-desc {
        font-size: 0.82rem;
        color: rgba(255,255,255,0.72);
        text-shadow: 0 1px 4px rgba(0,0,0,0.45);
        line-height: 1.6;
        height: 50px;
        overflow: hidden;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        border-left: 2px solid rgba(32,201,151,0.3);
        padding-left: 10px;
        margin-bottom: 14px;
    }

    /* 信息网格（时间/地点/人数）*/
    .card-info-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 6px 10px;
        margin-bottom: 14px;
    }
    .info-item {
        display: flex;
        align-items: center;
        gap: 5px;
        font-size: 0.76rem;
        color: rgba(255,255,255,0.70);
        text-shadow: 0 1px 3px rgba(0,0,0,0.4);
    }
    .info-item i { color: rgba(32,201,151,0.75); font-size: 0.72rem; flex-shrink:0; }
    /* 时间格跨两列 */
    .info-item.full { grid-column: 1 / -1; }

    /* 分隔线 */
    .card-divider {
        height: 1px;
        background: linear-gradient(90deg,rgba(255,255,255,0.10) 0%,transparent 100%);
        margin-bottom: 14px;
    }

    /* 报名进度 + 按钮行 */
    .card-bottom {
        display: flex;
        align-items: center;
        gap: 12px;
    }
    .enroll-progress { flex: 1; min-width: 0; }
    .enroll-label {
        font-size: 0.71rem;
        color: rgba(255,255,255,0.62);
        text-shadow: 0 1px 3px rgba(0,0,0,0.4);
        margin-bottom: 5px;
        display: flex;
        align-items: center;
        gap: 5px;
    }
    .enroll-label i { color: rgba(32,201,151,0.7); }
    .enroll-bar-bg {
        height: 4px;
        border-radius: 4px;
        background: rgba(255,255,255,0.10);
        overflow: hidden;
    }
    .enroll-bar-fill {
        height: 100%;
        border-radius: 4px;
        background: linear-gradient(90deg, #20c997, #00e5c4);
        min-width: 6px;
        transition: width 1.1s cubic-bezier(.22,.68,0,1.2);
    }

    /* 详情按钮 */
    .btn-detail {
        display: inline-flex;
        align-items: center;
        gap: 5px;
        padding: 8px 16px;
        border-radius: 100px;
        background: rgba(32,201,151,0.15);
        border: 1px solid rgba(32,201,151,0.40);
        color: #5efce8;
        font-size: 0.80rem;
        font-weight: 700;
        text-decoration: none;
        letter-spacing: 0.2px;
        white-space: nowrap;
        flex-shrink: 0;
        transition: all 0.25s cubic-bezier(.22,.68,0,1.2);
        position: relative;
        overflow: hidden;
    }
    .btn-detail::before {
        content:'';position:absolute;top:0;left:-100%;width:70%;height:100%;
        background:linear-gradient(90deg,transparent,rgba(255,255,255,.2),transparent);
        transition:left .4s ease;
    }
    .btn-detail:hover {
        background: rgba(32,201,151,0.28);
        border-color: rgba(32,201,151,0.65);
        transform: translateY(-2px) scale(1.05);
        box-shadow: 0 6px 18px rgba(32,201,151,0.3);
        color: #fff;
    }
    .btn-detail:hover::before { left:150%; }

    /* ========== 空状态 ========== */
    .empty-state {
        text-align: center;
        padding: 80px 20px;
        opacity: 0;
        animation: pageFadeUp 0.8s 0.3s ease forwards;
    }
    .empty-icon-ring {
        width: 90px; height: 90px;
        border-radius: 50%;
        background: rgba(32,201,151,0.08);
        border: 2px dashed rgba(32,201,151,0.28);
        display: inline-flex;
        align-items: center;
        justify-content: center;
        margin-bottom: 20px;
        animation: ringFloat 4s ease-in-out infinite;
    }
    @keyframes ringFloat {
        0%,100%{transform:translateY(0);}
        50%    {transform:translateY(-8px);}
    }
    .empty-icon-ring i { font-size: 2.2rem; color:rgba(32,201,151,0.55); }
    .empty-state h5 { color:rgba(255,255,255,.85);font-weight:700;text-shadow:0 1px 6px rgba(0,0,0,.5);margin-bottom:8px; }
    .empty-state p  { color:rgba(255,255,255,.50);text-shadow:0 1px 4px rgba(0,0,0,.4);font-size:.9rem; }

    /* ========== 浮动粒子 ========== */
    .particles-bg { position:fixed;inset:0;pointer-events:none;z-index:0;overflow:hidden; }
    .particle {
        position:absolute;border-radius:50%;
        background:rgba(32,201,151,0.35);
        animation:floatUp linear infinite;
    }
    @keyframes floatUp {
        0%  {transform:translateY(100vh) scale(0);opacity:0;}
        10% {opacity:1;}
        90% {opacity:.5;}
        100%{transform:translateY(-10vh) scale(1);opacity:0;}
    }

    /* ========== 搜索高亮闪烁 ========== */
    .card-highlight {
        animation: highlightPop 0.5s cubic-bezier(.22,.68,0,1.2);
    }
    @keyframes highlightPop {
        0%  { box-shadow: 0 0 0 0 rgba(32,201,151,0); }
        50% { box-shadow: 0 0 0 6px rgba(32,201,151,0.30); }
        100%{ box-shadow: 0 0 0 0 rgba(32,201,151,0); }
    }
</style>

<%-- 粒子背景 --%>
<div class="particles-bg" id="particlesBg" aria-hidden="true"></div>

<div class="container activity-page my-0 py-0">

    <%-- ===== HERO 区域 ===== --%>
    <div class="activity-hero">
        <div class="hero-icon-wrap">
            <i class="bi bi-calendar-event-fill"></i>
        </div>
        <h1 class="hero-title">活动中心</h1>
        <p class="hero-sub">发现精彩校园活动 · 相遇志同道合的伙伴</p>
        <div class="hero-divider">
            <div class="hdl"></div>
            <div class="hdd"></div>
            <div class="hdd" style="width:4px;height:4px;opacity:.5;"></div>
            <div class="hdd" style="width:3px;height:3px;opacity:.3;"></div>
            <div class="hdl"></div>
        </div>
    </div>

    <%-- ===== 统计芯片 ===== --%>
   <div class="stats-bar" id="statsBar">
    <span class="stat-chip"><i class="bi bi-broadcast-pin"></i> 活动进行中</span>
    <span class="stat-chip"><i class="bi bi-grid-fill"></i> <asp:Literal ID="litTotal" runat="server">0</asp:Literal> 场活动</span>
    <span class="stat-chip"><i class="bi bi-people-fill"></i> 等你加入</span>
</div>

    <%-- ===== 搜索栏（胶囊悬浮式） ===== --%>
    <div class="search-wrap">
        <div class="search-inner">
            <i class="bi bi-search search-icon"></i>
            <asp:TextBox ID="txtKeyword" runat="server"
                CssClass="form-control search-input"
                placeholder="搜索活动名称、地点或组织..." />
            <asp:Button ID="btnSearch" runat="server"
                Text="搜索" CssClass="btn-search"
                OnClick="BtnSearch_Click" />
        </div>
    </div>

    <%-- ===== 活动卡片网格 ===== --%>
    <div class="activity-grid" id="activityGrid">
        <asp:Repeater ID="rptActs" runat="server">
            <ItemTemplate>
                <div class="act-card" data-enrolled='<%# Eval("EnrolledCount") %>' data-max='<%# Eval("MaxEnroll") %>'>
                    <%-- 顶部状态色条 --%>
                    <div class="card-top-bar <%# GetStatusBarClass(Convert.ToInt32(Eval("Status"))) %>"></div>
                    <div class="card-body-inner">

                        <%-- 头部：组织 + 状态 --%>
                        <div class="card-head">
                            <span class="badge-org">
                                <i class="bi bi-building" style="font-size:.62rem;"></i>
                                <%# Eval("OrgName") %>
                            </span>
                            <span class="badge-status <%# GetStatusBadgeClass(Convert.ToInt32(Eval("Status"))) %>">
                                <span class="status-dot <%# GetStatusBadgeClass(Convert.ToInt32(Eval("Status"))) %>"></span>
                                <%# OrgManage.APP_Code.Utils.GetActivityStatusName(Convert.ToInt32(Eval("Status"))) %>
                            </span>
                        </div>

                        <%-- 标题 --%>
                        <a href='Detail.aspx?id=<%# Eval("ActivityID") %>' class="card-title-link">
                            <%# Eval("Title") %>
                        </a>

                        <%-- 描述 --%>
                        <div class="card-desc">
                            <%# OrgManage.APP_Code.Utils.CutString(Eval("Description").ToString(), 55) %>
                        </div>

                        <%-- 信息网格 --%>
                        <div class="card-info-grid">
                            <div class="info-item full">
                                <i class="bi bi-clock-fill"></i>
                                <span><%# Convert.ToDateTime(Eval("StartTime")).ToString("yyyy-MM-dd HH:mm") %></span>
                            </div>
                            <div class="info-item">
                                <i class="bi bi-geo-alt-fill"></i>
                                <span style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"><%# Eval("Location") %></span>
                            </div>
                            <div class="info-item">
                                <i class="bi bi-people-fill"></i>
                                <span>
                                    <strong style="color:#5efce8;"><%# Eval("EnrolledCount") %></strong>
                                    /
                                    <strong style="color:#5efce8;"><%# Convert.ToInt32(Eval("MaxEnroll")) == 0 ? "不限" : Eval("MaxEnroll").ToString() %></strong>
                                    人
                                </span>
                            </div>
                        </div>

                        <div class="card-divider"></div>

                        <%-- 进度 + 按钮 --%>
                        <div class="card-bottom">
                            <div class="enroll-progress">
                                <div class="enroll-label">
                                    <i class="bi bi-person-check-fill"></i>
                                    报名进度
                                </div>
                                <div class="enroll-bar-bg">
                                    <div class="enroll-bar-fill"
                                         style="width:<%# GetEnrollPercent(Eval("EnrolledCount"), Eval("MaxEnroll")) %>%;"></div>
                                </div>
                            </div>
                            <a href='Detail.aspx?id=<%# Eval("ActivityID") %>' class="btn-detail">
                                查看详情 <i class="bi bi-arrow-right-short"></i>
                            </a>
                        </div>

                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <%-- ===== 空状态 ===== --%>
    <asp:Panel ID="panelEmpty" runat="server" Visible="false">
        <div class="empty-state">
            <div class="empty-icon-ring">
                <i class="bi bi-calendar-x"></i>
            </div>
            <h5>暂无活动</h5>
            <p>当前没有符合条件的活动，请稍后再来查看</p>
        </div>
    </asp:Panel>

</div>

<script>
(function () {

    /* ── 1. 浮动粒子 ── */
    var bg = document.getElementById('particlesBg');
    if (bg) {
        for (var i = 0; i < 20; i++) {
            var p = document.createElement('div');
            p.className = 'particle';
            var s = (Math.random() * 3 + 1.2).toFixed(1);
            p.style.cssText = [
                'left:' + (Math.random() * 100).toFixed(1) + '%',
                'width:' + s + 'px', 'height:' + s + 'px',
                'opacity:' + (Math.random() * 0.45 + 0.1).toFixed(2),
                'animation-duration:' + (Math.random() * 14 + 8).toFixed(1) + 's',
                'animation-delay:' + (Math.random() * 12).toFixed(1) + 's'
            ].join(';');
            bg.appendChild(p);
        }
    }

    window.addEventListener('DOMContentLoaded', function () {

        /* ── 3. 鼠标追踪光晕 ── */
        var cards = document.querySelectorAll('.act-card');
        cards.forEach(function (card) {
            card.addEventListener('mousemove', function (e) {
                var r = card.getBoundingClientRect();
                card.style.setProperty('--mx', ((e.clientX - r.left) / r.width * 100).toFixed(1) + '%');
                card.style.setProperty('--my', ((e.clientY - r.top) / r.height * 100).toFixed(1) + '%');
            });
        });

        /* ── 4. 进度条延迟动画 ── */
        setTimeout(function () {
            document.querySelectorAll('.enroll-bar-fill').forEach(function (bar) {
                var w = bar.style.width;
                bar.style.width = '0%';
                setTimeout(function () { bar.style.width = w; }, 150);
            });
        }, 400);

        /* ── 5. 搜索按钮点击：卡片高亮闪烁 ── */
        var btnSearch = document.querySelector('.btn-search');
        if (btnSearch) {
            btnSearch.addEventListener('click', function () {
                var cards = document.querySelectorAll('.act-card');
                cards.forEach(function (card, idx) {
                    setTimeout(function () {
                        card.classList.remove('card-highlight');
                        void card.offsetWidth;
                        card.classList.add('card-highlight');
                    }, idx * 60);
                });
            });
        }

        /* ── 6. 搜索框：回车触发 ── */
        var input = document.querySelector('.search-input');
        if (input) {
            input.addEventListener('keydown', function (e) {
                if (e.key === 'Enter') {
                    var btn = document.getElementById('<%= btnSearch.ClientID %>');
                    if (btn) btn.click();
                }
            });
        }

        /* ── 7. Intersection Observer 滚动淡入（多于一屏时） ── */
        if ('IntersectionObserver' in window) {
            var io = new IntersectionObserver(function (entries) {
                entries.forEach(function (entry) {
                    if (entry.isIntersecting) {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateY(0) scale(1)';
                        io.unobserve(entry.target);
                    }
                });
            }, { threshold: 0.1 });
            Array.prototype.slice.call(cards, 6).forEach(function (card) {
                io.observe(card);
            });
        }
    });
    })();
</script>

    <script>
        // ==================== 防复制/防查看源码====================
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