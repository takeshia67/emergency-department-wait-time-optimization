
-- =========================================================
-- Emergency Department Wait-Time Optimization
-- File: 03_wait_time_analysis.sql
-- Purpose: Analyze ED door-to-provider wait times
-- Dataset: 1,000 synthetic ED encounters
-- Database: MySQL 8.0+
-- =========================================================

USE emergency_department_analytics;


-- =========================================================
-- 1. OVERALL AVERAGE DOOR-TO-PROVIDER WAIT TIME
-- =========================================================

SELECT
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
  AND provider_datetime >= arrival_datetime;


-- =========================================================
-- 2. DOOR-TO-PROVIDER WAIT TIME BY SHIFT
-- =========================================================

SELECT
    `shift`,
    COUNT(*) AS total_visits,

    ROUND(
        AVG(TIMESTAMPDIFF(
            MINUTE,
            arrival_datetime,
            provider_datetime
        )), 2
    ) AS average_wait_minutes

FROM ed_patient_visits

WHERE provider_datetime >= arrival_datetime

GROUP BY `shift`

ORDER BY average_wait_minutes DESC;


-- =========================================================
-- 3. DOOR-TO-PROVIDER WAIT TIME BY NURSE STAFFING
-- =========================================================

SELECT
    nurse_count,
    COUNT(*) AS total_visits,

    ROUND(
        AVG(TIMESTAMPDIFF(
            MINUTE,
            arrival_datetime,
            provider_datetime
        )), 2
    ) AS average_wait_minutes

FROM ed_patient_visits

WHERE provider_datetime >= arrival_datetime

GROUP BY nurse_count

ORDER BY nurse_count;


-- =========================================================
-- 4. DOOR-TO-PROVIDER WAIT TIME BY PROVIDER STAFFING
-- =========================================================

SELECT
    provider_count,
    COUNT(*) AS total_visits,

    ROUND(
        AVG(TIMESTAMPDIFF(
            MINUTE,
            arrival_datetime,
            provider_datetime
        )), 2
    ) AS average_wait_minutes

FROM ed_patient_visits

WHERE provider_datetime >= arrival_datetime

GROUP BY provider_count

ORDER BY provider_count;


-- =========================================================
-- 5. DOOR-TO-PROVIDER WAIT TIME BY TRIAGE LEVEL
-- =========================================================

SELECT
    triage_level,
    COUNT(*) AS total_visits,

    ROUND(
        AVG(TIMESTAMPDIFF(
            MINUTE,
            arrival_datetime,
            provider_datetime
        )), 2
    ) AS average_wait_minutes

FROM ed_patient_visits

WHERE provider_datetime >= arrival_datetime

GROUP BY triage_level

ORDER BY triage_level;


-- =========================================================
-- 6. ARRIVAL VOLUME AND WAIT TIME BY HOUR
-- =========================================================

SELECT
    HOUR(arrival_datetime) AS arrival_hour,
    COUNT(*) AS total_arrivals,

    ROUND(
        AVG(TIMESTAMPDIFF(
            MINUTE,
            arrival_datetime,
            provider_datetime
        )), 2
    ) AS average_wait_minutes

FROM ed_patient_visits

WHERE provider_datetime >= arrival_datetime

GROUP BY HOUR(arrival_datetime)

ORDER BY arrival_hour;


-- =========================================================
-- 7. OVERALL ED LENGTH OF STAY
-- =========================================================

SELECT
    COUNT(*) AS total_visits,

    ROUND(
        AVG(TIMESTAMPDIFF(
            MINUTE,
            arrival_datetime,
            discharge_datetime
        )), 2
    ) AS average_los_minutes,

    ROUND(
        AVG(TIMESTAMPDIFF(
            MINUTE,
            arrival_datetime,
            discharge_datetime
        )) / 60, 2
    ) AS average_los_hours

FROM ed_patient_visits

WHERE discharge_datetime >= arrival_datetime;


-- =========================================================
-- 8. ED LENGTH OF STAY BY DISPOSITION
-- =========================================================

SELECT
    disposition,
    COUNT(*) AS total_visits,

    ROUND(
        AVG(TIMESTAMPDIFF(
            MINUTE,
            arrival_datetime,
            discharge_datetime
        )), 2
    ) AS average_los_minutes

FROM ed_patient_visits

WHERE discharge_datetime >= arrival_datetime

GROUP BY disposition

ORDER BY average_los_minutes DESC;


-- =========================================================
-- 9. MEDIAN AND 90TH PERCENTILE WAIT TIME
-- =========================================================

WITH ranked_waits AS (

    SELECT
        TIMESTAMPDIFF(
            MINUTE,
            arrival_datetime,
            provider_datetime
        ) AS wait_minutes,

        ROW_NUMBER() OVER (
            ORDER BY TIMESTAMPDIFF(
                MINUTE,
                arrival_datetime,
                provider_datetime
            )
        ) AS row_num,

        COUNT(*) OVER () AS total_rows

    FROM ed_patient_visits

    WHERE arrival_datetime IS NOT NULL
      AND provider_datetime IS NOT NULL
      AND provider_datetime >= arrival_datetime

)

SELECT

    ROUND(
        AVG(
            CASE
                WHEN row_num IN (
                    FLOOR((total_rows + 1) / 2),
                    FLOOR((total_rows + 2) / 2)
                )
                THEN wait_minutes
            END
        ), 2
    ) AS median_wait_minutes,

    MAX(
        CASE
            WHEN row_num = CEIL(total_rows * 0.90)
            THEN wait_minutes
        END
    ) AS p90_wait_minutes

FROM ranked_waits;


-- =========================================================
-- 10. PERCENTAGE OF PATIENTS EXCEEDING WAIT-TIME THRESHOLDS
-- =========================================================

SELECT

    COUNT(*) AS total_visits,

    ROUND(
        SUM(
            CASE
                WHEN TIMESTAMPDIFF(
                    MINUTE,
                    arrival_datetime,
                    provider_datetime
                ) > 60
                THEN 1 ELSE 0
            END
        ) * 100.0 / COUNT(*), 2
    ) AS percentage_over_60_minutes,

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
-- 11. DOOR-TO-PROVIDER WAIT TIME BY DEPARTMENT
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
    ) AS average_wait_minutes,

    ROUND(
        AVG(TIMESTAMPDIFF(
            MINUTE,
            arrival_datetime,
            discharge_datetime
        )), 2
    ) AS average_los_minutes

FROM ed_patient_visits

WHERE provider_datetime >= arrival_datetime
  AND discharge_datetime >= arrival_datetime

GROUP BY department

ORDER BY average_wait_minutes DESC;


-- =========================================================
-- END OF WAIT-TIME ANALYSIS
-- =========================================================


