--CREATE DATABASE
CREATE DATABASE BookMeDB;
GO

--CREATE TABLES
CREATE TABLE Patients (
    PatientID VARCHAR(13) NOT NULL PRIMARY KEY,
    FullName VARCHAR(80) NOT NULL,
	Email VARCHAR(80) NOT NULL,
	PhoneNumber VARCHAR(10) NOT NULL,
	PasswordHash VARCHAR(150) NOT NULL 
);
GO


CREATE TABLE Doctors (
    DoctorID VARCHAR(13) NOT NULL PRIMARY KEY,
    FullName VARCHAR(80) NOT NULL,
	Email VARCHAR(80) NOT NULL,
	PhoneNumber VARCHAR(10) NOT NULL,
	PasswordHash VARCHAR(150) NOT NULL 
);
GO

CREATE TABLE Appointments(
	AppointmentID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	AppointmentDateTime DATETIME NOT NULL,
	AppointmentDescription VARCHAR(200) NULL,
	DoctorsCommentsAfterAppointment VARCHAR(200) NULL
);
GO

CREATE TABLE PatientAppointments(
	AppointmentID INT NOT NULL,
	PatientID VARCHAR(13) NOT NULL,
	DoctorID VARCHAR(13) NOT NULL,
);
GO

--MAKING A PRIMARY KEY FOR PATIENTAPPOINTMENTS
ALTER TABLE PatientAppointments ADD CONSTRAINT PK_PatientAppointments_AppointmentID_PatientID_DoctorID PRIMARY KEY (AppointmentID, PatientID, DoctorID);
GO

CREATE TABLE MedicalAidPayment(
	MedicalAidID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	PatientID VARCHAR(13) NOT NULL,
	MemberNumber INT NOT NULL
);
GO

CREATE TABLE AlternativePayments(
	PaymentID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	PatientID VARCHAR(13) NOT NULL,
	CardNumber VARCHAR(150) NOT NULL,
	ExpiryDate VARCHAR(150) NOT NULL,
	CVV VARCHAR(150) NOT NULL
);
GO


--ADD FOREIGN KEYS
ALTER TABLE PatientAppointments ADD CONSTRAINT FK_PatientAppointments_DoctorID FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID);
ALTER TABLE PatientAppointments ADD CONSTRAINT FK_PatientAppointments_AppointmentID  FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID);
ALTER TABLE PatientAppointments ADD CONSTRAINT FK_PatientAppointments_PatientID  FOREIGN KEY (PatientID) REFERENCES Patients(PatientID);
ALTER TABLE MedicalAidPayment ADD CONSTRAINT FK_MedicalAidPayment_PatientID  FOREIGN KEY (PatientID) REFERENCES Patients(PatientID);
ALTER TABLE AlternativePayments ADD CONSTRAINT FK_AlternativePayment_PatientID  FOREIGN KEY (PatientID) REFERENCES Patients(PatientID);
GO

--UNIQUE CONSTRAINTS
ALTER TABLE Patients ADD CONSTRAINT UNIQUE_Patients_Email UNIQUE(Email);
ALTER TABLE Patients ADD CONSTRAINT UNIQUE_Patients_PatientID UNIQUE (PatientID);
ALTER TABLE Doctors ADD CONSTRAINT UNIQUE_Doctors_Email UNIQUE(Email);
ALTER TABLE Doctors ADD CONSTRAINT UNIQUE_Doctors_DoctorID UNIQUE (DoctorID);
GO

--CHECK CONSTRAINTS
ALTER TABLE Patients ADD CONSTRAINT CK_Patients_PhoneNumber CHECK (LEN(PhoneNumber) = 10);
ALTER TABLE Patients ADD CONSTRAINT CK_Patients_PatientID CHECK (LEN(PatientID) = 13);
ALTER TABLE Doctors ADD CONSTRAINT CK_Doctors_PhoneNumber CHECK (LEN(PhoneNumber) = 10);
ALTER TABLE Doctors ADD CONSTRAINT CK_Doctors_DoctorID CHECK (LEN(DoctorID) = 13);
GO

--STORED PROCEDURES TO CREATE/UPDATE/DELETE USERS
CREATE PROCEDURE SP_InsertUpdateDeletePatient
( 
	@StatementType VARCHAR(20), 
	@PatientID VARCHAR(13)='',  
	@fullname VARCHAR(80)='', 
	@email VARCHAR(80)='', 
	@phonenumber VARCHAR(10)='', 
	@password VARCHAR(50)=''
)
	AS
	BEGIN
		IF @StatementType ='INSERT'
			BEGIN TRY
				INSERT INTO Patients (PatientID, FullName, Email, PhoneNumber, PasswordHash) VALUES (@PatientID, @fullname, @email, @phonenumber, @password)
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

      IF @StatementType = 'UPDATE'  
        BEGIN TRY 

            UPDATE Patients  
            SET    FullName = @fullname,
				   Email = @email,  
                   PhoneNumber = @phonenumber,  
                   PasswordHash = @password 
            WHERE PatientID = @PatientID  

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

      ELSE IF @StatementType = 'DELETE'  
        BEGIN TRY 
			
			DELETE FROM PatientAppointments  
            WHERE  PatientID = @PatientID 

			DELETE FROM MedicalAidPayment  
            WHERE  PatientID = @PatientID
			
			DELETE FROM AlternativePayments  
            WHERE  PatientID = @PatientID 
			
            DELETE FROM Patients  
            WHERE  PatientID = @PatientID  

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
  END
GO



