from pyspark.sql import SparkSession
from pyspark.sql.functions import from_json, col, window
from pyspark.sql.types import StructType, StringType, FloatType, IntegerType, TimestampType

# Initialize Spark session
spark = SparkSession.builder \
    .appName("Kafka-Spark-Cassandra") \
    .config("spark.cassandra.connection.host", "cassandra") \
    .getOrCreate()

# Define the schema for the dataset
schema = StructType() \
    .add("VendorID", IntegerType()) \
    .add("tpep_pickup_datetime", TimestampType()) \
    .add("tpep_dropoff_datetime", TimestampType()) \
    .add("passenger_count", FloatType()) \
    .add("trip_distance", FloatType()) \
    .add("fare_amount", FloatType()) \
    .add("extra", FloatType()) \
    .add("mta_tax", FloatType()) \
    .add("tip_amount", FloatType()) \
    .add("tolls_amount", FloatType()) \
    .add("improvement_surcharge", FloatType()) \
    .add("total_amount", FloatType()) \
    .add("payment_type", IntegerType()) \
    .add("congestion_surcharge", FloatType()) \
    .add("airport_fee", FloatType())

# Read data from Kafka
df = spark \
    .readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", "kafka-0.kafka.default.svc.cluster.local:9092") \
    .option("subscribe", "nyc_taxi_topic") \
    .load() \
    .selectExpr("CAST(value AS STRING)") \
    .select(from_json(col("value"), schema).alias("data")) \
    .select("data.*")

# Perform window-based aggregation
agg_df = df \
    .withWatermark("tpep_pickup_datetime", "1 minute") \
    .groupBy(window("tpep_pickup_datetime", "5 minutes"), "VendorID") \
    .agg({"fare_amount": "sum", "passenger_count": "sum", "trip_distance": "sum"})

# Write aggregated data to Cassandra
agg_df.writeStream \
    .format("org.apache.spark.sql.cassandra") \
    .option("keyspace", "nyc_taxi") \
    .option("table", "aggregated_fares") \
    .outputMode("update") \
    .start() \
    .awaitTermination()

