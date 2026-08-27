/*
===============================================================================
PROJECT: Operational Lead Time Analysis
FILE: 01_data_quality.sql

PURPOSE:
Data quality assessment and validation for the shipment Lead Time analysis.

BUSINESS QUESTION:
What shipment modes exhibit the highest operational variability,
and what is their impact within the overall shipment volume?

This script documents the main data-quality checks performed before
the analytical dataset was used for statistical analysis and Power BI.

DATABASE:
MySQL 8.4

===============================================================================
*/


/*
===============================================================================
1. SOURCE DATA OVERVIEW
===============================================================================

Review the structure and volume of the source dataset.
*/

SELECT COUNT(*) AS total_records
FROM shipments_lead_time_dataset_full;


/*
Review the available columns and data types.
*/

DESCRIBE shipments_lead_time_dataset_full;


/*
===============================================================================
2. SHIPMENT ID QUALITY CHECK
===============================================================================

Check for missing shipment IDs.
*/

SELECT
    COUNT(*) AS total_records,
    COUNT(id) AS records_with_id,
    COUNT(*) - COUNT(id) AS missing_id
FROM shipments_lead_time_dataset_full;


/*
Check for duplicated shipment IDs.
*/

SELECT
    id,
    COUNT(*) AS occurrences
FROM shipments_lead_time_dataset_full
GROUP BY id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;


/*
===============================================================================
3. SHIPMENT MODE QUALITY CHECK
===============================================================================

Review the distribution of transportation modes.

The original dataset contains records classified as N/A.
These records are retained but represented as "Other / Unspecified"
in the final analytical presentation.
*/

SELECT
    `Shipment Mode` AS shipment_mode,
    COUNT(*) AS shipment_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM shipments_lead_time_dataset_full),
        2
    ) AS volume_share_pct
FROM shipments_lead_time_dataset_full
GROUP BY `Shipment Mode`
ORDER BY shipment_count DESC;


/*
===============================================================================
4. MISSING PURCHASE ORDER DATES
===============================================================================

Identify records where the Purchase Order date is missing.

These records cannot be used to calculate Lead Time.
*/

SELECT
    COUNT(*) AS total_records,
    SUM(
        CASE
            WHEN `PO Sent to Vendor Date` IS NULL
                 OR TRIM(`PO Sent to Vendor Date`) = ''
            THEN 1
            ELSE 0
        END
    ) AS missing_po_dates
FROM shipments_lead_time_dataset_full;


/*
===============================================================================
5. MISSING DELIVERY DATES
===============================================================================

Identify records where the delivery date is missing.
*/

SELECT
    COUNT(*) AS total_records,
    SUM(
        CASE
            WHEN `Delivered to Client Date` IS NULL
                 OR TRIM(`Delivered to Client Date`) = ''
            THEN 1
            ELSE 0
        END
    ) AS missing_delivery_dates
FROM shipments_lead_time_dataset_full;


/*
===============================================================================
6. LEAD TIME VALIDATION
===============================================================================

Lead Time definition:

Lead Time =
Delivered to Client Date - PO Sent to Vendor Date

The following check identifies records where both dates are available
and calculates the resulting Lead Time.
*/

SELECT
    id,
    `Shipment Mode` AS shipment_mode,
    `PO Sent to Vendor Date` AS po_sent_to_vendor_date,
    `Delivered to Client Date` AS delivered_to_client_date,
    DATEDIFF(
        `Delivered to Client Date`,
        `PO Sent to Vendor Date`
    ) AS lead_time_days
FROM shipments_lead_time_dataset_full
WHERE `PO Sent to Vendor Date` IS NOT NULL
  AND `Delivered to Client Date` IS NOT NULL
LIMIT 20;


/*
===============================================================================
7. NEGATIVE LEAD TIME CHECK
===============================================================================

Negative Lead Time values indicate that the delivery date precedes
the Purchase Order date.

These observations require investigation and should not be treated
as valid operational Lead Time values.
*/

