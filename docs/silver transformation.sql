--Checking for NULL or duplicates in our data
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
		BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '=========================================';
		PRINT 'Loading Silver layer';
		PRINT '==========================================';

		SET @start_time = GETDATE();
		PRINT '====================================================================================';
		TRUNCATE TABLE silver.crm_cust_info
		PRINT '>> Inserting data into silver.crm_cust_info'
		INSERT INTO silver.crm_cust_info (
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date
		)
		SELECT 
		cst_id,
		cst_key,
		TRIM(cst_firstname),
		TRIM(cst_lastname),
		CASE WHEN UPPER(TRIM(cst_gndr)) = 'S' THEN 'Single'
			 WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Married'
			 ELSE 'n/a'
		END cst_marital_status,

		CASE WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
			 WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
			 ELSE 'n/a'
		END cst_gndr,
		cst_create_date
		FROM(
		SELECT 
			*,
			ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date desc) as flag_last
		FROM bronze.crm_cust_info
		WHERE cst_id is not null
		)t WHERE flag_last = 1 ;
		SET @end_time = GETDATE();
		PRINT '>> Load duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'Seconds';
		PRINT '===========================================================================================';

		SET @start_time = GETDATE();
		TRUNCATE TABLE silver.crm_prd_info
		PRINT '>> Inserting data into silver.crm_prd_info'
		INSERT INTO silver.crm_prd_info (
			prd_id,
			prd_key,
			cat_id,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_date
			)
		SELECT
			prd_id,
			REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') as cat_id, -- Extracted the category ID
			SUBSTRING(prd_key, 7,(Len(prd_key))) as prd_key, --- Extracted new productKey
			prd_nm,
			ISNULL(prd_cost, 0) AS prd_cost,
			CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
				WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
				WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other sales'
				WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
				ELSE 'n/a'
				END prd_line,
			CAST(prd_start_dt AS DATE) AS prd_start_dt,
			CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) as prd_end_dt
		FROM bronze.crm_prd_info;
		SET @end_time = GETDATE();
		PRINT '>> Load duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'Seconds';
		PRINT '===========================================================================================';

		SET @start_time = GETDATE();
		TRUNCATE TABLE silver.crm_sales_details
		PRINT '>> Inserting data into silver.crm_sales_details'
		INSERT INTO silver.crm_sales_details (
			sls_ord_num,
			sls_prd_key,
			sls_cus_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
		)
		SELECT
			sls_ord_num,
			sls_prd_key,
			sls_cus_id,	
			CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
				ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
			END sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			CASE WHEN sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price) 
			THEN sls_quantity * ABS(sls_price)
			ELSE sls_sales
		END AS sls_sales,
			sls_quantity,
		CASE WHEN sls_price IS NULL OR sls_price <= 0	THEN sls_sales /NULLIF(sls_quantity, 0)
			ELSE sls_price
		END AS sls_prie
		FROM bronze.crm_sales_details;
		SET @end_time = GETDATE();
		PRINT '>> Load duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'Seconds';
		PRINT '===========================================================================================';
		SET @start_time = GETDATE();
		TRUNCATE TABLE silver.erp_cus_az12
		PRINT '>> Inserting data into silver.erp_cus_az12'
		INSERT INTO silver.erp_cus_az12 (
				cid,
				bdate,
				gen
		)
		SELECT
			CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
				ELSE cid
			END  AS cid,
			CASE WHEN bdate > GETDATE() THEN NULL ELSE bdate
			END AS bdate,
			CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
				WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
				ELSE 'n/a'
			END  AS gen	
		FROM bronze.erp_cus_az12;
		SET @end_time = GETDATE();
		PRINT '>> Load duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'Seconds';
		PRINT '===========================================================================================';

		SET @start_time = GETDATE();
		TRUNCATE TABLE silver.erp_loc_a101
		PRINT '>> Inserting data into silver.erp_loc_a101'
		INSERT INTO silver.erp_loc_a101(cid, cntry)
		SELECT 
			REPLACE(cid, '-', '') AS cid,
			CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
				WHEN TRIM(cntry) IN ('USA', 'US') THEN 'United States'
				WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
				ELSE TRIM(cntry)
			END AS cntry
		FROM bronze.erp_loc_a101;
		SET @end_time = GETDATE();
		PRINT '>> Load duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'Seconds';
		PRINT '===========================================================================================';
		
		SET @start_time = GETDATE();
		TRUNCATE TABLE silver.erp_px_cat_g1v2
		PRINT '>> Inserting data into silver.erp_px_cat_g1v2'
		INSERT INTO silver.erp_px_cat_g1v2(id, cat, subcat, maintenance)
		SELECT id, cat, subcat, maintenance 
		FROM bronze.erp_px_cat_g1v2
	SET @end_time = GETDATE();
		PRINT '>> Load duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'Seconds';
		PRINT '===========================================================================================';

		SET @batch_end_time = GETDATE();
		PRINT '==========================================================================================='
		PRINT '>> Load Silver layer is completed' 
		PRINT '     - Total load duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'Seconds';
		PRINT '===========================================================================================';
		END TRY
		BEGIN CATCH
			PRINT '================================================';
			PRINT 'ERROR OCCURED LOADING SILVER LAYER';
			PRINT 'Error Message' + ERROR_MESSAGE();
			PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
			PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
			PRINT '================================================';
		END CATCH
END

exec bronze.load_bronze;


