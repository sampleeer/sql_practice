CREATE DATABASE RegistryBase;
use RegistryBase;


CREATE TABLE Doctor(
`ID` BIGINT NOT NULL PRIMARY KEY ,
`FIO` VARCHAR(300) NOT NULL,
`Specialization` VARCHAR(300) NOT NULL,
`Category` VARCHAR(300) NOT NULL,
`Date of Born` DATE  NOT NULL
);

CREATE TABLE Schedule(
`ID` BIGINT  PRIMARY KEY,
`Cabinet Number` BIGINT NOT NULL,
`Start Reception Time` TIME NOT NULL,
`End Reception Time` TIME NOT NULL,
`Doctor` BIGINT,
`Event Day` VARCHAR(300),
 CHECK (`Event Day` IN ('SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY')),
 FOREIGN KEY (`Doctor`) REFERENCES Doctor(`ID`)
);

CREATE TABLE Ticket(
`ID` BIGINT  PRIMARY KEY,
`ScheduleID` BIGINT,
`Taken` BOOL, 
`Time` Time NOT NULL, 
`PatientID` BIGINT,
`Date` date, 
 FOREIGN KEY (`ScheduleID`) REFERENCES Schedule(`ID`),
 FOREIGN KEY (`PatientID`) REFERENCES Patient(`Number of Policy`)
);

-- участок 
CREATE TABLE Station(
ID BIGINT  PRIMARY KEY,
`Doctor` BIGINT,
FOREIGN KEY (`Doctor`) REFERENCES Doctor(`ID`)
);

CREATE TABLE Address(
`ID` BIGINT PRIMARY KEY,
`District` VARCHAR(300) NOT NULL,
`Street` VARCHAR(300) NOT NULL, 
`House` INT NOT NULL,
`Station` BIGINT,
FOREIGN KEY (`Station`) REFERENCES Station(`ID`)
);

CREATE TABLE Patient(
`Number of Policy` BIGINT  PRIMARY KEY,
`FIO` VARCHAR(300) NOT NULL,
`Age` INT NOT NULL,
`Gender` VARCHAR(2) NOT NULL,
`Address` BIGINT,
FOREIGN KEY (`Address`) REFERENCES Address(`ID`)
);


-- приём 
CREATE TABLE Appointment(
`ID` BIGINT NOT NULL PRIMARY KEY,
`Date` DATE NOT NULL,
`Complaints` VARCHAR(300) NOT NULL,
`Diagnosis` VARCHAR(300) NOT NULL,
`Treatment` VARCHAR(300) NOT NULL,
`Sick leave` BOOLEAN NOT NULL,
`Illness duration` INT NOT NULL,
`DoctorID` BIGINT,
`Policy of Patient` BIGINT,
`TicketID` BIGINT,
FOREIGN KEY (`DoctorID`) REFERENCES Doctor(`ID`),
FOREIGN KEY (`Policy of Patient`) REFERENCES Patient(`Number of Policy`),
FOREIGN KEY (`TicketID`) REFERENCES Ticket(`ID`)
);




USE RegistryBase;

-- Заполнение таблицы Doctor
INSERT INTO Doctor (`ID`, `FIO`, `Specialization`, `Category`, `Date of Born`)
VALUES
(1, 'Иванов Иван Иванович', 'Терапевт', 'Высшая', '1980-05-15'),
(2, 'Петров Петр Петрович', 'Хирург', 'Первая', '1975-10-20'),
(3, 'Сидорова Анна Михайловна', 'Офтальмолог', 'Вторая', '1985-02-28'),
(4, 'Смирнов Сергей Николаевич', 'Невролог', 'Высшая', '1978-08-12'),
(5, 'Александрова Елена Владимировна', 'Стоматолог', 'Первая', '1983-04-05'),
(6, 'Козлов Андрей Васильевич', 'Кардиолог', 'Вторая', '1970-11-30'),
(7, 'Новикова Мария Александровна', 'Гинеколог', 'Высшая', '1982-07-18'),
(8, 'Федоров Павел Дмитриевич', 'Отоларинголог', 'Первая', '1973-09-25'),
(9, 'Белова Алла Игоревна', 'Онколог', 'Вторая', '1988-03-08'),
(10, 'Лебедев Дмитрий Олегович', 'Педиатр', 'Высшая', '1976-06-22');

-- Заполнение таблицы участок 
INSERT INTO Station (`ID`, `Doctor`)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);



-- Заполнение таблицы Schedule
INSERT INTO Schedule (`ID`, `Cabinet Number`, `Start Reception Time`, `End Reception Time`, `Doctor`, `Event Day`)
VALUES
(1, 101, '09:00:00', '09:40:00', 1, 'MONDAY'),
(2, 102, '10:30:00', '11:10:00', 2, 'TUESDAY'),
(3, 103, '13:00:00', '13:40:00', 3, 'WEDNESDAY'),
(4, 104, '15:00:00', '15:40:00', 4, 'THURSDAY'),
(5, 105, '11:00:00', '11:40:00', 5, 'FRIDAY'),
(6, 106, '14:00:00', '14:40:00', 6, 'SATURDAY'),
(7, 107, '12:00:00', '12:40:00', 7, 'SUNDAY'),
(8, 108, '16:00:00', '16:40:00', 8, 'MONDAY'),
(9, 109, '17:00:00', '17:40:00', 9, 'TUESDAY'),
(10, 110, '08:00:00', '08:40:00', 10, 'WEDNESDAY');

