-- INTRODUCTION

/*
Purpose: This project aims to conduct an analysis of agency sales data for PT Garuda Indonesia (Persero) Tbk, with a focus on 
		identifying top-performing agents, service codes, regions, and routes. The insights derived will support the Agency Sales Unit in developing targeted 
		product offerings, strategic sales programs, and data-driven marketing initiatives to drive sustainable growth across all market segments.
*/

-- Dataset Overview: 

/*
This project uses two datasets:
1. new_2023.csv : This dataset contains flown and sales records in USD of 2023 for travel agents that partnered with Garuda Indonesia, including data types,
				 agents name, region of sales, agent number, routes. Those data are the foundation for this analysis.
2. new_2024.csv : This dataset contains flown and sales records in USD of 2024 for travel agents that partnered with Garuda Indonesia, including data types,
				 agents name, region of sales, agent number, routes. Those data are the foundation for this analysis.

These data altogether allow for a comprehensive view of Agency Sales Unit revenue and routes performance.

DISCLAIMER: The data used in this project is fictional and has been generated for confidentiality purposes.
*/

-- DATA LOADING

-- Creates the table with standardize column names and importing the csv files.

CREATE TABLE agency_sales
	(data_type VARCHAR(20),
	travel_agent VARCHAR(200),
	region VARCHAR(5),
	service_code VARCHAR(5),
	agen_no INT,
	routes VARCHAR(40),
	"Date" Date,
	pax INT,
	usd INT);

COPY agency_sales FROM '..\Datasets\Q1_2023.csv' DELIMITER ',' CSV HEADER;
COPY agency_sales FROM '..\Datasets\Q1_2024.csv' DELIMITER ',' CSV HEADER;

-- Display the first few rows of the datasets to confirm successful loading and inspect initial data structure.

SELECT * FROM agency_sales
LIMIT 10;

-- DATA CLEANING

-- Checks for duplicates across all table.

WITH duplicate_check
	AS(SELECT *, ROW_NUMBER() OVER(
		PARTITION BY data_type, travel_agent, region, service_code, agen_no, routes, "Date", pax, usd) 
	AS row_num FROM agency_sales
)
SELECT *
FROM duplicate_check
WHERE row_num > 1;

-- Cleans the duplicates if present.

DELETE FROM agency_sales
WHERE ctid IN (
	SELECT ctid FROM (
		SELECT ctid, ROW_NUMBER() OVER(
			PARTITION BY data_type, travel_agent, region, service_code, agen_no, routes, "Date", pax, usd
			ORDER BY ctid)
		AS row_num FROM agency_sales
		) sub
	WHERE row_num > 1
);

-- Standardize prefix for some agent names that has "PT" in it/inconsistence.

SELECT DISTINCT travel_agent, REGEXP_REPLACE(travel_agent, '^PT[\.  ]*', 'PT ') AS standaradized_pt
FROM agency_sales
ORDER BY 1;

UPDATE agency_sales
	SET travel_agent = REGEXP_REPLACE(travel_agent, '^PT[\.  ]*', 'PT ')
	WHERE travel_agent ~ '^PT[\.  ]*';

-- Checks for invalid or unused agen_no since Agency Sales agen_no specifically starts from 150 for DOMESTIC / 153 for INTERNATIONAL.

SELECT DISTINCT agen_no FROM agency_sales
ORDER BY agen_no;

-- Checks for travel_agent column to identify duplicates name, similar names, and anomalies to improve data quality.

SELECT DISTINCT travel_agent FROM agency_sales
ORDER BY travel_agent;

SELECT DISTINCT travel_agent, agen_no FROM agency_sales
WHERE travel_agent ILIKE '%Dummy%';

SELECT DISTINCT travel_agent, agen_no FROM agency_sales
WHERE travel_agent IN ('GA HANDLING EC - OPA', 'Other Airline Agent');

/*
Communicate duplicates name, similar names, and anomalies findings to manager either to keep it on the dataset, update, or to delete it.
They will ask to update and delete these findings everytime in my cases.
*/

DELETE FROM agency_sales
WHERE travel_agent IN ('GA HANDLING EC - OPA', 'Other Airline Agent');

