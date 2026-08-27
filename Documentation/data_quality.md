# Data Quality Assessment

## Project

**Operational Lead Time Analysis: Measuring Variability and Operational Impact in Humanitarian Supply Chains**

---

## Purpose

Data quality was treated as an analytical component of the project rather than only a preprocessing step.

The objective of this assessment was to identify issues that could affect the validity of Lead Time calculations and subsequent comparisons between transportation modes.

The main areas assessed were:

- Record completeness
- Shipment identifiers
- Transportation mode classification
- Purchase Order dates
- Delivery dates
- Lead Time validity
- Zero-day observations
- Extreme Lead Time observations
- Missing or unspecified transportation modes

---

# 1. Source Dataset

The analysis was performed on shipment-level operational data containing information related to transportation mode, Purchase Order dates, delivery dates and other shipment attributes.

The final validated analytical population used for Lead Time analysis contains:

**4,587 shipment records.**

---

# 2. Shipment Identifiers

Shipment IDs were reviewed to identify:

- Missing identifiers
- Potential duplicate identifiers

Shipment-level records were retained according to the analytical dataset used for the project.

The shipment ID was used primarily as the record-level identifier for volume calculations and Power BI analysis.

---

# 3. Transportation Mode Quality

The dataset contains five transportation-mode categories after analytical treatment:

| Shipment Mode | Shipments | Volume Share |
|---|---:|---:|
| Air | 3,367 | 73.4% |
| Truck | 792 | 17.3% |
| Ocean | 366 | 8.0% |
| Other / Unspecified | 44 | 1.0% |
| Air Charter | 18 | 0.4% |

The original dataset contained records classified as:

`N/A`

These records were not removed.

Instead, they were represented in the final dashboard as:

**Other / Unspecified**

This approach preserves the underlying observations while providing a more meaningful category for executive reporting.

---

# 4. Purchase Order Dates

Purchase Order dates were reviewed because they represent the starting point of the Lead Time calculation.

Records without a valid Purchase Order date cannot produce a valid Lead Time under the project's definition.

Therefore, records without the required date information were excluded from the validated Lead Time analytical population.

---

# 5. Delivery Dates

Delivery dates were similarly reviewed because they represent the endpoint of the Lead Time calculation.

Records without a valid delivery date cannot produce a valid Lead Time.

These observations were therefore excluded from Lead Time-based analysis when the required date information was unavailable.

---

# 6. Lead Time Definition

Lead Time was calculated as:

**Lead Time = Delivered to Client Date − PO Sent to Vendor Date**

This definition was applied consistently across transportation modes.

The resulting value represents the observable operational interval available in the dataset.

---

# 7. Negative Lead Time

Negative Lead Time values were identified during validation.

A negative result means that the recorded delivery date precedes the recorded Purchase Order date.

Under the project's Lead Time definition, these observations cannot represent a valid operational duration.

Therefore:

**Negative Lead Time observations were excluded from the validated analytical population.**

They were not interpreted as unusually fast shipments.

---

# 8. Zero-Day Lead Time

Zero-day observations were identified during the data-quality assessment.

The analysis found:

**336 shipments with Lead Time = 0 days.**

These records were retained.

A zero-day Lead Time is mathematically valid under the selected definition and may represent cases where the Purchase Order and delivery dates fall on the same recorded date.

Without additional business rules indicating that these observations are invalid, removing them would introduce an unsupported assumption.

---

# 9. Short Lead Time Observations

The analysis also identified:

**102 shipments with Lead Time between 1 and 7 days.**

These observations were retained as valid Lead Time values.

They provide useful context for understanding the lower end of the Lead Time distribution.

---

# 10. Extreme Lead Time Observations

The analysis identified:

**121 shipments with Lead Time greater than 100 days.**

Extreme observations were not automatically removed.

A large Lead Time value may represent:

- A genuine operational event
- An unusual shipment
- A process exception
- A data-quality issue
- A combination of operational factors

Without additional business validation, automatically removing these observations could distort the true operational distribution.

Therefore, extreme observations were retained and evaluated through descriptive statistics and operational context.

---

# 11. Maximum Lead Time

The overall validated dataset contains an observed maximum Lead Time of:

**616 days**

This value was retained.

It is treated as an extreme observation requiring potential investigation rather than automatically classified as an error.

The Power BI Executive Summary therefore reports the maximum Lead Time while the analytical interpretation focuses primarily on median Lead Time and variability.

---

# 12. Median vs. Mean

