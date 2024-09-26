#!/bin/bash

# Step 1: Stop Flask dashboard
echo "Stopping Flask dashboard..."
kubectl delete deployment flask-dashboard

# Step 2: Stop Kafka producer job
echo "Stopping Kafka producer job..."
kubectl delete job kafka-producer

# Step 3: Stop Spark Streaming job
echo "Stopping Spark Streaming job..."
kubectl delete job spark-job

# Step 4: Stop Kafka
echo "Stopping Kafka..."
kubectl delete statefulset kafka

# Step 5: Stop Zookeeper
echo "Stopping Zookeeper..."
kubectl delete statefulset zookeeper

# Step 6: Stop Cassandra
echo "Stopping Cassandra..."
kubectl delete statefulset cassandra

echo "All services are stopped."

