-- Emergency Department Wait-Time Optimization
-- File: 02_data_quality_checks.sql
-- Purpose: Validate data quality before analysis
-- Dataset: 1,000 synthetic ED encounters

USE emergency_department_analytics;

-- 1. Confirm total encounters
SELECT
    COUNT(*) AS total_visits
FROM ed_patient_visits;

-- 2. Check for missing critical fields
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

-- 3. Check for invalid clinical timelines
SELECT
    COUNT(*) AS invalid_timeline_records
FROM ed_patient_visits
WHERE arrival_datetime > triage_datetime
   OR triage_datetime > provider_datetime
   OR provider_datetime > discharge_datetime;

-- 4. Check age and staffing ranges
SELECT
    MIN(age) AS minimum_age,
    MAX(age) AS maximum_age,
    MIN(nurse_count) AS minimum_nurses,
    MAX(nurse_count) AS maximum_nurses,
    MIN(provider_count) AS minimum_providers,
    MAX(provider_count) AS maximum_providers
FROM ed_patient_visits;
