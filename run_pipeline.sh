#!/bin/bash

# Step 1: Download and preprocess the dataset
echo "Downloading and preparing the dataset..."
python download_and_prepare_dataset.py

# Step 2: Start Zookeeper
echo "Starting Zookeeper..."
bin/zookeeper-server-start.sh config/zookeeper.properties > zookeeper.log 2>&1 &
ZOOKEEPER_PID=$!
sleep 10  # Wait for Zookeeper to start

# Step 3: Start Kafka
echo "Starting Kafka..."
bin/kafka-server-start.sh config/server.properties > kafka.log 2>&1 &
KAFKA_PID=$!
sleep 15  # Wait for Kafka to start

# Step 4: Start Spark Streaming job
echo "Submitting Spark job..."
spark-submit --master yarn --deploy-mode cluster spark_streaming.py > spark_streaming.log 2>&1 &
SPARK_PID=$!
sleep 10  # Wait for Spark to initialize

# Step 5: Start Kafka producer
echo "Starting Kafka producer..."
python kafka_producer.py > kafka_producer.log 2>&1 &
PRODUCER_PID=$!
sleep 5  # Wait for Kafka producer to start

# Step 6: Start Flask dashboard
echo "Starting Flask dashboard..."
python app.py > flask_dashboard.log 2>&1 &
FLASK_PID=$!

echo "All services are up and running."

# Wait for user input to terminate services
read -p "Press any key to stop services..."

# Stop services in reverse order
echo "Stopping Flask dashboard..."
kill $FLASK_PID

echo "Stopping Kafka producer..."
kill $PRODUCER_PID

echo "Stopping Spark job..."
yarn application -kill $SPARK_PID

echo "Stopping Kafka..."
kill $KAFKA_PID

echo "Stopping Zookeeper..."
kill $ZOOKEEPER_PID

echo "Pipeline shutdown complete."

