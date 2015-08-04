--SELECT COUNT(*)
SELECT ck.OpenIDClaimedIdentifier, ck.MembershipID, mc.CardNumber, p.EmailAddress
FROM Membership.dbo.MembershipCard mc
	JOIN Membership.dbo.Membership m
		ON mc.MembershipID = m.MembershipID
	JOIN Profile.KeyMap.CustomerKey ck
		ON m.MembershipID = ck.MembershipID
	JOIN Profile.dbo.Profile p
		ON ck.ProfileID = p.ProfileID
WHERE p.EmailAddress NOT LIKE '%@gs.com'
  AND p.EmailAddress NOT LIKE '%gamestop.com'
  AND ck.OpenIDClaimedIdentifier LIKE 'https://loginqa.gamestop.com%'	

SELECT p.EmailAddress, m.MembershipID, m.CreatedDate, mc.*
FROM Profile.dbo.Profile p
	LEFT JOIN Profile.KeyMap.CustomerKey ck
		ON p.ProfileID = ck.ProfileID 
	LEFT JOIN Membership.dbo.Membership m
		ON ck.MembershipID = m.MembershipID
	LEFT JOIN Membership.dbo.MembershipCard mc
		ON m.MembershipID = mc.MembershipID
WHERE p.EmailAddress = 'ericbrown@gamestop.com'
ORDER BY p.ProfileID DESC


select * 
from Membership.dbo.Membership m
	join Profile.KeyMap.CustomerKey ck
		on m.MembershipID = ck.MembershipID
	join Profile.dbo.Profile p
		on ck.ProfileID = p.ProfileID
where m.MembershipID = 1237237761

select *
from Profile.dbo.Profile p
	join Profile.KeyMap.CustomerKey ck
		on p.ProfileID = ck.ProfileID
	join Membership.dbo.Membership m
		on ck.MembershipID = m.MembershipID
	join Membership.dbo.MembershipCard mc
		on m.MembershipID = mc.MembershipID
where p.EmailAddress = 'ericbrown@gamestop.com'

UPDATE Membership.dbo.Membership
SET MembershipID = 1237237761
WHERE MembershipID = 2151366 

select * 
from Membership.dbo.MemberShip m 
	left join Membership.dbo.MembershipCard mc
		on m.MembershipID = mc.MembershipID
	join Profile.KeyMap.CustomerKey ck
		on m.MembershipID = ck.MembershipID
	join Profile.dbo.Profile p
		on ck.ProfileID = p.ProfileID
where m.MembershipID = 1237237761  


INSERT INTO Membership.dbo.MembershipCard
VALUES --MembershipID, CardNumber, CardDescription, CreatedDate, CancellationDate, CardStatusID, ModifiedDate
('1238153139', '3876307605089', NULL, '2013-03-21 22:06:48.430', NULL, '1', NULL),--bf@qagsecomprod.oib.com
('1238261743', '3875853192224', NULL, '2013-03-21 22:06:48.430', NULL, '1', NULL),--bf_gsdc6@qagsecomprod.oib.com, email5666729162@gamestop.com
('1238261745', '3875235662317', NULL, '2013-03-21 22:06:49.650', NULL, '1', NULL),--bf_gsdc7@qagsecomprod.oib.com, email3480838436@gamestop.com
('1238261746', '3876583551437', NULL, '2013-03-21 22:06:49.887', NULL, '1', NULL),--bf_gsdc9@qagsecomprod.oib.com, email7149020333@gamestop.com
('1238261747', '3876915649332', NULL, '2013-03-21 22:06:50.173', NULL, '1', NULL),--bf_gsdc10@qagsecomprod.oib.com, email4667600874@gamestop.com
('1238277967', '3875369384102', NULL, '2013-04-11 21:41:19.840', NULL, '1', NULL),--bf_gsdc14@qagsecomprod.oib.com, email7796366461@qagsecomprod.oib.com
('1238277974', '3875268597271', NULL, '2013-04-11 21:41:21.307', NULL, '1', NULL),--bf_gsdc29@qagsecomprod.oib.com
('1238152901', '3875465617324', NULL, '2011-02-18 00:00:00.000', NULL, '1', NULL),--eileensiriban@gamestop.com
('1238153204', '3876307605154', NULL, '2011-02-21 00:00:00.000', NULL, '1', NULL),--eileen.siriban@rcggs.com
('1238152818', '3875465617241', NULL, '2011-02-18 00:00:00.000', NULL, '1', NULL),--alitol@qagsecomprod.oib.com, 465617241FN@465617241LN.com
('1238152497', '3875465616920', NULL, '2011-02-18 00:00:00.000', NULL, '1', NULL),--roann@qagsecomprod.oib.com
('1238364147', '3876110388253', NULL, '2013-08-27 23:21:40.117', NULL, '1', NULL),--expire001@qagsecomprod.oib.com
('1238364148', '3876110388261', NULL, '2013-08-27 23:21:52.863', NULL, '1', NULL),--expire002@qagsecomprod.oib.com
('1238364149', '3876110388279', NULL, '2013-08-27 23:22:02.643', NULL, '1', NULL),--expire003@qagsecomprod.oib.com
('1238364150', '3876110388287', NULL, '2013-08-27 23:22:13.983', NULL, '1', NULL),--expire004@qagsecomprod.oib.com
('1238364151', '3876110388295', NULL, '2013-08-27 23:22:23.717', NULL, '1', NULL),--expire005@qagsecomprod.oib.com
('1238364152', '3876110389285', NULL, '2013-08-27 23:22:33.383', NULL, '1', NULL),--expire006@qagsecomprod.oib.com
('1238364154', '3876110389251', NULL, '2013-08-27 23:22:55.717', NULL, '1', NULL),--expire008@qagsecomprod.oib.com
('1238364155', '3876110389244', NULL, '2013-08-27 23:23:06.883', NULL, '1', NULL),--expire009@qagsecomprod.oib.com
('1238364156', '3876110389236', NULL, '2013-08-27 23:23:20.040', NULL, '1', NULL),--expire010@qagsecomprod.oib.com
('1237238197', '3875182358756', NULL, '2010-10-01 00:00:00.000', NULL, '1', NULL),--ebpur@qagsecomprod.oib.com
('2151366', '3876740435094', NULL, '2008-06-19 00:00:00.000', NULL, '1', NULL),--ericbrown@gamestop.com
('1238305594', '3876714813565', NULL, '2013-05-24 19:26:08.913', NULL, '1', NULL)--email6617478874@qagsecomprod.oib.com


