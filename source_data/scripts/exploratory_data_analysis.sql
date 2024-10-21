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

-- 1. Information about stores
-- How many stores does the company have and where are they located?

SELECT
	COUNT(*) AS num_stores
FROM
	stores;

/*
|num_stores|
|----------|
|3         |

*/

SELECT 
	store_name,
    street,
    city,
    state
FROM
	stores;

-- Results:
/*
|store_name      |street             |city      |state|
|----------------|-------------------|----------|-----|
|Santa Cruz Bikes|3700 Portola Drive |Santa Cruz|CA   |
|Baldwin Bikes   |4200 Chestnut Lane |Baldwin   |NY   |
|Rowlett Bikes   |8000 Fairway Avenue|Rowlett   |TX   |
*/

-- 2. Information about products, categories and brands
-- How many product categories are there? and, what product categories are there?

SELECT 
	count(*) AS num_products
FROM
	categories;

/*
|num_products|
|------------|
|7           |
*/

SELECT
	DISTINCT category_name AS product_category_name
FROM 
	categories;

/*
|product_category_name|
|---------------------|
|Children Bicycles    |
|Comfort Bicycles     |
|Cruisers Bicycles    |
|Cyclocross Bicycles  |
|Electric Bikes       |
|Mountain Bikes       |
|Road Bikes           |
*/

-- How many product brands are there? and, What are the names of the product brands?

SELECT
	COUNT(*) AS num_brands
FROM
	brands;

/*
|num_brands|
|----------|
|9         |
*/

SELECT
	DISTINCT brand_name
FROM
	brands;

/*
|brand_name|
|----------|
|Electra   |
|Haro      |
|Heller    |
|Pure Cycles|
|Ritchey   |
|Strider   |
|Sun Bicycles|
|Surly     |
|Trek      |

*/

-- How many products does the company offer?
SELECT 
	COUNT(*) AS num_products
FROM
	products;

/*
|num_products|
|------------|
|321         |
*/

-- How many products belong to each brand?

SELECT 
	products.brand_id,
    brands.brand_name,
    COUNT(products.product_name) AS num_products_by_brand    
FROM
	products
LEFT JOIN brands
	ON products.brand_id = brands.brand_id
GROUP BY
	brand_id
ORDER BY num_products_by_brand DESC;

/*
|brand_id|brand_name  |num_products_by_brand|
|--------|------------|---------------------|
|9       |Trek        |135                  |
|1       |Electra     |118                  |
|8       |Surly       |25                   |
|7       |Sun Bicycles|23                   |
|2       |Haro        |10                   |
|3       |Heller      |3                    |
|4       |Pure Cycles |3                    |
|6       |Strider     |3                    |
|5       |Ritchey     |1                    |

*/

-- What is the best-selling product per store?
WITH RankQuantityPerStore AS (
	SELECT
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

SELECT *
FROM RankQuantityPerStore
WHERE quantity_rank = 1;




/* 
|product_name                         |category_name      |store_name      |quantity|order_status|quantity_rank|
|-------------------------------------|-------------------|----------------|--------|------------|-------------|
|Pure Cycles Vine 8-Speed - 2016      |Cruisers Bicycles  |Baldwin Bikes   |2       |4           |1            |
|Surly Straggler 650b - 2016          |Cyclocross Bicycles|Rowlett Bikes   |2       |4           |1            |
|Trek Remedy 29 Carbon Frameset - 2016|Mountain Bikes     |Santa Cruz Bikes|2       |4           |1            |

*/


-- 3. Sales analysis
-- How many orders have the company made? and Which stores have the highest orders?

SELECT 
	COUNT(*) AS num_orders
FROM
	orders;
/*
|num_orders|
|----------|
|1615      |
*/

SELECT 
    stores.store_name,
    COUNT(orders.order_id) AS num_orders
FROM
	stores
LEFT JOIN orders
	ON stores.store_id = orders.store_id
GROUP BY
	stores.store_name
ORDER BY num_orders DESC;

/*
|store_name      |num_orders|
|----------------|----------|
|Baldwin Bikes   |1093      |
|Santa Cruz Bikes|348       |
|Rowlett Bikes   |174       |

*/