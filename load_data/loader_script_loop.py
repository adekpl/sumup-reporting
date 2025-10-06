import os
import pandas as pd
import snowflake.connector
from dotenv import load_dotenv

# --- Load environment variables ---
load_dotenv()

# --- Snowflake connection setup ---
conn = snowflake.connector.connect(
    user=os.getenv("SNOWFLAKE_USER"), # "sumup",        # from .env
    password=os.getenv("SNOWFLAKE_PASSWORD"), #"Sumup123sumup123!",# from .env
    account="riplfll-ej83096",               # your account (no need for .snowflakecomputing.com)
    warehouse="COMPUTE_WH",
    database="SUMUP",
    schema="RAW_DATA"
)
cs = conn.cursor()

# --- Folder where script (and Excel files) are located ---
folder_path = os.path.dirname(os.path.abspath(__file__))

# --- Find all Excel files in that folder ---
excel_files = [f for f in os.listdir(folder_path) if f.lower().endswith(".xlsx")]

if not excel_files:
    print("⚠️ No Excel files found in this folder.")
else:
    print(f"Found {len(excel_files)} Excel files: {excel_files}")

# --- Process each Excel file ---
for file in excel_files:
    file_path = os.path.join(folder_path, file)
    print(f"\n📂 Uploading {file_path} ...")

    # Load Excel into DataFrame
    df = pd.read_excel(file_path)
    if df.empty:
        print(f"⚠️ Skipping {file} (empty file)")
        continue

    # Create table name based on file name (without extension)
    table_name = os.path.splitext(file)[0].upper()  # e.g. "stores.xlsx" -> "STORES"

    # Create table dynamically (VARCHAR columns)
    drop_table_sql = f'DROP TABLE IF EXISTS TABLE {table_name}'
    columns = ", ".join([f'"{col}" VARCHAR' for col in df.columns])
    create_sql = f'CREATE OR REPLACE TABLE {table_name} ({columns})'
    cs.execute(create_sql)

    # Insert data row by row (good for small Excel files)
    for _, row in df.iterrows():
        values = "', '".join([str(v).replace("'", "''") for v in row.values])
        insert_sql = f"INSERT INTO {table_name} VALUES ('{values}')"
        cs.execute(insert_sql)

    conn.commit()
    print(f"✅ Uploaded {len(df)} rows into {table_name}")

cs.close()
conn.close()

print("\n🎉 All Excel files uploaded successfully!")