/*
Since there are plenty of 'Dummy Agent' in travel_agent, replacing these data requires reservation system provided by Garuda Indonesia purposedly for this cases.
However, since there are many of similar names or same travel_agent just different names, we could update these names using list provided by the company to achieve more cleaner dataset.
*/

UPDATE agency_sales
SET travel_agent = CASE
WHEN travel_agent LIKE 'CAHAYA BERSAMA TOUR & TRAVEL' THEN 'TRAVEL CENTRE'
	WHEN travel_agent LIKE 'CHAN BROTHERS TRAVEL' THEN 'PANORAMA JTB'
	WHEN travel_agent LIKE '%PANORAMA%' THEN 'PANORAMA JTB'
	WHEN travel_agent LIKE '%FLYING VENES PERSADA%' THEN 'TRAVEL MART'
	WHEN travel_agent LIKE 'MNC TRAVEL' THEN 'HOLIA TOUR'
	WHEN travel_agent LIKE 'ROTAMA TOUR' THEN 'WITA ROTAMA'
	WHEN travel_agent LIKE 'WITA TOUR' THEN 'WITA ROTAMA'
	WHEN travel_agent LIKE 'WISATA DEWA TOUR' THEN 'WITA ROTAMA'
	WHEN travel_agent LIKE '%HARUM INDAH SARI%' THEN 'HIS TRAVEL'
	WHEN travel_agent LIKE '%NUSANTARA%' THEN 'DWI DAYA'
	WHEN travel_agent LIKE '%OBAJA%' THEN 'OBAJA TOUR & TRAVEL'
	WHEN travel_agent LIKE '%GOLDEN RAMA%' THEN 'GOLDEN RAMA'
	WHEN travel_agent LIKE '%VOLTRAS%' THEN 'VOLTRAS TRAVEL'
	WHEN travel_agent LIKE '%BAYU BUANA%' THEN 'BAYU BUANA'
	WHEN travel_agent LIKE 'ALPINO TRAVEL' THEN 'ALPINO MUSI'
	WHEN travel_agent LIKE 'AVODAH TOUR TRAVEL' THEN 'PT AVODAH HARVEST INTERNATIONAL'
	WHEN travel_agent LIKE 'BIDY TANDT' THEN 'BIDI TOURS'
	WHEN travel_agent LIKE 'BUMI NATA WISATA TOURS' THEN 'BUMI NATA WISATA'
	WHEN travel_agent LIKE 'CARNAVAL HOLIDAY TOUR' THEN 'PT CARNAVAL HOLIDAY'
	WHEN travel_agent LIKE 'DWI DAYA WORLDWIDE' THEN 'DWI DAYA'
	WHEN travel_agent LIKE 'EVER PROMPT' THEN 'EVER PROMPT TRAVEL'
	WHEN travel_agent LIKE 'JATRA IDOLA' THEN 'JATRA IDOLA TOUR'
	WHEN travel_agent LIKE 'KAISA ROSSIE' THEN 'KAISSA ROSSIE'
	WHEN travel_agent LIKE 'MAJU IKA JAYA' THEN 'MAJU IKA JAYA TOUR'
	WHEN travel_agent LIKE 'MURNI TOUR & TRAVEL' THEN 'MURNI TOUR'
	WHEN travel_agent LIKE 'OMEGA TOURS & TRAVEL' THEN 'PT OMEGA TOUR&TRAVEL'
	WHEN travel_agent LIKE 'PACTO TRAVEL' THEN 'PACTO LIMITED'
	WHEN travel_agent LIKE 'PRIMA VIJAYA INDAH' THEN 'PRIMA VIJAYA IND'
	WHEN travel_agent LIKE 'PRIMA VIJAYA TOUR' THEN 'PRIMA VIJAYA IND'
	WHEN travel_agent LIKE 'PRIME TRAVELINDO / RASA WISATA' THEN 'PRIME TRAVELINDO'
	WHEN travel_agent LIKE 'PT ANGGREK WISATA INDONESIA' THEN 'ANGGREK WISATA INDONESIA TRAVEL'
	WHEN travel_agent LIKE 'ANGGREK WISATA INDONESIA TRAVE' THEN 'ANGGREK WISATA INDONESIA TRAVEL'
	WHEN travel_agent LIKE 'PT ANGKASA TRAVEL INTERNATIONAL' THEN 'ANGKASA INTERNATIONAL'
	WHEN travel_agent LIKE 'PT CENDANA TOUR & TRAVEL' THEN 'CENDANA'
	WHEN travel_agent LIKE 'PT DEWI AGUNG MULIA' THEN 'DEWI AGUNG MULIA'
	WHEN travel_agent LIKE 'PT GARNIS TOUR AND TRAVEL' THEN 'GARNIS TOUR AND TRA'
	WHEN travel_agent LIKE 'PT GARUDA ABADI/TA: GARDI TOUR' THEN 'GARDI TOUR'
	WHEN travel_agent LIKE 'GARUDA ABADI' THEN 'GARDI TOUR'
	WHEN travel_agent LIKE 'PT JASA GLOBAL WISATA' THEN 'JGW TRAVEL'
	WHEN travel_agent LIKE 'PT JEJAK IMANI BERKAH BERSAMA' THEN 'JEJAK IMANI BERKAH BERSAMA'
	WHEN travel_agent LIKE 'PT KINGSINDO TRAVEL PERKASA' THEN 'KINGS TRAVEL'
	WHEN travel_agent LIKE 'PT LICIA KEUMALA CEMERLANG' THEN 'LICIA KEUMALA CEMERLANG TOUR & TRAVEL'
	WHEN travel_agent LIKE 'PT MANARA TABA INDONESIA' THEN 'MANARA TABA INDONES'
	WHEN travel_agent LIKE 'PT PANJI MAS WISATA' THEN 'PANJI MAS WISATA'
	WHEN travel_agent LIKE 'PT PRICE SMART TOUR & TRAVEL' THEN 'PRICE SMART TOUR & TRAVEL'
	WHEN travel_agent LIKE 'PT SATGURU TRAVEL AND TOURS' THEN 'SATGURU TRAVEL & TOURS'
	WHEN travel_agent LIKE 'PT SHAFIRA TOUR & TRAVEL' THEN 'SHAFIRA TOUR & TRAVEL'
	WHEN travel_agent LIKE 'PT TYARA BERLIANI WISATA' THEN 'TYARA HOLIDAY'
	WHEN travel_agent LIKE 'PT YATITA TOURS INDONESIA' THEN 'YATITA TOURS INDONESIA'
	WHEN travel_agent LIKE 'PT PACTO LIMITED' THEN 'PACTO LIMITED'
	WHEN travel_agent LIKE 'PURI ASTINA PUTRA' THEN 'PT PURI ASTINA PUTRA'
	WHEN travel_agent LIKE 'RAYA UTAMA TRAVEL' THEN 'PT RAYA UTAMA TRAVEL'
	WHEN travel_agent LIKE 'SUMAN TOUR' THEN 'SUMANINDO TOUR'
	WHEN travel_agent LIKE 'SUMANINDO' THEN 'SUMANINDO TOUR'
	WHEN travel_agent LIKE 'SUMANINDO GRAHAWISATA' THEN 'SUMANINDO TOUR'
	WHEN travel_agent LIKE 'TIOLAMHOT TRAVELGO GLOBAL' THEN 'PT TIOLAMHOT TRAVELGO GLOBAL TOURS & TRAVEL'
	WHEN travel_agent LIKE 'TOTOGASONO SEKAWAN' THEN 'PT TOTOGASONO SEKAWAN'
	WHEN travel_agent LIKE 'TRANS GLOBE TRAVEL CENTRE' THEN 'TRAVEL CENTRE'
	WHEN travel_agent LIKE 'TX TRAVEL SURABAYA' THEN 'JAKARTA EXPRESS / TX TRAVEL'
	WHEN travel_agent LIKE 'WISATA JAWA INDAH' THEN 'PT WISATA JAWA INDAH'
	WHEN travel_agent LIKE 'WISATA MANCANEGARA NUGRAHA (WISMAN TOUR)' THEN 'WISMAN TOUR/ WISATA MANCANEGARA'
	WHEN travel_agent LIKE 'HARYONO%' THEN 'HARYONO TOURS'
	WHEN travel_agent LIKE 'CSM Tour & Travel' THEN 'CSM TOUR & TRAVEL'
	WHEN travel_agent LIKE 'PT FIWI LESTARI INTERNATIONAL (AVIA Tour)' THEN 'AVIA TOUR'
	WHEN travel_agent LIKE 'BALIDUTA EXP TOURS' THEN 'BALI DUTA EXPRESS'
	WHEN travel_agent LIKE 'BHAKTI PUTRA INT' THEN 'BHAKTI'
	WHEN travel_agent LIKE 'PALMMAS DEWATA TOURS (WCA)' THEN 'PALMMAS'
	WHEN agen_no = 1501*** THEN 'PT AVODAH HARVEST INTERNATIONAL'
	WHEN agen_no = 1533*** THEN 'RADIGOST TRAVEL'
	WHEN agen_no = 1533*** THEN 'KHALIFAH ASIA TOUR & TRAVEL'
	WHEN agen_no = 1533*** THEN 'PT BUFFALO TOURS INDONESIA'
	WHEN agen_no = 1533*** THEN 'PT EAST GLOBAL TOUR'
	WHEN agen_no = 1501*** THEN 'WISMAN TOUR/ WISATA MANCANEGARA'
	WHEN agen_no = 1501*** THEN 'TRITAMA JAYA WISATA'
	WHEN agen_no = 1533*** THEN 'ANDAMAS MABRUR WISATA'
	WHEN agen_no = 1533*** THEN 'KANAYA WISATA JAYA'
	WHEN agen_no = 1533*** THEN 'PRICELINE INC'
	WHEN agen_no = 1533*** THEN 'HATTCO TOURS & TRAVEL'
	WHEN agen_no = 1533*** THEN 'ALMADINAH MUTIARA SUNNAH'
	WHEN agen_no = 1533*** THEN 'CHERIA HALAL WISATA'
	WHEN agen_no = 1533*** THEN 'DUNIA GLOBALINDO TRAVEL'
	WHEN agen_no = 1501*** THEN 'JGW TRAVEL'
	WHEN agen_no = 1533*** THEN 'JGW TRAVEL'
	WHEN agen_no = 1501*** THEN 'KINGS TRAVEL'
	WHEN agen_no = 1533*** THEN 'KINGS TRAVEL'
	WHEN agen_no = 1501*** THEN 'MKU TOUR &TRAVEL'
	WHEN agen_no = 1501*** THEN 'PT KETAPANG WISATA'
	WHEN agen_no = 1533*** THEN 'PT SALWANA GLOBAL SARANA'
	WHEN agen_no = 1533*** THEN 'PT GLOBAL MANDIRI TANGGUH'
	WHEN agen_no = 1501*** THEN 'PT MULTI MITRA WISATA'
	WHEN agen_no = 1534*** THEN 'MULTI TOURS & TRAVEL'
	WHEN agen_no = 1531*** THEN 'AL ANDALUS NUSANTARA'
	ELSE travel_agent
