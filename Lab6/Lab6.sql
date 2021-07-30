/*1.*/
SELECT SalesOrderId, ProductId, SUM(OrderQty*UnitPrice) OVER (PARTITION BY SalesOrderId, PRODUCTID)
FROM Sales.SalesOrderDetail
ORDER BY SalesOrderID
/*2.*/
SELECT ProductID, ListPrice,  ListPrice- MIN(ListPrice) OVER (PARTITION BY ProductSubcategoryID)
FROM Production.Product	
/*3.*/
SELECT CustomerID, SalesOrderID, ROW_NUMBER() OVER (PARTITION BY CUSTOMERID ORDER BY OrderDate)
FROM Sales.SalesOrderHeader
/*4.*/
	WITH ProductsAndAvg (ProductID, StandardCost, ProductSubcategoryID, AvgCostSubcategory) AS
	(
		SELECT ProductID, StandardCost, ProductSubcategoryID, (AVG(StandardCost) OVER(PARTITION BY ProductSubcategoryID)) 
		FROM Production.Product
	)
SELECT ProductID 
FROM ProductsAndAvg
WHERE StandardCost > AvgCostSubcategory AND ProductSubcategoryID IS NOT NULL
/*4.*/
SELECT ProductID 
FROM (SELECT ProductID, StandardCost, ProductSubcategoryID, AVG(StandardCost) OVER(PARTITION BY ProductSubcategoryID) AS Avg FROM Production.Product) AS P
WHERE StandardCost > P.Avg AND ProductSubcategoryID IS NOT NULL
/*5.*/
SELECT OD.ProductID, P.Name, AVG(OrderQty) OVER (PARTITION BY OD.SalesOrderID, OD.productID  ORDER BY OrderDate DESC
ROWS BETWEEN UNBOUNDED PRECEDING AND 2 FOLLOWING)
FROM Production.Product AS P
JOIN Sales.SalesOrderDetail AS OD
ON P.ProductID=OD.ProductID
JOIN Sales.SalesOrderHeader AS OH
ON OH.SalesOrderID=OD.SalesOrderID
