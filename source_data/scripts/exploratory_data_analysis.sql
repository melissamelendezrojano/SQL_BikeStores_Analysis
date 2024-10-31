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
    ROUND(SUM(quantity * list_price * (1 - discount)), 2) AS total_sales,
    ROW_NUMBER() OVER(ORDER BY ROUND(SUM(quantity * list_price * (1 - discount)), 2) DESC) AS sales_rank
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
    ROUND(SUM(quantity * list_price * (1 - discount)), 2) AS total_sales,
    ROW_NUMBER() OVER(PARTITION BY EXTRACT(YEAR FROM order_date)
						ORDER BY ROUND(SUM(quantity * list_price * (1 - discount)), 2) DESC) AS sales_rank
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
	
-- ***************************************************************

SELECT
    store_name,
    ROUND(AVG(amount), 2) AS AVG_purchase_ticket
FROM (
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
	WHERE order_status = 4
) AS AmountProduct
GROUP BY store_name
ORDER BY AVG_purchase_ticket DESC;



-- •	Which stores show the highest month-over-month sales growth? 

WITH AmountMonthStoreYear AS (
	SELECT
		orders.store_id,
		EXTRACT(YEAR FROM order_date) AS year,
		EXTRACT(MONTH FROM order_date) AS month,
		SUM((order_items.quantity * order_items.list_price * (1 - order_items.discount))) AS sum_amount_month
	FROM
		orders
	LEFT JOIN order_items
		ON orders.order_id = order_items.order_id
	WHERE order_status = 4
	GROUP BY year, month, store_id)
SELECT
	store_id,
    year,
    month,
    sum_amount_month,
    LAG(sum_amount_month, 1) OVER 
		(PARTITION BY store_id
         ORDER BY year, month ) AS last_amount_month,
	ROUND(((sum_amount_month - LAG(sum_amount_month, 1) OVER (PARTITION BY store_id ORDER BY year, month))/LAG(sum_amount_month, 1) OVER (PARTITION BY store_id ORDER BY year, month)), 2) AS MoM
FROM
	AmountMonthStoreYear;

