# 🏠 AI-Assisted Property Inspection Workspace

## Overview
This project is a lightweight AI-assisted inspection workspace designed to help inspectors, regulators, and property managers quickly assess property conditions using structured inspection data stored in Snowflake.

The solution analyzes room-level inspection findings, classifies defects, assigns risk scores, and generates a plain-language summary — all displayed through an interactive Streamlit UI running inside Snowflake.

---

## Problem Statement
Manual property inspections generate large volumes of unstructured notes that are hard to analyze consistently. Risk assessment is subjective, time-consuming, and often delayed, leading to poor decision-making and compliance risks.

---

## Solution
An end-to-end inspection analysis workspace that:
- Reads structured inspection data from Snowflake
- Automatically classifies defects using rule-based AI logic
- Calculates room-level and property-level risk scores
- Produces a plain-language inspection summary
- Visualizes results in a Streamlit UI

---

## Key Features
- Property selection from Snowflake tables
- Room-level defect classification
- Severity tagging (High / Medium / Low)
- Risk scoring and aggregation
- Plain-language inspection summary
- Interactive Streamlit dashboard
- No external ML models required

---

## Architecture
Snowflake Tables
├── PROPERTY
├── ROOM
└── FINDINGS
↓
Snowflake SQL (Snowpark)
↓
Python Rule Engine
(Defect classification & risk scoring)
↓
Streamlit App (Snowflake Native)
↓
User Dashboard (Tables, Metrics, Summary)

## Tech Stack
- **Snowflake**: Data storage & SQL processing
- **Snowpark (Python)**: Data processing layer
- **Streamlit (in Snowflake)**: User interface
- **Python**: Business rules & logic
- **Pandas**: Data transformation

---

## Snowflake Capabilities Used
- Snowflake Worksheets & SQL
- Snowpark Python session
- Streamlit in Snowsight
- Structured data tables

---

## Why This Is Different
- No dependency on external LLMs or APIs
- Fully runs inside Snowflake (secure & compliant)
- Explainable rule-based decisions
- Faster and cheaper than AI-heavy solutions
- Designed for governance and auditability

---

## Future Enhancements
- Snowflake Cortex integration for NLP summaries
- Dynamic Tables for continuous evaluation
- Historical trend analysis
- Image-based inspection (OCR) support
- Automated alerts using Streams & Tasks

---

## Cost
- Built entirely using **Snowflake Free / Trial features**
- No paid APIs or external infrastructure

---

## Author
**Rathnagar**  
AI-Assisted Inspection Prototype
