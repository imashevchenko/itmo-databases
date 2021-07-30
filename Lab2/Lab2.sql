/*1.*/	
SELECT Color, Count(*) FROM Production.Product
WHERE ListPrice>=30
GROUP BY COLOR

/*2.*/
SELECT Color FROM Production.Product
GROUP BY (Color)
HAVING MIN(ListPrice)>100
/*3.*/	
SELECT ProductSubcategoryID, COUNT(*) FROM Production.Product
GROUP BY ProductSubcategoryID
/*4.*/	
SELECT ProductID, COUNT(*) FROM Sales.SalesOrderDetail
GROUP BY ProductID
/*5.*/
SELECT ProductID, COUNT(*) FROM Sales.SalesOrderDetail
GROUP BY ProductID
HAVING COUNT(*)>5

/*6.*/
SELECT CustomerID FROM Sales.SalesOrderHeader
GROUP BY CustomerID, DATEPART(DAYOFYEAR,OrderDate)
HAVING COUNT(*)>1

/*7.*/
SELECT SalesOrderID FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
HAVING COUNT(*)>3
/*8.*/
SELECT ProductID FROM Sales.SalesOrderDetail
GROUP BY ProductID
HAVING COUNT(*)>3
/*9.*/
SELECT ProductID FROM Sales.SalesOrderDetail
GROUP BY ProductID
HAVING COUNT(*)=3 OR COUNT(*)=5
/*10.*/	
SELECT ProductSubcategoryID, COUNT(*) FROM Production.Product
GROUP BY ProductSubcategoryID
HAVING COUNT(*)>10

/*11.*/
SELECT ProductID FROM Sales.SalesOrderDetail
GROUP BY ProductID
HAVING MAX(OrderQty)=1
ORDER BY ProductID ASC
/*12.*/
SELECT TOP 1 SalesOrderID FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
ORDER BY COUNT(ProductID) DESC

/*13.*/
SELECT SalesOrderID FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
ORDER BY SUM(OrderQty*UnitPrice) DESC

/*14*/
SELECT ProductSubcategoryID FROM Production.Product
Where ProductSubcategoryID IS NOT NULL AND Color IS NOT NULL
GROUP BY ProductSubcategoryID
/*15.*/
SELECT Color, COUNT(*) FROM Production.Product
WHERE COLOR IS NOT NULL
GROUP BY Color
ORDER BY COUNT(*) DESC

/*16.*/
SELECT ProductID FROM Sales.SalesOrderDetail
GROUP BY ProductID
HAVING MAX(OrderQty)>1 AND COUNT(SalesOrderID)>2
ORDER BY ProductID ASC
