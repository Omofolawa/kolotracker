--This view is creates a virtual table that consolidates the userdata from the user table,
-- rating tables and suggestion comments column to present a qucik view of user feedbacks.

CREATE VIEW UserRatingsView AS
SELECT 
    u.UserID,
    u.Username,
    rd.Description AS RatingDescription,
    r.Rating,
    r.Comment,
	s.Comment AS Suggestion
FROM 
    dbo.Users u
JOIN 
    dbo.Ratings r ON u.UserID = r.UserID
JOIN 
    dbo.RatingDescriptions rd ON r.Rating = rd.Rating
JOIN 
	dbo.Suggestions s ON s.UserID = u.UserID;