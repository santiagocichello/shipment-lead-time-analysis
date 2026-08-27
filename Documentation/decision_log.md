# Analytical Decision Log

## Project

**Operational Lead Time Analysis: Measuring Variability and Operational Impact in Humanitarian Supply Chains**

---

## Purpose

This document records the main analytical and methodological decisions made during the development of the project.

The objective is to provide transparency around the reasoning behind the data preparation, metric selection, analytical approach and dashboard design.

The project was guided by one central business question:

> **What shipment modes exhibit the highest operational variability, and what is their impact within the overall shipment volume?**

---

# 1. Lead Time Definition

### Decision

Lead Time was defined as:

**Lead Time = Delivered to Client Date − PO Sent to Vendor Date**

### Rationale

These two dates represent the observable operational interval available in the dataset.

This definition allows shipment duration to be calculated consistently across transportation modes.

### Limitation

This does not necessarily represent the complete end-to-end customer order lifecycle because earlier stages of the process are not fully represented in the available data.

---

# 2. Invalid Lead Time Observations

### Decision

Negative Lead Time observations were excluded from the validated analytical population.

### Rationale

A negative Lead Time means that the recorded delivery date occurs before the recorded Purchase Order date.

Under the Lead Time definition used in this project, such observations cannot represent a valid operational duration.

### Treatment

Negative values were treated as invalid observations for Lead Time-based analysis rather than being interpreted as extremely fast shipments.

---

# 3. Zero-Day Lead Time

### Decision

Zero-day Lead Time observations were retained.

### Rationale

A Lead Time of zero days is mathematically valid under the selected definition.

It may represent a shipment where the Purchase Order and delivery occurred on the same recorded date.

Without additional business rules indicating otherwise, these records should not be removed.

---

# 4. Extreme Lead Time Observations

### Decision

Extreme Lead Time observations were retained.

### Rationale

High Lead Time values were not automatically assumed to be data errors.

An extreme observation may represent:

- A genuine operational event
- An unusual shipment
- A process exception
- A data-quality issue

Removing extreme values without business validation could eliminate potentially meaningful operational information.

### Analytical Treatment

Extreme observations were therefore retained and evaluated through descriptive statistics, distribution analysis and operational context.

---

# 5. Shipment Mode: N/A

### Decision

Records originally classified as `N/A` under Shipment Mode were grouped under:

**Other / Unspecified**

### Rationale

The records were retained because they represent valid shipment observations.

However, exposing `N/A` directly in an executive-facing dashboard provides limited analytical meaning and reduces presentation quality.

The transformation therefore improves interpretability without removing the underlying records.

---

# 6. Median Lead Time

### Decision

Median Lead Time was prioritized when evaluating typical operational performance.

### Rationale

Lead Time distributions can contain extreme observations.

The median is less sensitive to extreme values than the arithmetic mean and therefore provides a more representative measure of typical shipment duration when distributions are highly variable.

### Analytical Interpretation

Median Lead Time answers:

> **How long does a typical shipment take?**

It does not measure predictability by itself.

For that reason, median Lead Time was always interpreted together with variability measures.

---

# 7. Standard Deviation

### Decision

Standard deviation was selected as the primary measure of Lead Time dispersion.

### Rationale

Standard deviation quantifies how widely Lead Time observations are dispersed around their mean.

A higher standard deviation indicates greater variability and therefore potentially lower operational predictability.

### Analytical Interpretation

Standard deviation answers:

> **How variable are shipment Lead Times?**

It should not be interpreted as a direct measure of operational impact because shipment volume must also be considered.

---

# 8. Shipment Volume

### Decision

Shipment volume was included as a core analytical dimension.

### Rationale

Variability alone does not determine operational significance.

A transportation mode may exhibit very high variability while representing only a small fraction of total shipments.

Conversely, a transportation mode with moderate variability may affect a much larger portion of operations because of its significantly higher volume.

Therefore, shipment volume provides the operational scale necessary to interpret variability.

---

# 9. Volume Share

### Decision

Volume share was calculated as the percentage of validated shipments represented by each transportation mode.

### Rationale

Absolute shipment counts provide scale, while percentage share provides proportional context.

Together, these metrics make it possible to distinguish:

- High variability with low operational exposure
- High variability with meaningful operational exposure
- Moderate variability affecting a very large proportion of operations

---

# 10. No Universal SLA Threshold

### Decision

No universal Lead Time threshold was imposed to classify shipments as "late" or "on time."

### Rationale

The dataset does not provide standardized formal Service Level Agreements (SLAs) by transportation mode.

A universal threshold such as 120 days would not necessarily be comparable across Air, Ocean and Truck transportation.

Using an arbitrary threshold would therefore introduce an unsupported assumption into the analysis.

### Methodological Approach

Instead, the analysis prioritized:

- Median Lead Time
- Standard deviation
- Shipment volume
- Volume share
- Lead Time distribution
- Minimum and maximum Lead Time

> **Due to the absence of standardized formal SLAs by transportation channel in the raw dataset, the analysis prioritized distribution-based comparisons using median Lead Time, variability measures and absolute shipment volumes rather than imposing arbitrary performance thresholds.**

---

# 11. Variability vs. Operational Impact

### Decision

The project explicitly distinguishes between **variability** and **operational impact**.

### Rationale

The transportation mode with the highest standard deviation is not automatically the mode with the greatest overall operational impact.

For example:

