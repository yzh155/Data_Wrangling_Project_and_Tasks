SELECT * into [yzhang].[PhoneCall] from [qbs181].dbo.PhoneCall
ALTER TABLE yzhang.PhoneCall ADD Enrollment_group VARCHAR(255)

SELECT dbo.PhoneCall_Encounter.EncounterCode, yzhang.PhoneCall.tri_CustomerIDEntityReference, yzhang.PhoneCall.CallType, yzhang.PhoneCall.CallStartTime, 
yzhang.PhoneCall.CallOutcome, yzhang.PhoneCall.CallDuration, yzhang.PhoneCall.Enrollment_group
INTO yzhang.PhoneCallNew
FROM dbo.PhoneCall_Encounter
RIGHT JOIN yzhang.PhoneCall ON
dbo.PhoneCall_Encounter.CustomerId = yzhang.PhoneCall.tri_CustomerIDEntityReference

UPDATE yzhang.PhoneCallNew SET Enrollment_group = 'Clinical Alert' WHERE EncounterCode=125060000
UPDATE yzhang.PhoneCallNew SET Enrollment_group = 'Health Coaching' WHERE EncounterCode=125060001
UPDATE yzhang.PhoneCallNew SET Enrollment_group = 'Technixal' WHERE EncounterCode=125060002
UPDATE yzhang.PhoneCallNew SET Enrollment_group = 'Administrative' WHERE EncounterCode=125060003
UPDATE yzhang.PhoneCallNew SET Enrollment_group = 'Other' WHERE EncounterCode=125060004
UPDATE yzhang.PhoneCallNew SET Enrollment_group = 'Lack of engagement' WHERE EncounterCode=125060005

SELECT Enrollment_group, COUNT(*) FROM yzhang.PhoneCallNew
GROUP BY Enrollment_group

SELECT * FROM dbo.PhoneCall_Encounter FULL JOIN dbo.CallDuration
ON dbo.PhoneCall_Encounter.CustomerId=dbo.CallDuration.tri_CustomerIDEntityReference

SELECT CallType, CallOutcome, count(*) AS [Number of Records]
FROM (
    SELECT * FROM dbo.PhoneCall_Encounter FULL JOIN dbo.CallDuration
    ON dbo.PhoneCall_Encounter.CustomerId=dbo.CallDuration.tri_CustomerIDEntityReference
)AA
GROUP BY CallType, CallOutcome
Order BY CallType, CallOutcome

SELECT CallType, CallOutcome, count(*) AS [Number of Records]
FROM yzhang.PhoneCallNew
GROUP BY CallType, CallOutcome
Order BY CallType, CallOutcome

SELECT AVG(CallDuration) FROM yzhang.PhoneCallNew


SELECT Enrollment_group, Sum(isnull(cast(CallDuration as float),0)) as [Total Call Duration]
FROM yzhang.PhoneCallNew
GROUP BY Enrollment_group
ORDER BY Enrollment_group