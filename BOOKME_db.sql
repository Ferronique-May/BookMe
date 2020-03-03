--CREATE DATABASE
CREATE DATABASE BookMe;
GO

--CREATE TABLES
CREATE TABLE Patients (
    PatientID VARCHAR(13) NOT NULL PRIMARY KEY,
    FullName VARCHAR(80) NOT NULL,
	AdditionalInfoID INT NOT NULL
);
GO


CREATE TABLE Doctors (
    DoctorID VARCHAR(13) NOT NULL PRIMARY KEY,
    FullName VARCHAR(80) NOT NULL,
	AdditionalInfoID INT NOT NULL
);
GO


CREATE TABLE AdditionalInfo(
	AdditionalInfoID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Email VARCHAR(80) NOT NULL,
	PhoneNumber VARCHAR(10) NOT NULL,
	PasswordHash VARCHAR(150) NOT NULL 
);
GO

CREATE TABLE Appointments(
	AppointmentID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	AppointmentDateTime DATETIME NOT NULL,
	DoctorID VARCHAR(13) NOT NULL,
	AppointmentDescription VARCHAR(200) NULL
);
GO

CREATE TABLE PatientAppointments(
	AppointmentID INT NOT NULL,
	PatientID VARCHAR(13) NOT NULL
);
GO

--MAKING A PRIMARY KEY FOR PATIENTAPPOINTMENTS
ALTER TABLE PatientAppointments ADD CONSTRAINT PK_PatientAppointments_AppointmentID_PatientID PRIMARY KEY (AppointmentID, PatientID);
GO

CREATE TABLE MedicalAidNumber(
	MedicalAidID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	PatientID VARCHAR(13) NOT NULL,
	MemberNumber INT NOT NULL
);
GO

CREATE TABLE AlternativePayment(
	PaymentID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	PatientID VARCHAR(13) NOT NULL,
	CardNumber VARCHAR(150) NOT NULL,
	ExpiryDate VARCHAR(150) NOT NULL,
	CVV VARCHAR(150) NOT NULL
);
GO



--ADD FOREIGN KEYS
ALTER TABLE Patients ADD CONSTRAINT FK_Patients_AdditionalInfoID FOREIGN KEY (AdditionalInfoID) REFERENCES AdditionalInfo(AdditionalInfoID);
ALTER TABLE Doctors ADD CONSTRAINT FK_Doctors_AdditionalInfoID FOREIGN KEY (AdditionalInfoID) REFERENCES AdditionalInfo(AdditionalInfoID);
ALTER TABLE Appointments ADD CONSTRAINT FK_Appointments_DoctorID FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID);
ALTER TABLE PatientAppointments ADD CONSTRAINT FK_PatientAppointments_AppointmentID  FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID);
ALTER TABLE PatientAppointments ADD CONSTRAINT FK_PatientAppointments_PatientID  FOREIGN KEY (PatientID) REFERENCES Patients(PatientID);
ALTER TABLE MedicalAidNumber ADD CONSTRAINT FK_MedicalAidNumber_PatientID  FOREIGN KEY (PatientID) REFERENCES Patients(PatientID);
ALTER TABLE AlternativePayment ADD CONSTRAINT FK_AlternativePayment_PatientID  FOREIGN KEY (PatientID) REFERENCES Patients(PatientID);
GO

--UNIQUE CONSTRAINTS
ALTER TABLE AdditionalInfo ADD CONSTRAINT UNIQUE_AdditionalInfo_Email UNIQUE(Email);
ALTER TABLE Patients ADD CONSTRAINT UNIQUE_Patients_PatientID UNIQUE (PatientID);
ALTER TABLE Doctors ADD CONSTRAINT UNIQUE_Doctors_DoctorID UNIQUE (DoctorID);
GO

--CHECK CONSTRAINTS
ALTER TABLE AdditionalInfo ADD CONSTRAINT CK_AdditionalInfo_PhoneNumber CHECK (LEN(PhoneNumber) = 10);
ALTER TABLE Patients ADD CONSTRAINT CK_Patients_PatientID CHECK (LEN(PatientID) = 13);
GO

--STORED PROCEDURES TO CREATE USERS
CREATE PROCEDURE InsertAdditionalInfo(@email VARCHAR(80), @phonenumber VARCHAR(10), @password VARCHAR(50))
	AS
	BEGIN TRY
		INSERT INTO AdditionalInfo (Email,PhoneNumber,PasswordHash) VALUES (@email, @phonenumber, @password)
	END TRY
	BEGIN CATCH
		SELECT
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_SEVERITY() AS ErrorSeverity,
			ERROR_STATE() AS ErrorState,
			ERROR_PROCEDURE() AS ErrorProcedure,
			ERROR_LINE() AS ErrorLine,
			ERROR_MESSAGE() AS ErrorMessage;
	END CATCH;
GO

CREATE PROCEDURE InsertPatient(@patientID VARCHAR(13), @fullname VARCHAR(80), @additionalInfoID INT)
	AS
	BEGIN TRY
		INSERT INTO Patients(PatientID, FullName, AdditionalInfoID) VALUES (@patientID, @fullname, @additionalInfoID);
	END TRY
	BEGIN CATCH
		SELECT
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_SEVERITY() AS ErrorSeverity,
			ERROR_STATE() AS ErrorState,
			ERROR_PROCEDURE() AS ErrorProcedure,
			ERROR_LINE() AS ErrorLine,
			ERROR_MESSAGE() AS ErrorMessage;
	END CATCH;
GO

CREATE PROCEDURE InsertDoctor(@doctorID VARCHAR(13), @fullname VARCHAR(80), @additionalInfoID INT)
	AS
	BEGIN TRY
		INSERT INTO Doctors(DoctorID, FullName, AdditionalInfoID) VALUES (@doctorID, @fullname, @additionalInfoID);
	END TRY
	BEGIN CATCH
		SELECT
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_SEVERITY() AS ErrorSeverity,
			ERROR_STATE() AS ErrorState,
			ERROR_PROCEDURE() AS ErrorProcedure,
			ERROR_LINE() AS ErrorLine,
			ERROR_MESSAGE() AS ErrorMessage;
	END CATCH;
GO

--STORED PROCEDURE TO ADD APPOINTMENTS

CREATE PROCEDURE CreateAppointment(@appointmentDateTime DATETIME, @doctorID VARCHAR(13),@appointmentDescription VARCHAR(200))
	AS
	BEGIN TRY
		INSERT INTO Appointments(AppointmentDateTime, DoctorID, AppointmentDescription) VALUES (@appointmentDateTime, @doctorID, @appointmentDescription);
	END TRY
	BEGIN CATCH
		SELECT
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_SEVERITY() AS ErrorSeverity,
			ERROR_STATE() AS ErrorState,
			ERROR_PROCEDURE() AS ErrorProcedure,
			ERROR_LINE() AS ErrorLine,
			ERROR_MESSAGE() AS ErrorMessage;
	END CATCH;
GO

