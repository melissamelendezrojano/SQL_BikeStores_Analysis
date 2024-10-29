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

-- 1. Overview of each table:

-- brands' table
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
	*
FROM
	brands;

/*
| brand_id | brand_name   |
|----------|--------------|
| 1        | Electra      |
| 2        | Haro         |
| 3        | Heller       |
| 4        | Pure Cycles  |
| 5        | Ritchey      |
| 6        | Strider      |
| 7        | Sun Bicycles |
| 8        | Surly        |
| 9        | Trek         |
*/

-- categories' table
SELECT
	COUNT(*) AS num_categories
FROM
	categories;
    
/*
|num_categories|
|--------------|
|7             |
*/

SELECT
	*
FROM
	categories;

/*
| category_id | category_name       |
|-------------|---------------------|
| 1           | Children Bicycles   |
| 2           | Comfort Bicycles    |
| 3           | Cruisers Bicycles   |
| 4           | Cyclocross Bicycles |
| 5           | Electric Bikes      |
| 6           | Mountain Bikes      |
| 7           | Road Bikes          |
*/

-- stores' table
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
	*
FROM
	stores;

/*
| store_id | store_name       | phone          | email                | street              | city       | state | zip_code |
|----------|------------------|----------------|----------------------|---------------------|------------|-------|----------|
| 1        | Santa Cruz Bikes | (831) 476-4321 | santacruz@bikes.shop | 3700 Portola Drive  | Santa Cruz | CA    | 95060    |
| 2        | Baldwin Bikes    | (516) 379-8888 | baldwin@bikes.shop   | 4200 Chestnut Lane  | Baldwin    | NY    | 11432    |
| 3        | Rowlett Bikes    | (972) 530-5555 | rowlett@bikes.shop   | 8000 Fairway Avenue | Rowlett    | TX    | 75088    |
*/

-- products' table
SELECT
	COUNT(*) AS num_products
FROM
	products;
    
/*
|num_products|
|------------|
|321         |
*/

SELECT
	*
FROM
	products
LIMIT
	5;

/*
| product_id | product_name                       | brand_id | category_id | model_year | list_price |
|------------|------------------------------------|----------|-------------|------------|------------|
| 1          | Trek 820 - 2016                    | 9        | 6           | 2016       | 379.99     |
| 2          | Ritchey Timberwolf Frameset - 2016 | 5        | 6           | 2016       | 749.99     |
| 3          | Surly Wednesday Frameset - 2016    | 8        | 6           | 2016       | 999.99     |
| 4          | Trek Fuel EX 8 29 - 2016           | 9        | 6           | 2016       | 2899.99    |
| 5          | Heller Shagamaw Frame - 2016       | 3        | 6           | 2016       | 1320.99    |
*/

-- orders' table
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
	*
FROM
	orders
LIMIT
	5;

/*
| order_id | customer_id | order_status | order_date | required_date | shipped_date | store_id | staff_id |
|----------|-------------|--------------|------------|---------------|--------------|----------|----------|
| 1        | 259         | 4            | 2016-01-01 | 2016-01-03    | 2016-01-03   | 1        | 2        |
| 2        | 1212        | 4            | 2016-01-01 | 2016-01-04    | 2016-01-03   | 2        | 6        |
| 3        | 523         | 4            | 2016-01-02 | 2016-01-05    | 2016-01-03   | 2        | 7        |
| 4        | 175         | 4            | 2016-01-03 | 2016-01-04    | 2016-01-05   | 1        | 3        |
| 5        | 1324        | 4            | 2016-01-03 | 2016-01-06    | 2016-01-06   | 2        | 6        |
*/

-- order_items' table
SELECT
	COUNT(*) AS num_order_items
FROM
	order_items;

/*
|num_order_items|
|---------------|
|4722           |
*/

SELECT
	*
FROM
	order_items
LIMIT
	5;

/*
| order_id | item_id | product_id | quantity | list_price | discount |
|----------|---------|------------|----------|------------|----------|
| 1        | 1       | 20         | 1        | 599.99     | 0.20     |
| 1        | 2       | 8          | 2        | 1799.99    | 0.07     |
| 1        | 3       | 10         | 2        | 1549.00    | 0.05     |
| 1        | 4       | 16         | 2        | 599.99     | 0.05     |
| 1        | 5       | 4          | 1        | 2899.99    | 0.20     |

*/

-- stocks' table
SELECT
	COUNT(*) AS num_stocks
FROM
	stocks;

/*
| num_stocks |
|------------|
| 939        |
*/

SELECT
	*
FROM
	stocks
LIMIT
	5;

/*
| store_id | product_id | quantity |
|----------|------------|----------|
| 1        | 1          | 27       |
| 1        | 2          | 5        |
| 1        | 3          | 6        |
| 1        | 4          | 23       |
| 1        | 5          | 22       |
*/

-- customers' table
SELECT
	COUNT(*) AS num_customers
FROM
	customers;
    
/*
|num_customers|
|-------------|
|1445         |
*/

SELECT
	*
FROM
	customers
LIMIT
	5;

/*
|customer_id|first_name|last_name|phone         |email                  |street               |city         |state|zip_code|
|-----------|----------|---------|--------------|-----------------------|---------------------|-------------|-----|--------|
|1          |Debra     |Burks    |              |debra.burks@yahoo.com  |9273 Thorne Ave.     |Orchard Park |NY   |14127   |
|2          |Kasha     |Todd     |              |kasha.todd@yahoo.com   |910 Vine Street      |Campbell     |CA   |95008   |
|3          |Tameka    |Fisher   |              |tameka.fisher@aol.com  |769C Honey Creek St. |Redondo Beach|CA   |90278   |
|4          |Daryl     |Spence   |              |daryl.spence@aol.com   |988 Pearl Lane       |Uniondale    |NY   |11553   |
|5          |Charolette|Rice     |(916) 381-6003|charolette.rice@msn.com|107 River Dr.        |Sacramento   |CA   |95820   |
*/

-- staffs' table
SELECT
	COUNT(*) AS num_staff
FROM
	staffs;

/*
| num_staff |
|-----------|
| 10        |
*/

SELECT
	*
FROM
	staffs;
    
/*
|staff_id|first_name|last_name|email                        |phone         |active|store_id|manager_id|
|--------|----------|---------|-----------------------------|--------------|------|--------|----------|
|1       |Fabiola   |Jackson  |fabiola.jackson@bikes.shop   |(831) 555-5554|1     |1       |          |
|2       |Mireya    |Copeland |mireya.copeland@bikes.shop   |(831) 555-5555|1     |1       |1         |
|3       |Genna     |Serrano  |genna.serrano@bikes.shop     |(831) 555-5556|1     |1       |2         |
|4       |Virgie    |Wiggins  |virgie.wiggins@bikes.shop    |(831) 555-5557|1     |1       |2         |
|5       |Jannette  |David    |jannette.david@bikes.shop    |(516) 379-4444|1     |2       |1         |
|6       |Marcelene |Boyer    |marcelene.boyer@bikes.shop   |(516) 379-4445|1     |2       |5         |
|7       |Venita    |Daniel   |venita.daniel@bikes.shop     |(516) 379-4446|1     |2       |5         |
|8       |Kali      |Vargas   |kali.vargas@bikes.shop       |(972) 530-5555|1     |3       |1         |
|9       |Layla     |Terrell  |layla.terrell@bikes.shop     |(972) 530-5556|1     |3       |7         |
|10      |Bernardine|Houston  |bernardine.houston@bikes.shop|(972) 530-5557|1     |3       |7         |
*/