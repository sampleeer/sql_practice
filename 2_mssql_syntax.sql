-- Ñîçäàíèå áàçû äàííûõ
CREATE DATABASE RegistryBase;
USE RegistryBase;

-- Ñîçäàíèå òàáëèöû Doctor
CREATE TABLE Doctor (
    ID BIGINT PRIMARY KEY,
    FIO VARCHAR(300) NOT NULL,
    Specialization VARCHAR(300) NOT NULL,
    Category VARCHAR(300) NOT NULL,
    [Date of Born] DATE NOT NULL
); 

-- Ñîçäàíèå òàáëèöû Schedule
CREATE TABLE Schedule (
    ID BIGINT PRIMARY KEY,
    [Cabinet Number] BIGINT NOT NULL,
    [Start Reception Time] TIME NOT NULL,
    [End Reception Time] TIME NOT NULL,
    Doctor BIGINT,
    [Event Day] VARCHAR(300),
    CHECK ([Event Day] IN ('SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY')),
    FOREIGN KEY (Doctor) REFERENCES Doctor(ID)
);

-- Ñîçäàíèå òàáëèöû Ticket
CREATE TABLE Ticket (
    ID BIGINT PRIMARY KEY,
    ScheduleID BIGINT,
    Taken BIT,
    [Time] TIME NOT NULL,
    PatientID BIGINT,
    [Date] DATE,
    FOREIGN KEY (ScheduleID) REFERENCES Schedule(ID),
    FOREIGN KEY (PatientID) REFERENCES Patient([Number of Policy])
);

-- Ñîçäàíèå òàáëèöû Station
CREATE TABLE Station (
    ID BIGINT PRIMARY KEY,
    Doctor BIGINT,
    FOREIGN KEY (Doctor) REFERENCES Doctor(ID)
);

-- Ñîçäàíèå òàáëèöû Address
CREATE TABLE Address (
    ID BIGINT PRIMARY KEY,
    District VARCHAR(300) NOT NULL,
    Street VARCHAR(300) NOT NULL,
    House INT NOT NULL,
    Station BIGINT,
    FOREIGN KEY (Station) REFERENCES Station(ID)
);

-- Ñîçäàíèå òàáëèöû Patient
CREATE TABLE Patient (
    [Number of Policy] BIGINT PRIMARY KEY,
    FIO VARCHAR(300) NOT NULL,
    Age INT NOT NULL,
    Gender VARCHAR(2) NOT NULL,
    [Address] BIGINT,
    FOREIGN KEY (Address) REFERENCES Address(ID)
); 

-- Ñîçäàíèå òàáëèöû Appointment
CREATE TABLE Appointment (
    ID BIGINT PRIMARY KEY,
    [Date] DATE NOT NULL,
    Complaints VARCHAR(300) NOT NULL,
    Diagnosis VARCHAR(300) NOT NULL,
    Treatment VARCHAR(300) NOT NULL,
    [Sick leave] BIT NOT NULL,
    [Illness duration] INT NOT NULL,
    DoctorID BIGINT,
    [Policy of Patient] BIGINT,
    TicketID BIGINT,
    FOREIGN KEY (DoctorID) REFERENCES Doctor(ID),
    FOREIGN KEY ([Policy of Patient]) REFERENCES Patient([Number of Policy]),
    FOREIGN KEY (TicketID) REFERENCES Ticket(ID)
);
-- drop table Patient;

