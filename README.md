# Emergency Department Wait-Time Optimization

## Healthcare Data Analytics Portfolio Project

### Project Overview

This project uses SQL to analyze emergency department (ED) patient-flow data and identify opportunities to improve wait times and operational efficiency.

The analysis examines 1,000 synthetic patient encounters using MySQL, with a focus on provider wait time, emergency department length of stay, staffing, triage acuity, arrival patterns, and patient disposition.

---

## Business Problem

Emergency departments must balance patient demand, staffing resources, and timely access to care.

Long patient waits can affect patient experience, operational efficiency, and overall throughput.

The objective of this project is to use healthcare data analysis to:

- Measure ED provider wait times
- Evaluate overall length of stay
- Identify patterns in patient flow
- Compare wait times across operational factors
- Identify potential areas for process improvement
- Translate analytical findings into operational recommendations

---

## Key Performance Indicators

| KPI | Result |
|---|---:|
| Total ED Visits | 1,000 |
| Average Provider Wait Time | 70.02 minutes |
| Average ED Length of Stay | 299.51 minutes |
| Average ED Length of Stay | ~5 hours |
| Minimum Patient Age | 18 |
| Maximum Patient Age | 95 |

---

## Key Findings

### Provider Wait Time

The average time from patient arrival to provider evaluation was **70.02 minutes**.

### Emergency Department Length of Stay

The average time from arrival to discharge was **299.51 minutes**, or approximately **5 hours**.

### Shift Analysis

Wait times were relatively consistent across shifts:

- Day: 69.62 minutes
- Evening: 70.16 minutes
- Night: 70.27 minutes

The difference between the highest and lowest shift averages was less than one minute.

### Provider Staffing

Average wait times were also similar across provider staffing levels.

| Providers | Visits | Average Wait |
|---:|---:|---:|
| 2 | 252 | 70.12 min |
| 3 | 252 | 69.95 min |
| 4 | 249 | 70.11 min |
| 5 | 247 | 69.89 min |

The results do not demonstrate a strong relationship between provider count and wait time within this dataset.

### Triage Analysis

Wait times were relatively consistent across triage levels.

Level 5 represented the largest patient group with 427 encounters, while Level 1 represented 50 encounters.

### Arrival-Time Analysis

Hourly wait times remained relatively stable throughout the day.

The highest observed hourly average was approximately 72.41 minutes and the lowest was approximately 67.74 minutes.

---

## Data Quality

The dataset passed the initial quality checks:

- 0 missing patient IDs
- 0 missing visit IDs
- 0 missing critical timestamps
- 0 missing triage levels
- 0 missing chief complaints
- 0 missing staffing values
- 0 invalid clinical timelines

This provided a clean foundation for the analysis.

---

## Operational Recommendations

### 1. Monitor Door-to-Provider Time

Track door-to-provider time as a recurring operational KPI.

Recommended measures include:

- Average wait time
- Median wait time
- 90th percentile wait time
- Percentage waiting more than 60 minutes
- Percentage waiting more than 90 minutes

### 2. Evaluate Patient Flow Beyond Staffing Counts

Because provider and nurse counts showed limited variation in average wait time, additional operational variables should be evaluated.

Potential variables include:

- Patient arrival volume
- Provider workload
- Treatment-room availability
- Registration time
- Triage processing time
- Diagnostic turnaround time
- Boarding time

### 3. Investigate High-Wait Encounters

Analyze patients experiencing exceptionally long waits separately from overall averages.

This can help identify bottlenecks that may not be visible when looking only at average performance.

### 4. Develop an ED Performance Dashboard

A future dashboard could monitor:

- Provider wait time
- Length of stay
- Arrival volume
- Wait-time distribution
- Staffing
- Triage acuity
- Disposition
- Hourly and shift-level performance

---

## Important Analytical Consideration

This analysis does **not** establish that staffing levels, shifts, or triage levels cause changes in wait times.

The differences observed in the dataset were relatively small.

Additional operational variables and real-world data would be necessary to establish causal relationships.

---

## Project Structure

```text
Emergency-Department-Wait-Time-Optimization/
│
├── README.md
│
├── analysis/
│   └── findings.md
│
└── sql/
    ├── 01_database_setup.sql
    ├── 02_data_quality_checks.sql
    ├── 03_wait_time_analysis.sql
    └── 04_optimization_analysis.sql
