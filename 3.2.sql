-- 3.1 
-- 1.1 Выбрать из произвольной таблицы данные и отсортировать
--  их по двум  произвольным имеющимся в таблице признакам (разные направления сортировки).
-- по возрастанию
use RegistryBase;


SELECT * FROM Appointment
ORDER BY Date ASC;
-- по убыванию 
SELECT * FROM Appointment
ORDER BY Date DESC;

-- 1.2 
-- посещения, где дата позже 01 01 2024 
SELECT * FROM Appointment
WHERE Date >= '2024-01-01';

-- посещения, где тип - бессонница и болел меньше 7 суток 
SELECT * FROM Appointment
WHERE Complaints = 'Бессонница' AND `Illness duration` < 7;

-- 1.3 
-- общее количество записей 
SELECT 
	COUNT(*) AS TotalAppointments 
    FROM Appointment;
-- максимальная продолжительность болезни
SELECT 
	MAX(`Illness duration`) AS MaxIllnessDuration
    FROM Appointment;
-- количество записей по каждому врачу 
SELECT DoctorID, COUNT(*) AS AppointmentCount
FROM Appointment
GROUP BY DoctorID;
-- средняя продолжительность болезни для каждого врача
SELECT DoctorID, AVG(`Illness duration`) AS AvgIllnessDuration
FROM Appointment
GROUP BY DoctorID;
-- общее количество записей и минимальная продолжительность болезни для каждой даты
SELECT Date, COUNT(*) AS TotalAppointments, MIN(`Illness duration`) AS MinIllnessDuration
FROM Appointment
GROUP BY Date;

-- 1.4 
-- количество талонов на каждый день недели и общее количество талонов
SELECT `Event Day`, COUNT(*) as `Total Tickets`
FROM Schedule
JOIN Ticket ON Schedule.ID = Ticket.ScheduleID
GROUP BY `Event Day` WITH ROLLUP;


-- итоги для каждого дня недели и общий итог + разбиение по районам 
SELECT `Event Day`, District, AVG(Age) as `Average Age`
FROM Schedule
JOIN Ticket ON Schedule.ID = Ticket.ScheduleID
JOIN Patient ON Ticket.PatientID = Patient.`Number of Policy`
JOIN Address ON Patient.Address = Address.ID
GROUP BY `Event Day`, District WITH ROLLUP;


-- 1.5 
SELECT *
FROM Doctor
WHERE FIO NOT LIKE '%Иван%';

-- часть 2 
-- 2.1 

-- информация о приемах, где мы заменяем коды врачей, пациентов и талонов на их имена и тд
SELECT
    Doctor.FIO AS Doctor_Name,
    Patient.FIO AS Patient_Name,
    Ticket.Time AS Ticket_Time
FROM Appointment
JOIN Doctor ON Appointment.DoctorID = Doctor.ID
JOIN Patient ON Appointment.`Policy of Patient` = Patient.`Number of Policy`
JOIN Ticket ON Appointment.TicketID = Ticket.ID;

-- информацию о приемах только терапевтов 
SELECT
    Doctor.FIO AS Doctor_Name,
    Patient.FIO AS Patient_Name,
    Ticket.Time AS Ticket_Time
FROM Appointment
JOIN Doctor ON Appointment.DoctorID = Doctor.ID
JOIN Patient ON Appointment.`Policy of Patient` = Patient.`Number of Policy`
JOIN Ticket ON Appointment.TicketID = Ticket.ID
WHERE Doctor.Specialization = 'Терапевт';

-- 2.2 
SELECT
    Doctor.FIO AS Doctor_Name,
    Patient.FIO AS Patient_Name,
    Ticket.Time AS Ticket_Time
FROM Appointment
INNER JOIN Doctor ON Appointment.DoctorID = Doctor.ID
INNER JOIN Patient ON Appointment.`Policy of Patient` = Patient.`Number of Policy`
INNER JOIN Ticket ON Appointment.TicketID = Ticket.ID;

SELECT
    Doctor.FIO AS Doctor_Name,
    Patient.FIO AS Patient_Name,
    Ticket.Time AS Ticket_Time