END;

-- Final Data Consistency Check

-- Checks previous findings and also checking duplicates one more time just to be safe.

SELECT * FROM agency_sales
WHERE travel_agent IN ('%Dummy%', 'GA HANDLING EC - OPA', 'Other Airline Agent');

WITH duplicate_check
	AS(SELECT *, ROW_NUMBER() OVER(
		PARTITION BY data_type, travel_agent, region, service_code, agen_no, routes, "Date", pax, usd) 
	AS row_num FROM agency_sales
)
SELECT *
FROM duplicate_check
WHERE row_num > 1;

-- EXPLORATORY DATA ANALYSIS (EDA)

-- What is the Quarter-on-Quarter in total revenue, average revenue, and total pax?

SELECT EXTRACT(YEAR FROM "Date") AS year,
	SUM(usd) AS total_revenue,
	ROUND(AVG(usd),2) AS avg_revenue,
	SUM(pax) AS total_pax
FROM agency_sales
WHERE data_type = 'Revenue'
GROUP BY year
ORDER BY year;

-- What is the Month-on-Month in total revenue, average revenue, and total pax?

SELECT EXTRACT(YEAR FROM "Date") AS year,
	EXTRACT(MONTH FROM "Date") AS month,
	SUM(usd) AS total_revenue,
	ROUND(AVG(usd),2) AS avg_revenue,
	SUM(pax) AS total_pax
