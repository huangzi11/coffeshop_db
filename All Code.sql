/*
CREATING DATABASE
*/
-- CREATE DATABASE GROUP13_PROJECT
USE GROUP13_PROJECT
GO


/*
BUILD TABLE SCHEMA
*/

CREATE TABLE tblCUSTOMER (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    CustFname VARCHAR(50),
    CustLname VARCHAR(50),
    CustBirth DATE,
)

CREATE TABLE tblPAYMENT_METHOD (
    PaymentMethodID INT IDENTITY(1,1) PRIMARY KEY,
    PaymentMethodName VARCHAR(50),
    PaymentMethodDescr VARCHAR(300)
)

CREATE TABLE tblORDER_TYPE (
    OrderTypeID INT IDENTITY(1,1) PRIMARY KEY,
    OrderTypeName VARCHAR(100),
    OrderTypeDescr VARCHAR(300)
)

CREATE TABLE tblORDER (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    OrderDate DATE,
    -- OrderTotal NUMERIC(8,2), -- computed column
    OrderDescr VARCHAR(300),
    PaymentMethodID INT,
    CustomerID INT FOREIGN KEY REFERENCES tblCUSTOMER(CustomerID),
    OrderTypeID INT FOREIGN KEY REFERENCES tblORDER_TYPE(OrderTypeID)
)

CREATE TABLE tblEMPLOYEE_TYPE (
    EmployeeTypeID INT IDENTITY(1,1) PRIMARY KEY,
    EmpTypeName VARCHAR(50),
    EmpTypeDescr VARCHAR(300)
)

CREATE TABLE tblEMPLOYEE (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    EmpFname VARCHAR(50),
    EmpLname VARCHAR(50),
    EmpBirth DATE,
    EmployeeTypeID INT FOREIGN KEY REFERENCES tblEMPLOYEE_TYPE(EmployeeTypeID)
)

CREATE TABLE tblPRODUCT_TYPE (
    ProductTypeID INT IDENTITY(1,1) PRIMARY KEY,
    ProductTypeName VARCHAR(50),
    ProductTypeDescr VARCHAR(300)
)

CREATE TABLE tblPRODUCT (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100),
    Price NUMERIC(4,2),
    ProductDescr VARCHAR(300),
    ProductTypeID INT FOREIGN KEY REFERENCES tblPRODUCT_TYPE(ProductTypeID)
)

CREATE TABLE tblORDER_PRODUCT (
    OrderProductID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES tblORDER(OrderID),
    ProductID INT FOREIGN KEY REFERENCES tblPRODUCT(ProductID),
    Quantity INT,
    EmployeeID INT FOREIGN KEY REFERENCES tblEMPLOYEE(EmployeeID),
    -- Subtotal NUMERIC(6,2) -- computed column
)

CREATE TABLE tblRATING (
    RatingID INT IDENTITY(1,1) PRIMARY KEY,
    RatingName VARCHAR(50),
    RatingValue INT
)

CREATE TABLE tblREVIEW (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    OrderProductID INT FOREIGN KEY REFERENCES tblORDER_PRODUCT(OrderProductID),
    ReviewDate DATE,
    ReviewBody VARCHAR(1000),
    RatingID INT FOREIGN KEY REFERENCES tblRATING(RatingID)
)

CREATE TABLE tblMEASUREMENT (
    MeasurementID INT IDENTITY(1,1) PRIMARY KEY,
    MeasurementName VARCHAR(50),
    MeasurementAbbrv VARCHAR(10)
)

CREATE TABLE tblSUPPLIER (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName VARCHAR(100),
    SupplierDescr VARCHAR(300)
)

CREATE TABLE tblINGREDIENT_TYPE (
    IngredientTypeID INT IDENTITY(1,1) PRIMARY KEY,
    IngredientTypeName VARCHAR(50),
    IngredientTypeDescr VARCHAR(300)
)

CREATE TABLE tblINGREDIENT (
    IngredientID INT IDENTITY(1,1) PRIMARY KEY,
    IngredientName VARCHAR(100),
    IngredientTypeID INT FOREIGN KEY REFERENCES tblINGREDIENT_TYPE(IngredientTypeID),
    SupplierID INT FOREIGN KEY REFERENCES tblSUPPLIER(SupplierID)
)

CREATE TABLE tblPREPARATION (
    PreparationID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT FOREIGN KEY REFERENCES tblPRODUCT(ProductID),
    IngredientID INT FOREIGN KEY REFERENCES tblINGREDIENT(IngredientID),
    MeasurementID INT FOREIGN KEY REFERENCES tblMEASUREMENT(MeasurementID),
    Quantity INT
)

GO


/*
NESTED STORED PROCEDURE
*/

-- Jackie
-- Nested stored procedure to get PaymentMethodID
CREATE OR ALTER PROCEDURE GetPaymentMethodID
@PM_name VARCHAR(50),
@PM_ID INT OUTPUT
AS
SET @PM_ID = (SELECT PaymentMethodID
              FROM tblPAYMENT_METHOD
              WHERE PaymentMethodName = @PM_name)
GO

-- Jackie
-- Nested stored procedure to get CustomerID
CREATE OR ALTER PROCEDURE GetCustomerID
@C_Fname VARCHAR(50),
@C_Lname VARCHAR(50),
@C_DOB DATE,
@C_ID INT OUTPUT
AS
SET @C_ID = (SELECT CustomerID
             FROM tblCUSTOMER
             WHERE CustFname = @C_Fname AND CustLname = @C_Lname AND CustBirth = @C_DOB)
GO

