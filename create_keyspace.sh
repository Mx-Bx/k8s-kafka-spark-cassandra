#!/bin/bash

echo "Creating Cassandra keyspace..."
kubectl exec -it cassandra-0 -- cqlsh -e "CREATE KEYSPACE IF NOT EXISTS nyc_taxi WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};"
sleep 5  # Ensure Cassandra is ready
