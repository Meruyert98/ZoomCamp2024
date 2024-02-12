## Week 3 Homework
ATTENTION: At the end of the submission form, you will be required to include a link to your GitHub repository or other public code-hosting site. This repository should contain your code for solving the homework. If your solution includes code that is not in file format (such as SQL queries or shell commands), please include these directly in the README file of your repository.

<b><u>Important Note:</b></u> <p> For this homework we will be using the 2022 Green Taxi Trip Record Parquet Files from the New York
City Taxi Data found here: </br> https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page </br>
If you are using orchestration such as Mage, Airflow or Prefect do not load the data into Big Query using the orchestrator.</br> 
Stop with loading the files into a bucket. </br></br>
<u>NOTE:</u> You will need to use the PARQUET option files when creating an External Table</br>

<b>SETUP:</b></br>
Create an external table using the Green Taxi Trip Records Data for 2022. </br>

```sql
-- Create an external table using the Green Taxi Trip Records Data for 2022. 
CREATE OR REPLACE EXTERNAL TABLE sinuous-studio-412717.ny_taxi.external_green_tripdata
OPTIONS (
    format = 'PARQUET',
    uris = ['gs://mage-zoomcamp-slamova/green_taxi_2022.parquet']
);
```
Create a table in BQ using the Green Taxi Trip Records for 2022 (do not partition or cluster this table). </br>
```sql
-- Create a table in BQ using the Green Taxi Trip Records for 2022 
-- (do not partition or cluster this table).
CREATE OR REPLACE TABLE sinuous-studio-412717.ny_taxi.green_tripdata_non_partitoned AS
SELECT * FROM sinuous-studio-412717.ny_taxi.external_green_tripdata;
```
</p>

## Question 1:
Question 1: What is count of records for the 2022 Green Taxi Data??
- 840,402

```SQL
SELECT COUNT(*) FROM sinuous-studio-412717.ny_taxi.external_green_tripdata;
```

## Question 2:
Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.</br> 
What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?

- 0 MB for the External Table and 6.41MB for the Materialized Table

```SQL
-- 0 B processed 
SELECT COUNT(DISTINCT PULocationID) FROM sinuous-studio-412717.ny_taxi.external_green_tripdata;
-- 6.41 MB processed 
SELECT COUNT(DISTINCT PULocationID) FROM sinuous-studio-412717.ny_taxi.green_tripdata_non_partitoned;
```

## Question 3:
How many records have a fare_amount of 0?

- 1,622

```SQL
SELECT COUNT(*) FROM sinuous-studio-412717.ny_taxi.green_tripdata_non_partitoned
WHERE fare_amount = 0;  
```

## Question 4:
What is the best strategy to make an optimized table in Big Query if your query will always order the results by PUlocationID and filter based on lpep_pickup_datetime? (Create a new table with this strategy)

- Partition by lpep_pickup_datetime  Cluster on PUlocationID

```SQL
-- Partition by `lpep_pickup_datetime` Cluster on `PUlocationID`
CREATE OR REPLACE TABLE sinuous-studio-412717.ny_taxi.green_tripdata_partitoned_clustered
PARTITION BY DATE(lpep_pickup_datetime)
CLUSTER BY PULocationID AS
SELECT * FROM sinuous-studio-412717.ny_taxi.green_tripdata_non_partitoned;
```
## Question 5:
Write a query to retrieve the distinct PULocationID between lpep_pickup_datetime
06/01/2022 and 06/30/2022 (inclusive)</br>

Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 4 and note the estimated bytes processed. What are these values? </br>

Choose the answer which most closely matches.</br> 

- 12.82 MB for non-partitioned table and 1.12 MB for the partitioned table

```sql
-- 12.82 MB
SELECT DISTINCT(PULocationID)
FROM sinuous-studio-412717.ny_taxi.green_tripdata_non_partitoned
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-06-30';

-- 1.12 MB
SELECT DISTINCT(PULocationID)
FROM sinuous-studio-412717.ny_taxi.green_tripdata_partitoned_clustered
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-06-30';
```

## Question 6: 
Where is the data stored in the External Table you created?

- GCP Bucket


## Question 7:
It is best practice in Big Query to always cluster your data:

- True


## (Bonus: Not worth points) Question 8:
No Points: Write a `SELECT count(*)` query FROM the materialized table you created. How many bytes does it estimate will be read? Why?

```sql
SELECT COUNT(*) FROM sinuous-studio-412717.ny_taxi.green_tripdata_non_partitoned;
```
 Bytes processed: 0 B
Due to the query being cached.

## Submitting the solutions

* Form for submitting: https://courses.datatalks.club/de-zoomcamp-2024/homework/hw3