-- Jackie
-- Nested stored procedure to get OrderTypeID
CREATE OR ALTER PROCEDURE GetOrderTypeID
@OT_name VARCHAR(50),
@OT_ID INT OUTPUT
AS
SET @OT_ID = (SELECT OrderTypeID
              FROM tblORDER_TYPE
              WHERE OrderTypeName = @OT_name)
GO

-- Jackie
-- Nested stored procedure to get EmployeeTypeID
CREATE OR ALTER PROCEDURE GetEmployeeTypeID
@ET_name VARCHAR(50),
@ET_ID INT OUTPUT
AS
SET @ET_ID = (SELECT EmployeeTypeID
              FROM tblEMPLOYEE_TYPE
              WHERE EmpTypeName = @ET_name)
GO

-- Jackie
-- Nested stored procedure to get ProductTypeID
CREATE OR ALTER PROCEDURE GetProductTypeID
@PT_name VARCHAR(50),
@PT_ID INT OUTPUT
AS
SET @PT_ID = (SELECT ProductTypeID
              FROM tblPRODUCT_TYPE
              WHERE ProductTypeName = @PT_name)
GO

-- Ziliang
-- Nested stored procedure to get IngredientTypeID
CREATE OR ALTER PROCEDURE GetIngredientTypeID
@IT_name VARCHAR(50),
@IT_ID INT OUTPUT
AS
SET @IT_ID = (SELECT IngredientTypeID
              FROM tblINGREDIENT_TYPE
              WHERE IngredientTypeName = @IT_name)
GO

-- Ziliang
-- Nested stored procedure to get MeasurementID
CREATE OR ALTER PROCEDURE GetMeasurementID
@M_name VARCHAR(100),
@M_ID INT OUTPUT
AS
SET @M_ID = (SELECT MeasurementID
             FROM tblMEASUREMENT
             WHERE MeasurementName = @M_name)
GO

-- Ziliang
-- Nested stored procedure to get SupplierID
CREATE OR ALTER PROCEDURE GetSupplierID
@S_name VARCHAR(100),
@S_ID INT OUTPUT
AS
SET @S_ID = (SELECT SupplierID
             FROM tblSUPPLIER
             WHERE SupplierName = @S_name)
GO

-- Ziliang
-- Nested stored procedure to get IngredientID
CREATE OR ALTER PROCEDURE GetIngredientID
@I_name VARCHAR(100),
@I_ID INT OUTPUT
AS
SET @I_ID = (SELECT IngredientID
             FROM tblINGREDIENT
             WHERE IngredientName = @I_name)
GO

-- Ziliang
-- Nested stored procedure to get ProductID
CREATE OR ALTER PROCEDURE GetProductID
@P_name VARCHAR(100),
@P_ID INT OUTPUT
AS
SET @P_ID = (SELECT ProductID
             FROM tblPRODUCT
             WHERE ProductName = @P_name)


/*
POPULATING DATABASE
*/

-- Jackie
-- Insert into tblCUSTOMER from PEEPS database
INSERT INTO tblCUSTOMER(CustFname, CustLname, CustBirth)
SELECT TOP 400 CustomerFname, CustomerLname, DateOfBirth
FROM PEEPS.dbo.tblCUSTOMER
ORDER BY CustomerID ASC
GO

-- Jackie
-- Populate tblPAYMENT_METHOD
INSERT INTO tblPAYMENT_METHOD (PaymentMethodName)
    VALUES ('Cash'), ('Credit Card'), ('Digital Wallet'), ('Paypal')
GO

-- Ziliang
-- Populate tblRATING
INSERT INTO tblRATING (RatingName, RatingValue)
    VALUES ('Excellent', 5), ('Very Good', 4), ('Decent', 3), ('Poor', 2), ('Unsatisfied', 1)
GO

-- Ziliang
-- Populate tblORDER_TYPE
INSERT INTO tblORDER_TYPE (OrderTypeName)
    VALUES ('At the counter'), ('Pickup'), ('Delivery')
GO


-- Jackie
/*
tblEMPLOYEE and tblEMPLOYEE_TYPE
*/

-- Insert distinct Employee_Type from RAW_EmployeeTypeList
INSERT INTO tblEMPLOYEE_TYPE (EmpTypeName)
SELECT DISTINCT EmployeeType
FROM RAW_EmployeeTypeList
GO

/* Stored procedure to insert into tblEMPLOYEE from RAW_EmployeeTypeList */
CREATE OR ALTER PROCEDURE InsertEmployee
@EmpF VARCHAR(50),
@EmpL VARCHAR(50),
@EmpDOB DATE,
@EmpTname VARCHAR(50)
AS

DECLARE @EmpT_ID INT

EXEC GetEmployeeTypeID
@ET_name = @EmpTname,
@ET_ID = @EmpT_ID OUTPUT
-- error-handling
IF @EmpT_ID IS NULL
    BEGIN
        PRINT '@EmpT_ID is empty... check spelling';
        THROW 54662, '@EmpT_ID cannot be NULL; process is terminating', 1;
    END

BEGIN TRANSACTION T1

INSERT INTO tblEMPLOYEE (EmpFname, EmpLname, EmpBirth, EmployeeTypeID)
    VALUES (@EmpF, @EmpL, @EmpDOB, @EmpT_ID)

-- error-handling
IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION
    END
ELSE
    COMMIT TRANSACTION T1

GO

/*
Create copy of RAW_EmployeeTypeList and add PK

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RAW_EmployeeTypeList_PK](
    [PK_ID] [int] IDENTITY(1,1) PRIMARY KEY,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[Birth] [date] NOT NULL,
	[EmployeeType] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO

INSERT INTO RAW_EmployeeTypeList_PK (FirstName, LastName, Birth, EmployeeType)
SELECT FirstName, LastName, Birth, EmployeeType
FROM RAW_EmployeeTypeList
*/

