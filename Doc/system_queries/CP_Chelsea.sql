--Consolidated Profile: activate pur comm pref default mailing address
DECLARE @EmailAddr NVARCHAR(100)
SET @EmailAddr = ''

SELECT a.Line1, a.Line1, a.City, a.State, a.PostalCode, a.Country
FROM Profile.dbo.Profile p WITH(NOLOCK)
	JOIN profile.dbo.Address a WITH(NOLOCK)
		ON p.ProfileID = a.ProfileID
WHERE a.[Default] = '1'
  AND p.EmailAddress = @EmailAddr
   
--Consolidated Profile: activate pur comm pref mail opt in answer
DECLARE @EmailAddr NVARCHAR(100)
SET @EmailAddr = ''

SELECT pa.AnswerText as MailOptIn
FROM GenesisCorp.dbo.Customer c WITH(NOLOCK)
	JOIN GenesisCorp.dbo.PreferenceAnswer pa WITH(NOLOCK)
		ON c.CustomerID = pa.CustomerID
	JOIN GenesisCorp.dbo.PreferenceQuestion pq WITH(NOLOCK)
		ON pa.PreferenceQuestionID = pq.PreferenceQuestionID
	JOIN GenesisCorp.dbo.refResource rr WITH(NOLOCK)
		ON pq.ResourceID = rr.ResourceID
WHERE rr.ResourceID = '167' 
  AND c.EmailAddress = @EmailAddr

--Consolidated Profile" activate pur comm pref primary phone
DECLARE @EmailAddr NVARCHAR(100)
SET @EmailAddr = ''

SELECT ph.PhoneNumber
FROM Profile.dbo.Profile p WITH(NOLOCK)
	JOIN Profile.dbo.Phone ph  WITH(NOLOCK)
		ON p.ProfileID = ph.ProfileID
	JOIN profile.dbo.PhoneType pht WITH(NOLOCK)
		ON ph.PhoneTypeID = pht.PhoneTypeID
WHERE pht.PhoneTypeID = '0'
  AND p.EmailAddress = @EmailAddr

--Consolidated Profile: activate pur phone opt in answer
DECLARE @EmailAddr NVARCHAR(100)
SET @EmailAddr = ''

SELECT top 10 pa.AnswerText AS PhoneOptIn
FROM GenesisCorp.dbo.Customer c WITH(NOLOCK)
	JOIN GenesisCorp.dbo.PreferenceAnswer pa WITH(NOLOCK)
		ON c.CustomerID = pa.CustomerID
	JOIN GenesisCorp.dbo.PreferenceQuestion pq WITH(NOLOCK)
		ON pa.PreferenceQuestionID = pq.PreferenceQuestionID
	JOIN GenesisCorp.dbo.refResource rr WITH(NOLOCK)
		ON pq.ResourceID = rr.ResourceID
WHERE rr.ResourceID = 166
  AND pa.AnswerText <> 'SingleAnswerText'
  AND c.EmailAddress = @EmailAddr

--Consolidated Profile: activate pur text opt in answer
DECLARE @EmailAddr NVARCHAR(100)
SET @EmailAddr = ''

SELECT top 10 pa.AnswerText AS TextOptIn
FROM GenesisCorp.dbo.Customer c WITH(NOLOCK)
	JOIN GenesisCorp.dbo.PreferenceAnswer pa WITH(NOLOCK)
		ON c.CustomerID = pa.CustomerID
	JOIN GenesisCorp.dbo.PreferenceQuestion pq WITH(NOLOCK)
		ON pa.PreferenceQuestionID = pq.PreferenceQuestionID
	JOIN GenesisCorp.dbo.refResource rr WITH(NOLOCK)
		ON pq.ResourceID = rr.ResourceID
WHERE rr.ResourceID = 165
  AND pa.AnswerText <> 'SingleAnswerText'
  AND c.EmailAddress = @EmailAddr

--Consoldated Profile: activate pur security question
DECLARE @EmailAddr NVARCHAR(100)
SET @EmailAddr = ''

SELECT pa.AnswerText AS SecurityQuestion
FROM GenesisCorp.dbo.Customer c WITH(NOLOCK)
	JOIN GenesisCorp.dbo.PreferenceAnswer pa WITH(NOLOCK)
		ON c.CustomerID = pa.CustomerID
	JOIN GenesisCorp.dbo.PreferenceQuestion pq WITH(NOLOCK)
		ON pa.PreferenceQuestionID = pq.PreferenceQuestionID
	JOIN GenesisCorp.dbo.refResource rr WITH(NOLOCK)
		ON pq.ResourceID = rr.ResourceID
WHERE rr.ResourceID = 229
  AND pa.AnswerText <> 'DropDownAnswerText'
  AND c.EmailAddress = @EmailAddr
  
--Consoldated Profile: activate pur security answer
DECLARE @EmailAddr NVARCHAR(100)
SET @EmailAddr = ''

SELECT pa.AnswerText AS SecurityAnswer
FROM GenesisCorp.dbo.Customer c WITH(NOLOCK)
	JOIN GenesisCorp.dbo.PreferenceAnswer pa WITH(NOLOCK)
		ON c.CustomerID = pa.CustomerID
	JOIN GenesisCorp.dbo.PreferenceQuestion pq WITH(NOLOCK)
		ON pa.PreferenceQuestionID = pq.PreferenceQuestionID
	JOIN GenesisCorp.dbo.refResource rr WITH(NOLOCK)
		ON pq.ResourceID = rr.ResourceID
WHERE rr.ResourceID = 230
  AND c.EmailAddress = @EmailAddr  

--Consolidated Profile: activate pur dob
DECLARE @EmailAddr NVARCHAR(100)
SET @EmailAddr = ''

SELECT p.BirthMonth, p.BirthDay, p.BirthYear
FROM profile.dbo.Profile p WITH(NOLOCK)
WHERE p.EmailAddress = @EmailAddr  

--Consolidated Profile: activate pur gender
DECLARE @EmailAddr NVARCHAR(100)
SET @EmailAddr = ''

SELECT g.GenderDesc
FROM profile.dbo.Profile p WITH(NOLOCK)
	JOIN profile.dbo.Gender g
		ON p.GenderID = g.GenderID
WHERE p.EmailAddress = @EmailAddr 

--Consolidated Profile: activate pur game library ***WIP***
DECLARE @EmailAddr NVARCHAR(100)
SET @EmailAddr = ''

SELECT top 10 c.EmailAddress, gl.*, gls.*, glst.*
FROM GenesisCorp.dbo.Customer c WITH(NOLOCK)
	JOIN GenesisCorp.GL.GameLibrary gl WITH(NOLOCK)
		ON c.CustomerID = gl.CustomerID
	JOIN GenesisCorp.gl.GameLibraryListSuggestion gls WITH(NOLOCK)
		ON gl.GameLibraryID = gls.GameLibraryID
	JOIN GenesisCorp.gl.refGameLibraryListType glst
		ON gls.GameLibraryListSuggestionID = glst.GameLibraryListTypeID
WHERE c.EmailAddress = @EmailAddr
	