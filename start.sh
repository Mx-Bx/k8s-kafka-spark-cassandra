#!/bin/bash

# Step 1: Start Zookeeper
echo "Starting Zookeeper..."
kubectl apply -f zookeeper-statefulset.yaml

# Step 2: Start Kafka
echo "Starting Kafka..."
kubectl apply -f kafka-statefulset.yaml

# Step 3: Start Cassandra
echo "Starting Cassandra..."
kubectl apply -f cassandra-statefulset.yaml

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