-- Заполнение таблицы Address
INSERT INTO Address (`ID`, `District`, `Street`, `House`, `Station`)
VALUES
(1, 'Центральный', 'Ленина', 10, 1),
(2, 'Западный', 'Советская', 25, 2),
(3, 'Северный', 'Пушкина', 15, 3),
(4, 'Южный', 'Гагарина', 5, 4),
(5, 'Восточный', 'Мира', 12, 5),
(6, 'Северный', 'Лесная', 8, 6),
(7, 'Центральный', 'Парковая', 17, 7),
(8, 'Западный', 'Новая', 30, 8),
(9, 'Южный', 'Садовая', 3, 9),
(10, 'Восточный', 'Полярная', 21, 10);



-- Заполнение таблицы Patient
INSERT INTO Patient (`Number of Policy`, `FIO`, `Age`, `Gender`, `Address`)
VALUES
(123456789, 'Смирнова Екатерина Игоревна', 30, 'F', 1),
(987654321, 'Козлов Павел Александрович', 45, 'M', 2),
(567890123, 'Иванова Ольга Сергеевна', 28, 'F', 3),
(345678912, 'Петров Виктор Николаевич', 35, 'M', 4),
(789012345, 'Александрова Светлана Ивановна', 50, 'F', 5),
(901234567, 'Козлова Марина Викторовна', 40, 'F', 6),
(234567890, 'Лебедев Сергей Анатольевич', 55, 'M', 7),
(456789012, 'Новиков Андрей Павлович', 32, 'M', 8),
(678901234, 'Федорова Ольга Дмитриевна', 42, 'F', 9),
(890123456, 'Белов Владимир Андреевич', 38, 'M', 10);


-- Заполнение таблицы Ticket
INSERT INTO Ticket (ID, ScheduleID, Taken, Time, PatientID, Date)
VALUES
(1, 1, TRUE, '09:00:00', 123456789, '2024-01-01'),
(2, 1, FALSE, '09:20:00', null, '2024-01-01'),
(3, 2, TRUE, '10:30:00', 987654321, '2024-01-02'),
(4, 2, FALSE, '10:50:00', null, '2024-01-02'),
(5, 3, TRUE, '13:00:00', 567890123, '2024-01-03'),
(6, 3, FALSE, '13:20:00', null, '2024-01-03'),
(7, 4, TRUE, '15:00:00', 567890123, '2024-01-04'),
(8, 4, FALSE, '15:20:00', null, '2024-01-04'),
(9, 5, TRUE, '11:00:00', 345678912, '2024-01-05'),
(10, 5, FALSE, '11:20:00', null, '2024-01-05'),
(11, 6, TRUE, '14:00:00', 789012345, '2024-01-06'),
(12, 6, FALSE, '14:20:00', null, '2024-01-06'),
(13, 7, TRUE, '12:00:00', 123456789, '2024-01-07'),
(14, 7, FALSE, '12:20:00', null, '2024-01-07'),
(15, 8, TRUE, '16:00:00', 567890123, '2024-01-08'),
(16, 8, FALSE, '16:20:00', null, '2024-01-08'),
(17, 9, TRUE, '17:00:00', 987654321, '2024-01-09'),
(18, 9, FALSE, '17:20:00', null, '2024-01-09'),
(19, 10, TRUE, '08:00:00', 567890123, '2024-01-10'),
(20, 10, FALSE, '08:20:00', null, '2024-01-10');
INSERT INTO Ticket (ID, ScheduleID, Taken, Time, PatientID, Date)
VALUES
(21, 1, FALSE, '09:00:00', null, '2024-01-22');
INSERT INTO Ticket (ID, ScheduleID, Taken, Time, PatientID, Date)
VALUES
(22, 2, FALSE, '10:30:00', null, '2024-01-23');



-- Заполнение таблицы прием 
INSERT INTO Appointment (`ID`, `Date`, `Complaints`, `Diagnosis`, `Treatment`, `Sick leave`, `Illness duration`, `DoctorID`, `Policy of Patient`, `TicketID`)
VALUES
(1, '2024-01-01', 'Головная боль', 'Мигрень', 'Принять анальгин', TRUE, 3, 1, 123456789, 1),
(2, '2024-01-02', 'Боль в животе', 'Гастрит', 'Прописать антибиотики', TRUE, 5,  2, 987654321, 2),
(3, '2024-01-03', 'Рвота и температура', 'Пищевое отравление', 'Принимать уголь и обильное питье', TRUE, 3,  3, 567890123, 3),
(4, '2024-01-04', 'Температура, кашель', 'ОРВИ', 'Отдых и принять антипиретик', TRUE, 7, 3, 567890123, 4),
(5, '2024-01-05', 'Боли в спине', 'Остеохондроз', 'Физиотерапия и массаж', FALSE, 10,  4, 345678912, 5),
(6, '2024-01-06', 'Бессонница', 'Невроз', 'Назначить успокоительное', FALSE, 5,  5, 789012345, 6),
(7, '2024-01-07', 'Покраснение глаз', 'Конъюнктивит', 'Капли от воспаления', TRUE, 3,  1, 123456789, 7),
(8, '2024-01-08', 'Потеря аппетита', 'Дисбактериоз', 'Пробиотики и диета', TRUE, 7,  3, 567890123, 8),
(9, '2024-01-09', 'Зубная боль', 'Кариес', 'Пломбирование и анестезия', TRUE, 2,  2, 987654321, 9),
(10, '2024-01-10', 'Тахикардия', 'Стресс', 'Рекомендации по уменьшению стресса', FALSE, 3,  3, 567890123, 10);
