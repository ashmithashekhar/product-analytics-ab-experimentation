# Product Analytics A/B Experimentation

## Overview

This project demonstrates an **end-to-end A/B experiment analytics pipeline** similar to what a real product analytics or data science team builds in industry.

The goal of the project is to:

* analyze user behavior through a product funnel
* compare **control vs variant** conversion performance
* measure uplift and statistical strength
* visualize experiment results for stakeholders

The pipeline covers **data ingestion → SQL analytics → statistical evaluation → Python visualization**.

---

## What I Built

I built a complete experimentation workflow that:

1. Loads raw user, session, event, order, and experiment assignment data into **PostgreSQL**
2. Computes **funnel metrics** and **A/B conversion rates** using SQL
3. Calculates **uplift and z-score** for experiment evaluation
4. Exports analytics results to CSV
5. Visualizes results using **Python (pandas + matplotlib)**

---

## Tech Stack

### Data & Storage

* PostgreSQL
* CSV datasets (users, sessions, events, orders, experiment assignments)

### Analytics & Querying

* SQL (CTEs, JOINs, GROUP BY, FILTER, date_trunc)
* Funnel analysis
* A/B testing metrics (conversion, lift, z-score)

### Visualization

* Python
* pandas
* matplotlib

---

## Dataset Description

| Table                  | Description                                            |
| ---------------------- | ------------------------------------------------------ |
| users                  | User-level metadata                                    |
| sessions               | User sessions                                          |
| events                 | Product events (view, add_to_cart, checkout, purchase) |
| orders                 | Completed purchases                                    |
| experiment_assignments | Control / Variant assignment per user                  |

---

## Step-by-Step Workflow

### 1. Load Data into PostgreSQL

Data is loaded into PostgreSQL using SQL scripts:

```bash
psql -U postgres -d product_analytics -f sql/03_load.sql
```

Basic sanity checks confirm correct row counts and event distributions.

---

### 2. Funnel Analysis (SQL)

The product funnel is defined as:

```
view → add_to_cart → checkout → purchase
```

Using SQL conditional counts, I calculated:

* total users at each funnel stage
* drop-offs between stages

This highlights where users are most likely to abandon the flow.

---

### 3. A/B Conversion Analysis

To evaluate experiment impact:

* buyers are defined as users with a `purchase` event
* users are grouped by experiment variant (control vs variant)
* conversion rate is computed as:

```
conversion = buyers / users
```

---

### 4. Statistical Evaluation

To quantify experiment impact, I computed:

* **Absolute lift**: `p_variant - p_control`
* **Relative lift**: `(p_variant - p_control) / p_control`
* **Z-score** using pooled proportions

This provides evidence of whether the observed difference is meaningful.

---

### 5. Weekly Conversion Trends

To ensure results are stable over time:

* conversion rates are aggregated by week
* control and variant trends are compared

This helps detect volatility or seasonality effects.

---

### 6. Export Analytics Outputs

Key results are exported from PostgreSQL using `\copy`:

| File                      | Description                   |
| ------------------------- | ----------------------------- |
| funnel.csv                | Funnel stage counts           |
| conversion_by_variant.csv | Overall conversion comparison |
| weekly_conversion.csv     | Weekly conversion trends      |

---

### 7. Visualization (Python)

A Python script (`visualize_experiment.py`) loads CSV outputs and produces:

* **User Funnel Bar Chart**
* **Conversion Rate by Variant**
* **Weekly Conversion Trend Line Chart**

Run visualization:

```bash
python visualize_experiment.py
```

---

## Key Insights

* Significant drop-off occurs between `add_to_cart` and `checkout`
* Variant shows higher conversion rate than control
* Weekly trends indicate consistent performance over time

---

## How to Run This Project

### 1. Start PostgreSQL

```bash
psql -U postgres -d product_analytics
```

### 2. Load Data

```bash
psql -U postgres -d product_analytics -f sql/03_load.sql
```

### 3. Run Analytics Queries

Execute SQL files inside the `sql/` directory or run queries manually in psql.

### 4. Export CSVs

Use provided `\copy` queries to export results.

### 5. Visualize

```bash
pip install pandas matplotlib
python visualize_experiment.py
```

---

## Future Improvements

* Add confidence intervals and p-values
* Add retention and cohort analysis
* Automate reporting with dashboards (Tableau / Power BI)
* Add Bayesian A/B testing

---

## Author

**Ashmitha Shekhar**
End-to-End Product Analytics & Experimentation Project
