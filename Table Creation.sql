-- 1. Roles --
CREATE TABLE Roles (
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL
);
GO

-- 2. Users --
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    RoleID INT NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(255) NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    RegistrationDate DATETIME2 NOT NULL,
    AccountStatus NVARCHAR(20) NOT NULL,
    Avatar NVARCHAR(10) NULL,

    CONSTRAINT FK_Users_Roles
        FOREIGN KEY (RoleID) REFERENCES Roles(RoleID),

    CONSTRAINT CK_Users_AccountStatus
        CHECK (AccountStatus IN ('Active', 'Inactive', 'Suspended'))
);
GO

-- 3. FAQs --
CREATE TABLE FAQs (
    FaqID INT IDENTITY(1,1) PRIMARY KEY,
    Category NVARCHAR(100) NOT NULL,
    Question NVARCHAR(MAX) NOT NULL,
    Answer NVARCHAR(MAX) NOT NULL,
    IsPublished BIT NOT NULL,
    CreatedDate DATETIME2 NOT NULL
);
GO

-- 4. Categories --
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL
);
GO

-- 5. Courses --
CREATE TABLE Courses (
    CourseID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID INT NOT NULL,
    CreatedBy INT NOT NULL,
    CourseTitle NVARCHAR(255) NOT NULL,
    CourseDescription NVARCHAR(MAX) NOT NULL,
    DifficultyLevel NVARCHAR(50) NOT NULL,
    CourseStatus NVARCHAR(20) NOT NULL,
    CreatedDate DATETIME2 NOT NULL,
    Rating DECIMAL(2,1) NULL,
    Price DECIMAL(10,2) NULL,

    CONSTRAINT FK_Courses_Categories
        FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),

    CONSTRAINT FK_Courses_Users
        FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),

    CONSTRAINT CK_Courses_Status
        CHECK (CourseStatus IN ('Active', 'Draft', 'Archived'))
);
GO

-- 6. Enrollments --
CREATE TABLE Enrollments (
    EnrollmentID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    CourseID INT NOT NULL,
    EnrollDate DATETIME2 NOT NULL,
    OverallProgressPercentage DECIMAL(5,2) NOT NULL,
    Certificate BIT NOT NULL,

    CONSTRAINT FK_Enrollments_Users
        FOREIGN KEY (UserID) REFERENCES Users(UserID),

    CONSTRAINT FK_Enrollments_Courses
        FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);
GO

-- 7. Lessons --
CREATE TABLE Lessons (
    LessonID INT IDENTITY(1,1) PRIMARY KEY,
    CourseID INT NOT NULL,
    LessonTitle NVARCHAR(255) NOT NULL,
    LessonOrder INT NOT NULL,
    LessonType NVARCHAR(20) NOT NULL DEFAULT 'Video',

    CONSTRAINT FK_Lessons_Courses
        FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),

    CONSTRAINT CK_Lessons_LessonType
        CHECK (LessonType IN ('Video', 'Quiz', 'Coding', 'Lab'))
);
GO

-- 8. Lesson Resources --
CREATE TABLE Lesson_Resources (
    ResourceID INT IDENTITY(1,1) PRIMARY KEY,
    LessonID INT NOT NULL,
    ResourceType NVARCHAR(50) NOT NULL,
    ResourceURL NVARCHAR(500) NULL,
    AdditionalContent NVARCHAR(MAX) NULL,
    Status NVARCHAR(20) NOT NULL,

    CONSTRAINT FK_LessonResources_Lessons
        FOREIGN KEY (LessonID) REFERENCES Lessons(LessonID),

    CONSTRAINT CK_LessonResources_Status
        CHECK (Status IN ('Published', 'Hidden'))
);
GO

-- 9. Assessments --
CREATE TABLE Assessments (
    AssessmentID INT IDENTITY(1,1) PRIMARY KEY,
    LessonID INT NOT NULL,
    AssessmentTitle NVARCHAR(255) NOT NULL,
    TotalMarks INT NOT NULL,
    Status NVARCHAR(20) NOT NULL,

    CONSTRAINT FK_Assessments_Lessons
        FOREIGN KEY (LessonID) REFERENCES Lessons(LessonID),

    CONSTRAINT CK_Assessments_Status
        CHECK (Status IN ('Active', 'Inactive'))
);
GO

-- 10. Assessment Questions --
CREATE TABLE Assessment_Questions (
    QuestionID INT IDENTITY(1,1) PRIMARY KEY,
    AssessmentID INT NOT NULL,
    QuestionText NVARCHAR(MAX) NOT NULL,
    CorrectAnswer NVARCHAR(MAX) NOT NULL,
    Marks INT NOT NULL,

    CONSTRAINT FK_AssessmentQuestions_Assessments
        FOREIGN KEY (AssessmentID) REFERENCES Assessments(AssessmentID)
);
GO

