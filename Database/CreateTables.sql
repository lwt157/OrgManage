-- =============================================
-- 高校组织综合线上管理平台 - 数据库建表脚本
-- Database: OrgManageDB
-- Generated: 2026-08-30
-- =============================================

USE [master];
GO

-- 创建数据库（如需要）
-- CREATE DATABASE [OrgManageDB];
-- GO

USE [OrgManageDB];
GO

-- ---------------------------------------------
-- 表: Activities
-- ---------------------------------------------
IF OBJECT_ID('[Activities]', 'U') IS NOT NULL
    DROP TABLE [Activities];
GO

CREATE TABLE [Activities] (
    [ActivityID] int IDENTITY(1,1) NOT NULL,
    [OrgID] int NOT NULL,
    [Title] nvarchar(200) NOT NULL,
    [Description] nvarchar(MAX) NULL,
    [Location] nvarchar(200) NULL,
    [StartTime] datetime NOT NULL,
    [EndTime] datetime NOT NULL,
    [MaxEnroll] int NULL DEFAULT ((0)),
    [CoverUrl] nvarchar(300) NULL,
    [VenueID] int NULL,
    [Status] tinyint NOT NULL DEFAULT ((0)),
    [ApproveBy] int NULL,
    [ApproveTime] datetime NULL,
    [ApproveNote] nvarchar(500) NULL,
    [CreateBy] int NOT NULL,
    [CreateTime] datetime NOT NULL DEFAULT (getdate()),
    [ParticipationScope] tinyint NOT NULL DEFAULT ((0)),
    CONSTRAINT [PK_Activities] PRIMARY KEY CLUSTERED ([ActivityID])
);
GO

-- ---------------------------------------------
-- 表: ActivityEnrollments
-- ---------------------------------------------
IF OBJECT_ID('[ActivityEnrollments]', 'U') IS NOT NULL
    DROP TABLE [ActivityEnrollments];
GO

CREATE TABLE [ActivityEnrollments] (
    [EnrollID] int IDENTITY(1,1) NOT NULL,
    [ActivityID] int NOT NULL,
    [UserID] int NOT NULL,
    [Status] bit NOT NULL DEFAULT ((1)),
    [EnrollTime] datetime NOT NULL DEFAULT (getdate()),
    CONSTRAINT [PK_ActivityEnrollments] PRIMARY KEY CLUSTERED ([EnrollID])
);
GO

-- ---------------------------------------------
-- 表: Announcements
-- ---------------------------------------------
IF OBJECT_ID('[Announcements]', 'U') IS NOT NULL
    DROP TABLE [Announcements];
GO

CREATE TABLE [Announcements] (
    [AnnID] int IDENTITY(1,1) NOT NULL,
    [Title] nvarchar(200) NOT NULL,
    [Content] nvarchar(MAX) NULL,
    [PublishBy] int NOT NULL,
    [IsTop] bit NOT NULL DEFAULT ((0)),
    [IsActive] bit NOT NULL DEFAULT ((1)),
    [CreateTime] datetime NOT NULL DEFAULT (getdate()),
    CONSTRAINT [PK_Announcements] PRIMARY KEY CLUSTERED ([AnnID])
);
GO

-- ---------------------------------------------
-- 表: Applications
-- ---------------------------------------------
IF OBJECT_ID('[Applications]', 'U') IS NOT NULL
    DROP TABLE [Applications];
GO

CREATE TABLE [Applications] (
    [AppID] int IDENTITY(1,1) NOT NULL,
    [RecruitID] int NOT NULL,
    [OrgID] int NOT NULL,
    [UserID] int NOT NULL,
    [SelfIntro] nvarchar(1000) NULL,
    [Reason] nvarchar(500) NULL,
    [Status] tinyint NOT NULL DEFAULT ((0)),
    [ReviewNote] nvarchar(300) NULL,
    [ReviewBy] int NULL,
    [ReviewTime] datetime NULL,
    [ApplyTime] datetime NOT NULL DEFAULT (getdate()),
    CONSTRAINT [PK_Applications] PRIMARY KEY CLUSTERED ([AppID])
);
GO

-- ---------------------------------------------
-- 表: BackupRecords
-- ---------------------------------------------
IF OBJECT_ID('[BackupRecords]', 'U') IS NOT NULL
    DROP TABLE [BackupRecords];
GO

