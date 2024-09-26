#!/bin/bash

# Step 0: Download and preprocess the dataset
echo "Downloading and preparing the dataset..."
python download_and_prepare_dataset.py

# Step 1: Start Zookeeper
echo "Starting Zookeeper..."
kubectl apply -f zookeeper-statefulset.yaml

# Step 2: Start Kafka
echo "Starting Kafka..."
kubectl apply -f kafka-statefulset.yaml

# Step 3: Start Cassandra
echo "Starting Cassandra..."
kubectl apply -f cassandra-statefulset.yaml
sleep 10

echo "Creating Cassandra keyspace..."
kubectl exec -it cassandra-0 -- cqlsh -e "CREATE KEYSPACE IF NOT EXISTS nyc_taxi WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};"
sleep 5  # Ensure Cassandra is ready

# Step 4: Start Spark Streaming job
echo "Starting Spark Streaming job..."
kubectl apply -f spark-job.yaml

# Step 5: Start Kafka producer
echo "Starting Kafka producer..."
kubectl apply -f kafka-producer-job.yaml

# Step 6: Start Flask dashboard
echo "Starting Flask dashboard..."
kubectl apply -f flask-deployment.yaml

echo "All services are up and running."



########################################################################
#########################   VIRTUAL MACHINES   #########################
########################################################################

# Step 2: Start Zookeeper
# echo "Starting Zookeeper..."
# bin/zookeeper-server-start.sh config/zookeeper.properties > zookeeper.log 2>&1 &
# ZOOKEEPER_PID=$!
# sleep 10  # Wait for Zookeeper to start

# # Step 3: Start Kafka
# echo "Starting Kafka..."
# bin/kafka-server-start.sh config/server.properties > kafka.log 2>&1 &
# KAFKA_PID=$!
# sleep 15  # Wait for Kafka to start

# # Step 4: Start Spark Streaming job
# echo "Submitting Spark job..."
# spark-submit --master yarn --deploy-mode cluster spark_streaming.py > spark_streaming.log 2>&1 &
# SPARK_PID=$!
# sleep 10  # Wait for Spark to initialize

# # Step 5: Start Kafka producer
# echo "Starting Kafka producer..."
# python kafka_producer.py > kafka_producer.log 2>&1 &
# PRODUCER_PID=$!
# sleep 5  # Wait for Kafka producer to start

# # Step 6: Start Flask dashboard
# echo "Starting Flask dashboard..."
# python app.py > flask_dashboard.log 2>&1 &
# FLASK_PID=$!

# echo "All services are up and running."

# # Wait for user input to terminate services
# read -p "Press any key to stop services..."

# # Stop services in reverse order
# echo "Stopping Flask dashboard..."
# kill $FLASK_PID

# echo "Stopping Kafka producer..."
# kill $PRODUCER_PID

# echo "Stopping Spark job..."
# yarn application -kill $SPARK_PID

# echo "Stopping Kafka..."
# kill $KAFKA_PID

# echo "Stopping Zookeeper..."
# kill $ZOOKEEPER_PID

# echo "Pipeline shutdown complete."