/* WHILE loop to populate tblEMPLOYEE */

-- declare variables to use in WHILE loop
DECLARE @EFname VARCHAR(50), @ELname VARCHAR(50), @EBirth DATE
DECLARE @ETname VARCHAR(50)
DECLARE @Run INT = (SELECT COUNT(*) FROM RAW_EmployeeTypeList)
DECLARE @EmployeeID INT

-- build a WHILE loop to roll through a COPY of RAW_EmployeeTypeList row-by-row
WHILE @Run > 0

BEGIN

-- set variables to use when executing InsertEmployee
SET @EmployeeID = @Run
SET @EFname = (SELECT FirstName FROM RAW_EmployeeTypeList_PK WHERE PK_ID = @EmployeeID)
SET @ELname = (SELECT LastName FROM RAW_EmployeeTypeList_PK WHERE PK_ID = @EmployeeID)
SET @EBirth = (SELECT Birth FROM RAW_EmployeeTypeList_PK WHERE PK_ID = @EmployeeID)
SET @ETname = (SELECT EmployeeType FROM RAW_EmployeeTypeList_PK WHERE PK_ID = @EmployeeID)

-- execute stored procedure to insert into tblEMPLOYEE
EXEC InsertEmployee
@EmpF = @EFname,
@EmpL = @ELname,
@EmpDOB = @EBirth,
@EmpTname = @ETname

-- decrement the WHILE loop
SET @Run = @Run - 1

END


-- Ziliang
/*
tblINGREDIENT and tblINGREDIENT_TYPE
*/

-- Insert distinct Ingredient_Type from RAW_MilkTeaList
INSERT INTO tblINGREDIENT_TYPE (IngredientTypeName)
SELECT DISTINCT INGREDIENT_TYPE
FROM RAW_MilkTeaList 
GO

-- Temp table to store Ingredient
CREATE TABLE #TempIngredient
(IngredientName VARCHAR(100),
IngredientTypeID INT,
SupplierID INT)
GO

/* Stored procedure to insert into tblINGREDIENT */
CREATE OR ALTER PROCEDURE InsertIngredient
@Ing_name VARCHAR(100),
@IngT_name VARCHAR(50),
@Suplr_name VARCHAR(100)
AS

DECLARE @IngType_ID INT, @Suplr_ID INT

EXEC GetIngredientTypeID
@IT_name = @IngT_name,
@IT_ID = @IngType_ID OUTPUT
-- error-handling
IF @IngType_ID IS NULL
    BEGIN
        PRINT '@IngType_ID is empty... check spelling';
        THROW 54662, '@IngType_ID cannot be NULL; process is terminating', 1;
    END

EXEC GetSupplierID
@S_name = @Suplr_name,
@S_ID = @Suplr_ID OUTPUT
-- error-handling
IF @Suplr_ID IS NULL
    BEGIN
        PRINT '@Suplr_ID is empty... check spelling';
        THROW 54662, '@Suplr_ID cannot be NULL; process is terminating', 1;
    END


BEGIN TRANSACTION T1

-- use a temp table so can select DISTINCT values only later
INSERT INTO #TempIngredient (IngredientName, IngredientTypeID, SupplierID)
    VALUES (@Ing_name, @IngType_ID, @Suplr_ID)

-- error-handling
IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION
    END
ELSE
    COMMIT TRANSACTION T1

GO

/*
Create copy of RAW_MilkTeaList and add PK

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RAW_MilkTeaList_PK](
    [PK_ID] [int] IDENTITY(1,1) PRIMARY KEY,
	[Item] [nvarchar](100) NOT NULL,
	[Price] [float] NOT NULL,
	[ItemType] [nvarchar](50) NOT NULL,
	[Ingredient] [nvarchar](50) NOT NULL,
	[IngredientType] [nvarchar](50) NOT NULL,
	[Measurement] [nvarchar](1) NULL,
	[Supplier] [nvarchar](1) NULL
) ON [PRIMARY]
GO

INSERT INTO RAW_MilkTeaList_PK (Item, Price, ItemType, Ingredient, IngredientType, Measurement, Supplier)
SELECT ITEM, PRICE, ITEM_TYPE, INGREDIENT, INGREDIENT_TYPE, MEASUREMENT, SUPPLIER
FROM RAW_MilkTeaList
*/

/* WHILE loop to populate tblINGREDIENT */

-- declare variables to use in WHILE loop
DECLARE @IngN VARCHAR(100), @ITypeN VARCHAR(50), @SupN VARCHAR(100)
DECLARE @Run INT = (SELECT COUNT(*) FROM RAW_MilkTeaList)
DECLARE @IngredientID INT

-- build a WHILE loop to roll through a COPY of RAW_MilkTeaList row-by-row
WHILE @Run > 0

BEGIN

-- set variables to use when executing InsertIngredient
SET @IngredientID = @Run
SET @IngN = (SELECT Ingredient FROM RAW_MilkTeaList_PK WHERE PK_ID = @IngredientID)
SET @ITypeN = (SELECT IngredientType FROM RAW_MilkTeaList_PK WHERE PK_ID = @IngredientID)
SET @SupN = (SELECT Supplier FROM RAW_MilkTeaList_PK WHERE PK_ID = @IngredientID)

-- execute stored procedure to insert into tblINGREDIENT
EXEC InsertIngredient
@Ing_name = @IngN,
@IngT_name = @ITypeN,
@Suplr_name = @SupN

-- decrement the WHILE loop
SET @Run = @Run - 1

END