/*
|store_id|year|month|sum_amount_month|last_amount_month|MoM  |
|--------|----|-----|----------------|-----------------|-----|
|1       |2016|1    |71760.3064      |                 |     |
|1       |2016|2    |35255.4513      |71760.3064       |-0.51|
|1       |2016|3    |46817.6251      |35255.4513       |0.33 |
|1       |2016|4    |31980.6586      |46817.6251       |-0.32|
|1       |2016|5    |28095.2399      |31980.6586       |-0.12|
|1       |2016|6    |36456.0239      |28095.2399       |0.30 |
|1       |2016|7    |21258.8857      |36456.0239       |-0.42|
|1       |2016|8    |41462.6539      |21258.8857       |0.95 |
|1       |2016|9    |65159.6319      |41462.6539       |0.57 |
|1       |2016|10   |69175.4980      |65159.6319       |0.06 |
|1       |2016|11   |55771.3843      |69175.4980       |-0.19|
|1       |2016|12   |41465.7848      |55771.3843       |-0.26|
|1       |2017|1    |52937.6554      |41465.7848       |0.28 |
|1       |2017|2    |45378.2664      |52937.6554       |-0.14|
|1       |2017|3    |55460.9753      |45378.2664       |0.22 |
|1       |2017|4    |20607.5748      |55460.9753       |-0.63|
|1       |2017|5    |52097.6926      |20607.5748       |1.53 |
|1       |2017|6    |56720.9109      |52097.6926       |0.09 |
|1       |2017|7    |57073.9615      |56720.9109       |0.01 |
|1       |2017|8    |39812.9909      |57073.9615       |-0.30|
|1       |2017|9    |36178.5697      |39812.9909       |-0.09|
|1       |2017|10   |32258.8614      |36178.5697       |-0.11|
|1       |2017|11   |54307.8571      |32258.8614       |0.68 |
|1       |2017|12   |41361.6818      |54307.8571       |-0.24|
|1       |2018|1    |73982.1779      |41361.6818       |0.79 |
|1       |2018|2    |39637.6433      |73982.1779       |-0.46|
|1       |2018|3    |53015.6861      |39637.6433       |0.34 |
|2       |2016|1    |132894.2968     |                 |     |
|2       |2016|2    |97425.1139      |132894.2968      |-0.27|
|2       |2016|3    |110338.7916     |97425.1139       |0.13 |
|2       |2016|4    |120491.9842     |110338.7916      |0.09 |
|2       |2016|5    |149993.2523     |120491.9842      |0.24 |
|2       |2016|6    |139021.3866     |149993.2523      |-0.07|
|2       |2016|7    |167320.8731     |139021.3866      |0.20 |
|2       |2016|8    |142994.2888     |167320.8731      |-0.15|
|2       |2016|9    |164368.6516     |142994.2888      |0.15 |
|2       |2016|10   |129251.7324     |164368.6516      |-0.21|
|2       |2016|11   |95705.8019      |129251.7324      |-0.26|
|2       |2016|12   |135329.5141     |95705.8019       |0.41 |
|2       |2017|1    |217406.6490     |135329.5141      |0.61 |
|2       |2017|2    |184014.7518     |217406.6490      |-0.15|
|2       |2017|3    |219582.6878     |184014.7518      |0.19 |
|2       |2017|4    |161639.9347     |219582.6878      |-0.26|
|2       |2017|5    |201407.9959     |161639.9347      |0.25 |
|2       |2017|6    |250491.8029     |201407.9959      |0.24 |
|2       |2017|7    |155027.5852     |250491.8029      |-0.38|
|2       |2017|8    |190536.1944     |155027.5852      |0.23 |
|2       |2017|9    |203956.7509     |190536.1944      |0.07 |
|2       |2017|10   |256674.0375     |203956.7509      |0.26 |
|2       |2017|11   |196386.3156     |256674.0375      |-0.23|
|2       |2017|12   |196824.5810     |196386.3156      |0.00 |
|2       |2018|1    |262508.3779     |196824.5810      |0.33 |
|2       |2018|2    |136659.3029     |262508.3779      |-0.48|
|2       |2018|3    |282956.9115     |136659.3029      |1.07 |
|3       |2016|1    |10491.8209      |                 |     |
|3       |2016|2    |15825.7929      |10491.8209       |0.51 |
|3       |2016|3    |23443.9118      |15825.7929       |0.48 |
|3       |2016|4    |11926.4359      |23443.9118       |-0.49|
|3       |2016|5    |19090.6025      |11926.4359       |0.60 |
|3       |2016|6    |29986.5696      |19090.6025       |0.57 |
|3       |2016|7    |10977.0501      |29986.5696       |-0.63|
|3       |2016|8    |28370.1689      |10977.0501       |1.58 |
|3       |2016|9    |41828.3937      |28370.1689       |0.47 |
|3       |2016|10   |13650.8501      |41828.3937       |-0.67|
|3       |2016|11   |24573.3818      |13650.8501       |0.80 |
|3       |2016|12   |12889.3869      |24573.3818       |-0.48|
|3       |2017|1    |15272.1796      |12889.3869       |0.18 |
|3       |2017|2    |52575.2867      |15272.1796       |2.44 |
|3       |2017|3    |33113.7572      |52575.2867       |-0.37|
|3       |2017|4    |38161.6481      |33113.7572       |0.15 |
|3       |2017|5    |9539.0677       |38161.6481       |-0.75|
|3       |2017|6    |68364.8169      |9539.0677        |6.17 |
|3       |2017|7    |1618.1535       |68364.8169       |-0.98|
|3       |2017|8    |42987.4042      |1618.1535        |25.57|
|3       |2017|9    |53269.9355      |42987.4042       |0.24 |
|3       |2017|10   |14489.4377      |53269.9355       |-0.73|
|3       |2017|11   |18114.9554      |14489.4377       |0.25 |
|3       |2017|12   |21319.7221      |18114.9554       |0.18 |
|3       |2018|1    |44939.5435      |21319.7221       |1.11 |
|3       |2018|2    |21075.3598      |44939.5435       |-0.53|
|3       |2018|3    |28018.3959      |21075.3598       |0.33 |
*/


-- •	What percentage of total sales comes from each store?
