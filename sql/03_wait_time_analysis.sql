-- Emergency Department Wait-Time Optimization
-- File: 03_wait_time_analysis.sql
-- Purpose: Analyze ED door-to-provider wait times
-- Dataset: 1,000 synthetic ED encounters

USE emergency_department_analytics;


-- =========================================================
-- 1. Overall Average Door-to-Provider Wait Time
-- =========================================================

SELECT
    ROUND(
        AVG(
            TIMESTAMPDIFF(
                MINUTE,
                arrival_datetime,
                provider_datetime
            )
        ),
        2
    ) AS average_wait_minutes
FROM ed_patient_visits;


-- =========================================================
-- 2. Door-to-Provider Wait Time by Shift
-- =========================================================

SELECT
    shift,
    COUNT(*) AS total_visits,
    ROUND(
        AVG(
            TIMESTAMPDIFF(
                MINUTE,
                arrival_datetime,
                provider_datetime
            )
        ),
        2
    ) AS average_wait_minutes
FROM ed_patient_visits
GROUP BY shift
ORDER BY average_wait_minutes DESC;


-- =========================================================
-- 3. Door-to-Provider Wait Time by Nurse Staffing
-- =========================================================

SELECT
    nurse_count,
    COUNT(*) AS total_visits,
    ROUND(
        AVG(
            TIMESTAMPDIFF(
                MINUTE,
                arrival_datetime,
                provider_datetime
            )
        ),
        2
    ) AS average_wait_minutes
FROM ed_patient_visits
GROUP BY nurse_count
ORDER BY nurse_count;


-- =========================================================
-- 4. Door-to-Provider Wait Time by Provider Staffing
-- =========================================================

SELECT
    provider_count,
    COUNT(*) AS total_visits,
    ROUND(
        AVG(
            TIMESTAMPDIFF(
                MINUTE,
                arrival_datetime,
                provider_datetime
            )
        ),
        2
    ) AS average_wait_minutes
FROM ed_patient_visits
GROUP BY provider_count
ORDER BY provider_count;


-- =========================================================
-- 5. Door-to-Provider Wait Time by Triage Level
-- =========================================================

SELECT
    triage_level,
    COUNT(*) AS total_visits,
    ROUND(
        AVG(
            TIMESTAMPDIFF(
                MINUTE,
                arrival_datetime,
                provider_datetime
            )
        ),
        2
    ) AS average_wait_minutes
FROM ed_patient_visits
GROUP BY triage_level
ORDER BY triage_level;


-- =========================================================
-- 6. Arrival Volume and Wait Time by Hour
-- =========================================================

SELECT
    HOUR(arrival_datetime) AS arrival_hour,
    COUNT(*) AS total_arrivals,
    ROUND(
        AVG(
            TIMESTAMPDIFF(
                MINUTE,
                arrival_datetime,
                provider_datetime
            )
        ),
        2
    ) AS average_wait_minutes
FROM ed_patient_visits
GROUP BY HOUR(arrival_datetime)
ORDER BY arrival_hour;


-- =========================================================
-- 7. Overall ED Length of Stay
-- =========================================================

SELECT
    ROUND(
        AVG(
            TIMESTAMPDIFF(
                MINUTE,
                arrival_datetime,
                discharge_datetime
            )
        ),
        2
    ) AS average_los_minutes
FROM ed_patient_visits;


-- =========================================================
-- 8. ED Length of Stay by Disposition
-- =========================================================

SELECT
    disposition,
    COUNT(*) AS total_visits,
    ROUND(
        AVG(
            TIMESTAMPDIFF(
                MINUTE,
                arrival_datetime,
                discharge_datetime
            )
        ),
        2
    ) AS average_los_minutes
FROM ed_patient_visits
GROUP BY disposition
ORDER BY average_los_minutes DESC;

