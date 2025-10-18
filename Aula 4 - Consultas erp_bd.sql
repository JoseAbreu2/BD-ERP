create database erp_db;
use erp_db;

-- TABELA Categories

CREATE TABLE Categories (
    CategoryID INT NOT NULL auto_increment,
    CategoryName VARCHAR(100) NOT NULL,
    Description VARCHAR(255) NULL,
    PRIMARY KEY (CategoryID)
);

-- upload de CSV

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Categories.csv'
INTO TABLE Categories
FIELDS TERMINATED BY ';'      -- Campos separados por ponto e vírgula
ENCLOSED BY ''                -- Não há delimitador de texto (aspas)
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;                -- Ignora a linha de cabeçalho

select * from categories;

-- ----------------------------- FIM BLOCO -------------------------------------------

-- TABELA CUSTOMERS
-- 1. Script para criar a tabela 'Customers'
CREATE TABLE `Customers` (
    `CustomerID` INT NOT NULL auto_increment,
    `CustomerName` VARCHAR(100) NOT NULL,
    `ContactName` VARCHAR(100) NULL,
    `Address` VARCHAR(255) NULL,
    `City` VARCHAR(100) NULL,
    `PostalCode` VARCHAR(20) NULL,
    `Country` VARCHAR(100) NULL,
    PRIMARY KEY (`CustomerID`)
);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Customers.csv'
INTO TABLE Customers
FIELDS TERMINATED BY ';'      -- Campos separados por ponto e vírgula
ENCLOSED BY ''                -- Não há delimitador de texto (aspas)
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;                -- Ignora a linha de cabeçalho

select * from customers;

-- ----------------------------- FIM BLOCO -------------------------------------------

-- TABELA EMPLOYEES

