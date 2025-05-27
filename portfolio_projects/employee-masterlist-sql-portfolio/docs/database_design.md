# Database Requirements and Structure

## Introduction

This document details a normalized, scalable database schema for managing employee masterlist data in a BPO context. The design supports data migration, analytics, operational reporting, and workforce optimization.

### Objectives

- Enable robust migration, analytics, and operational reporting.
- Support workforce optimization and attrition modeling.

### Context

- Designed for a BPO environment, with a focus on OTC processes and operational relevance.

---

## Data Description

### Data Sources

- Original data sourced from Excel, migrated to MySQL.

### Schema Overview

#### Core Tables

- **employees**: Stores employee demographic and employment details.
- **lines_of_business**: Defines lines of business (LOBs).
- **teams**: Contains team information and leadership assignments.
- **clusters**: Represents organizational clusters and their managers.
- **emergency_contacts**: Maintains employee emergency contact details.
- **performance_reviews**: Tracks employee performance review records.
- **attendance_logs**: Logs employee attendance and shift information.
- **disciplinary_actions**: Records disciplinary actions taken.
- **bcp_readiness**: Captures business continuity planning readiness.
- **seat_assignments**: Manages seat and location assignments.
- **asset_tracking**: Tracks company assets assigned to employees.
- **account_directory**: Lists account assignments and affiliations.

#### Data Integrity & Constraints

- Foreign keys enforce referential integrity.
- ENUMs standardize categorical fields (e.g., gender, employment status).
- Indexes on frequently queried fields (e.g., employee_id, team_id, lob_id).
- Unique constraints on email, asset_tag, and seat_number.

#### Scalability

- The schema supports modular expansion for new clients, departments, LOBs, and teams.

#### Data Distribution

- Employees are located in Metro Manila and nearby provinces.
- Includes graveyard shift workforce and maintains gender balance.
- Retains termination records for historical analysis.

#### Handling Missing Data & Derived Fields

- Optional fields allow nulls (e.g., termination_date).
- Derived fields include tenure and attrition flag.

---

## Exploratory Analysis

- Analyze distributions: age, tenure, role, gender, LOB.
- Provide visual summaries (tables, charts).
- Conduct data validation and profiling.

---

## Statistical Methods

- Segment data by gender, LOB, and team.
- Model attrition (voluntary/involuntary).
- Analyze capacity and performance correlations.
- Use SQL for preprocessing; R/Python/Excel for modeling.

---

## Results

- Identify workforce patterns, gaps, and attrition rates.
- Assess impact of coaching and performance reviews.
- Visualize trends, heatmaps, and organizational structure.

---

## Conclusion

- Summarize findings and actionable recommendations (e.g., hiring, attrition response).
- Outline next steps: dashboard development and ETL automation.

---

## Naming Conventions

- Use snake_case for table and field names.
- Primary keys: `<table>_id`.
- Foreign keys: `<referenced_table>_id`.

---

## Entity Relationship Diagram

Refer to the separate Mermaid diagram file in this folder for the complete ER diagram.