-- 11. Lesson Progress --
CREATE TABLE Lesson_Progress (
    ProgressID INT IDENTITY(1,1) PRIMARY KEY,
    EnrollmentID INT NOT NULL,
    LessonID INT NOT NULL,
    IsCompleted BIT NOT NULL,
    CompletedDate DATETIME2 NULL,
    LastAccessedDate DATETIME2 NULL,

    CONSTRAINT FK_LessonProgress_Enrollments
        FOREIGN KEY (EnrollmentID) REFERENCES Enrollments(EnrollmentID),

    CONSTRAINT FK_LessonProgress_Lessons
        FOREIGN KEY (LessonID) REFERENCES Lessons(LessonID)
);
GO

-- 12. Assessment Results --
CREATE TABLE Assessment_Results (
    ResultID INT IDENTITY(1,1) PRIMARY KEY,
    AssessmentID INT NOT NULL,
    EnrollmentID INT NOT NULL,
    Score DECIMAL(5,2) NOT NULL,
    AttemptDate DATETIME2 NOT NULL,

    CONSTRAINT FK_AssessmentResults_Assessments
        FOREIGN KEY (AssessmentID) REFERENCES Assessments(AssessmentID),

    CONSTRAINT FK_AssessmentResults_Enrollments
        FOREIGN KEY (EnrollmentID) REFERENCES Enrollments(EnrollmentID)
);
GO

-- 13. Discussion Threads --
CREATE TABLE Discussion_Threads (
    ThreadID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID INT NOT NULL,
    UserID INT NOT NULL,
    Title NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    Status NVARCHAR(20) NOT NULL,
    CreatedAt DATETIME2 NOT NULL,

    CONSTRAINT FK_DiscussionThreads_Categories
        FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),

    CONSTRAINT FK_DiscussionThreads_Users
        FOREIGN KEY (UserID) REFERENCES Users(UserID),

    CONSTRAINT CK_DiscussionThreads_Status
        CHECK (Status IN ('Open', 'Closed'))
);
GO

-- 14. Discussion Posts --
CREATE TABLE Discussion_Posts (
    PostID INT IDENTITY(1,1) PRIMARY KEY,
    ThreadID INT NOT NULL,
    UserID INT NOT NULL,
    Content NVARCHAR(MAX) NOT NULL,
    Reply NVARCHAR(MAX) NULL,
    CreatedAt DATETIME2 NOT NULL,
    IsEdited BIT NOT NULL,
    PostStatus NVARCHAR(20) NOT NULL,

    CONSTRAINT FK_DiscussionPosts_Threads
        FOREIGN KEY (ThreadID) REFERENCES Discussion_Threads(ThreadID),

    CONSTRAINT FK_DiscussionPosts_Users
        FOREIGN KEY (UserID) REFERENCES Users(UserID),

    CONSTRAINT CK_DiscussionPosts_PostStatus
        CHECK (PostStatus IN ('Pending', 'Approved', 'Removed'))
);
GO

-- 15. Support Tickets --
CREATE TABLE Support_Tickets (
    TicketID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    Subject NVARCHAR(255) NOT NULL,
    Message NVARCHAR(MAX) NOT NULL,
    TicketStatus NVARCHAR(30) NOT NULL,
    CreatedDate DATETIME2 NOT NULL,

    CONSTRAINT FK_SupportTickets_Users
        FOREIGN KEY (UserID) REFERENCES Users(UserID),

    CONSTRAINT CK_SupportTickets_Status
        CHECK (TicketStatus IN ('Open', 'In Progress', 'Resolved', 'Closed'))
);
GO

-- 16. Knowledge Base --
CREATE TABLE Knowledge_Base (
    KnowledgeBaseID INT IDENTITY(1,1) PRIMARY KEY,
    Topic NVARCHAR(255) NOT NULL,
    Status NVARCHAR(20) NOT NULL,
    ResponseSummary NVARCHAR(MAX) NOT NULL,
    CreatedAt DATETIME2 NOT NULL,
    UpdatedAt DATETIME2 NULL,

    CONSTRAINT CK_KnowledgeBase_Status
        CHECK (Status IN ('Active', 'Draft'))
);
GO

-- 17. Chatbot --
CREATE TABLE Chatbot (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    SessionID NVARCHAR(100) NOT NULL,
    UserQuery NVARCHAR(MAX) NOT NULL,
    BotResponse NVARCHAR(MAX) NOT NULL,
    IsEscalated BIT NOT NULL,
    Timestamp DATETIME2 NOT NULL,
    KnowledgeBaseID INT NULL,

    CONSTRAINT FK_Chatbot_Users
        FOREIGN KEY (UserID) REFERENCES Users(UserID),

    CONSTRAINT FK_Chatbot_KnowledgeBase
        FOREIGN KEY (KnowledgeBaseID) REFERENCES Knowledge_Base(KnowledgeBaseID)
);
GO


