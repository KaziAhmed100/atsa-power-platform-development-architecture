/* 
  ATSA — Generic Database Sample Schema
  This schema is intentionally generic and does not replicate any real institution naming.
*/

-- PEOPLE
CREATE TABLE People (
    PersonId            INT IDENTITY(1,1) PRIMARY KEY,
    FirstName           NVARCHAR(100) NULL,
    LastName            NVARCHAR(100) NULL,
    Email               NVARCHAR(255) NULL,
    Phone               NVARCHAR(50)  NULL,
    Country             NVARCHAR(100) NULL,
    CreatedAt           DATETIME2     NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt           DATETIME2     NOT NULL DEFAULT SYSUTCDATETIME()
);

-- PROGRAMS / COHORTS
CREATE TABLE Programs (
    ProgramId           INT IDENTITY(1,1) PRIMARY KEY,
    ProgramName         NVARCHAR(200) NOT NULL,
    IsCohort            BIT           NOT NULL DEFAULT 0,
    CreatedAt           DATETIME2     NOT NULL DEFAULT SYSUTCDATETIME()
);

-- LEAD STATUS LOOKUP
CREATE TABLE LeadStatuses (
    LeadStatusId        INT IDENTITY(1,1) PRIMARY KEY,
    StatusName          NVARCHAR(50) NOT NULL,
    SortOrder           INT          NOT NULL DEFAULT 0
);

-- APPLICANT STATUS LOOKUP
CREATE TABLE ApplicantStatuses (
    ApplicantStatusId   INT IDENTITY(1,1) PRIMARY KEY,
    StatusName          NVARCHAR(50) NOT NULL,
    SortOrder           INT          NOT NULL DEFAULT 0
);

-- LEADS
CREATE TABLE Leads (
    LeadId              INT IDENTITY(1,1) PRIMARY KEY,
    PersonId            INT          NOT NULL,
    ProgramId           INT          NULL,
    LeadStatusId        INT          NOT NULL,
    Source              NVARCHAR(100) NULL,       -- e.g., campaign, referral
    Notes               NVARCHAR(MAX) NULL,
    CreatedAt           DATETIME2    NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt           DATETIME2    NOT NULL DEFAULT SYSUTCDATETIME(),
    LastContactedAt     DATETIME2    NULL,
    CONSTRAINT FK_Leads_People FOREIGN KEY (PersonId) REFERENCES People(PersonId),
    CONSTRAINT FK_Leads_Programs FOREIGN KEY (ProgramId) REFERENCES Programs(ProgramId),
    CONSTRAINT FK_Leads_LeadStatuses FOREIGN KEY (LeadStatusId) REFERENCES LeadStatuses(LeadStatusId)
);

-- APPLICANTS
CREATE TABLE Applicants (
    ApplicantId         INT IDENTITY(1,1) PRIMARY KEY,
    PersonId            INT          NOT NULL,
    ProgramId           INT          NULL,
    ApplicantStatusId   INT          NOT NULL,
    ExternalAppRef      NVARCHAR(100) NULL,       -- sanitized: central system reference
    SubmittedAt         DATETIME2    NULL,
    DecisionAt          DATETIME2    NULL,
    CreatedAt           DATETIME2    NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt           DATETIME2    NOT NULL DEFAULT SYSUTCDATETIME(),
    LinkedLeadId        INT          NULL,        -- lead-to-applicant conversion tracking
    CONSTRAINT FK_Applicants_People FOREIGN KEY (PersonId) REFERENCES People(PersonId),
    CONSTRAINT FK_Applicants_Programs FOREIGN KEY (ProgramId) REFERENCES Programs(ProgramId),
    CONSTRAINT FK_Applicants_ApplicantStatuses FOREIGN KEY (ApplicantStatusId) REFERENCES ApplicantStatuses(ApplicantStatusId),
    CONSTRAINT FK_Applicants_Leads FOREIGN KEY (LinkedLeadId) REFERENCES Leads(LeadId)
);

