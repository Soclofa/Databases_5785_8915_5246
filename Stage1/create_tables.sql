-- Create Insurance table
CREATE TABLE Insurance (
    InsuranceID SERIAL PRIMARY KEY,
    CoveredAmount NUMERIC(10, 2) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL
);

-- Create Procurement table
CREATE TABLE Procurement (
    ProcurementID SERIAL PRIMARY KEY,
    Source VARCHAR(100),
    ProcurementDate DATE NOT NULL,
    Cost NUMERIC(10, 2) NOT NULL
);
-- Create Asset table (now can reference Insurance)
CREATE TABLE Asset (
    AssetID SERIAL PRIMARY KEY,
    Type VARCHAR(50) NOT NULL,
    InsuranceID INT,
    ProcurementID INT,
    FOREIGN KEY (ProcurementID) REFERENCES Procurement(ProcurementID),
    FOREIGN KEY (InsuranceID) REFERENCES Insurance(InsuranceID)
);

-- Create Subscription table
CREATE TABLE Subscription (
    SubscriptionID SERIAL PRIMARY KEY,
    SubscriptionType VARCHAR(50) NOT NULL,
    RenewalDate DATE NOT NULL,
    PurchaseDate DATE NOT NULL
);

-- Create Reader table
CREATE TABLE Reader (
    ReaderID SERIAL PRIMARY KEY,
    SubscriptionID INT NOT NULL,
    FOREIGN KEY (SubscriptionID) REFERENCES Subscription(SubscriptionID)
);

-- Create Penalty table
CREATE TABLE Penalty (
    PenaltyID SERIAL PRIMARY KEY,
    Type VARCHAR(50) NOT NULL,
    Cost NUMERIC(10, 2) NOT NULL
);

-- Create SubscriptionPenalties table (Many-to-Many relationship)
CREATE TABLE SubscriptionPenalties (
    SubscriptionID INT,
    PenaltyID INT,
    BookID INT,
    PRIMARY KEY (SubscriptionID, PenaltyID, BookID),
    FOREIGN KEY (SubscriptionID) REFERENCES Subscription(SubscriptionID),
    FOREIGN KEY (PenaltyID) REFERENCES Penalty(PenaltyID)
);

-- Create Wage table
CREATE TABLE Wage (
    WageID SERIAL PRIMARY KEY,
    Amount NUMERIC(10, 2) NOT NULL,
    PayDay DATE NOT NULL
);

-- Create Employee table
CREATE TABLE Employee (
    EmployeeID SERIAL PRIMARY KEY,
    WageID INT,
    FOREIGN KEY (WageID) REFERENCES Wage(WageID)
);

-- Create Procurement table
CREATE TABLE Procurement (
    ProcurementID SERIAL PRIMARY KEY,
    Source VARCHAR(100),
    ProcurementDate DATE NOT NULL,
    Cost NUMERIC(10, 2) NOT NULL,
    FOREIGN KEY (AssetID) REFERENCES Asset(AssetID)
);

ALTER SEQUENCE procurement_procurementid_seq RESTART 1;
ALTER SEQUENCE penalty_penaltyid_seq RESTART 1;
ALTER SEQUENCE wage_wageid_seq RESTART 1;
ALTER SEQUENCE subscription_subscriptionid_seq RESTART 1;
ALTER SEQUENCE insurance_insuranceid_seq RESTART 1;