CREATE TABLE [BackupRecords] (
    [BackupID] int IDENTITY(1,1) NOT NULL,
    [BackupType] nvarchar(50) NULL,
    [FileName] nvarchar(200) NULL,
    [FilePath] nvarchar(500) NULL,
    [OperatorID] int NULL,
    [BackupTime] datetime NULL DEFAULT (getdate()),
    CONSTRAINT [PK_BackupRecords] PRIMARY KEY CLUSTERED ([BackupID])
);
GO

-- ---------------------------------------------
-- 表: Feedbacks
-- ---------------------------------------------
IF OBJECT_ID('[Feedbacks]', 'U') IS NOT NULL
    DROP TABLE [Feedbacks];
GO

CREATE TABLE [Feedbacks] (
    [FeedbackID] int IDENTITY(1,1) NOT NULL,
    [UserID] int NOT NULL,
    [Content] nvarchar(1000) NOT NULL,
    [Status] tinyint NULL DEFAULT ((0)),
    [ReplyBy] int NULL,
    [ReplyTime] datetime NULL,
    [CreateTime] datetime NULL DEFAULT (getdate()),
    [Type] nvarchar(20) NULL,
    [Contact] nvarchar(100) NULL,
    CONSTRAINT [PK_Feedbacks] PRIMARY KEY CLUSTERED ([FeedbackID])
);
GO

-- ---------------------------------------------
-- 表: InviteKeys
-- ---------------------------------------------
IF OBJECT_ID('[InviteKeys]', 'U') IS NOT NULL
    DROP TABLE [InviteKeys];
GO

CREATE TABLE [InviteKeys] (
    [KeyID] int IDENTITY(1,1) NOT NULL,
    [KeyCode] nvarchar(50) NOT NULL,
    [TargetRole] tinyint NOT NULL,
    [IsUsed] bit NOT NULL DEFAULT ((0)),
    [ExpireDate] datetime NULL DEFAULT (dateadd(day,(7),getdate())),
    [CreatedBy] int NULL,
    [CreatedTime] datetime NOT NULL DEFAULT (getdate()),
    [UsedBy] int NULL,
    [UsedTime] datetime NULL,
    CONSTRAINT [PK_InviteKeys] PRIMARY KEY CLUSTERED ([KeyID])
);
GO

-- ---------------------------------------------
-- 表: LoginLogs
-- ---------------------------------------------
IF OBJECT_ID('[LoginLogs]', 'U') IS NOT NULL
    DROP TABLE [LoginLogs];
GO

CREATE TABLE [LoginLogs] (
    [LogID] int IDENTITY(1,1) NOT NULL,
    [UserID] int NOT NULL,
    [LoginName] nvarchar(50) NULL,
    [IPAddress] nvarchar(50) NULL,
    [UserAgent] nvarchar(300) NULL,
    [LoginTime] datetime NULL DEFAULT (getdate()),
    [Result] bit NULL DEFAULT ((1)),
    CONSTRAINT [PK_LoginLogs] PRIMARY KEY CLUSTERED ([LogID])
);
GO

-- ---------------------------------------------
-- 表: Notifications
-- ---------------------------------------------
IF OBJECT_ID('[Notifications]', 'U') IS NOT NULL
    DROP TABLE [Notifications];
GO

CREATE TABLE [Notifications] (
    [NotifyID] int IDENTITY(1,1) NOT NULL,
    [ToUserID] int NOT NULL,
    [FromUserID] int NULL,
    [Type] tinyint NOT NULL DEFAULT ((1)),
    [Title] nvarchar(200) NOT NULL,
    [Content] nvarchar(1000) NULL,
    [IsRead] bit NOT NULL DEFAULT ((0)),
    [RelatedID] int NULL,
    [CreateTime] datetime NOT NULL DEFAULT (getdate()),
    CONSTRAINT [PK_Notifications] PRIMARY KEY CLUSTERED ([NotifyID])
);
GO

-- ---------------------------------------------
-- 表: OperationLogs
-- ---------------------------------------------
IF OBJECT_ID('[OperationLogs]', 'U') IS NOT NULL
    DROP TABLE [OperationLogs];
GO

CREATE TABLE [OperationLogs] (
    [LogID] int IDENTITY(1,1) NOT NULL,
    [OperatorID] int NOT NULL,
    [OperatorName] nvarchar(50) NULL,
    [ActionType] nvarchar(50) NULL,
    [TargetType] nvarchar(50) NULL,
    [TargetID] int NULL,
    [Detail] nvarchar(1000) NULL,
    [IPAddress] nvarchar(50) NULL,
    [LogTime] datetime NULL DEFAULT (getdate()),
    CONSTRAINT [PK_OperationLogs] PRIMARY KEY CLUSTERED ([LogID])
);
GO