-- 18. Review --
CREATE TABLE Review (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    CourseID INT NOT NULL,
    CourseTitle NVARCHAR(255) NOT NULL,
    UserID INT NOT NULL,
    Rating INT NOT NULL,
    Comment NVARCHAR(MAX) NULL,
    ReviewDate DATETIME2 NOT NULL,

    CONSTRAINT FK_Review_Courses
        FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),

    CONSTRAINT FK_Review_Users
        FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
GO

-- 19. Cart --
CREATE TABLE Cart (
    CartID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    CourseID INT NOT NULL,
    CourseTitle NVARCHAR(255) NOT NULL,
    PriceAtAdded DECIMAL(10,2) NOT NULL,
    AddedDate DATETIME2 NOT NULL,
    CartStatus NVARCHAR(20) NOT NULL,

    CONSTRAINT FK_Cart_Users
        FOREIGN KEY (UserID) REFERENCES Users(UserID),

    CONSTRAINT FK_Cart_Courses
        FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),

    CONSTRAINT CK_Cart_Status
        CHECK (CartStatus IN ('Active', 'Saved', 'Removed'))
);
GO

-- 20. Quiz --
CREATE TABLE Quiz (
    QuizID INT IDENTITY(1,1) PRIMARY KEY,
    LessonID INT NOT NULL,
    CourseID INT NOT NULL,
    QuizTitle NVARCHAR(255) NOT NULL,
    QuestionText NVARCHAR(MAX) NOT NULL,
    OptionA NVARCHAR(MAX) NOT NULL,
    OptionB NVARCHAR(MAX) NOT NULL,
    OptionC NVARCHAR(MAX) NOT NULL,
    OptionD NVARCHAR(MAX) NOT NULL,
    CorrectOption NVARCHAR(10) NOT NULL,
    Marks INT NOT NULL,
    Status NVARCHAR(20) NOT NULL,

    CONSTRAINT FK_Quiz_Lessons
        FOREIGN KEY (LessonID) REFERENCES Lessons(LessonID),

    CONSTRAINT FK_Quiz_Courses
        FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),

    CONSTRAINT CK_Quiz_Status
        CHECK (Status IN ('Active', 'Inactive'))
);
GO

-- 21. Question --
CREATE TABLE Question (
    QuestionID INT IDENTITY(1,1) PRIMARY KEY,
    LessonID INT NOT NULL,
    CourseID INT NOT NULL,
    QuestionTitle NVARCHAR(255) NOT NULL,
    QuestionPrompt NVARCHAR(MAX) NOT NULL,
    StarterCode NVARCHAR(MAX) NULL,
    Answer NVARCHAR(MAX) NOT NULL,
    QuestionType NVARCHAR(50) NOT NULL,
    Status NVARCHAR(20) NOT NULL,
    CreatedDate DATETIME2 NOT NULL,

    CONSTRAINT FK_Question_Lessons
        FOREIGN KEY (LessonID) REFERENCES Lessons(LessonID),

    CONSTRAINT FK_Question_Courses
        FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),

    CONSTRAINT CK_Question_Status
        CHECK (Status IN ('Active', 'Inactive'))
);
GO


-- 22. Bio --
CREATE TABLE Bio (
    BioID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    Headline NVARCHAR(255) NULL,
    BioText NVARCHAR(MAX) NULL,
    Visibility NVARCHAR(20) NOT NULL,
    CreatedAt DATETIME2 NOT NULL,
    UpdatedAt DATETIME2 NULL,

    CONSTRAINT FK_Bio_Users
        FOREIGN KEY (UserID) REFERENCES Users(UserID),

    CONSTRAINT CK_Bio_Visibility
        CHECK (Visibility IN ('Public', 'Private'))
);
GO

-- 23. Announcements --
CREATE TABLE Announcements (
    AnnouncementID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(255) NOT NULL,
    Content NVARCHAR(MAX) NOT NULL,
    AuthorID INT NOT NULL,
    CreatedAt DATETIME2 NOT NULL,

    CONSTRAINT FK_Announcements_Users
        FOREIGN KEY (AuthorID) REFERENCES Users(UserID)
);
GO

-- 24. Instructor --
CREATE TABLE Instructor (
    InstructorID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    CategoryID INT NOT NULL,
    TeachingPlan NVARCHAR(MAX) NOT NULL,
    Motivation NVARCHAR(MAX) NOT NULL,
    Status NVARCHAR(20) NOT NULL,
    ReasonReject NVARCHAR(MAX) NULL,

    CONSTRAINT FK_Instructor_Users
        FOREIGN KEY (UserID) REFERENCES Users(UserID),

    CONSTRAINT FK_Instructor_Categories
        FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),

    CONSTRAINT CK_Instructor_Status
        CHECK (Status IN ('approved', 'rejected', 'pending'))
);
GO
