# Operational Lead Time Analysis: Measuring Variability and Operational Impact in Humanitarian Supply Chains

## Why This Project Matters

> In humanitarian supply chains, operational predictability can be as critical as speed. This analysis provides a framework for distinguishing between the two, enabling data-driven decisions about where to focus process improvement efforts.

---

## Project Overview

This project analyzes shipment Lead Time across transportation modes using SQL, MySQL and Microsoft Power BI.

The objective is to identify which transportation modes exhibit the greatest operational variability and assess that variability in the context of overall shipment volume.

Rather than relying on a single performance metric, the analysis combines shipment volume, volume share, median Lead Time and standard deviation to distinguish typical operational performance from variability and operational impact.

The project follows an end-to-end analytics workflow:

**Data Quality Assessment → Data Preparation → SQL Analysis → Exploratory Data Analysis → Statistical Analysis → Power BI Dashboard → Business Interpretation**

---

## Quick Stats

| Metric | Value |
|--------|-------|
| Records Analyzed | 4,587 |
| Transportation Modes | 5 |
| Dashboard Pages | 2 |
| Key Insight | Volume + Variability = True Impact |

---

## Business Question

> **What shipment modes exhibit the highest operational variability, and what is their impact within the overall shipment volume?**

This question guided the analytical process from data preparation through the final Power BI dashboard.

The analysis focuses on the relationship between:

- Shipment volume
- Volume share
- Typical Lead Time
- Operational variability
- Potential operational impact

---

## Dataset

The dataset contains shipment-level operational records including transportation mode, purchase order dates, delivery dates and other shipment-related attributes.

The analysis focused primarily on:

- Shipment ID
- Shipment Mode
- PO Sent to Vendor Date
- Delivered to Client Date
- Lead Time in days

### Lead Time Definition

Lead Time was calculated as:

**Lead Time = Delivered to Client Date − PO Sent to Vendor Date**

After data validation and preparation, the final analytical dataset contains:

**4,587 shipment records.**

---

# Data Quality

Data quality was treated as an analytical consideration rather than only a technical preprocessing step.

The data preparation process identified several issues, including:

- Missing purchase order dates
- Invalid or incomplete date values
- Invalid Lead Time observations
- Unspecified transportation modes
- Extreme Lead Time observations

### Unspecified Shipment Modes

Records originally classified as `N/A` were grouped under:

**Other / Unspecified**

This preserves the underlying information while presenting a cleaner and more professional analytical category in the dashboard.

### Extreme Observations

Extreme Lead Time observations were not arbitrarily removed simply because their values were high.

Instead, they were retained and evaluated through descriptive statistics and operational context.

An extreme value may represent:

- A genuine operational event
- An unusual shipment
- A data-quality issue
- A process exception requiring further investigation

---

# Analytical Approach

The analysis evaluates transportation modes using complementary dimensions.

## Shipment Volume

The number of shipments associated with each transportation mode establishes the operational scale of each mode.

## Median Lead Time

Median Lead Time was prioritized when interpreting typical operational performance.

The median is less sensitive to extreme observations than the arithmetic mean and therefore provides a more representative view of typical shipment performance when distributions are highly variable.

## Standard Deviation

Standard deviation was used to assess dispersion in Lead Time.

A higher standard deviation indicates greater variability around typical performance and therefore potentially lower predictability.

The Power BI dashboard uses the final validated standard-deviation measure consistently with the analytical dataset.

## Operational Impact

Variability was interpreted together with shipment volume and volume share.

A transportation mode with high variability but very low shipment volume does not necessarily have the same overall operational impact as a mode with substantial variability representing a large proportion of total operations.

---

# Methodological Decision: No Arbitrary SLA Thresholds

The dataset does not provide standardized formal Service Level Agreements (SLAs) by transportation channel.

Therefore, the analysis does not impose an arbitrary fixed threshold to classify shipments as "late" or "on time."

For example, a universal threshold such as 120 days would not necessarily be comparable across Air, Ocean and Truck transportation.

Instead, the analysis prioritizes:

- Median Lead Time
- Standard deviation
- Shipment volume
- Volume share
- Lead Time distribution
- Minimum and maximum Lead Time

> **Due to the absence of standardized formal SLAs by transportation channel in the raw dataset, the analysis prioritized distribution-based comparisons using median Lead Time, variability measures and absolute shipment volumes rather than imposing arbitrary performance thresholds.**

This approach avoids introducing unsupported performance assumptions into the analysis.

---

# Key Findings

## Air

Air represents the largest transportation mode in the dataset:

- **3,367 shipments**
- **73.4% of total volume**
- Median Lead Time: **99 days**
- Standard deviation: **67.9 days**

Because Air represents nearly three quarters of total shipment volume, its operational variability is particularly relevant when assessing overall operational impact.

---

## Truck

Truck represents:

- **792 shipments**
- **17.3% of total volume**
- Median Lead Time: **4 days**
- Standard deviation: **98.1 days**

Truck presents an important operational pattern.

Its median Lead Time is only 4 days, suggesting fast typical performance.

However, its standard deviation is the highest among the transportation modes analyzed.

