SELECT * FROM inventory;
SELECT * FROM products;
SELECT * FROM sales;
SELECT * FROM stores;


--Query for the product category that drives the biggest profit (Question 1)
SELECT
	p.product_category,
	SUM(s.units *(p.product_price - p.product_cost)) AS total_profit
FROM
	sales AS s
	LEFT JOIN
	products AS p
ON
	s.product_id = p.product_id
GROUP BY
	p.product_category
ORDER BY
	total_profit DESC;
--Toys is the product category that drives the biggest profit at $1,079,527.00


--Query to show if Toys is the product category that drives the biggest profit across store location (Question 2)
SELECT
	p.product_category,
	st.store_location,
	SUM(s.units *(p.product_price - p.product_cost)) AS total_profit
FROM
	sales AS s
	LEFT JOIN
	products AS p
ON
	s.product_id = p.product_id
	LEFT JOIN
	stores AS st
ON	
	s.store_id = st.store_id
GROUP BY
	p.product_category,
	st.store_location
ORDER BY
	store_location DESC,
	total_profit DESC;
/*Toys is the product category that drives the biggest profit in Residential and Downtown Store Locations 
while Electronics drives the biggest profit in Commercial and Airport Store Locations */ 


--Query for the amount of money tied up in Inventory at the Toy stores (Question 3)
SELECT
	SUM (p.product_price * i.stock_on_hand) AS inventory_value
FROM 
	inventory AS i
LEFT JOIN
	products AS p
ON
	i.product_id = p.product_id
LEFT JOIN
	stores AS st
ON
	st.store_id = i.store_id
;
--$410,240.58 was tied up in Inventory at the Toy stores


--Query on how long the Inventory will Last? (Question 4)
SELECT 
	SUM(s.avg_units_sold_per_day) AS total_avg_unit_sold_per_day, --To get the total avg unit sold across all the stores
	SUM(i.stock_on_hand) AS total_stock,
	((SUM(i.stock_on_hand)) / (SUM(s.avg_units_sold_per_day))) AS inventory_days --To get the days it will take to sell all in Inventory
FROM 
	inventory AS i
LEFT JOIN (
    SELECT store_id,
	AVG(units) AS avg_units_sold_per_day
    FROM sales
    GROUP BY store_id) AS s -- Here is a sub-query to get the avg units sold per day in each store represented by the store_id
ON 
	i.store_id = s.store_id;
--The days Inventory will last at the Toy Stores is approximately 14 days.
