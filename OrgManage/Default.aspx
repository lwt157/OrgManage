<%@ Page Title="首页 - 高校组织综合线上管理平台" Language="C#" MasterPageFile="~/Site.master"
         AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="OrgManage._Default" %>
<%@ Import Namespace="System.Data" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <!-- ==================== 全局深色星空主题样式 + 公告栏 + 滚动网格容器 ==================== -->
    <style>
        /* ---------- 基础 ---------- */
        body {
            background: url('<%= ResolveUrl("~/images/bg-night.jpg") %>') no-repeat center center fixed !important;
            background-size: cover !important;
            color: #fff !important;
            scroll-behavior: smooth;
        }
        /* ---------- 导航栏（仅定义滚动后的背景，透明状态由母版 .navbar-transparent 控制） ---------- */
        .navbar.scrolled {
            background: rgba(0, 0, 0, 0.5) !important;
            backdrop-filter: blur(10px) !important;
            -webkit-backdrop-filter: blur(10px) !important;
        }
        .navbar .nav-link, .navbar-brand {
            color: #fff !important;
            transition: color 0.3s ease;
        }
        .navbar .nav-link:hover {
            color: #ff8ba7 !important;
        }
        /* ========== 核心修改：横幅（视频作为普通元素随页面滚动，覆盖导航栏） ========== */
        .site-hero {
            position: relative;
            /* 从页面最顶部开始，覆盖导航栏 */
            top: 0;
            left: 0;
            width: 100%;
            height: 100vh;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff !important;
            /* 确保视频在导航栏下方，导航栏文字在视频上方 */
            z-index: 1;
            /* 关键：让视频容器向上移动，覆盖导航栏 */
            margin-top: -56px; /* 导航栏高度是56px，这里用负margin覆盖 */
            padding-top: 56px; /* 给内容留导航栏高度，避免文字被挡住 */
        }
        /* 背景视频 - 完全覆盖容器 */
        .hero-video {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 100vw;
            height: 100vh;
            object-fit: cover;
            z-index: 1;
            opacity: 1;
            will-change: transform;
        }
        /* 半透明深色遮罩（降低透明度，让视频更清晰） */
        .hero-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.2);
            z-index: 2;
        }
        /* 文字内容容器 */
        .hero-content {
            position: relative;
            z-index: 3;
            text-align: center;
            padding: 2rem;
            animation: fadeInUp 1s ease forwards;
        }
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .site-hero h2 {
            color: #ff8ba7 !important;
            animation: pulse 2s infinite alternate;
        }
        @keyframes pulse {
            from { transform: scale(1); }
            to { transform: scale(1.05); }
        }
        /* ---------- 按钮 ---------- */
       /* 透明按钮样式 */