CREATE TABLE `Employees` (
    `EmployeeID` INT NOT NULL auto_increment,
    `LastName` VARCHAR(100) NOT NULL,
    `FirstName` VARCHAR(100) NOT NULL,
    `BirthDate` DATE NULL,
    `Photo` VARCHAR(50) NULL,
    `Notes` TEXT NULL,
    PRIMARY KEY (`EmployeeID`)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Employees.csv'
INTO TABLE Employees
FIELDS TERMINATED BY ';'      -- Campos separados por ponto e vírgula
ENCLOSED BY ''                -- Não há delimitador de texto (aspas)
LINES TERMINATED BY '\n'
IGNORE 1 ROWS                -- Ignora a linha de cabeçalho
(EmployeeID,LastName,FirstName,@BirthDate,Photo,Notes)
set BirthDate = str_to_date(@BirthDate,"%d/%m/%Y");

select * from employees;


-- ----------------------------- FIM BLOCO -------------------------------------------
-- TABELA ORDERDETAILS

CREATE TABLE `OrderDetails` (
    `OrderDetailID` INT NOT NULL auto_increment,
    `OrderID` INT NOT NULL,
    `ProductID` INT NOT NULL,
    `Quantity` INT NULL,
    PRIMARY KEY (`OrderDetailID`)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/OrderDetails.csv'
INTO TABLE OrderDetails
FIELDS TERMINATED BY ';'      -- Campos separados por ponto e vírgula
ENCLOSED BY ''                -- Não há delimitador de texto (aspas)
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;                -- Ignora a linha de cabeçalho

select * from OrderDetails;

-- ----------------------------- FIM BLOCO -------------------------------------------
-- TABELA ORDERS

CREATE TABLE `Orders` (
    `OrderID` INT NOT NULL auto_increment,
    `CustomerID` INT NULL,
    `EmployeeID` INT NULL,
    `OrderDate` DATE NULL,
    `ShipperID` INT NULL,
    PRIMARY KEY (`OrderID`)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Orders.csv'
INTO TABLE Orders
FIELDS TERMINATED BY ';'      -- Campos separados por ponto e vírgula
ENCLOSED BY ''                -- Não há delimitador de texto (aspas)
LINES TERMINATED BY '\n'
IGNORE 1 ROWS                -- Ignora a linha de cabeçalho
(OrderID,CustomerID,EmployeeID,@OrderDate,ShipperID)
set OrderDate = str_to_date(@OrderDate,"%d/%m/%Y");

select * from Orders;

-- ----------------------------- FIM BLOCO -------------------------------------------
-- TABELA PRODUCTS

CREATE TABLE `Products` (
    `ProductID` INT NOT NULL,
    `ProductName` VARCHAR(100) NOT NULL,
    `SupplierID` INT NULL,
    `CategoryID` INT NULL,
    `Unit` VARCHAR(100) NULL,
    `Price` DECIMAL(10,2) NULL,
    PRIMARY KEY (`ProductID`)
);

-- CARREGAR COM TRANSFORMAÇÃO DE DADOS / PRICE SEPARDOR DECIMAL COM VIRGULA PARA PONTO
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Products.csv'
INTO TABLE products
FIELDS TERMINATED BY ';'      -- Campos separados por ponto e vírgula
ENCLOSED BY ''                -- Não há delimitador de texto (aspas)
LINES TERMINATED BY '\n'
IGNORE 1 ROWS                -- Ignora a linha de cabeçalho
(ProductID,ProductName,SupplierID,CategoryID,Unit,@Price)
set Price = replace(@Price,",",".");

select * from Products;

-- ----------------------------- FIM BLOCO -------------------------------------------
-- TABELA SHIPPERS

CREATE TABLE `Shippers` (
    `ShipperID` INT NOT NULL auto_increment,
    `ShipperName` VARCHAR(100) NOT NULL,
    `Phone` VARCHAR(50) NULL,
    PRIMARY KEY (`ShipperID`)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Shippers.csv'
INTO TABLE shippers
FIELDS TERMINATED BY ';'      -- Campos separados por ponto e vírgula
ENCLOSED BY ''                -- Não há delimitador de texto (aspas)
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;                -- Ignora a linha de cabeçalho

select * from shippers;

-- ----------------------------- FIM BLOCO -------------------------------------------
-- TABELA SUPPLIERS

CREATE TABLE `Suppliers` (
    `SupplierID` INT NOT NULL auto_increment,
    `SupplierName` VARCHAR(100) NOT NULL,
    `ContactName` VARCHAR(100) NULL,
    `Address` VARCHAR(255) NULL,
    `City` VARCHAR(100) NULL,
    `PostalCode` VARCHAR(20) NULL,
    `Country` VARCHAR(100) NULL,
    `Phone` VARCHAR(50) NULL,
    PRIMARY KEY (`SupplierID`)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Suppliers.csv'
INTO TABLE Suppliers
FIELDS TERMINATED BY ';'      -- Campos separados por ponto e vírgula
ENCLOSED BY ''                -- Não há delimitador de texto (aspas)
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;                -- Ignora a linha de cabeçalho

select * from suppliers;

-- ----------------------------- FIM BLOCO -------------------------------------------


-- ----------- RELACIONAMENTOS FOREING KEY ------------------------

-- ------------------------------------------------------------------
-- Adicionando Chaves Estrangeiras na tabela 'Orders'
-- (Orders -> Customers, Orders -> Employees, Orders -> Shippers)
-- ------------------------------------------------------------------

ALTER TABLE `Orders`
    ADD CONSTRAINT `fk_orders_customers`
        FOREIGN KEY (`CustomerID`) REFERENCES `Customers`(`CustomerID`);

ALTER TABLE `Orders`
    ADD CONSTRAINT `fk_orders_employees`
        FOREIGN KEY (`EmployeeID`) REFERENCES `Employees`(`EmployeeID`);

ALTER TABLE `Orders`
    ADD CONSTRAINT `fk_orders_shippers`
        FOREIGN KEY (`ShipperID`) REFERENCES `Shippers`(`ShipperID`);


-- ------------------------------------------------------------------
-- Adicionando Chaves Estrangeiras na tabela 'Products'
-- (Products -> Suppliers, Products -> Categories)
-- ------------------------------------------------------------------

ALTER TABLE `Products`
    ADD CONSTRAINT `fk_products_suppliers`
        FOREIGN KEY (`SupplierID`) REFERENCES `Suppliers`(`SupplierID`);
        
ALTER TABLE `Products`
    ADD CONSTRAINT `fk_products_categories`
        FOREIGN KEY (`CategoryID`) REFERENCES `Categories`(`CategoryID`);


-- ------------------------------------------------------------------
-- Adicionando Chaves Estrangeiras na tabela 'OrderDetails'
-- (OrderDetails -> Orders, OrderDetails -> Products)
-- ------------------------------------------------------------------

ALTER TABLE `OrderDetails`
    ADD CONSTRAINT `fk_orderdetails_orders`
        FOREIGN KEY (`OrderID`) REFERENCES `Orders`(`OrderID`);

ALTER TABLE `OrderDetails`
    ADD CONSTRAINT `fk_orderdetails_products`
        FOREIGN KEY (`ProductID`) REFERENCES `Products`(`ProductID`);