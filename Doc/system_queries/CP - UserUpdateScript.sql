--douglemme@gamestop.com
--UPDATE Multipass.dbo.IssuedUser 
--SET emailAddress = 'jontestqa0820131209@gspcauto.fav.cc', UserName = 'jontestqa0820131209@gspcauto.fav.cc'
--WHERE OpenIDClaimedIdentifier = 'https://loginqa.gamestop.com/ID/1AAE878A-CD25-45F1-BE70-F2E85F359165'

--UPDATE Profile.dbo.Profile 
--SET EmailAddress = 'jontestqa0820131209@gspcauto.fav.cc'
--WHERE ProfileID = 1237238255

--UPDATE Profile.dbo.Profile 
--SET EmailAddress = 'jontestqa0820131209@gspcauto.fav.cc'
--WHERE ProfileID = 1253594481

--get data before
--SELECT EmailAddress, UserName, OpenIDClaimedIdentifier FROM Multipass.dbo.IssuedUser where EmailAddress = 'douglemme@gamestop.com'
--SELECT p.ProfileID, ck.ProfileID 
--FROM Profile.dbo.Profile p 
--	JOIN Profile.KeyMap.CustomerKey ck
--		ON p.ProfileID = ck.ProfileID
--WHERE ck.OpenIDClaimedIdentifier = 'https://loginqa.gamestop.com/ID/1AAE878A-CD25-45F1-BE70-F2E85F359165'

--test data after
--SELECT p.ProfileID FROM Profile.dbo.Profile p WHERE p.EmailAddress = 'jontestqa0820131209@gspcauto.fav.cc'
--SELECT m.EmailAddress, m.UserName FROM Multipass.dbo.IssuedUser m WHERE OpenIDClaimedIdentifier = 'https://loginqa.gamestop.com/ID/1AAE878A-CD25-45F1-BE70-F2E85F359165'
--SELECT p.EmailAddress FROM profile.dbo.Profile p WHERE p.ProfileID IN (1237238255, 1253594481)



--easleydj@earthlink.net
--UPDATE Multipass.dbo.IssuedUser 
--SET emailAddress = 'jontestqa0821130757@gspcauto.fav.cc', UserName = 'jontestqa0821130757@gspcauto.fav.cc'
--WHERE OpenIDClaimedIdentifier = 'https://loginqa.gamestop.com/ID/806818DF-EABE-453B-81FE-1DD977E18BF9'

--UPDATE Profile.dbo.Profile 
--SET EmailAddress = 'jontestqa0821130757@gspcauto.fav.cc'
--WHERE ProfileID = 1253482330

--UPDATE Profile.dbo.Profile 
--SET EmailAddress = 'jontestqa0821130757@gspcauto.fav.cc'
--WHERE ProfileID = 2151484

--get data before
--SELECT EmailAddress, UserName, OpenIDClaimedIdentifier FROM Multipass.dbo.IssuedUser where EmailAddress = 'easleydj@earthlink.net'

--SELECT p.ProfileID, ck.ProfileID 
--FROM Profile.dbo.Profile p 
--	JOIN Profile.KeyMap.CustomerKey ck
--		ON p.ProfileID = ck.ProfileID
--WHERE ck.OpenIDClaimedIdentifier = 'https://loginqa.gamestop.com/ID/806818DF-EABE-453B-81FE-1DD977E18BF9'

--test data after
--SELECT p.ProfileID FROM Profile.dbo.Profile p WHERE p.EmailAddress = 'jontestqa0821130757@gspcauto.fav.cc'
--SELECT m.EmailAddress, m.UserName FROM Multipass.dbo.IssuedUser m WHERE OpenIDClaimedIdentifier = 'https://loginqa.gamestop.com/ID/806818DF-EABE-453B-81FE-1DD977E18BF9'
--SELECT p.EmailAddress FROM profile.dbo.Profile p WHERE p.ProfileID IN (1253482330, 2151484)