.btn-light {
    background: transparent !important;
    border: 1px solid rgba(255,255,255,0.3) !important;
    color: #fff !important;
    transition: all 0.3s ease;
}
.btn-light:hover {
    background: rgba(255,255,255,0.15) !important;
    border-color: rgba(255,255,255,0.5) !important;
    transform: translateY(-3px) scale(1.05);
    box-shadow: 0 8px 20px rgba(0,0,0,0.15);
}
.btn-warning {
    background: transparent !important;
    border: 1px solid rgba(255,139,167,0.4) !important;
    color: #ff8ba7 !important;
    transition: all 0.3s ease;
}
.btn-warning:hover {
    background: rgba(255,139,167,0.2) !important;
    border-color: rgba(255,139,167,0.6) !important;
    transform: translateY(-3px) scale(1.05);
    box-shadow: 0 8px 20px rgba(255,139,167,0.2);
}
        /* ---------- 文字颜色 ---------- */
        .text-primary { color: #ff8ba7 !important; }
        .text-dark { color: #fff !important; }
        .text-muted { color: rgba(255,255,255,0.7) !important; }
        .btn-outline-primary {
            border-color: #ff8ba7 !important;
            color: #ff8ba7 !important;
        }
        .btn-outline-primary:hover {
            background: #ff8ba7 !important;
            color: #fff !important;
        }
        .btn-outline-success {
            border-color: #20e09c !important;
            color: #20e09c !important;
        }
        .btn-outline-success:hover {
            background: #20e09c !important;
            color: #1a1a2e !important;
        }
        .btn-outline-warning {
            border-color: #ffd43b !important;
            color: #ffd43b !important;
        }
        .btn-outline-warning:hover {
            background: #ffd43b !important;
            color: #1a1a2e !important;
        }
        /* ---------- 基础卡片 ---------- */
        .card {
            background: rgba(255, 255, 255, 0.08) !important;
            backdrop-filter: blur(12px) !important;
            -webkit-backdrop-filter: blur(12px) !important;
            border: 1px solid rgba(255,255,255,0.12) !important;
            color: #fff !important;
            transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);
            border-radius: 14px;
        }
        .card:hover {
            transform: translateY(-6px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4), 0 0 20px rgba(255,139,167,0.15);
        }
        .card .text-muted {
            color: rgba(255,255,255,0.7) !important;
        }
        /* ==================== 公告栏 ==================== */
        .announce-board {
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 14px;
            margin-bottom: 28px;
            overflow: hidden;
            transition: all 0.3s ease;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.25);
        }
        .announce-board:hover {
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.35);
        }
        .announce-board-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 14px 18px;
            cursor: pointer;
            user-select: none;
            -webkit-user-select: none;
            transition: background 0.2s ease;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
            gap: 10px;
        }
        .announce-board-header:hover {
            background: rgba(255, 255, 255, 0.05);
        }
        .announce-board-header-left {
            display: flex;
            align-items: center;
            gap: 10px;
            min-width: 0;
            flex: 1;
        }
        .announce-board-icon {
            font-size: 20px;
            flex-shrink: 0;
            color: #ff8ba7;
            animation: announcePulse 2.5s infinite alternate;
        }
        @keyframes announcePulse {
            from { transform: scale(1); opacity: 0.85; }
            to { transform: scale(1.12); opacity: 1; }
        }
        .announce-board-title {
            font-weight: 700;
            font-size: 15px;
            color: #fff;
            letter-spacing: 0.5px;
            white-space: nowrap;
        }
        .announce-board-count {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: rgba(255, 139, 167, 0.25);
            color: #ffb3c6;
            font-size: 12px;
            font-weight: 600;
            border-radius: 20px;
            padding: 3px 10px;
            min-width: 26px;
            line-height: 1;
            flex-shrink: 0;
        }
        .announce-board-toggle {
            flex-shrink: 0;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.18);
            color: #fff;
            font-size: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            line-height: 1;
            padding: 0;
        }
        .announce-board-toggle:hover {
            background: rgba(255, 255, 255, 0.16);
            border-color: rgba(255, 255, 255, 0.35);
            transform: scale(1.06);
        }
        .announce-board-toggle i {
            transition: transform 0.35s ease;
            font-size: 16px;
        }
        .announce-board.collapsed .announce-board-toggle i {
            transform: rotate(180deg);
        }
        .announce-board-list-wrapper {
            max-height: 340px;
            overflow-y: auto;
            overflow-x: hidden;
            transition: max-height 0.4s cubic-bezier(0.4, 0, 0.2, 1),
                        padding 0.4s cubic-bezier(0.4, 0, 0.2, 1),
                        opacity 0.3s ease;
            padding: 6px 10px;
            opacity: 1;
        }
        .announce-board.collapsed .announce-board-list-wrapper {
            max-height: 0;
            overflow-y: hidden;
            padding-top: 0;
            padding-bottom: 0;
            opacity: 0;
        }
        .announce-board.collapsed .announce-board-header {
            border-bottom-color: transparent;
        }
        .announce-board-list-wrapper::-webkit-scrollbar {
            width: 5px;
        }
        .announce-board-list-wrapper::-webkit-scrollbar-track {
            background: transparent;
            border-radius: 10px;
        }
        .announce-board-list-wrapper::-webkit-scrollbar-thumb {
            background: rgba(255, 255, 255, 0.18);
            border-radius: 10px;
        }
        .announce-board-list-wrapper::-webkit-scrollbar-thumb:hover {
            background: rgba(255, 255, 255, 0.32);
        }
        .announce-board-list-wrapper {
            scrollbar-width: thin;
            scrollbar-color: rgba(255,255,255,0.18) transparent;
        }
        .announce-row {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 11px 12px;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.22s ease;
            color: #fff;
            position: relative;
            margin: 2px 0;
            border: 1px solid transparent;
            background: transparent;
        }
        .announce-row:hover {
            background: rgba(255, 255, 255, 0.1);
            border-color: rgba(255, 255, 255, 0.18);
            transform: translateX(3px);
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.2);
        }
        .announce-row:active {
            transform: scale(0.985);
        }
        .announce-row-dot {
            flex-shrink: 0;
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #ff8ba7;
            box-shadow: 0 0 8px rgba(255, 139, 167, 0.5);
            transition: all 0.25s ease;
        }
        .announce-row:hover .announce-row-dot {
            box-shadow: 0 0 14px rgba(255, 139, 167, 0.75);
            transform: scale(1.3);
        }
        .announce-row-text {
            flex: 1;
            font-size: 14px;
            font-weight: 50;
            color: rgba(255, 255, 255, 0.92);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            line-height: 1.4;
            min-width: 0;
        }
        .announce-row:hover .announce-row-text {
            color: #fff;
        }
        .announce-row-arrow {
            flex-shrink: 0;
            font-size: 13px;
            color: rgba(255, 255, 255, 0.45);
            transition: all 0.25s ease;
        }
        .announce-row:hover .announce-row-arrow {
            color: #ff8ba7;
            transform: translateX(3px);
        }
        .announce-empty {
            text-align: center;
            padding: 30px 20px;
            color: rgba(255,255,255,0.45);
            font-size: 13px;
        }
        .announce-empty i {
            font-size: 28px;
            display: block;
            margin-bottom: 8px;
            opacity: 0.5;
        }
        /* ==================== 智能自适应网格容器 ==================== */
        .module-container {
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255,255,255,0.15);
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 28px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
        }
        .module-scroll-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 14px;
            padding: 4px 2px;
            border-radius: 12px;
            scroll-behavior: smooth;
            min-height: 0;
        }
        .module-scroll-grid::-webkit-scrollbar {
            width: 5px;
        }
        .module-scroll-grid::-webkit-scrollbar-track {
            background: transparent;
            border-radius: 10px;
        }
        .module-scroll-grid::-webkit-scrollbar-thumb {
            background: rgba(255, 255, 255, 0.2);
            border-radius: 10px;
        }
        .module-scroll-grid::-webkit-scrollbar-thumb:hover {
            background: rgba(255, 255, 255, 0.35);
        }
        .module-scroll-grid {
            scrollbar-width: thin;
            scrollbar-color: rgba(255,255,255,0.2) transparent;
        }
        .module-scroll-grid > .card {
            height: 100%;
            margin: 0;
        }
        /* 空数据提示（居中） */
        .empty-tip {
            grid-column: 1 / -1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
            color: rgba(255,255,255,0.5);
            text-align: center;
        }
        .empty-tip i {
            font-size: 36px;
            margin-bottom: 12px;
            opacity: 0.5;
        }
        /* ==================== 模块标题动画样式 ==================== */
        .module-header {
            position: relative;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            overflow: hidden;
        }
        .module-title-wrapper {
            position: relative;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        .module-title {
            font-weight: 700;
            font-size: 1.25rem;
            margin: 0;
            opacity: 0;
            transform: translateY(20px);
        }
        .module-title.animated {
            animation: titleSlideUp 0.8s cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
        }
        @keyframes titleSlideUp {
            0% {
                opacity: 0;
                transform: translateY(20px);
            }
            100% {
                opacity: 1;
                transform: translateY(0);
            }
        }
        .module-title-underline {
            position: absolute;
            bottom: -4px;
            left: 0;
            width: 0;
            height: 3px;
            border-radius: 2px;
            background: linear-gradient(90deg, currentColor, transparent);
            transition: width 0.8s cubic-bezier(0.4, 0, 0.2, 1) 0.3s;
        }
        .module-title-wrapper.animated .module-title-underline {
            width: 100%;
        }
        .module-icon {
            font-size: 1.3rem;
            opacity: 0;
            transform: scale(0) rotate(-180deg);
        }
        .module-icon.animated {
            animation: iconPopIn 0.6s cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
        }
        @keyframes iconPopIn {
            0% {
                opacity: 0;
                transform: scale(0) rotate(-180deg);
            }
            100% {
                opacity: 1;
                transform: scale(1) rotate(0deg);
            }
        }
        .module-btn {
            opacity: 0;
            transform: translateX(20px);
        }
        .module-btn.animated {
            animation: btnSlideIn 0.6s cubic-bezier(0.4, 0, 0.2, 1) 0.4s forwards;
        }
        @keyframes btnSlideIn {
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
        /* ==================== 卡片入场动画 ==================== */
        .card-animate {
            opacity: 0;
            transform: translateY(40px) scale(0.95);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .card-animate.visible {
            animation: cardElasticIn 0.7s cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
        }
        @keyframes cardElasticIn {
            0% {
                opacity: 0;
                transform: translateY(40px) scale(0.95);
            }
            60% {
                transform: translateY(-8px) scale(1.02);
            }
            100% {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }
        /* 卡片依次延迟 */
        .card-animate.visible:nth-child(1) { animation-delay: 0s; }
        .card-animate.visible:nth-child(2) { animation-delay: 0.08s; }
        .card-animate.visible:nth-child(3) { animation-delay: 0.16s; }
        .card-animate.visible:nth-child(4) { animation-delay: 0.24s; }
        .card-animate.visible:nth-child(5) { animation-delay: 0.32s; }
        .card-animate.visible:nth-child(6) { animation-delay: 0.40s; }
        .card-animate.visible:nth-child(7) { animation-delay: 0.48s; }
        .card-animate.visible:nth-child(8) { animation-delay: 0.56s; }
        .card-animate.visible:nth-child(9) { animation-delay: 0.64s; }
        /* ==================== 卡片悬停3D效果 ==================== */
     
.org-card-h, .act-card, .recruit-card {
    cursor: pointer;
    position: relative;
    overflow: hidden;
    /* 移除 preserve-3d 和 perspective，改用 translateZ 触发轻量GPU加速 */
    transform: translateZ(0);
    transition: transform 0.2s cubic-bezier(0.4, 0, 0.2, 1), box-shadow 0.2s ease;
}
.org-card-h:hover, .act-card:hover, .recruit-card:hover {
    transform: translateY(-8px) translateZ(0);
}
        /* 光效扫过 */
        .org-card-h::before, .act-card::before, .recruit-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 50%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.15), transparent);
            transition: left 0.8s ease;
            z-index: 1;
            pointer-events: none;
        }
        .org-card-h:hover::before, .act-card:hover::before, .recruit-card:hover::before {
            left: 150%;
        }
        /* 边缘发光 */
        .org-card-h::after, .act-card::after, .recruit-card::after {
            content: '';
            position: absolute;
            inset: -1px;
            border-radius: 14px;
            padding: 1px;
            background: linear-gradient(135deg, transparent, rgba(255,139,167,0.3), transparent);
            -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
            mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
            -webkit-mask-composite: xor;
            mask-composite: exclude;
            opacity: 0;
            transition: opacity 0.4s ease;
            pointer-events: none;
        }
        .org-card-h:hover::after, .act-card:hover::after, .recruit-card:hover::after {
            opacity: 1;
        }
        /* ==================== 精选组织卡片样式 ==================== */
        .org-card-h .org-logo-wrapper {
            width: 64px;
            height: 64px;
            border-radius: 14px;
            overflow: hidden;
            background: rgba(255,255,255,0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px solid rgba(255,255,255,0.15);
            flex-shrink: 0;
            transition: all 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
            position: relative;
        }
        .org-card-h:hover .org-logo-wrapper {
            transform: scale(1.1) rotate(5deg);
            box-shadow: 0 0 25px rgba(255,139,167,0.4);
            border-color: rgba(255,139,167,0.4);
        }
        .org-logo-wrapper img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.4s ease;
        }
        .org-card-h:hover .org-logo-wrapper img {
            transform: scale(1.1);
        }
        /* Logo脉冲光环 */
        .org-logo-wrapper::before {
            content: '';
            position: absolute;
            inset: -3px;
            border-radius: 16px;
            background: linear-gradient(135deg, #ff8ba7, #e94560, #ff8ba7);
            opacity: 0;
            z-index: -1;
            transition: opacity 0.4s ease;
            filter: blur(8px);
        }
        .org-card-h:hover .org-logo-wrapper::before {
            opacity: 0.6;
            animation: logoGlow 1.5s ease-in-out infinite alternate;
        }
        @keyframes logoGlow {
            from { opacity: 0.4; filter: blur(6px); }
            to { opacity: 0.8; filter: blur(12px); }
        }
        .org-card-h .btn-detail {
            background: linear-gradient(135deg, #ff8ba7, #e94560);
            border: none;
            transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
            white-space: nowrap;
            position: relative;
            overflow: hidden;
        }
        .org-card-h .btn-detail::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.5s ease;
        }
        .org-card-h:hover .btn-detail {
            transform: scale(1.05);
            box-shadow: 0 5px 20px rgba(233, 69, 96, 0.5);
        }
        .org-card-h:hover .btn-detail::before {
            left: 100%;
        }
        /* 组织名称文字动画 */
        .org-card-h h6 {
            position: relative;
            display: inline-block;
        }
        .org-card-h h6::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 0;
            height: 2px;
            background: linear-gradient(90deg, #ff8ba7, transparent);
            transition: width 0.4s ease;
        }
        .org-card-h:hover h6::after {
            width: 100%;
        }
        /* ==================== 活动卡片样式 ==================== */
        .act-date {
            background: linear-gradient(135deg, rgba(32, 224, 156, 0.2), rgba(32, 224, 156, 0.05));
            border-radius: 12px;
            padding: 10px 14px;
            text-align: center;
            min-width: 70px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            border: 1px solid rgba(32,224,156,0.3);
            transition: all 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
            position: relative;
            overflow: hidden;
        }
        .act-card:hover .act-date {
            transform: scale(1.05);
            box-shadow: 0 0 20px rgba(32, 224, 156, 0.3);
            border-color: rgba(32,224,156,0.5);
        }
        .act-date::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent, rgba(255,255,255,0.1), transparent);
            transform: rotate(45deg);
            transition: all 0.6s ease;
            opacity: 0;
        }
        .act-card:hover .act-date::before {
            animation: dateShine 0.8s ease forwards;
        }
        @keyframes dateShine {
            0% { transform: translateX(-100%) translateY(-100%) rotate(45deg); opacity: 0; }
            50% { opacity: 1; }
            100% { transform: translateX(100%) translateY(100%) rotate(45deg); opacity: 0; }
        }
        .act-date .day {
            font-size: 28px;
            font-weight: 800;
            color: #20e09c;
            line-height: 1;
            text-shadow: 0 0 10px rgba(32, 224, 156, 0.5);
            transition: all 0.3s ease;
        }
        .act-card:hover .act-date .day {
            transform: scale(1.1);
            text-shadow: 0 0 20px rgba(32, 224, 156, 0.8);
        }
        .act-date .mon {
            font-size: 12px;
            color: rgba(255,255,255,0.9);
            margin-top: 4px;
            font-weight: 500;
            letter-spacing: 1px;
        }
        .act-card h6 {
            transition: all 0.3s ease;
        }
        .act-card:hover h6 {
            color: #20e09c !important;
            text-shadow: 0 0 10px rgba(32, 224, 156, 0.3);
        }
        /* ==================== 招新卡片样式 ==================== */
        .recruit-card {
            position: relative;
            overflow: hidden;
        }
        .recruit-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, #ffd43b, #ff8ba7, #e94560, #ffd43b);
            background-size: 300% 100%;
            opacity: 0;
            transition: opacity 0.4s ease;
        }
        .recruit-card:hover::before {
            opacity: 1;
            animation: borderFlow 2s linear infinite;
        }
        @keyframes borderFlow {
            0% { background-position: 0% 50%; }
            100% { background-position: 300% 50%; }
        }
        .recruit-card .badge {
            transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
            position: relative;
            overflow: hidden;
        }
        .recruit-card:hover .badge {
            transform: scale(1.05);
            box-shadow: 0 0 15px rgba(255, 212, 59, 0.4);
        }
        .recruit-card .badge::after {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent, rgba(255,255,255,0.3), transparent);
            transform: rotate(45deg);
            transition: all 0.6s ease;
        }
        .recruit-card:hover .badge::after {
            animation: badgeShine 0.8s ease forwards;
        }
        @keyframes badgeShine {
            0% { transform: translateX(-100%) translateY(-100%) rotate(45deg); }
            100% { transform: translateX(100%) translateY(100%) rotate(45deg); }
        }
        .recruit-card h6 {
            transition: all 0.3s ease;
        }
        .recruit-card:hover h6 {
            color: #ffd43b !important;
            text-shadow: 0 0 10px rgba(255, 212, 59, 0.3);
        }
        .recruit-card .btn-warning {
            background: linear-gradient(135deg, #ffd43b, #ff8ba7) !important;
            border: none !important;
            color: #1a1a2e !important;
            font-weight: 600;
            transition: all 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
            position: relative;
            overflow: hidden;
        }
        .recruit-card .btn-warning::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.4), transparent);
            transition: left 0.5s ease;
        }
        .recruit-card:hover .btn-warning {
            transform: scale(1.03);
            box-shadow: 0 8px 25px rgba(255, 212, 59, 0.5);
        }
        .recruit-card:hover .btn-warning::before {
            left: 100%;
        }
        /* 倒计时闪烁效果 */
        .recruit-card small {
            transition: all 0.3s ease;
        }
        .recruit-card:hover small {
            color: #ffd43b !important;
            text-shadow: 0 0 8px rgba(255, 212, 59, 0.4);
        }
        /* ==================== 文字逐字显示动画 ==================== */
        .text-reveal {
            opacity: 0;
        }
        .text-reveal.animated {
            opacity: 1;
            animation: textFadeIn 0.6s ease forwards;
        }
        @keyframes textFadeIn {
            from {
                opacity: 0;
                filter: blur(4px);
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                filter: blur(0);
                transform: translateY(0);
            }
        }
        /* ==================== 粒子背景效果 ==================== */
        .module-particles {
            position: absolute;
            inset: 0;
            overflow: hidden;
            pointer-events: none;
            border-radius: 16px;
        }
        .particle {
            position: absolute;
            width: 4px;
            height: 4px;
            background: rgba(255,255,255,0.3);
            border-radius: 50%;
            animation: float 3s ease-in-out infinite;
        }
        @keyframes float {
            0%, 100% {
                transform: translateY(0) translateX(0);
                opacity: 0.3;
            }
            50% {
                transform: translateY(-20px) translateX(10px);
                opacity: 0.8;
            }
        }
        /* 移动端降级：隐藏视频，显示背景图 */
        @media (max-width: 768px) {
            .hero-video {
                display: none;
            }
            .site-hero {
                background: url('<%= ResolveUrl("~/images/default.jpg") %>') center center / cover;
            }
            .module-scroll-grid {
                grid-template-columns: 1fr;
            }
        }
        @media (max-width: 992px) {
            .module-scroll-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        /* 暂无logo 样式 */
.no-logo-txt {
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 12px;
    color: rgba(255,255,255,0.6);
    background: rgba(255,255,255,0.05);
}
.org-logo-img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}
/* 首页透明按钮样式 + 动态交互 */
.hero-btn-1 {
    background: rgba(255,255,255,0.15);
    backdrop-filter: blur(8px);
    border: 1px solid rgba(255,255,255,0.3);
    color: #fff;
    transition: all 0.3s ease;
}
.hero-btn-1:hover {
    background: rgba(255,255,255,0.3);
    border-color: rgba(255,255,255,0.5);
    transform: translateY(-3px) scale(1.05);
    box-shadow: 0 8px 20px rgba(0,0,0,0.2);
}