This indicates substantial dispersion around typical performance and suggests that the primary concern may be **unpredictability rather than consistently long Lead Time**.

---

## Ocean

Ocean represents:

- **366 shipments**
- **8.0% of total volume**
- Median Lead Time: **167 days**
- Standard deviation: **61.8 days**

Ocean has the highest median Lead Time among the major transportation modes.

However, Ocean represents only 8.0% of total shipment volume.

Its Lead Time should therefore be interpreted together with its lower operational scale rather than evaluated using the median alone.

---

## Other / Unspecified

Records originally classified as `N/A` were grouped under **Other / Unspecified**.

This category represents:

- **44 shipments**
- **1.0% of total volume**
- Median Lead Time: **3.5 days**
- Standard deviation: **37.3 days**

Because this category represents only a small proportion of total volume, its overall operational impact is limited within the current dataset.

---

## Air Charter

Air Charter represents:

- **18 shipments**
- **0.4% of total volume**
- Median Lead Time: **64 days**
- Standard deviation: **29.9 days**

Due to its very small sample size, Air Charter should be interpreted cautiously and should not be directly compared with high-volume transportation modes without considering sample size.

---

# Key Analytical Insight

The analysis demonstrates why operational variability should not be evaluated using a single metric.

Different transportation modes exhibit different combinations of:

**Volume + Typical Lead Time + Variability**

For example:

- **Truck** has the highest variability while representing 17.3% of total volume.
- **Air** represents 73.4% of total volume and therefore has the greatest operational exposure by scale.
- **Ocean** has the highest median Lead Time but represents only 8.0% of total volume.

Therefore, the transportation mode with the highest individual variability is not automatically the transportation mode with the greatest overall operational impact.

The analysis highlights the importance of evaluating **variability together with operational scale**.

---

# Power BI Dashboard

The Power BI report contains two analytical pages.

## Page 1 — Executive Summary

The Executive Summary provides a high-level view of the operational dataset.

It includes:

- Total Shipments
- Average Lead Time
- Median Lead Time
- Maximum Lead Time
- Lead Time distribution
- Shipment Volume vs. Median Lead Time by Mode

The purpose of this page is to allow decision-makers to quickly understand the overall operational profile and identify the transportation modes requiring further attention.

---

## Page 2 — Variability & Operational Impact

The second page focuses directly on the project's business question.

It provides a deeper comparison of transportation modes using:

- Shipment volume
- Volume share
- Median Lead Time
- Standard deviation
- Minimum Lead Time
- Maximum Lead Time

The page combines visual analysis with a detailed analytical table to support interpretation of both operational variability and operational scale.

---

# Business Interpretation

The analysis indicates that transportation modes should not be evaluated using a single performance measure.

A transportation mode can exhibit:

- High Lead Time but relatively stable performance
- Low median Lead Time but extreme variability
- High variability but lower operational volume
- Moderate variability combined with very high operational volume

Therefore, operational performance should be evaluated through a combination of:

**Central Tendency + Dispersion + Operational Scale**

A key distinction in this analysis is between:

> **How long shipments typically take**

and:

> **How predictable the process is.**

For operational planning, unpredictability can be relevant even when typical Lead Time appears relatively low.

---

# Business Implications

## 1. Truck variability

Truck has the highest observed variability while maintaining a very low median Lead Time.

This suggests an opportunity for further investigation into the sources of dispersion rather than simply attempting to reduce average transit time.

Potential dimensions for further analysis could include:

- Routes
- Suppliers
- Destinations
- Order characteristics
- Process exceptions

## 2. Air operational exposure

Air represents 73.4% of total shipment volume.

Because of its operational scale, improvements in Air process predictability could potentially have a significant impact on overall operations.

## 3. Ocean Lead Time

Ocean has the highest median Lead Time at 167 days.

Further investigation could determine whether this reflects expected characteristics of ocean transportation or operational inefficiencies within specific routes, suppliers or processes.

## 4. Extreme observations

Extreme Lead Time values should be investigated individually before being used to support operational decisions.

---

# What I Would Do Next

Given more time or additional data access, I would:

1. **Investigate Truck variability drivers** by analyzing variability at the route, supplier and destination level to identify specific sources of unpredictability.

2. **Analyze seasonality patterns** in Air shipments to determine whether variability is consistent throughout the year or concentrated in specific periods.

3. **Validate findings with operations teams** to establish realistic SLAs by transportation mode based on empirical distributions rather than arbitrary thresholds.

4. **Build a predictive model** to estimate Lead Time ranges by mode, route and supplier to support operational planning.

5. **Develop an anomaly detection system** to flag extreme Lead Time observations in real time for operational intervention.

---

# Limitations

## No standardized SLA information

The dataset does not provide formal SLA targets by transportation mode.

Therefore, the analysis cannot determine whether a shipment is objectively "on time" or "late" relative to a contractual service target.

## Lead Time definition

Lead Time is measured from PO Sent to Vendor Date to Delivered to Client Date.

This represents the observable interval available in the dataset but may not capture the complete end-to-end customer order lifecycle.

## Extreme observations

