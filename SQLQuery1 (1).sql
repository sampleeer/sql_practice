-- �������� ���� ������
CREATE DATABASE RegistryBase;
USE RegistryBase;

-- �������� ������� Doctor
CREATE TABLE Doctor (
    ID BIGINT PRIMARY KEY,
    FIO VARCHAR(300) NOT NULL,
    Specialization VARCHAR(300) NOT NULL,
    Category VARCHAR(300) NOT NULL,
    [Date of Born] DATE NOT NULL
); 

-- �������� ������� Schedule
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

-- �������� ������� Ticket
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

-- �������� ������� Station
CREATE TABLE Station (
    ID BIGINT PRIMARY KEY,
    Doctor BIGINT,
    FOREIGN KEY (Doctor) REFERENCES Doctor(ID)
);

-- �������� ������� Address
CREATE TABLE Address (
    ID BIGINT PRIMARY KEY,
    District VARCHAR(300) NOT NULL,
    Street VARCHAR(300) NOT NULL,
    House INT NOT NULL,
    Station BIGINT,
    FOREIGN KEY (Station) REFERENCES Station(ID)
);

-- �������� ������� Patient
CREATE TABLE Patient (
    [Number of Policy] BIGINT PRIMARY KEY,
    FIO VARCHAR(300) NOT NULL,
    Age INT NOT NULL,
    Gender VARCHAR(2) NOT NULL,
    [Address] BIGINT,
    FOREIGN KEY (Address) REFERENCES Address(ID)
); 

-- �������� ������� Appointment
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

-- ���������� ������� ������� Doctor
INSERT INTO Doctor (ID, FIO, Specialization, Category, [Date of Born])
VALUES
(1, '������ ���� ��������', '��������', '������', '1980-05-15'),
(2, '������ ���� ��������', '������', '������', '1975-10-20'),
(3, '�������� ���� ����������', '�����������', '������', '1985-02-28'),
(4, '������� ������ ����������', '��������', '������', '1978-08-12'),
(5, '������������ ����� ������������', '����������', '������', '1983-04-05'),
(6, '������ ������ ����������', '���������', '������', '1970-11-30'),
(7, '�������� ����� �������������', '���������', '������', '1982-07-18'),
(8, '������� ����� ����������', '�������������', '������', '1973-09-25'),
(9, '������ ���� ��������', '�������', '������', '1988-03-08'),
(10, '������� ������� ��������', '�������', '������', '1976-06-22');

-- ���������� ������� ������� Station
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

-- ���������� ������� ������� Schedule
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

-- ���������� ������� ������� Address
INSERT INTO Address (ID, District, Street, House, Station)
VALUES
(1, '�����������', '������', 10, 1),
(2, '��������', '���������', 25, 2),
(3, '��������', '�������', 15, 3),
(4, '�����', '��������', 5, 4),
(5, '���������', '����', 12, 5),
(6, '��������', '������', 8, 6),
(7, '�����������', '��������', 17, 7),
(8, '��������', '�����', 30, 8),
(9, '�����', '�������', 3, 9),
(10, '���������', '��������', 21, 10);

-- ���������� ������� ������� Patient
INSERT INTO Patient ([Number of Policy], FIO, Age, Gender, Address)
VALUES
(123456789, '�������� ��������� ��������', 30, 'F', 1),
(987654321, '������ ����� �������������', 45, 'M', 2),
(567890123, '������� ����� ���������', 28, 'F', 3),
(345678912, '������ ������ ����������', 35, 'M', 4),
(789012345, '������������ �������� ��������', 50, 'F', 5),
(901234567, '������� ������ ����������', 40, 'F', 6),
(234567890, '������� ������ �����������', 55, 'M', 7),
(456789012, '������� ������ ��������', 32, 'M', 8),
(678901234, '�������� ����� ����������', 42, 'F', 9),
(890123456, '����� �������� ���������', 38, 'M', 10);

-- ���������� ������� ������� Ticket
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

-- ���������� ������� ������� Appointment
INSERT INTO Appointment (ID, [Date], Complaints, Diagnosis, Treatment, [Sick leave], [Illness duration], DoctorID, [Policy of Patient], TicketID)
VALUES
(1, '2024-01-01', '�������� ����', '�������', '������� ��������', 1, 3, 1, 123456789, 1),
(2, '2024-01-02', '���� � ������', '�������', '��������� �����������', 1, 5,  2, 987654321, 2),
(3, '2024-01-03', '����� � �����������', '������� ����������', '��������� ����� � �������� �����', 1, 3,  3, 567890123, 3),
(4, '2024-01-04', '�����������, ������', '����', '����� � ������� �����������', 1, 7, 3, 567890123, 4),
(5, '2024-01-05', '���� � �����', '������������', '������������ � ������', 0, 10,  4, 345678912, 5),
(6, '2024-01-06', '����������', '������', '��������� ��������������', 0, 5,  5, 789012345, 6),
(7, '2024-01-07', '����������� ����', '������������', '����� �� ����������', 1, 3,  1, 123456789, 7),
(8, '2024-01-08', '������ ��������', '������������', '���������� � �����', 1, 7,  3, 567890123, 8),
(9, '2024-01-09', '������ ����', '������', '������������� � ���������', 1, 2,  2, 987654321, 9),
(10, '2024-01-10', '����������', '������', '������������ �� ���������� �������', 0, 3,  3, 567890123, 10);