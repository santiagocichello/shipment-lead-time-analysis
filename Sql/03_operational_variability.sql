/*
===============================================================================
PROJECT: Operational Lead Time Analysis
FILE: 03_operational_variability.sql

PURPOSE:
Analyze operational variability by transportation mode and evaluate it
in the context of shipment volume and operational scale.

BUSINESS QUESTION:
What shipment modes exhibit the highest operational variability,
and what is their impact within the overall shipment volume?

DATABASE:
MySQL 8.4

===============================================================================
*/


/*
===============================================================================
1. DESCRIPTIVE STATISTICS BY SHIPMENT MODE
===============================================================================

This query provides the basic descriptive statistics used to compare
transportation modes.

Metrics:
- Shipment volume
- Average Lead Time
- Minimum Lead Time
- Maximum Lead Time
- Standard deviation

Standard deviation is used as a measure of operational dispersion.
A higher value indicates greater variability around typical performance.
*/

SELECT
    shipment_mode,

    COUNT(*) AS total_shipments,

    ROUND(
        AVG(lead_time_days),
        2
    ) AS average_lead_time,

    MIN(lead_time_days) AS minimum_lead_time,

    MAX(lead_time_days) AS maximum_lead_time,

    ROUND(
        STDDEV_POP(lead_time_days),
        2
    ) AS standard_deviation

FROM vw_shipments_lead_time_valid

GROUP BY shipment_mode

ORDER BY standard_deviation DESC;


/*
===============================================================================
2. MEDIAN LEAD TIME BY SHIPMENT MODE
===============================================================================

Median Lead Time represents typical operational performance.

It is used alongside standard deviation because the median is less
sensitive to extreme observations than the arithmetic mean.
*/

SELECT
    shipment_mode,

    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY lead_time_days),
        2
    ) AS median_lead_time

FROM vw_shipments_lead_time_valid

GROUP BY shipment_mode

ORDER BY median_lead_time DESC;


/*
===============================================================================
3. VOLUME AND VOLUME SHARE BY SHIPMENT MODE
===============================================================================

Shipment volume provides the operational scale required to interpret
variability.

A highly variable mode with very low volume may have less overall
operational impact than a moderately variable mode representing
a substantial share of total shipments.
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
4. COMBINED VARIABILITY AND OPERATIONAL SCALE
===============================================================================

This is the primary analytical output of the project.

It combines:

- Shipment volume
- Volume share
- Median Lead Time
- Standard deviation
- Minimum Lead Time
- Maximum Lead Time

These dimensions should be interpreted together rather than independently.
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
    ) AS median_lead_time,

    ROUND(
        STDDEV_POP(lead_time_days),
        2
    ) AS standard_deviation,

    MIN(lead_time_days) AS minimum_lead_time,

    MAX(lead_time_days) AS maximum_lead_time

FROM vw_shipments_lead_time_valid

GROUP BY shipment_mode

ORDER BY standard_deviation DESC;


/*
===============================================================================
5. VARIABILITY RANKING
===============================================================================

Rank transportation modes by standard deviation.

The ranking identifies which modes exhibit the greatest dispersion
in Lead Time.

This ranking should not be interpreted as a ranking of overall
operational impact by itself.
*/

SELECT
    shipment_mode,

    ROUND(
        STDDEV_POP(lead_time_days),
        2
    ) AS standard_deviation,

    RANK() OVER (
        ORDER BY STDDEV_POP(lead_time_days) DESC
    ) AS variability_rank

FROM vw_shipments_lead_time_valid

GROUP BY shipment_mode

ORDER BY variability_rank;


/*
===============================================================================
6. VOLUME RANKING
===============================================================================

Rank transportation modes by shipment volume.

This provides the second dimension required to interpret operational impact.
*/

SELECT
    shipment_mode,

    COUNT(*) AS total_shipments,

    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM vw_shipments_lead_time_valid),
        2
    ) AS volume_share_pct,

    RANK() OVER (
        ORDER BY COUNT(*) DESC
    ) AS volume_rank

FROM vw_shipments_lead_time_valid

GROUP BY shipment_mode

ORDER BY volume_rank;


/*
===============================================================================
7. MEDIAN VS. VARIABILITY
===============================================================================

Compare typical Lead Time with operational variability.

This helps distinguish between:

- Long but relatively predictable processes
- Short but highly unpredictable processes
- High-volume modes with substantial operational exposure
*/

SELECT
    shipment_mode,

    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY lead_time_days),
        2
    ) AS median_lead_time,

    ROUND(
        STDDEV_POP(lead_time_days),
        2
    ) AS standard_deviation

FROM vw_shipments_lead_time_valid

GROUP BY shipment_mode

ORDER BY standard_deviation DESC;


/*
===============================================================================
8. EXTREME LEAD TIME OBSERVATIONS BY MODE
===============================================================================

Identify the maximum Lead Time observed for each transportation mode.

Extreme values are retained because they may represent genuine operational
events, process exceptions or data-quality issues.

They should therefore be investigated rather than automatically removed.
*/

SELECT
    shipment_mode,

    MAX(lead_time_days) AS maximum_lead_time,

    MIN(lead_time_days) AS minimum_lead_time

FROM vw_shipments_lead_time_valid

GROUP BY shipment_mode

ORDER BY maximum_lead_time DESC;


/*
===============================================================================
9. LEAD TIME DISPERSION RANGE
===============================================================================

Calculate the observed range between minimum and maximum Lead Time.

This provides an additional descriptive indication of the spread
of operational performance.
*/

SELECT
    shipment_mode,

    MIN(lead_time_days) AS minimum_lead_time,

    MAX(lead_time_days) AS maximum_lead_time,

    MAX(lead_time_days) - MIN(lead_time_days) AS observed_range

FROM vw_shipments_lead_time_valid

GROUP BY shipment_mode

ORDER BY observed_range DESC;


/*
===============================================================================
10. FINAL ANALYTICAL TABLE
===============================================================================

This query produces the consolidated output used to support the final
Power BI analysis and README findings.

The table deliberately combines operational scale, typical performance
and variability.

===============================================================================
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
    ) AS median_lead_time,

    ROUND(
        STDDEV_POP(lead_time_days),
        2
    ) AS standard_deviation,

    MIN(lead_time_days) AS minimum_lead_time,

    MAX(lead_time_days) AS maximum_lead_time

FROM vw_shipments_lead_time_valid

GROUP BY shipment_mode

ORDER BY total_shipments DESC;


/*
===============================================================================
ANALYTICAL INTERPRETATION

The analysis should not identify a single transportation mode as the
"worst" based on one metric.

Instead:

- Standard deviation identifies variability.
- Median Lead Time describes typical operational performance.
- Shipment volume identifies operational scale.
- Volume share provides proportional context.
- Minimum and maximum values provide additional distribution context.

The key analytical distinction is:

    VARIABILITY ≠ OPERATIONAL IMPACT

A transportation mode can have the highest variability while representing
a relatively smaller share of total operations.

Conversely, a high-volume mode can have substantial operational exposure
even if it does not have the highest standard deviation.

Therefore, transportation modes should be evaluated through the combined
lens of:

    CENTRAL TENDENCY + DISPERSION + OPERATIONAL SCALE

===============================================================================
*/