.hero-btn-2 {
    background: rgba(255,139,167,0.2);
    backdrop-filter: blur(8px);
    border: 1px solid rgba(255,139,167,0.4);
    color: #fff;
    transition: all 0.3s ease;
}
.hero-btn-2:hover {
    background: rgba(255,139,167,0.4);
    border-color: rgba(255,139,167,0.6);
    transform: translateY(-3px) scale(1.05);
    box-shadow: 0 8px 20px rgba(255,139,167,0.3);
}
    </style>


    <!-- ===== 横幅（视频作为普通元素随页面滚动） ===== -->
    <div id="videoSection" class="site-hero">
        <video class="hero-video" autoplay loop muted playsinline poster="<%= ResolveUrl("~/images/bg-night.jpg") %>" preload="auto">
            <source src="<%= ResolveUrl("~/videos/hero-bg.mp4") %>" type="video/mp4">
            您的浏览器不支持视频播放
        </video>
        <div class="hero-overlay"></div>
        <div class="hero-content container text-center">
            <h1>高校组织综合线上管理平台</h1>
            <!-- 时间卡片 -->
    <div class="time-card my-4" style="display: inline-block; padding: 15px 30px; background: rgba(255,255,255,0.1); backdrop-filter: blur(10px); border-radius: 16px; border: 1px solid rgba(255,255,255,0.2);">
        <div id="live-time" style="font-size: 3rem; font-weight: 700; color: #ff8ba7; letter-spacing: 3px; font-family: 'Segoe UI', monospace; text-shadow: 0 0 15px rgba(255,139,167,0.5);"></div>
        <div id="time-tip" style="font-size: 1rem; color: rgba(255,255,255,0.8); margin-top: 8px;"></div>
    </div>
            <p class="mt-2">探索校园，加入组织，开启精彩大学生活</p>
         <div class="mt-4">
    <a href="Orgs/Apply.aspx" class="btn btn-lg me-3 fw-bold hero-btn-1">
        <i class="bi bi-grid me-1"></i>申请创建组织
    </a>
    <a href="Orgs/Recruit.aspx" class="btn btn-lg fw-bold hero-btn-2">
        <i class="bi bi-megaphone me-1"></i>参加招新
    </a>
