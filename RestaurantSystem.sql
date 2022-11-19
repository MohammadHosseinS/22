--Boro video ro bebin (multiple datasets) => https://www.youtube.com/watch?v=eKkh5Xm0OlU


--Branches
CREATE TABLE Branches
(Id INT PRIMARY KEY IDENTITY,
City VARCHAR(50),
Name VARCHAR(50)
)
-- ***** --
INSERT INTO dbo.Branches VALUES('Tehran', 'Vazir'), ('Tehran', 'Vazir2'), ('Tehran', 'Vazir3'),  ('Qom', 'Vazir4'), ('Qom', 'Vazir5'), ('Esfehan', 'Vazir6')




--Employees
CREATE TABLE Employees 
(Id INT PRIMARY KEY IDENTITY,
Name VARCHAR(50),
UserName VARCHAR(50),
PassWord VARCHAR(50),
BranchId INT FOREIGN KEY REFERENCES dbo.Branches)
--  *****  --
INSERT INTO dbo.Employees VALUES ('Mohammad Azizi', 'MAzizi', '123456', 1), ('Mostafa Mohammadi','MMohammadi', '123456', 2), ('Reza Alimi','RAlimi', '123456', 3), ('Afshin Soltani','ASoltani', '123456', 4), ('Hamid Shahani','HShahani', '123456', 5)




--Customers
CREATE TABLE Customers
(id INT PRIMARY KEY IDENTITY,
Name VARCHAR(50),
Phone VARCHAR(50),
Address VARCHAR(50)
)
--  *****  --
CREATE PROC SaveCustomers
@Id int,
@Name VARCHAR(50),
@Phone VARCHAR(50),
@Address VARCHAR(50)
AS
BEGIN
		IF @Id IS NULL OR @Id = 0
		BEGIN
				INSERT INTO dbo.Customers VALUES(@Name, @Phone, @Address)
				SELECT 'Etelaat sabt shod'
		END

		ELSE
		BEGIN
				UPDATE dbo.Customers SET Name = @Name, Phone = @Phone, Address = @Address
				SELECT 'Etelaat virayesh shod'
		END
END
--  *****  --
CREATE PROC ReadCustomers
@Id int,
@Phone VARCHAR(50)
AS
BEGIN
		IF (@Id IS NULL OR @Id = 0) AND (@Phone IS NULL OR @Phone = '')
				SELECT * FROM dbo.Customers

		ELSE IF (@Id IS NULL OR @Id = 0) AND (@Phone IS NOT NULL OR NOT @Phone = '')
				SELECT * FROM dbo.Customers WHERE Phone = @Phone

		ELSE IF (@Id > 0)
				SELECT * FROM dbo.Customers WHERE Id = @Id

		-- The following is used for AutoCompleteBoxes
		ELSE IF (@Id < 0)
				SELECT Phone FROM dbo.Customers
		
		ELSE
				SELECT * FROM dbo.Customers
END

GO




--Items
CREATE TABLE Items
(Id INT PRIMARY KEY IDENTITY,
Name VARCHAR(50),
Price INT)
--  *****  --
CREATE PROC SaveItems
@Id int,
@Name VARCHAR(50),
@Price INT
AS
BEGIN
		IF @Id IS NULL OR @Id = 0
		BEGIN
				INSERT INTO dbo.Items VALUES (@Name, @Price)
				SELECT 'Etelaat sabt shod'
		END

		ELSE
		BEGIN
				UPDATE dbo.Items SET Name = @Name, Price = @Price WHERE Id = @Id
				SELECT 'Etelaat virayesh shod'
		END
