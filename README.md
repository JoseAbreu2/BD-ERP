# BD-ERP
Banco de Dados para gerenciamento de clientes e vendas


# Estruturação e Carga de Banco de Dados ERP com MySQL

## 1. Visão Geral do Projeto

Este projeto consiste na estruturação e preenchimento de um banco de dados relacional chamado **`erp_db`** [1], que simula um **Sistema ERP (Enterprise Resource Planning)**, utilizando o **MySQL** [1].

O foco principal é a **carga eficiente e rápida de grandes volumes de dados** a partir de arquivos CSV (Comma-Separated Values) [2]. Para isso, é empregado o comando **`LOAD DATA INFILE`** [1, 3-11], que é a ferramenta mais rápida e eficaz para transferir listas extensas de dados de arquivos de texto simples para as tabelas do SGBD [2].

O CSV é um formato de arquivo amplamente utilizado para armazenar e transmitir dados tabulares, onde os valores são separados por um delimitador [12].

## 2. Estrutura do Banco de Dados (`erp_db`)

O banco de dados é composto por nove tabelas principais. O projeto começa com a criação do banco de dados (`create database erp_db;`) e sua seleção (`use erp_db;`) [1].

| Tabela | Chave Primária | Colunas Principais | Citações |
| :--- | :--- | :--- | :--- |
| **Categories** | `CategoryID` | `CategoryName`, `Description` | [1] |
| **Customers** | `CustomerID` | `CustomerName`, `ContactName`, `Address`, `City`, `PostalCode`, `Country` | [3] |
| **Employees** | `EmployeeID` | `LastName`, `FirstName`, `BirthDate`, `Photo`, `Notes` | [4] |
| **Shippers** | `ShipperID` | `ShipperName`, `Phone` | [9] |
| **Suppliers** | `SupplierID` | `SupplierName`, `ContactName`, `Address`, `City`, `PostalCode`, `Country`, `Phone` | [10, 11] |
| **Products** | `ProductID` | `ProductName`, `SupplierID`, `CategoryID`, `Unit`, `Price` (DECIMAL(10,2)) | [8] |
| **Orders** | `OrderID` | `CustomerID`, `EmployeeID`, `OrderDate`, `ShipperID` | [6] |
| **OrderDetails** | `OrderDetailID` | `OrderID`, `ProductID`, `Quantity` | [5] |

## 3. Carga de Dados via `LOAD DATA INFILE`

O comando `LOAD DATA INFILE` é utilizado para preencher todas as tabelas a partir de arquivos CSV [1, 3-11]. O comando exige o caminho completo para o arquivo CSV [13]. Nos scripts, o caminho padrão utilizado é, por exemplo, `C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/` [1, 3-11].

### Configurações de Importação

As seguintes cláusulas definem o formato de importação, que é consistente para todas as tabelas:

1.  **Delimitador de Campos:** Definido como **ponto e vírgula (`;`)** (`FIELDS TERMINATED BY ';'`) [1, 4, 5, 7-9, 11, 14, 15].
2.  **Delimitador de Texto:** Não há delimitador de texto (`ENCLOSED BY ''`) [1, 5, 7-9, 11, 14, 16].
3.  **Terminador de Linhas:** Utiliza o caractere de nova linha (`LINES TERMINATED BY '\n'`) [1, 5, 6, 8, 10, 11, 14, 16].
4.  **Ignorar Cabeçalho:** A primeira linha do arquivo CSV, que contém o cabeçalho, é ignorada (`IGNORE 1 ROWS`) para que não seja inserida como um registro de dados [1, 4, 6, 8, 10, 11, 14, 17].

### Transformações de Dados em Tempo de Carga (SET)

Algumas tabelas exigiram transformação de dados antes da inserção, utilizando variáveis intermediárias (precedidas por `@`) e a cláusula `SET` [4, 7, 8]:

| Tabela | Campo | Transformação | Função | Citações |
| :--- | :--- | :--- | :--- | :--- |
| **Employees** | `BirthDate` | `set BirthDate = str_to_date(@BirthDate,"%d/%m/%Y")` | Converte a data do formato Dia/Mês/Ano para o tipo `DATE` [4]. | [4] |
| **Orders** | `OrderDate` | `set OrderDate = str_to_date(@OrderDate,"%d/%m/%Y")` | Converte a data do formato Dia/Mês/Ano para o tipo `DATE` [7]. | [7] |
| **Products** | `Price` | `set Price = replace(@Price,",",".")` | Substitui a vírgula (separador decimal no CSV) por ponto, para adequar ao tipo `DECIMAL(10,2)` no MySQL [8]. | [8] |

## 4. Definição de Relacionamentos (Chaves Estrangeiras)

Após a carga dos dados, as chaves estrangeiras (`FOREIGN KEY`) são adicionadas usando o comando `ALTER TABLE` para estabelecer a integridade referencial [18-20]:

### 4.1. Chaves Estrangeiras da Tabela `Orders` [18]

| Nome da FK | Coluna de `Orders` | Referência |
| :--- | :--- | :--- |
| `fk_orders_customers` | `CustomerID` | `Customers`(`CustomerID`) |
| `fk_orders_employees` | `EmployeeID` | `Employees`(`EmployeeID`) |
| `fk_orders_shippers` | `ShipperID` | `Shippers`(`ShipperID`) |

### 4.2. Chaves Estrangeiras da Tabela `Products` [19]

| Nome da FK | Coluna de `Products` | Referência |
| :--- | :--- | :--- |
| `fk_products_suppliers` | `SupplierID` | `Suppliers`(`SupplierID`) |
| `fk_products_categories` | `CategoryID` | `Categories`(`CategoryID`) |

### 4.3. Chaves Estrangeiras da Tabela `OrderDetails` [20]

| Nome da FK | Coluna de `OrderDetails` | Referência |
| :--- | :--- | :--- |
| `fk_orderdetails_orders` | `OrderID` | `Orders`(`OrderID`) |
| `fk_orderdetails_products` | `ProductID` | `Products`(`ProductID`) |
