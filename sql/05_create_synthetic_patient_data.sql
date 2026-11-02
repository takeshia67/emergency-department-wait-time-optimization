
-- =====================================================
-- Emergency Department Wait-Time Optimization
-- File: 05_create_synthetic_patient_data.sql
-- Purpose: Create and validate 1,000 synthetic ED encounters
-- Database: MySQL 8.0+
-- =====================================================

USE emergency_department_analytics;


-- =====================================================
-- 1. CREATE PATIENT ENCOUNTERS TABLE
-- =====================================================

CREATE TABLE IF NOT EXISTS ed_patient_visits (

    patient_id VARCHAR(10) PRIMARY KEY,
    visit_id VARCHAR(10) UNIQUE,
    age INT,
    chief_complaint VARCHAR(100),
    arrival_datetime DATETIME,
    triage_datetime DATETIME,
    provider_datetime DATETIME,
    discharge_datetime DATETIME,
    triage_level INT,
    arrival_mode VARCHAR(30),
    department VARCHAR(50),
    `shift` VARCHAR(20),
    nurse_count INT,
    provider_count INT,
    disposition VARCHAR(30),
    insurance_type VARCHAR(30)

);


-- =====================================================
-- 2. GENERATE 1,000 SYNTHETIC PATIENT ENCOUNTERS
-- =====================================================

INSERT IGNORE INTO ed_patient_visits (

    patient_id,
    visit_id,
    age,
    chief_complaint,
    arrival_datetime,
    triage_datetime,
    provider_datetime,
    discharge_datetime,
    triage_level,
    arrival_mode,
    department,
    `shift`,
    nurse_count,
    provider_count,
    disposition,
    insurance_type

)

SELECT

    CONCAT('P', LPAD(n + 1, 4, '0')),
    CONCAT('V', LPAD(n + 1, 4, '0')),
    age,
    chief_complaint,
    arrival_datetime,

    TIMESTAMPADD(
        MINUTE,
        triage_delay,
        arrival_datetime
    ),

    TIMESTAMPADD(
        MINUTE,
        triage_delay + wait_after_triage,
        arrival_datetime
    ),

    TIMESTAMPADD(
        MINUTE,
        triage_delay + wait_after_triage + stay_minutes,
        arrival_datetime
    ),

    triage_level,
    arrival_mode,
    department,

    CASE
        WHEN HOUR(arrival_datetime) BETWEEN 7 AND 14
            THEN 'Day'
        WHEN HOUR(arrival_datetime) BETWEEN 15 AND 22
            THEN 'Evening'
        ELSE 'Night'
    END,

    nurse_count,
    provider_count,
    disposition,
    insurance_type