</div>
            <div class="row mt-5 justify-content-center">
                <div class="col-6 col-md-3">
                    <h2 class="fw-bold text-warning"><asp:Literal ID="litOrgCount" runat="server">0</asp:Literal></h2>
                    <p class="small opacity-75">在校组织</p>
                </div>
                <div class="col-6 col-md-3">
                    <h2 class="fw-bold text-warning"><asp:Literal ID="litActivityCount" runat="server">0</asp:Literal></h2>
                    <p class="small opacity-75">精彩活动</p>
                </div>
                <div class="col-6 col-md-3">
                    <h2 class="fw-bold text-warning"><asp:Literal ID="litMemberCount" runat="server">0</asp:Literal></h2>
                    <p class="small opacity-75">活跃成员</p>
                </div>
                <div class="col-6 col-md-3">
                    <h2 class="fw-bold text-warning"><asp:Literal ID="litRecruitCount" runat="server">0</asp:Literal></h2>
                    <p class="small opacity-75">招新进行中</p>
                </div>
            </div>
        </div>
    </div>
    <!-- ===== 下方内容（不再需要占位元素，直接跟在视频后面） ===== -->
    <div class="container my-5" style="position: relative; z-index: 2;">
        <!-- ==================== 可折叠公告栏 ==================== -->
        <div class="announce-board" id="announceBoard">
            <div class="announce-board-header" id="announceHeader" title="点击折叠/展开公告栏">
                <div class="announce-board-header-left">
                    <span class="announce-board-icon">📢</span>
                    <span class="announce-board-title">最新公告</span>
                    <span class="announce-board-count" id="announceCount">0</span>
                </div>
                <button type="button" class="announce-board-toggle" id="announceToggle" aria-label="折叠公告栏">
                    <i class="bi bi-chevron-up"></i>
                </button>
            </div>
            <div class="announce-board-list-wrapper" id="announceListWrapper">
                <asp:Repeater ID="rpAnnouncements" runat="server">
                    <ItemTemplate>
                        <div class="announce-row"
                             data-id="<%# Eval("AnnID") %>"
                             title="点击查看公告详情">
                            <span class="announce-row-dot"></span>
                            <span class="announce-row-text"><%# Eval("Title") %></span>
                            <span class="announce-row-arrow"><i class="bi bi-chevron-right"></i></span>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <div class="announce-empty" id="announceEmpty" style="display:none;">
                    <i class="bi bi-bell-slash"></i>
                    暂无公告
                </div>
            </div>
        </div>
        <!-- ===== 精选组织 ===== -->
        <div class="module-container" data-module="orgs">
            <div class="module-header">
                <div class="module-title-wrapper">
                    <i class="bi bi-grid-fill module-icon text-primary"></i>
                    <h4 class="module-title text-primary">精选组织</h4>
                    <span class="module-title-underline" style="color: #ff8ba7;"></span>
                </div>
                <a href="Orgs/List.aspx" class="btn btn-outline-primary btn-sm module-btn">查看全部 <i class="bi bi-arrow-right"></i></a>
            </div>
            <div class="module-scroll-grid" data-empty-text="暂无组织">
                <asp:Repeater ID="rptOrgs" runat="server">
                    <ItemTemplate>
                        <div class="card org-card-h card-animate"
                             data-url="Orgs/Detail.aspx?id=<%# ((DataRowView)Container.DataItem)["OrgID"] %>">
                            <div class="card-body p-3 d-flex align-items-center gap-3 h-100">

                               <div class="org-logo-wrapper">
                               <%# string.IsNullOrEmpty(Eval("LogoUrl").ToString()) ? 
                                "<div class='no-logo-txt'>暂无logo</div>" : 
                                 "<img src='"+Eval("LogoUrl")+"' class='org-logo-img' />"   %>

                               </div>
                                <div class="overflow-hidden flex-grow-1">
                                    <h6 class="fw-bold mb-1 text-white text-truncate text-reveal"><%# ((DataRowView)Container.DataItem)["OrgName"] %></h6>
                                    <p class="small text-muted mb-2 text-reveal" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                        <%# GetShortDescription(((DataRowView)Container.DataItem)["Description"].ToString()) %>
                                    </p>
                                    <div class="d-flex justify-content-between align-items-center text-reveal">
                                        <span class="text-muted small"><i class="bi bi-people me-1"></i><%# ((DataRowView)Container.DataItem)["MemberCount"] %>人</span>
                                        <a href="Orgs/Detail.aspx?id=<%# ((DataRowView)Container.DataItem)["OrgID"] %>"
                                           class="btn btn-primary btn-sm btn-detail"
                                           onclick="event.stopPropagation();">了解更多</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
        <!-- ===== 近期活动 ===== -->
        <div class="module-container" data-module="activities">
            <div class="module-header">
                <div class="module-title-wrapper">
                    <i class="bi bi-calendar-event-fill module-icon text-success" style="color: #20e09c !important;"></i>
                    <h4 class="module-title" style="color: #20e09c !important;">近期活动</h4>
                    <span class="module-title-underline" style="color: #20e09c;"></span>
                </div>
                <a href="Activities/List.aspx" class="btn btn-outline-success btn-sm module-btn">查看全部 <i class="bi bi-arrow-right"></i></a>
            </div>
            <div class="module-scroll-grid" data-empty-text="暂无活动">
                <asp:Repeater ID="rptActivities" runat="server">
                    <ItemTemplate>
                        <div class="card act-card card-animate"
                             data-url="Activities/Detail.aspx?id=<%# ((DataRowView)Container.DataItem)["ActivityID"] %>">
                            <div class="card-body p-3 d-flex gap-3 h-100">
                                <div class="act-date flex-shrink-0">
                                    <div class="day"><%# Convert.ToDateTime(((DataRowView)Container.DataItem)["StartTime"]).Day %></div>
                                    <div class="mon"><%# Convert.ToDateTime(((DataRowView)Container.DataItem)["StartTime"]).ToString("MM月") %></div>
                                </div>
                                <div class="overflow-hidden d-flex flex-column justify-content-center">
                                    <h6 class="fw-bold mb-1 text-white text-truncate text-reveal">
                                        <%# ((DataRowView)Container.DataItem)["Title"] %>
                                    </h6>
                                    <p class="small text-muted mb-1 text-reveal"><i class="bi bi-geo-alt me-1"></i><%# ((DataRowView)Container.DataItem)["Location"] %></p>
                                    <p class="small text-muted mb-0 text-reveal"><i class="bi bi-building me-1"></i><%# ((DataRowView)Container.DataItem)["OrgName"] %></p>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
        <!-- ===== 招新进行中 ===== -->
        <div class="module-container" data-module="recruits">
            <div class="module-header">
                <div class="module-title-wrapper">
                    <i class="bi bi-person-plus-fill module-icon text-warning" style="color: #ffd43b !important;"></i>
                    <h4 class="module-title" style="color: #ffd43b !important;">招新进行中</h4>
                    <span class="module-title-underline" style="color: #ffd43b;"></span>
                </div>
                <a href="Orgs/Recruit.aspx" class="btn btn-outline-warning btn-sm module-btn">全部招新 <i class="bi bi-arrow-right"></i></a>
            </div>
            <div class="module-scroll-grid" data-empty-text="暂无招新">
                <asp:Repeater ID="rptRecruits" runat="server">
                    <ItemTemplate>
                        <div class="card recruit-card card-animate"
                             data-url="Orgs/RecruitDetail.aspx?id=<%# ((DataRowView)Container.DataItem)["RecruitID"] %>">
                            <div class="card-body d-flex flex-column justify-content-between h-100 p-3">
                                <div>
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <span class="badge bg-warning text-dark"><%# ((DataRowView)Container.DataItem)["CategoryName"] %></span>
                                        <small class="text-muted">截止 <%# Convert.ToDateTime(((DataRowView)Container.DataItem)["EndDate"]).ToString("MM-dd") %></small>
                                    </div>
                                    <h6 class="fw-bold mb-1 text-white text-truncate text-reveal"><%# ((DataRowView)Container.DataItem)["Title"] %></h6>
                                    <p class="small text-muted mb-2 text-reveal"><%# ((DataRowView)Container.DataItem)["OrgName"] %></p>
                                </div>
                                <a href='Orgs/RecruitDetail.aspx?id=<%# ((DataRowView)Container.DataItem)["RecruitID"] %>'
                                   class="btn btn-warning btn-sm w-100"
                                   onclick="event.stopPropagation();">立即报名</a>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </div>
    <!-- ==================== JavaScript ==================== -->
    <script>
        // ---------- 公告栏折叠与交互（完全保留，无改动） ----------
        (function () {
            const board = document.getElementById('announceBoard');
            const header = document.getElementById('announceHeader');
            const toggleBtn = document.getElementById('announceToggle');
            const listWrapper = document.getElementById('announceListWrapper');
            const countEl = document.getElementById('announceCount');
            const emptyEl = document.getElementById('announceEmpty');
            function updateCount() {
                const rows = listWrapper.querySelectorAll('.announce-row');
                const count = rows.length;
                countEl.textContent = count;
                if (emptyEl) {
                    emptyEl.style.display = count === 0 ? 'block' : 'none';
                }
            }
            updateCount();
            function toggleAnnounceBoard(e) {
                if (e && e.target.closest('.announce-row')) return;
                board.classList.toggle('collapsed');
            }
            header.addEventListener('click', function (e) {
                if (e.target.closest('#announceToggle')) return;
                toggleAnnounceBoard(e);
            });
            toggleBtn.addEventListener('click', function (e) {
                e.stopPropagation();
                toggleAnnounceBoard(e);
            });
            listWrapper.addEventListener('click', function (e) {
                const row = e.target.closest('.announce-row');
                if (!row) return;
                const annId = row.getAttribute('data-id');
                if (annId) {
                    window.open('AnnounceDetail.aspx?id=' + encodeURIComponent(annId), '_blank');
                }
            });
            header.addEventListener('keydown', function (e) {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    toggleAnnounceBoard(e);
                }
            });
            header.setAttribute('tabindex', '0');
            header.setAttribute('role', 'button');
            header.setAttribute('aria-expanded', 'true');
            const observer = new MutationObserver(function () {
                const isCollapsed = board.classList.contains('collapsed');
                header.setAttribute('aria-expanded', !isCollapsed);
            });
            observer.observe(board, { attributes: true, attributeFilter: ['class'] });
        })();
        // ---------- 智能自适应布局 ----------
        document.addEventListener('DOMContentLoaded', function () {
            document.querySelectorAll('.module-scroll-grid').forEach(grid => {
                const cards = grid.querySelectorAll('.card');
                const emptyText = grid.dataset.emptyText || '暂无数据';
                if (cards.length === 0) {
                    grid.innerHTML = `<div class="empty-tip"><i class="bi bi-inbox"></i><div>${emptyText}</div></div>`;
                } else if (cards.length > 9) {
                    grid.style.maxHeight = '420px';
                    grid.style.overflowY = 'auto';
                }
            });
        });
        // ---------- 整卡点击跳转（完全保留，无改动） ----------
        document.addEventListener('click', function (e) {
            const orgCard = e.target.closest('.org-card-h');
            if (orgCard) {
                if (e.target.closest('a, button, .btn')) return;
                const url = orgCard.getAttribute('data-url');
                if (url) window.location.href = url;
                return;
            }
            const actCard = e.target.closest('.act-card');
            if (actCard) {
                if (e.target.closest('a, button')) return;
                const url = actCard.getAttribute('data-url');
                if (url) window.location.href = url;
                return;
            }
            const recruitCard = e.target.closest('.recruit-card');
            if (recruitCard) {
                if (e.target.closest('a, button, .btn')) return;
                const url = recruitCard.getAttribute('data-url');
                if (url) window.location.href = url;
            }
        });
        // ==================== 滚动触发动画系统 ====================
        (function () {
            // 模块标题动画
            const animateModuleHeader = (container) => {
                const titleWrapper = container.querySelector('.module-title-wrapper');
                const icon = container.querySelector('.module-icon');
                const title = container.querySelector('.module-title');
                const btn = container.querySelector('.module-btn');
                if (icon) icon.classList.add('animated');
                if (title) title.classList.add('animated');
                if (titleWrapper) titleWrapper.classList.add('animated');
                if (btn) btn.classList.add('animated');
            };

            // 卡片动画 - 合并延迟，减少setTimeout嵌套
            const animateCards = (container) => {
                const cards = container.querySelectorAll('.card-animate');
                cards.forEach((card, index) => {
                    // 用 requestAnimationFrame 替代 setTimeout，避免主线程阻塞
                    requestAnimationFrame(() => {
                        setTimeout(() => {
                            card.classList.add('visible');
                            // 文字动画直接批量触发，减少嵌套setTimeout
                            const textElements = card.querySelectorAll('.text-reveal');
                            textElements.forEach((el, i) => {
                                el.classList.add('animated');
                            });
                        }, index * 60); // 降低延迟间隔，减少长任务
                    });
                });
            };

            const observerOptions = {
                root: null,
                rootMargin: '100px 0px', // 提前100px触发动画，避免进入视口时卡顿
                threshold: 0.05 // 降低触发阈值，减少计算量
            };

            const moduleObserver = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const container = entry.target;
                        animateModuleHeader(container);
                        animateCards(container);
                        moduleObserver.unobserve(container); // 只触发一次
                    }
                });
            }, observerOptions);

            // 观察所有模块
            document.querySelectorAll('.module-container').forEach(module => {
                moduleObserver.observe(module);
            });

            // 首次加载动画（合并执行，避免重复计算）
            requestAnimationFrame(() => {
                document.querySelectorAll('.module-container').forEach(module => {
                    const rect = module.getBoundingClientRect();
                    if (rect.top < window.innerHeight && rect.bottom > 0) {
                        animateModuleHeader(module);
                        animateCards(module);
                        moduleObserver.unobserve(module);
                    }
                });
            });
        })();
        // ==================== 鼠标跟随3D倾斜效果（优化版，带节流） ====================
        (function () {
            const cards = document.querySelectorAll('.org-card-h, .act-card, .recruit-card');
            let ticking = false;

            cards.forEach(card => {
                // 提前获取元素尺寸，避免每次读取布局
                let rect;
                let centerX, centerY;

                const updateCardTransform = (x, y) => {
                    const rotateX = (y - centerY) / 25; // 降低倾斜强度，减少GPU计算
                    const rotateY = (centerX - x) / 25;
                    // 只使用 transform，不触发布局重排
                    card.style.transform = `translateY(-8px) rotateX(${rotateX}deg) rotateY(${rotateY}deg)`;
                };

                const handleMouseMove = (e) => {
                    if (!ticking) {
                        window.requestAnimationFrame(() => {
                            if (!rect) rect = card.getBoundingClientRect();
                            centerX = rect.width / 2;
                            centerY = rect.height / 2;

                            const x = e.clientX - rect.left;
                            const y = e.clientY - rect.top;
                            updateCardTransform(x, y);
                            ticking = false;
                        });
                        ticking = true;
                    }
                };

                card.addEventListener('mousemove', handleMouseMove, { passive: true });
                card.addEventListener('mouseleave', function () {
                    // 直接重置，不做过渡，避免额外动画开销
                    card.style.transform = '';
                    rect = null; // 释放缓存
                });
            });
        })();
      
    </script>
      <!-- 时间卡片JS脚本 -->
    <script>
        function updateLiveTime() {
            const now = new Date();
            const hours = String(now.getHours()).padStart(2, '0');
            const minutes = String(now.getMinutes()).padStart(2, '0');
            const seconds = String(now.getSeconds()).padStart(2, '0');
            document.getElementById('live-time').innerText = `${hours}:${minutes}:${seconds}`;

            let tip = '';
            const h = now.getHours();
            if (h >= 0 && h < 6) {
                tip = "🌙 夜深了，该休息了，别熬坏了身体哦~";
            } else if (h >= 6 && h < 9) {
                tip = "☀️ 早上好，新的一天也要元气满满！";
            } else if (h >= 9 && h < 12) {
                tip = "📚 上午好，学习和工作都加油呀~";
            } else if (h >= 12 && h < 14) {
                tip = "🍽️ 中午啦，记得吃午饭，休息一下吧~";
            } else if (h >= 14 && h < 18) {
                tip = "☕ 下午好，继续为目标努力吧！";
            } else if (h >= 18 && h < 21) {
                tip = "🌆 傍晚好，结束一天的忙碌，放松一下吧~";
            } else if (h >= 21 && h < 24) {
                tip = "🌙 晚上好，别太晚睡，早点休息哦~";
            }
            document.getElementById('time-tip').innerText = tip;
        }
        updateLiveTime();
        setInterval(updateLiveTime, 1000);
    </script>
    <script>
        // ==================== 基础防复制/防查看源码（不影响自己调试） ====================
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


    </script>

   <!-- ==================== 天鹅悬浮反馈按钮（更大、更实体、带动画） ==================== -->
