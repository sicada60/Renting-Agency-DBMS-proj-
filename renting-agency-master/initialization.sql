-- CreateTable
CREATE TABLE Property (
    pid INTEGER NOT NULL,
    rent DOUBLE PRECISION NOT NULL,
    rentHike DOUBLE PRECISION NOT NULL,
    floors INTEGER NOT NULL,
    constructionYear INTEGER NOT NULL,
    address VARCHAR(100) NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    plinth DOUBLE PRECISION NOT NULL,
    locality VARCHAR(50) NOT NULL,
    aadharID VARCHAR(50) NOT NULL,
    PRIMARY KEY (pid)
);

-- CreateTable
CREATE TABLE Commercial (
    pid INTEGER NOT NULL,
    ROI DOUBLE PRECISION NOT NULL,
    PRIMARY KEY (pid)
);

-- CreateTable
CREATE TABLE Residential (
    pid INTEGER NOT NULL,
    bedrooms INTEGER NOT NULL,
    PRIMARY KEY (pid)
);

-- CreateTable
CREATE TABLE Facility (
    pid INTEGER NOT NULL,
    facility VARCHAR(50) NOT NULL,
    PRIMARY KEY (pid,facility)
);

-- CreateTable
CREATE TABLE Users (
    aadharID VARCHAR(50) NOT NULL,
    age INTEGER NOT NULL,
    email VARCHAR(100) NOT NULL,
		password varchar(100) NOT NULL,
    name VARCHAR(50),
    doorNo VARCHAR(50) NOT NULL,
    street VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    pin INTEGER NOT NULL,
    PRIMARY KEY (aadharID)
);

-- CreateTable
CREATE TABLE Admin (
    aadharID VARCHAR(50) NOT NULL,
    PRIMARY KEY (aadharID)
);

-- CreateTable
CREATE TABLE Manager (
    aadharID VARCHAR(50) NOT NULL,
    PRIMARY KEY (aadharID)
);

-- CreateTable
CREATE TABLE Landlord (
    aadharID VARCHAR(50) NOT NULL,
    PRIMARY KEY (aadharID)
);

-- CreateTable
CREATE TABLE Tenant (
    aadharID VARCHAR(50) NOT NULL,
    PRIMARY KEY (aadharID)
);

-- CreateTable
CREATE TABLE Phone (
    aadharID VARCHAR(50) NOT NULL,
    phoneNumber VARCHAR(50) NOT NULL,
    PRIMARY KEY (aadharID,phoneNumber)
);

-- CreateTable
CREATE TABLE Rent (
    pid INTEGER NOT NULL,
    aadharID VARCHAR(50) NOT NULL,
    commission DOUBLE PRECISION NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE,
    PRIMARY KEY (pid,aadharID,startDate)
);

CREATE VIEW RENT_TENANT AS
SELECT t1.name, t2.rent, t2.locality, t3.startDate, t3.endDate
FROM users t1, Property t2, rent t3
where t1.aadharID = t3.aadharID and t2.pid = t3.pid;

-- CreateIndex
CREATE UNIQUE INDEX User_email_key ON Users(email);

-- AddForeignKey
ALTER TABLE Commercial ADD CONSTRAINT Commercial_pid_fkey FOREIGN KEY (pid) REFERENCES Property(pid) ;

-- AddForeignKey
ALTER TABLE Residential ADD CONSTRAINT Residential_pid_fkey FOREIGN KEY (pid) REFERENCES Property(pid) ;

-- AddForeignKey
ALTER TABLE Facility ADD CONSTRAINT Facility_pid_fkey FOREIGN KEY (pid) REFERENCES Property(pid) ;

-- AddForeignKey
ALTER TABLE Admin ADD CONSTRAINT Admin_aadharID_fkey FOREIGN KEY (aadharID) REFERENCES Users(aadharID) ;

-- AddForeignKey
ALTER TABLE Manager ADD CONSTRAINT Manager_aadharID_fkey FOREIGN KEY (aadharID) REFERENCES Users(aadharID) ;

-- AddForeignKey
ALTER TABLE Landlord ADD CONSTRAINT Landlord_aadharID_fkey FOREIGN KEY (aadharID) REFERENCES Users(aadharID) ;

-- AddForeignKey
ALTER TABLE Tenant ADD CONSTRAINT Tenant_aadharID_fkey FOREIGN KEY (aadharID) REFERENCES Users(aadharID) ;

-- AddForeignKey
ALTER TABLE Phone ADD CONSTRAINT Phone_aadharID_fkey FOREIGN KEY (aadharID) REFERENCES Users(aadharID) ;

-- AddForeignKey
ALTER TABLE Rent ADD CONSTRAINT Rent_pid_fkey FOREIGN KEY (pid) REFERENCES Property(pid) ;

-- AddForeignKey
ALTER TABLE Rent ADD CONSTRAINT Rent_aadharID_fkey FOREIGN KEY (aadharID) REFERENCES Tenant(aadharID) ;

-- AddForeignKey
ALTER TABLE Property ADD CONSTRAINT Property_aadharID_fkey FOREIGN KEY (aadharID) REFERENCES Landlord(aadharID) ;
