這份 notebook 是 Capstone Project 第 1 部分，聚焦於 **ETL pipeline 和 Data Modeling**，使用的技術包括 AWS Glue、Terraform、dbt 和 Redshift。以下是根據該 Lab 撰寫的詳盡學習筆記：

---

## 🧠 學習筆記：Capstone Project Part 1 - ETL and Data Modeling

### 🎯 目標與背景

DeFtunes 是一家新創音樂公司，除了提供串流服務，也開始販售數位音樂。公司需要一條 **完整的資料管線** 來處理購買紀錄與歌曲資訊，目的在於：

* 從 API 和資料庫提取資料。
* 建立 Medallion 架構（Landing → Transformation → Serving）。
* 使用 S3、Iceberg、Redshift 儲存並處理資料。
* 使用 Terraform 部署基礎設施。
* 使用 dbt 建立 Star Schema 供分析團隊使用。

---

### 🗂️ 架構與資料流程設計

**1. 架構圖重點：**

* **Landing Zone**：原始資料從 API 或資料庫匯入 S3。
* **Transformation Zone**：用 AWS Glue 清洗轉換資料並儲存為 Iceberg 表格。
* **Serving Zone**：將轉換後資料移至 Redshift（Gold Layer），並用 dbt 建立 Star Schema 模型。

---

### 📦 ETL 與 Data Lake 區段

#### 1. 資料來源與探索

* 使用 Python 調用 API，獲取 JSON 格式資料。
* 使用 `pandas` 快速檢視欄位、資料型別與缺漏值。

```python
import json
import requests
import pandas as pd

# 簡單的 API 請求
response = requests.get("API_ENDPOINT")
data = response.json()
df = pd.DataFrame(data)
```

#### 2. 建立 Landing Zone（S3）

* 使用 AWS CLI 或 Terraform 建立 S3 bucket。
* 原始資料放入 `landing/` 子資料夾。

#### 3. Transformation Zone

* 建立 Glue Job：

  * 使用 Spark（Glue 提供的 Spark 環境）。
  * 清理資料（空值、資料型別轉換）。
  * 儲存為 Apache Iceberg 格式於 `transform/`。

#### 4. Serving Zone

* 使用 Glue 將處理後資料移至 Redshift Spectrum 可讀格式。
* 資料依 Star Schema 儲存：

  * Fact 購買紀錄表格
  * Dim 歌曲、藝人等維度表格

---

### 🧰 基礎建設（Infrastructure as Code）

#### Terraform 模組：

* 建立以下資源：

  * S3 bucket
  * IAM Role（給 Glue 使用）
  * Glue Jobs
  * Redshift cluster
* 使用 `terraform apply` 部署後，整個資料管線架構立即成形。

---

### 🧱 資料建模（dbt）

#### 步驟：

1. 設定 `profiles.yml`，連接 Redshift。
2. 建立 dbt project，撰寫 model SQL 檔案。
3. 使用 jinja macro 寫維度與事實表。
4. `dbt run` 自動產出 Redshift 中的 star schema。

範例：

```sql
-- models/fact_sales.sql
select
  s.purchase_id,
  s.user_id,
  s.song_id,
  s.purchase_date,
  s.amount
from {{ ref('stg_purchases') }} s
```

---

### ✅ 學到的關鍵點

| 技術                 | 學習內容                                             |
| ------------------ | ------------------------------------------------ |
| **AWS Glue**       | 使用 Spark script 進行 ETL，處理 JSON / CSV，寫入 Iceberg。 |
| **Terraform**      | 用於快速部署 Glue Job、S3、IAM Role 等基礎設施。               |
| **Medallion 架構**   | 清楚區分 Raw、Cleaned、Modelled 資料儲存層次。                |
| **Iceberg Tables** | 用於建立版本控制、支援 ACID 的 Data Lake 表格格式。               |
| **dbt**            | 將資料建模轉為標準流程化工作，便於維運與測試。                          |
| **Star Schema**    | 提升查詢效能，供報表與資料視覺化分析使用。                            |

---

---

## 🚀 完整 ETL Pipeline 與架構解析（DeFtunes Project）

這個專案將資料從 **RDS + API** 經過三層架構（Landing → Transformation → Serving）轉換成供分析使用的 Star Schema，並利用 Glue、S3、Iceberg、Redshift、dbt、Terraform 等技術實作。

---

### 🗺 架構概覽

```text
┌────────────────────────┐
│      Source Systems    │
│ - RDS (songs metadata) │
│ - API (users/sessions) │
└──────────┬─────────────┘
           │
     Extract with Glue Jobs
           ↓
┌────────────────────────┐
│     Landing Zone (S3)  │ ← 原始 JSON/CSV
└──────────┬─────────────┘
     Glue Cleansing Job
           ↓
┌─────────────────────────────┐
│ Transformation Zone (S3 +  │
│ Iceberg via Data Catalog)  │ ← 表格化 (parquet + schema)
└──────────┬──────────────────┘
   Redshift Spectrum Query
           ↓
┌─────────────────────────────┐
│     Serving Zone (Redshift) │ ← dbt + Star Schema
└─────────────────────────────┘
```

