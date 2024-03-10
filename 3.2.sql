-- a) Выбрать информацию о свободных талонах к заданному врачу на заданный день недели
use RegistryBase;

SELECT 
    Schedule.`Event Day` AS 'День',
    Doctor.`FIO` AS 'Доктор',
    Ticket.`Time` AS 'Время'
FROM Ticket
JOIN Schedule ON Ticket.`ScheduleID` = Schedule.`ID`
JOIN Doctor ON Schedule.`Doctor` = Doctor.`ID`
WHERE Doctor.`FIO` = 'Петров Петр Петрович'
    AND Schedule.`Event Day` = 'TUESDAY'
    AND Ticket.`Taken` = FALSE;



-- b) Для заданного пациента (ФИО) выдать все его посещения 

SELECT 
    Appointment.`Date` AS 'Дата посещения',
    Appointment.`Complaints` AS 'Жалобы',
    Appointment.`Diagnosis` AS 'Диагноз',
    Appointment.`Treatment` AS 'Лечение',
    Appointment.`Sick leave` AS 'Больничный лист',
    Appointment.`Illness duration` AS 'Продолжительность болезни',
    Appointment.`DoctorID` AS 'Лечащий врач'
FROM Patient
JOIN Appointment ON Patient.`Number of Policy` = Appointment.`Policy of Patient`
WHERE Patient.`FIO` = 'Козлов Павел Александрович'
    AND YEAR(Appointment.`Date`) = YEAR(CURDATE());


-- c) Пациент пришел на медосмотр. Выбрать всех специалистов, к которым он может сегодня попасть:

SELECT DISTINCT
    Doctor.`FIO` AS 'Специалист',
    Schedule.`Cabinet Number` AS 'Номер кабинета',
    Schedule.`Start Reception Time` AS 'Время начала приема',
    Schedule.`End Reception Time` AS 'Время окончания приема',
    Schedule.`Event Day` AS 'День недели'
FROM Schedule
JOIN Doctor ON Schedule.`Doctor` = Doctor.`ID`
WHERE Schedule.`Event Day` = DAYNAME(CURDATE());

  
-- d) Подсчитать количество посещений с диагнозом «ОРВИ» 
-- с начала текущего года с разбивкой по возрастам: от 14 до 18 лет, от 19 д 45, от 46 до 65, от 66
-- плохой вариант 
WITH Age_14_18 AS (
SELECT Patient.`Number of Policy`, Appointment.`Diagnosis`, "14-18" AS `Age group`
FROM Patient RIGHT JOIN Appointment ON Patient.`Number of Policy` = Appointment.`Policy of Patient`
	WHERE Patient.`Age` BETWEEN 14 AND 18 AND
     Appointment.`Diagnosis` = 'ОРВИ' AND YEAR(Appointment.`Date`) = YEAR(CURDATE())), 
Age_19_45 AS (
SELECT Patient.`Number of Policy`, Appointment.`Diagnosis`, "19-45" AS `Age group`
FROM Patient RIGHT JOIN Appointment ON Patient.`Number of Policy` = Appointment.`Policy of Patient`
	WHERE Patient.`Age` BETWEEN 19 AND 45 AND
     Appointment.`Diagnosis` = 'ОРВИ' AND YEAR(Appointment.`Date`) = YEAR(CURDATE())),
Age_46_65 AS (
SELECT Patient.`Number of Policy`, Appointment.`Diagnosis`, "46-65" AS `Age group`
FROM Patient RIGHT JOIN Appointment ON Patient.`Number of Policy` = Appointment.`Policy of Patient`
	WHERE Patient.`Age` BETWEEN 46 AND 65 AND
     Appointment.`Diagnosis` = 'ОРВИ' AND YEAR(Appointment.`Date`) = YEAR(CURDATE())), 
Age_66_Infinity AS (
SELECT Patient.`Number of Policy`, Appointment.`Diagnosis`, "66-infinity" AS `Age group`
FROM Patient RIGHT JOIN Appointment ON Patient.`Number of Policy` = Appointment.`Policy of Patient`
	WHERE Patient.`Age` > 65 AND
     Appointment.`Diagnosis` = 'ОРВИ' AND YEAR(Appointment.`Date`) = YEAR(CURDATE())) 
     
	SELECT NEW_GROUPS.`Diagnosis`, NEW_GROUPS.`Age group`, COUNT(*)
    FROM( 
    SELECT* FROM Age_14_18 UNION ALL SELECT* FROM Age_19_45 UNION ALL
     SELECT* FROM Age_46_65 UNION ALL  SELECT* FROM Age_66_Infinity) 
     AS NEW_GROUPS
     GROUP BY NEW_GROUPS.`Age group`, NEW_GROUPS.`Diagnosis`;
     
-- сумму от каждого case 
-- правильный вариант
SELECT
  SUM(CASE WHEN Patient.Age BETWEEN 14 AND 18 THEN 1 ELSE 0 END) AS "14-18",
  SUM(CASE WHEN Patient.Age BETWEEN 19 AND 45 THEN 1 ELSE 0 END) AS "19-45",
  SUM(CASE WHEN Patient.Age BETWEEN 46 AND 65 THEN 1 ELSE 0 END) AS "46-65",
  SUM(CASE WHEN Patient.Age > 65 THEN 1 ELSE 0 END) AS "66-infinity"
FROM Appointment
LEFT JOIN Patient ON Appointment.`Policy of Patient` = Patient.`Number of Policy`
WHERE Appointment.`Diagnosis` = 'ОРВИ' AND YEAR(Appointment.`Date`) = YEAR(CURDATE());


-- тех лет, которых нет, тоже 0 
-- e) Вывести количество посещений для каждого участка на заданную дату
-- выводить 0, по категориям которых нет 


SELECT Address.District, COUNT(Appointment.`Policy of Patient`) AS VisitsCount
FROM Address
LEFT JOIN Patient ON Address.ID = Patient.Address
LEFT JOIN Appointment ON Patient.`Number of Policy` = Appointment.`Policy of Patient`  and Appointment.Date = "2024-01-10"
GROUP BY Address.District ;



-- просто проверка хззачем
select Address.District, COUNT(visits.ai) as counts from Address left join ( 
select Address.ID as a, Appointment.ID as ai
FROM Address
LEFT JOIN Patient ON Address.ID = Patient.Address
LEFT JOIN Appointment ON Patient.`Number of Policy` = Appointment.`Policy of Patient`  where Appointment.Date = "2024-01-10") as visits 
on Address.ID = visits.a
group by  Address.District
;