-- Çàïîëíåíèå äàííûìè òàáëèöû Doctor
INSERT INTO Doctor (ID, FIO, Specialization, Category, [Date of Born])
VALUES
(1, 'Èâàíîâ Èâàí Èâàíîâè÷', 'Òåðàïåâò', 'Âûñøàÿ', '1980-05-15'),
(2, 'Ïåòðîâ Ïåòð Ïåòðîâè÷', 'Õèðóðã', 'Ïåðâàÿ', '1975-10-20'),
(3, 'Ñèäîðîâà Àííà Ìèõàéëîâíà', 'Îôòàëüìîëîã', 'Âòîðàÿ', '1985-02-28'),
(4, 'Ñìèðíîâ Ñåðãåé Íèêîëàåâè÷', 'Íåâðîëîã', 'Âûñøàÿ', '1978-08-12'),
(5, 'Àëåêñàíäðîâà Åëåíà Âëàäèìèðîâíà', 'Ñòîìàòîëîã', 'Ïåðâàÿ', '1983-04-05'),
(6, 'Êîçëîâ Àíäðåé Âàñèëüåâè÷', 'Êàðäèîëîã', 'Âòîðàÿ', '1970-11-30'),
(7, 'Íîâèêîâà Ìàðèÿ Àëåêñàíäðîâíà', 'Ãèíåêîëîã', 'Âûñøàÿ', '1982-07-18'),
(8, 'Ôåäîðîâ Ïàâåë Äìèòðèåâè÷', 'Îòîëàðèíãîëîã', 'Ïåðâàÿ', '1973-09-25'),
(9, 'Áåëîâà Àëëà Èãîðåâíà', 'Îíêîëîã', 'Âòîðàÿ', '1988-03-08'),
(10, 'Ëåáåäåâ Äìèòðèé Îëåãîâè÷', 'Ïåäèàòð', 'Âûñøàÿ', '1976-06-22');

-- Çàïîëíåíèå äàííûìè òàáëèöû Station
INSERT INTO Station (ID, Doctor)
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

-- Çàïîëíåíèå äàííûìè òàáëèöû Schedule
INSERT INTO Schedule (ID, [Cabinet Number], [Start Reception Time], [End Reception Time], Doctor, [Event Day])
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

-- Çàïîëíåíèå äàííûìè òàáëèöû Address
INSERT INTO Address (ID, District, Street, House, Station)
VALUES
(1, 'Öåíòðàëüíûé', 'Ëåíèíà', 10, 1),
(2, 'Çàïàäíûé', 'Ñîâåòñêàÿ', 25, 2),
(3, 'Ñåâåðíûé', 'Ïóøêèíà', 15, 3),
(4, 'Þæíûé', 'Ãàãàðèíà', 5, 4),
(5, 'Âîñòî÷íûé', 'Ìèðà', 12, 5),
(6, 'Ñåâåðíûé', 'Ëåñíàÿ', 8, 6),
(7, 'Öåíòðàëüíûé', 'Ïàðêîâàÿ', 17, 7),
(8, 'Çàïàäíûé', 'Íîâàÿ', 30, 8),
(9, 'Þæíûé', 'Ñàäîâàÿ', 3, 9),
(10, 'Âîñòî÷íûé', 'Ïîëÿðíàÿ', 21, 10);

-- Çàïîëíåíèå äàííûìè òàáëèöû Patient
INSERT INTO Patient ([Number of Policy], FIO, Age, Gender, Address)
VALUES
(123456789, 'Ñìèðíîâà Åêàòåðèíà Èãîðåâíà', 30, 'F', 1),
(987654321, 'Êîçëîâ Ïàâåë Àëåêñàíäðîâè÷', 45, 'M', 2),
(567890123, 'Èâàíîâà Îëüãà Ñåðãååâíà', 28, 'F', 3),
(345678912, 'Ïåòðîâ Âèêòîð Íèêîëàåâè÷', 35, 'M', 4),
(789012345, 'Àëåêñàíäðîâà Ñâåòëàíà Èâàíîâíà', 50, 'F', 5),
(901234567, 'Êîçëîâà Ìàðèíà Âèêòîðîâíà', 40, 'F', 6),
(234567890, 'Ëåáåäåâ Ñåðãåé Àíàòîëüåâè÷', 55, 'M', 7),
(456789012, 'Íîâèêîâ Àíäðåé Ïàâëîâè÷', 32, 'M', 8),
(678901234, 'Ôåäîðîâà Îëüãà Äìèòðèåâíà', 42, 'F', 9),
(890123456, 'Áåëîâ Âëàäèìèð Àíäðååâè÷', 38, 'M', 10);

