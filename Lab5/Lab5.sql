/*1.*/
WITH SALES_NUMBER(SalesOrderId, SalesByOrder)
AS
(
SELECT SalesOrderID, COUNT(*) FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
)

SELECT CustomerID, AVG(SalesByOrder) FROM Sales.SalesOrderHeader AS OH
JOIN SALES_NUMBER
ON SALES_NUMBER.SalesOrderId=OH.SalesOrderID
GROUP BY CustomerID

SELECT CustomerID, AVG(OD.C) FROM Sales.SalesOrderHeader AS OH
JOIN (SELECT SalesOrderID, COUNT(*) as C FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID) AS OD
ON OD.SalesOrderId=OH.SalesOrderID
GROUP BY CustomerID
/*2.*/
WITH TMP (CustomerID, AMOUNT) AS
(
SELECT CustomerID, COUNT(*) FROM Sales.SalesOrderDetail AS OD
JOIN Sales.SalesOrderHeader AS OH
ON OD.SalesOrderID=OH.SalesOrderID
GROUP BY CustomerID
)


SELECT CustomerID, ProductID, CAST(CAST (COUNT(*) AS FLOAT)/CAST((SELECT AMOUNT FROM TMP WHERE TMP.CustomerID=OH.CustomerID) AS FLOAT) AS DECIMAL(6,3)) AS ANSWER FROM Sales.SalesOrderDetail AS OD
JOIN Sales.SalesOrderHeader AS OH
ON OD.SalesOrderID=OH.SalesOrderID
GROUP BY CustomerID, ProductID

/*3.*/
WITH TMP (CustomerID, AMOUNT) AS
(
SELECT CustomerID, COUNT(*) FROM Sales.SalesOrderDetail AS OD
JOIN Sales.SalesOrderHeader AS OH
ON OD.SalesOrderID=OH.SalesOrderID
GROUP BY CustomerID
)


SELECT P.NAME, 
(SELECT COUNT(*) FROM Sales.SalesOrderDetail AS OD
JOIN Sales.SalesOrderHeader AS OH
ON OD.SalesOrderID=OH.SalesOrderID
WHERE OD.ProductID=(SELECT ProductID FROM Production.Product WHERE Name=P.Name)
GROUP BY ProductID), 
(SELECT COUNT(DISTINCT CustomerID) FROM Sales.SalesOrderDetail AS OD
JOIN Sales.SalesOrderHeader AS OH
ON OD.SalesOrderID=OH.SalesOrderID
WHERE OD.ProductID=(SELECT ProductID FROM Production.Product WHERE Name=P.Name)
GROUP BY ProductID) 
FROM Sales.SalesOrderDetail AS OD
JOIN Sales.SalesOrderHeader AS OH
ON OD.SalesOrderID=OH.SalesOrderID
JOIN Production.Product AS P
ON P.ProductID=OD.ProductID
GROUP BY P.Name


/*4.*/
WITH TMP1 (CustomerID, MAXPRICE) AS
(
SELECT OH.CustomerID, (SELECT TOP 1 SUM(Od1.UNITprice) from Sales.SalesOrderDetail AS OD1
JOIN Sales.SalesOrderHeader AS OH1
ON OH1.SalesOrderID=OD1.SalesOrderID
WHERE OH1.CustomerID=OH.CustomerID
GROUP BY OH1.SalesOrderID
ORDER BY SUM(Od1.UNITprice) DESC) 
FROM Sales.SalesOrderDetail AS OD
JOIN Sales.SalesOrderHeader AS OH
ON OH.SalesOrderID=OD.SalesOrderID
GROUP BY OH.CustomerID
),
TMP2 (CustomerID, MINPRICE) AS
(
SELECT OH.CustomerID, (SELECT TOP 1 SUM(Od1.UNITprice) from Sales.SalesOrderDetail AS OD1
JOIN Sales.SalesOrderHeader AS OH1
ON OH1.SalesOrderID=OD1.SalesOrderID
WHERE OH1.CustomerID=OH.CustomerID
GROUP BY OH1.SalesOrderID
ORDER BY SUM(Od1.UNITprice) ASC) 
FROM Sales.SalesOrderDetail AS OD
JOIN Sales.SalesOrderHeader AS OH
ON OH.SalesOrderID=OD.SalesOrderID
GROUP BY OH.CustomerID
)

SELECT TMP1.CustomerID,TMP1.MAXPRICE,TMP2.MINPRICE FROM TMP1
JOIN TMP2
ON TMP1.CustomerID=TMP2.CustomerID

/*5.*/
WITH TMP1 (CustomerID, SalesOrderID, _COUNTER) AS
(
SELECT OH1.CustomerID, OD1.SalesOrderID, COUNT(*) FROM Sales.SalesOrderDetail AS OD1
JOIN Sales.SalesOrderHeader AS OH1
ON OH1.SalesOrderID=OD1.SalesOrderID
GROUP BY OH1.CustomerID,OD1.SalesOrderID
)

SELECT TMP1.CustomerID FROM TMP1
GROUP BY CustomerID
HAVING COUNT(TMP1.SAlesOrderID)=COUNT(DISTINCT TMP1.SAlesOrderID)
/*6.*/
WITH TMP1 (CustomerID, SalesOrderID, ProductId) AS
(
SELECT OH1.CustomerID, OD1.SalesOrderID, OD1.ProductID FROM Sales.SalesOrderDetail AS OD1
JOIN Sales.SalesOrderHeader AS OH1
ON OH1.SalesOrderID=OD1.SalesOrderID
GROUP BY OH1.CustomerID,OD1.SalesOrderID,ProductID
)

SELECT P.CustomerID FROM TMP1 AS P
GROUP BY P.CustomerID
HAVING COUNT(DISTINCT p.ProductId)=(SELECT COUNT(Distinct D.ProductId) FROM  (SELECT ProductId FROM TMP1 WHERE CustomerID=P.CustomerID GROUP BY ProductId HAVING COUNT(DISTINCT SalesOrderID)>=2) AS D)
