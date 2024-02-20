set language english

SELECT 
    [Event Day] AS 'Äåíü',
    [FIO] AS 'Äîêòîð',
    [Time] AS 'Âðåìÿ'
FROM Ticket_G AS t, Schedule_G as s , Doctor_G as d, Ñîñòàâèë as make, Ïðèíàäëåæèò as part
WHERE MATCH(d-(make)->s-(part)->t) and 
[FIO] = 'Ïåòðîâ Ïåòð Ïåòðîâè÷'
    AND [Event Day] = 'TUESDAY'
    AND [Taken] = 0;


-- 2

SELECT 
    [Date] AS 'Äàòà ïîñåùåíèÿ',
    [Complaints] AS 'Æàëîáû',
    [Diagnosis] AS 'Äèàãíîç',
    [Treatment] AS 'Ëå÷åíèå',
    [Sick leave] AS 'Áîëüíè÷íûé ëèñò',
    [Illness duration] AS 'Ïðîäîëæèòåëüíîñòü áîëåçíè'
FROM Patient_G AS p, Appointment_G as a, Ïðèø¸ë as cum 
WHERE MATCH(p-(cum)->a)
and [FIO] = 'Êîçëîâ Ïàâåë Àëåêñàíäðîâè÷'
    AND YEAR([Date]) = YEAR(GETDATE());


SELECT DISTINCT
    [FIO] AS 'Ñïåöèàëèñò',
    [Cabinet Number] AS 'Íîìåð êàáèíåòà',
    [Start Reception Time] AS 'Âðåìÿ íà÷àëà ïðèåìà',
    [End Reception Time] AS 'Âðåìÿ îêîí÷àíèÿ ïðèåìà',
    [Event Day] AS 'Äåíü íåäåëè'
FROM Schedule_G AS s, Doctor_G AS d, Ñîñòàâèë AS make
WHERE MATCH(d-(make)->s)
    AND [Event Day] = DATENAME(dw, GETDATE());

-- SELECT DAYNAME(GETDATE())

SELECT
  SUM(CASE WHEN p.[Age] BETWEEN 14 AND 18 THEN 1 ELSE 0 END) AS "14-18",
  SUM(CASE WHEN p.[Age] BETWEEN 19 AND 45 THEN 1 ELSE 0 END) AS "19-45",
  SUM(CASE WHEN p.[Age] BETWEEN 46 AND 65 THEN 1 ELSE 0 END) AS "46-65",
  SUM(CASE WHEN p.[Age] > 65 THEN 1 ELSE 0 END) AS "66-infinity"
FROM Appointment_G AS a, Patient_G AS p, Ïðèø¸ë AS came
WHERE MATCH(p-(came)->a)
    AND [Diagnosis] = 'ÎÐÂÈ'
    AND YEAR([Date]) = YEAR(GETDATE());




SELECT Address_G.District, COUNT(Visits.agid) as VisitsCount FROM  Address_G LEFT JOIN (
SELECT a.ID as aid, ag.ID as agid
FROM Address_G as a, [Ïðîæèâàåò] AS live, [Ïðèø¸ë] AS come, Patient_G AS p, Appointment_G AS ag
WHERE MATCH (ag<-(come)-p-(live)->a) and ag.[Date] = '2024-01-10' ) AS Visits ON  Address_G.ID =  Visits.aid
GROUP BY District;



--SELECT DISTINCT
--    [FIO] AS 'Ñïåöèàëèñò',
--    [Cabinet Number] AS 'Íîìåð êàáèíåòà',
--    [Start Reception Time] AS 'Âðåìÿ íà÷àëà ïðèåìà',
--    [End Reception Time] AS 'Âðåìÿ îêîí÷àíèÿ ïðèåìà',
--    [Event Day] AS 'Äåíü íåäåëè'
--FROM Schedule_G AS s, Doctor_G AS d, Ñîñòàâèë AS make
--WHERE MATCH(d-(make)->s)
--    AND [Event Day] = 

--	SELECT DISTINCT
--	Doctor.FIO AS 'Ñïåöèàëèñò',
--	Schedule.[Cabinet Number] AS 'Íîìåð êàáèíåòà',
--	Schedule.[Start Reception Time] AS 'Âðåìÿ íà÷àëà ïðèåìà',
--	Schedule.[End Reception Time] AS 'Âðåìÿ îêîí÷àíèÿ ïðèåìà',
--	Schedule.[Event Day] AS 'Äåíü íåäåëè'
--	FROM Schedule
--	JOIN Doctor ON Schedule.Doctor = Doctor.ID
--	WHERE Schedule.[Event Day] = DATENAME(dw, GETDATE());


--SELECT  a.District, COUNT(p.[Number of Policy]) AS VisitsCount
--FROM Address_G AS a, Patient_G AS p, [Ïðîæèâàåò] AS live, Appointment_G AS ag, [Ïðèø¸ë] AS come
--WHERE MATCH(ag<-(come)-p-(live)->a) AND ag.[Date] = '2024-01-10'
--GROUP BY a.District;

--select * from Appointment


--select DATENAME(dw, GETDATE());
