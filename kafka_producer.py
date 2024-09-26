from kafka import KafkaProducer
import pandas as pd
import json
import time

# Kafka Producer Configuration
producer = KafkaProducer(
    bootstrap_servers='kafka-0.kafka.default.svc.cluster.local:9092',
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

# Load the preprocessed dataset
df = pd.read_csv('data/yellow_tripdata_2023-01_preprocessed.csv')

# Stream data row by row into Kafka topic
for _, row in df.iterrows():
    producer.send('nyc_taxi_topic', row.to_dict())
    time.sleep(0.01)  # Simulate real-time streaming

producer.flush()