-- ---------------------------------------------
-- 表: Organizations
-- ---------------------------------------------
IF OBJECT_ID('[Organizations]', 'U') IS NOT NULL
    DROP TABLE [Organizations];
GO

CREATE TABLE [Organizations] (
    [OrgID] int IDENTITY(1,1) NOT NULL,
    [OrgName] nvarchar(100) NOT NULL,
    [CategoryID] int NOT NULL,
    [Description] nvarchar(2000) NULL,
    [LogoUrl] nvarchar(300) NULL,
    [FoundedDate] date NULL,
    [MaxMembers] int NULL DEFAULT ((50)),
    [ContactInfo] nvarchar(200) NULL,
    [AdvisorID] int NULL,
    [LeaderID] int NULL,
    [Status] tinyint NOT NULL DEFAULT ((0)),
    [ApproveTime] datetime NULL,
    [ApproverID] int NULL,
    [ApproveNote] nvarchar(500) NULL,
    [CreateTime] datetime NOT NULL DEFAULT (getdate()),
    [AuditorRole] int NULL,
    [College] nvarchar(100) NULL,
    CONSTRAINT [PK_Organizations] PRIMARY KEY CLUSTERED ([OrgID])
);
GO

-- ---------------------------------------------
-- 表: OrgAnnouncements
-- ---------------------------------------------
IF OBJECT_ID('[OrgAnnouncements]', 'U') IS NOT NULL
    DROP TABLE [OrgAnnouncements];
GO

CREATE TABLE [OrgAnnouncements] (
    [AnnouncementID] int IDENTITY(1,1) NOT NULL,
    [OrgID] int NULL,
    [Title] nvarchar(200) NULL,
    [Content] ntext NULL,
    [PublisherID] int NULL,
    [PublishTime] datetime NULL DEFAULT (getdate()),
    CONSTRAINT [PK_OrgAnnouncements] PRIMARY KEY CLUSTERED ([AnnouncementID])
);
GO

-- ---------------------------------------------
-- 表: OrgCategories
-- ---------------------------------------------
IF OBJECT_ID('[OrgCategories]', 'U') IS NOT NULL
    DROP TABLE [OrgCategories];
GO

CREATE TABLE [OrgCategories] (
    [CategoryID] int IDENTITY(1,1) NOT NULL,
    [CategoryName] nvarchar(50) NOT NULL,
    [Description] nvarchar(200) NULL,
    CONSTRAINT [PK_OrgCategories] PRIMARY KEY CLUSTERED ([CategoryID])
);
GO

-- ---------------------------------------------
-- 表: OrgDeleteLogs
-- ---------------------------------------------
IF OBJECT_ID('[OrgDeleteLogs]', 'U') IS NOT NULL
    DROP TABLE [OrgDeleteLogs];
GO

CREATE TABLE [OrgDeleteLogs] (
    [LogID] int IDENTITY(1,1) NOT NULL,
    [OrgID] int NOT NULL,
    [OrgName] nvarchar(100) NOT NULL,
    [DeleteReason] nvarchar(500) NOT NULL,
    [DeleteBy] int NOT NULL,
    [DeleteTime] datetime NULL DEFAULT (getdate()),
    CONSTRAINT [PK_OrgDeleteLogs] PRIMARY KEY CLUSTERED ([LogID])
);
GO

-- ---------------------------------------------
-- 表: OrgDisbandRequests
-- ---------------------------------------------
IF OBJECT_ID('[OrgDisbandRequests]', 'U') IS NOT NULL
    DROP TABLE [OrgDisbandRequests];
GO

CREATE TABLE [OrgDisbandRequests] (
    [RequestID] int IDENTITY(1,1) NOT NULL,
    [OrgID] int NOT NULL,
    [RequestUserID] int NOT NULL,
    [Reason] nvarchar(500) NOT NULL,
    [RequestTime] datetime NULL DEFAULT (getdate()),
    [Status] int NOT NULL DEFAULT ((0)),
    [CreateTime] datetime NULL DEFAULT (getdate()),
    CONSTRAINT [PK_OrgDisbandRequests] PRIMARY KEY CLUSTERED ([RequestID])
);
GO

-- ---------------------------------------------
-- 表: OrgFavorites
-- ---------------------------------------------
IF OBJECT_ID('[OrgFavorites]', 'U') IS NOT NULL
    DROP TABLE [OrgFavorites];
