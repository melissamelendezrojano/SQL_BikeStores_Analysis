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
	brand_id,
    COUNT(product_name) AS num_products_by_brand    
FROM
	products
GROUP BY
	brand_id;
    
/*
|brand_id|num_products_by_brand|
|--------|---------------------|
|1       |118                  |
|2       |10                   |
|3       |3                    |
|4       |3                    |
|5       |1                    |
|6       |3                    |
|7       |23                   |
|8       |25                   |
|9       |135                  |

*/

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