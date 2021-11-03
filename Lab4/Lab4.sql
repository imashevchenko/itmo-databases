/*1.*/
SELECT Name
FROM Production.Product AS P
WHERE P.ProductID =
      (SELECT TOP 1 ProductID
       FROM Sales.SalesOrderDetail
       GROUP BY ProductID
       ORDER BY COUNT(*) DESC)
/*2.*/
SELECT TOP 1 CustomerID
FROM Sales.SalesOrderHeader AS SOH
         JOIN (SELECT SalesOrderID, SUM(OrderQty * UnitPrice) AS SUMMARY
               FROM Sales.SalesOrderDetail
               GROUP BY SalesOrderID) AS S
              ON S.SalesOrderID = SOH.SalesOrderID
GROUP BY CustomerID
ORDER BY SUM(SUMMARY) DESC
/*3.*/
SELECT Name
FROM Production.Product AS P
WHERE (P.ProductID = ANY
       (SELECT ProductID
        FROM Sales.SalesOrderDetail AS SOD
                 JOIN Sales.SalesOrderHeader AS SOH
                      ON SOD.SalesOrderID = SOH.SalesOrderID
        GROUP BY ProductID
        HAVING COUNT(DISTINCT CustomerID) = 1
       )
          )
/*4.*/
SELECT Name
FROM Production.Product AS P
WHERE (P.ListPrice >
       (SELECT AVG(ListPrice)
        FROM Production.Product AS P1
                 JOIN Production.ProductSubcategory AS PSC
                      ON P1.ProductSubcategoryID = PSC.ProductSubcategoryID
        GROUP BY P1.ProductSubcategoryID
        HAVING P.ProductSubcategoryID = P1.ProductSubcategoryID
       )
          )
/*5.*/
SELECT OD.ProductID
FROM Sales.SalesOrderDetail AS OD
         JOIN Sales.SalesOrderHeader OH
              ON OD.SalesOrderID = OH.SalesOrderID
WHERE OH.CustomerID IN
      (SELECT OH.CustomerID
       FROM Production.Product AS P
                JOIN Sales.SalesOrderDetail AS OD
                     ON P.ProductID = OD.ProductID
                JOIN Sales.SalesOrderHeader OH
                     ON OD.SalesOrderID = OH.SalesOrderID
       GROUP BY OH.CustomerID
       HAVING COUNT(distinct p.Color) = 1)
  AND OD.ProductID NOT IN
      (SELECT OD.ProductID
       FROM Sales.SalesOrderDetail AS OD
                JOIN Sales.SalesOrderHeader OH
                     ON OD.SalesOrderID = OH.SalesOrderID
       WHERE OH.CustomerID IN
             (SELECT OH.CustomerID
              FROM Production.Product AS P
                       JOIN Sales.SalesOrderDetail AS OD
                            ON P.ProductID = OD.ProductID
                       JOIN Sales.SalesOrderHeader OH
                            ON OD.SalesOrderID = OH.SalesOrderID
              GROUP BY OH.CustomerID
              HAVING COUNT(distinct p.Color) = 2))
GROUP BY OD.ProductID
HAVING COUNT(distinct OH.CustomerID) > 1

/*6.*/
SELECT DISTINCT OD.ProductID
FROM Sales.SalesOrderDetail AS OD
         JOIN Sales.SalesOrderHeader OH
              ON OD.SalesOrderID = OH.SalesOrderID
WHERE OH.CustomerID IN
      (SELECT OH.CustomerID
       FROM Production.Product AS P1
                JOIN Sales.SalesOrderDetail AS OD1
                     ON P1.ProductID = OD1.ProductID
                JOIN Sales.SalesOrderHeader OH1
                     ON OD1.SalesOrderID = OH1.SalesOrderID
       WHERE OD.ProductID = OD1.ProductID
       GROUP BY OH1.CustomerID
       HAVING COUNT(DISTINCT OD1.SalesOrderID) = (
           SELECT COUNT(DISTINCT OD2.SalesOrderID)
           FROM Production.Product AS P2
                    JOIN Sales.SalesOrderDetail AS OD2
                         ON P2.ProductID = OD2.ProductID
                    JOIN Sales.SalesOrderHeader OH2
                         ON OD2.SalesOrderID = OH2.SalesOrderID
           WHERE OH2.CustomerID = OH1.CustomerID
           GROUP BY OH2.CustomerID
       )
      )
/*7.*/
SELECT DISTINCT CustomerID
FROM Sales.SalesOrderHeader
WHERE CustomerID IN
      (
          SELECT SOH.CustomerID
          FROM Sales.SalesOrderDetail as SOD
                   JOIN Sales.SalesOrderHeader as SOH
                        ON SOD.SalesOrderID = SOH.SalesOrderID
          WHERE EXISTS
                    (
                        SELECT _SOD.ProductID
			FROM Sales.SalesOrderDetail AS _SOD
			JOIN Sales.SalesOrderHeader AS _SOH
			ON _ SOD.SalesOrderID = _ SOH.SalesOrderID
                        WHERE
                        SOH.CustomerID = _ SOH.CustomerID AND
                        SOD.ProductID = _ SOD.ProductID AND
                        SOD.SalesOrderID != _ SOD.SalesOrderID
                    )
      )