GO

CREATE TABLE [OrgFavorites] (
    [FavID] int IDENTITY(1,1) NOT NULL,
    [UserID] int NOT NULL,
    [OrgID] int NOT NULL,
    [FavTime] datetime NOT NULL DEFAULT (getdate()),
    CONSTRAINT [PK_OrgFavorites] PRIMARY KEY CLUSTERED ([FavID])
);
GO

-- ---------------------------------------------
-- 表: OrgMembers
-- ---------------------------------------------
IF OBJECT_ID('[OrgMembers]', 'U') IS NOT NULL
    DROP TABLE [OrgMembers];
GO

CREATE TABLE [OrgMembers] (
    [MemberID] int IDENTITY(1,1) NOT NULL,
    [OrgID] int NOT NULL,
    [UserID] int NOT NULL,
    [MemberRole] tinyint NOT NULL DEFAULT ((1)),
    [JoinDate] date NOT NULL DEFAULT (CONVERT([date],getdate(),0)),
    [QuitDate] date NULL,
    [Status] bit NOT NULL DEFAULT ((1)),
    [Remark] nvarchar(200) NULL,
    [StudentNo] nvarchar(50) NULL,
    [UserName] nvarchar(100) NULL,
    [College] nvarchar(100) NULL,
    CONSTRAINT [PK_OrgMembers] PRIMARY KEY CLUSTERED ([MemberID])
);
GO

-- ---------------------------------------------
-- 表: RecruitApps
-- ---------------------------------------------
IF OBJECT_ID('[RecruitApps]', 'U') IS NOT NULL
    DROP TABLE [RecruitApps];
GO

CREATE TABLE [RecruitApps] (
    [AppID] int IDENTITY(1,1) NOT NULL,
    [RecruitID] int NOT NULL,
    [UserID] int NOT NULL,
    [SelfIntro] nvarchar(MAX) NULL,
    [ApplyTime] datetime NULL DEFAULT (getdate()),
    [Status] int NULL DEFAULT ((0)),
    [OrgID] int NULL,
    [Reason] nvarchar(500) NULL,
    [ReviewNote] nvarchar(300) NULL,
    CONSTRAINT [PK_RecruitApps] PRIMARY KEY CLUSTERED ([AppID])
);
GO

-- ---------------------------------------------
-- 表: Recruitments
-- ---------------------------------------------
IF OBJECT_ID('[Recruitments]', 'U') IS NOT NULL
    DROP TABLE [Recruitments];
GO

CREATE TABLE [Recruitments] (
    [RecruitID] int IDENTITY(1,1) NOT NULL,
    [OrgID] int NOT NULL,
    [Title] nvarchar(200) NOT NULL,
    [Content] nvarchar(MAX) NULL,
    [Requirements] nvarchar(1000) NULL,
    [Quota] int NULL DEFAULT ((0)),
    [StartDate] datetime NOT NULL,
    [EndDate] datetime NOT NULL,
    [Status] tinyint NOT NULL DEFAULT ((1)),
    [CreateBy] int NOT NULL,
    [CreateTime] datetime NOT NULL DEFAULT (getdate()),
    CONSTRAINT [PK_Recruitments] PRIMARY KEY CLUSTERED ([RecruitID])
);
GO

-- ---------------------------------------------
-- 表: SensitiveWords
-- ---------------------------------------------
IF OBJECT_ID('[SensitiveWords]', 'U') IS NOT NULL
    DROP TABLE [SensitiveWords];
GO

CREATE TABLE [SensitiveWords] (
    [WordID] int IDENTITY(1,1) NOT NULL,
    [Word] nvarchar(50) NOT NULL,
    [Replacement] nvarchar(50) NULL DEFAULT (N'**'),
    [IsActive] bit NULL DEFAULT ((1)),
    CONSTRAINT [PK_SensitiveWords] PRIMARY KEY CLUSTERED ([WordID])
);
GO

-- ---------------------------------------------
-- 表: SystemConfig
-- ---------------------------------------------
IF OBJECT_ID('[SystemConfig]', 'U') IS NOT NULL
    DROP TABLE [SystemConfig];
GO

CREATE TABLE [SystemConfig] (
    [ConfigID] int IDENTITY(1,1) NOT NULL,
    [ConfigKey] nvarchar(100) NOT NULL,
    [ConfigValue] nvarchar(MAX) NULL,
    [ConfigDesc] nvarchar(200) NULL,
    [UpdateTime] datetime NULL DEFAULT (getdate()),
    CONSTRAINT [PK_SystemConfig] PRIMARY KEY CLUSTERED ([ConfigID])
);
GO

