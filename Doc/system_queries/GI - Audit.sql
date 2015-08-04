SELECT TOP 1000 
		a.RequestUsername, a.ActivityId, a.ActivityDate, at.Name, at.ActivityTypeId, d.Value, dt.Name
FROM GISite.audit.Activity a (NOLOCK)
	JOIN GISite.audit.ActivityType at (NOLOCK)
		ON a.ActivityTypeId = at.ActivityTypeId
	JOIN GISite.audit.Detail d (NOLOCK)
		ON a.ActivityId = d.ActivityId
	JOIN GISite.audit.DetailType dt (NOLOCK)
		ON d.DetailTypeId = dt.DetailTypeId
WHERE a.ActivityDate >= GETDATE() - 1
ORDER BY a.ActivityId DESC

SELECT COUNT(*), RequestServer
FROM GISite.audit.Activity
GROUP BY RequestServer