-- Çàïîëíåíèå äàííûìè òàáëèöû Ticket
INSERT INTO Ticket (ID, ScheduleID, Taken, Time, PatientID, [Date])
VALUES
(1, 1, 1, '09:00:00', 123456789, '2024-01-01'),
(2, 1, 0, '09:20:00', null, '2024-01-01'),
(3, 2, 1, '10:30:00', 987654321, '2024-01-02'),
(4, 2, 0, '10:50:00', null, '2024-01-02'),
(5, 3, 1, '13:00:00', 567890123, '2024-01-03'),
(6, 3, 0, '13:20:00', null, '2024-01-03'),
(7, 4, 1, '15:00:00', 567890123, '2024-01-04'),
(8, 4, 0, '15:20:00', null, '2024-01-04'),
(9, 5, 1, '11:00:00', 345678912, '2024-01-05'),
(10, 5, 0, '11:20:00', null, '2024-01-05'),
(11, 6, 1, '14:00:00', 789012345, '2024-01-06'),
(12, 6, 0, '14:20:00', null, '2024-01-06'),
(13, 7, 1, '12:00:00', 123456789, '2024-01-07'),
(14, 7, 0, '12:20:00', null, '2024-01-07'),
(15, 8, 1, '16:00:00', 567890123, '2024-01-08'),
(16, 8, 0, '16:20:00', null, '2024-01-08'),
(17, 9, 1, '17:00:00', 987654321, '2024-01-09'),
(18, 9, 0, '17:20:00', null, '2024-01-09'),
(19, 10, 1, '08:00:00', 567890123, '2024-01-10'),
(20, 10, 0, '08:20:00', null, '2024-01-10'),
(21, 1, 0, '09:00:00', null, '2024-01-22'),
(22, 2, 0, '10:30:00', null, '2024-01-23');

-- Çàïîëíåíèå äàííûìè òàáëèöû Appointment
INSERT INTO Appointment (ID, [Date], Complaints, Diagnosis, Treatment, [Sick leave], [Illness duration], DoctorID, [Policy of Patient], TicketID)
VALUES
(1, '2024-01-01', 'Ãîëîâíàÿ áîëü', 'Ìèãðåíü', 'Ïðèíÿòü àíàëüãèí', 1, 3, 1, 123456789, 1),
(2, '2024-01-02', 'Áîëü â æèâîòå', 'Ãàñòðèò', 'Ïðîïèñàòü àíòèáèîòèêè', 1, 5,  2, 987654321, 2),
(3, '2024-01-03', 'Ðâîòà è òåìïåðàòóðà', 'Ïèùåâîå îòðàâëåíèå', 'Ïðèíèìàòü óãîëü è îáèëüíîå ïèòüå', 1, 3,  3, 567890123, 3),
(4, '2024-01-04', 'Òåìïåðàòóðà, êàøåëü', 'ÎÐÂÈ', 'Îòäûõ è ïðèíÿòü àíòèïèðåòèê', 1, 7, 3, 567890123, 4),
(5, '2024-01-05', 'Áîëè â ñïèíå', 'Îñòåîõîíäðîç', 'Ôèçèîòåðàïèÿ è ìàññàæ', 0, 10,  4, 345678912, 5),
(6, '2024-01-06', 'Áåññîííèöà', 'Íåâðîç', 'Íàçíà÷èòü óñïîêîèòåëüíîå', 0, 5,  5, 789012345, 6),
(7, '2024-01-07', 'Ïîêðàñíåíèå ãëàç', 'Êîíúþíêòèâèò', 'Êàïëè îò âîñïàëåíèÿ', 1, 3,  1, 123456789, 7),
(8, '2024-01-08', 'Ïîòåðÿ àïïåòèòà', 'Äèñáàêòåðèîç', 'Ïðîáèîòèêè è äèåòà', 1, 7,  3, 567890123, 8),
(9, '2024-01-09', 'Çóáíàÿ áîëü', 'Êàðèåñ', 'Ïëîìáèðîâàíèå è àíåñòåçèÿ', 1, 2,  2, 987654321, 9),
(10, '2024-01-10', 'Òàõèêàðäèÿ', 'Ñòðåññ', 'Ðåêîìåíäàöèè ïî óìåíüøåíèþ ñòðåññà', 0, 3,  3, 567890123, 10);
