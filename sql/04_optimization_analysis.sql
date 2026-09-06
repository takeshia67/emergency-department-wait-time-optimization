-- Emergency Department Wait-Time Optimization
-- File: 04_optimization_analysis.sql
-- Purpose: Identify operational opportunities to improve ED patient flow
-- Dataset: 1,000 synthetic ED encounters

USE emergency_department_analytics;


-- 1. Wait Time by Arrival Mode

SELECT
    arrival_mode,
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
GROUP BY arrival_mode
ORDER BY average_wait_minutes DESC;


-- 2. Wait Time by Department

SELECT
    department,
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
GROUP BY department
ORDER BY average_wait_minutes DESC;


-- 3. Wait Time by Insurance Type

SELECT
    insurance_type,
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
GROUP BY insurance_type
ORDER BY average_wait_minutes DESC;


-- 4. Encounters With Wait Times Over 90 Minutes

SELECT
    COUNT(*) AS visits_over_90_minutes,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM ed_patient_visits),
        2
    ) AS percentage_over_90_minutes
FROM ed_patient_visits
WHERE TIMESTAMPDIFF(
    MINUTE,
    arrival_datetime,
    provider_datetime
) > 90;


-- 5. Encounters With Wait Times Over 120 Minutes

SELECT
    COUNT(*) AS visits_over_120_minutes,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM ed_patient_visits),
        2
    ) AS percentage_over_120_minutes
FROM ed_patient_visits
WHERE TIMESTAMPDIFF(
    MINUTE,
    arrival_datetime,
    provider_datetime
) > 120;


-- 6. Wait-Time Categories

SELECT
    CASE
        WHEN TIMESTAMPDIFF(
            MINUTE,
            arrival_datetime,
            provider_datetime
        ) <= 30 THEN '0-30 Minutes'

        WHEN TIMESTAMPDIFF(
            MINUTE,
            arrival_datetime,
            provider_datetime
        ) <= 60 THEN '31-60 Minutes'

        WHEN TIMESTAMPDIFF(
            MINUTE,
            arrival_datetime,
            provider_datetime
        ) <= 90 THEN '61-90 Minutes'

        WHEN TIMESTAMPDIFF(
            MINUTE,
            arrival_datetime,
            provider_datetime
        ) <= 120 THEN '91-120 Minutes'

        ELSE 'Over 120 Minutes'
    END AS wait_time_category,

    COUNT(*) AS total_visits

FROM ed_patient_visits

GROUP BY wait_time_category

ORDER BY
    CASE wait_time_category
        WHEN '0-30 Minutes' THEN 1
        WHEN '31-60 Minutes' THEN 2
        WHEN '61-90 Minutes' THEN 3
        WHEN '91-120 Minutes' THEN 4
        WHEN 'Over 120 Minutes' THEN 5
    END;


-- 7. Average Wait Time by Day of Week

SELECT
    DAYNAME(arrival_datetime) AS day_of_week,
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

GROUP BY
    DAYNAME(arrival_datetime),
    DAYOFWEEK(arrival_datetime)

ORDER BY DAYOFWEEK(arrival_datetime);


-- 8. Overall ED Performance Summary

SELECT
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
    ) AS average_wait_minutes,

    ROUND(
        AVG(
            TIMESTAMPDIFF(
                MINUTE,
                arrival_datetime,
                discharge_datetime
            )
        ),
        2
    ) AS average_los_minutes,

    MIN(age) AS minimum_patient_age,

    MAX(age) AS maximum_patient_age

FROM ed_patient_visits;