SELECT
    COUNT(*) AS negative_lead_time_records
FROM shipments_lead_time_dataset_full
WHERE `PO Sent to Vendor Date` IS NOT NULL
  AND `Delivered to Client Date` IS NOT NULL
  AND DATEDIFF(
        `Delivered to Client Date`,
        `PO Sent to Vendor Date`
      ) < 0;


/*
===============================================================================
8. ZERO-DAY LEAD TIME CHECK
===============================================================================

Identify shipments with Lead Time equal to zero days.

These records are retained as valid observations unless additional
business rules indicate otherwise.
*/

SELECT
    COUNT(*) AS zero_day_shipments
FROM shipments_lead_time_dataset_full
WHERE `PO Sent to Vendor Date` IS NOT NULL
  AND `Delivered to Client Date` IS NOT NULL
  AND DATEDIFF(
        `Delivered to Client Date`,
        `PO Sent to Vendor Date`
      ) = 0;


/*
===============================================================================
9. VERY SHORT LEAD TIME CHECK
===============================================================================

Identify shipments with Lead Time between 1 and 7 days.

This provides additional context for the distribution of very short
operational intervals.
*/

SELECT
    COUNT(*) AS shipments_1_to_7_days
FROM shipments_lead_time_dataset_full
WHERE `PO Sent to Vendor Date` IS NOT NULL
  AND `Delivered to Client Date` IS NOT NULL
  AND DATEDIFF(
        `Delivered to Client Date`,
        `PO Sent to Vendor Date`
      ) BETWEEN 1 AND 7;


/*
===============================================================================
10. EXTREME LEAD TIME CHECK
===============================================================================

Identify shipments with Lead Time greater than 100 days.

Extreme observations are not automatically removed because they may
represent genuine operational events, process exceptions or data-quality
issues requiring further investigation.
*/

SELECT
    COUNT(*) AS shipments_over_100_days
FROM shipments_lead_time_dataset_full
WHERE `PO Sent to Vendor Date` IS NOT NULL
  AND `Delivered to Client Date` IS NOT NULL
  AND DATEDIFF(
        `Delivered to Client Date`,
        `PO Sent to Vendor Date`
      ) > 100;


/*
===============================================================================
11. LEAD TIME SUMMARY
===============================================================================

Generate a basic statistical overview of valid Lead Time observations.

Negative Lead Time values are excluded from the valid analytical population.
*/

SELECT
    COUNT(*) AS valid_lead_time_records,
    MIN(lead_time_days) AS min_lead_time,
    MAX(lead_time_days) AS max_lead_time,
    ROUND(AVG(lead_time_days), 2) AS avg_lead_time
FROM
(
    SELECT
        DATEDIFF(
            `Delivered to Client Date`,
            `PO Sent to Vendor Date`
        ) AS lead_time_days
    FROM shipments_lead_time_dataset_full
    WHERE `PO Sent to Vendor Date` IS NOT NULL
      AND `Delivered to Client Date` IS NOT NULL
) AS lead_time_data
WHERE lead_time_days >= 0;


/*
===============================================================================
12. DATA QUALITY DECISIONS
===============================================================================

Summary of the analytical treatment applied after the quality assessment:

1. Records without sufficient dates to calculate Lead Time were excluded
   from Lead Time-based analysis.

2. Negative Lead Time observations were excluded from the valid analytical
   Lead Time population.

3. Zero-day Lead Time observations were retained.

4. Extreme Lead Time observations were retained rather than arbitrarily
   removed.

5. Original N/A Shipment Mode records were retained and represented as
   "Other / Unspecified" in the analytical presentation.

6. No universal Lead Time threshold was imposed to classify shipments as
   "late" or "on time", because the dataset does not provide standardized
   formal SLAs by transportation mode.

These decisions preserve analytical transparency while avoiding unsupported
assumptions about operational performance.
===============================================================================
*/