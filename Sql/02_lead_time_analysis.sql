/*
===============================================================================
PROJECT: Operational Lead Time Analysis
FILE: 02_lead_time_analysis.sql

PURPOSE:
Lead Time calculation and descriptive analysis by transportation mode.

BUSINESS QUESTION:
What shipment modes exhibit the highest operational variability,
and what is their impact within the overall shipment volume?

DATABASE:
MySQL 8.4

===============================================================================
*/


/*
===============================================================================
1. VALID LEAD TIME DATASET
===============================================================================

Lead Time is defined as:

Lead Time =
Delivered to Client Date - PO Sent to Vendor Date

Only records with non-negative Lead Time values are included in the
validated analytical population.
*/

CREATE OR REPLACE VIEW vw_shipments_lead_time_valid AS

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
  AND DATEDIFF(
        `Delivered to Client Date`,
        `PO Sent to Vendor Date`
      ) >= 0;


/*
===============================================================================
2. VALIDATED DATASET OVERVIEW
===============================================================================
*/

SELECT
    COUNT(*) AS total_valid_shipments,
    ROUND(AVG(lead_time_days), 2) AS average_lead_time,
    MAX(lead_time_days) AS maximum_lead_time,
    MIN(lead_time_days) AS minimum_lead_time
FROM vw_shipments_lead_time_valid;


/*
===============================================================================
3. LEAD TIME DISTRIBUTION
===============================================================================

Create analytical Lead Time buckets for distribution analysis.

Buckets:

0-30 days
31-60 days
61-90 days
91-120 days
121-180 days
180+ days
*/

SELECT
    CASE
        WHEN lead_time_days BETWEEN 0 AND 30 THEN '0-30'
        WHEN lead_time_days BETWEEN 31 AND 60 THEN '31-60'
        WHEN lead_time_days BETWEEN 61 AND 90 THEN '61-90'
        WHEN lead_time_days BETWEEN 91 AND 120 THEN '91-120'
        WHEN lead_time_days BETWEEN 121 AND 180 THEN '121-180'
        WHEN lead_time_days > 180 THEN '180+'
    END AS lead_time_bucket,

    COUNT(*) AS shipment_count

FROM vw_shipments_lead_time_valid

GROUP BY
    CASE
        WHEN lead_time_days BETWEEN 0 AND 30 THEN '0-30'
        WHEN lead_time_days BETWEEN 31 AND 60 THEN '31-60'
        WHEN lead_time_days BETWEEN 61 AND 90 THEN '61-90'
        WHEN lead_time_days BETWEEN 91 AND 120 THEN '91-120'
        WHEN lead_time_days BETWEEN 121 AND 180 THEN '121-180'
        WHEN lead_time_days > 180 THEN '180+'
    END

ORDER BY
    MIN(lead_time_days);


/*
===============================================================================
4. OVERALL LEAD TIME STATISTICS
===============================================================================
*/

SELECT
    COUNT(*) AS total_shipments,
    ROUND(AVG(lead_time_days), 2) AS average_lead_time,
    MIN(lead_time_days) AS minimum_lead_time,
    MAX(lead_time_days) AS maximum_lead_time
FROM vw_shipments_lead_time_valid;


/*
===============================================================================
5. MEDIAN LEAD TIME
===============================================================================

MySQL 8.4 does not provide a simple MEDIAN() aggregate function.

The following calculation uses percentile_cont to obtain the 50th percentile,
which represents the median Lead Time.
*/

SELECT
    PERCENTILE_CONT(0.5)
    WITHIN GROUP (ORDER BY lead_time_days) AS median_lead_time
FROM vw_shipments_lead_time_valid;


/*
===============================================================================
6. MEDIAN LEAD TIME BY SHIPMENT MODE
===============================================================================

Median Lead Time is calculated separately for each transportation mode.

The median is prioritized over the mean when interpreting typical operational
performance because it is less sensitive to extreme observations.
*/

SELECT
    shipment_mode,

    PERCENTILE_CONT(0.5)
    WITHIN GROUP (ORDER BY lead_time_days) AS median_lead_time

FROM vw_shipments_lead_time_valid

GROUP BY shipment_mode

ORDER BY median_lead_time DESC;


/*
===============================================================================
7. SHIPMENT VOLUME BY MODE
===============================================================================

Calculate shipment volume and percentage of total volume.

This provides the operational scale required to interpret variability.
*/

SELECT
    shipment_mode,

    COUNT(*) AS total_shipments,

    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM vw_shipments_lead_time_valid),
        2
    ) AS volume_share_pct

FROM vw_shipments_lead_time_valid

GROUP BY shipment_mode

ORDER BY total_shipments DESC;


/*
===============================================================================
8. COMBINED VOLUME AND MEDIAN LEAD TIME
===============================================================================

Combines operational scale and typical Lead Time by transportation mode.
*/

SELECT
    shipment_mode,

    COUNT(*) AS total_shipments,

    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM vw_shipments_lead_time_valid),
        2
    ) AS volume_share_pct,

    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY lead_time_days),
        2
    ) AS median_lead_time

FROM vw_shipments_lead_time_valid

GROUP BY shipment_mode

ORDER BY total_shipments DESC;


/*
===============================================================================
9. LEAD TIME SUMMARY BY MODE
===============================================================================

Basic descriptive statistics by transportation mode.

This query provides the foundation for the variability analysis performed
in the following SQL script.
*/

SELECT
    shipment_mode,

    COUNT(*) AS total_shipments,

    ROUND(AVG(lead_time_days), 2) AS average_lead_time,

    MIN(lead_time_days) AS minimum_lead_time,

    MAX(lead_time_days) AS maximum_lead_time

FROM vw_shipments_lead_time_valid

GROUP BY shipment_mode

ORDER BY total_shipments DESC;


/*
===============================================================================
10. FINAL ANALYTICAL CHECK
===============================================================================

Confirm that the validated analytical population contains the expected
4,587 shipment records used in the final analysis.
*/

SELECT
    COUNT(*) AS validated_records
FROM vw_shipments_lead_time_valid;


/*
===============================================================================
ANALYTICAL NOTES

- Lead Time is measured from PO Sent to Vendor Date to Delivered to Client Date.
- Negative Lead Time observations are excluded.
- Zero-day Lead Time observations are retained.
- Extreme Lead Time observations are retained.
- Median Lead Time is used as the primary measure of typical performance.
- Shipment volume and volume share are used to provide operational context.
- No universal SLA threshold is imposed because standardized SLAs by mode
  are not available in the dataset.

The next analytical stage is the assessment of operational variability,
including standard deviation and the relationship between variability
and shipment volume.

===============================================================================
*/