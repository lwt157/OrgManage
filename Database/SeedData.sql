-- =============================================
-- 高校组织综合线上管理平台 - 初始数据脚本
-- 包含：分类、敏感词、系统配置
-- =============================================

USE [OrgManageDB];
GO

-- ---------------------------------------------
-- 表: OrgCategories (4 条数据)
-- ---------------------------------------------
INSERT INTO [OrgCategories] ([CategoryID], [CategoryName], [Description]) VALUES (1, '校级组织', '校级职能型组织，由校级管理层（role=4）审核');
INSERT INTO [OrgCategories] ([CategoryID], [CategoryName], [Description]) VALUES (2, '院级组织', '院级职能型组织，由系统管理员（role=5）审核');
INSERT INTO [OrgCategories] ([CategoryID], [CategoryName], [Description]) VALUES (3, '校级社团', '校级跨学院社团，由校级管理层（role=4）审核');
INSERT INTO [OrgCategories] ([CategoryID], [CategoryName], [Description]) VALUES (4, '院级社团', '院级学生社团，由系统管理员（role=5）审核');
GO

-- ---------------------------------------------
-- 表: SensitiveWords (91 条数据)
-- ---------------------------------------------
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (1, '傻逼', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (2, '傻比', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (3, '脑残', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (4, '智障', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (5, '废物', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (6, '垃圾', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (7, '菜鸡', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (8, '狗东西', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (9, '去死', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (10, '滚蛋', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (11, '贱人', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (12, '婊子', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (13, '渣男', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (14, '渣女', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (15, '舔狗', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (16, '屌丝', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (17, '穷鬼', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (18, '土狗', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (19, '小黑子', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (20, '下头', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (21, '色情', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (22, '自慰', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (23, '约炮', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (24, '开房', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (25, '裸聊', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (26, '暧昧', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (27, '一夜情', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (28, '情趣', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (29, '少妇', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (30, '嫩模', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (31, '福利姬', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (32, '擦边', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (33, '赌博', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (34, '赌钱', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (35, '麻将赌博', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (36, '线上赌场', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (37, '网贷', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (38, '高利贷', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (39, '刷单', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (40, '跑分', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (41, '兼职刷单', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (42, '返利', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (43, '杀猪盘', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (44, '充值上分', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (45, '毒品', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (46, '冰毒', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (47, '大麻', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (48, '摇头丸', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (49, '嗑药', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (50, '吸毒', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (51, '烟油', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (52, '上头', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (53, '打架', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (54, '砍人', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (55, '弄死', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (56, '威胁', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (57, '校园霸凌', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (58, '围堵', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (59, '报复', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (60, '揍你', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (61, '台独', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (62, '港独', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (63, '分裂', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (64, '反动', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (65, '邪教', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (66, '法轮功', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (67, '抹黑国家', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (68, '造谣时政', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (69, '系统管理员', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (70, '超级管理员', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (71, '校长', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (72, '书记', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (73, '主任', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (74, '教务处', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (75, '校领导', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (76, '破解', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (77, '外挂', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (78, '盗号', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (79, '代刷', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (80, '代考', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (81, '替考', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (82, '作弊答案', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (83, '入侵', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (84, '老六', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (85, '牛马', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (86, '阴沟', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (87, '耗子尾汁', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (88, '绝绝子', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (89, 'yyds', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (90, '破防', '**', 1);
INSERT INTO [SensitiveWords] ([WordID], [Word], [Replacement], [IsActive]) VALUES (91, 'emo', '**', 1);
GO

-- ---------------------------------------------
-- 表: SystemConfig (2 条数据)
-- ---------------------------------------------
INSERT INTO [SystemConfig] ([ConfigID], [ConfigKey], [ConfigValue], [ConfigDesc], [UpdateTime]) VALUES (1, 'SystemLogo', '/images/logo_73389558.png', '系统顶部左上角LOGO', '2026-05-13 22:13:30');
INSERT INTO [SystemConfig] ([ConfigID], [ConfigKey], [ConfigValue], [ConfigDesc], [UpdateTime]) VALUES (2, 'SystemName', '高校组织综合线上管理平台', '系统名称', '2026-05-14 11:08:14');
GO


