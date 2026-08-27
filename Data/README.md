# Data Documentation

## Overview

This project analyzes shipment Lead Time and operational variability across different transportation modes.

The original dataset contains shipment-level operational records with information related to transportation, purchase orders, delivery dates and other supply chain attributes.

The final analytical dataset used for this project contains:

**4,587 validated shipment records.**

---

## Data Availability

The original dataset is not included in this repository.

This repository focuses on documenting the analytical process, data preparation decisions, SQL analysis and Power BI dashboard development.

The dataset used in the project was processed and validated before being used for statistical analysis and visualization.

---

## Key Variables Used

The analysis primarily focused on the following variables:

| Variable | Description |
|---|---|
| `id` | Unique shipment identifier |
| `Shipment Mode` | Transportation mode used for the shipment |
| `PO Sent to Vendor Date` | Date when the purchase order was sent to the vendor |
| `Delivered to Client Date` | Date when the shipment was delivered to the client |
| `lead_time_days` | Number of days between the purchase order being sent to the vendor and delivery to the client |

---

## Lead Time Definition

Lead Time was calculated as:

**Lead Time = Delivered to Client Date − PO Sent to Vendor Date**

This definition represents the operational interval available in the dataset.

It should not be interpreted as the complete end-to-end customer order lifecycle, as the dataset does not provide all stages of the order process.

---

## Data Preparation

Before analysis, the dataset was reviewed for data-quality issues.

The preparation process included:

- Identifying missing or invalid purchase order dates
- Handling incomplete date values
- Validating Lead Time calculations
- Reviewing extreme Lead Time observations
- Standardizing transportation mode categories

Records originally classified as `N/A` under Shipment Mode were grouped as:

**Other / Unspecified**

This transformation preserves the records while presenting a clearer category in the final dashboard.

---

## Final Analytical Dataset

The final dataset used for SQL analysis and Power BI visualization contains:

**4,587 shipment records with validated Lead Time values.**

The dataset was used to analyze:

- Shipment volume by transportation mode
- Volume share
- Median Lead Time
- Lead Time variability
- Standard deviation
- Minimum and maximum Lead Time
- Operational impact in relation to shipment volume

---

## Data Quality Considerations

Several data-quality considerations were incorporated into the analysis.

### Missing Dates

Some records contained missing or incomplete purchase order date information.

Records without sufficient information to calculate a valid Lead Time were excluded from the final Lead Time analysis.

### Unspecified Transportation Mode

Records classified as `N/A` were retained but grouped under:

**Other / Unspecified**

This avoids presenting an unexplained `N/A` category while preserving the underlying records.

### Extreme Lead Time Values

Extreme Lead Time observations were not automatically removed.

They were retained for analysis because unusually high values may represent genuine operational events, process exceptions or potential data-quality issues.

---

## Data Limitations

### SLA Information

The dataset does not provide standardized formal Service Level Agreements (SLAs) by transportation mode.

Therefore, the analysis does not classify shipments as universally "late" or "on time" using an arbitrary Lead Time threshold.

### Lead Time Scope

Lead Time is measured between:

`PO Sent to Vendor Date`

and

`Delivered to Client Date`

This represents the observable interval available in the dataset but may not capture the complete end-to-end customer order lifecycle.

### Causal Interpretation

The dataset supports descriptive and diagnostic analysis, but it does not by itself establish the causal drivers of Lead Time variability.

Further analysis would be required to determine whether variability is associated with factors such as routes, suppliers, destinations, seasonality or other operational characteristics.

---

## Relationship to the Analysis

The validated dataset serves as the foundation for the SQL analysis and Power BI dashboard.

The analytical process uses the dataset to evaluate:

**Shipment Volume + Typical Lead Time + Variability = Operational Impact**

For details about the analytical decisions and methodology, see:

`documentation/decision_log.md`

For detailed information about the data-quality process, see:

`documentation/data_quality.md`