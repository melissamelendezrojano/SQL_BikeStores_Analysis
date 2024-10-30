/*
	Data Analyst Bike Stores
    SQL Author: Melissa Meléndez
    LinkedIn: https://www.linkedin.com/in/melissamelendezrojano/
    
    Dataset Creator: SQLServerTutorial.Net (https://www.sqlservertutorial.net/getting-started/sql-server-sample-database/)
    Original Dataset Location: https://www.sqlservertutorial.net/getting-started/load-sample-database/
    Dataset .csv Location: https://www.kaggle.com/datasets/dillonmyrick/bike-store-sample-database
        
    File name: exploratory_data_analysis.sql
    Description: The aim of this project is to get to know this fictitious company. I approach these company and its data as if I were a new entry-level worker who has just started and wants to learn everything
    about this company. Fist of all, I begin by conducting a basic exploratory data analysis of this company.

*/


-- Exploratory Data Analysis

-- Sales and Store Performance Analysis
-- •	Which stores have the highest total sales?

-- TOTAL SALES PER STORE
SELECT
	orders.store_id,
    stores.store_name,
    ROUND(SUM(quantity * list_price * (1 - discount)), 2) AS total_sales
FROM
	order_items
LEFT JOIN orders
	ON order_items.order_id = orders.order_id
LEFT JOIN stores
	ON orders.store_id = stores.store_id
WHERE orders.order_status = 4
GROUP BY
	orders.store_id, stores.store_name
ORDER BY total_sales DESC;

/*
|store_id|store_name      |total_sales|
|--------|----------------|-----------|
|2       |Baldwin Bikes   |4701209.57 |
|1       |Santa Cruz Bikes|1255491.65 |
|3       |Rowlett Bikes   |705914.03  |
*/

-- *******************************************************	

-- TOTAL SALES PER STORE AND YEAR
SELECT
	EXTRACT(YEAR FROM order_date) AS year,
    orders.store_id,
    stores.store_name,
    ROUND(SUM(quantity * list_price * (1 - discount)), 2) AS total_sales
FROM
	order_items
LEFT JOIN orders
	ON order_items.order_id = orders.order_id
LEFT JOIN stores
	ON orders.store_id = stores.store_id
WHERE orders.order_status = 4
GROUP BY
	orders.store_id, stores.store_name, year
ORDER BY year, total_sales DESC;

/*
|year|store_id|store_name      |total_sales|
|----|--------|----------------|-----------|
|2016|2       |Baldwin Bikes   |1585135.69 |
|2016|1       |Santa Cruz Bikes|544659.14  |
|2016|3       |Rowlett Bikes   |243054.37  |
|2017|2       |Baldwin Bikes   |2433949.29 |
|2017|1       |Santa Cruz Bikes|544197.00  |
|2017|3       |Rowlett Bikes   |368826.36  |
|2018|2       |Baldwin Bikes   |682124.59  |
|2018|1       |Santa Cruz Bikes|166635.51  |
|2018|3       |Rowlett Bikes   |94033.30   |
*/


-- •	What is the best-selling product in each store?

WITH RankQuantityPerStore AS (
	SELECT
    EXTRACT(YEAR FROM orders.order_date) AS year,
	products.product_name,
    category_name,
    stores.store_name,
    order_items.quantity,
    orders.order_status,
    ROW_NUMBER() OVER(PARTITION BY stores.store_name
						ORDER BY order_items.quantity DESC) AS quantity_rank
	FROM
		stores
	LEFT JOIN orders
		ON stores.store_id = orders.store_id
	LEFT JOIN order_items
		ON orders.order_id = order_items.order_id
	LEFT JOIN products
		ON order_items.product_id = products.product_id
	LEFT JOIN categories
		ON products.category_id = categories.category_id
	WHERE orders.order_status = 4
	ORDER BY order_items.quantity
)
SELECT
	year,
    store_name,
    product_name,
    category_name,
    quantity