/* Insert only DISTINCT IngredientName from temp ingredient table into tblINGREDIENT */
INSERT INTO tblINGREDIENT
SELECT DISTINCT IngredientName, IngredientTypeID, SupplierID
FROM #TempIngredient


-- Jackie
/*
tblPRODUCT and tblPRODUCT_TYPE
*/

-- Insert distinct Item_Type from RAW_MilkTeaList
INSERT INTO tblPRODUCT_TYPE (ProductTypeName)
SELECT DISTINCT ITEM_TYPE
FROM RAW_MilkTeaList
GO

-- Temp table to store Product
CREATE TABLE #TempProduct
(ProductName VARCHAR(100),
Price NUMERIC(4,2),
ProductDescr VARCHAR(300),
ProductTypeID INT)
GO

/* Stored procedure to insert into tblPRODUCT */
CREATE OR ALTER PROCEDURE InsertProduct
@Prodname VARCHAR(100),
@Pricey NUMERIC(4,2),
@ProdDescr VARCHAR(300),
@ProdTyname VARCHAR(50)
AS

DECLARE @ProdTy_ID INT

EXEC GetProductTypeID
@PT_name = @ProdTyname,
@PT_ID = @ProdTy_ID OUTPUT
-- error-handling
IF @ProdTy_ID IS NULL
    BEGIN
        PRINT '@ProdTy_ID is empty... check spelling';
        THROW 54662, '@ProdTy_ID cannot be NULL; process is terminating', 1;
    END

BEGIN TRANSACTION T1

-- use a temp table so can select DISTINCT values only later
INSERT INTO #TempProduct (ProductName, Price, ProductDescr, ProductTypeID)
    VALUES (@Prodname, @Pricey, @ProdDescr, @ProdTy_ID)

-- error-handling
IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION
    END
ELSE
    COMMIT TRANSACTION T1

GO

/* WHILE loop to populate tblPRODUCT */

-- declare variables to use in WHILE loop
DECLARE @ProdN VARCHAR(100), @ProdP NUMERIC(4,2), @ProdDsr VARCHAR(300)
DECLARE @ProdTyN VARCHAR(50)
DECLARE @Run INT = (SELECT COUNT(*) FROM RAW_MilkTeaList)
DECLARE @ProductID INT

-- build a WHILE loop to roll through a COPY of RAW_MilkTeaList row-by-row
WHILE @Run > 0

BEGIN

-- set variables to use when executing InsertProduct
SET @ProductID = @Run
SET @ProdN = (SELECT Item FROM RAW_MilkTeaList_PK WHERE PK_ID = @ProductID)
SET @ProdP = (SELECT Price FROM RAW_MilkTeaList_PK WHERE PK_ID = @ProductID)
SET @ProdDsr = ''
SET @ProdTyN = (SELECT ItemType FROM RAW_MilkTeaList_PK WHERE PK_ID = @ProductID)

-- execute stored procedure to insert into tblPRODUCT
EXEC InsertProduct
@Prodname = @ProdN,
@Pricey = @ProdP,
@ProdDescr = @ProdDsr,
@ProdTyname = @ProdTyN

-- decrement the WHILE loop
SET @Run = @Run - 1

END

/* Insert only DISTINCT ProductName from temp product table into tblPRODUCT */
INSERT INTO tblPRODUCT
SELECT DISTINCT ProductName, Price, ProductDescr, ProductTypeID
FROM #TempProduct

GO

-- Jackie
/*
tblPREPARATION
*/

/* Stored procedure to insert into tblPREPARATION */
CREATE OR ALTER PROCEDURE InsertPreparation
@Prodname VARCHAR(100),
@Ingname VARCHAR(100),
@Measure VARCHAR(50),
@Quanty INT
AS

DECLARE @Prod_ID INT, @Ing_ID INT, @Mea_ID INT

EXEC GetProductID
@P_name = @Prodname,
@P_ID = @Prod_ID OUTPUT
-- error-handling
IF @Prod_ID IS NULL
    BEGIN
        PRINT '@Prod_ID is empty... check spelling';
        THROW 54662, '@Prod_ID cannot be NULL; process is terminating', 1;
    END

EXEC GetIngredientID
@I_name = @Ingname,
@I_ID = @Ing_ID OUTPUT
-- error-handling
IF @Ing_ID IS NULL
    BEGIN
        PRINT '@Ing_ID is empty... check spelling';
        THROW 54662, '@Ing_ID cannot be NULL; process is terminating', 1;
    END

EXEC GetMeasurementID
@M_name = @Measure,
@M_ID = @Mea_ID OUTPUT
-- error-handling
IF @Mea_ID IS NULL
    BEGIN
        PRINT '@Mea_ID is empty... check spelling';
        THROW 54662, '@Mea_ID cannot be NULL; process is terminating', 1;
    END

BEGIN TRANSACTION T1

INSERT INTO tblPREPARATION (ProductID, IngredientID, MeasurementID, Quantity)
    VALUES (@Prod_ID, @Ing_ID, @Mea_ID, @Quanty)

-- error-handling
IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION
    END
ELSE
    COMMIT TRANSACTION T1

GO

/* WHILE loop to populate tblPREPARATION */

-- declare variables to use in WHILE loop
DECLARE @ProdN VARCHAR(100), @IngN VARCHAR(100), @MeasureN VARCHAR(50), @Quant INT
DECLARE @Run INT = (SELECT COUNT(*) FROM RAW_MilkTeaList)
DECLARE @PrepID INT

-- build a WHILE loop to roll through a COPY of RAW_MilkTeaList row-by-row
WHILE @Run > 0

BEGIN