/*8.*/
SELECT OD.ProductID
FROM Sales.SalesOrderDetail AS OD
         JOIN Sales.SalesOrderHeader AS OH
              ON OD.SalesOrderID = OH.SalesOrderID
GROUP BY ProductID
HAVING COUNT(DISTINCT CustomerID) <= 3

/*9.*/
SELECT DISTINCT OD.ProductID
FROM Sales.SalesOrderDetail AS OD
         JOIN Sales.SalesOrderHeader AS OH
              ON OD.SalesOrderID = OH.SalesOrderID
WHERE EXISTS(
              SELECT OD1.ProductID
              FROM Sales.SalesOrderDetail AS OD1
                       JOIN Sales.SalesOrderHeader AS OH1
                            ON OD1.SalesOrderID = OH1.SalesOrderID
                       JOIN Production.Product AS P1
                            ON P1.ProductID = OD1.ProductID
                       JOIN Production.ProductSubcategory AS PSC0
                            ON P1.ProductSubcategoryID = PSC0.ProductSubcategoryID
              WHERE OD1.ProductID = (
                  SELECT TOP 1 P2.ProductID
                  FROM Production.ProductCategory AS PC
                           JOIN Production.ProductSubcategory AS PSC
                                ON PSC.ProductCategoryID = PC.ProductCategoryID
                           JOIN Production.Product AS P2
                                ON P2.ProductSubcategoryID = PSC.ProductSubcategoryID
                  WHERE PSC.ProductSubcategoryID = P1.ProductSubcategoryID
                  ORDER BY ListPrice
              )
          )
GROUP BY OD.ProductID
HAVING COUNT(OH.SalesOrderID) = (
    SELECT COUNT(OH3.SalesOrderId)
    FROM Sales.SalesOrderHeader AS OH3
             JOIN Sales.SalesOrderDetail AS OD3
                  ON OH3.SalesOrderID = OD3.SalesOrderID
    WHERE OD3.ProductID = OD.ProductID
    GROUP BY OD3.ProductID
)

/*10.*/
SELECT OH.CUSTOMERID
FROM Sales.SalesOrderDetail AS OD
         JOIN Sales.SalesOrderHeader AS OH
              ON OH.SalesOrderID = OD.SalesOrderID
WHERE OD.SalesOrderID = ANY (
    SELECT OH.SalesOrderID
    FROM Sales.SalesOrderDetail AS OD
             JOIN Sales.SalesOrderHeader AS OH
                  ON OH.SalesOrderID = OD.SalesOrderID
    WHERE OD.ProductID = ANY (
        SELECT ProductID
        FROM Sales.SalesOrderDetail AS OD2
                 JOIN Sales.SalesOrderHeader AS OH2
                      ON OH2.SalesOrderID = OD2.SalesOrderID
        GROUP BY ProductID
        HAVING COUNT(DISTINCT CustomerId) >= 4
    )
    Group BY OH.SalesOrderID
    HAVING COUNt(DISTINCT ProductID) >= 3
)
GROUP BY CustomerID
HAVING COUNT(OD.SalesOrderID) >= 2

/*12.*/
SELECT OD.ProductID
FROM Sales.SalesOrderDetail AS OD
         JOIN Sales.SalesOrderHeader AS OH
              ON OH.SalesOrderID = OD.SalesOrderID
GROUP BY ProductID
HAVING COUNT(DISTINCT CustomerID) >= 3

/*13.*/
SELECT PSC.Name
FROM Sales.SalesOrderDetail AS OD
         JOIN Sales.SalesOrderHeader AS OH
              ON OH.SalesOrderID = OD.SalesOrderID
         JOIN Production.Product as P
              ON P.ProductID = OD.ProductID
         JOIN Production.ProductSubcategory AS PSC
              ON PSC.ProductSubcategoryID = P.ProductSubcategoryID
WHERE P.ProductID IN
      (
          SELECT ProductID
          FROM Sales.SalesOrderDetail AS OD
                   JOIN Sales.SalesOrderHeader AS OH
                        ON OH.SalesOrderID = OD.SalesOrderID
          Group BY ProductID
          HAVING COUNT(OH.SalesOrderID) > 3
      )
GROUP BY PSC.Name
HAVING COUNT(DISTINCT P.ProductID) >= 3

/*14.*/
SELECT DISTINCT OD.ProductID
FROM Sales.SalesOrderDetail AS OD
         JOIN Sales.SalesOrderHeader AS OH
              ON OH.SalesOrderID = OD.SalesOrderID
WHERE OD.ProductID IN
      (
          SELECT ProductID
          FROM Sales.SalesOrderDetail AS OD
                   JOIN Sales.SalesOrderHeader AS OH
                        ON OH.SalesOrderID = OD.SalesOrderID
          Group BY ProductID
          HAVING COUNT(OH.SalesOrderID) < 3
      )
   OR OD.ProductID IN
      (
          SELECT ProductID
          FROM Sales.SalesOrderDetail AS OD
                   JOIN Sales.SalesOrderHeader AS OH
                        ON OH.SalesOrderID = OD.SalesOrderID
          Group BY ProductID
          HAVING COUNT(OH.CustomerID) - COUNT(DISTINCT OH.CUSTOMERID) > 2
      )
