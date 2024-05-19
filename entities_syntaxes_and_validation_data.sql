Users: Stores user information such as username, password, and email.
Categories: Stores expense categories (e.g., groceries, utilities, entertainment).
Expenses: Stores user expenses, including the associated user ID, category ID, amount, date, and description.
Suggestions: stores user suggestions on new features they would like to be implemented on the web app, and also general feedbacks on existing features.
Ratings: stores user ratings and their experiences.

-- Create Users table to store user information
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(50) NOT NULL,
    Password NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL
);

INSERT INTO [koloexptracker].[dbo].[Users] ([Username], [Password], [Email])
VALUES 
('user1', HASHBYTES('SHA2_256', 'Password1!'), 'user1@example.com'),
('user2', HASHBYTES('SHA2_256', 'Password2!'), 'user2@example.com'),
('user3', HASHBYTES('SHA2_256', 'Password3!'), 'user3@example.com');

-- Create Expenses table to store user expenses
CREATE TABLE [dbo].[Expenses] (
    [ExpenseID] INT PRIMARY KEY IDENTITY(1,1),
    [UserID] INT,
    [Description] NVARCHAR(255),
    [Amount] DECIMAL(10,2),
    [CategoryID] INT,
    [Timestamp] DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_UserExpense FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT FK_CategoryExpense FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

INSERT INTO [dbo].[Expenses] ([UserID], [Description], [Amount], [CategoryID], [Timestamp])
VALUES
(1, 'Grocery shopping', 150.75, 2, GETDATE()),
(2, 'Monthly rent', 1200.00, 5, GETDATE()),
(3, 'Dinner at a restaurant', 45.50, 1, GETDATE());


--Create Suggestions table to store user suggestions
CREATE TABLE Suggestions (
    SuggestionID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCE Users(UserID),
    Comment TEXT (500)
);

INSERT INTO [dbo].[Suggestions] ([UserID], [Comment])
VALUES
(1, 'Add more detailed expense reports.'),
(2, 'Introduce a dark mode option.'),
(3, 'Include a currency conversion feature.');


CREATE TABLE [dbo].[Ratings] (
    [ID] INT PRIMARY KEY IDENTITY(1,1),
    [UserID] INT FOREIGN KEY REFERENCES Users(UserID),
    [Rating] INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    [Comment] NVARCHAR(255),
    FOREIGN KEY (Rating) REFERENCES RatingDescriptions(Rating)
);

CREATE TABLE [dbo].[RatingDescriptions] (
    [Rating] INT PRIMARY KEY CHECK (Rating BETWEEN 1 AND 5),
    [Description] NVARCHAR(50) NOT NULL
);

-- Insert rating descriptions
INSERT INTO [dbo].[RatingDescriptions] ([Rating], [Description])
VALUES
(1, 'Poor'),
(2, 'Fair'),
(3, 'Good'),
(4, 'Very Good'),
(5, 'Excellent');

INSERT INTO [dbo].[Ratings] ([UserID], [Rating], [Comment])
VALUES
(1, 5, 'Excellent service!'),
(2, 3, 'It was okay.'),
(3, 2, 'Fair experience.');

-- Create Categories table to store expense categories
CREATE TABLE Category (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL
);

-- Insert expense categories into the Category table
INSERT INTO Category (Name)
VALUES
('Food & Dining'),
('Groceries'),
('Transportation'),
('Utilities'),
('Rent/Mortgage'),
('Insurance'),
('Entertainment'),
('Travel'),
('Clothing & Accessories'),
('Health & Fitness'),
('Education'),
('Gifts & Donations'),
('Personal Care'),
('Household Supplies'),
('Pet Expenses'),
('Miscellaneous');