The Lead Time distribution contains substantial dispersion and extreme observations.

For this reason, median Lead Time was prioritized when interpreting typical operational performance.

The median is less sensitive to extreme observations than the arithmetic mean.

This makes it more suitable for answering:

> **How long does a typical shipment take?**

The mean remains available as a descriptive KPI but is not used as the sole measure of typical performance.

---

# 13. Variability Assessment

Standard deviation was used as the principal measure of Lead Time dispersion.

The final validated values used in the analytical interpretation are:

| Shipment Mode | Standard Deviation |
|---|---:|
| Truck | 98.1 days |
| Air | 67.9 days |
| Ocean | 61.8 days |
| Other / Unspecified | 37.3 days |
| Air Charter | 29.9 days |

These values are interpreted together with shipment volume and median Lead Time.

A higher standard deviation indicates greater variability but does not automatically indicate greater overall operational impact.

---

# 14. Operational Scale

Shipment volume was incorporated into the analysis because variability without operational scale can be misleading.

For example:

- Truck has the highest variability.
- Air has the largest shipment volume.
- Ocean has the highest median Lead Time.

These findings represent different dimensions of operational performance.

Therefore, the project does not rank transportation modes using standard deviation alone.

---

# 15. No Arbitrary SLA Threshold

The dataset does not contain standardized formal SLAs by transportation mode.

Consequently, the analysis does not impose a universal threshold to determine whether shipments are "late" or "on time."

A threshold such as 120 days would not necessarily have the same operational meaning for:

- Air
- Ocean
- Truck

Instead, the analysis uses:

- Median Lead Time
- Standard deviation
- Shipment volume
- Volume share
- Lead Time distribution
- Minimum Lead Time
- Maximum Lead Time

This approach avoids introducing unsupported assumptions into the analysis.

---

# 16. Data Quality Treatment Summary

| Issue | Treatment | Rationale |
|---|---|---|
| Missing PO date | Excluded from Lead Time analysis | Lead Time cannot be calculated |
| Missing delivery date | Excluded from Lead Time analysis | Lead Time cannot be calculated |
| Negative Lead Time | Excluded | Invalid under the selected Lead Time definition |
| Zero-day Lead Time | Retained | Valid mathematical observation |
| 1–7 day Lead Time | Retained | Valid operational observation |
| Lead Time >100 days | Retained | Potential operational event or exception |
| Maximum = 616 days | Retained | Investigated through descriptive analysis |
| Shipment Mode = N/A | Renamed to Other / Unspecified | Preserve records while improving presentation |
| No standardized SLA | No arbitrary threshold applied | Avoid unsupported performance assumptions |

---

# 17. Data Quality Philosophy

The project follows a principle of:

> **Validate before removing.**

An unusual observation is not automatically a bad observation.

Data should only be removed when there is a defensible analytical or business reason to do so.

This approach is particularly important in operational analytics because unusual observations may contain information about:

- Process failures
- Exceptional shipments
- Operational bottlenecks
- Data-entry problems
- Unusual routes
- Supplier issues
- Other process conditions

---

# 18. Limitations

The available dataset does not provide sufficient business context to determine whether every extreme Lead Time value represents:

- A genuine operational delay
- A process exception
- A data-entry error
- A missing process stage

Therefore, the project identifies these observations as candidates for further investigation rather than making unsupported assumptions about their cause.

Similarly, the dataset does not provide formal SLA information by transportation mode.

As a result, the analysis is descriptive and diagnostic rather than a formal compliance assessment.

---

# 19. Recommended Next Data Quality Checks

If additional operational data became available, the following checks would improve the analysis:

1. Validate Lead Time definitions with process owners.

2. Investigate extreme Lead Time observations individually.

3. Validate shipment-mode classifications.

4. Confirm whether zero-day shipments represent genuine same-day operations.

5. Establish standardized SLA definitions by transportation mode.

6. Analyze data completeness by supplier, destination and route.

7. Investigate whether missing dates are systematically associated with specific operational groups.

---

# Final Assessment

The dataset required several quality considerations before being used for operational analysis.

The final analytical approach deliberately preserves valid observations, explicitly documents exclusions, and avoids arbitrary assumptions.

The resulting analysis is therefore based on a validated Lead Time population of:

**4,587 shipment records**

and evaluates transportation modes through the combined dimensions of:

**Typical Performance + Variability + Operational Scale**

This provides the analytical foundation for the Power BI dashboard and the project's final business conclusions.