-- set variables to use when executing InsertPreparation
SET @PrepID = @Run
SET @ProdN = (SELECT Item FROM RAW_MilkTeaList_PK WHERE PK_ID = @PrepID)
SET @IngN = (SELECT Ingredient FROM RAW_MilkTeaList_PK WHERE PK_ID = @PrepID)
SET @MeasureN = (SELECT Measurement FROM RAW_MilkTeaList_PK WHERE PK_ID = @PrepID)
SET @Quant = 1

-- execute stored procedure to insert into tblPREPARATION
EXEC InsertPreparation
@Prodname = @ProdN,
@Ingname = @IngN,
@Measure = @MeasureN,
@Quanty = @Quant

-- decrement the WHILE loop
SET @Run = @Run - 1

END

GO

/* Synthetic transaction */
-- ZILIANG 
CREATE OR ALTER PROCEDURE group13_tblPREPARATION_syntran_wrapper
@Run INT
AS

DECLARE @ProductCount INT = (SELECT COUNT(*) FROM tblPRODUCT)
DECLARE @IngredientCount INT = (SELECT COUNT(*) FROM tblINGREDIENT)
DECLARE @MeasurementCount INT = (SELECT COUNT(*) FROM tblMEASUREMENT)

DECLARE
@ProdN VARCHAR(100),
@IngN VARCHAR(100),
@MeasureN VARCHAR(50),
@Quant INT

DECLARE @Prod_PK INT, @Ing_PK INT, @Measure_PK INT

WHILE @Run > 0
BEGIN

SET @Prod_PK = (SELECT RAND() * @ProductCount + 1)
SET @ProdN = (SELECT ProductName FROM tblPRODUCT WHERE ProductID = @Prod_PK)
-- error-handling
    IF @ProdN IS NULL
        BEGIN
            SET @ProdN = (SELECT TOP 1 ProductName FROM tblPRODUCT)
        END

SET @Ing_PK = (SELECT RAND() * @IngredientCount + 1)
SET @IngN = (SELECT IngredientName FROM tblINGREDIENT WHERE IngredientID = @Ing_PK)
-- error-handling
    IF @IngN IS NULL
        BEGIN
            SET @IngN = (SELECT TOP 1 IngredientName FROM tblINGREDIENT)
        END

SET @Measure_PK = (SELECT RAND() * @MeasurementCount + 1)
SET @MeasureN = (SELECT MeasurementName FROM tblMEASUREMENT WHERE MeasurementID = @Measure_PK)
-- error-handling
    IF @MeasureN IS NULL
        BEGIN
            SET @MeasureN = (SELECT TOP 1 MeasurementName FROM tblMEASUREMENT)
        END

SET @Quant = (SELECT FLOOR(RAND() * 10))

-- execute stored procedure to insert into tblPREPARATION
EXEC InsertPreparation
@Prodname = @ProdN,
@Ingname = @IngN,
@Measure = @MeasureN,
@Quanty = @Quant

-- decrement the WHILE loop
SET @Run = @Run - 1

END

-- execute synthetic transaction to ensure it works
EXEC group13_tblPREPARATION_syntran_wrapper 100
GO


--- JACKIE 
/*
tblORDER
*/

/* Stored procedure to insert into tblORDER */
CREATE OR ALTER PROCEDURE InsertOrder
@CFNAME VARCHAR(50),
@CLNAME VARCHAR(50),
@CDOB DATE,
@OT_NAME1 VARCHAR(50),
@PM_NAME1 VARCHAR(50),
@O_Date DATE,
@O_Descr VARCHAR(300)
AS

DECLARE @PAYMENTMETHODID INT, @CUSTOMERID INT, @ORDERTYPEID INT

EXEC GetCustomerID
@C_Fname = @CFNAME,
@C_Lname = @CLNAME,
@C_DOB = @CDOB,
@C_ID = @CUSTOMERID OUTPUT
-- error-handling
IF @CUSTOMERID IS NULL
    BEGIN
        PRINT '@CUSTOMERID is empty... check spelling';
        THROW 54662, '@CUSTOMERID cannot be NULL; process is terminating', 1;
    END

EXEC GetOrderTypeID
@OT_name = @OT_NAME1,
@OT_ID = @ORDERTYPEID OUTPUT
-- error-handling
IF @ORDERTYPEID IS NULL
    BEGIN
        PRINT '@ORDERTYPEID is empty... check spelling';
        THROW 54662, '@ORDERTYPEID cannot be NULL; process is terminating', 1;
    END

EXEC GetPaymentMethodID
@PM_name = @PM_NAME1,
@PM_ID = @PAYMENTMETHODID OUTPUT
-- error-handling
IF @PAYMENTMETHODID IS NULL
    BEGIN
        PRINT '@PAYMENTMETHODID is empty... check spelling';
        THROW 54662, '@PAYMENTMETHODID cannot be NULL; process is terminating', 1;
    END

BEGIN TRANSACTION T1

INSERT INTO tblORDER (OrderDate, OrderDescr, PaymentMethodID, CustomerID, OrderTypeID)
   VALUES (@O_Date, @O_Descr, @PAYMENTMETHODID, @CUSTOMERID, @ORDERTYPEID)

-- error-handling
IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION
    END
ELSE
    COMMIT TRANSACTION T1

GO


-- ZILIANG 
/* Synthetic transaction */
CREATE OR ALTER PROCEDURE group13_tblORDER_syntran_wrapper
@Run INT
AS

DECLARE @Cust_MaxID_Count INT = (SELECT MAX(CustomerID) FROM tblCUSTOMER)
DECLARE @Cust_MinID_Count INT = (SELECT Min(CustomerID) FROM tblCUSTOMER)
DECLARE @OT_COUNT INT = (SELECT MAX(OrderTypeID) FROM tblORDER_TYPE)
DECLARE @PM_COUNT INT = (SELECT MAX(PaymentMethodID) FROM tblPAYMENT_METHOD)