FROM RankQuantityPerStore
WHERE quantity_rank = 1;

/*
|year|store_name      |product_name                                 |category_name      |quantity|
|----|----------------|---------------------------------------------|-------------------|--------|
|2016|Baldwin Bikes   |Electra Girl's Hawaii 1 (20-inch) - 2015/2016|Children Bicycles  |2       |
|2016|Rowlett Bikes   |Surly Straggler 650b - 2016                  |Cyclocross Bicycles|2       |
|2017|Santa Cruz Bikes|Electra Amsterdam Fashion 7i Ladies' - 2017  |Cruisers Bicycles  |2       |
*/

-- ***********************************************************************************

WITH RankQuantityPerStore AS (
	SELECT
	EXTRACT(YEAR FROM orders.order_date) AS year,
    products.product_name,
	category_name,
    stores.store_name,
    order_items.quantity,
    ROW_NUMBER() OVER(PARTITION BY EXTRACT(YEAR FROM orders.order_date), stores.store_name
						ORDER BY order_items.quantity DESC) AS quantity_row_number
	FROM
		stores
	LEFT JOIN orders
		ON stores.store_id = orders.store_id
	LEFT JOIN order_items
		ON orders.order_id = order_items.order_id
	LEFT JOIN products
		ON order_items.product_id = products.product_id
	LEFT JOIN categories
		ON products.category_id = categories.category_id
	WHERE orders.order_status = 4)
SELECT
	year,
    store_name,
    product_name,
    category_name,
    quantity
FROM
	RankQuantityPerStore
WHERE quantity_row_number = 1;

/*
|year|store_name      |product_name                        |category_name      |quantity|
|----|----------------|------------------------------------|-------------------|--------|
|2016|Baldwin Bikes   |Trek Fuel EX 8 29 - 2016            |Mountain Bikes     |2       |
|2016|Rowlett Bikes   |Electra Townie Original 7D EQ - 2016|Comfort Bicycles   |2       |
|2016|Santa Cruz Bikes|Surly Straggler 650b - 2016         |Cyclocross Bicycles|2       |
|2017|Baldwin Bikes   |Trek Conduit+ - 2016                |Electric Bikes     |2       |
|2017|Rowlett Bikes   |Surly Steamroller - 2017            |Road Bikes         |2       |
|2017|Santa Cruz Bikes|Trek Powerfly 8 FS Plus - 2017      |Electric Bikes     |2       |
|2018|Baldwin Bikes   |Trek Powerfly 8 FS Plus - 2017      |Electric Bikes     |2       |
|2018|Rowlett Bikes   |Trek Super Commuter+ 8S - 2018      |Electric Bikes     |2       |
|2018|Santa Cruz Bikes|Sun Bicycles Lil Kitt'n - 2017      |Children Bicycles  |2       |
*/



-- •	Which stores have the highest average purchase ticket?

WITH AmountProduct AS (
	SELECT
		orders.order_id,
		orders.order_status,
		order_items.item_id,
		order_items.product_id,
		stores.store_name,
		(quantity * list_price * (1 - discount)) AS amount  
	FROM
		orders
	LEFT JOIN order_items
		ON orders.order_id = order_items.order_id
	LEFT JOIN stores
		ON orders.store_id = stores.store_id
	WHERE order_status = 4)
SELECT
    store_name,
    ROUND(AVG(amount), 2) AS AVG_purchase_ticket
FROM
	AmountProduct
GROUP BY store_name
ORDER BY AVG_purchase_ticket DESC;

/*
|store_name      |AVG_purchase_ticket|
|----------------|-------------------|
|Rowlett Bikes   |1637.85            |
|Baldwin Bikes   |1585.57            |
|Santa Cruz Bikes|1534.83            |
*/
	


-- •	Which stores show the highest month-over-month sales growth?
-- •	What percentage of total sales comes from each store?