- **Truck** has the highest variability.
- **Air** represents the largest share of total shipment volume.
- **Ocean** has the highest median Lead Time but represents a substantially smaller share of total operations.

These are different operational dimensions.

### Analytical Framework

The project therefore evaluates:

**Central Tendency + Dispersion + Operational Scale**

rather than relying on a single ranking.

---

# 12. Interpretation of Truck

### Finding

Truck has:

- **792 shipments**
- **17.3% volume share**
- **4-day median Lead Time**
- **98.1-day standard deviation**

### Interpretation

Truck demonstrates a particularly important operational pattern.

Typical Lead Time is very low, but variability is the highest among the transportation modes analyzed.

This suggests that the primary issue may be **predictability rather than consistently long Lead Time**.

### Potential Follow-Up

Further analysis could investigate variability by:

- Route
- Supplier
- Destination
- Order characteristics
- Process exceptions

---

# 13. Interpretation of Air

### Finding

Air has:

- **3,367 shipments**
- **73.4% volume share**
- **99-day median Lead Time**
- **67.9-day standard deviation**

### Interpretation

Air represents nearly three quarters of all validated shipments.

Although Air does not have the highest standard deviation, its substantial operational scale makes its variability highly relevant to overall operational exposure.

### Analytical Implication

Improving predictability within Air operations could potentially affect a large proportion of total shipments.

---

# 14. Interpretation of Ocean

### Finding

Ocean has:

- **366 shipments**
- **8.0% volume share**
- **167-day median Lead Time**
- **61.8-day standard deviation**

### Interpretation

Ocean has the highest median Lead Time among the major transportation modes.

However, it represents only 8.0% of total shipment volume.

Therefore, its long typical Lead Time should not automatically be interpreted as the greatest overall operational impact.

### Potential Follow-Up

Further analysis could determine whether the observed Lead Time is consistent with expected characteristics of Ocean transportation or whether specific routes, suppliers or processes contribute to the observed values.

---

# 15. Interpretation of Other / Unspecified

### Finding

Other / Unspecified has:

- **44 shipments**
- **1.0% volume share**
- **3.5-day median Lead Time**
- **37.3-day standard deviation**

### Interpretation

The category represents a very small proportion of the validated shipment population.

It should therefore not be given the same operational weight as the major transportation modes.

The category is retained primarily for data transparency and completeness.

---

# 16. Interpretation of Air Charter

### Finding

Air Charter has:

- **18 shipments**
- **0.4% volume share**
- **64-day median Lead Time**
- **29.9-day standard deviation**

### Interpretation

The sample size is very small compared with the major transportation modes.

Therefore, Air Charter statistics should be interpreted cautiously.

The observed metrics are descriptive but should not be treated as equally reliable indicators of broader operational behavior without additional observations.

---

# 17. Dashboard Design Decision

### Decision

The Power BI report was structured into two pages:

1. **Executive Summary**
2. **Variability & Operational Impact**

### Rationale

The first page provides an executive-level overview of the operational dataset.

The second page focuses directly on the project's analytical question by comparing transportation modes through volume, typical Lead Time and variability.

This structure separates:

**High-level understanding**

from

**Detailed operational diagnosis**

---

# 18. Page 1 — Executive Summary

### Purpose

Provide a concise overview of the shipment population and highlight the main operational patterns.

### Main Elements

The page includes:

- Total Shipments
- Average Lead Time
- Median Lead Time
- Maximum Lead Time
- Lead Time distribution
- Shipment Volume vs. Median Lead Time by Mode

### Analytical Role

Page 1 establishes the overall operational context before the viewer moves into the detailed variability analysis.

---

# 19. Page 2 — Variability & Operational Impact

### Purpose

Directly address the project's central business question.

### Main Elements

The page compares transportation modes using:

- Shipment volume
- Volume share
- Median Lead Time
- Standard deviation
- Minimum Lead Time
- Maximum Lead Time

### Analytical Role

The page is designed to distinguish between:

> **How long shipments typically take**

and

> **How predictable the process is**

while incorporating shipment volume as the measure of operational scale.

---

# 20. Final Analytical Principle

The project intentionally avoids identifying a single transportation mode as universally "worst."

Instead, each mode is evaluated according to its combination of:

**Volume + Typical Lead Time + Variability**

This prevents conclusions based on a single metric and provides a more balanced operational interpretation.

---

# 21. Final Analytical Conclusion

The analysis demonstrates that operational variability should be evaluated together with shipment volume and typical Lead Time.

The key findings are:

- **Truck has the highest variability**, with a standard deviation of 98.1 days, despite having a very low median Lead Time of 4 days.
- **Air represents the largest operational exposure by volume**, accounting for 73.4% of shipments, with a standard deviation of 67.9 days.
- **Ocean has the highest median Lead Time**, at 167 days, but represents only 8.0% of total shipment volume.

Therefore:

> **The transportation mode with the highest individual variability is not automatically the mode with the greatest overall operational impact.**

The analysis supports a more nuanced approach to logistics performance evaluation by combining:

**Central Tendency + Dispersion + Operational Scale**

---

## Document Status

**Status:** Final

**Project Stage:** Portfolio-ready

**Analytical Scope:** Closed

**Primary Business Question:**  
What shipment modes exhibit the highest operational variability, and what is their impact within the overall shipment volume?

**Last methodological principle:**  
No further analytical changes are required unless new data, business requirements or validated operational information becomes available.