END
GO
--  *****  --
CREATE PROC ReadItems
@Id INT,
@Name VARCHAR(50)
AS
BEGIN
		IF (@Id IS NULL OR @Id = 0) AND (@Name IS NULL OR @Name = '')
				SELECT * FROM dbo.Items

		ELSE IF (@Id IS NULL OR @Id = 0) AND (@Name IS NOT NULL OR NOT @Name = '')
				SELECT * FROM dbo.Items WHERE Name = @Name

		ELSE IF (@Id > 0)
				SELECT * FROM dbo.Items WHERE Id = @Id

		-- The following is used for AutoCompleteBoxes
		ELSE IF (@Id < 0)
				SELECT Name FROM dbo.Items

		ELSE
				SELECT * FROM dbo.Items
END
GO




--OrderFiles
CREATE TABLE OrderFiles
(Id INT PRIMARY KEY IDENTITY,
CustomerId INT FOREIGN KEY REFERENCES dbo.Customers,
Date DateTime,
TotalPrice INT)
-- ***** --
CREATE PROC SaveOrderFiles
@Id INT,
@CustomerId INT,
@Date DATETIME,
@TotalPrice INT
AS BEGIN
		IF @id IS NULL OR @id = 0
		BEGIN
				INSERT INTO dbo.OrderFiles VALUES (@CustomerId, @Date, @TotalPrice)
				SELECT 'Etelaat sabt shod'
		END

		ELSE
		BEGIN
				UPDATE dbo.OrderFiles SET CustomerId = @CustomerId, Date = @Date, TotalPrice = @TotalPrice WHERE Id = @Id
				SELECT 'Etelaat virayesh shod'
		END
END
GO




--OrderFiles_Items
CREATE TABLE OrderFiles_Items
(Id INT PRIMARY KEY IDENTITY,
ItemsId INT FOREIGN KEY REFERENCES dbo.Items,
OFId INT FOREIGN KEY REFERENCES dbo.OrderFiles)
--  *****  --
CREATE PROC SaveOrderFiles_Items
@Id INT,
@Item_Name VARCHAR(50),
@OrderFile_Date DATETIME
AS
BEGIN
		IF	@Id IS NULL OR @Id = 0
		BEGIN
				INSERT INTO dbo.OrderFiles_Items VALUES (
				(SELECT Id FROM dbo.Items WHERE Id = @Item_Name),
				(SELECT Id FROM dbo.OrderFiles WHERE Id = @Item_Name)
				)
		SELECT 'Ertebat ijad shod'
		END

		ELSE
		BEGIN
				UPDATE dbo.OrderFiles_Items SET ItemsId = (SELECT Id FROM dbo.Items WHERE Name = @Item_Name),
																		OFId = (SELECT Id FROM dbo.OrderFiles WHERE Date = @OrderFile_Date)
				WHERE Id = @Id
				SELECT 'Ertebat virayesh shod'
		END
END
GO





--  *****  --
CREATE PROC ReadOrderFiles
@Id INT,
@Date DATETIME
AS
BEGIN
		IF @Id IS NULL OR @Id = 0
				SELECT Name, Phone, TotalPrice, Date FROM dbo.OrderFiles O LEFT OUTER JOIN dbo.Customers C ON C.id = O.CustomerId

		ELSE IF (@Id IS NULL OR @Id = 0) AND @Date IS NOT NULL 
				SELECT * FROM dbo.OrderFiles WHERE Date = @Date

		ELSE IF @Id > 0
				SELECT * FROM dbo.OrderFiles WHERE Id = @Id

		ELSE
				SELECT 'Voroodi Namotabar'
END
GO

--  *****  --

CREATE PROC ReadOrderFile_Items
@OrderId INT
AS 
BEGIN
		IF @OrderId IS NULL OR @OrderId = 0
				SELECT I.Name, I.Price, O.Date, O.TotalPrice FROM dbo.Items I
				JOIN dbo.OrderFiles_Items OI ON I.Id = OI.ItemsId
				JOIN dbo.OrderFiles O ON OI.OFId = O.Id
		ELSE
				SELECT 'Voroodi Namotabar'

END
GO



create proc testingDynamic
@string varchar(50),
@date datetime
as
begin
select @string + @date
end
go