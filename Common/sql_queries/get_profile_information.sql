DECLARE @Email_Address NVARCHAR(50)
SET @Email_Address = 'gsui_20140606_140624_403@qagsecomprod.oib.com'

SELECT TOP 20 iu.EmailAddress, iu.OpenIDClaimedIdentifier
                  , ck.ProfileID, ck.MembershipKeyID
                  , p.BirthDay, p.BirthMonth, p.BirthYear, p.FirstName, p.LastName
                  , CASE p.GenderID
                        WHEN 1 THEN 'MALE'
                        WHEN 2 THEN 'FEMALE'
                      ELSE 'UNKNOWN'
                    END AS Gender
                  , CASE a.AddressTypeID
                        WHEN 0 THEN 'Shipping Address'
                        WHEN 1 THEN 'Billing Address'
                        WHEN 2 THEN 'Mailing Address'
                      ELSE 'Undetermined'
                    END AS Address_Type
                  , a.RecipientFirstName, a.RecipientLastName, a.Line1, a.Line2, a.City, a.State, a.Country, a.PostalCode
                  , m.MembershipID
                  , CASE m.MembershipProgramID
                        WHEN 1 THEN 'PUR Free'
                        WHEN 2 THEN 'PUR Pro'
                        WHEN 3 THEN 'PURCC'
                        ELSE 'Unknown'
                    END AS PUR_Program_Type
                  , CASE m.MembershipStatusID
                        WHEN 1 THEN 'Activated'
                        WHEN 2 THEN 'Inactive'
                        WHEN 3 THEN 'Terminated'
                        WHEN 4 THEN 'Deactivated'
                        WHEN 5 THEN 'Cancelled'
                        WHEN 6 THEN 'Returned'
                        WHEN 7 THEN 'MergeCancelled'
                      ELSE 'Unspecified'
                    END AS Membership_Status
                  , CASE mc.CardStatusID
                        WHEN 1 THEN 'Active'
                        WHEN 2 THEN 'Inactive'
                        WHEN 3 THEN 'Terminated'
                        WHEN 4 THEN 'Deactivated'
                        WHEN 5 THEN 'Cancelled'
                        WHEN 6 THEN 'MergeCancelled'
                        ELSE 'Unknown'
                    END AS Membership_Card_Status
                  , mc.CardNumber AS PUR_Card_Number
FROM Multipass.dbo.IssuedUser iu (NOLOCK)
      JOIN Profile.KeyMap.CustomerKey ck (NOLOCK)
            ON iu.OpenIDClaimedIdentifier = ck.OpenIDClaimedIdentifier
      LEFT JOIN profile.dbo.Profile p (NOLOCK)
            ON ck.ProfileID = p.ProfileID
      LEFT JOIN Profile.dbo.Address a (NOLOCK)
            ON p.ProfileID = a.ProfileID
      LEFT JOIN Membership.dbo.MembershipKey mk (NOLOCK)
            ON ck.MembershipKeyID = mk.MembershipKeyID
      LEFT JOIN Membership.dbo.Membership m (NOLOCK)
            ON mk.MembershipID = m.MembershipID
      LEFT JOIN Membership.dbo.MembershipCard mc (NOLOCK)
            ON m.MembershipID = mc.MembershipID
WHERE iu.EmailAddress = @Email_Address
