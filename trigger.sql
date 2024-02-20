-- триггеры 
-- Триггер любого типа на добавление нового врача – если это терапевт 
-- и номер участка не заполнен, то выводится сообщение об этом,
--  и запись не добавляется
-- триггер перед before 
use RegistryBase;



DELIMITER //
CREATE TRIGGER BeforeInsertDoctor
BEFORE INSERT ON Doctor
FOR EACH ROW
BEGIN
    DECLARE doctorStationID INT;

    -- Проверка, что если врач терапевт, то номер участка не указан
    IF NEW.Specialization = 'Терапевт' AND NOT EXISTS (SELECT 1 FROM Station WHERE Doctor IS NULL) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ошибка: Не указан номер участка для терапевта.';
    END IF;
END;
//
DELIMITER ;

DROP TRIGGER IF EXISTS BeforeInsertDoctor;

DELIMITER //
CREATE TRIGGER BeforeInsertDoctor
BEFORE INSERT ON Doctor
FOR EACH ROW
BEGIN
    DECLARE StationID INT;

    -- Проверка, что если врач терапевт, то номер участка не указан
    IF NEW.Specialization = 'Терапевт' AND NOT EXISTS (SELECT 1 FROM Station WHERE Doctor IS NULL) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ошибка: Не указан номер участка для терапевта.';
    ELSE
        -- Если врач терапевт и есть свободное поле в Station, связываем их
        IF NEW.Specialization = 'Терапевт' THEN
            SET StationID = (SELECT ID FROM Station WHERE Doctor IS NULL LIMIT 1);
            UPDATE Station SET `Doctor` = NEW.`ID` WHERE `ID` = StationID;
        END IF;
    END IF;
END;
//
DELIMITER ;


DELETE FROM Doctor WHERE ID = 11;
 -- если это терапевт и есть хотя бы 1 id с null,  то добавляем 
-- если поля null нет,  то не добавляет 

INSERT INTO Station (`ID`, `Doctor`)
VALUES
(11, null);

 UPDATE Station SET `Doctor` = 11 WHERE `ID` = 11;


INSERT INTO Doctor (`ID`, `FIO`, `Specialization`, `Category`, `Date of Born`)
VALUES (11, 'Тестов Тест Тестович', 'Терапевт', 'Высшая', '1990-01-01');

select * from  Station; 
select * from  Doctor; 
delete  from Station where ID = 11; 
delete  from Doctor where ID = 12; 
-- --------------------------------------------------------------------------------------------------------------------------------------------

-- Последующий триггер на изменение номера кабинета у врача – если этот
--  кабинет проставлен у другого врача и он пересекается по дням недели
--  хотя бы в 1 день с данным врачом, то отменить изменение
-- загуглить if \ else if - не совпадают дни 
-- перебрать все случаи 


DELIMITER //
CREATE TRIGGER BeforeUpdateDoctorCabinet
BEFORE UPDATE ON Schedule
FOR EACH ROW
BEGIN
    DECLARE otherDoctorID INT;

    -- Проверка, что кабинет уже используется другим врачом
    -- смотрим всех докторов, если выполнились условия, которые не подходят 
    SET otherDoctorID = (
        SELECT Doctor 
        FROM Schedule 
        WHERE `Cabinet Number` = NEW.`Cabinet Number` 
          AND `Event Day` = NEW.`Event Day` 
          AND NEW.Doctor != Doctor
          AND (NEW.`End Reception Time` > `Start Reception Time` AND NEW.`Start Reception Time` < `End Reception Time`)
          LIMIT 1
    ); 
        
    IF otherDoctorID IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ошибка: Кабинет уже используется другим врачом в тот же день недели и пересекается по времени работы.';
    END IF;	
END;
//
DELIMITER ;

-- Error Code: 1193. Unknown system variable 'MESSAGE_TEXT'

UPDATE Schedule
SET `Cabinet Number` = 108,
    `Start Reception Time` = '10:00:00', 
    `End Reception Time` = '11:00:00'
WHERE `Doctor` = 1
      AND `Event Day` = 'MONDAY';

UPDATE Schedule
SET `Cabinet Number` = 108,
    `Start Reception Time` = '16:20:00', 
    `End Reception Time` = '17:00:00'
WHERE `Doctor` = 1
      AND `Event Day` = 'MONDAY';



DROP TRIGGER IF EXISTS BeforeUpdateDoctorCabinet;


-- Предположим, что номер кабинета 101 уже используется в понедельник  другим врачом
-- INSERT INTO Schedule (`ID`, `Cabinet Number`, `Start Reception Time`, `End Reception Time`, `Doctor`, `Event Day`)
-- VALUES (11, 101, '09:00:00', '09:40:00', 2, 'MONDAY');
-- DELETE FROM Schedule WHERE ID = 11;