FROM agency_sales
WHERE data_type = 'Revenue'
GROUP BY year, month
ORDER BY month;

/*
Which travel_agent eligible for the strategic sales program. The number and the requirement for selected travel_agent are undisclosed for the public.
However, for the sake of this project shall select the top 10 travel_agent using revenue_2023.
*/

SELECT travel_agent,
  SUM(usd) AS revenue_2023
FROM agency_sales
WHERE data_type = 'Revenue'
  AND EXTRACT(YEAR FROM "Date") = 2023
GROUP BY travel_agent
ORDER BY revenue_2023 DESC
LIMIT 10;

-- Which travel_agent accumulate the biggest growth of revenue QoQ?

SELECT travel_agent,
  SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2023 THEN usd ELSE 0 END) AS revenue_2023,
  SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2024 THEN usd ELSE 0 END) AS revenue_2024,
  SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2024 THEN usd ELSE 0 END) - SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2023 THEN usd ELSE 0 END) AS revenue_growth,
  CASE WHEN SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2023 THEN usd ELSE 0 END) = 0 THEN 
  CASE WHEN SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2024 THEN usd ELSE 0 END) > 0 THEN 100
	ELSE 0
  END
    ELSE 
      ROUND(100.0 * (SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2024 THEN usd ELSE 0 END) - SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2023 THEN usd ELSE 0 END))
      / SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2023 THEN usd ELSE 0 END),2)
  END AS percentage_growth
