# Examinar BBDD y hacerse preguntas.

Se ha creado, en entorno Azure, una base de datos importando un fichero de SQL de ejemplo. La conexión a la BBDD se realiza a traves de Azure Data Studio, donde vamos, en un primer momento, analizando la estructura de la misma y su relaciones entres tablas.
La BBDD consta de 12 tablas, de la cual 10 son relativa al negocio principal (en este caso a una tienda de bicicletas) y otra dos tablas relativa a un logs de errores y version de la misma BBDD.

En esta primera investigación no tenemos una petición especifica, así que haremos una analisis explicativa relativa a la información que hemos podido recuperar de la BBDD.
Nos centraremos principalmente en analizar si tenemos clientes fidelizado, los artículos mas vendidos, la cantidades de ordenes, Provincia/Estado de mas ventas, y valorar la ventas medias por pedido.

Las tablas son relacionadas entre si a traves de ID específicos, en el caso de los pedidos se relaciona la mayoría de información con "SalesOrderID" para relación lo que es la cabecera del pedido con lo que seria las lineas del pedido (su composición). Desde esta misma tabla de cabecera se relaciona tambien el cliente con la dirección (en este caso la tabla de dirección esta separada de la tabla de cliente, ya que una dirección puede ser de facturación y/p de envio).

Los producto, aunque en mi primera investigación no se ha analizado, viene catalogado por Familias, ese punto tambien pudiera ser interessante examinar para ver cual son la categoria que mas se venden.

Se añade esquema grafico de la relaciones de tablas en un archivo externo: chart.svg

![](https://github.com/Xicu980/SQL_01/blob/main/chart.svg)

Tambien se añade la estructuras de la tablas en formato textual (tablas, columnas, tipologia, etc.): chart.md

En el archivo SQL_Tienda_Preguntas.sql se incluye las varias preguntas y código de consulta SQL, ademas de una pequena presentación.
 
