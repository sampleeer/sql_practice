set language english

SELECT 
    [Event Day] AS '����',
    [FIO] AS '������',
    [Time] AS '�����'
FROM Ticket_G AS t, Schedule_G as s , Doctor_G as d, �������� as make, ����������� as part
WHERE MATCH(d-(make)->s-(part)->t) and 
[FIO] = '������ ���� ��������'
    AND [Event Day] = 'TUESDAY'
    AND [Taken] = 0;


-- 2

SELECT 
    [Date] AS '���� ���������',
    [Complaints] AS '������',
    [Diagnosis] AS '�������',
    [Treatment] AS '�������',
    [Sick leave] AS '���������� ����',
    [Illness duration] AS '����������������� �������'
FROM Patient_G AS p, Appointment_G as a, ������ as cum 
WHERE MATCH(p-(cum)->a)
and [FIO] = '������ ����� �������������'
    AND YEAR([Date]) = YEAR(GETDATE());


SELECT DISTINCT
    [FIO] AS '����������',
    [Cabinet Number] AS '����� ��������',
    [Start Reception Time] AS '����� ������ ������',
    [End Reception Time] AS '����� ��������� ������',
    [Event Day] AS '���� ������'
FROM Schedule_G AS s, Doctor_G AS d, �������� AS make
WHERE MATCH(d-(make)->s)
    AND [Event Day] = DATENAME(dw, GETDATE());

-- SELECT DAYNAME(GETDATE())

SELECT
  SUM(CASE WHEN p.[Age] BETWEEN 14 AND 18 THEN 1 ELSE 0 END) AS "14-18",
  SUM(CASE WHEN p.[Age] BETWEEN 19 AND 45 THEN 1 ELSE 0 END) AS "19-45",
  SUM(CASE WHEN p.[Age] BETWEEN 46 AND 65 THEN 1 ELSE 0 END) AS "46-65",
  SUM(CASE WHEN p.[Age] > 65 THEN 1 ELSE 0 END) AS "66-infinity"
FROM Appointment_G AS a, Patient_G AS p, ������ AS came
WHERE MATCH(p-(came)->a)
    AND [Diagnosis] = '����'
    AND YEAR([Date]) = YEAR(GETDATE());




SELECT Address_G.District, COUNT(Visits.agid) as VisitsCount FROM  Address_G LEFT JOIN (
SELECT a.ID as aid, ag.ID as agid
FROM Address_G as a, [���������] AS live, [������] AS come, Patient_G AS p, Appointment_G AS ag
WHERE MATCH (ag<-(come)-p-(live)->a) and ag.[Date] = '2024-01-10' ) AS Visits ON  Address_G.ID =  Visits.aid
GROUP BY District;



--SELECT DISTINCT
--    [FIO] AS '����������',
--    [Cabinet Number] AS '����� ��������',
--    [Start Reception Time] AS '����� ������ ������',
--    [End Reception Time] AS '����� ��������� ������',
--    [Event Day] AS '���� ������'
--FROM Schedule_G AS s, Doctor_G AS d, �������� AS make
--WHERE MATCH(d-(make)->s)
--    AND [Event Day] = 

--	SELECT DISTINCT
--	Doctor.FIO AS '����������',
--	Schedule.[Cabinet Number] AS '����� ��������',
--	Schedule.[Start Reception Time] AS '����� ������ ������',
--	Schedule.[End Reception Time] AS '����� ��������� ������',
--	Schedule.[Event Day] AS '���� ������'
--	FROM Schedule
--	JOIN Doctor ON Schedule.Doctor = Doctor.ID
--	WHERE Schedule.[Event Day] = DATENAME(dw, GETDATE());


--SELECT  a.District, COUNT(p.[Number of Policy]) AS VisitsCount
--FROM Address_G AS a, Patient_G AS p, [���������] AS live, Appointment_G AS ag, [������] AS come
--WHERE MATCH(ag<-(come)-p-(live)->a) AND ag.[Date] = '2024-01-10'
--GROUP BY a.District;

--select * from Appointment


--select DATENAME(dw, GETDATE());