FROM agency_sales
WHERE data_type = 'Revenue'
GROUP BY travel_agent
ORDER BY revenue_growth DESC
LIMIT 10;

-- How are the growth revenues and pax flowns for the region of sales in Q1 2023 & 2024?

SELECT region,
  SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2023 THEN usd ELSE 0 END) AS revenue_2023,
  SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2024 THEN usd ELSE 0 END) AS revenue_2024,
  SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2024 THEN usd ELSE 0 END) - SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2023 THEN usd ELSE 0 END) AS revenue_growth,
  SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2023 THEN pax ELSE 0 END) AS pax_2023,
  SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2024 THEN pax ELSE 0 END) AS pax_2024,
  SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2024 THEN pax ELSE 0 END) - SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2023 THEN pax ELSE 0 END) AS pax_growth
FROM agency_sales
WHERE data_type = 'Revenue'
GROUP BY region
ORDER BY revenue_growth DESC;

-- What is the top 5 most demanding routes per Q1 of 2023 and 2024?

WITH ranked_routes AS (
  SELECT
    EXTRACT(YEAR FROM "Date") AS year,
    service_code,
    routes,
    SUM(usd) AS total_revenue,
    SUM(pax) AS total_pax,
    ROW_NUMBER() OVER (PARTITION BY EXTRACT(YEAR FROM "Date")
    ORDER BY SUM(usd) DESC) AS rank
  FROM agency_sales
  WHERE data_type = 'Revenue'
    AND EXTRACT(YEAR FROM "Date") IN (2023, 2024)
  GROUP BY year, service_code, routes
)
SELECT year,
  service_code,
  routes,
  total_revenue,
  total_pax
FROM ranked_routes
WHERE rank <= 5
ORDER BY year, total_revenue DESC;

-- What is the pax to revenue ratio per day of Q1 2023?

SELECT "Date",
  SUM(usd) AS total_revenue,
  SUM(pax) AS total_pax,
  ROUND(SUM(usd) / NULLIF(SUM(pax), 0), 2) AS revenue_per_pax
FROM agency_sales
WHERE data_type = 'Revenue' AND EXTRACT(YEAR FROM "Date") = 2023
GROUP BY "Date"
ORDER BY "Date";

-- DATA LOADING ON DAILY BASIS

-- Since this database updated regularly, here is example of the process.