--ABC@aol.com
UPDATE Multipass.dbo.IssuedUser 
SET emailAddress = 'jontestqa0821130758@gspcauto.fav.cc', UserName = 'jontestqa0821130758@gspcauto.fav.cc'
WHERE OpenIDClaimedIdentifier = 'https://loginqa.gamestop.com/ID/27456B71-4161-4ABE-B8CD-D4F79209C1DB'

UPDATE Profile.dbo.Profile 
SET EmailAddress = 'jontestqa0821130758@gspcauto.fav.cc'
WHERE ProfileID = 1253309560

UPDATE Profile.dbo.Profile 
SET EmailAddress = 'jontestqa0821130758@gspcauto.fav.cc'
WHERE ProfileID = 1000132388

UPDATE Profile.dbo.Profile 
SET EmailAddress = 'jontestqa0821130758@gspcauto.fav.cc'
WHERE ProfileID = 1000132433

UPDATE Profile.dbo.Profile 
SET EmailAddress = 'jontestqa0821130758@gspcauto.fav.cc'
WHERE ProfileID = 1000132440

UPDATE Profile.dbo.Profile 
SET EmailAddress = 'jontestqa0821130758@gspcauto.fav.cc'
WHERE ProfileID = 1000132475

UPDATE Profile.dbo.Profile 
SET EmailAddress = 'jontestqa0821130758@gspcauto.fav.cc'
WHERE ProfileID = 1000132599

--get data before
--SELECT EmailAddress, UserName, OpenIDClaimedIdentifier FROM Multipass.dbo.IssuedUser where EmailAddress = 'ABC@aol.com'
--SELECT p.ProfileID, ck.ProfileID 
--FROM Profile.dbo.Profile p 
--	JOIN Profile.KeyMap.CustomerKey ck
--		ON p.ProfileID = ck.ProfileID
--WHERE ck.OpenIDClaimedIdentifier = 'https://loginqa.gamestop.com/ID/27456B71-4161-4ABE-B8CD-D4F79209C1DB'

--test data after
SELECT p.ProfileID FROM Profile.dbo.Profile p WHERE p.EmailAddress = 'jontestqa0821130758@gspcauto.fav.cc'
SELECT m.EmailAddress, m.UserName FROM Multipass.dbo.IssuedUser m WHERE OpenIDClaimedIdentifier = 'https://loginqa.gamestop.com/ID/27456B71-4161-4ABE-B8CD-D4F79209C1DB'
SELECT p.EmailAddress FROM profile.dbo.Profile p WHERE p.ProfileID IN (1253309560, 1000132388, 1000132433, 1000132440, 1000132475, 1000132599)

--vidiot1304@aol.com
UPDATE Multipass.dbo.IssuedUser 
SET emailAddress = 'jontestqa0821130759@gspcauto.fav.cc', UserName = 'jontestqa0821130759@gspcauto.fav.cc'
WHERE OpenIDClaimedIdentifier = 'https://loginqa.gamestop.com/ID/FA7FCBC9-2D6A-4D5D-B622-DB4932F573F7'

UPDATE Profile.dbo.Profile 
SET EmailAddress = 'jontestqa0821130759@gspcauto.fav.cc'
WHERE ProfileID = 1252516545

UPDATE Profile.dbo.Profile 
SET EmailAddress = 'jontestqa0821130759@gspcauto.fav.cc'
WHERE ProfileID = 1000131752

UPDATE Profile.dbo.Profile 
SET EmailAddress = 'jontestqa0821130759@gspcauto.fav.cc'
WHERE ProfileID = 1000132028

--get data before
--SELECT EmailAddress, UserName, OpenIDClaimedIdentifier FROM Multipass.dbo.IssuedUser where EmailAddress = 'vidiot1304@aol.com'
--SELECT p.ProfileID, ck.ProfileID 
--FROM Profile.dbo.Profile p 
--	JOIN Profile.KeyMap.CustomerKey ck
--		ON p.ProfileID = ck.ProfileID
--WHERE ck.OpenIDClaimedIdentifier = 'https://loginqa.gamestop.com/ID/FA7FCBC9-2D6A-4D5D-B622-DB4932F573F7'