FROM Appointment
INNER JOIN Doctor ON Appointment.DoctorID = Doctor.ID
INNER JOIN Patient ON Appointment.`Policy of Patient` = Patient.`Number of Policy`
INNER JOIN Ticket ON Appointment.TicketID = Ticket.ID
WHERE Doctor.Specialization = 'Терапевт';


-- 2.3 
-- информация о врачах и их расписании приема
SELECT
    Doctor.ID AS Doctor_ID,
    Doctor.FIO AS Doctor_Name,
    Doctor.Specialization,
    Schedule.`Cabinet Number` AS Cabinet_Number,
    Schedule.`Start Reception Time` AS Start_Time,
    Schedule.`End Reception Time` AS End_Time,
    Schedule.`Event Day` AS Reception_Day
FROM Doctor
LEFT JOIN Schedule ON Doctor.ID = Schedule.Doctor;

-- информация о пациентах и их адресах
SELECT
    Patient.`Number of Policy` AS Patient_Policy_Number,
    Patient.FIO AS Patient_Name,
    Patient.Age,
    Patient.Gender,
    Address.District,
    Address.Street,
    Address.House
FROM Patient
LEFT JOIN Address ON Patient.Address = Address.ID;

-- 2.4 
SELECT
    Doctor.ID AS Doctor_ID,
    Doctor.FIO AS Doctor_Name,
    Doctor.Specialization,
    Schedule.`Cabinet Number` AS Cabinet_Number,
    Schedule.`Start Reception Time` AS Start_Time,
    Schedule.`End Reception Time` AS End_Time,
    Schedule.`Event Day` AS Reception_Day
FROM Doctor
RIGHT JOIN Schedule ON Doctor.ID = Schedule.Doctor;


SELECT
    Patient.`Number of Policy` AS Patient_Policy_Number,
    Patient.FIO AS Patient_Name,
    Patient.Age,
    Patient.Gender,
    Address.District,
    Address.Street,
    Address.House
FROM Patient
RIGHT JOIN Address ON Patient.Address = Address.ID;

-- 2.5
-- количество талонов для каждого пациента 
SELECT
    Patient.`Number of Policy` AS Patient_Policy_Number,
    Patient.FIO AS Patient_Name,
    COUNT(Ticket.ID) AS Ticket_Count
FROM Patient
LEFT JOIN Ticket ON Patient.`Number of Policy` = Ticket.PatientID
GROUP BY Patient_Policy_Number, Patient_Name;

-- средний возраст пациентов каждого района 
SELECT
    Address.District,
    AVG(Patient.Age) AS Average_Age
FROM Patient
LEFT JOIN Address ON Patient.Address = Address.ID
GROUP BY Address.District;

-- 2.6 
-- врачи у которых более двух талонов true
SELECT
    Doctor.ID AS Doctor_ID,
    Doctor.FIO AS Doctor_Name,
    COUNT(Ticket.ID) AS Taken_Ticket_Count
FROM Doctor
LEFT JOIN Schedule ON Doctor.ID = Schedule.Doctor
LEFT JOIN Ticket ON Schedule.ID = Ticket.ScheduleID AND Ticket.Taken = TRUE
GROUP BY Doctor_ID, Doctor_Name
HAVING Taken_Ticket_Count > 2;

-- только те дни приема, где было более 1 приема
SELECT
    Schedule.`Event Day` AS Reception_Day,
    COUNT(Appointment.ID) AS Appointment_Count
FROM Schedule
LEFT JOIN Appointment ON Schedule.ID = Appointment.TicketID
GROUP BY Reception_Day
HAVING Appointment_Count > 1;

-- 2.7 
-- только те пациенты, у которых есть приемы
SELECT
    `Number of Policy` AS Patient_Policy_Number,
    FIO AS Patient_Name
FROM Patient
WHERE `Number of Policy` IN (
    SELECT DISTINCT `Policy of Patient`
    FROM Appointment
);

-- врачи, которые поставили диагноз мигрень 
SELECT
    Doctor.ID AS Doctor_ID,
    Doctor.FIO AS Doctor_Name
