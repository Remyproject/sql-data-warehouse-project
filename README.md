# **Building a Scalable Data Warehouse Using the Medallion Architecture**

## **Project Overview**

This project focuses on designing and implementing a **scalable Data Warehouse** using the **Medallion Architecture (Bronze, Silver, Gold Layers)** to process and transform raw data into business-ready insights. The entire ETL (Extract, Transform, Load) pipeline was developed from scratch, ensuring data quality, integrity, and usability. Additionally, I used the **Star Schema Model** to structure the analytical data efficiently for reporting and business intelligence.


## **Project Goals**

- Build a structured Data Warehouse from **raw source data** to **business-ready data**.
- Implement a robust **ETL pipeline** to process, clean, and transform data.
- Ensure **data quality, deduplication, and standardization** at different stages.
- Utilize **Medallion Architecture** for efficient data processing.
- Design an optimized **Star Schema** for analytical queries and reporting.
 

---

## **Project Steps and Execution**

### **1. Data Architecture Planning**

- Designed a **high-level architecture** to define the data flow from source systems to analytics.
- Followed the **Medallion Architecture**, splitting data into **Bronze, Silver, and Gold layers**.
- Selected appropriate **data sources** such as CRM and ERP systems.
- Chose a **relational database (SQL-based) for the warehouse** to store structured data.

 <img width="606" alt="highlever" src="https://github.com/user-attachments/assets/3942b86e-7470-4d60-b457-f1c6b59e5106" /> 

### **2. Project Initialization**

- Created a **database schema** for the warehouse.
- Defined table structures for different layers (Bronze, Silver, Gold).
- Established the **ETL pipeline** for ingestion, transformation, and storage.
- Ensured data governance with **data types, constraints, and indexing**.

### **3. Bronze Layer - Raw Data Storage**

- **Extracted data** from CRM and ERP systems into the **Bronze layer**.
- Stored raw data **without transformation** to retain full fidelity.
- Ensured ingestion supports **batch processing** for scalability.

### **4. Silver Layer - Data Cleaning & Transformation**

- **Performed data quality checks**:
  - Removed **duplicates** using `ROW_NUMBER()` to keep only the latest records.
  - Checked for **NULL values** and handled missing data.
- **Standardized text fields** using `TRIM()` to remove unwanted spaces.
- **Transformed categorical values**:
  - Mapped `cst_gndr` values ('M' → 'Male', 'F' → 'Female').
  - Transformed `cst_marital_status` ('S' → 'Single', 'M' → 'Married').
- Ensured **data consistency** for accurate analysis.

### **5. Gold Layer - Business Ready Data**

- **Created business-level aggregations**:
  - Designed **fact tables** for transactions and interactions.
  - Created **dimension tables** (customers, products, time, etc.).
  - Implemented the **Star Schema** to optimize analytical queries.
- Designed **views** for fast business intelligence reporting.
- Applied **business rules and KPIs** for strategic insights.

---

## **Achievements & Results**

- Successfully **built a scalable Data Warehouse** using the **Medallion Architecture**.
- Optimized data for **BI tools like Power BI & SQL-based queries**.
- Improved **data consistency, accuracy, and usability** across layers.
- Established a structured **ETL pipeline** that ensures efficient data processing.
- Implemented **best practices** in data warehousing for high performance.
![Integration model](https://github.com/user-attachments/assets/c53d1ec8-4e64-41fa-8f41-1a1d3d43625c)

---

## **Technology Stack**

- **Database**: SQL-based Data Warehouse
- **ETL Tools**: SQL scripts for transformation
- **Data Modeling**: Star Schema
- **BI & Reporting**: Power BI
![data model](https://github.com/user-attachments/assets/808b92ce-0583-4d02-b242-2ce7a081de0a)

---

## **Next Steps & Future Enhancements**

- Automate ETL processes with **Apache Airflow** or **dbt**.
- Implement **real-time streaming** with **Apache Kafka**.
- Optimize query performance using **indexing and partitioning**.
- Integrate **Machine Learning models** for predictive analytics.

### 🚀 *This project demonstrates my ability to design and implement a full-scale Data Warehouse from scratch, transforming raw data into valuable business insights.*



## **About Me & Tools Used**

### **About Me**
I am a passionate **Data Analyst transitioning into Data Engineering**, with experience in building scalable data solutions. My expertise includes **data warehousing, ETL pipelines, business intelligence, and forensic data analysis**. I thrive on solving complex data challenges and transforming raw information into meaningful insights.

### **Tools Used**
- **Database & ETL**: SQL (for transformation & querying)
- **Data Modeling**: Star Schema, Medallion Architecture
- **Visualization & BI**: Power BI
- **Project Tracking**: Notion
- **Diagramming & Architecture Design**: draw.io