Large Lead Time values were retained rather than arbitrarily removed.

They may represent genuine operational events, data-quality issues or exceptional cases requiring additional investigation.

## Descriptive nature of the analysis

The project is primarily descriptive and diagnostic.

The analysis identifies patterns and potential areas for investigation but does not establish causal relationships.


# Conclusion

This project demonstrates an end-to-end approach to Logistics, Operations and Business Analytics, moving beyond simple descriptive reporting by combining:

- Data quality assessment as an analytical consideration
- SQL-based data preparation and analysis
- Exploratory Data Analysis
- Descriptive statistics (median, standard deviation, distribution analysis)
- Median-based performance analysis
- Variability analysis with operational context
- Shipment volume and share analysis
- Power BI dashboard development (Executive Summary + Variability pages)
- Business interpretation and actionable recommendations

---

## What This Project Demonstrates

Beyond technical execution, this project demonstrates the ability to:

1. **Define a clear analytical business question** - Starting from "what shipment modes exhibit the highest variability and impact" rather than a generic data exploration

2. **Validate and prepare operational data** - Treating data quality as an analytical problem, not just a technical preprocessing step

3. **Select appropriate analytical metrics** - Choosing median over mean, and combining central tendency with dispersion and volume

4. **Avoid unsupported performance assumptions** - Recognizing the absence of SLAs and avoiding arbitrary thresholds

5. **Analyze variability together with operational scale** - Distinguishing between "high variability" and "high impact"

6. **Build an executive-facing dashboard** - Creating two pages with different audiences (summary vs. detailed analysis)

7. **Translate quantitative findings into business questions** - Converting numbers into actionable investigation areas

8. **Communicate limitations transparently** - Acknowledging what the analysis can and cannot say

---

## Main Analytical Conclusion

> **Operational variability should be evaluated together with shipment volume and typical Lead Time. A transportation mode with the highest individual variability is not automatically the mode with the greatest overall operational impact.**

---

## Final Reflection

This analysis reveals that in humanitarian supply chains, **predictability can be as important as speed**. 

While Ocean shipments take the longest (167 days median), their relatively low volume (8%) limits their overall operational impact. Conversely, Truck shipments are fast (4 days median) but highly unpredictable (98.1 days standard deviation) - suggesting that the real problem may not be transit time but process consistency.

Meanwhile, Air dominates the operational volume (73.4%) and shows substantial variability (67.9 days standard deviation), making it highly relevant from an overall operational exposure perspective. Truck, however, exhibits the highest variability (98.1 days standard deviation), highlighting a different operational challenge: predictability rather than typical transit speed.

The framework developed here - combining **volume, central tendency, and dispersion** - can be applied to other supply chain contexts where standardized performance targets are not available.
---

# Tools & Technical Skills

## Data Analysis

- SQL
- MySQL 8.4
- Exploratory Data Analysis (EDA)
- Data Quality Analysis
- Descriptive Statistics
- Median
- Standard Deviation
- Distribution Analysis
- Operational Variability Analysis

## Data Visualization

- Microsoft Power BI
- Interactive Dashboard Development
- KPI Design
- Comparative Visualization
- Scatter Plot Analysis
- Operational Reporting

## Business & Operations Analytics

- Logistics Analytics
- Operations Analytics
- Business Analytics
- Supply Chain Analytics
- Lead Time Analysis
- Shipment Performance Analysis
- Transportation Mode Analysis
- Volume Analysis
- Operational Impact Assessment
- Data-driven Decision Support

---

## Key Analytical Skills Demonstrated

- **Data quality assessment and remediation** - Identifying and handling data issues while preserving analytical integrity
- **Statistical thinking** - Selecting median over mean based on distribution characteristics
- **Multi-dimensional performance evaluation** - Combining volume, variability and central tendency for comprehensive assessment
- **Business communication** - Translating technical findings into actionable business insights
- **Methodological transparency** - Clearly articulating analytical decisions and their rationale
- **Critical thinking** - Recognizing the distinction between speed and predictability

---

# End-to-End Analytical Workflow

The project follows a complete analytics lifecycle, demonstrating capabilities across the entire data-to-insights pipeline:

```text
Raw Operational Data
        ↓
Data Quality Assessment
        ↓
Data Cleaning & Validation
        ↓
Lead Time Calculation
        ↓
SQL Analysis
        ↓
Exploratory Data Analysis
        ↓
Statistical Analysis
        ↓
Power BI Dashboard
        ↓
Business Interpretation
```

This workflow reflects industry best practices for analytics projects and ensures traceability from raw data to final business recommendations.

---

# Repository Structure

```text
shipment-lead-time-analysis/
│
├── README.md
│
├── data/
│   └── README.md
│
├── sql/
│   ├── 01_data_quality.sql
│   ├── 02_lead_time_analysis.sql
│   └── 03_operational_variability.sql
│
├── powerbi/
│   └── Shipment_Lead_Time_Analysis.pbix
│
├── documentation/
│   ├── decision_log.md
│   └── data_quality.md
│
└── screenshots/
    ├── executive_summary.png
    └── variability_operational_impact.png
```