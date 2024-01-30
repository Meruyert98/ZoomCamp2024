# Q1: Which tag has the following text? - Automatically remove the container when it exits
```
docker build --help
docker run --help
```
 --rm
# ---------------

# Q2: What is version of the package wheel ?
```
docker run -it --entrypoint=bash python:3.9
pip list

```
0.42.0

# ---------------

# Q3:

Run Postgres and load data green taxi trips from September 2019 with a pipeline:

```
docker-compose up

docker build -t taxi_ingest:v001 .

URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-09.csv.gz"

docker run -it \
    --network=pg-network \
    taxi_ingest:v001 \
    --user=root \
    --password=root \
    --host=pgdatabase \
    --port=5432 \
    --db=ny_taxi \
    --table_name=green_taxi_trips \
    --url=${URL}
```

or 

```
python ingest_data.py \
	--user=root \
	--password=root \
	--host=localhost \
	--port=5432 \
	--db=ny_taxi \
	--table_name=green_taxi_trips \
	--url=${URL}
```


Load data into Postgres (with jupyter notebooks)

```
!wget https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv
df_zones = pd.read_csv('taxi+_zone_lookup.csv')
df_zones.head()
df_zones.to_sql(name='zones', con=engine, if_exists='replace')
```

# ---------------
# SQL


# 3

```sql
SELECT count(*)
from green_taxi_trips
where lpep_pickup_datetime >= TO_TIMESTAMP('2019/09/18 00:00:0', 'YYYY/MM/DD HH24:MI:ss')
and lpep_dropoff_datetime <= TO_TIMESTAMP('2019/09/18 23:59:59', 'YYYY/MM/DD HH24:MI:ss')
```

15612

# 4
```sql
SELECT lpep_pickup_datetime,max(trip_distance) as max_Dist
from green_taxi_trips
group by lpep_pickup_datetime
order by max_Dist desc
limit 1;
```

2019-09-26

# 5
```sql
SELECT zpu."Borough", sum(total_amount)
FROM
green_taxi_trips t
LEFT JOIN zones zpu ON t."PULocationID" = zpu."LocationID"
   LEFT JOIN zones zdo ON t."DOLocationID" = zdo."LocationID"
 	where  lpep_pickup_datetime >= TO_TIMESTAMP('2019/09/18 00:00:0', 'YYYY/MM/DD HH24:MI:ss')
 and lpep_pickup_datetime <= TO_TIMESTAMP('2019/09/18 23:59:59', 'YYYY/MM/DD HH24:MI:ss')
 group by zpu."Borough"
 having sum(total_amount)>50000;

```

"Brooklyn"	96333.23999999923
"Manhattan"	92271.29999999987
"Queens"	78671.70999999875

# 6
```sql
select "drtz"."Zone",max(tip_amount) as max_tip
from taxi_zones "pultz"
inner join green_taxi_trips "tg"
on "pultz"."LocationID" = "tg"."PULocationID"
inner join taxi_zones "drtz"
on "drtz"."LocationID" = "tg"."DOLocationID"
where "pultz"."Zone" = 'Astoria'
group by "drtz"."Zone"
order by max_tip desc
limit 1;

```
JFK Airport

# 7
```
terraform apply
```

```
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  + create

Terraform will perform the following actions:

  # google_bigquery_dataset.demo_dataset will be created
  + resource "google_bigquery_dataset" "demo_dataset" {
      + creation_time              = (known after apply)
      + dataset_id                 = "demo_dataset"
      + default_collation          = (known after apply)
      + delete_contents_on_destroy = false
      + effective_labels           = (known after apply)
      + etag                       = (known after apply)
      + id                         = (known after apply)
      + is_case_insensitive        = (known after apply)
      + last_modified_time         = (known after apply)
      + location                   = "US"
      + max_time_travel_hours      = (known after apply)
      + project                    = "sinuous-studio-412717"
      + self_link                  = (known after apply)
      + storage_billing_model      = (known after apply)
      + terraform_labels           = (known after apply)
    }

  # google_storage_bucket.demo-bucket will be created
  + resource "google_storage_bucket" "demo-bucket" {
      + effective_labels            = (known after apply)
      + force_destroy               = true
      + id                          = (known after apply)
      + location                    = "US"
      + name                        = "sinuous-studio-412717-terra-bucket"
      + project                     = (known after apply)
      + public_access_prevention    = (known after apply)
      + self_link                   = (known after apply)
      + storage_class               = "STANDARD"
      + terraform_labels            = (known after apply)
      + uniform_bucket_level_access = (known after apply)
      + url                         = (known after apply)

      + lifecycle_rule {
          + action {
              + type = "AbortIncompleteMultipartUpload"
            }
          + condition {
              + age                   = 1
              + matches_prefix        = []
              + matches_storage_class = []
              + matches_suffix        = []
              + with_state            = (known after apply)
            }
        }
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

google_bigquery_dataset.demo_dataset: Creating...
google_storage_bucket.demo-bucket: Creating...
google_bigquery_dataset.demo_dataset: Creation complete after 2s [id=projects/sinuous-studio-412717/datasets/demo_dataset]
google_storage_bucket.demo-bucket: Creation complete after 3s [id=sinuous-studio-412717-terra-bucket]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```