from flask import Flask, jsonify
from cassandra.cluster import Cluster

app = Flask(__name__)

# Cassandra connection
cluster = Cluster(['cassandra'])
session = cluster.connect('nyc_taxi')

@app.route('/dashboard')
def get_aggregated_data():
    query = "SELECT vendor_id, window_start, sum_fare_amount, sum_passenger_count, sum_trip_distance FROM aggregated_fares LIMIT 10"
    rows = session.execute(query)
    results = []
    for row in rows:
        results.append({
            'vendor_id': row.vendor_id,
            'window_start': row.window_start,
            'sum_fare_amount': row.sum_fare_amount,
            'sum_passenger_count': row.sum_passenger_count,
            'sum_trip_distance': row.sum_trip_distance
        })
    return jsonify(results)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)

