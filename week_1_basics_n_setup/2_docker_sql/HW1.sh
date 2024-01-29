# Q1: Which tag has the following text? - Automatically remove the container when it exits
docker build --help
docker run --help
# --rm
# ---------------

# Q2: What is version of the package wheel ?
docker run -it --entrypoint=bash python:3.9
pip list

# 0.42.0
# ---------------

# Q3:

# 1)
docker-compose up

# 2)
docker build -t taxi_ingest:v001 .

# 3)
URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-09.csv.gz"
docker run -it \
  taxi_ingest:v001 \
    --user=root \
    --password=root \
    --host=pgdatabase \
    --port=5432 \
    --db=ny_taxi \
    --table_name=green_taxi_trips \
    --url=${URL}

python ingest_data.py \
	--user=root \
	--password=root \
	--host=localhost \
	--port=5432 \
	--db=ny_taxi \
	--table_name=green_taxi_trips \
	--url=${URL}

# for test: pgcli -h localhost -p 5432 -u root -d ny_taxi

# 4)
URL="https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv"
docker run -it \
  taxi_ingest:v001 \
    --user=root \
    --password=root \
    --host=pgdatabase \
    --port=5432 \
    --db=ny_taxi \
    --table_name=zones \
    --url=${URL}

# ---------------
# SQL


# 3
# SELECT count(*)
# from green_taxi_trips
# where lpep_pickup_datetime >= TO_TIMESTAMP('2019/09/18 00:00:0', 'YYYY/MM/DD HH24:MI:ss')
# and lpep_dropoff_datetime <= TO_TIMESTAMP('2019/09/18 23:59:59', 'YYYY/MM/DD HH24:MI:ss')

# 15612

# 4
# SELECT lpep_pickup_datetime,max(trip_distance) as max_Dist
# from green_taxi_trips
# group by lpep_pickup_datetime
# order by max_Dist desc
# limit 1;

# 2019-09-26

# 5
# SELECT passenger_count,count(1)
# from green_taxi_trips
# where  lpep_pickup_datetime >= TO_TIMESTAMP('2019/09/18 00:00:0', 'YYYY/MM/DD HH24:MI:ss')
# and lpep_pickup_datetime <= TO_TIMESTAMP('2019/09/18 23:59:59', 'YYYY/MM/DD HH24:MI:ss')
# and (passenger_count =2 or passenger_count =3)
# group by passenger_count;

# A: 2: 1282 ; 3: 254

# 6
# select "drtz"."Zone",max(tip_amount) as max_tip
# from taxi_zones "pultz"
# inner join green_taxi_trips "tg"
# on "pultz"."LocationID" = "tg"."PULocationID"
# inner join taxi_zones "drtz"
# on "drtz"."LocationID" = "tg"."DOLocationID"
# where "pultz"."Zone" = 'Astoria'
# group by "drtz"."Zone"
# order by max_tip desc
# limit 1;

# JFK Airport