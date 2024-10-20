/* Evaluando la BBDD (Base de Datos) y sus relaciones entres tabla se evince que podemos sacar varios tipos de estadisticas, auqnue esto puede ser ampliable dependiendo de lo que uno quiere examinar y desde que prospectivas uno quiere ver esos datos.
Siendo la empresa una comercializadora/tienda lo que surge como preguntas son:
- Hay clientes fidelizado?
- Articulos más vendidos
- Cantidad de orden para examinar la temporabilidad (en vision general)
- Provincia o Region de mas envio
- Venta media mensual

Obviamente estas preguntas se pueden ampliar y ir analizando detalles como los articulos se mueven mas durante el año, o que color se vende mas, etc.
Para dar una vision general de una tienda creo que las primeras preguntas puedan dar ya un buen comienzo para una sucesivas analisis de negocio. */

/* Hay clientes fidelizado? */

SELECT C.CustomerID, C.LastName, COUNT (SoH.SalesOrderID) AS NumerosPedidos
FROM SalesLT.Customer C
INNER JOIN SalesLT.SalesOrderHeader SoH ON
    C.CustomerID = SoH.CustomerID
GROUP BY C.CustomerID, C.LastName
HAVING COUNT(SoH.SalesOrderID) > 1;

/* Con esta consulta valoramos si hay clientes que tengan más de un pedido, junto con la cantidad de pedidos realizados. El resultado que vamos sacando es negativo. */


/* Articulos más vendido (5), relacionandolo con la cantidad de pedidos */

SELECT TOP 5 P.ProductID, P.Name, COUNT(DISTINCT SoD.SalesOrderID) AS NumerosPedidos, SUM(Sod.OrderQty) AS Qtas
FROM SalesLT.Product P
JOIN SalesLT.SalesOrderDetail SoD ON
    P.ProductID = SoD.ProductID
GROUP BY P.ProductID, P.Name
ORDER BY NumerosPedidos DESC, Qtas DESC;

/* Para hacer una comprobacion se analizan solo los cinco articulos mas vendidos sin relacionarlos con la cantidfades de pedidos */
SELECT TOP 5 P.ProductID, P.Name, COUNT (SoD.SalesOrderID) AS Qtas FROM
SalesLT.Product P
JOIN SalesLT.SalesOrderDetail SoD ON
    P.ProductID = SoD.ProductID
GROUP BY P.ProductID, P.Name
ORDER BY Qtas DESC;


/* Cantidad de ordenan para examinar la temporabilidad */
/* Analizando la BBDD se ha detectado que solo se pone un mes de ejemplo, así que esta consulta resulta sin utilidad practica  */

SELECT FORMAT (SoH.OrderDate, 'MMMM') AS Mes, COUNT (SoH.PurchaseOrderNumber) AS Totales_Pedidos
FROM SalesLT.SalesOrderHeader SoH
GROUP BY FORMAT (SoH.OrderDate, 'MMMM'),
YEAR (SoH.OrderDate);


/* Provincia y Region de mas comrpas de los pedidos */
SELECT A.StateProvince, A.CountryRegion, COUNT(SoH.PurchaseOrderNumber) AS Totales_Pedidos FROM SalesLT.SalesOrderHeader SoH
JOIN SalesLT.Address A ON
    SoH.BillToAddressID = A.AddressID
GROUP BY A.StateProvince, A.CountryRegion
ORDER BY Totales_Pedidos DESC
OFFSET 0 ROWS
FETCH NEXT 5 ROWS ONLY;


/* Ventas mensuales y comprobacion con año anterior */

 SELECT
        YEAR (SoH.OrderDate) AS año,
        MONTH (SoH.OrderDate) AS mes,
        SUM (SoH.SubTotal) AS Total_Sub,
        COUNT (SoH.PurchaseOrderNumber) AS Total_Pedido
    FROM SalesLT.SalesOrderHeader SoH
    WHERE YEAR (SoH.OrderDate) IN (YEAR('2008-01-01'), YEAR('2008-01-01') - 1)
    GROUP BY YEAR (SoH.OrderDate), MONTH (SoH.OrderDate);

/* Si la base de dato tuviera mas informacion se pudiera poner en este modo para tener comparacion */

WITH VentasPorMes AS (
    SELECT
        YEAR (SoH.OrderDate) AS año,
        MONTH (SoH.OrderDate) AS mes,
        SUM (SoH.SubTotal) AS Total_Sub,
        COUNT (SoH.PurchaseOrderNumber) AS Total_Pedido
    FROM SalesLT.SalesOrderHeader SoH
    WHERE YEAR (SoH.OrderDate) IN (YEAR(GETDATE()), YEAR(GETDATE()) - 1)
    GROUP BY YEAR (SoH.OrderDate), MONTH (SoH.OrderDate)
)
SELECT
    v.mes,
    ISNULL (v.año, YEAR (GETDATE()) - 1) AS año,
    ISNULL (Total_Sub, 0) AS Total_Sub,
    ISNULL (Total_Pedido, 0) AS Total_Pedido,
    ISNULL (Total_Sub, 0) / NULLIF (Total_Pedido, 0) AS Media_Ventas
FROM
    ( SELECT 1 AS mes UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 
     UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 
     UNION SELECT 11 UNION SELECT 12) AS meses
LEFT JOIN
    VentasPorMes v ON meses.mes = v.mes
ORDER BY
    v.año DESC, v.mes;