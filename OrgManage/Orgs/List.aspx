<%@ Page Title="组织大厅 - 高校组织综合线上管理平台" Language="C#" MasterPageFile="../Site.master"
         AutoEventWireup="true" CodeFile="List.aspx.cs" Inherits="OrgManage.Orgs_List" %>

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
        background: linear-gradient(135deg, rgba(25,10,35,0.82) 0%, rgba(45,15,35,0.70) 55%, rgba(20,10,30,0.85) 100%);
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

    /* ========== 鼠标跟踪光晕 ========== */
    body::after {
        content: '';
        position: fixed;
        top: calc(var(--my, 50vh) - 150px);
        left: calc(var(--mx, 50vw) - 150px);
        width: 300px;
        height: 300px;
        border-radius: 50%;
        background: radial-gradient(circle, rgba(255,139,167,0.08) 0%, transparent 70%);
        pointer-events: none;
        z-index: 0;
        transition: top 0.15s ease-out, left 0.15s ease-out;
    }

    /* ========== 页面整体入场 ========== */
    @keyframes pageSlideIn {
        from { opacity: 0; transform: translateY(30px) scale(0.97); }
        to   { opacity: 1; transform: translateY(0) scale(1); }
    }
    .org-page {
        animation: pageSlideIn 0.9s cubic-bezier(.22,.68,0,1.2) forwards;
    }

    /* ========== Hero 区域 ========== */
    .org-hero {
        position: relative;
        padding: 52px 0 36px;
        text-align: center;
        overflow: hidden;
    }
    /* 双层脉冲光圈 */
    .org-hero::before {
        content: '';
        position: absolute;
        top: -100px; left: 50%;
        transform: translateX(-50%);
        width: 600px; height: 600px;
        border-radius: 50%;
        background: radial-gradient(circle, rgba(255,139,167,0.10) 0%, transparent 65%);
        pointer-events: none;
        animation: doublePulse 5s ease-in-out infinite;
    }
    .org-hero::after {
        content: '';
        position: absolute;
        top: -60px; left: 50%;
        transform: translateX(-50%);
        width: 400px; height: 400px;
        border-radius: 50%;
        background: radial-gradient(circle, rgba(233,69,96,0.08) 0%, transparent 70%);
        pointer-events: none;
        animation: doublePulse 5s ease-in-out infinite 0.5s;
    }
    @keyframes doublePulse {
        0%,100% { opacity:0.4; transform: translateX(-50%) scale(1); }
        50%      { opacity:1;   transform: translateX(-50%) scale(1.2); }
    }

    /* Hero 主图标 - 浮动效果 */
    .hero-icon-wrap {
        position: relative;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: 80px; height: 80px;
        border-radius: 24px;
        background: rgba(255,139,167,0.12);
        border: 1.5px solid rgba(255,139,167,0.30);
        margin-bottom: 22px;
        opacity: 0;
        animation: iconFloat 1.2s cubic-bezier(.22,.68,0,1.2) 0.15s forwards, iconBreathe 3s ease-in-out infinite 1.2s;
    }
    @keyframes iconFloat {
        0%  { opacity:0; transform: scale(0.2) rotate(-15deg) translateY(-30px); }
        60% { opacity:1; transform: scale(1.1) rotate(3deg) translateY(0); }
        80% { transform: scale(0.95) rotate(-1deg); }
        100%{ opacity:1; transform: scale(1) rotate(0); }
    }
    @keyframes iconBreathe {
        0%,100% { box-shadow: 0 0 20px rgba(255,139,167,0.2), 0 0 40px rgba(255,139,167,0.1); }
        50%      { box-shadow: 0 0 35px rgba(255,139,167,0.35), 0 0 60px rgba(255,139,167,0.15); }
    }
    /* 旋转光环 - 双层 */
    .hero-icon-wrap::before {
        content: '';
        position: absolute;
        inset: -10px;
        border-radius: 32px;
        border: 2px dashed rgba(255,139,167,0.25);
        animation: ringRotate 10s linear infinite;
    }
    .hero-icon-wrap::after {
        content: '';
        position: absolute;
        inset: -18px;
        border-radius: 38px;
        border: 1px dotted rgba(233,69,96,0.15);
        animation: ringRotate 15s linear infinite reverse;
    }
    @keyframes ringRotate {
        from { transform: rotate(0deg); }
        to   { transform: rotate(360deg); }
    }
    .hero-icon-wrap i {
        font-size: 2.2rem;
        color: #ff8ba7;
        filter: drop-shadow(0 3px 12px rgba(255,139,167,0.6));
        animation: iconPulse 2s ease-in-out infinite;
    }
    @keyframes iconPulse {
        0%,100% { transform: scale(1); }
        50%      { transform: scale(1.08); }
    }

    /* 标题打字机效果 */
    .hero-title {
        font-size: 2.6rem;
        font-weight: 800;
        background: linear-gradient(135deg, #ff8ba7 0%, #ffc4d6 50%, #ff8ba7 100%);
        background-size: 200% auto;
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        animation: titleShimmer 3s linear infinite, titleFadeIn 1s ease 0.4s both;
        text-shadow: none;
    }
    @keyframes titleShimmer {
        to { background-position: 200% center; }
    }
    @keyframes titleFadeIn {
        from { opacity: 0; letter-spacing: 0.3em; }
        to   { opacity: 1; letter-spacing: 0.02em; }
    }

    .hero-subtitle {
        color: rgba(255,255,255,0.8) !important;
        font-size: 1.1rem;
        animation: fadeSlideUp 0.8s ease 0.6s both;
    }
    @keyframes fadeSlideUp {
        from { opacity: 0; transform: translateY(15px); }
        to   { opacity: 1; transform: translateY(0); }
    }

    /* 装饰分隔线 */
    .hero-divider {
        width: 80px;
        height: 3px;
        background: linear-gradient(90deg, transparent, #ff8ba7, transparent);
        margin: 18px auto;
        border-radius: 2px;
        animation: dividerExpand 1s ease 0.8s both;
    }
    @keyframes dividerExpand {
        from { width: 0; opacity: 0; }
        to   { width: 80px; opacity: 1; }
    }

    /* 统计芯片栏 */
    .stats-bar {
        display: flex;
        justify-content: center;
        gap: 20px;
        margin-top: 24px;
        flex-wrap: wrap;
        animation: statsSlideIn 0.8s ease 1s both;
    }
    @keyframes statsSlideIn {
        from { opacity: 0; transform: translateY(20px); }
        to   { opacity: 1; transform: translateY(0); }
    }
    .stat-chip {
        background: rgba(255,139,167,0.1);
        border: 1px solid rgba(255,139,167,0.25);
        border-radius: 50px;
        padding: 8px 20px;
        display: flex;
        align-items: center;
        gap: 8px;
        transition: all 0.3s ease;
        cursor: default;
    }
    .stat-chip:hover {
        background: rgba(255,139,167,0.2);
        transform: translateY(-3px);
        box-shadow: 0 5px 15px rgba(255,139,167,0.2);
    }
    .stat-chip i { color: #ff8ba7; font-size: 1.1rem; }
    .stat-chip span { color: rgba(255,255,255,0.9); font-weight: 500; }
    .stat-chip strong { color: #fff; font-weight: 700; }

    /* 申请创建组织按钮 */
    .apply-org-btn {
        background: linear-gradient(135deg, #e94560 0%, #ff8ba7 100%);
        border: none;
        border-radius: 50px;
        padding: 10px 24px;
        color: #fff;
        font-weight: 600;
        font-size: 0.9rem;
        display: inline-flex;
        align-items: center;
        transition: all 0.4s ease;
        box-shadow: 0 4px 15px rgba(233,69,96,0.3);
        text-decoration: none;
        animation: fadeSlideUp 0.8s ease 0.7s both;
    }
    .apply-org-btn:hover {
        transform: translateY(-3px) scale(1.05);
        box-shadow: 0 8px 25px rgba(233,69,96,0.4);
        color: #fff;
    }

    /* ========== Hero 标题区域（居中布局） ========== */
    .hero-section {
        text-align: center;
        padding: 52px 0 30px;
        position: relative;
    }
    .hero-section .hero-icon-wrap {
        margin-bottom: 18px;
    }
    .hero-section .hero-title-wrap {
        display: flex;
        flex-direction: column;
        align-items: center;
    }

    /* ========== 搜索卡片 ========== */
    .search-glass-card {
        background: rgba(0,0,0,0.3) !important;
        backdrop-filter: blur(20px);
        -webkit-backdrop-filter: blur(20px);
        border: 1px solid rgba(255,255,255,0.15) !important;
        border-radius: 20px !important;
        padding: 24px !important;
        margin-bottom: 28px;
        box-shadow: 0 8px 32px rgba(0,0,0,0.2);
        opacity: 0;
        animation: cardSlideUp 0.7s cubic-bezier(.22,.68,0,1.2) 0.3s forwards;
        transition: all 0.4s ease;
    }
    .search-glass-card:hover {
        border-color: rgba(255,139,167,0.4) !important;
        box-shadow: 0 12px 40px rgba(255,139,167,0.15);
    }
    @keyframes cardSlideUp {
        from { opacity: 0; transform: translateY(25px) scale(0.98); }
        to   { opacity: 1; transform: translateY(0) scale(1); }
    }

    /* 胶囊搜索栏 */
    .search-pill {
        background: rgba(255,255,255,0.08);
        border: 1.5px solid rgba(255,255,255,0.15);
        border-radius: 50px;
        padding: 6px 6px 6px 20px;
        display: flex;
        align-items: center;
        gap: 10px;
        transition: all 0.4s ease;
    }
    .search-pill:focus-within {
        background: rgba(255,255,255,0.12);
        border-color: rgba(255,139,167,0.5);
        box-shadow: 0 0 0 3px rgba(255,139,167,0.15), 0 0 20px rgba(255,139,167,0.1);
    }
    .search-pill i { color: rgba(255,255,255,0.6); font-size: 1.1rem; }
    .search-pill input {
        background: transparent !important;
        border: none !important;
        color: #fff !important;
        font-size: 0.95rem;
        flex: 1;
        padding: 4px 0;
        outline: none;
        box-shadow: none !important;
    }
    .search-pill input::placeholder { color: rgba(255,255,255,0.5) !important; }

    /* 搜索按钮 */
    .search-btn {
        background: linear-gradient(135deg, #e94560 0%, #ff8ba7 100%);
        border: none;
        border-radius: 50px;
        padding: 10px 28px;
        color: #fff;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 6px;
        transition: all 0.4s ease;
        cursor: pointer;
    }
    .search-btn:hover {
        transform: scale(1.05);
        box-shadow: 0 5px 20px rgba(233,69,96,0.4);
    }
    .search-btn:active { transform: scale(0.97); }

    /* 下拉框样式 */
    .filter-select {
        background: rgba(255,255,255,0.08) !important;
        border: 1.5px solid rgba(255,255,255,0.15) !important;
        border-radius: 12px !important;
        color: #fff !important;
        padding: 10px 16px;
        font-size: 0.95rem;
        transition: all 0.3s ease;
        cursor: pointer;
    }
    .filter-select:focus {
        border-color: rgba(255,139,167,0.5) !important;
        box-shadow: 0 0 0 3px rgba(255,139,167,0.15) !important;
        outline: none;
    }
    .filter-select option { background: #1a1020 !important; color: #fff; }

    /* ========== 分类标签云 ========== */
    .category-cloud {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
        margin-bottom: 24px;
        padding: 20px;
        background: rgba(0,0,0,0.2);
        border-radius: 16px;
        border: 1px solid rgba(255,255,255,0.08);
        animation: cloudFadeIn 0.8s ease 0.5s both;
    }
    @keyframes cloudFadeIn {
        from { opacity: 0; transform: scale(0.95); }
        to   { opacity: 1; transform: scale(1); }
    }
    .category-tag {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        background: rgba(255,139,167,0.08);
        border: 1px solid rgba(255,139,167,0.2);
        border-radius: 50px;
        padding: 8px 18px;
        color: rgba(255,255,255,0.85);
        text-decoration: none;
        font-size: 0.88rem;
        transition: all 0.4s cubic-bezier(.22,.68,0,1.2);
        opacity: 0;
        animation: tagPopIn 0.5s cubic-bezier(.22,.68,0,1.2) forwards;
    }
    .category-tag:nth-of-type(1) { animation-delay: 0.6s; }
    .category-tag:nth-of-type(2) { animation-delay: 0.65s; }
    .category-tag:nth-of-type(3) { animation-delay: 0.7s; }
    .category-tag:nth-of-type(4) { animation-delay: 0.75s; }
    .category-tag:nth-of-type(5) { animation-delay: 0.8s; }
    .category-tag:nth-of-type(6) { animation-delay: 0.85s; }
    .category-tag:nth-of-type(7) { animation-delay: 0.9s; }
    .category-tag:nth-of-type(8) { animation-delay: 0.95s; }
    .category-tag:nth-of-type(9) { animation-delay: 1.0s; }
    .category-tag:nth-of-type(10) { animation-delay: 1.05s; }
    @keyframes tagPopIn {
        from { opacity: 0; transform: scale(0.5) translateY(10px); }
        to   { opacity: 1; transform: scale(1) translateY(0); }
    }
    .category-tag:hover {
        background: rgba(255,139,167,0.2);
        border-color: rgba(255,139,167,0.5);
        color: #fff;
        transform: translateY(-3px) scale(1.05);
        box-shadow: 0 5px 15px rgba(255,139,167,0.25);
    }
    .category-tag.active {
        background: linear-gradient(135deg, #e94560 0%, #ff8ba7 100%);
        border-color: transparent;
        color: #fff;
        font-weight: 600;
    }
    .category-tag i { font-size: 0.95rem; }

    /* 结果计数 */
    .result-count {
        color: rgba(255,255,255,0.7);
        font-size: 0.9rem;
        margin-bottom: 20px;
        animation: fadeIn 0.6s ease 1s both;
    }
    .result-count strong { color: #ff8ba7; font-weight: 700; }
    @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }

    /* ========== 组织卡片网格 ========== */
    .org-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
        gap: 24px;
        margin-bottom: 30px;
    }

    /* 单个组织卡片 */
    .org-card {
        background: rgba(0,0,0,0.35) !important;
        backdrop-filter: blur(16px);
        -webkit-backdrop-filter: blur(16px);
        border: 1px solid rgba(255,255,255,0.12) !important;
        border-radius: 20px !important;
        overflow: hidden;
        cursor: pointer;
        transition: all 0.5s cubic-bezier(.22,.68,0,1.2);
        opacity: 0;
        animation: orgCardRise 0.7s cubic-bezier(.22,.68,0,1.2) forwards;
        position: relative;
    }
    /* 入场延迟 - 瀑布流效果 */
    .org-card:nth-child(1) { animation-delay: 0.5s; }
    .org-card:nth-child(2) { animation-delay: 0.6s; }
    .org-card:nth-child(3) { animation-delay: 0.7s; }
    .org-card:nth-child(4) { animation-delay: 0.8s; }
    .org-card:nth-child(5) { animation-delay: 0.55s; }
    .org-card:nth-child(6) { animation-delay: 0.65s; }
    .org-card:nth-child(7) { animation-delay: 0.75s; }
    .org-card:nth-child(8) { animation-delay: 0.85s; }
    @keyframes orgCardRise {
        from { opacity: 0; transform: translateY(40px) scale(0.9) rotateX(15deg); }
        to   { opacity: 1; transform: translateY(0) scale(1) rotateX(0); }
    }

    /* 卡片顶部装饰条 */
    .org-card::before {
        content: '';
        position: absolute;
        top: 0; left: 0; right: 0;
        height: 4px;
        background: linear-gradient(90deg, #e94560 0%, #ff8ba7 50%, #ffc4d6 100%);
        background-size: 200% auto;
        animation: shimmer 3s linear infinite;
        z-index: 1;
    }
    @keyframes shimmer {
        to { background-position: 200% center; }
    }

  

    /* 卡片悬停效果 */
    .org-card:hover {
        transform: translateY(-10px) scale(1.02);
        border-color: rgba(255,139,167,0.4) !important;
        box-shadow: 0 20px 50px rgba(0,0,0,0.4), 0 0 30px rgba(255,139,167,0.15);
    }

    /* Logo 区域 */
    .org-logo-area {
        position: relative;
        height: 160px;
        overflow: hidden;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
    }
    .org-logo-area img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.5s ease;
    }
    .org-card:hover .org-logo-area img { transform: scale(1.1); }

    /* 暂无 logo 文字占位 */
    .no-logo-txt {
        width: 100%;
        height: 100%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 14px;
        letter-spacing: 2px;
        color: rgba(255,255,255,0.75);
    }

    /* 悬浮层遮罩 */
    .org-overlay {
        position: absolute;
        bottom: 0; left: 0; right: 0;
        background: linear-gradient(to top, rgba(0,0,0,0.7) 0%, transparent 100%);
        padding: 30px 15px 15px;
        transition: all 0.4s ease;
    }

    /* 分类标签 */
    .org-category-badge {
        display: inline-flex;
        align-items: center;
        gap: 4px;
        background: linear-gradient(135deg, #e94560 0%, #ff8ba7 100%);
        border-radius: 50px;
        padding: 4px 12px;
        font-size: 0.75rem;
        font-weight: 600;
        color: #fff;
        box-shadow: 0 2px 8px rgba(233,69,96,0.4);
        transition: all 0.3s ease;
    }
    .org-card:hover .org-category-badge {
        transform: scale(1.08);
        box-shadow: 0 4px 12px rgba(233,69,96,0.5);
    }

    /* 卡片主体 */
    .org-card-body {
        padding: 18px;
        position: relative;
    }

    /* 组织名称 */
    .org-name {
        font-size: 1.15rem;
        font-weight: 700;
        color: #fff !important;
        margin-bottom: 8px;
        transition: all 0.3s ease;
        text-shadow: 0 1px 3px rgba(0,0,0,0.3);
    }
    .org-card:hover .org-name {
        color: #ff8ba7 !important;
        text-shadow: 0 0 10px rgba(255,139,167,0.4);
    }

    /* 组织描述 */
    .org-desc {
        font-size: 0.88rem;
        color: rgba(255,255,255,0.7) !important;
        line-height: 1.5;
        margin-bottom: 14px;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
        text-shadow: 0 1px 2px rgba(0,0,0,0.2);
    }

    /* 最新公告提示 */
    .org-latest-ann {
        display: flex;
        align-items: center;
        gap: 6px;
        margin-top: 12px;
        padding: 8px 12px;
        background: rgba(255,193,7,0.1);
        border: 1px solid rgba(255,193,7,0.25);
        border-radius: 10px;
        font-size: 0.82rem;
        color: rgba(255,255,255,0.85);
        overflow: hidden;
        transition: all 0.3s ease;
    }
    .org-card:hover .org-latest-ann {
        background: rgba(255,193,7,0.18);
        border-color: rgba(255,193,7,0.45);
    }
    .org-latest-ann i { color: #ffc107; flex-shrink: 0; }
    .org-latest-ann span {
        overflow: hidden;
        white-space: nowrap;
        text-overflow: ellipsis;
    }

    /* 成员数量环形进度 */
    .org-stats-row {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 14px;
    }
    .member-ring {
        position: relative;
        width: 48px;
        height: 48px;
    }
    .member-ring svg {
        transform: rotate(-90deg);
        width: 48px;
        height: 48px;
    }
    .member-ring-bg {
        fill: none;
        stroke: rgba(255,255,255,0.1);
        stroke-width: 4;
    }
    .member-ring-fill {
        fill: none;
        stroke: url(#memberGradient);
        stroke-width: 4;
        stroke-linecap: round;
        stroke-dasharray: 126;
        stroke-dashoffset: 126;
        transition: stroke-dashoffset 1.5s ease-out;
    }
    .org-card:hover .member-ring-fill { stroke-dashoffset: calc(126 - (126 * var(--member-percent, 0.5))); }
    .member-ring-text {
        position: absolute;
        inset: 0;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 0.7rem;
        font-weight: 700;
        color: #fff;
    }
    .member-ring i {
        position: absolute;
        top: -2px; right: -2px;
        font-size: 0.7rem;
        color: #ff8ba7;
        animation: memberPulse 2s ease-in-out infinite;
    }
    @keyframes memberPulse {
        0%,100% { transform: scale(1); opacity: 1; }
        50%      { transform: scale(1.2); opacity: 0.7; }
    }

    /* 热门/新组织标签 */
    .org-hot-tag {
        position: absolute;
        top: 12px; right: 12px;
        background: linear-gradient(135deg, #ff6b6b 0%, #ffa500 100%);
        border-radius: 6px;
        padding: 3px 8px;
        font-size: 0.7rem;
        font-weight: 700;
        color: #fff;
        display: flex;
        align-items: center;
        gap: 3px;
        box-shadow: 0 2px 8px rgba(255,107,107,0.4);
        animation: hotTagPulse 2s ease-in-out infinite;
    }
    .org-new-tag {
        position: absolute;
        top: 12px; right: 12px;
        background: linear-gradient(135deg, #00d2d3 0%, #01a3a4 100%);
        border-radius: 6px;
        padding: 3px 8px;
        font-size: 0.7rem;
        font-weight: 700;
        color: #fff;
        box-shadow: 0 2px 8px rgba(0,210,211,0.4);
        animation: newTagGlow 2s ease-in-out infinite;
    }
    @keyframes hotTagPulse {
        0%,100% { transform: scale(1); }
        50%      { transform: scale(1.05); }
    }
    @keyframes newTagGlow {
        0%,100% { box-shadow: 0 2px 8px rgba(0,210,211,0.4); }
        50%      { box-shadow: 0 2px 15px rgba(0,210,211,0.6); }
    }

    /* 底部操作栏 */
    .org-action-row {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding-top: 12px;
        border-top: 1px solid rgba(255,255,255,0.08);
    }
    .member-count-text {
        display: flex;
        align-items: center;
        gap: 5px;
        font-size: 0.85rem;
        color: rgba(255,255,255,0.7);
    }
    .member-count-text i { color: #ff8ba7; }
    .member-count-text strong { color: #fff; }

    /* 详情按钮 */
    .org-detail-btn {
        background: rgba(255,139,167,0.15);
        border: 1px solid rgba(255,139,167,0.3);
        border-radius: 50px;
        padding: 6px 16px;
        color: #ff8ba7;
        font-size: 0.85rem;
        font-weight: 500;
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: 4px;
        transition: all 0.4s cubic-bezier(.22,.68,0,1.2);
    }
    .org-detail-btn:hover {
        background: linear-gradient(135deg, #e94560 0%, #ff8ba7 100%);
        border-color: transparent;
        color: #fff;
        transform: translateX(3px);
        box-shadow: 0 4px 15px rgba(255,139,167,0.4);
    }
    .org-detail-btn i { transition: transform 0.3s ease; }
    .org-detail-btn:hover i { transform: translateX(3px); }

    /* 卡片展开指示器 */
    .expand-hint {
        position: absolute;
        bottom: 8px; left: 50%;
        transform: translateX(-50%);
        opacity: 0;
        transition: all 0.3s ease;
        color: rgba(255,255,255,0.5);
        font-size: 0.75rem;
        display: flex;
        align-items: center;
        gap: 3px;
    }
    .org-card:hover .expand-hint { opacity: 1; }

    /* 搜索高亮闪烁 */
    @keyframes highlightPulse {
        0%  { box-shadow: 0 0 0 0 rgba(255,139,167,0.6); }
        50% { box-shadow: 0 0 20px 5px rgba(255,139,167,0.4); transform: scale(1.03); }
        100%{ box-shadow: 0 0 0 0 rgba(255,139,167,0); transform: scale(1); }
    }
    .org-card.highlight { animation: highlightPulse 0.6s ease-out; }

    /* 空状态 */
    .empty-state {
        text-align: center;
        padding: 80px 20px;
        animation: emptyFadeIn 0.6s ease;
    }
    @keyframes emptyFadeIn {
        from { opacity: 0; transform: scale(0.9); }
        to   { opacity: 1; transform: scale(1); }
    }
    .empty-icon {
        font-size: 5rem;
        color: rgba(255,139,167,0.4);
        margin-bottom: 20px;
        animation: emptyFloat 3s ease-in-out infinite;
    }
    @keyframes emptyFloat {
        0%,100% { transform: translateY(0) rotate(0); }
        25%      { transform: translateY(-10px) rotate(5deg); }
        75%      { transform: translateY(5px) rotate(-3deg); }
    }
    .empty-title {
        font-size: 1.3rem;
        font-weight: 600;
        color: rgba(255,255,255,0.8);
        margin-bottom: 8px;
    }
    .empty-desc { color: rgba(255,255,255,0.5); }

    /* 滚动淡入 */
    .org-card.scroll-reveal {
        opacity: 0;
        transform: translateY(30px);
        transition: opacity 0.6s ease, transform 0.6s ease;
    }
    .org-card.scroll-reveal.revealed {
        opacity: 1;
        transform: translateY(0);
    }

    /* 浮动粒子背景 */
    .floating-particles {
        position: fixed;
        inset: 0;
        pointer-events: none;
        z-index: 0;
        overflow: hidden;
    }
    .particle {
        position: absolute;
        width: 4px;
        height: 4px;
        background: rgba(255,139,167,0.3);
        border-radius: 50%;
        animation: particleFloat linear infinite;
    }
    @keyframes particleFloat {
        0% { transform: translateY(100vh) rotate(0deg); opacity: 0; }
        10% { opacity: 1; }
        90% { opacity: 1; }
        100%{ transform: translateY(-10vh) rotate(720deg); opacity: 0; }
    }

    /* ========== 响应式 ========== */
    @media (max-width: 768px) {
        .hero-section { padding: 30px 0 20px; }
        .hero-section .hero-icon-wrap { width: 56px !important; height: 56px !important; }
        .hero-section .hero-icon-wrap i { font-size: 1.4rem !important; }
        .hero-title { font-size: 1.8rem; }
        .hero-subtitle { font-size: 0.95rem; }
        .org-grid { grid-template-columns: 1fr; gap: 16px; }
        .search-glass-card { padding: 16px !important; }
        .stats-bar { gap: 12px; }
        .stat-chip { padding: 6px 14px; font-size: 0.85rem; }
    }
</style>

<!-- SVG 渐变定义 -->
<svg style="position:absolute;width:0;height:0;">
    <defs>
        <linearGradient id="memberGradient" x1="0%" y1="0%" x2="100%" y2="0%">
            <stop offset="0%" stop-color="#e94560"/>
            <stop offset="100%" stop-color="#ff8ba7"/>
        </linearGradient>
    </defs>
</svg>



<div class="container org-page">
    <!-- ========== 标题区域（居中布局） ========== -->
    <div class="hero-section">
        <!-- Hero 主图标 -->
        <div class="hero-icon-wrap" style="width:72px;height:72px;">
            <i class="bi bi-grid-3x3-gap-fill" style="font-size:1.8rem;"></i>
        </div>
        
        <!-- 标题和副标题 -->
        <div class="hero-title-wrap">
            <h1 class="hero-title">组织大厅</h1>
            <p class="hero-subtitle mb-0">探索校园精彩，发现你的归属</p>
        </div>
        
        <!-- 申请创建组织按钮 -->
        <div style="margin-top: 18px;">
            <asp:HyperLink ID="hlApplyOrg" runat="server" NavigateUrl="~/Orgs/Apply.aspx"
                CssClass="apply-org-btn" Visible="false">
                <i class="bi bi-plus-circle me-1"></i>申请创建组织
            </asp:HyperLink>
        </div>
    </div>

    <!-- 统计芯片栏 -->
    <div class="stats-bar">
        <div class="stat-chip">
            <i class="bi bi-building"></i>
            <span>组织总数</span>
            <strong><asp:Literal ID="litOrgCount" runat="server">0</asp:Literal></strong>
        </div>
        <div class="stat-chip">
            <i class="bi bi-people-fill"></i>
            <span>覆盖成员</span>
            <strong><asp:Literal ID="litMemberCount" runat="server">0</asp:Literal></strong>
        </div>
        <div class="stat-chip">
            <i class="bi bi-calendar-check"></i>
            <span>正在招新</span>
            <strong><asp:Literal ID="litRecruiting" runat="server">0</asp:Literal></strong>
        </div>
    </div>

    <!-- ========== 搜索卡片 ========== -->
    <div class="search-glass-card">
        <div class="row g-3 align-items-end">
            <div class="col-lg-5">
                <label class="form-label small fw-bold text-white-50 mb-2">关键词搜索</label>
                <div class="search-pill">
                    <i class="bi bi-search"></i>
                    <asp:TextBox ID="txtKeyword" runat="server" CssClass="form-control" placeholder="搜索组织名称、关键词..." />
                </div>
            </div>
            <div class="col-lg-4">
                <label class="form-label small fw-bold text-white-50 mb-2">组织类型</label>
                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select filter-select" />
            </div>
            <div class="col-lg-3">
                <asp:Button ID="btnSearch" runat="server" Text="搜索" CssClass="search-btn w-100"
                            OnClick="BtnSearch_Click" />
            </div>
        </div>
    </div>
<!-- ========== 分类标签云 ========== -->
<div class="category-cloud">
    <a href="List.aspx" class="category-tag <%= string.IsNullOrEmpty(Request.QueryString["cat"]) ? "active" : "" %>">
         全部类型
    </a>
    <asp:Repeater ID="rptCategories" runat="server">
        <ItemTemplate>
            <a href='List.aspx?cat=<%# Eval("CategoryID") %>'
               class='category-tag <%# (Request.QueryString["cat"] == Eval("CategoryID").ToString()) ? "active" : "" %>'>
                <i class='<%# GetCategoryIcon(Eval("CategoryName").ToString()) %>'></i>
                <%# Eval("CategoryName") %>
            </a>
        </ItemTemplate>
    </asp:Repeater>
</div>

    <!-- ========== 结果计数 ========== -->
    <p class="result-count">
        共找到 <strong><asp:Literal ID="litCount" runat="server">0</asp:Literal></strong> 个组织
    </p>

    <!-- ========== 组织卡片网格 ========== -->
    <div class="org-grid">
        <asp:Repeater ID="rptOrgs" runat="server">
            <ItemTemplate>
                <div class="org-card scroll-reveal" data-member-percent='<%# GetMemberPercent(Eval("MemberCount")) %>' style="--member-percent: <%# GetMemberPercent(Eval("MemberCount")) %>;">
                    <!-- 热门/新组织标签 -->
                    <%# IsNewOrg(Eval("CreateTime")) ? "<div class=\"org-new-tag\"><i class=\"bi bi-stars\"></i>新组织</div>" : "" %>
                    <%# IsHotOrg(Eval("MemberCount")) ? "<div class=\"org-hot-tag\"><i class=\"bi bi-fire\"></i>热门</div>" : "" %>

                    <!-- Logo 区域 -->
                    <%# string.IsNullOrEmpty(Eval("LogoUrl").ToString())
                        ? "<div class=\"org-logo-area\"><div class=\"no-logo-txt\">暂无logo</div></div>"
                        : string.Format("<div class=\"org-logo-area\"><img src=\"{0}\" alt=\"Logo\">{1}</div>",
                            ResolveUrl(Eval("LogoUrl").ToString()), "<div class=\"org-overlay\"><span class=\"org-category-badge\"><i class=\"bi bi-tag\"></i>" + Eval("CategoryName") + "</span></div>") %>

                    <!-- 卡片主体 -->
                    <div class="org-card-body">
                        <h5 class="org-name mb-1"><%# Eval("OrgName") %></h5>
                        <p class="org-desc mb-0"><%# OrgManage.APP_Code.Utils.CutString(Eval("Description").ToString(), 60) %></p>
                        <%# !string.IsNullOrEmpty(Convert.ToString(Eval("LatestAnnTitle")))
                            ? "<div class=\"org-latest-ann\"><i class=\"bi bi-megaphone-fill\"></i><span>公告：" + Eval("LatestAnnTitle") + "</span></div>"
                            : "" %>
                    </div>

                    <!-- 成员环形进度 -->
                    <div style="padding: 0 18px 12px;">
                        <div class="org-stats-row">
                            <div class="member-ring">
                                <svg viewBox="0 0 44 44">
                                    <circle class="member-ring-bg" cx="22" cy="22" r="20"/>
                                    <circle class="member-ring-fill" cx="22" cy="22" r="20"/>
                                </svg>
                                <div class="member-ring-text"><%# GetShortMemberCount(Eval("MemberCount")) %></div>
                                <i class="bi bi-people-fill"></i>
                            </div>
                            <div class="member-count-text">
                                <i class="bi bi-people"></i>
                                <span>共 <strong><%# Eval("MemberCount") %></strong> 名成员</span>
                            </div>
                        </div>
                    </div>

                    <!-- 底部操作栏 -->
                    <div style="padding: 0 18px 18px;">
                        <div class="org-action-row">
                            <div class="member-count-text">
                                <i class="bi bi-calendar3"></i>
                                <span><%# Convert.ToDateTime(Eval("CreateTime")).ToString("yyyy-MM") %> 创建</span>
                            </div>
                            <a href='Detail.aspx?id=<%# Eval("OrgID") %>' class="org-detail-btn" onclick="event.stopPropagation();">
                                查看详情 <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>

                    <!-- 展开提示 -->
                    <div class="expand-hint">
                        <i class="bi bi-chevron-expand"></i> 点击卡片查看
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <!-- ========== 空状态 ========== -->
    <asp:Panel ID="panelEmpty" runat="server" Visible="false">
        <div class="empty-state">
            <div class="empty-icon"><i class="bi bi-inbox-fill"></i></div>
            <h4 class="empty-title">暂无匹配的组织</h4>
            <p class="empty-desc">试试调整筛选条件或搜索关键词</p>
        </div>
    </asp:Panel>
</div>

<!-- ========== JavaScript 交互 ========== -->
<script type="text/javascript">
// 1. 鼠标跟踪光晕
document.addEventListener('mousemove', function(e) {
    document.body.style.setProperty('--mx', e.clientX + 'px');
    document.body.style.setProperty('--my', e.clientY + 'px');
});

// 2. 浮动粒子
(function createParticles() {
    var container = document.getElementById('particles');
    var count = 20;
    for (var i = 0; i < count; i++) {
        var p = document.createElement('div');
        p.className = 'particle';
        p.style.left = Math.random() * 100 + '%';
        p.style.width = (2 + Math.random() * 4) + 'px';
        p.style.height = p.style.width;
        p.style.animationDuration = (15 + Math.random() * 20) + 's';
        p.style.animationDelay = (Math.random() * 10) + 's';
        p.style.background = Math.random() > 0.5 ? 'rgba(255,139,167,0.25)' : 'rgba(233,69,96,0.2)';
        container.appendChild(p);
    }
})();

// 3. 卡片点击跳转
document.querySelectorAll('.org-card').forEach(function(card) {
    card.addEventListener('click', function(e) {
        if (e.target.closest('.org-detail-btn')) return;
        var link = card.querySelector('.org-detail-btn');
        if (link) window.location.href = link.href;
    });
});

// 4. 搜索高亮效果
var btnSearch = document.getElementById('<%= btnSearch.ClientID %>');
if (btnSearch) {
    btnSearch.addEventListener('click', function() {
        var cards = document.querySelectorAll('.org-card');
        cards.forEach(function(card, i) {
            setTimeout(function() {
                card.classList.add('highlight');
                setTimeout(function() { card.classList.remove('highlight'); }, 700);
            }, i * 80);
        });
    });
}

// 5. 回车触发搜索
document.getElementById('<%= txtKeyword.ClientID %>').addEventListener('keypress', function (e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            btnSearch && btnSearch.click();
        }
    });

    // 6. 滚动淡入观察器
    var revealObserver = new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
            if (entry.isIntersecting) {
                entry.target.classList.add('revealed');
                revealObserver.unobserve(entry.target);
            }
        });
    }, { threshold: 0.1, rootMargin: '0px 0px -50px 0px' });

    document.querySelectorAll('.scroll-reveal').forEach(function (el) {
        revealObserver.observe(el);
    });

    // 7. 成员环形进度动画
    document.querySelectorAll('.org-card').forEach(function (card) {
        var percent = parseFloat(card.dataset.memberPercent) || 0.5;
        card.style.setProperty('--member-percent', percent);
    });
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
