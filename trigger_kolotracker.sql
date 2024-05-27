-- Triggers to record CRUD operations and activities in the tables

CREATE TABLE AuditTable (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    AuditDateTime DATETIME DEFAULT GETDATE(),
    Operation NVARCHAR(10),
    TableName NVARCHAR(100),
    UserName NVARCHAR(100),
    InsertedData NVARCHAR(MAX)
);

--USERS TABLE
--INSERT
CREATE TRIGGER trg_Audit_Insert_Users
ON dbo.Users
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditTable (Operation, TableName, UserName, InsertedData)
    SELECT 
        'INSERT', 
        'Users', 
        SYSTEM_USER, 
        (SELECT * FROM inserted FOR JSON PATH);
END;
GO

--UPDATE
CREATE TRIGGER trg_Audit_Update_Users
ON dbo.Users
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditTable (Operation, TableName, UserName, InsertedData)
    SELECT 
        'UPDATE', 
        'Users', 
        SYSTEM_USER, 
        (SELECT * FROM inserted FOR JSON PATH);
END;
GO
-- DELETE
CREATE TRIGGER trg_Audit_Delete_Users

ON dbo.Users
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditTable (Operation, TableName, UserName, InsertedData)
    SELECT 
        'DELETE', 
        'Users', 
        SYSTEM_USER, 
        (SELECT * FROM deleted FOR JSON PATH);
END;
GO

-- EXPENSES
--INSERT
CREATE TRIGGER trg_Audit_Insert_Expenses
ON dbo.Expenses
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditTable (Operation, TableName, UserName, InsertedData)
    SELECT 
        'INSERT', 
        'Expenses', 
        SYSTEM_USER, 
        (SELECT * FROM inserted FOR JSON PATH);
END;
GO

--UPDATE
CREATE TRIGGER trg_Audit_Update_Expenses
ON dbo.Expenses
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditTable (Operation, TableName, UserName, InsertedData)
    SELECT 
        'UPDATE', 
        'Expenses', 
        SYSTEM_USER, 
        (SELECT * FROM inserted FOR JSON PATH);
END;
GO

--DELETE
CREATE TRIGGER trg_Audit_Delete_Expenses
ON dbo.Expenses
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditTable (Operation, TableName, UserName, InsertedData)
    SELECT 
        'DELETE', 
        'Expenses', 
        SYSTEM_USER, 
        (SELECT * FROM deleted FOR JSON PATH);
END;
GO

--RATINGS
--INSERT
CREATE TRIGGER trg_Audit_Insert_Ratings
ON dbo.Ratings
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditTable (Operation, TableName, UserName, InsertedData)
    SELECT 
        'INSERT', 
        'Ratings', 
        SYSTEM_USER, 
        (SELECT * FROM inserted FOR JSON PATH);
END;
GO

--UPDATE
CREATE TRIGGER trg_Audit_Update_Attendance
ON dbo.Ratings
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditTable (Operation, TableName, UserName, InsertedData)
    SELECT 
        'UPDATE', 
        'Ratings', 
        SYSTEM_USER, 
        (SELECT * FROM inserted FOR JSON PATH);
END;
GO

--DELETE
CREATE TRIGGER trg_Audit_Delete_Ratings
ON dbo.Ratings
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditTable (Operation, TableName, UserName, InsertedData)
    SELECT 
        'DELETE', 
        'Ratings', 
        SYSTEM_USER, 
        (SELECT * FROM deleted FOR JSON PATH);
END;
GO

--Suggestions
--INSERT
CREATE TRIGGER trg_Audit_Insert_Suggestions
ON dbo.Suggestions
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditTable (Operation, TableName, UserName, InsertedData)
    SELECT 
        'INSERT', 
        'Suggestions', 
        SYSTEM_USER, 
        (SELECT * FROM inserted FOR JSON PATH);
END;
GO

--UPDATE
CREATE TRIGGER trg_Audit_Update_Suggestions
ON dbo.Suggestions
AFTER UPDATE
AS
BEGIN
    INSERT INTO AuditTable (Operation, TableName, UserName, InsertedData)
    SELECT 
        'UPDATE', 
        'Suggestions', 
        SYSTEM_USER, 
        (SELECT * FROM inserted FOR JSON PATH);
END;
GO

--DELETE
CREATE TRIGGER trg_Audit_Delete_Suggestions
ON dbo.Suggestions
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditTable (Operation, TableName, UserName, InsertedData)
    SELECT 
        'DELETE', 
        'Suggestions', 
        SYSTEM_USER, 
        (SELECT * FROM deleted FOR JSON PATH);
END;
GO

