CREATE PROCEDURE AddExpense
    @UserID INT,
    @Description NVARCHAR(MAX),
    @Amount DECIMAL(18, 2),
    @CategoryID INT,
    @Timestamp DATETIME = NULL
AS
BEGIN
    -- Use current date and time if @Timestamp is NULL
    SET @Timestamp = ISNULL(@Timestamp, GETDATE())

    -- Start a transaction
    BEGIN TRANSACTION

    -- Insert the new expense record
    INSERT INTO [dbo].[Expenses] ([UserID], [Description], [Amount], [CategoryID], [Timestamp])
    VALUES (@UserID, @Description, @Amount, @CategoryID, @Timestamp)

    -- Check if the insert was successful
    IF @@ERROR = 0
    BEGIN
        -- Commit the transaction
        COMMIT TRANSACTION
    END
    ELSE
    BEGIN
        -- Rollback the transaction in case of an error
        ROLLBACK TRANSACTION
    END
END
GO


--USE CASE
EXEC AddExpense 
    @UserID = 2, 
    @Description = 'Office Supplies', 
    @Amount = 99.99, 
    @CategoryID = 2