<style>
    /* 天鹅按钮整体容器 - 更大更实体 */
    .swan-feedback-btn {
        position: fixed;
        bottom: 30px;
        right: 28px;
        width: 100px;
        height: 100px;
        z-index: 9999;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        filter: drop-shadow(0 8px 24px rgba(0, 0, 0, 0.4)) drop-shadow(0 0 12px rgba(255, 215, 150, 0.3));
        transition: filter 0.3s ease;
    }

    /* 光晕圆环 - 毛玻璃质感 */
    .swan-glow-ring {
        position: absolute;
        width: 100%;
        height: 100%;
        border-radius: 50%;
        background: rgba(255, 250, 240, 0.08);
        backdrop-filter: blur(12px);
        -webkit-backdrop-filter: blur(12px);
        border: 1.8px solid rgba(255, 220, 150, 0.5);
        box-shadow: 0 8px 28px rgba(0, 0, 0, 0.5), inset 0 1px 2px rgba(255, 240, 180, 0.3);
        transition: all 0.35s cubic-bezier(0.2, 0.9, 0.4, 1.1);
    }

    .swan-feedback-btn:hover .swan-glow-ring {
        border-color: rgba(255, 200, 120, 0.9);
        box-shadow: 0 12px 32px rgba(0, 0, 0, 0.6), 0 0 28px rgba(255, 200, 100, 0.4);
        transform: scale(1.06);
    }

    /* 天鹅SVG容器动画 (整体浮动) */
    .swan-svg-wrapper {
        position: relative;
        width: 92px;
        height: 92px;
        z-index: 2;
        animation: swanFloat 3.2s ease-in-out infinite;
        filter: drop-shadow(0 4px 10px rgba(0,0,0,0.3));
    }

    .swan-svg {
        width: 100%;
        height: 100%;
        display: block;
    }

    /* 翅膀扇动关键帧 */
    @keyframes wingFlap {
        0% { transform: rotate(-8deg) scaleY(1); }
        50% { transform: rotate(18deg) scaleY(0.98); }
        100% { transform: rotate(-8deg) scaleY(1); }
    }

    /* 头部轻微摇摆 */
    @keyframes headBob {
        0%, 100% { transform: translateY(0px) rotate(0deg); }
        50% { transform: translateY(-1.2px) rotate(1.5deg); }
    }

    /* 水波荡漾 */
    @keyframes rippleWaves {
        0% { opacity: 0.3; transform: scaleX(0.95) scaleY(0.9); }
        100% { opacity: 0.7; transform: scaleX(1.05) scaleY(1.1); }
    }

    @keyframes swanFloat {
        0%, 100% { transform: translateY(0px); }
        50% { transform: translateY(-7px); }
    }

    .wing-animation {
        transform-origin: 58px 68px;
        animation: wingFlap 1.9s ease-in-out infinite;
    }

    .head-animation {
        transform-origin: 36px 44px;
        animation: headBob 2.4s ease-in-out infinite;
    }

    .water-ripple {
        animation: rippleWaves 2.5s alternate infinite ease-in-out;
        transform-origin: 50px 72px;
    }

    /* 气泡提示框 */
    .swan-bubble {
        position: fixed;
        bottom: 120px;
        right: 40px;
        z-index: 9998;
        background: rgba(30, 35, 55, 0.75);
        backdrop-filter: blur(12px);
        -webkit-backdrop-filter: blur(12px);
        border: 1px solid rgba(255, 215, 150, 0.4);
        border-radius: 28px;
        padding: 8px 18px;
        color: #fff4e0;
        font-size: 13px;
        font-weight: 500;
        white-space: nowrap;
        pointer-events: none;
        letter-spacing: 0.5px;
        animation: bubbleFade 0.5s ease, bubbleSoftPulse 2s infinite;
    }

    .swan-bubble::after {
        content: '';
        position: absolute;
        bottom: -7px;
        right: 28px;
        width: 12px;
        height: 12px;
        background: rgba(30, 35, 55, 0.75);
        border-right: 1px solid rgba(255, 215, 150, 0.4);
        border-bottom: 1px solid rgba(255, 215, 150, 0.4);
        transform: rotate(45deg);
        backdrop-filter: blur(10px);
    }

    @keyframes bubbleSoftPulse {
        0%, 100% { opacity: 0.85; transform: scale(1); }
        50% { opacity: 1; transform: scale(1.02); text-shadow: 0 0 3px rgba(255,215,150,0.6); }
    }

    @keyframes bubbleFade {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }

    /* 弹窗样式（天鹅主题） */
    .fb-modal-overlay {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(0, 0, 0, 0.6);
        backdrop-filter: blur(6px);
        z-index: 10000;
        display: none;
        align-items: center;
        justify-content: center;
        animation: fadeIn 0.25s ease;
    }

    .fb-modal-overlay.show {
        display: flex;
    }

    .fb-modal-card {
        width: 420px;
        max-width: 90vw;
        padding: 28px;
        background: rgba(18, 22, 40, 0.85);
        backdrop-filter: blur(28px);
        -webkit-backdrop-filter: blur(28px);
        border: 1px solid rgba(255, 215, 150, 0.35);
        border-radius: 28px;
        box-shadow: 0 25px 50px rgba(0, 0, 0, 0.5), 0 0 0 1px rgba(255, 215, 150, 0.1);
        animation: modalSlideUp 0.4s cubic-bezier(0.2, 1.2, 0.4, 1);
    }

    @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }

    @keyframes modalSlideUp {
        from {
            opacity: 0;
            transform: translateY(40px) scale(0.96);
        }
        to {
            opacity: 1;
            transform: translateY(0) scale(1);
        }
    }

    .fb-inp {
        width: 100%;
        box-sizing: border-box;
        background: rgba(255, 255, 255, 0.06);
        border: 1px solid rgba(255, 255, 255, 0.15);
        border-radius: 16px;
        color: #fff;
        font-size: 13px;
        padding: 12px 16px;
        outline: none;
        font-family: inherit;
        transition: all 0.2s;
    }

    .fb-inp:focus {
        border-color: #ffc285;
        background: rgba(255, 255, 255, 0.1);
        box-shadow: 0 0 0 2px rgba(255, 194, 133, 0.2);
    }

    .fb-inp::placeholder {
        color: rgba(255, 255, 255, 0.4);
    }

    .fb-tag {
        display: inline-block;
        padding: 6px 18px;
        border-radius: 40px;
        font-size: 13px;
        cursor: pointer;
        transition: all 0.2s;
        background: rgba(255, 255, 255, 0.05);
        border: 1px solid rgba(255, 255, 255, 0.1);
        color: rgba(255, 255, 255, 0.65);
        font-weight: 500;
    }

    .fb-tag.active {
        background: rgba(255, 194, 133, 0.2);
        border-color: #ffc285;
        color: #ffdfb8;
        box-shadow: 0 0 6px rgba(255, 200, 100, 0.3);
    }

    .fb-tag:hover {
        border-color: rgba(255, 194, 133, 0.6);
        color: white;
        background: rgba(255, 194, 133, 0.1);
    }

    .fb-submit-gradient {
        background: linear-gradient(105deg, #f5a97f, #e07a5f);
        transition: all 0.2s;
    }
    .fb-submit-gradient:hover {
        filter: brightness(1.05);
        transform: scale(0.98);
    }
</style>

<!-- 天鹅悬浮按钮 -->
<div id="swanFeedbackBtn" class="swan-feedback-btn" onclick="openFeedbackModal()">
    <div class="swan-glow-ring"></div>
    <div class="swan-svg-wrapper">
        <svg class="swan-svg" viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
            <defs>
                <linearGradient id="swanBodyGrad" x1="20%" y1="20%" x2="80%" y2="80%">
                    <stop offset="0%" stop-color="#ffffff" />
                    <stop offset="70%" stop-color="#f2ede8" />
                    <stop offset="100%" stop-color="#e2dcd5" />
                </linearGradient>
                <linearGradient id="wingGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                    <stop offset="0%" stop-color="#ffffff" />
                    <stop offset="60%" stop-color="#f0ece7" />
                    <stop offset="100%" stop-color="#ddd6ce" />
                </linearGradient>
                <linearGradient id="beakGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                    <stop offset="0%" stop-color="#ff9f5e" />
                    <stop offset="100%" stop-color="#e25c2c" />
                </linearGradient>
                <radialGradient id="cheekGlow" cx="50%" cy="50%" r="50%">
                    <stop offset="0%" stop-color="#ffb7b2" stop-opacity="0.7" />
                    <stop offset="100%" stop-color="#ffb7b2" stop-opacity="0" />
                </radialGradient>
            </defs>
            <!-- 水波纹 -->
            <g class="water-ripple">
                <ellipse cx="49" cy="76" rx="30" ry="11" fill="rgba(255,240,210,0.15)" stroke="rgba(255,220,150,0.3)" stroke-width="0.8" />
                <ellipse cx="49" cy="76" rx="24" ry="8" fill="rgba(255,245,225,0.2)" stroke="rgba(255,220,150,0.2)" stroke-width="0.5" />
            </g>
            <!-- 尾部羽毛 -->
            <path d="M68 68 Q78 63 76 55 Q80 63 74 70 Q82 70 78 76 Q74 73 68 72 Z" fill="#e8e2db" stroke="#d4ccc3" stroke-width="0.5" />
            <!-- 主体 -->
            <ellipse cx="49" cy="66" rx="28" ry="20" fill="url(#swanBodyGrad)" stroke="#cfc6bc" stroke-width="0.7" />
            <path d="M32 69 Q36 78 48 80 Q62 80 66 72 Q62 82 48 84 Q34 82 30 73 Z" fill="rgba(255,252,245,0.7)" />
            <!-- 脖子 -->
            <path d="M42 55 C38 45 36 38 33 32 C30 26 27 24 29 18 C31 14 36 15 38 18 C42 24 44 34 46 44 C48 52 49 56 49 60" fill="url(#swanBodyGrad)" stroke="#cfc6bc" stroke-width="0.8" />
            <path d="M44 54 C42 46 40 40 38 34 L34 30 L37 29 C40 33 44 41 46 50 L47 56 Z" fill="url(#swanBodyGrad)" />
            <!-- 头部 -->
            <circle cx="33" cy="26" r="9" fill="url(#swanBodyGrad)" stroke="#ccc2b8" stroke-width="0.7" />
            <path d="M29 18 Q32 12 37 15 Q33 10 28 15 Z" fill="#f7f0e8" stroke="#d4c4b5" stroke-width="0.5" />
            <path d="M31 17 Q34 11 38 13" stroke="#e2bc96" stroke-width="1.2" fill="none" stroke-linecap="round" />
            <!-- 腮红 -->
            <circle cx="38" cy="30" r="4" fill="url(#cheekGlow)" />
            <circle cx="28" cy="30" r="3.5" fill="url(#cheekGlow)" />
            <!-- 眼睛 -->
            <ellipse cx="30" cy="24" rx="2.5" ry="3.2" fill="#201e1c" />
            <circle cx="29" cy="23" r="1.2" fill="white" />
            <circle cx="31.2" cy="25" r="0.5" fill="white" opacity="0.8" />
            <ellipse cx="36.5" cy="25" rx="2" ry="2.5" fill="#201e1c" />
            <circle cx="36" cy="24" r="0.9" fill="white" />
            <!-- 嘴巴 -->
            <path d="M23 25 L16 23 L22 29 Z" fill="url(#beakGrad)" stroke="#c5461a" stroke-width="0.5" />
            <path d="M16 23 L19.5 26.5" stroke="#ffcc88" stroke-width="0.8" fill="none" />
            <circle cx="19" cy="24.5" r="0.8" fill="#a33e12" />
            <!-- 动态翅膀 -->
            <g class="wing-animation">
                <path d="M48 52 C54 44 66 39 74 46 C78 50 79 58 74 64 C68 70 59 69 52 64 C48 60 46 55 48 52 Z" fill="url(#wingGrad)" stroke="#cdc2b5" stroke-width="0.8" />
                <path d="M52 54 C60 48 70 45 74 52 C76 57 75 62 70 65 C63 68 56 65 52 60 Z" fill="rgba(255,255,245,0.5)" stroke="#d8cdbf" stroke-width="0.6" />
                <path d="M55 56 C62 51 68 49 72 54" stroke="#e5d9ce" stroke-width="1.2" fill="none" stroke-linecap="round" />
                <path d="M53 61 C59 59 66 57 70 62" stroke="#e5d9ce" stroke-width="1" fill="none" stroke-linecap="round" />
                <path d="M70 52 L74 49 L72 55 Z" fill="#fffef9" opacity="0.7" />
            </g>
            <path d="M44 58 C40 54 38 49 41 45 C44 42 48 45 49 49 C48 54 46 56 44 58 Z" fill="#f2ece3" stroke="#d9cdbf" stroke-width="0.5" opacity="0.8" />
            <ellipse cx="48" cy="79" rx="18" ry="5" fill="rgba(255,235,190,0.15)" filter="blur(2px)" />
        </svg>
    </div>
</div>

<!-- 气泡提示 -->
<div id="swanBubble" class="swan-bubble">✨ 天鹅心意，戳我反馈 ✨</div>

<!-- 弹窗遮罩（完全兼容原有逻辑） -->
<div id="fbModalOverlay" class="fb-modal-overlay" onclick="closeFeedbackModal(event)">
    <div class="fb-modal-card" onclick="event.stopPropagation()">
        <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px;">
            <div style="display: flex; align-items: center; gap: 10px;">
                <svg width="26" height="26" viewBox="0 0 30 30" fill="none">
                    <path d="M12 14 C10 9 9 5 11 3 C13 2 15 4 15 8 C15 12 14 16 12 18 Z" fill="#ffc285" opacity="0.7" />
                    <circle cx="15" cy="12" r="8" fill="rgba(255,250,240,0.8)" stroke="#ffc285" stroke-width="1" />
                    <circle cx="13" cy="11" r="1.5" fill="#333" />
                    <path d="M7 10 L3 9 L6 13 Z" fill="#ffa559" />
                </svg>
                <span id="fbModalTitle" style="color:#fff3e5; font-size: 18px; font-weight: 500;">🦢 天鹅倾听·你的声音</span>
            </div>
            <div onclick="closeFeedbackModal()" style="width: 30px; height: 30px; border-radius: 50%; background: rgba(255,255,240,0.08); display: flex; align-items: center; justify-content: center; cursor: pointer; border: 0.5px solid rgba(255,215,150,0.3);">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="rgba(255,235,200,0.7)" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
            </div>
        </div>
        <!-- 未登录提示 -->
        <div id="fbLoginTip" style="display: none; text-align: center; padding: 30px 0;">
            <div style="color: rgba(255,240,220,0.65); font-size: 14px; margin-bottom: 18px;">🦢 请先登录，天鹅才能带着你的心意飞向管理员 ~</div>
            <a href="Account/Login.aspx" style="display: inline-block; padding: 10px 32px; border-radius: 40px; background: linear-gradient(95deg, #ffb27a, #e9673b); color: #fff; text-decoration: none; font-size: 14px; font-weight: 500; box-shadow: 0 4px 12px rgba(0,0,0,0.2);">去登录</a>
        </div>
        <!-- 反馈表单 -->
        <div id="fbFormArea">
            <div style="margin-bottom: 16px;">
                <div style="color: rgba(255,250,235,0.6); font-size: 13px; margin-bottom: 10px; font-weight: 500;">我想说</div>
                <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                    <span class="fb-tag active" onclick="selectTag(this)">功能建议</span>
                    
                </div>
            </div>
            <div style="margin-bottom: 16px;">
                <textarea id="fbContent" class="fb-inp" rows="4" placeholder="写下你的想法，天鹅会为你转达..." style="height: 100px; resize: none;"></textarea>
            </div>
            <div style="margin-bottom: 22px;">
                <input id="fbContact" class="fb-inp" placeholder="📮 QQ / 邮箱（方便我回复你~）" />
            </div>
            <div style="display: flex; gap: 12px;">
                <div onclick="closeFeedbackModal()" style="flex: 1; height: 44px; border-radius: 40px; background: rgba(255,255,245,0.06); border: 0.5px solid rgba(255,215,150,0.3); display: flex; align-items: center; justify-content: center; color: rgba(255,240,215,0.7); font-size: 13px; cursor: pointer;">先不说了</div>
                <div id="fbSubmitBtn" onclick="submitFeedback()" style="flex: 2; height: 44px; border-radius: 40px; background: linear-gradient(100deg, #f0a06b, #e35f3a); display: flex; align-items: center; justify-content: center; color: #fff; font-size: 15px; font-weight: 600; cursor: pointer; box-shadow: 0 4px 10px rgba(0,0,0,0.2);">📨 发送 ~ 天鹅传信</div>
            </div>
            <div style="text-align: center; margin-top: 18px; color: rgba(255,245,210,0.25); font-size: 11px;">管理员会认真查看每一条心声✨</div>
        </div>
    </div>
</div>

<script>
    var selectedType = '功能建议';
    function selectTag(el) {
        document.querySelectorAll('.fb-tag').forEach(function (t) { t.classList.remove('active'); });
        el.classList.add('active');
        selectedType = el.textContent.trim();
    }

    function openFeedbackModal() {
        var overlay = document.getElementById('fbModalOverlay');
        overlay.classList.add('show');
        var tip = document.getElementById('fbLoginTip');
        var form = document.getElementById('fbFormArea');
        // 检查登录状态（沿用页面 body 上的 data-loggedin 属性）
        var isLoggedIn = document.body.getAttribute('data-loggedin') === 'true';
        if (isLoggedIn) {
            tip.style.display = 'none';
            form.style.display = 'block';
            document.getElementById('fbModalTitle').textContent = '🦢 天鹅倾听·你的声音';
        } else {
            tip.style.display = 'block';
            form.style.display = 'none';
            document.getElementById('fbModalTitle').textContent = '🦢 请先登录呀~';
        }
    }

    function closeFeedbackModal(e) {
        if (e && e.target !== e.currentTarget) return;
        document.getElementById('fbModalOverlay').classList.remove('show');
    }

    function submitFeedback() {
        var content = document.getElementById('fbContent').value.trim();
        if (!content) {
            alert("🦢 写一些想说的话吧 ~ 天鹅等着呢");
            return;
        }
        var contact = document.getElementById('fbContact').value.trim();
        var btn = document.getElementById('fbSubmitBtn');
        var originalText = btn.innerHTML;
        btn.innerHTML = "✈️ 发送中...";
        btn.style.opacity = "0.7";
        btn.style.pointerEvents = "none";

        // 模拟 AJAX 提交（保留原有 SubmitFeedback.ashx 逻辑）
        var xhr = new XMLHttpRequest();
        xhr.open('POST', 'SubmitFeedback.ashx', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onload = function () {
            btn.innerHTML = originalText;
            btn.style.opacity = "1";
            btn.style.pointerEvents = "auto";
            if (xhr.status === 200) {
                alert('✨ 已收到！优雅天鹅会把你的心意带给管理员 ✨\n感谢你的反馈~ 🦢');
                closeFeedbackModal();
                document.getElementById('fbContent').value = '';
                document.getElementById('fbContact').value = '';
                document.querySelectorAll('.fb-tag').forEach(function (t, i) {
                    t.classList.toggle('active', i === 0);
                });
                selectedType = '功能建议';
            } else {
                alert('发送失败，请稍后重试 ~');
            }
        };
        xhr.onerror = function () {
            btn.innerHTML = originalText;
            btn.style.opacity = "1";
            btn.style.pointerEvents = "auto";
            alert('网络错误，请稍后重试 ~');
        };
        xhr.send('type=' + encodeURIComponent(selectedType) + '&content=' + encodeURIComponent(content) + '&contact=' + encodeURIComponent(contact));
    }

    // 给天鹅按钮增加点击翅膀加速反馈效果
    var swanBtn = document.getElementById('swanFeedbackBtn');
    if (swanBtn) {
        swanBtn.addEventListener('click', function (e) {
            var wing = document.querySelector('.wing-animation');
            if (wing) {
                wing.style.animation = 'none';
                wing.offsetHeight;
                wing.style.animation = 'wingFlap 0.6s ease-in-out 2';
                setTimeout(function () {
                    wing.style.animation = 'wingFlap 1.9s ease-in-out infinite';
                }, 700);
            }
            var bubbleTip = document.getElementById('swanBubble');
            if (bubbleTip) {
                bubbleTip.style.transform = 'scale(1.1)';
                setTimeout(function () { bubbleTip.style.transform = 'scale(1)'; }, 200);
            }
        });
    }
</script>
    
</asp:Content>