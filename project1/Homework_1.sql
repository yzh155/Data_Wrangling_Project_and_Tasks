/* Question 1*/
EXEC sp_rename 'yzhang.demographics.tri_age', 'Age', 'COLUMN'
EXEC sp_rename 'yzhang.demographics.gendercode', 'gender', 'COLUMN'
EXEC sp_rename 'yzhang.demographics.contactid', 'id', 'COLUMN'
EXEC sp_rename 'yzhang.demographics.Address1_Stateorprovince', 'State', 'COLUMN'
EXEC sp_rename 'yzhang.demographics.Tri_ImagineCareenrollmentemailsentdate', 'EmailSentdate', 'COLUMN'
EXEC sp_rename 'yzhang.demographics.Tri_enrollmentcompletedate ', 'Completedate', 'COLUMN'
EXEC sp_rename 'yzhang.demographics.Tri_imaginecareenrollmentstatus ', 'Status', 'COLUMN'

ALTER TABLE yzhang.demographics ADD days_to_complete VARCHAR(255)
UPDATE yzhang.demographics SET days_to_complete=DATEDIFF(day, Completedate, EmailSentdate) 
SELECT TOP 10 * FROM yzhang.demographics

/* Question 2*/
ALTER TABLE yzhang.demographics ADD Enrollment_Status VARCHAR(255)
UPDATE yzhang.demographics SET Enrollment_Status='Complete' WHERE STATUS=167410011
UPDATE yzhang.demographics SET Enrollment_Status='Email Sent' WHERE STATUS=167410001
UPDATE yzhang.demographics SET Enrollment_Status='Non responder' WHERE STATUS=167410004
UPDATE yzhang.demographics SET Enrollment_Status='Facilitated Enrollment' WHERE STATUS=167410005
UPDATE yzhang.demographics SET Enrollment_Status='Incomplete Enrollments' WHERE STATUS=167410002
UPDATE yzhang.demographics SET Enrollment_Status='Opted Out' WHERE STATUS=167410003
UPDATE yzhang.demographics SET Enrollment_Status='Unprocessed' WHERE STATUS=167410000
UPDATE yzhang.demographics SET Enrollment_Status='Second email sent' WHERE STATUS=167410006

/* Question 3*/
ALTER TABLE yzhang.demographics ADD SEX VARCHAR(255)
UPDATE yzhang.demographics SET SEX='female' WHERE gender='2'
UPDATE yzhang.demographics SET SEX='male' WHERE gender='1'
UPDATE yzhang.demographics SET SEX='other' WHERE STATUS=167410000
UPDATE yzhang.demographics SET SEX='unknown' WHERE gender is NULL

/* Question 4*/
ALTER TABLE yzhang.demographics ADD AGEGROUP VARCHAR(255)
UPDATE yzhang.demographics SET AGEGROUP='0-25' WHERE AGE<26
UPDATE yzhang.demographics SET AGEGROUP='26-50' WHERE AGE>25 AND AGE <51
UPDATE yzhang.demographics SET AGEGROUP='51-75' WHERE AGE>50 AND AGE <76
UPDATE yzhang.demographics SET AGEGROUP='76-100' WHERE AGE>75

SELECT TOP 10 * FROM yzhang.demographics








