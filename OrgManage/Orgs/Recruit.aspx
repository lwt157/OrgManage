<%@ Page Title="招新广场 - 高校组织综合线上管理平台" Language="C#" MasterPageFile="../Site.master"
         AutoEventWireup="true" CodeFile="Recruit.aspx.cs" Inherits="OrgManage.Orgs_Recruit" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

<style>
    /* ========== 全局背景 & 页面入场 ========== */
    body {
        background: url('<%= ResolveUrl("~/images/orgs_list_bg.jpg") %>') no-repeat center center fixed !important;
        background-size: cover !important;
        min-height: 100vh !important;
        color: #fff !important;
    }
    /* 背景暗色遮罩，确保文字清晰 */
    body::before {
        content: '';
        position: fixed;
        inset: 0;
        background: linear-gradient(135deg, rgba(10,12,30,0.72) 0%, rgba(20,25,60,0.60) 60%, rgba(10,15,35,0.75) 100%);
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

    /* ========== 页面整体淡入上移 ========== */
    @keyframes pageFadeUp {
        from { opacity: 0; transform: translateY(28px); }
        to   { opacity: 1; transform: translateY(0); }
    }
    .recruit-page {
        animation: pageFadeUp 0.9s cubic-bezier(.22,.68,0,1.2) forwards;
    }

    /* ========== 顶部 Hero Banner ========== */
    .recruit-hero {
        position: relative;
        padding: 48px 0 36px;
        text-align: center;
        overflow: hidden;
    }
    .recruit-hero::before {
        content: '';
        position: absolute;
        top: -60px; left: 50%;
        transform: translateX(-50%);
        width: 520px; height: 520px;
        border-radius: 50%;
        background: radial-gradient(circle, rgba(255,193,7,0.13) 0%, transparent 70%);
        pointer-events: none;
        animation: pulseGlow 4s ease-in-out infinite;
    }
    @keyframes pulseGlow {
        0%,100% { opacity: 0.6; transform: translateX(-50%) scale(1); }
        50%      { opacity: 1;   transform: translateX(-50%) scale(1.12); }
    }

    .recruit-hero-icon {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: 64px; height: 64px;
        border-radius: 20px;
        background: rgba(255,193,7,0.18);
        border: 1px solid rgba(255,193,7,0.35);
        margin-bottom: 18px;
        animation: iconBounce 1.1s cubic-bezier(.22,.68,0,1.2) forwards;
        opacity: 0;
    }
    @keyframes iconBounce {
        0%   { opacity:0; transform: scale(0.4) rotate(-15deg); }
        70%  { opacity:1; transform: scale(1.1) rotate(3deg); }
        100% { opacity:1; transform: scale(1) rotate(0); }
    }
    .recruit-hero-icon i {
        font-size: 2rem;
        color: #ffc107;
        filter: drop-shadow(0 2px 8px rgba(255,193,7,0.5));
    }

    .recruit-hero h1 {
        font-size: 2.4rem;
        font-weight: 800;
        letter-spacing: -0.5px;
        color: #fff;
        text-shadow: 0 2px 18px rgba(0,0,0,0.55), 0 0 40px rgba(255,193,7,0.18);
        margin-bottom: 10px;
        opacity: 0;
        animation: heroTextIn 0.8s 0.2s cubic-bezier(.22,.68,0,1.2) forwards;
    }
    @keyframes heroTextIn {
        from { opacity:0; transform: translateY(16px); }
        to   { opacity:1; transform: translateY(0); }
    }
    .recruit-hero p {
        font-size: 1rem;
        color: rgba(255,255,255,0.82);
        text-shadow: 0 1px 6px rgba(0,0,0,0.55);
        letter-spacing: 0.3px;
        margin: 0;
        opacity: 0;
        animation: heroTextIn 0.8s 0.4s cubic-bezier(.22,.68,0,1.2) forwards;
    }

    /* 分割线装饰 */
    .hero-divider {
        display: flex;
        align-items: center;
        gap: 14px;
        justify-content: center;
        margin: 22px 0 0;
        opacity: 0;
        animation: heroTextIn 0.8s 0.55s ease forwards;
    }
    .hero-divider-line {
        height: 1px;
        width: 80px;
        background: linear-gradient(90deg, transparent, rgba(255,193,7,0.55), transparent);
    }
    .hero-divider-dot {
        width: 6px; height: 6px;
        border-radius: 50%;
        background: rgba(255,193,7,0.7);
        box-shadow: 0 0 8px rgba(255,193,7,0.5);
    }

    /* ========== 统计 Badge 行 ========== */
    .stats-bar {
        display: flex;
        justify-content: center;
        gap: 20px;
        margin: 24px 0 32px;
        flex-wrap: wrap;
        opacity: 0;
        animation: heroTextIn 0.7s 0.7s ease forwards;
    }
    .stat-chip {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 7px 18px;
        border-radius: 100px;
        background: rgba(255,255,255,0.08);
        border: 1px solid rgba(255,255,255,0.14);
        backdrop-filter: blur(10px);
        font-size: 0.82rem;
        color: rgba(255,255,255,0.9);
        text-shadow: 0 1px 4px rgba(0,0,0,0.4);
        font-weight: 500;
        transition: all 0.25s ease;
    }
    .stat-chip:hover {
        background: rgba(255,193,7,0.15);
        border-color: rgba(255,193,7,0.4);
        transform: translateY(-2px);
    }
    .stat-chip i { color: #ffc107; }

    /* ========== 卡片网格 ========== */
    .recruit-grid {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 22px;
        margin-bottom: 40px;
    }
    @media (max-width: 991px) {
        .recruit-grid { grid-template-columns: repeat(2, 1fr); }
    }
    @media (max-width: 575px) {
        .recruit-grid { grid-template-columns: 1fr; }
        .recruit-hero h1 { font-size: 1.8rem; }
    }

    /* ========== 招新卡片 ========== */
    .recruit-card {
        position: relative;
        background: rgba(255,255,255,0.07);
        backdrop-filter: blur(18px) saturate(1.4);
        -webkit-backdrop-filter: blur(18px) saturate(1.4);
        border: 1px solid rgba(255,255,255,0.13);
        border-radius: 20px;
        padding: 0;
        overflow: hidden;
        opacity: 0;
        transition: transform 0.35s cubic-bezier(.22,.68,0,1.2),
                    box-shadow 0.35s ease,
                    border-color 0.35s ease,
                    background 0.35s ease;
        cursor: pointer;
    }
    /* 卡片入场：错落延迟 */
    .recruit-card:nth-child(1)  { animation: cardRise 0.7s 0.15s cubic-bezier(.22,.68,0,1.2) forwards; }
    .recruit-card:nth-child(2)  { animation: cardRise 0.7s 0.25s cubic-bezier(.22,.68,0,1.2) forwards; }
    .recruit-card:nth-child(3)  { animation: cardRise 0.7s 0.35s cubic-bezier(.22,.68,0,1.2) forwards; }
    .recruit-card:nth-child(4)  { animation: cardRise 0.7s 0.45s cubic-bezier(.22,.68,0,1.2) forwards; }
    .recruit-card:nth-child(5)  { animation: cardRise 0.7s 0.55s cubic-bezier(.22,.68,0,1.2) forwards; }
    .recruit-card:nth-child(6)  { animation: cardRise 0.7s 0.65s cubic-bezier(.22,.68,0,1.2) forwards; }
    .recruit-card:nth-child(n+7){ animation: cardRise 0.7s 0.75s cubic-bezier(.22,.68,0,1.2) forwards; }

    @keyframes cardRise {
        from { opacity:0; transform: translateY(40px) scale(0.93); }
        to   { opacity:1; transform: translateY(0) scale(1); }
    }

    /* 卡片顶部彩色条 */
    .card-accent-bar {
        height: 4px;
        background: linear-gradient(90deg, #ffc107 0%, #ff8c42 50%, #ffd700 100%);
        border-radius: 20px 20px 0 0;
        position: relative;
        overflow: hidden;
    }
    .card-accent-bar::after {
        content: '';
        position: absolute;
        top: 0; left: -100%;
        width: 60%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255,255,255,0.6), transparent);
        animation: shimmer 2.5s 1s ease-in-out infinite;
    }
    @keyframes shimmer {
        0%   { left: -100%; }
        100% { left: 200%; }
    }

    .card-body-inner {
        padding: 20px 22px 22px;
    }

    /* 顶部分类 + 截止日期行 */
    .card-meta-row {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 14px;
    }
    .badge-category {
        display: inline-flex;
        align-items: center;
        gap: 4px;
        padding: 4px 12px;
        border-radius: 100px;
        background: rgba(255,193,7,0.22);
        border: 1px solid rgba(255,193,7,0.45);
        color: #ffe066;
        font-size: 0.75rem;
        font-weight: 700;
        letter-spacing: 0.5px;
        text-shadow: 0 1px 4px rgba(0,0,0,0.5);
    }
    .deadline-badge {
        display: inline-flex;
        align-items: center;
        gap: 5px;
        padding: 4px 10px;
        border-radius: 100px;
        background: rgba(255,255,255,0.07);
        border: 1px solid rgba(255,255,255,0.12);
        font-size: 0.73rem;
        color: rgba(255,255,255,0.78);
        text-shadow: 0 1px 3px rgba(0,0,0,0.5);
        font-weight: 500;
    }
    .deadline-badge i { color: #ff8c42; font-size: 0.7rem; }

    /* 卡片标题 */
    .card-title-text {
        font-size: 1.05rem;
        font-weight: 800;
        color: #fff;
        text-shadow: 0 2px 10px rgba(0,0,0,0.6);
        margin-bottom: 5px;
        line-height: 1.4;
        letter-spacing: -0.2px;
    }

    /* 组织名 */
    .card-org-name {
        font-size: 0.82rem;
        color: rgba(255,193,7,0.9);
        font-weight: 600;
        text-shadow: 0 1px 5px rgba(0,0,0,0.5);
        margin-bottom: 10px;
        display: flex;
        align-items: center;
        gap: 5px;
    }
    .card-org-name i { opacity: 0.8; }

    /* 内容摘要 */
    .card-excerpt {
        font-size: 0.83rem;
        color: rgba(255,255,255,0.78);
        text-shadow: 0 1px 5px rgba(0,0,0,0.5);
        line-height: 1.65;
        height: 54px;
        overflow: hidden;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        margin-bottom: 16px;
        border-left: 2px solid rgba(255,193,7,0.3);
        padding-left: 10px;
    }

    /* 分隔线 */
    .card-divider {
        height: 1px;
        background: linear-gradient(90deg, rgba(255,255,255,0.12) 0%, transparent 100%);
        margin-bottom: 14px;
    }

    /* 底部：名额进度 + 按钮 */
    .card-footer-row {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 10px;
    }
    .quota-info {
        flex: 1;
        min-width: 0;
    }
    .quota-label {
        font-size: 0.72rem;
        color: rgba(255,255,255,0.65);
        text-shadow: 0 1px 3px rgba(0,0,0,0.4);
        margin-bottom: 5px;
        display: flex;
        align-items: center;
        gap: 5px;
    }
    .quota-label i { color: rgba(255,193,7,0.7); }
    .quota-bar-bg {
        height: 4px;
        border-radius: 4px;
        background: rgba(255,255,255,0.1);
        overflow: hidden;
    }
    .quota-bar-fill {
        height: 100%;
        border-radius: 4px;
        background: linear-gradient(90deg, #ffc107, #ff8c42);
        min-width: 8px;
        transition: width 1s cubic-bezier(.22,.68,0,1.2);
    }

    /* 报名按钮 */
    .btn-apply {
        display: inline-flex;
        align-items: center;
        gap: 5px;
        padding: 8px 18px;
        border-radius: 100px;
        background: linear-gradient(135deg, #ffc107 0%, #ffad00 100%);
        color: #1a1200;
        font-size: 0.82rem;
        font-weight: 800;
        border: none;
        text-decoration: none;
        letter-spacing: 0.3px;
        transition: all 0.25s cubic-bezier(.22,.68,0,1.2);
        position: relative;
        overflow: hidden;
        box-shadow: 0 4px 14px rgba(255,193,7,0.3);
        white-space: nowrap;
        flex-shrink: 0;
    }
    .btn-apply::before {
        content: '';
        position: absolute;
        top: 0; left: -100%;
        width: 70%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255,255,255,0.35), transparent);
        transition: left 0.4s ease;
    }
    .btn-apply:hover {
        transform: translateY(-2px) scale(1.06);
        box-shadow: 0 8px 22px rgba(255,193,7,0.45);
        color: #0d0900;
    }
    .btn-apply:hover::before {
        left: 150%;
    }
    .btn-apply i { font-size: 0.75rem; }

    /* ========== 悬停光晕效果 ========== */
    .recruit-card::before {
        content: '';
        position: absolute;
        inset: 0;
        border-radius: 20px;
        background: radial-gradient(circle at var(--mx, 50%) var(--my, 50%), rgba(255,193,7,0.10) 0%, transparent 65%);
        opacity: 0;
        transition: opacity 0.35s ease;
        pointer-events: none;
        z-index: 0;
    }
    .recruit-card:hover::before { opacity: 1; }
    .recruit-card:hover {
        transform: translateY(-8px) scale(1.015);
        border-color: rgba(255,193,7,0.28);
        background: rgba(255,255,255,0.11);
        box-shadow: 0 20px 48px rgba(0,0,0,0.32), 0 0 0 1px rgba(255,193,7,0.15);
    }
    .card-body-inner { position: relative; z-index: 1; }
    .card-accent-bar  { position: relative; z-index: 1; }

    /* ========== 空状态 ========== */
    .empty-state {
        text-align: center;
        padding: 80px 20px;
        opacity: 0;
        animation: pageFadeUp 0.8s 0.3s ease forwards;
    }
    .empty-icon-wrap {
        width: 90px; height: 90px;
        border-radius: 50%;
        background: rgba(255,193,7,0.1);
        border: 2px dashed rgba(255,193,7,0.3);
        display: inline-flex;
        align-items: center;
        justify-content: center;
        margin-bottom: 20px;
        animation: emptyRotate 6s linear infinite;
    }
    @keyframes emptyRotate {
        from { transform: rotate(0deg); }
        to   { transform: rotate(360deg); }
    }
    .empty-icon-wrap i {
        font-size: 2.4rem;
        color: rgba(255,193,7,0.6);
        animation: emptyRotate 6s linear infinite reverse;
    }
    .empty-state h5 {
        color: rgba(255,255,255,0.85);
        font-weight: 700;
        text-shadow: 0 1px 6px rgba(0,0,0,0.5);
        margin-bottom: 8px;
    }
    .empty-state p {
        color: rgba(255,255,255,0.55);
        text-shadow: 0 1px 4px rgba(0,0,0,0.4);
        font-size: 0.9rem;
    }

    /* ========== 浮动粒子装饰 ========== */
    .particles-bg {
        position: fixed;
        inset: 0;
        pointer-events: none;
        z-index: 0;
        overflow: hidden;
    }
    .particle {
        position: absolute;
        width: 3px; height: 3px;
        border-radius: 50%;
        background: rgba(255,193,7,0.4);
        animation: floatParticle linear infinite;
    }
    @keyframes floatParticle {
        0%   { transform: translateY(100vh) scale(0); opacity: 0; }
        10%  { opacity: 1; }
        90%  { opacity: 0.6; }
        100% { transform: translateY(-10vh) scale(1); opacity: 0; }
    }

    /* ========== 滚动入场 (Intersection Observer) ========== */
    .reveal-item {
        opacity: 0;
        transform: translateY(24px);
        transition: opacity 0.6s ease, transform 0.6s cubic-bezier(.22,.68,0,1.2);
    }
    .reveal-item.visible {
        opacity: 1;
        transform: translateY(0);
    }
</style>

<%-- 浮动粒子背景 --%>
<div class="particles-bg" id="particlesBg" aria-hidden="true"></div>

<div class="container recruit-page my-0 py-0">

    <%-- ===== HERO 区域 ===== --%>
    <div class="recruit-hero">
        <div class="recruit-hero-icon">
            <i class="bi bi-megaphone-fill"></i>
        </div>
        <h1>招新广场</h1>
        <p>各组织招新信息汇总 · 找到适合你的舞台</p>
        <div class="hero-divider">
            <div class="hero-divider-line"></div>
            <div class="hero-divider-dot"></div>
            <div class="hero-divider-dot" style="width:4px;height:4px;opacity:.5;"></div>
            <div class="hero-divider-dot" style="width:3px;height:3px;opacity:.3;"></div>
            <div class="hero-divider-line"></div>
        </div>
    </div>

    <%-- ===== 统计数据行 ===== --%>
    <div class="stats-bar" id="statsBar">
        <span class="stat-chip"><i class="bi bi-lightning-charge-fill"></i> 招新进行中</span>
        <span class="stat-chip" id="chipCount"><i class="bi bi-grid-fill"></i> <span id="totalCount">--</span> 个组织</span>
        <span class="stat-chip"><i class="bi bi-calendar2-check"></i> 实时更新</span>
    </div>

    <%-- ===== 卡片网格 ===== --%>
    <div class="recruit-grid" id="recruitGrid">
        <asp:Repeater ID="rptRecruits" runat="server">
            <ItemTemplate>
                <div class="recruit-card" data-app='<%# Eval("AppCount") %>' data-quota='<%# Eval("Quota") %>'>
                    <div class="card-accent-bar"></div>
                    <div class="card-body-inner">
                        <div class="card-meta-row">
                            <span class="badge-category">
                                <i class="bi bi-tag-fill" style="font-size:.65rem;"></i>
                                <%# Eval("CategoryName") %>
                            </span>
                            <span class="deadline-badge">
                                <i class="bi bi-clock-fill"></i>
                                截止 <%# Convert.ToDateTime(Eval("EndDate")).ToString("MM/dd") %>
                            </span>
                        </div>

                        <div class="card-title-text"><%# Eval("Title") %></div>
                        <div class="card-org-name">
                            <i class="bi bi-building"></i>
                            <%# Eval("OrgName") %>
                        </div>
                        <div class="card-excerpt">
                            <%# OrgManage.APP_Code.Utils.CutString(Eval("Content").ToString(), 60) %>
                        </div>

                        <div class="card-divider"></div>

                        <div class="card-footer-row">
                            <div class="quota-info">
                                <div class="quota-label">
                                    <i class="bi bi-people-fill"></i>
                                    已报名 <strong style="color:#ffe066;"><%# Eval("AppCount") %></strong>
                                    &nbsp;/&nbsp;名额
                                    <strong style="color:#ffe066;"><%# Convert.ToInt32(Eval("Quota")) == 0 ? "不限" : Eval("Quota").ToString() %></strong>
                                </div>
                                <div class="quota-bar-bg">
                                    <div class="quota-bar-fill"
                                         style="width: <%# GetQuotaPercent(Eval("AppCount"), Eval("Quota")) %>%;"></div>
                                </div>
                            </div>
                            <a href='RecruitDetail.aspx?id=<%# Eval("RecruitID") %>'
                               class="btn-apply">
                                立即报名 <i class="bi bi-arrow-right-short"></i>
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
            <div class="empty-icon-wrap">
                <i class="bi bi-megaphone"></i>
            </div>
            <h5>暂无进行中的招新活动</h5>
            <p>请稍后再来查看，或关注各组织动态</p>
        </div>
    </asp:Panel>

</div>

<script>
(function() {

    /* ── 1. 浮动粒子生成 ── */
    var bg = document.getElementById('particlesBg');
    if (bg) {
        for (var i = 0; i < 18; i++) {
            var p = document.createElement('div');
            p.className = 'particle';
            var size = (Math.random() * 3 + 1.5).toFixed(1);
            p.style.cssText = [
                'left:' + (Math.random()*100).toFixed(1) + '%',
                'width:' + size + 'px',
                'height:' + size + 'px',
                'opacity:' + (Math.random()*0.5+0.15).toFixed(2),
                'animation-duration:' + (Math.random()*12+8).toFixed(1) + 's',
                'animation-delay:' + (Math.random()*10).toFixed(1) + 's'
            ].join(';');
            bg.appendChild(p);
        }
    }

    /* ── 2. 统计卡片数量 ── */
    window.addEventListener('DOMContentLoaded', function() {
        var grid = document.getElementById('recruitGrid');
        var cards = grid ? grid.querySelectorAll('.recruit-card') : [];
        var el = document.getElementById('totalCount');
        if (el) el.textContent = cards.length;

        /* ── 3. 鼠标跟踪光晕 ── */
        cards.forEach(function(card) {
            card.addEventListener('mousemove', function(e) {
                var r = card.getBoundingClientRect();
                var mx = ((e.clientX - r.left) / r.width * 100).toFixed(1) + '%';
                var my = ((e.clientY - r.top)  / r.height * 100).toFixed(1) + '%';
                card.style.setProperty('--mx', mx);
                card.style.setProperty('--my', my);
            });
        });

        /* ── 4. 配额进度条动态宽度（CSS过渡） ── */
        setTimeout(function() {
            document.querySelectorAll('.quota-bar-fill').forEach(function(bar) {
                var w = bar.style.width;
                bar.style.width = '0%';
                setTimeout(function() { bar.style.width = w; }, 200);
            });
        }, 300);

        /* ── 5. Intersection Observer 滚动淡入 ── */
        if ('IntersectionObserver' in window) {
            var io = new IntersectionObserver(function(entries) {
                entries.forEach(function(e) {
                    if (e.isIntersecting) {
                        e.target.classList.add('visible');
                        io.unobserve(e.target);
                    }
                });
            }, { threshold: 0.12 });
            document.querySelectorAll('.reveal-item').forEach(function(el) {
                io.observe(el);
            });
        }
    });
})();
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