DECLARE
@CFNAME1 VARCHAR(30),
@CLNAME1 VARCHAR(30),
@CDOB1 DATE,
@OT_NAME2 VARCHAR(50),
@PM_NAME2 VARCHAR(50),
@O_Date1 DATE,
@O_Descr1 VARCHAR(300)

DECLARE @Cust_PK INT, @OrderType_PK INT, @PayMethod_PK INT

WHILE @Run > 0
BEGIN

SET @Cust_PK = (SELECT FLOOR(RAND() * (@Cust_MaxID_Count - @Cust_MinID_Count + 1)) + @Cust_MinID_Count)
SET @CFNAME1 = (SELECT CustFname FROM tblCUSTOMER WHERE CustomerID = @Cust_PK)
-- error-handling
    IF @CFNAME1 IS NULL
        BEGIN
            SET @CFNAME1 = (SELECT TOP 1 CustFname FROM tblCUSTOMER)
        END
SET @CLNAME1 = (SELECT CustLname FROM tblCUSTOMER WHERE CustomerID = @Cust_PK)
-- error-handling
    IF @CLNAME1 IS NULL
        BEGIN
            SET @CLNAME1 = (SELECT TOP 1 CustLname FROM tblCUSTOMER)
        END
SET @CDOB1 = (SELECT CustBirth FROM tblCUSTOMER WHERE CustomerID = @Cust_PK)
-- error-handling
    IF @CDOB1 IS NULL
        BEGIN
            SET @CDOB1 = (SELECT TOP 1 CustBirth FROM tblCUSTOMER)
        END

SET @OrderType_PK = (SELECT RAND() * @OT_COUNT + 1)
SET @OT_NAME2 = (SELECT OrderTypeName FROM tblORDER_TYPE WHERE OrderTypeID = @OrderType_PK)
-- error-handling
    IF @OT_NAME2 IS NULL
        BEGIN
            SET @OT_NAME2 = (SELECT TOP 1 OrderTypeName FROM tblORDER_TYPE)
        END

SET @PayMethod_PK = (SELECT RAND() * @PM_COUNT)
SET @PM_NAME2 = (SELECT PaymentMethodName FROM tblPAYMENT_METHOD WHERE PaymentMethodID = @PayMethod_PK)
-- error-handling
    IF @PM_NAME2 IS NULL
        BEGIN
            SET @PM_NAME2 = (SELECT TOP 1 PaymentMethodName FROM tblPAYMENT_METHOD)
        END

SET @O_Date1 = (SELECT GETDATE() - (SELECT RAND() * 1000))
SET @O_Descr1 = ''

EXEC InsertOrder
@CFNAME = @CFNAME1,
@CLNAME = @CLNAME1,
@CDOB = @CDOB1,
@OT_NAME1 = @OT_NAME2,
@PM_NAME1 = @PM_NAME2,
@O_Date = @O_Date1,
@O_Descr= @O_Descr1

SET @Run = @Run - 1

END

-- execute synthetic transaction to ensure it works
EXEC group13_tblORDER_syntran_wrapper 200

GO


/*
BUSINESS RULE
*/

-- Jackie
-- Order type ‘Delivery’ or ‘Pickup’ cannot use payment method ‘Cash’
CREATE OR ALTER FUNCTION fn_NoCashAllowed()
RETURNS INTEGER
AS
BEGIN

DECLARE @RET INTEGER = 0
IF EXISTS (SELECT *
           FROM tblORDER O
               JOIN tblORDER_TYPE OT ON O.OrderTypeID = OT.OrderTypeID
               JOIN tblPAYMENT_METHOD PM ON O.PaymentMethodID = PM.PaymentMethodID
           WHERE OT.OrderTypeName IN ('Delivery', 'Pickup')
           AND PM.PaymentMethodName = 'Cash')
SET @RET = 1
RETURN @RET
END
GO

ALTER TABLE tblORDER
ADD CONSTRAINT CashForbiddenForDeliveryPickup
CHECK (dbo.fn_NoCashAllowed() = 0)
GO


-- Jackie
-- Customers older than 50 years old cannot order the product 'Signature Milk Tea'
CREATE OR ALTER FUNCTION fn_NoSigMilkTea()
RETURNS INT
AS
BEGIN

DECLARE @RET INT = 0
IF EXISTS (SELECT *
           FROM tblORDER O
               JOIN tblCUSTOMER C ON O.CustomerID = C.CustomerID
               JOIN tblORDER_PRODUCT OP ON O.OrderID = OP.OrderID
               JOIN tblPRODUCT P ON OP.ProductID = P.ProductID
           WHERE P.ProductName = 'Signature Milk Tea'
           AND C.CustBirth < DATEADD(YEAR, -50, GETDATE()))
SET @RET = 1
RETURN @RET
END
GO

ALTER TABLE tblORDER
ADD CONSTRAINT Over50CannotDrinkSMT
CHECK (dbo.fn_NoSigMilkTea() = 0)
GO


-- Ziliang
-- Rating value cannot be less than 1 or more than 5
CREATE OR ALTER FUNCTION fn_RatingBetweenOneFive()
RETURNS INT
AS
BEGIN

DECLARE @RET INT = 0
IF EXISTS (SELECT *
           FROM tblRATING
           WHERE (RatingValue < 1 OR RatingValue > 5))
SET @RET = 1
RETURN @RET
END
GO

ALTER TABLE tblRATING
ADD CONSTRAINT RatingConstraint
CHECK (dbo.fn_RatingBetweenOneFive() = 0)
GO


