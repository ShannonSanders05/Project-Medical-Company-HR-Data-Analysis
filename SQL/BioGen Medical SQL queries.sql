-- IMPORT TABLES

CREATE TABLE
IF NOT EXISTS attendance (

	user_id TEXT,
	location TEXT,
	date DATE,
	time TIME,
	timezone TEXT,
	case_type TEXT,
	source TEXT

);

SELECT * FROM attendance

CREATE TABLE
IF NOT EXISTS leave_requests (

	user_id TEXT,
	first_name TEXT,
	last_name TEXT,
	type TEXT,
	leave_type TEXT,
	dates TEXT,
	time_start TEXT,
	time_end TEXT,
	time_zone TEXT,
	status TEXT,
	created_at TEXT

);

SELECT * FROM leave_requests

CREATE TABLE
IF NOT EXISTS payroll (

	user_id TEXT,
	first_name TEXT,
	last_name TEXT,
	date_start DATE,
	date_end DATE,
	ctc DECIMAL (10,0),
	net_pay DECIMAL (10,0),
	gross_pay DECIMAL (10,0),
	data_salary_basic_rate DECIMAL (10,0),
	data_salary_basic_type TEXT,
	currency TEXT,
	status TEXT,
	created_at TEXT

);

SELECT * FROM payroll

CREATE TABLE
IF NOT EXISTS schedules (

	type TEXT,
	dates TEXT,
	time_start TIME,
	time_end TIME,
	timezone TEXT,
	time_planned INT,
	break_time INT,
	leave_type TEXT,
	user_id TEXT
	

);

SELECT * FROM schedules

CREATE TABLE
IF NOT EXISTS users (

	user_id TEXT,
	first_name TEXT,
	last_name TEXT,
	gender TEXT,
	date_birth DATE,
	date_hire DATE,
	date_leave DATE,
	employment TEXT,
	position TEXT,
	location TEXT,
	department TEXT,
	created_at TEXT

);

SELECT * FROM users

----------------------------------------------------

--CLEANING attendance table

SELECT * FROM attendance

SELECT user_id, location, date, time, case_type, source FROM attendance


----------------------------------------------------

--CLEANING leave_requests table

UPDATE leave_requests
SET dates = REPLACE(REPLACE(dates,'[',''),']','')

SELECT * FROM leave_requests

SELECT user_id, type, leave_type, status, TRIM(UNNEST(STRING_TO_ARRAY(dates, ','))) AS date FROM leave_requests

----------------------------------------------------

--CLEANING payroll table

SELECT * FROM payroll

SELECT user_id, 
date_start, 
date_end, 
ctc, 
net_pay, 
gross_pay, 
data_salary_basic_rate, 
data_salary_basic_type, 
currency, 
status 
FROM payroll

----------------------------------------------------

--CLEANING schedules table

SELECT * FROM schedules

UPDATE schedules
SET dates = REPLACE(REPLACE(dates,'[',''),']','')

UPDATE schedules
SET user_id = REPLACE(REPLACE(user_id,'{',''),'}','')

CREATE TABLE cleaned_schedules AS
SELECT TRIM(UNNEST(STRING_TO_ARRAY(user_id, ','))) AS user_id, type, dates,
time_start, time_end   FROM schedules

SELECT * FROM cleaned_schedules

SELECT user_id, type, TRIM(UNNEST(STRING_TO_ARRAY(dates, ','))) AS date, time_start, time_end FROM cleaned_schedules

----------------------------------------------------

--CLEANING users table

SELECT * FROM users

SELECT user_id, gender, position, location, department FROM users
