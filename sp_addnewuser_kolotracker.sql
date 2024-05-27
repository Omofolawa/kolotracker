CREATE PROCEDURE AddNewUser 
    @Username NVARCHAR(100),
    @Password NVARCHAR(100),
    @Email NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Insert the new user into the Users table with the password hashed using SHA2_256
        INSERT INTO [koloexptracker].[dbo].[Users] ([Username], [Password], [Email])
        VALUES (
            @Username, 
            HASHBYTES('SHA2_256', @Password), 
            @Email
        );

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- If there is an error, rollback the transaction
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Rethrow the error
        THROW;
    END CATCH;
END;
GO