-- Ziliang
-- Customers younger than 18 cannot order drinks of product type 'Creama' or ingredient of type 'Topping'
CREATE FUNCTION fn_NoCreamaOrTopping()
RETURNS INT
AS
BEGIN

DECLARE @RET INT = 0
IF EXISTS (SELECT *
           FROM tblCUSTOMER C
               JOIN tblORDER O ON O.CustomerID = C.CustomerID
               JOIN tblORDER_PRODUCT OP ON O.OrderID = OP.OrderID
               JOIN tblPRODUCT P ON OP.ProductID = P.ProductID
               JOIN tblPRODUCT_TYPE PT ON P.ProductTypeID = PT.ProductTypeID
               JOIN tblPREPARATION PR ON P.ProductID = PR.ProductID
               JOIN tblINGREDIENT I ON PR.IngredientID = I.IngredientID
               JOIN tblINGREDIENT_TYPE IT ON I.IngredientTypeID = IT.IngredientTypeID
           WHERE C.CustBirth > DATEADD(YEAR, -18, GETDATE())
           AND (PT.ProductTypeName = 'Creama' OR IT.IngredientTypeName = 'Topping'))
SET @RET = 1
RETURN @RET
END
GO

ALTER TABLE tblORDER
ADD CONSTRAINT Younger18CannotCreamaTopping
CHECK (dbo.fn_NoCreamaOrTopping() = 0)
GO



/*
COMPUTED COLUMN
*/

-- Ziliang
-- tblORDER_PRODUCT
   --  Subtotal NUMERIC(6,2)
CREATE FUNCTION CalcItemSubtotal(@PK INT)
RETURNS NUMERIC(6,2)
AS
BEGIN
DECLARE @RET NUMERIC(6,2) = (SELECT (P.Price * OP.Quantity)
                             FROM tblORDER_PRODUCT OP
                                 JOIN tblPRODUCT P ON OP.ProductID = P.ProductID
                             WHERE OP.ProductID = @PK)
RETURN @RET
END
GO

ALTER TABLE tblORDER_PRODUCT
ADD Subtotal AS (dbo.CalcItemSubtotal(ProductID))
GO

-- Jackie
-- tblORDER
   -- OrderTotal NUMERIC(8,2)
       -- SUM OF SUBTOTAL
CREATE FUNCTION CalcOrderTotal(@PK INT)
RETURNS NUMERIC(8,2)
AS
BEGIN
DECLARE @RET NUMERIC(8,2) = (SELECT SUM(Subtotal)
                             FROM tblORDER_PRODUCT
                             WHERE OrderID = @PK)
 
RETURN @RET
END
GO
 
ALTER TABLE tblORDER
ADD OrderTotal AS (DBO.CalcOrderTotal(OrderID))
GO


-- Jackie
-- tblCUSTOMER
   -- Number of customers born in 1990's
CREATE FUNCTION Calc1990sBornCustomers(@PK INT)
RETURNS INT
AS
BEGIN
DECLARE @RET INT = (SELECT COUNT(CustomerID)
                    FROM tblCUSTOMER
                    WHERE YEAR(CustBirth) LIKE '199%'
                    AND CustomerID = @PK)
RETURN @RET
END
GO

ALTER TABLE tblCUSTOMER
ADD Birth1990s AS (dbo.Calc1990sBornCustomers(CustomerID))
GO


-- Ziliang
-- tblPRODUCT
   -- Average rating of each product in the most recent year
CREATE OR ALTER FUNCTION CalcProductAverageRating(@PK INT)
RETURNS INT
AS
BEGIN
DECLARE @RET INT = (SELECT AVG(RT.RatingValue)
                    FROM tblREVIEW R
                        JOIN tblRATING RT ON R.RatingID = RT.RatingID
                        JOIN tblORDER_PRODUCT OP ON R.OrderProductID = OP.OrderProductID
                        JOIN tblPRODUCT P ON OP.ProductID = P.ProductID
                    WHERE R.ReviewDate > DATEADD(YEAR, -1, GETDATE())
                    AND P.ProductID = @PK)
RETURN @RET
END
GO

ALTER TABLE tblPRODUCT
ADD AvgRating AS (DBO.CalcProductAverageRating(ProductID))
GO



/*
COMPLEX QUERY + VIEW
*/

-- Jackie
-- Which customers have purchased over $200 (in their lifetime) of products of type 'Fruit Tea'
-- that have also purchased at least 5 products of type 'Brewed Tea' and includes the ingredient type 'Topping'
CREATE VIEW Cust_View_1
AS
SELECT A.CustomerID, A.CustFname, A.CustLname, A.LifetimeOrderSumTotal, B.ProductCount
FROM
(SELECT C.CustomerID, C.CustFname, C.CustLname, SUM(O.OrderTotal) AS LifetimeOrderSumTotal
FROM tblCUSTOMER C
    JOIN tblORDER O ON C.CustomerID = O.CustomerID
    JOIN tblORDER_PRODUCT OP ON O.OrderID = OP.OrderID
    JOIN tblPRODUCT P ON OP.ProductID = P.ProductID
    JOIN tblPRODUCT_TYPE PT ON P.ProductTypeID = PT.ProductTypeID
WHERE PT.ProductTypeName = 'Fruit Tea' 
GROUP BY C.CustomerID, C.CustFname, C.CustLname
HAVING SUM(O.OrderTotal) > 200) AS A,
(SELECT C.CustomerID, C.CustFname, C.CustLname, COUNT(P.ProductID) AS ProductCount
FROM tblCUSTOMER C
    JOIN tblORDER O ON C.CustomerID = O.CustomerID
    JOIN tblORDER_PRODUCT OP ON O.OrderID = OP.OrderID
    JOIN tblPRODUCT P ON OP.ProductID = P.ProductID
    JOIN tblPRODUCT_TYPE PT ON P.ProductTypeID = PT.ProductTypeID
    JOIN tblPREPARATION PREP ON P.ProductID = PREP.ProductID
    JOIN tblINGREDIENT I ON PREP.IngredientID = I.IngredientID
    JOIN tblINGREDIENT_TYPE IT ON I.IngredientTypeID = IT.IngredientTypeID
WHERE PT.ProductTypeName = 'Brewed Tea'
AND IT.IngredientTypeName = 'Topping'
GROUP BY C.CustomerID, C.CustFname, C.CustLname
HAVING COUNT(P.ProductID) >= 5) AS B
WHERE A.CustomerID = B.CustomerID

