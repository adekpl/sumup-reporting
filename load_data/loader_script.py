import os
import pandas as pd
import snowflake.connector
from dotenv import load_dotenv

print("Current working directory:", os.getcwd())

# Load environment variables from .env file
load_dotenv()


# 1. Load Excel file into pandas DataFrame
file_path = "/Users/adrianpietrzykowski/apps/sumup/load_data/stores.xlsx"   # change to your file path
df = pd.read_excel(file_path)

# 2. Connect to Snowflake using environment variables
conn = snowflake.connector.connect(
    user="sumup", # os.getenv("sumup"),
    password="Sumup123sumup123!", # os.getenv("Sumup123sumup123!"),
    account="riplfll-ej83096",  # account identifier (without .snowflakecomputing.com)
    warehouse="COMPUTE_WH",     # change if you use another warehouse
    database="SUMUP",
    schema="RAW_DATA"
)

cs = conn.cursor()

# 3. Create target table
table_name = "stores"

# Automatically create VARCHAR columns based on Excel headers
columns = ", ".join([f'"{col}" VARCHAR' for col in df.columns])
create_sql = f'CREATE OR REPLACE TABLE {table_name} ({columns})'
cs.execute(create_sql)

# 4. Insert rows (row-by-row, fine for small Excel)
for _, row in df.iterrows():
    values = "', '".join([str(v).replace("'", "''") for v in row.values])
    insert_sql = f"INSERT INTO {table_name} VALUES ('{values}')"
    cs.execute(insert_sql)

conn.commit()
cs.close()
conn.close()

print("✅ Excel data uploaded to Snowflake successfully!")
