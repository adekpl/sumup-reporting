# 🧾 SumUp Reporting — Snowflake + dbt + Python ETL

This repository contains the complete **ETL and analytics pipeline** for loading Excel data into **Snowflake**, transforming it with **dbt**, and producing **reporting-ready tables** for BI and analytics.

---

## 📁 Repository Structure

sumup-reporting/
├── load_data/                  # Python scripts to load Excel files into Snowflake
│   ├── upload_excels.py
│   └── ...
│
├── sumup_dbt/                  # dbt project folder
│   ├── dbt_project.yml
│   ├── models/
│   │   ├── staging/            # staging models (raw → cleaned)
│   │   ├── marts/
│   │   │   ├── dimensions/     # dimension tables (dim_stores, dim_devices, etc.)
│   │   │   ├── facts/          # fact tables (fact_transactions)
│   │   │   └── reports/        # reporting models (reporting_base, sales_summary)
│   └── ...
│
├── logs/                       # optional logs or ETL run outputs
├── .env                        # environment variables (excluded from Git)
└── README.md                   # project documentation


### 📦 Components

- **`load_data/`** — Python scripts to ingest `.xlsx` files into **RAW_DATA** schema in Snowflake  
- **`sumup_dbt/`** — dbt project containing staging, dimension, fact, and reporting models  
- **`.env`** — local environment variables (Snowflake credentials)  
- **`logs/`** — optional logs directory for ETL job outputs  

---

## ⚙️ Getting Started

### Prerequisites

Make sure you have installed:

- Python **3.8+**
- [`dbt-snowflake`](https://docs.getdbt.com/docs/core/connect-data-platform/snowflake)
- `pandas`
- `snowflake-connector-python`
- `python-dotenv`
- Access to a **Snowflake account** with write permissions

---

### 🧰 Installation

```bash
# 1. Clone the repository
git clone https://github.com/adekpl/sumup-reporting.git
cd sumup-reporting

# 2. Install Python dependencies
pip install pandas snowflake-connector-python python-dotenv

# 3. Install dbt for Snowflake
pip install dbt-snowflake


🔑 Configuration
1️⃣ Environment Variables

Create a .env file in the project root:

SNOWFLAKE_USER=your_username
SNOWFLAKE_PASSWORD=your_password

2️⃣ dbt Profile

In your ~/.dbt/profiles.yml, configure the Snowflake connection:

sumup_dbt:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: riplfll-ej83096
      user: "{{ env_var('SNOWFLAKE_USER') }}"
      password: "{{ env_var('SNOWFLAKE_PASSWORD') }}"
      role: ACCOUNTADMIN
      warehouse: COMPUTE_WH
      database: SUMUP
      schema: RAW_DATA
      threads: 4
      client_session_keep_alive: False

🚀 Usage
1️⃣ Load Excel Files into Snowflake

Place all your .xlsx files (e.g. transactions.xlsx, devices.xlsx, stores.xlsx) in the same folder as your Python script, then run:

python load_data/upload_excels.py


✅ This will:

Read all Excel files in the directory

Create/replace tables in your RAW_DATA schema

Upload their contents row-by-row or via bulk COPY INTO

2️⃣ Run dbt Transformations

Move to your dbt project folder:

cd sumup_dbt
dbt run
dbt test


✅ dbt will:

Build staging models (stg_transactions, stg_stores, stg_devices)

Build dimension tables (dim_stores, dim_devices, dim_products, dim_credit_cards)

Build the fact table (fact_transactions)

Join everything into reporting models (reporting_base, report_sales_summary)

3️⃣ Generate Documentation
dbt docs generate
dbt docs serve


Then open your browser at the provided link — you’ll see interactive documentation and data lineage.

📊 Data Model Overview
Layer	Model	Description
Staging	stg_transactions, stg_stores, stg_devices	Cleaned raw Snowflake tables
Dimensions	dim_stores, dim_devices, dim_products, dim_credit_cards	Master data lookup tables
Fact	fact_transactions	Core transactional data (links to all dimensions)
Reports	transaction_report	Ready for BI tools

✅ Data Quality & Testing

All .yml files include dbt tests for:

not_null

unique

relationships between facts and dimensions

accepted_values (e.g. country, device type, status)

accepted_range for numeric columns

Run them anytime with:

dbt test

🔒 Security Best Practices

❌ Do not commit .env or credentials to GitHub

Use {{ env_var('SNOWFLAKE_PASSWORD') }} in profiles.yml

For sensitive columns (e.g. card numbers), use hashing:

TO_HEX(HASH_SHA256(CONCAT(card_number, cvv)))


Restrict access to raw staging schemas if they contain PII

📈 Example Workflow
# 1. Add Excel files
cp transactions.xlsx load_data/

# 2. Upload data to Snowflake
python load_data/upload_excels.py

# 3. Run dbt transformations
dbt run

# 4. Validate and test data
dbt test

# 5. Generate documentation site
dbt docs generate && dbt docs serve

🧠 Future Enhancements

Add CI/CD integration (GitHub Actions) for automatic dbt runs

Implement incremental models for larger datasets

Add snapshot models for historical tracking

Add data freshness tests and daily scheduling