FROM Doctor
WHERE EXISTS (
    SELECT 1
    FROM Appointment
    WHERE Appointment.DoctorID = Doctor.ID
    AND Appointment.Diagnosis = 'Мигрень'
);

-- пациенты, которые записаны  на прием к врачу с высшей категорией
SELECT
    Patient.`Number of Policy` AS Patient_Policy_Number,
    Patient.FIO AS Patient_Name
FROM Patient
WHERE EXISTS (
    SELECT 1
    FROM Ticket
    JOIN Schedule ON Ticket.ScheduleID = Schedule.ID
    JOIN Doctor ON Schedule.Doctor = Doctor.ID
    WHERE Ticket.PatientID = Patient.`Number of Policy`
    AND Doctor.Category = 'Высшая'
);

-- тема 3 
-- 3.1 
-- информация о врачах и их расписании приема
CREATE VIEW DoctorScheduleView AS
SELECT
    Doctor.ID AS Doctor_ID,
    Doctor.FIO AS Doctor_Name,
    Doctor.Specialization,
    Schedule.`Cabinet Number` AS Cabinet_Number,
    Schedule.`Start Reception Time` AS Start_Time,
    Schedule.`End Reception Time` AS End_Time,
    Schedule.`Event Day` AS Reception_Day
FROM Doctor
LEFT JOIN Schedule ON Doctor.ID = Schedule.Doctor;

-- DROP VIEW DoctorScheduleView;
SELECT * FROM DoctorScheduleView;

-- информация о талонах и приемах
CREATE VIEW TicketAppointmentView AS
   SELECT
       Ticket.ID AS Ticket_ID,
       Ticket.Time AS Ticket_Time,
       Ticket.Date,
       Ticket.Taken,
       Appointment.Complaints,
       Appointment.Diagnosis,
       Appointment.Treatment,
       Appointment.`Sick leave`,
       Appointment.`Illness duration`
   FROM Ticket
   LEFT JOIN Appointment ON Ticket.ID = Appointment.TicketID
   WHERE Ticket.Taken = TRUE;


-- DROP VIEW TicketAppointmentView;
SELECT * FROM TicketAppointmentView;

-- 3.2
-- выбор врачей и их расписания приема
WITH DoctorSchedule AS (
    SELECT
        Doctor.ID AS Doctor_ID,
        Doctor.FIO AS Doctor_Name,
        Schedule.`Cabinet Number` AS Cabinet_Number,
        Schedule.`Start Reception Time` AS Start_Time,
        Schedule.`End Reception Time` AS End_Time,
        Schedule.`Event Day` AS Reception_Day
    FROM Doctor
    LEFT JOIN Schedule ON Doctor.ID = Schedule.Doctor
)
SELECT * FROM DoctorSchedule;

-- выбор пациентов и информации о приемах
WITH PatientAppointment AS (
    SELECT
        Patient.`Number of Policy` AS Patient_Policy_Number,
        Patient.FIO AS Patient_Name,
        Ticket.Time AS Ticket_Time,
        Ticket.Date,
        Appointment.Complaints,
        Appointment.Diagnosis,
        Appointment.Treatment,
        Appointment.`Sick leave`,
        Appointment.`Illness duration`
    FROM Patient
    LEFT JOIN Ticket ON Patient.`Number of Policy` = Ticket.PatientID
    LEFT JOIN Appointment ON Ticket.ID = Appointment.TicketID
    WHERE Ticket.Taken = TRUE
)
SELECT * FROM PatientAppointment;

-- тема 4 

-- присваиваем номер каждому пациенту в порядке возрастания возраста
SELECT
    FIO AS Patient_Name, Age, Gender,
    ROW_NUMBER() OVER (ORDER BY Age) AS RowNumber
FROM Patient;

-- присваиваем ранг каждому приему в пределах каждого врача +  упорядычиваем по дате
SELECT
    DoctorID, Date, Complaints,
    RANK() OVER (PARTITION BY DoctorID ORDER BY Date) AS AppointmentRank
FROM Appointment;

-- присваиваем  ранг каждой специализации врача в порядке возрастания их категории
SELECT
    Specialization, Category,
    DENSE_RANK() OVER (ORDER BY Category) AS DenseRank
FROM Doctor;