--test data after
--SELECT p.ProfileID FROM Profile.dbo.Profile p WHERE p.EmailAddress = 'jontestqa0821130759@gspcauto.fav.cc'
--SELECT m.EmailAddress, m.UserName FROM Multipass.dbo.IssuedUser m WHERE OpenIDClaimedIdentifier = 'https://loginqa.gamestop.com/ID/FA7FCBC9-2D6A-4D5D-B622-DB4932F573F7'
--SELECT p.EmailAddress FROM profile.dbo.Profile p WHERE p.ProfileID IN (1252516545, 1000131752, 1000132028)

--AA@YAHOO.COM
UPDATE Multipass.dbo.IssuedUser 
SET emailAddress = 'jontestqa0821130800@gspcauto.fav.cc', UserName = 'jontestqa0821130800@gspcauto.fav.cc'
WHERE OpenIDClaimedIdentifier = 'https://loginqa.gamestop.com/ID/9E86BF96-E327-421D-B1E9-FF45E41823D3'

UPDATE Profile.dbo.Profile 
SET EmailAddress = 'jontestqa0821130800@gspcauto.fav.cc'
WHERE ProfileID = 1251634992

UPDATE Profile.dbo.Profile 
SET EmailAddress = 'jontestqa0821130800@gspcauto.fav.cc'
WHERE ProfileID = 1000000439

--get data before
--SELECT EmailAddress, UserName, OpenIDClaimedIdentifier FROM Multipass.dbo.IssuedUser where EmailAddress = 'AA@YAHOO.COM'
--SELECT p.ProfileID, ck.ProfileID 
--FROM Profile.dbo.Profile p 
--	JOIN Profile.KeyMap.CustomerKey ck
--		ON p.ProfileID = ck.ProfileID
--WHERE ck.OpenIDClaimedIdentifier = 'https://loginqa.gamestop.com/ID/9E86BF96-E327-421D-B1E9-FF45E41823D3'

--test data after
--SELECT p.ProfileID FROM Profile.dbo.Profile p WHERE p.EmailAddress = 'jontestqa0821130800@gspcauto.fav.cc'
--SELECT m.EmailAddress, m.UserName FROM Multipass.dbo.IssuedUser m WHERE OpenIDClaimedIdentifier = 'https://loginqa.gamestop.com/ID/9E86BF96-E327-421D-B1E9-FF45E41823D3'
--SELECT p.EmailAddress FROM profile.dbo.Profile p WHERE p.ProfileID IN (1251634992, 1000000439)

--karealways@yahoo.com
UPDATE Multipass.dbo.IssuedUser 
SET emailAddress = 'jontestqa0821130801@gspcauto.fav.cc', UserName = 'jontestqa0821130801@gspcauto.fav.cc'
WHERE OpenIDClaimedIdentifier = 'https://loginqa.gamestop.com/ID/68B74A0A-08F0-41CB-A7AD-ACE81FC1B3E0'

UPDATE Profile.dbo.Profile 
SET EmailAddress = 'jontestqa0821130801@gspcauto.fav.cc'
WHERE ProfileID = 1250057064

UPDATE Profile.dbo.Profile 
SET EmailAddress = 'jontestqa0821130801@gspcauto.fav.cc'
WHERE ProfileID = 1238253353

--get data before
--SELECT EmailAddress, UserName, OpenIDClaimedIdentifier FROM Multipass.dbo.IssuedUser where EmailAddress = 'karealways@yahoo.com'
--SELECT p.ProfileID, ck.ProfileID 
--FROM Profile.dbo.Profile p 
--	JOIN Profile.KeyMap.CustomerKey ck
--		ON p.ProfileID = ck.ProfileID
--WHERE ck.OpenIDClaimedIdentifier = 'https://loginqa.gamestop.com/ID/68B74A0A-08F0-41CB-A7AD-ACE81FC1B3E0'

--test data after
--SELECT p.ProfileID FROM Profile.dbo.Profile p WHERE p.EmailAddress = 'jontestqa0821130801@gspcauto.fav.cc'
--SELECT m.EmailAddress, m.UserName FROM Multipass.dbo.IssuedUser m WHERE OpenIDClaimedIdentifier = 'https://loginqa.gamestop.com/ID/68B74A0A-08F0-41CB-A7AD-ACE81FC1B3E0'
--SELECT p.EmailAddress FROM profile.dbo.Profile p WHERE p.ProfileID IN (1250057064, 1238253353)