FROM (

    SELECT
        base.*,

        5 + MOD(n * 7, 11) AS triage_delay,

        CASE triage_level
            WHEN 1 THEN 5 + MOD(n * 7, 16)
            WHEN 2 THEN 15 + MOD(n * 11, 26)
            WHEN 3 THEN 30 + MOD(n * 13, 41)
            WHEN 4 THEN 40 + MOD(n * 17, 51)
            ELSE 50 + MOD(n * 19, 71)
        END AS wait_after_triage,

        120 + MOD(n * 23, 241) AS stay_minutes

    FROM (

        SELECT
            n,

            18 + MOD(n * 17, 78) AS age,

            CASE
                WHEN n < 50 THEN 1
                WHEN n < 185 THEN 2
                WHEN n < 359 THEN 3
                WHEN n < 573 THEN 4
                ELSE 5
            END AS triage_level,

            CASE MOD(n, 6)
                WHEN 0 THEN 'Chest Pain'
                WHEN 1 THEN 'Abdominal Pain'
                WHEN 2 THEN 'Shortness of Breath'
                WHEN 3 THEN 'Headache'
                WHEN 4 THEN 'Injury'
                ELSE 'Fever'
            END AS chief_complaint,

            TIMESTAMPADD(
                MINUTE,
                n * 37,
                '2025-01-01 00:00:00'
            ) AS arrival_datetime,

            CASE MOD(n, 3)
                WHEN 0 THEN 'Ambulance'
                WHEN 1 THEN 'Walk-In'
                ELSE 'Private Vehicle'
            END AS arrival_mode,

            CASE MOD(n, 3)
                WHEN 0 THEN 'Emergency'
                WHEN 1 THEN 'Fast Track'
                ELSE 'Observation'
            END AS department,

            4 + MOD(n * 3, 7) AS nurse_count,

            2 + MOD(n * 5, 4) AS provider_count,

            CASE
                WHEN n < 789 THEN 'Discharged'
                WHEN n < 933 THEN 'Admitted'
                ELSE 'Transferred'
            END AS disposition,

            CASE MOD(n, 4)
                WHEN 0 THEN 'Private'
                WHEN 1 THEN 'Medicare'
                WHEN 2 THEN 'Medicaid'
                ELSE 'Self-Pay'
            END AS insurance_type

        FROM (

            SELECT
                ones.d
                + tens.d * 10
                + hundreds.d * 100 AS n

            FROM

                (SELECT 0 AS d UNION ALL SELECT 1 UNION ALL
                 SELECT 2 UNION ALL SELECT 3 UNION ALL
                 SELECT 4 UNION ALL SELECT 5 UNION ALL
                 SELECT 6 UNION ALL SELECT 7 UNION ALL
                 SELECT 8 UNION ALL SELECT 9) ones

            CROSS JOIN

                (SELECT 0 AS d UNION ALL SELECT 1 UNION ALL
                 SELECT 2 UNION ALL SELECT 3 UNION ALL
                 SELECT 4 UNION ALL SELECT 5 UNION ALL
                 SELECT 6 UNION ALL SELECT 7 UNION ALL
                 SELECT 8 UNION ALL SELECT 9) tens

            CROSS JOIN

                (SELECT 0 AS d UNION ALL SELECT 1 UNION ALL
                 SELECT 2 UNION ALL SELECT 3 UNION ALL
                 SELECT 4 UNION ALL SELECT 5 UNION ALL
                 SELECT 6 UNION ALL SELECT 7 UNION ALL
                 SELECT 8 UNION ALL SELECT 9) hundreds

        ) numbers

    ) base

) ) AS generated_data;


-- =====================================================
-- 3. VERIFY GENERATED DATASET
-- =====================================================

SELECT
    COUNT(*) AS total_patient_encounters
FROM ed_patient_visits;


-- =====================================================
-- 4. REVIEW PATIENT ENCOUNTER RECORDS
-- =====================================================

SELECT *
FROM ed_patient_visits
LIMIT 10;


-- =====================================================
-- 5. DATA QUALITY VALIDATION
-- =====================================================


-- 5A. Verify total records

SELECT
    COUNT(*) AS total_encounters
FROM ed_patient_visits;


-- 5B. Check for missing values

SELECT

    SUM(patient_id IS NULL) AS missing_patient_id,

    SUM(visit_id IS NULL) AS missing_visit_id,

    SUM(age IS NULL) AS missing_age,

    SUM(arrival_datetime IS NULL) AS missing_arrival,

    SUM(triage_datetime IS NULL) AS missing_triage,

    SUM(provider_datetime IS NULL) AS missing_provider,

    SUM(discharge_datetime IS NULL) AS missing_discharge

FROM ed_patient_visits;


-- 5C. Check for duplicate visit IDs

SELECT
    visit_id,
    COUNT(*) AS duplicate_count

FROM ed_patient_visits

GROUP BY visit_id

HAVING COUNT(*) > 1;


-- 5D. Validate timestamp sequence

SELECT
    COUNT(*) AS invalid_timestamp_records

FROM ed_patient_visits

WHERE arrival_datetime > triage_datetime
   OR triage_datetime > provider_datetime
   OR provider_datetime > discharge_datetime;


-- 5E. Validate patient ages

SELECT
    COUNT(*) AS invalid_age_records

FROM ed_patient_visits

WHERE age < 0
   OR age > 120;


-- 5F. Review triage distribution

SELECT
    triage_level,
    COUNT(*) AS encounter_count

FROM ed_patient_visits

GROUP BY triage_level

ORDER BY triage_level;


-- 5G. Review patient disposition

SELECT
    disposition,
    COUNT(*) AS encounter_count

FROM ed_patient_visits

GROUP BY disposition

ORDER BY encounter_count DESC;


-- 5H. Review staffing distribution

SELECT
    nurse_count,
    provider_count,
    COUNT(*) AS encounter_count

FROM ed_patient_visits

GROUP BY
    nurse_count,
    provider_count

ORDER BY
    nurse_count,
    provider_count;


-- =====================================================
-- END OF SYNTHETIC DATA GENERATION AND VALIDATION
-- =====================================================