/*

-- Checks and removes the current testing table for duplicates (one time setup).

WITH check_duplicate 
	AS(SELECT *, ROW_NUMBER() OVER(
		PARTITION BY data_type, travel_agent, region, service_code, agen_no, routes, "Date", pax, usd) 
	AS row_num FROM agency_sales_testing
)
SELECT *
FROM check_duplicate
WHERE row_num > 1;

DELETE FROM agency_sales_testing
WHERE ctid IN (
	SELECT ctid FROM (
		SELECT ctid, ROW_NUMBER() OVER(
			PARTITION BY data_type, travel_agent, region, service_code, agen_no, routes, "Date", pax, usd
			ORDER BY ctid)
		AS row_num FROM agency_sales_testing
		) sub
	WHERE row_num > 1
);

-- Adding constraint for better performance while inserting new data every time.

ALTER TABLE agency_sales_testing
ADD CONSTRAINT uk_agency_sales_testing
UNIQUE (data_type, travel_agent, region, service_code, agen_no, routes, "Date", pax, usd);

-- Creates a temporary table for safe loading process.

CREATE TEMP TABLE agency_sales_staging
	(data_type VARCHAR(20),
	travel_agent VARCHAR(200),
	region VARCHAR(5),
	service_code VARCHAR(5),
	agen_no INT,
	routes VARCHAR(40),
	"Date" Date,
	pax INT,
	usd INT);

COPY agency_sales_staging FROM '..\Datasets\Q2_2024.csv' DELIMITER ',' CSV HEADER;

-- Checks for invalid data, common anomalies, duplicates, and similar names in the dataset.

SELECT DISTINCT agen_no FROM agency_sales_staging
ORDER BY agen_no;

SELECT DISTINCT travel_agent FROM agency_sales_staging
ORDER BY travel_agent;

SELECT DISTINCT travel_agent, agen_no FROM agency_sales_staging
WHERE travel_agent ILIKE '%Dummy%';

SELECT DISTINCT travel_agent, agen_no FROM agency_sales_staging
WHERE travel_agent IN ('GA HANDLING EC - OPA', 'Other Airline Agent');

-- Cleans and upadates the temporary table to match the current database.

UPDATE agency_sales_staging
	SET travel_agent = REGEXP_REPLACE(travel_agent, '^PT[\.  ]*', 'PT ')
	WHERE travel_agent ~ '^PT[\.  ]*';

DELETE FROM agency_sales_staging
	WHERE agen_no IN ('0', '1005756', '1533584');

DELETE FROM agency_sales_staging
	WHERE travel_agent IN ('GA HANDLING EC - OPA', 'Other Airline Agent', 'CENGKARENG', 'SALES TO UJUNG PANDANG-USD');

UPDATE agency_sales_staging
SET travel_agent = CASE
	WHEN travel_agent LIKE 'CAHAYA BERSAMA TOUR & TRAVEL' THEN 'TRAVEL CENTRE'
	WHEN travel_agent LIKE 'CHAN BROTHERS TRAVEL' THEN 'PANORAMA JTB'
	WHEN travel_agent LIKE '...' THEN '...'
	ELSE travel_agent
END;

-- Final data consistency check before inserting the data to the testing table.

SELECT * FROM agency_sales_staging
WHERE travel_agent IN ('%Dummy%', 'GA HANDLING EC - OPA', 'Other Airline Agent');

WITH duplicate_check
	AS(SELECT *, ROW_NUMBER() OVER(
		PARTITION BY data_type, travel_agent, region, service_code, agen_no, routes, "Date", pax, usd) 
	AS row_num FROM agency_sales_staging
)
SELECT *
FROM duplicate_check
WHERE row_num > 1;

INSERT INTO agency_sales_testing
    SELECT * FROM agency_sales_staging
    ON CONFLICT (data_type, travel_agent, region, service_code, agen_no, routes, "Date", pax, usd)
    DO NOTHING;

DROP TABLE IF EXISTS agency_sales_staging;

-- Final process of importing the new dataset into the main table.

TRUNCATE TABLE agency_sales;

INSERT INTO agency_sales
SELECT * FROM agency_sales_testing;
*/


-- Create VIEWS to import the EDA findings into Power BI (adjusted some some query to match Power BI "Date" format).

