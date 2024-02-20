

CREATE TABLE Doctor_G(
    ID BIGINT PRIMARY KEY,
    FIO VARCHAR(300) NOT NULL,
    Specialization VARCHAR(300) NOT NULL,
    Category VARCHAR(300) NOT NULL,
    [Date of Born] DATE NOT NULL
) AS NODE


CREATE TABLE Schedule_G (
    ID BIGINT PRIMARY KEY,
    [Cabinet Number] BIGINT NOT NULL,
    [Start Reception Time] TIME NOT NULL,
    [End Reception Time] TIME NOT NULL,
    [Event Day] VARCHAR(300),
    CHECK ([Event Day] IN ('SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY'))
) AS NODE


CREATE TABLE Ticket_G (
    ID BIGINT PRIMARY KEY,
    Taken BIT,
    [Time] TIME NOT NULL,
    [Date] DATE
) AS NODE


CREATE TABLE Station_G (
    ID BIGINT PRIMARY KEY
) AS NODE


CREATE TABLE Address_G (
    ID BIGINT PRIMARY KEY,
    District VARCHAR(300) NOT NULL,
    Street VARCHAR(300) NOT NULL,
    House INT NOT NULL
) AS NODE


CREATE TABLE Patient_G (
    [Number of Policy] BIGINT PRIMARY KEY,
    FIO VARCHAR(300) NOT NULL,
    Age INT NOT NULL,
    Gender VARCHAR(2) NOT NULL
) AS NODE


CREATE TABLE Appointment_G (
    ID BIGINT PRIMARY KEY,
    [Date] DATE NOT NULL,
    Complaints VARCHAR(300) NOT NULL,
    Diagnosis VARCHAR(300) NOT NULL,
    Treatment VARCHAR(300) NOT NULL,
    [Sick leave] BIT NOT NULL,
    [Illness duration] INT NOT NULL
) AS NODE

-- EDGE 

CREATE TABLE [Ïðèíàäëåæèò] AS EDGE
CREATE TABLE [Ñîñòàâèë] AS EDGE
-- CREATE TABLE [Ðàáîòàåò] AS EDGE
-- DROP TABLE [Ðàáîòàåò];
CREATE TABLE [Ðàñïðåäåëåíèå] AS EDGE
CREATE TABLE [Ïðîâ¸ë] AS EDGE
CREATE TABLE [Ïðèø¸ë] AS EDGE
CREATE TABLE [Ïðîæèâàåò] AS EDGE
CREATE TABLE [Íàõîäèòñÿ] AS EDGE

-- insert

--INSERT 
--INTO NODES 
INSERT INTO Doctor_G(ID, FIO, Specialization, Category, [Date of Born]) 
SELECT ID, FIO, Specialization, Category, [Date of Born] FROM Doctor
SELECT * FROM Doctor_G 
 
INSERT INTO Schedule_G (ID,[Cabinet Number], [Start Reception Time], [End Reception Time], [Event Day])  
SELECT ID,[Cabinet Number], [Start Reception Time], [End Reception Time], [Event Day] FROM Schedule 
SELECT * FROM Schedule_G 
 
INSERT INTO Ticket_G(ID, Taken, Time, [Date]) 
SELECT ID, Taken, [Time], [Date] FROM Ticket
SELECT * FROM Ticket_G 
 
INSERT INTO  Station_G(ID) 
SELECT ID FROM Station 
SELECT * FROM Station_G 
 
INSERT INTO Address_G (ID, District, Street , House) 
SELECT ID, District, Street , House FROM [Address]
SELECT * FROM Address_G 

INSERT INTO Patient_G ([Number of Policy], FIO, Age, Gender)
SELECT [Number of Policy], FIO, Age, Gender FROM Patient
SELECT * FROM Patient_G 

INSERT INTO Appointment_G (ID, [Date], Complaints, Diagnosis, Treatment, [Sick leave], [Illness duration])
SELECT ID, [Date], Complaints, Diagnosis, Treatment, [Sick leave], [Illness duration] FROM Appointment
SELECT * FROM Appointment_G 
 


--INSERT  
--INTO EDGES 

INSERT INTO [Ïðèíàäëåæèò] ( $from_id, $to_id )
SELECT sg.$node_id, tg.$node_id
FROM Ticket AS t
JOIN Schedule AS s ON t.ScheduleID = s.ID
JOIN Schedule_G AS sg ON sg.ID = s.ID
JOIN Ticket_G AS tg ON tg.ID = t.ID;
SELECT $from_id, $to_id FROM [Ïðèíàäëåæèò] 

INSERT INTO [Ñîñòàâèë] ( $from_id, $to_id )
SELECT dg.$node_id, sg.$node_id
FROM Doctor AS d
JOIN Schedule AS s ON d.ID = s.Doctor
JOIN Schedule_G AS sg ON sg.ID = s.ID
JOIN Doctor_G AS dg ON dg.ID = d.ID;
SELECT $from_id, $to_id FROM [Ñîñòàâèë] 


INSERT INTO [Ïðèø¸ë] ( $from_id, $to_id )
SELECT pg.$node_id, ag.$node_id
FROM Patient AS p
JOIN Appointment AS a ON p.[Number of Policy] = a.[Policy of Patient]
JOIN Appointment_G AS ag ON ag.ID = a.ID
JOIN Patient_G AS pg ON pg.[Number of Policy] = p.[Number of Policy];

INSERT INTO [Ðàñïðåäåëåíèå] ( $from_id, $to_id )
SELECT dg.$node_id, sg.$node_id
FROM Doctor AS d
JOIN Station AS s ON d.ID = s.Doctor
JOIN Station_G AS sg ON sg.ID = s.ID
JOIN Doctor_G AS dg ON dg.ID = d.ID;



INSERT INTO [Ïðîâ¸ë] ( $from_id, $to_id )
SELECT dg.$node_id, ag.$node_id
FROM Doctor AS d
JOIN Appointment AS a ON d.ID = a.DoctorID
JOIN Doctor_G AS dg ON dg.ID = d.ID
JOIN Appointment_G AS ag ON ag.ID = a.ID;




INSERT INTO [Ïðîæèâàåò] ( $from_id, $to_id )
SELECT pg.$node_id, ag.$node_id
FROM Patient AS p
JOIN [Address] AS a ON p.[Address] = a.ID
JOIN Patient_G AS pg ON pg.[Number of Policy] = p.[Number of Policy]
JOIN Address_G AS ag ON ag.ID = a.ID;



INSERT INTO [Íàõîäèòñÿ] ( $from_id, $to_id )
SELECT ag.$node_id, sg.$node_id
FROM [Address] AS a
JOIN Station AS s ON a.[Station] = s.ID
JOIN Address_G AS ag ON ag.ID = a.ID
JOIN Station_G AS sg ON sg.ID = s.ID;

SELECT $from_id, $to_id FROM [Ñîäåðæèò] 



