GO


-- Jackie
-- Find the top 5 employees of type 'Barista' who worked on products with a subtotal
-- between the 21% and 74% --> NTILE()
CREATE VIEW Barista_Subtotal_View
AS
WITH CTE_Product_Subtotal (ID, Fname, Lname, Subtotal, Percentile)
AS
(SELECT E.EmployeeID, E.EmpFname, E.EmpLname, SUM(OP.Subtotal),
NTILE(100) OVER (ORDER BY SUM(OP.Subtotal))
FROM tblEMPLOYEE E
    JOIN tblEMPLOYEE_TYPE ET ON E.EmployeeTypeID = ET.EmployeeTypeID
    JOIN tblORDER_PRODUCT OP ON E.EmployeeID = OP.EmployeeID
WHERE ET.EmpTypeName = 'Barista'
GROUP BY E.EmployeeID, E.EmpFname, E.EmpLname)

SELECT TOP 5 *
FROM CTE_Product_Subtotal
WHERE Percentile BETWEEN 21 AND 74

GO


-- Ziliang
/*
Write the SQL to determine and label the number of customers that meet each of the following conditions:
1) Spent less than $7000 after the 2000s and ordered less than 100 products with the ingreident type 'Topping' in their lifetime
    -- Red
2) Spent between $7000 and $10000 after the 2000s and ordered between 100 and 150 products with the ingreident type 'Topping' in their lifetime
    -- Blue
3) Spent between $10001 and $13000 after the 2000s and ordered more than 150 products with the ingreident type 'Topping' in their lifetime
    -- Green
4) If not found above
    -- Orange
*/
CREATE VIEW Complex_Customer_Spending
AS
SELECT (CASE
    WHEN (TotalSpending < 7000)  AND (NUMPRODUCT < 100)
        THEN 'Red'
    WHEN (TotalSpending BETWEEN 7000 AND 10000) AND (NUMPRODUCT BETWEEN 100 AND 150)
        THEN 'Blue'
    WHEN (TotalSpending BETWEEN 10001 AND 13000) AND (NUMPRODUCT > 150)
        THEN 'Green'
    ELSE 'Orange'
END) ColumnLabel, COUNT(*) AS NumCustomers
FROM

(SELECT A.CustomerID, A.CustFname, A.CustLname, A.TotalSpending, B.NumProduct
FROM
(SELECT C.CustomerID, C.CustFname, C.CustLname, SUM(O.OrderTotal) AS TotalSpending
FROM tblCUSTOMER C
    JOIN tblORDER O ON C.CustomerID = O.CustomerID
WHERE YEAR(O.OrderDate) > 2000
GROUP BY C.CustomerID, C.CustFname, C.CustLname) A,
(SELECT C.CustomerID, C.CustFname, C.CustLname, COUNT(P.ProductID) AS NumProduct
FROM tblCUSTOMER C
  JOIN tblORDER O ON C.CustomerID = O.CustomerID
  JOIN tblORDER_PRODUCT OP ON O.OrderID = OP.OrderID
  JOIN tblPRODUCT P ON OP.ProductID = P.ProductID
  JOIN tblPREPARATION PR ON P.ProductID = PR.ProductID
  JOIN tblINGREDIENT I ON PR.IngredientID = I.IngredientID
  JOIN tblINGREDIENT_TYPE IT ON I.IngredientTypeID = IT.IngredientTypeID
WHERE IT.IngredientTypeName ='Topping'
GROUP BY C.CustomerID, C.CustFname, C.CustLname) B
WHERE A.CustomerID = B.CustomerID) C

GROUP BY (CASE
    WHEN (TotalSpending < 7000)  AND (NUMPRODUCT < 100)
        THEN 'Red'
    WHEN (TotalSpending BETWEEN 7000 AND 10000) AND (NUMPRODUCT BETWEEN 100 AND 150)
        THEN 'Blue'
    WHEN (TotalSpending BETWEEN 10001 AND 13000) AND (NUMPRODUCT > 150)
        THEN 'Green'
    ELSE 'Orange'
END)
GO


-- Ziliang
-- Write the SQL to determine the 5th highest number of sales of a product in the past five years.
CREATE VIEW Fifth_Highest_Sales
AS
WITH CTE_Highest_Product (ID, ProductName, Num_Sales, D_RANKY)
AS
(SELECT P.ProductID, P.ProductName, COUNT(O.OrderID) AS Num_Sales,
DENSE_RANK() OVER (ORDER BY COUNT(O.OrderID))
FROM tblPRODUCT P
    JOIN tblORDER_PRODUCT OP ON P.ProductID = OP.ProductID
    JOIN tblORDER O ON OP.OrderID = O.OrderID
WHERE O.OrderDate > DATEADD(YEAR, -5, GETDATE())
GROUP BY P.ProductID, P.ProductName)

SELECT *
FROM CTE_Highest_Product
WHERE D_RANKY = 5