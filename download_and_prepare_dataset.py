import requests
import os
import pandas as pd

# URL for the dataset (Parquet format)
dataset_url = 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2023-01.parquet'

# Directory for storing the dataset
data_dir = 'data/'
os.makedirs(data_dir, exist_ok=True)

# Filepath for the downloaded file
parquet_file_path = os.path.join(data_dir, 'yellow_tripdata_2023-01.parquet')

# Download the Parquet file
print("Downloading dataset...")
response = requests.get(dataset_url)
with open(parquet_file_path, 'wb') as file:
    file.write(response.content)

print("Dataset downloaded.")

# Preprocessing: Load the Parquet file and check for data consistency
print("Preprocessing dataset...")
df = pd.read_parquet(parquet_file_path)

# Filter and clean necessary columns
df_filtered = df[[
    'VendorID', 'tpep_pickup_datetime', 'tpep_dropoff_datetime',
    'passenger_count', 'trip_distance', 'fare_amount', 'extra',
    'mta_tax', 'tip_amount', 'tolls_amount', 'improvement_surcharge',
    'total_amount', 'payment_type', 'congestion_surcharge', 'airport_fee'
]]

# Save the preprocessed dataset as CSV
preprocessed_file_path = os.path.join(data_dir, 'yellow_tripdata_2023-01_preprocessed.csv')
df_filtered.to_csv(preprocessed_file_path, index=False)

print(f"Dataset preprocessed and saved to {preprocessed_file_path}.")

