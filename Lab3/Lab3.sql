/*1.*/
SELECT P.NAME, PC.Name
FROM Production.Product AS P
         JOIN Production.ProductSubcategory as PSC
              ON PSC.ProductCategoryID = P.ProductSubcategoryID
         JOIN Production.ProductCategory AS PC
              ON PC.ProductCategoryID = PSC.ProductCategoryID
WHERE P.Color = 'Red'
  AND P.ListPrice >= 100
/*2.*/
SELECT P.NAME, P1.Name
FROM Production.ProductSubcategory AS P
         JOIN Production.ProductSubcategory as P1
              ON P1.Name = P.Name AND P1.ProductSubcategoryID!=P.ProductSubcategoryID
/*3.*/
SELECT PC.NAME, COUNT(*)
FROM Production.Product AS P
         JOIN Production.ProductSubcategory as PSC
              ON PSC.ProductSubcategoryID = P.ProductSubcategoryID
         JOIN Production.ProductCategory AS PC
              ON PSC.ProductCategoryID = PC.ProductCategoryID
GROUP BY PC.Name
/*4.*/
SELECT PSC.ProductSubcategoryID, PSC.NAME, COUNT(*)
FROM Production.Product AS P
         JOIN Production.ProductSubcategory as PSC
              ON PSC.ProductSubcategoryID = P.ProductSubcategoryID
GROUP BY PSC.ProductSubcategoryID, PSC.Name
/*5.*/
SELECT TOP 3 PSC.NAME, COUNT(*) AS AMOUNT
FROM Production.Product AS P
         JOIN Production.ProductSubcategory as PSC
              ON PSC.ProductSubcategoryID = P.ProductSubcategoryID
GROUP BY PSC.Name
ORDER BY AMOUNT DESC
/*6.*/
SELECT PSC.NAME, MAX(ListPrice) AS AMOUNT
FROM Production.Product AS P
         JOIN Production.ProductSubcategory as PSC
              ON PSC.ProductSubcategoryID = P.ProductSubcategoryID
WHERE P.Color = 'Red'
GROUP BY PSC.Name
/*7.*/
SELECT V.Name, COUNT(ProductID)
FROM Purchasing.ProductVendor as PV
         JOIN Purchasing.Vendor as V
              ON PV.BusinessEntityID = V.BusinessEntityID
GROUP BY V.Name
/*8.*/
SELECT P.Name
FROM Production.Product as P
         JOIN Purchasing.ProductVendor as PV
              ON PV.ProductID = P.ProductID
GROUP BY P.Name
HAVING COUNT(PV.BusinessEntityID) > 1
/*9.*/
SELECT TOP 1 P.Name, COUNT(*)
FROM Purchasing.PurchaseOrderDetail as POD
         JOIN Production.Product as P
              ON P.ProductID = POD.ProductID
GROUP BY P.Name
ORDER BY COUNT(*) DESC
/*10.*/
SELECT TOP 1 PC.Name, COUNT(*)
FROM Purchasing.PurchaseOrderDetail as POD
         JOIN Production.Product as P
              ON P.ProductID = POD.ProductID
         JOIN Production.ProductSubcategory as PSC
              ON P.ProductSubcategoryID = PSC.ProductSubcategoryID
         JOIN Production.ProductCategory as PC
              ON PC.ProductCategoryID = PSC.ProductCategoryID
GROUP BY PC.Name
ORDER BY COUNT(*) DESC
/*11.*/
SELECT PC.Name, COUNT(DISTINCT PSC.ProductSubcategoryID), COUNT(P.ProductID)
FROM Production.Product as P
         JOIN Production.ProductSubcategory as PSC
              ON P.ProductSubcategoryID = PSC.ProductSubcategoryID
         JOIN Production.ProductCategory as PC
              ON PC.ProductCategoryID = PSC.ProductCategoryID
GROUP BY PC.Name

/*12.*/
SELECT V.CreditRating, COUNT(DISTINCT PV.ProductID)
FROM Purchasing.Vendor as V
         JOIN Purchasing.ProductVendor as PV
              ON V.BusinessEntityID = PV.BusinessEntityID
GROUP BY V.CreditRating

