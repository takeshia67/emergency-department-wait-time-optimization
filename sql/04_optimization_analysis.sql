
-- =========================================================
-- Emergency Department Wait-Time Optimization
-- File: 04_optimization_analysis.sql
-- Purpose: Identify operational opportunities to improve
--          ED patient flow and reduce excessive wait times
-- Dataset: 1,000 synthetic ED encounters
-- Database: MySQL 8.0+
-- =========================================================

USE emergency_department_analytics;


-- =========================================================
-- 1. WAIT TIME BY ARRIVAL MODE
-- =========================================================

SELECT
    arrival_mode,
    COUNT(*) AS total_visits,

    ROUND(
        AVG(TIMESTAMPDIFF(
            MINUTE,
            arrival_datetime,
            provider_datetime
        )), 2
    ) AS average_wait_minutes

FROM ed_patient_visits

WHERE arrival_datetime IS NOT NULL
  AND provider_datetime IS NOT NULL
  AND provider_datetime >= arrival_datetime

GROUP BY arrival_mode

ORDER BY average_wait_minutes DESC;


-- =========================================================
-- 2. WAIT TIME BY DEPARTMENT
-- =========================================================

SELECT
    department,
    COUNT(*) AS total_visits,

    ROUND(
        AVG(TIMESTAMPDIFF(
            MINUTE,
            arrival_datetime,
            provider_datetime
        )), 2
    ) AS average_wait_minutes

FROM ed_patient_visits

WHERE arrival_datetime IS NOT NULL
  AND provider_datetime IS NOT NULL
  AND provider_datetime >= arrival_datetime

GROUP BY department

ORDER BY average_wait_minutes DESC;


-- =========================================================
-- 3. WAIT TIME BY INSURANCE TYPE
-- =========================================================

SELECT
    insurance_type,
    COUNT(*) AS total_visits,

    ROUND(
        AVG(TIMESTAMPDIFF(
            MINUTE,
            arrival_datetime,
            provider_datetime
        )), 2
    ) AS average_wait_minutes

FROM ed_patient_visits

WHERE arrival_datetime IS NOT NULL
  AND provider_datetime IS NOT NULL
  AND provider_datetime >= arrival_datetime

GROUP BY insurance_type

ORDER BY average_wait_minutes DESC;


-- =========================================================
-- 4. ENCOUNTERS WITH WAIT TIMES OVER 90 MINUTES
-- =========================================================

SELECT

    COUNT(*) AS valid_total_visits,

    SUM(
        CASE
            WHEN TIMESTAMPDIFF(
                MINUTE,
                arrival_datetime,
                provider_datetime
            ) > 90
            THEN 1 ELSE 0
        END
    ) AS visits_over_90_minutes,

    ROUND(
        SUM(
            CASE
                WHEN TIMESTAMPDIFF(
                    MINUTE,
                    arrival_datetime,
                    provider_datetime
                ) > 90
                THEN 1 ELSE 0
            END
        ) * 100.0 / COUNT(*), 2
    ) AS percentage_over_90_minutes

FROM ed_patient_visits

WHERE arrival_datetime IS NOT NULL
  AND provider_datetime IS NOT NULL
  AND provider_datetime >= arrival_datetime;


-- =========================================================
-- 5. ENCOUNTERS WITH WAIT TIMES OVER 120 MINUTES
-- =========================================================

SELECT

    COUNT(*) AS valid_total_visits,

    SUM(
        CASE
            WHEN TIMESTAMPDIFF(
                MINUTE,
                arrival_datetime,
                provider_datetime
            ) > 120
            THEN 1 ELSE 0
        END
    ) AS visits_over_120_minutes,

    ROUND(
        SUM(
            CASE
                WHEN TIMESTAMPDIFF(
                    MINUTE,
                    arrival_datetime,
                    provider_datetime
                ) > 120
                THEN 1 ELSE 0
            END
        ) * 100.0 / COUNT(*), 2
    ) AS percentage_over_120_minutes

FROM ed_patient_visits

WHERE arrival_datetime IS NOT NULL
  AND provider_datetime IS NOT NULL
  AND provider_datetime >= arrival_datetime;


-- =========================================================
-- 6. WAIT-TIME CATEGORIES
-- =========================================================

SELECT

    CASE
        WHEN wait_minutes <= 30 THEN '0-30 Minutes'
        WHEN wait_minutes <= 60 THEN '31-60 Minutes'
        WHEN wait_minutes <= 90 THEN '61-90 Minutes'
        WHEN wait_minutes <= 120 THEN '91-120 Minutes'
        ELSE 'Over 120 Minutes'
    END AS wait_time_category,

    COUNT(*) AS total_visits,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (), 2
    ) AS percentage_of_visits

FROM (

    SELECT
        TIMESTAMPDIFF(
            MINUTE,
            arrival_datetime,
            provider_datetime
        ) AS wait_minutes

    FROM ed_patient_visits

    WHERE arrival_datetime IS NOT NULL
      AND provider_datetime IS NOT NULL
      AND provider_datetime >= arrival_datetime

) valid_waits

GROUP BY wait_time_category

ORDER BY
    CASE wait_time_category
        WHEN '0-30 Minutes' THEN 1
        WHEN '31-60 Minutes' THEN 2
        WHEN '61-90 Minutes' THEN 3
        WHEN '91-120 Minutes' THEN 4
        WHEN 'Over 120 Minutes' THEN 5
    END;


-- =========================================================
-- 7. AVERAGE WAIT TIME BY DAY OF WEEK
-- =========================================================

SELECT

    DAYNAME(arrival_datetime) AS day_of_week,

    COUNT(*) AS total_visits,

    ROUND(
        AVG(TIMESTAMPDIFF(
            MINUTE,
            arrival_datetime,
            provider_datetime
        )), 2
    ) AS average_wait_minutes

FROM ed_patient_visits

WHERE arrival_datetime IS NOT NULL
  AND provider_datetime IS NOT NULL
  AND provider_datetime >= arrival_datetime

GROUP BY
    DAYNAME(arrival_datetime),
    DAYOFWEEK(arrival_datetime)

ORDER BY DAYOFWEEK(arrival_datetime);


-- =========================================================
-- 8. OVERALL ED PERFORMANCE SUMMARY
-- =========================================================

SELECT

    COUNT(*) AS total_visits,

    ROUND(
        AVG(TIMESTAMPDIFF(
            MINUTE,
            arrival_datetime,
            provider_datetime
        )), 2
    ) AS average_wait_minutes,

    ROUND(
        AVG(TIMESTAMPDIFF(
            MINUTE,
            arrival_datetime,
            discharge_datetime
        )), 2
    ) AS average_los_minutes,

    MIN(age) AS minimum_patient_age,

    MAX(age) AS maximum_patient_age

FROM ed_patient_visits

WHERE arrival_datetime IS NOT NULL
  AND provider_datetime IS NOT NULL
  AND discharge_datetime IS NOT NULL
  AND provider_datetime >= arrival_datetime
  AND discharge_datetime >= provider_datetime;


-- =========================================================
-- END OF OPTIMIZATION ANALYSIS
-- =========================================================