-- COMMUNICATIONS
CREATE TABLE Communications (
    CommunicationId     INT IDENTITY(1,1) PRIMARY KEY,
    PersonId            INT NOT NULL,
    RelatedLeadId       INT NULL,
    RelatedApplicantId  INT NULL,
    Channel             NVARCHAR(50) NOT NULL,    -- Email, Phone, Visit, etc.
    Direction           NVARCHAR(20) NULL,        -- Incoming/Outgoing
    Subject             NVARCHAR(255) NULL,
    Body                NVARCHAR(MAX) NULL,
    SentBy              NVARCHAR(255) NULL,       -- staff user identifier (generic)
    OccurredAt          DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    IsAutomated         BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_Comm_People FOREIGN KEY (PersonId) REFERENCES People(PersonId),
    CONSTRAINT FK_Comm_Leads FOREIGN KEY (RelatedLeadId) REFERENCES Leads(LeadId),
    CONSTRAINT FK_Comm_Applicants FOREIGN KEY (RelatedApplicantId) REFERENCES Applicants(ApplicantId)
);

-- EMAIL TEMPLATES (for batch or individual emails)
CREATE TABLE EmailTemplates (
    TemplateId          INT IDENTITY(1,1) PRIMARY KEY,
    TemplateName        NVARCHAR(200) NOT NULL,
    SubjectTemplate     NVARCHAR(255) NOT NULL,
    BodyTemplate        NVARCHAR(MAX) NOT NULL,
    CreatedAt           DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

-- AUTOMATED MESSAGE PLANS (configured automation sequences)
CREATE TABLE AutomatedMessagePlans (
    PlanId              INT IDENTITY(1,1) PRIMARY KEY,
    PlanName            NVARCHAR(200) NOT NULL,
    IsEnabled           BIT NOT NULL DEFAULT 1,
    Description         NVARCHAR(MAX) NULL,
    CreatedAt           DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

-- PER-PERSON STATUS OF AUTOMATED MESSAGES
CREATE TABLE AutomatedMessageStatuses (
    StatusId            INT IDENTITY(1,1) PRIMARY KEY,
    PersonId            INT NOT NULL,
    PlanId              INT NOT NULL,
    StepNumber          INT NOT NULL DEFAULT 1,
    StepStatus          NVARCHAR(50) NOT NULL DEFAULT 'Pending', -- Pending/Sent/Skipped/Failed/Complete
    LastAttemptAt       DATETIME2 NULL,
    NextScheduledAt     DATETIME2 NULL,
    Notes               NVARCHAR(MAX) NULL,
    CONSTRAINT FK_AutoStatus_People FOREIGN KEY (PersonId) REFERENCES People(PersonId),
    CONSTRAINT FK_AutoStatus_Plans FOREIGN KEY (PlanId) REFERENCES AutomatedMessagePlans(PlanId)
);

-- IMPORT BATCHES (traceability for import runs)
CREATE TABLE ImportBatches (
    ImportBatchId       INT IDENTITY(1,1) PRIMARY KEY,
    BatchType           NVARCHAR(50) NOT NULL,    -- Applicants/Cohort/etc.
    StartedAt           DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    EndedAt             DATETIME2 NULL,
    TotalRecords        INT NOT NULL DEFAULT 0,
    ImportedRecords     INT NOT NULL DEFAULT 0,
    SkippedRecords      INT NOT NULL DEFAULT 0,
    FailedRecords       INT NOT NULL DEFAULT 0,
    Notes               NVARCHAR(MAX) NULL
);

-- OPTIONAL: STAFF ROLES (conceptual RBAC)
CREATE TABLE StaffRoles (
    RoleId              INT IDENTITY(1,1) PRIMARY KEY,
    RoleName            NVARCHAR(100) NOT NULL
);

CREATE TABLE StaffUsers (
    StaffUserId         INT IDENTITY(1,1) PRIMARY KEY,
    DisplayName         NVARCHAR(200) NOT NULL,
    Email               NVARCHAR(255) NULL,
    RoleId              INT NOT NULL,
    IsActive            BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_StaffUsers_Roles FOREIGN KEY (RoleId) REFERENCES StaffRoles(RoleId)
);
