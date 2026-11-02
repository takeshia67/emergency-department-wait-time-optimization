
-- =========================================================
-- Emergency Department Wait-Time Optimization
-- File: 02_data_quality_checks.sql
-- Purpose: Validate data quality before analysis
-- Dataset: 1,000 synthetic ED encounters
-- Database: MySQL 8.0+
-- =========================================================

USE emergency_department_analytics;


-- =========================================================
-- 1. CONFIRM TOTAL ENCOUNTERS
-- =========================================================

SELECT
    COUNT(*) AS total_visits
FROM ed_patient_visits;


-- =========================================================
-- 2. CHECK FOR MISSING CRITICAL FIELDS
-- =========================================================

SELECT

    SUM(patient_id IS NULL) AS missing_patient_id,

    SUM(visit_id IS NULL) AS missing_visit_id,

    SUM(arrival_datetime IS NULL) AS missing_arrival,

    SUM(triage_datetime IS NULL) AS missing_triage,

    SUM(provider_datetime IS NULL) AS missing_provider,

    SUM(discharge_datetime IS NULL) AS missing_discharge,

    SUM(triage_level IS NULL) AS missing_triage_level,

    SUM(chief_complaint IS NULL) AS missing_complaint,

    SUM(nurse_count IS NULL) AS missing_nurse_count,

    SUM(provider_count IS NULL) AS missing_provider_count

FROM ed_patient_visits;


-- =========================================================
-- 3. CHECK FOR INVALID CLINICAL TIMELINES
-- =========================================================

SELECT

    COUNT(*) AS invalid_timeline_records

FROM ed_patient_visits

WHERE arrival_datetime IS NULL
   OR triage_datetime IS NULL
   OR provider_datetime IS NULL
   OR discharge_datetime IS NULL
   OR arrival_datetime > triage_datetime
   OR triage_datetime > provider_datetime
   OR provider_datetime > discharge_datetime;


-- =========================================================
-- 4. CHECK AGE AND STAFFING RANGES
-- =========================================================

SELECT

    MIN(age) AS minimum_age,

    MAX(age) AS maximum_age,

    MIN(nurse_count) AS minimum_nurses,

    MAX(nurse_count) AS maximum_nurses,

    MIN(provider_count) AS minimum_providers,

    MAX(provider_count) AS maximum_providers

FROM ed_patient_visits;


-- =========================================================
-- 5. CHECK FOR DUPLICATE PATIENT AND VISIT IDENTIFIERS
-- =========================================================

SELECT
    patient_id,
    COUNT(*) AS duplicate_count

FROM ed_patient_visits

GROUP BY patient_id

HAVING COUNT(*) > 1;


SELECT
    visit_id,
    COUNT(*) AS duplicate_count

FROM ed_patient_visits

GROUP BY visit_id

HAVING COUNT(*) > 1;


-- =========================================================
-- 6. CHECK FOR INVALID PATIENT AGES
-- =========================================================

SELECT

    COUNT(*) AS invalid_age_records

FROM ed_patient_visits

WHERE age IS NULL
   OR age < 0
   OR age > 120;


-- =========================================================
-- 7. CHECK FOR INVALID TRIAGE LEVELS
-- =========================================================

SELECT

    COUNT(*) AS invalid_triage_records

FROM ed_patient_visits

WHERE triage_level IS NULL
   OR triage_level NOT BETWEEN 1 AND 5;


-- =========================================================
-- 8. CHECK FOR INVALID STAFFING VALUES
-- =========================================================

SELECT

    COUNT(*) AS invalid_staffing_records

FROM ed_patient_visits

WHERE nurse_count IS NULL
   OR nurse_count < 1
   OR provider_count IS NULL
   OR provider_count < 1;


-- =========================================================
-- 9. CHECK FOR INVALID WAIT TIMES
-- =========================================================

SELECT

    COUNT(*) AS invalid_wait_time_records

FROM ed_patient_visits

WHERE arrival_datetime IS NULL
   OR provider_datetime IS NULL
   OR provider_datetime < arrival_datetime;


-- =========================================================
-- 10. CHECK FOR INVALID LENGTH OF STAY
-- =========================================================

SELECT

    COUNT(*) AS invalid_los_records

FROM ed_patient_visits

WHERE arrival_datetime IS NULL
   OR discharge_datetime IS NULL
   OR discharge_datetime < arrival_datetime;


-- =========================================================
-- 11. REVIEW TRIAGE LEVEL DISTRIBUTION
-- =========================================================

SELECT

    triage_level,

    COUNT(*) AS total_visits

FROM ed_patient_visits

GROUP BY triage_level

ORDER BY triage_level;


-- =========================================================
-- 12. REVIEW DEPARTMENT VALUES
-- =========================================================

SELECT

    department,

    COUNT(*) AS total_visits

FROM ed_patient_visits

GROUP BY department

ORDER BY department;


-- =========================================================
-- 13. REVIEW DISPOSITION VALUES
-- =========================================================

SELECT

    disposition,

    COUNT(*) AS total_visits

FROM ed_patient_visits

GROUP BY disposition

ORDER BY disposition;


-- =========================================================
-- END OF DATA QUALITY CHECKS
-- =========================================================

