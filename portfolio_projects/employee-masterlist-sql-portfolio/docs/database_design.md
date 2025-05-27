# Database Requirements and Structure (Updated)

## Introduction

This document outlines a normalized, scalable database schema for managing employee masterlist data in a BPO context, supporting migration, analysis, and workforce optimization.

### Objective
- Enable robust migration, analytics, and operational reporting.
- Support workforce optimization and attrition modeling.

### Context
- BPO environment, focusing on OTC processes and operational relevance.

---

## Data Description

### Sources
- Original data from Excel, migrated to MySQL.

### Schema Walkthrough

#### Core Tables and Fields

| Table Name            | Key Fields & Description                                                                                  |
|-----------------------|----------------------------------------------------------------------------------------------------------|
| **employees**         | employee_id (PK), first_name, last_name, gender (ENUM), date_of_birth, hire_date, termination_date, status (ENUM: Active, Terminated), contact_number (anonymized), email, address, cluster_id (FK), team_id (FK), lob_id (FK) |
| **lines_of_business** | lob_id (PK), lob_name                                                                                   |
| **teams**             | team_id (PK), team_name, team_leader_id (FK: employees), cluster_id (FK)                                |
| **clusters**          | cluster_id (PK), cluster_name, cluster_manager_id (FK: employees)                                        |
| **emergency_contacts**| contact_id (PK), employee_id (FK), name, relationship, phone                                            |
| **performance_reviews**| review_id (PK), employee_id (FK), review_date, reviewer_id (FK: employees), score, notes               |
| **attendance_logs**   | attendance_id (PK), employee_id (FK), date, shift (ENUM), status (ENUM: Present, Absent, Leave, etc.)   |
| **disciplinary_actions**| action_id (PK), employee_id (FK), date, type, description, outcome                                    |
| **bcp_readiness**     | bcp_id (PK), employee_id (FK), status (ENUM), last_updated                                              |
| **seat_assignments**  | seat_id (PK), employee_id (FK), location, seat_number, effective_date                                   |
| **asset_tracking**    | asset_id (PK), employee_id (FK), asset_tag, type, assigned_date, returned_date                          |
| **account_directory** | account_id (PK), employee_id (FK), account_name, team_id (FK), lob_id (FK)                              |

#### Data Integrity & Constraints

- Foreign keys enforce referential integrity (e.g., employees.team_id → teams.team_id).
- ENUMs for gender, employment status, attendance status, BCP readiness.
- Indexes on frequently queried fields (employee_id, team_id, lob_id).
- Unique constraints on email, asset_tag, seat_number.

#### Modular Expansion

- Schema supports adding new clients, departments, LOBs, and teams without redesign.

#### Data Distribution

- Employees located in Metro Manila and nearby provinces.
- Includes graveyard shift workforce.
- Gender balance maintained.
- Termination records (voluntary/involuntary) retained for historical analysis.

#### Handling Missing Data & Field Derivation

- Nulls allowed for optional fields (e.g., termination_date).
- Derived fields: tenure (hire_date to current/termination), attrition flag.

---

## Exploratory Analysis

- Distributions: Age, tenure, role, gender, LOB.
- Visual summaries: Tables, charts.
- Data validation and profiling steps.

---

## Statistical Methods

- Segmentations: Gender, LOB, team.
- Attrition modeling (voluntary/involuntary).
- Capacity and performance correlation.
- SQL for preprocessing; R/Python/Excel for modeling.

---

## Results

- Workforce patterns, gaps, attrition rates.
- Impact of coaching and performance reviews.
- Visualization: Trends, heatmaps, org structure.

---

## Conclusion

- Summary of findings and actionable recommendations (e.g., hiring, attrition response).
- Next steps: Dashboard development, ETL automation.

---

## Naming Conventions

- Table and field names use snake_case.
- Primary keys: `<table>_id`.
- Foreign keys: `<referenced_table>_id`.



---

## ER Diagram (Mermaid Code)

erDiagram
    employees {
        INT employee_id PK
        VARCHAR first_name
        VARCHAR last_name
        ENUM gender
        DATE date_of_birth
        DATE hire_date
        DATE termination_date
        ENUM status
        VARCHAR contact_number
        VARCHAR email
        VARCHAR address
        INT cluster_id FK
        INT team_id FK
        INT lob_id FK
    }
    lines_of_business {
        INT lob_id PK
        VARCHAR lob_name
    }
    teams {
        INT team_id PK
        VARCHAR team_name
        INT team_leader_id FK
        INT cluster_id FK
    }
    clusters {
        INT cluster_id PK
        VARCHAR cluster_name
        INT cluster_manager_id FK
    }
    emergency_contacts {
        INT contact_id PK
        INT employee_id FK
        VARCHAR name
        VARCHAR relationship
        VARCHAR phone
    }
    performance_reviews {
        INT review_id PK
        INT employee_id FK
        DATE review_date
        INT reviewer_id FK
        INT score
        VARCHAR notes
    }
    attendance_logs {
        INT attendance_id PK
        INT employee_id FK
        DATE date
        ENUM shift
        ENUM status
    }
    disciplinary_actions {
        INT action_id PK
        INT employee_id FK
        DATE date
        VARCHAR type
        VARCHAR description
        VARCHAR outcome
    }
    bcp_readiness {
        INT bcp_id PK
        INT employee_id FK
        ENUM status
        DATE last_updated
    }
    seat_assignments {
        INT seat_id PK
        INT employee_id FK
        VARCHAR location
        VARCHAR seat_number
        DATE effective_date
    }
    asset_tracking {
        INT asset_id PK
        INT employee_id FK
        VARCHAR asset_tag
        VARCHAR type
        DATE assigned_date
        DATE returned_date
    }
    account_directory {
        INT account_id PK
        INT employee_id FK
        VARCHAR account_name
        INT team_id FK
        INT lob_id FK
    }

    employees ||--o{ emergency_contacts : "has"
    employees ||--o{ performance_reviews : "reviewed"
    employees ||--o{ attendance_logs : "attendance"
    employees ||--o{ disciplinary_actions : "subject to"
    employees ||--o{ bcp_readiness : "bcp status"
    employees ||--o{ seat_assignments : "assigned seat"
    employees ||--o{ asset_tracking : "assigned asset"
    employees ||--o{ account_directory : "account"
    employees }o--|| teams : "member of"
    employees }o--|| clusters : "part of"
    employees }o--|| lines_of_business : "assigned to"
    teams ||--o{ employees : "led by"
    teams }o--|| clusters : "belongs to"
    clusters ||--o{ employees : "managed by"