---

### 🧩 各個技術角色與互動細節

---

#### 1. **Landing Zone (Raw Layer in S3)**

* **來源**：

  * PostgreSQL (RDS): `deftunes.songs` 表格。
  * REST API: `/users`, `/sessions`
* **處理流程**：

  * 使用 Glue Job（PySpark）分別從 RDS 與 API 抽取資料。
  * 將原始 JSON 儲存到 S3 的 `landing/` 子目錄。
* **資料格式**：JSON、CSV

```python
requests.get("http://{API_ENDPOINT}/sessions")
```

---

#### 2. **Transformation Zone (Silver Layer with Apache Iceberg)**

* **Glue Job** 將 landing zone 的 raw data：

  * 轉換為結構化 schema（cast、explode nested fields）。
  * 寫入 Iceberg 表格（格式為 Parquet，支援 ACID）。
* **使用 AWS Glue Data Catalog** 建立 schema 定義與 table metadata。
* **Schema 存儲方式**：

  * `iceberg_users`, `iceberg_sessions`, `iceberg_songs` 等 Glue 表格（透過 catalog 查詢）。

🔎 **Data Catalog 的用途**：

* 儲存每個 table 的 schema。
* Glue / Athena / Redshift Spectrum 可以查詢 catalog 表格。
* 整個 schema evolution 支援 versioned metadata。

```python
DynamicFrame → cast → write_dynamic_frame.from_options( format="iceberg" )
```

---

#### 3. **Serving Zone (Gold Layer with Redshift + dbt)**

##### ✳ Redshift Spectrum 介入方式：

* Spectrum 允許 Redshift 查詢 S3 中由 Glue Data Catalog 管理的 Iceberg 表格。
* `CREATE EXTERNAL SCHEMA` 映射 Glue catalog 中的資料進 Redshift：

```sql
CREATE EXTERNAL SCHEMA iceberg_schema
FROM data catalog
DATABASE 'deftunes_catalog'
IAM_ROLE 'arn:aws:iam::xxx:role/RedshiftRole';
```

🔁 Redshift Spectrum 的角色：

* 作為中介層讓 Redshift 能查詢 S3 中轉換後的資料。
* 無需移動資料，即可 SQL 查詢。

---

##### 🧱 使用 dbt 做 Star Schema 建模

* 在 dbt 專案中建立以下模型：

  * `dim_users`, `dim_songs`, `fact_sessions`
* 模型來自 Glue Iceberg 表格（透過 Spectrum 查詢）。
* 執行 `dbt run` 時，SQL 查詢會透過 Spectrum 從 S3 抓資料，然後結果會 **物化（materialize）在 Redshift 中的內部表格中**。

---

### 🌟 Star Schema 使用方式

| 角色              | 資料來源                             | 建立方式                 |
| --------------- | -------------------------------- | -------------------- |
| `dim_users`     | API `/users` → Glue → Iceberg    | dbt 處理後轉為 Redshift 表 |
| `dim_songs`     | RDS `songs` → Glue → Iceberg     | dbt 處理後轉為 Redshift 表 |
| `fact_sessions` | API `/sessions` → Glue → Iceberg | dbt 處理後轉為 Redshift 表 |

dbt 用來：

* join 多張表格
* 建立 surrogate key
* 使用 Jinja macro 做資料型別轉換
* 自動建立與測試模型

---

### 🔁 資料在各層的變化流程

| 層級            | 原始資料 → 處理步驟 → 結果格式                                   |                       |
| ------------- | ---------------------------------------------------- | --------------------- |
| **Landing**   | JSON / CSV → S3 儲存                                   | 非結構化資料                |
| **Transform** | Glue Job (cast, filter) → Iceberg 表格                 | 結構化 Parquet 格式        |
| **Serving**   | Redshift Spectrum 查詢 → dbt Materialize → Redshift 表格 | Star Schema 表格，供分析師使用 |

---

### 🛠️ Terraform 基礎建設管理

Terraform 管理下列資源：

| 資源                       | 用途                        |
| ------------------------ | ------------------------- |
| `aws_s3_bucket`          | 資料湖分區（landing, transform） |
| `aws_glue_job`           | extract, transform job    |
| `aws_glue_catalog_table` | schema 管理                 |
| `aws_redshift_cluster`   | 資料倉儲                      |
| `aws_iam_role`           | Glue 與 Redshift 的角色存取權限   |

---

### ✅ 小結：各層互動摘要

| 層級        | 技術組件                        | 關鍵處理                |
| --------- | --------------------------- | ------------------- |
| Landing   | S3, Glue extract job        | 抽取原始資料並儲存           |
| Transform | Glue, Iceberg, Data Catalog | 清洗轉換並註冊 schema      |
| Serving   | Redshift + dbt + Spectrum   | 建模轉為 star schema 表格 |

---