-- ---------------------------------------------
-- 表: UserAppeals
-- ---------------------------------------------
IF OBJECT_ID('[UserAppeals]', 'U') IS NOT NULL
    DROP TABLE [UserAppeals];
GO

CREATE TABLE [UserAppeals] (
    [AppealID] int IDENTITY(1,1) NOT NULL,
    [UserID] int NOT NULL,
    [Content] nvarchar(1000) NOT NULL,
    [Status] tinyint NULL DEFAULT ((0)),
    [ReplyContent] nvarchar(1000) NULL,
    [HandleBy] int NULL,
    [HandleTime] datetime NULL,
    [CreateTime] datetime NULL DEFAULT (getdate()),
    CONSTRAINT [PK_UserAppeals] PRIMARY KEY CLUSTERED ([AppealID])
);
GO

-- ---------------------------------------------
-- 表: UserMessages
-- ---------------------------------------------
IF OBJECT_ID('[UserMessages]', 'U') IS NOT NULL
    DROP TABLE [UserMessages];
GO

CREATE TABLE [UserMessages] (
    [MsgID] int IDENTITY(1,1) NOT NULL,
    [UserID] int NOT NULL,
    [Title] nvarchar(100) NOT NULL,
    [Content] nvarchar(500) NOT NULL,
    [IsRead] bit NOT NULL DEFAULT ((0)),
    [IsDeleted] bit NOT NULL DEFAULT ((0)),
    [CreateTime] datetime NOT NULL DEFAULT (getdate()),
    CONSTRAINT [PK_UserMessages] PRIMARY KEY CLUSTERED ([MsgID])
);
GO

-- ---------------------------------------------
-- 表: Users
-- ---------------------------------------------
IF OBJECT_ID('[Users]', 'U') IS NOT NULL
    DROP TABLE [Users];
GO

CREATE TABLE [Users] (
    [UserID] int IDENTITY(1,1) NOT NULL,
    [StudentNo] nvarchar(20) NOT NULL,
    [UserName] nvarchar(50) NOT NULL,
    [LoginName] nvarchar(50) NOT NULL,
    [PasswordHash] nvarchar(256) NOT NULL,
    [Role] tinyint NOT NULL DEFAULT ((1)),
    [Email] nvarchar(100) NULL,
    [Phone] nvarchar(20) NULL,
    [College] nvarchar(100) NULL,
    [AvatarUrl] nvarchar(300) NULL,
    [IsActive] bit NOT NULL DEFAULT ((1)),
    [CreateTime] datetime NOT NULL DEFAULT (getdate()),
    [LastLogin] datetime NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([UserID])
);
GO

-- ---------------------------------------------
-- 表: VenueReservations
-- ---------------------------------------------
IF OBJECT_ID('[VenueReservations]', 'U') IS NOT NULL
    DROP TABLE [VenueReservations];
GO

CREATE TABLE [VenueReservations] (
    [ResvID] int IDENTITY(1,1) NOT NULL,
    [VenueID] int NOT NULL,
    [ActivityID] int NULL,
    [ApplyBy] int NOT NULL,
    [OrgID] int NULL,
    [StartTime] datetime NOT NULL,
    [EndTime] datetime NOT NULL,
    [Purpose] nvarchar(300) NULL,
    [Status] tinyint NOT NULL DEFAULT ((0)),
    [ApproveBy] int NULL,
    [ApproveTime] datetime NULL,
    [ApproveNote] nvarchar(300) NULL,
    [ApplyTime] datetime NOT NULL DEFAULT (getdate()),
    CONSTRAINT [PK_VenueReservations] PRIMARY KEY CLUSTERED ([ResvID])
);
GO

-- ---------------------------------------------
-- 表: Venues
-- ---------------------------------------------
IF OBJECT_ID('[Venues]', 'U') IS NOT NULL
    DROP TABLE [Venues];
GO

CREATE TABLE [Venues] (
    [VenueID] int IDENTITY(1,1) NOT NULL,
    [VenueName] nvarchar(100) NOT NULL,
    [Location] nvarchar(200) NULL,
    [Capacity] int NULL,
    [Facilities] nvarchar(500) NULL,
    [IsActive] bit NOT NULL DEFAULT ((1)),
    CONSTRAINT [PK_Venues] PRIMARY KEY CLUSTERED ([VenueID])
);
GO