CREATE PROCEDURE SP_InsertUpdateDeleteDoctor
( 
	@StatementType VARCHAR(20), 
	@DoctorID VARCHAR(13)='',  
	@fullname VARCHAR(80)='', 
	@email VARCHAR(80)='', 
	@phonenumber VARCHAR(10)='', 
	@password VARCHAR(50)=''
)
	AS
	BEGIN
		IF @StatementType ='INSERT'
			BEGIN TRY
				INSERT INTO Doctors (DoctorID,FullName, Email, PhoneNumber, PasswordHash) VALUES (@DoctorID, @fullname, @email, @phonenumber, @password)
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

      IF @StatementType = 'UPDATE'  
        BEGIN TRY 

            UPDATE Doctors  
            SET    FullName = @fullname,
				   Email = @email,  
                   PhoneNumber = @phonenumber,  
                   PasswordHash = @password 
            WHERE DoctorID = @DoctorID  

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

      ELSE IF @StatementType = 'DELETE'  
        BEGIN TRY 
			
			DELETE FROM PatientAppointments  
            WHERE  DoctorID = @DoctorID 
			
            DELETE FROM Doctors  
            WHERE  DoctorID = @DoctorID  

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
  END
GO

--STORED PROCEDURE TO ADD APPOINTMENTS

CREATE PROCEDURE SP_InsertUpdateDeleteAppointment
( 
	@StatementType VARCHAR(20),
	@appointmentID INT ='',
	@appointmentDateTime DATETIME='',  
	@appointmentDescription VARCHAR(200)='',
	@PatientIDforPatientAppointments VARCHAR(13)='',
	@DoctorIDforPatientAppointments VARCHAR(13)=''
)
	AS
	BEGIN
		IF @StatementType ='INSERT'
			BEGIN TRY
				INSERT INTO Appointments (AppointmentDateTime, AppointmentDescription) VALUES (@appointmentDateTime, @appointmentDescription)
				DECLARE @appointmentIDForPatientAppointments INT
				SET @appointmentIDForPatientAppointments = (SELECT AppointmentID FROM Appointments WHERE AppointmentDateTime = @appointmentDateTime)
				EXEC SP_InsertUpdateDeletePatientAppointments  'INSERT',@appointmentIDForPatientAppointments, @PatientIDforPatientAppointments, @DoctorIDforPatientAppointments 
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

      IF @StatementType = 'UPDATE'  
        BEGIN TRY 

            UPDATE Appointments  
            SET    AppointmentDateTime = @appointmentDateTime,
				   AppointmentDescription = @appointmentDescription
            WHERE AppointmentID = @appointmentID  

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

      ELSE IF @StatementType = 'DELETE'  
        BEGIN TRY 
			
			DELETE FROM PatientAppointments  
            WHERE  AppointmentID = @appointmentID 
			
            DELETE FROM Appointments  
            WHERE  AppointmentID = @appointmentID  

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
  END
GO

CREATE PROCEDURE SP_InsertDeletePatientAppointments
( 
	@StatementType VARCHAR(20),
	@appointmentID INT ='',
	@PatientID VARCHAR(13)='',
	@DoctorID VARCHAR(13)=''
)
	AS
	BEGIN
		IF @StatementType ='INSERT'
			BEGIN TRY
				INSERT INTO PatientAppointments (AppointmentID, PatientID,DoctorID) VALUES (@appointmentID, @PatientID, @DoctorID)
				 
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

      ELSE IF @StatementType = 'DELETE'  
        BEGIN TRY 
			
			DELETE FROM PatientAppointments  
            WHERE  AppointmentID = @appointmentID 
			
            DELETE FROM PatientAppointments  
            WHERE  PatientID = @PatientID
			
            DELETE FROM PatientAppointments  
            WHERE  DoctorID = @DoctorID

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
  END
GO

--STORED PROCEDURES TO CREATE/UPDATE/DELETE PAYMENT OPTIONS.
CREATE PROCEDURE SP_InsertUpdateDeleteMedicalAidPaymentDetails
( 
	@StatementType VARCHAR(20),
	@patientID VARCHAR(13) ='',
	@memberNumber INT ='',  
	@medicalAidID INT=''
)
	AS
	BEGIN
		IF @StatementType ='INSERT'
			BEGIN TRY
				INSERT INTO MedicalAidPayment (PatientID, MemberNumber) VALUES (@patientID, @memberNumber)
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

      IF @StatementType = 'UPDATE'  
        BEGIN TRY 

            UPDATE MedicalAidPayment  
            SET    PatientID = @patientID,
				   MemberNumber = @memberNumber
            WHERE MedicalAidID = @medicalAidID  

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

      ELSE IF @StatementType = 'DELETE'  
        BEGIN TRY 
			
			DELETE FROM MedicalAidPayment  
            WHERE  MedicalAidID = @medicalAidID 
	
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
  END
GO

CREATE PROCEDURE SP_InsertUpdateDeleteAlternativePaymentDetails
( 
	@StatementType VARCHAR(20),
	@paymentID INT,
	@patientID VARCHAR(13) ='',
	@cardNumber VARCHAR(150) ='',  
	@expiryDate VARCHAR(150)='',
	@cvv VARCHAR(150)=''
)
	AS
	BEGIN
		IF @StatementType ='INSERT'
			BEGIN TRY
				INSERT INTO AlternativePayments(PatientID, CardNumber, ExpiryDate, CVV ) VALUES (@patientID, @cardNumber, @expiryDate, @cvv)
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

      IF @StatementType = 'UPDATE'  
        BEGIN TRY 

            UPDATE AlternativePayments  
            SET    PatientID = @patientID,
				   CardNumber = @cardNumber,
				   ExpiryDate = @expiryDate,
				   CVV = @cvv
            WHERE PaymentID = @paymentID  

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

      ELSE IF @StatementType = 'DELETE'  
        BEGIN TRY 
			
			DELETE FROM AlternativePayments  
            WHERE  PaymentID = @paymentID
	
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
  END
GO