CREATE OR REPLACE VIEW QoQ AS
SELECT EXTRACT(YEAR FROM "Date") AS year,
	SUM(usd) AS total_revenue,
	ROUND(AVG(usd),2) AS avg_revenue,
	SUM(pax) AS total_pax
FROM agency_sales
WHERE data_type = 'Revenue'
GROUP BY year
ORDER BY year;

CREATE OR REPLACE VIEW MoM AS
SELECT "Date",
    SUM(usd) AS total_revenue,
    ROUND(AVG(usd), 2) AS avg_revenue,
    SUM(pax) AS total_pax
FROM agency_sales
WHERE data_type = 'Revenue'
GROUP BY "Date"
ORDER BY "Date";

CREATE OR REPLACE VIEW top_ten AS
SELECT travel_agent,
  SUM(usd) AS revenue_2023
FROM agency_sales
WHERE data_type = 'Revenue'
  AND EXTRACT(YEAR FROM "Date") = 2023
GROUP BY travel_agent
ORDER BY revenue_2023 DESC
LIMIT 10;

CREATE OR REPLACE VIEW top_growth AS
SELECT travel_agent,
  SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2023 THEN usd ELSE 0 END) AS revenue_2023,
  SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2024 THEN usd ELSE 0 END) AS revenue_2024,
  SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2024 THEN usd ELSE 0 END) - SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2023 THEN usd ELSE 0 END) AS revenue_growth,
  CASE WHEN SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2023 THEN usd ELSE 0 END) = 0 THEN 
  CASE WHEN SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2024 THEN usd ELSE 0 END) > 0 THEN 100
	ELSE 0
  END
    ELSE 
      ROUND(100.0 * (SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2024 THEN usd ELSE 0 END) - SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2023 THEN usd ELSE 0 END))
      / SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2023 THEN usd ELSE 0 END),2)
  END AS percentage_growth
FROM agency_sales
WHERE data_type = 'Revenue'
GROUP BY travel_agent
ORDER BY revenue_growth DESC
LIMIT 10;

CREATE OR REPLACE VIEW region_growth AS
SELECT region,
  SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2023 THEN usd ELSE 0 END) AS revenue_2023,
  SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2024 THEN usd ELSE 0 END) AS revenue_2024,
  SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2024 THEN usd ELSE 0 END) - SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2023 THEN usd ELSE 0 END) AS revenue_growth,
  SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2023 THEN pax ELSE 0 END) AS pax_2023,
  SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2024 THEN pax ELSE 0 END) AS pax_2024,
  SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2024 THEN pax ELSE 0 END) - SUM(CASE WHEN EXTRACT(YEAR FROM "Date") = 2023 THEN pax ELSE 0 END) AS pax_growth
FROM agency_sales
WHERE data_type = 'Revenue'
GROUP BY region
ORDER BY revenue_growth DESC;

CREATE OR REPLACE VIEW demand_routes AS
WITH ranked_routes AS (
  SELECT
    EXTRACT(YEAR FROM "Date") AS year,
    service_code,
    routes,
    SUM(usd) AS total_revenue,
    SUM(pax) AS total_pax,
    ROW_NUMBER() OVER (PARTITION BY EXTRACT(YEAR FROM "Date")
    ORDER BY SUM(usd) DESC) AS rank
  FROM agency_sales
  WHERE data_type = 'Revenue'
    AND EXTRACT(YEAR FROM "Date") IN (2023, 2024)
  GROUP BY year, service_code, routes
)
SELECT year,
  service_code,
  routes,
  total_revenue,
  total_pax
FROM ranked_routes
WHERE rank <= 5
ORDER BY year, total_revenue DESC;

CREATE OR REPLACE VIEW rev_to_pax AS
SELECT "Date",
  SUM(usd) AS total_revenue,
  SUM(pax) AS total_pax,
  ROUND(SUM(usd) / NULLIF(SUM(pax), 0), 2) AS revenue_per_pax
FROM agency_sales
WHERE data_type = 'Revenue' AND EXTRACT(YEAR FROM "Date") = 2023
GROUP BY "Date"
ORDER BY "Date";