-- --------------------------------------------------------------------------------------------------------------------------------------------


-- Замещающий триггер на операцию удаления строки из графика приема врача 
-- – если на даты, соответствующие дню недели удаляемой строки, выданы талоны,
--  то строка не удаляется
-- смотреть на будущее 
-- они выданы 
-- если таких нет 
-- то при удалении удалить все 
-- так как будут ссылки в талонах 
-- просто есть день недели, и у врача есть талоны, то не могу удалять 

DROP TRIGGER IF EXISTS BeforeDeleteSchedule;


INSERT INTO Schedule (`ID`, `Cabinet Number`, `Start Reception Time`, `End Reception Time`, `Doctor`, `Event Day`)
VALUES (21, 101, '09:00:00', '09:40:00', 2, 'MONDAY');
INSERT INTO Ticket (ID, ScheduleID, Taken, Time, PatientID, Date)
VALUES (31, 21, TRUE, '09:00:00', 123456789, '2024-01-29');
DELETE FROM Schedule WHERE ID = 21;
INSERT INTO Ticket (ID, ScheduleID, Taken, Time, PatientID, Date)
VALUES (31, 21, TRUE, '09:00:00', 123456789, '2023-01-29');
DELETE FROM Ticket WHERE ID = 31;
select * from  Ticket; 
select * from Schedule;
SELECT * FROM Schedule WHERE ID = 21;
DELIMITER //
CREATE TRIGGER BeforeDeleteSchedule
BEFORE DELETE ON Schedule
FOR EACH ROW
BEGIN
    DECLARE HasTakenTickets INT;

    -- в будущем нет билетов - от сегодня и далее 
    SET HasTakenTickets = (
        SELECT COUNT(*)
        FROM Ticket
        WHERE ScheduleID = OLD.`ID` 
            AND Taken = TRUE 
            AND DAYOFWEEK(Date) = 
                CASE OLD.`Event Day`
                    WHEN 'MONDAY' THEN 2
                    WHEN 'TUESDAY' THEN 3
                    WHEN 'WEDNESDAY' THEN 4
                    WHEN 'THURSDAY' THEN 5
                    WHEN 'FRIDAY' THEN 6
                    WHEN 'SATURDAY' THEN 7
                    WHEN 'SUNDAY' THEN 1
                    ELSE 0
                END
            AND Date >= CURDATE()  -- Учитываем только будущие даты
    );

    -- Если есть выданные талоны, создаем ошибку
    IF HasTakenTickets > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ошибка: Нельзя удалить строку, так как есть выданные талоны на удаляемую дату.';
    ELSE
        -- Удаление талонов с Taken = FALSE на удаляемую дату
        DELETE FROM Ticket
        WHERE ScheduleID = OLD.`ID`;
    END IF;
END //
DELIMITER ;


DELIMITER //
CREATE TRIGGER BeforeDeleteSchedule
BEFORE DELETE ON Schedule
FOR EACH ROW
BEGIN
    DECLARE HasTakenTickets INT;

    -- Проверка, есть ли талоны на удаляемую дату
    SET HasTakenTickets = (
        SELECT COUNT(*)
        FROM Ticket
        WHERE ScheduleID = OLD.`ID` AND Taken = TRUE AND Date >= CURDATE() AND DAYOFWEEK(Date) = 
                CASE OLD.`Event Day`
                    WHEN 'MONDAY' THEN 2
                    WHEN 'TUESDAY' THEN 3
                    WHEN 'WEDNESDAY' THEN 4
                    WHEN 'THURSDAY' THEN 5
                    WHEN 'FRIDAY' THEN 6
                    WHEN 'SATURDAY' THEN 7
                    WHEN 'SUNDAY' THEN 1
                    ELSE 0
                END
    );

    -- Если есть выданные талоны, создаем ошибку
    IF HasTakenTickets > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ошибка: Нельзя удалить строку, так как есть выданные талоны на удаляемую дату.';
    ELSE
        -- Удаление талонов с Taken = FALSE на удаляемую дату
        DELETE FROM Ticket
        WHERE ScheduleID = OLD.`ID`;
    END IF;
END;
//
DELIMITER ;









DELIMITER //
CREATE TRIGGER DeleteSchedule
BEFORE DELETE
ON Schedule
FOR EACH ROW
BEGIN
IF Old.ID IN (SELECT Ticket.ScheduleID FROM Ticket) THEN
SIGNAL SQLSTATE '45000' -- код из mysql (так надо) 
SET MESSAGE_TEXT = 'Есть талоны в этот день';
END IF;
END // 
DELIMITER ;

DROP TRIGGER IF EXISTS DeleteSchedule;

DELETE FROM Schedule 
Where ID = 10;