-- тема 5 
-- выводим кардиологов и объединяем данные из таблицы пациентов и врачей 
SELECT
    `Number of Policy` AS ID,
    FIO AS Name
FROM Patient
WHERE Gender = 'F'
UNION ALL
SELECT
    ID, FIO
FROM Doctor
WHERE Specialization = 'Кардиолог'
ORDER BY ID; 

-- выбора пациентов, которые не имеют талоны на прием к врачам
SELECT
    `Number of Policy` AS ID,
    FIO AS Name
FROM Patient
WHERE Age < 40
EXCEPT
SELECT
    Patient.`Number of Policy` AS ID,
    Patient.FIO AS Name
FROM Ticket
JOIN Schedule ON Ticket.ScheduleID = Schedule.ID
JOIN Doctor ON Schedule.Doctor = Doctor.ID
JOIN Patient ON Ticket.PatientID = Patient.`Number of Policy`
ORDER BY ID; 

-- выбор уникальных пациентов младше 40 лет, у которых есть талоны на прием к врачам
SELECT
    `Number of Policy` AS ID,
    FIO AS Name
FROM Patient
WHERE Age < 40
AND `Number of Policy` IN (
    SELECT PatientID
    FROM Ticket
    INTERSECT
    SELECT Patient.`Number of Policy`
    FROM Ticket
    JOIN Schedule ON Ticket.ScheduleID = Schedule.ID
    JOIN Doctor ON Schedule.Doctor = Doctor.ID
    JOIN Patient ON Ticket.PatientID = Patient.`Number of Policy`
    WHERE Ticket.Taken = TRUE
)
ORDER BY ID; 

-- тема 6 

-- 6.1 
-- подсчет посещений у каждого доктора на каждый денб недели 
SELECT
    Doctor.ID AS DoctorID,
    Doctor.FIO AS DoctorName,
    SUM(CASE WHEN Schedule.`Event Day` = 'MONDAY' THEN 1 ELSE 0 END) AS MondayAppointments,
    SUM(CASE WHEN Schedule.`Event Day` = 'TUESDAY' THEN 1 ELSE 0 END) AS TuesdayAppointments,
    SUM(CASE WHEN Schedule.`Event Day` = 'WEDNESDAY' THEN 1 ELSE 0 END) AS WednesdayAppointments,
    SUM(CASE WHEN Schedule.`Event Day` = 'THURSDAY' THEN 1 ELSE 0 END) AS ThursdayAppointments,
    SUM(CASE WHEN Schedule.`Event Day` = 'FRIDAY' THEN 1 ELSE 0 END) AS FridayAppointments,
    SUM(CASE WHEN Schedule.`Event Day` = 'SATURDAY' THEN 1 ELSE 0 END) AS SaturdayAppointments,
    SUM(CASE WHEN Schedule.`Event Day` = 'SUNDAY' THEN 1 ELSE 0 END) AS SundayAppointments
FROM Doctor 
LEFT JOIN Schedule ON Doctor.ID = Schedule.Doctor
GROUP BY Doctor.ID, Doctor.FIO;


-- 6.2
-- в mysql нет pivot \ unpivot, можно попробовать через union или case что-то придумать 

-- имитация pivot 
-- покажем принадлежность врача к той или иной специализации 
SELECT ID, 
   MAX(CASE WHEN Specialization = 'Терапевт' THEN 'YES' ELSE 'NO' END) AS `Терапевт`,
   MAX(CASE WHEN Specialization = 'Хирург' THEN 'YES' ELSE 'NO' END) AS `Хирург`,
   MAX(CASE WHEN Specialization = 'Офтальмолог' THEN 'YES' ELSE 'NO' END) AS `Офтальмолог`
FROM Doctor
GROUP BY ID;

-- имитация unpivot 
-- покажем каждого доктора и его артибуты 

SELECT ID, FIO AS Attribute, Specialization AS Value
FROM Doctor
UNION
SELECT ID, FIO AS Attribute, Category AS Value
FROM Doctor
UNION
SELECT ID, FIO AS Attribute, DATE_FORMAT(`Date of Born`, '%Y-%m-%d') AS Value
FROM Doctor;