--kevin4380@yahoo.com
UPDATE Multipass.dbo.IssuedUser 
SET emailAddress = 'jontestqa0822130802@gspcauto.fav.cc', UserName = 'jontestqa0822130802@gspcauto.fav.cc'
WHERE OpenIDClaimedIdentifier = 'https://loginqa.gamestop.com/ID/BB0338C7-22C9-4191-A72A-80DD53AF6069'

UPDATE Profile.dbo.Profile 
SET EmailAddress = 'jontestqa0822130802@gspcauto.fav.cc'
WHERE ProfileID = 1250726602

UPDATE Profile.dbo.Profile 
SET EmailAddress = 'jontestqa0822130802@gspcauto.fav.cc'
WHERE ProfileID = 1238217801

--get data before
--SELECT EmailAddress, UserName, OpenIDClaimedIdentifier FROM Multipass.dbo.IssuedUser where EmailAddress = 'kevin4380@yahoo.com'
--SELECT p.ProfileID, ck.ProfileID 
--FROM Profile.dbo.Profile p 
--	JOIN Profile.KeyMap.CustomerKey ck
--		ON p.ProfileID = ck.ProfileID
--WHERE ck.OpenIDClaimedIdentifier = 'https://loginqa.gamestop.com/ID/BB0338C7-22C9-4191-A72A-80DD53AF6069'

--test data after
--SELECT p.ProfileID FROM Profile.dbo.Profile p WHERE p.EmailAddress = 'jontestqa0822130802@gspcauto.fav.cc'
--SELECT m.EmailAddress, m.UserName FROM Multipass.dbo.IssuedUser m WHERE OpenIDClaimedIdentifier = 'https://loginqa.gamestop.com/ID/BB0338C7-22C9-4191-A72A-80DD53AF6069'
--SELECT p.EmailAddress FROM profile.dbo.Profile p WHERE p.ProfileID IN (1250726602, 1238217801)

--leighvit2@aol.com
UPDATE Multipass.dbo.IssuedUser 
SET emailAddress = 'jontestqa0821130804@gspcauto.fav.cc', UserName = 'jontestqa0821130804@gspcauto.fav.cc'
WHERE OpenIDClaimedIdentifier = 'https://loginqa.gamestop.com/ID/2A453694-BA81-4521-98FB-E0AAE58B7D65'

UPDATE Profile.dbo.Profile 
SET EmailAddress = 'jontestqa0821130804@gspcauto.fav.cc'
WHERE ProfileID = 1250156264

UPDATE Profile.dbo.Profile 
SET EmailAddress = 'jontestqa0821130804@gspcauto.fav.cc'
WHERE ProfileID = 2151579

--get data before
--SELECT EmailAddress, UserName, OpenIDClaimedIdentifier FROM Multipass.dbo.IssuedUser where EmailAddress = 'leighvit2@aol.com'
--SELECT p.ProfileID, ck.ProfileID 
--FROM Profile.dbo.Profile p 
--	JOIN Profile.KeyMap.CustomerKey ck
--		ON p.ProfileID = ck.ProfileID
--WHERE ck.OpenIDClaimedIdentifier = 'https://loginqa.gamestop.com/ID/2A453694-BA81-4521-98FB-E0AAE58B7D65'

--test data after
--SELECT p.ProfileID FROM Profile.dbo.Profile p WHERE p.EmailAddress = 'jontestqa0821130804@gspcauto.fav.cc'
--SELECT m.EmailAddress, m.UserName FROM Multipass.dbo.IssuedUser m WHERE OpenIDClaimedIdentifier = 'https://loginqa.gamestop.com/ID/2A453694-BA81-4521-98FB-E0AAE58B7D65'
--SELECT p.EmailAddress FROM profile.dbo.Profile p WHERE p.ProfileID IN (1250156264, 2151579)
