CREATE VIEW gold.dim_customers AS
	 SELECT
		ROW_NUMBER () OVER (ORDER BY cst_id) AS customer_key,
		ci.cst_id AS customer_id,
		ci.cst_key as customer_number,
		ci.cst_firstname as first_name,
		ci.cst_lastname as last_name,
		ci.cst_marital_status as marital_status,
		la.cntry as country,
		CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr --- master for gender
			ELSE COALESCE(ca.gen, 'n/a')
		END AS gender,
		ca.bdate as birthdate,
		ci.cst_create_date as create_date
	
	 FROM silver.crm_cust_info ci
	 LEFT JOIN silver.erp_cus_az12 ca ON ci.cst_key = ca.cid
	 LEFT JOIN silver.erp_loc_a101 la ON ci.cst_key = la.cid


 CREATE VIEW gold.dim_products AS
 SELECT 
	ROW_NUMBER () OVER (ORDER BY pn.prd_start_dt, pn.prd_key) as product_key,
	pn.prd_id as product_id,
	pn.prd_key as product_number,
	pn.prd_nm as product_name,
	pn.cat_id as category_id,
	pc.cat as category,
	pc.subcat as subcategory,
	pc.Maintenance,
	pn.prd_cost as product_cost,
	pn.prd_line as product_line,
	pn.prd_start_dt as start_date
	
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc ON pn.prd_key = pc.id 
WHERE pn.prd_end_date IS NULL--- removing all historical data


CREATE VIEW gold.fact_sales AS
SELECT
	sd.sls_ord_num,
	pr.product_key,
	c.customer_key,
	sd.sls_order_dt,
	sd.sls_ship_dt,
	sd.sls_due_dt,
	sd.sls_sales,
	sd.sls_quantity,
	sd.sls_price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr ON sd.sls_prd_key = pr.category_id
LEFT JOIN gold.dim_customers c ON sd.sls_cus_id = c.customer_id
