CREATE DATABASE BOOKME;
GO

CREATE TABLE Patients (
    PatientID INT NOT NULL PRIMARY KEY,
    FullName VARCHAR(80) NOT NULL
);
GO

CREATE TABLE Doctors (
    DoctorID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    FullName VARCHAR(80) NOT NULL
);
GO

CREATE TABLE PatientDetails(
	PatientDetailsID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Email VARCHAR(80) NOT NULL,
	PhoneNumber INT NOT NULL,
	PatientID INT NOT NULL,
	PatientPassword VARCHAR(150) NOT NULL
);
GO

CREATE TABLE DoctorDetails(
	DoctorDetailsID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	DoctorID INT NOT NULL,
	Email VARCHAR(80) NOT NULL,
	PhoneNumber INT NOT NULL,
	DoctorPassword VARCHAR(150) NOT NULL
);
GO

CREATE TABLE Appointments(
	AppointentID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	AppointmentDateTime DATETIME NOT NULL,
	PatientID INT NOT NULL,
	AppointmentDescription VARCHAR(200) NULL
);
GO

CREATE TABLE PatientAppointments(
	AppointmentID INT NOT NULL,
	PatientID INT NOT NULL,
	DoctorID INT NOT NULL
);
GO

CREATE TABLE MedicalAidNumber(
	MedicalAidID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	PatientID INT NOT NULL,
	MemberNumber INT NOT NULL
);
GO

CREATE TABLE AlternativePayment(
	PaymentID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	PatientID INT NOT NULL,
	CardNumber VARCHAR(150) NOT NULL,
	ExpiryDate VARCHAR(150) NOT NULL,
	CVV VARCHAR(150) NOT NULL
);
GO

--ADD FOREIGN KEYS
ALTER TABLE AlternativePayment ADD CONSTRAINT AlternativePayment_PatientID_FK FOREIGN KEY (PatientID) REFERENCES Patients(PatientID);
ALTER TABLE MedicalAidNumber ADD CONSTRAINT MedicalAidNumber_PatientID_FK FOREIGN KEY (PatientID) REFERENCES Patients(PatientID);
ALTER TABLE PatientAppointments ADD CONSTRAINT PatientAppointments_PatientID_FK FOREIGN KEY (PatientID) REFERENCES Patients(PatientID);
ALTER TABLE PatientAppointments ADD CONSTRAINT PatientAppointments_DoctorID_FK FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID);
ALTER TABLE PatientAppointments ADD CONSTRAINT PatientAppointments_AppointmentID_FK FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID);
ALTER TABLE Appointments ADD CONSTRAINT Appointments_PatientID_FK FOREIGN KEY (PatientID) REFERENCES Patients(PatientID);
ALTER TABLE DoctorDetails ADD CONSTRAINT DoctorDetails_DoctorID_FK FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID);
ALTER TABLE PatientDetails ADD CONSTRAINT PatientDetails_DoctorID_FK FOREIGN KEY (PatientID) REFERENCES Patients(PatientID);

