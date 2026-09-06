# Emergency Department Wait-Time Optimization

## Project Overview

This project analyzes 1,000 synthetic emergency department (ED) patient encounters to identify patterns in patient wait times and overall length of stay.

The analysis uses MySQL to evaluate operational factors including arrival patterns, staffing levels, triage acuity, shifts, departments, and patient disposition.

## Business Problem

Emergency departments must balance patient demand, staffing resources, and timely access to providers.

The goal of this analysis is to identify patterns that may help healthcare operations leaders better understand ED flow and identify opportunities for process improvement.

## Dataset

- 1,000 synthetic emergency department encounters
- Patient demographics
- Arrival and clinical timestamps
- Triage levels
- Arrival mode
- Department
- Shift
- Nurse staffing
- Provider staffing
- Patient disposition

## Data Quality Findings

The dataset passed the initial quality checks:

- 0 missing patient IDs
- 0 missing visit IDs
- 0 missing arrival timestamps
- 0 missing triage timestamps
- 0 missing provider timestamps
- 0 missing discharge timestamps
- 0 missing triage levels
- 0 missing chief complaints
- 0 missing nurse counts
- 0 missing provider counts
- 0 invalid clinical timelines

Patient ages ranged from 18 to 95.

Nurse staffing ranged from 4 to 10.

Provider staffing ranged from 2 to 5.

## Key Finding 1: Average Provider Wait Time

The average time from patient arrival to provider evaluation was:

**70.02 minutes**

This represents an important operational metric for evaluating access to providers and overall emergency department flow.

## Key Finding 2: Average Emergency Department Length of Stay

The average time from arrival to discharge was:

**299.51 minutes**

This is approximately **5 hours**.

The length of stay analysis provides additional context beyond provider wait time and can help identify opportunities to improve the overall patient journey.

## Key Finding 3: Wait Time by Shift

Average wait times were very similar across shifts:

| Shift | Visits | Average Wait |
|---|---:|---:|
| Day | 335 | 69.62 min |
| Evening | 333 | 70.16 min |
| Night | 332 | 70.27 min |

The difference between the highest and lowest shift averages was less than one minute.

This suggests that shift alone was not a major differentiator of wait time in this dataset.

## Key Finding 4: Wait Time by Provider Staffing

Average wait times were also very similar across provider staffing levels:

| Providers | Visits | Average Wait |
|---:|---:|---:|
| 2 | 252 | 70.12 min |
| 3 | 252 | 69.95 min |
| 4 | 249 | 70.11 min |
| 5 | 247 | 69.89 min |

The results do not demonstrate a strong relationship between the number of providers and average wait time in this dataset.

Additional operational variables would be needed to determine whether staffing changes could reduce wait times.

## Key Finding 5: Wait Time by Triage Level

| Triage Level | Visits | Average Wait |
|---:|---:|---:|
| 1 | 50 | 70.96 min |
| 2 | 135 | 69.42 min |
| 3 | 174 | 70.76 min |
| 4 | 214 | 70.03 min |
| 5 | 427 | 69.78 min |

Triage level did not show a large difference in average wait time.

However, the dataset contains substantially more lower-acuity Level 5 encounters than Level 1 encounters. This distribution should be considered when interpreting the averages.

## Key Finding 6: Arrival-Time Patterns

Hourly analysis showed relatively consistent average wait times throughout the day.

The highest observed hourly average was approximately **72.41 minutes**, while the lowest was approximately **67.74 minutes**.

This represents a relatively narrow range.

The analysis therefore does not indicate a single hour with an extreme wait-time spike in this dataset.

## Key Finding 7: Length of Stay by Disposition

| Disposition | Visits | Average LOS |
|---|---:|---:|
| Discharged | 789 | 299.67 min |
| Admitted | 144 | 299.65 min |
| Transferred | 67 | 297.19 min |

Average length of stay was similar across disposition groups.

This suggests that disposition alone did not explain substantial differences in length of stay within this dataset.

## Operational Recommendations

### 1. Monitor Door-to-Provider Time

Establish door-to-provider time as a recurring operational KPI.

Leadership could monitor:

- Average wait time
- Median wait time
- 90th percentile wait time
- Percentage of patients waiting more than 60 minutes
- Percentage waiting more than 90 minutes

### 2. Analyze Patient Flow Beyond Staffing Counts

Because provider and nurse counts showed limited differences in average wait times, future analysis should incorporate additional operational variables such as:

- Patient arrival volume
- Provider workload
- Treatment-room availability
- Boarding time
- Registration time
- Triage processing time
- Diagnostic turnaround time

### 3. Focus on High-Wait Encounters

Patients experiencing exceptionally long waits should be analyzed separately.

Segmenting encounters by wait-time thresholds can help identify operational bottlenecks that overall averages may hide.

### 4. Build an ED Performance Dashboard

A dashboard could allow healthcare leaders to monitor:

- Average wait time
- Average length of stay
- Arrival volume
- Wait-time distribution
- Staffing levels
- Triage distribution
- Disposition
- Performance by shift and hour

## Limitations

This analysis uses a synthetic dataset created for portfolio and educational purposes.

The findings should not be interpreted as representing the performance of a real emergency department.

The dataset also does not contain enough operational variables to establish causal relationships between staffing and patient wait times.

Further analysis using real-world operational data would be required before implementing staffing or workflow changes.

## Tools Used

- MySQL
- SQL
- Git
- GitHub
- GitHub Codespaces

## Skills Demonstrated

- SQL data analysis
- Data quality validation
- Healthcare operations analysis
- Time-based analysis
- Aggregation and grouping
- KPI development
- Operational recommendations
- Data storytelling
- Git/GitHub version control
