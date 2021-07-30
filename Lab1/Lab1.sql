/*1*/
SELECT Name,Color,Size FROM Production.Product
/*2*/
SELECT Name,Color,Size FROM Production.Product WHERE ListPrice>100
/*3*/
SELECT Name,Color,Size FROM Production.Product WHERE ListPrice<100 AND Color = 'Black'
/*4*/
SELECT Name,Color,Size FROM Production.Product WHERE ListPrice<100 AND Color = 'Black' ORDER BY ListPrice
/*5*/
SELECT TOP 3 Name,Size FROM Production.Product WHERE Color='Black' ORDER BY ListPrice DESC
/*5*/
SELECT Name,Color FROM Production.Product WHERE Color IS NOT NULL AND SIZE IS NOT NULL
/*6*/
SELECT DISTINCT Color FROM Production.Product WHERE ListPrice BETWEEN 10 AND 50
/*7*/
SELECT Color FROM Production.Product WHERE Name LIKE 'L_N%'
/*8*/
SELECT Name FROM Production.Product WHERE Name LIKE '[DM]%' AND LEN(Name)>3
/*9*/
SELECT Name FROM Production.Product WHERE YEAR(SellStartDate)>=2012
/*10*/
SELECT Name FROM Production.ProductSubcategory
/*11*/
SELECT Name FROM Production.ProductCategory	SELECT FirstName FROM Person.Person WHERE Title='Mr.'
/*12*/
SELECT FirstName FROM Person.Person WHERE Title IS NULL