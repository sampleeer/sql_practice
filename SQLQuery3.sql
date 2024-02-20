set language english

SELECT 
    [Event Day] AS 'День',
    [FIO] AS 'Доктор',
    [Time] AS 'Время'
FROM Ticket_G AS t, Schedule_G as s , Doctor_G as d, Составил as make, Принадлежит as part
WHERE MATCH(d-(make)->s-(part)->t) and 
[FIO] = 'Петров Петр Петрович'
    AND [Event Day] = 'TUESDAY'
    AND [Taken] = 0;


-- 2

SELECT 
    [Date] AS 'Дата посещения',
    [Complaints] AS 'Жалобы',
    [Diagnosis] AS 'Диагноз',
    [Treatment] AS 'Лечение',
    [Sick leave] AS 'Больничный лист',
    [Illness duration] AS 'Продолжительность болезни'
FROM Patient_G AS p, Appointment_G as a, Пришёл as cum 
WHERE MATCH(p-(cum)->a)
and [FIO] = 'Козлов Павел Александрович'
    AND YEAR([Date]) = YEAR(GETDATE());


SELECT DISTINCT
    [FIO] AS 'Специалист',
    [Cabinet Number] AS 'Номер кабинета',
    [Start Reception Time] AS 'Время начала приема',
    [End Reception Time] AS 'Время окончания приема',
    [Event Day] AS 'День недели'
FROM Schedule_G AS s, Doctor_G AS d, Составил AS make
WHERE MATCH(d-(make)->s)
    AND [Event Day] = DATENAME(dw, GETDATE());

-- SELECT DAYNAME(GETDATE())

SELECT
  SUM(CASE WHEN p.[Age] BETWEEN 14 AND 18 THEN 1 ELSE 0 END) AS "14-18",
  SUM(CASE WHEN p.[Age] BETWEEN 19 AND 45 THEN 1 ELSE 0 END) AS "19-45",
  SUM(CASE WHEN p.[Age] BETWEEN 46 AND 65 THEN 1 ELSE 0 END) AS "46-65",
  SUM(CASE WHEN p.[Age] > 65 THEN 1 ELSE 0 END) AS "66-infinity"
FROM Appointment_G AS a, Patient_G AS p, Пришёл AS came
WHERE MATCH(p-(came)->a)
    AND [Diagnosis] = 'ОРВИ'
    AND YEAR([Date]) = YEAR(GETDATE());




SELECT Address_G.District, COUNT(Visits.agid) as VisitsCount FROM  Address_G LEFT JOIN (
SELECT a.ID as aid, ag.ID as agid
FROM Address_G as a, [Проживает] AS live, [Пришёл] AS come, Patient_G AS p, Appointment_G AS ag
WHERE MATCH (ag<-(come)-p-(live)->a) and ag.[Date] = '2024-01-10' ) AS Visits ON  Address_G.ID =  Visits.aid
GROUP BY District;



--SELECT DISTINCT
--    [FIO] AS 'Специалист',
--    [Cabinet Number] AS 'Номер кабинета',
--    [Start Reception Time] AS 'Время начала приема',
--    [End Reception Time] AS 'Время окончания приема',
--    [Event Day] AS 'День недели'
--FROM Schedule_G AS s, Doctor_G AS d, Составил AS make
--WHERE MATCH(d-(make)->s)
--    AND [Event Day] = 

--	SELECT DISTINCT
--	Doctor.FIO AS 'Специалист',
--	Schedule.[Cabinet Number] AS 'Номер кабинета',
--	Schedule.[Start Reception Time] AS 'Время начала приема',
--	Schedule.[End Reception Time] AS 'Время окончания приема',
--	Schedule.[Event Day] AS 'День недели'
--	FROM Schedule
--	JOIN Doctor ON Schedule.Doctor = Doctor.ID
--	WHERE Schedule.[Event Day] = DATENAME(dw, GETDATE());


--SELECT  a.District, COUNT(p.[Number of Policy]) AS VisitsCount
--FROM Address_G AS a, Patient_G AS p, [Проживает] AS live, Appointment_G AS ag, [Пришёл] AS come
--WHERE MATCH(ag<-(come)-p-(live)->a) AND ag.[Date] = '2024-01-10'
--GROUP BY a.District;

--select * from Appointment


--select DATENAME(dw, GETDATE());