-- 4.а Процедура без параметров, 
-- возвращающая расписание работы врачей на текущую дату: ФИО врача, 
-- кабинет, время начала работы, количество записавшихся на этот день пациентов
use RegistryBase;

DELIMITER //
CREATE PROCEDURE GetDoctorScheduleForToday()
BEGIN
DECLARE currentDate DATE;
SET currentDate = CURDATE();

SELECT DISTINCT Doctor.FIO,
Schedule.`Cabinet Number` AS CabinetNumber,
Schedule.`Start Reception Time` AS StartTime,
IF(Appointment.Date = CAST(currentDate AS date), COUNT(*), 0) AS AppointmentsCount
FROM Doctor  
JOIN Schedule  ON Doctor.ID = Schedule.Doctor 
JOIN Ticket  ON Schedule.ID = Ticket.ScheduleID 
LEFT JOIN Appointment ON Appointment.TicketID = Ticket.ID
WHERE Schedule.`Event Day` = DAYNAME(currentDate)
GROUP BY Doctor.FIO, Schedule.`Cabinet Number`, Schedule.`Start Reception Time`, Appointment.Date;
END //
DELIMITER ;





DELIMITER //
CREATE PROCEDURE GetDoctorScheduleForToday()
BEGIN
DECLARE currentDate DATE;
SET currentDate = CURDATE();
SELECT 
	Doctor.FIO,
	Schedule.`Cabinet Number` AS CabinetNumber,
	Schedule.`Start Reception Time` AS StartTime,
	SUM(CASE WHEN Appointment.Date = currentDate THEN 1 ELSE 0 END) AS AppointmentsCount
FROM 
	Doctor  
	JOIN Schedule ON Doctor.ID = Schedule.Doctor 
	LEFT JOIN Ticket ON Schedule.ID = Ticket.ScheduleID 
	LEFT JOIN Appointment ON Appointment.TicketID = Ticket.ID
WHERE 
	Schedule.`Event Day` = DAYNAME(currentDate)
GROUP BY 
	Doctor.FIO, Schedule.`Cabinet Number`, Schedule.`Start Reception Time`;
END //
DELIMITER ;

drop procedure GetDoctorScheduleForToday; 
Call GetDoctorScheduleForToday();

-- не туда добавляет 
-- 4.б
-- Процедура, на входе получающая номер участка и 
-- формирующая список улиц, находящихся на этом участке

DELIMITER //

CREATE PROCEDURE GetStreetsByDistrict1(IN StationID INT)
BEGIN
    SELECT Street
    FROM Address
    WHERE `Station` =  StationID;
END //

DELIMITER ;
drop PROCEDURE GetStreetsByDistrict1;
call GetStreetsByDistrict(2);

-- 4.c Процедура, получающая номер участка как входной параметр, 
-- формирующая выходной параметр  – ФИО врача, обслуживающего данный участок
DELIMITER //

CREATE PROCEDURE GetDoctorName(IN StationID INT, OUT outDoctorName VARCHAR(300))
BEGIN
    SELECT DISTINCT Doctor.FIO INTO outDoctorName
    FROM Doctor
    JOIN Station ON Doctor.ID = Station.Doctor
    -- JOIN Address ON Station.ID = Address.Station
    WHERE Station.ID = StationID;
END //
DELIMITER ;
drop procedure GetDoctorName;
CALL GetDoctorName(1, @result);
SELECT @result AS "Доктор";


-- 4.D Процедура, находящая один из участков с максимальным 
-- количеством домов и возвращающая ФИО врача, обслуживающего данный участок 
-- (с использованием вызова предыдущей процедуры)


DELIMITER //
CREATE PROCEDURE GetDoctorForMaxHousesStation()
BEGIN
    DECLARE maxHousesStation VARCHAR(300);
    DECLARE DoctorName VARCHAR(300);
    SELECT Station INTO maxHousesStation
    FROM (
        SELECT Station, COUNT(House) AS CountHouses
        FROM Address
        GROUP BY Station
        ORDER BY CountHouses DESC
        LIMIT 1
    ) AS MaxDistrict;
    CALL GetDoctorName(maxHousesStation, DoctorName);
    SELECT DoctorName AS Doctor;
END //

DELIMITER ;
drop procedure GetDoctorForMaxHousesStation;
call GetDoctorForMaxHousesStation();


-- скалярные функции 

-- а) Скалярная функция, возвращающая по адресу (улица, дом) номер участка

DELIMITER //

CREATE FUNCTION GetStationNumberByAddress(in_street VARCHAR(300), in_house INT)
RETURNS BIGINT
DETERMINISTIC
BEGIN
    DECLARE station_number BIGINT;

    SELECT Station INTO station_number
    FROM Address
    WHERE Address.Street = in_street AND Address.House = in_house;

    RETURN station_number;
END //

DELIMITER ;
drop FUNCTION GetStationNumberByAddress;
SELECT GetStationNumberByAddress('Советская', 25) AS "Station Number";

-- b) Inline-функция, возвращающая все посещения заданного пациента за текущий год
DELIMITER //

CREATE PROCEDURE GetPatientVisitsInCurrentYear(IN patientPolicyNumber BIGINT)
BEGIN
    DECLARE currentYear INT;
    SET currentYear = YEAR(NOW());

    SELECT Appointment.*
    FROM Appointment 
    JOIN Ticket ON Appointment.TicketID = Ticket.ID
    JOIN Patient ON Ticket.PatientID = Patient.`Number of Policy`
    WHERE Patient.`Number of Policy` = patientPolicyNumber
        AND YEAR(Appointment.`Date`) = currentYear;
END //

DELIMITER ;
drop PROCEDURE GetPatientVisitsInCurrentYear;
CALL GetPatientVisitsInCurrentYear(987654321);


-- с)  Multi-statement-функция, возвращающая список свободных 
-- явок на текущую неделю к заданному врачу в формате день недели, время 

DELIMITER //
CREATE PROCEDURE GetFreeTimeOnWeek(IN doctorID INT)
BEGIN
    DECLARE currentDate DATE;
    DECLARE currentDayOfWeek INT;
    
    SET currentDate = CURDATE();
    SET currentDayOfWeek = DAYOFWEEK(currentDate);

    SET @startDate = currentDate - INTERVAL (currentDayOfWeek - 1) DAY;
    SET @endDate = @startDate + INTERVAL 6 DAY;

    -- Выбираем свободные временные интервалы для указанного врача на текущей неделе
   SELECT distinct
        `Event Day` AS "День недели",
        `Time` AS "Время талона"
    FROM Schedule
    LEFT JOIN Ticket ON Ticket.ScheduleID = Schedule.ID
    LEFT JOIN Appointment ON Ticket.ID = Appointment.TicketID
    WHERE Doctor = doctorID 
        AND ( Ticket.Taken = false AND Ticket.`Date`not between @startDate  and @endDate );
END //
DELIMITER ;

DROP PROCEDURE GetFreeTimeOnWeek;
CALL GetFreeTimeOnWeek(2);

select * from  Appointment; 
select * from  Ticket; 
INSERT INTO Ticket (ID, ScheduleID, Taken, Time, PatientID, Date)
VALUES
(23, 3, FALSE, '13:00:00', NULL, '2024-01-24');


DELETE FROM Ticket where ID = 23;