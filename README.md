# AI-Powered Welfare Monitoring and Preventive Support System for Uniformed-Force Personnel

> **Tagline**: *Detect Early. Understand the Cause. Prevent Escalation. Measure Recovery.*

> [!IMPORTANT]
> **PREVENTIVE DECISION SUPPORT DISCLAIMER**:
> This system is **NOT** a medical diagnosis system and does **NOT** provide clinical diagnoses or prescribe treatment. It is an operational **preventive welfare decision-support platform** designed to assist force welfare officers and commanders. AI recommendations assist humans; AI does **NOT** automatically make disciplinary, medical, or personnel deployment decisions.

---

## Table of Contents
1. [Project Overview & Problem Statement](#project-overview--problem-statement)
2. [Core System Features](#core-system-features)
3. [System Architecture](#system-architecture)
4. [Machine Learning & Optimization Pipeline](#machine-learning--optimization-pipeline)
5. [Database Schema (27 Tables)](#database-schema-27-tables)
6. [API Endpoints Reference](#api-endpoints-reference)
7. [Installation & Setup Guide](#installation--setup-guide)
8. [Demo Credentials & Scenarios](#demo-credentials--scenarios)
9. [SIH Live 5-Minute Presentation Flow](#sih-live-5-minute-presentation-flow)

---

## Project Overview & Problem Statement

Uniformed-force personnel (defense, police, paramilitary, disaster response) face extended duty hours, high-altitude or border deployments, night shifts, and operational stress. Manual observation frequently fails to detect gradual changes in individual wellness early.

This system provides an end-to-end preventive welfare intelligence platform that:
- Collects structured daily wellness and operational duty metrics.
- Learns each individual's personal wellness baseline over rolling historical windows.
- Detects meaningful baseline deviations and subtle anomalies using Isolation Forest.
- Calculates a transparent, weighted **Recovery Debt** indicator ($0-100$).
- Predicts calibrated wellness-support risk categories using XGBoost.
- Explains **WHY** risk changed using SHAP (SHapley Additive exPlanations).
- Optimizes duty rotations using **Google OR-Tools CP-SAT** solver.
- Evaluates cognitive load concerns before demanding task assignments.
- Supports welfare officers in intervention planning and measures before/after recovery outcomes.
- Enables discreet emergency field SOS workflow.
- Guarantees privacy through role-based access control (RBAC), minimum necessary data exposure, and IndexedDB offline field operation.

---

## Core System Features

| Feature | Description | Implementation Engine |
| :--- | :--- | :--- |
| **Calibrated Risk Classifier** | Predicts risk (`LOW`, `MODERATE`, `ELEVATED`, `HIGH`) with true probabilities. | XGBoost + `CalibratedClassifierCV` (Fallback: `RandomForest`) |
| **Personal Baseline Engine** | Individual rolling mean & std dev (7–30 records) instead of static thresholds. | Rolling Pandas Statistical Engine |
| **Anomaly Detection** | Detects behavioral & duty deviations. | `IsolationForest` (contamination=0.08) |
| **Root-Cause Explanation** | Identifies top contributing factors & percentage impact. | `SHAP` TreeExplainer & Narrative Generator |
| **Recovery Debt** | Transparent weighted recovery deficit score ($0-100$). | Mathematical Weighted Deficit Formula |
| **Duty Rotation Optimizer** | Generates workload-balanced shift schedules with caps on night shifts. | **Google OR-Tools CP-SAT Solver** |
| **What-If Simulator** | Simulates counterfactual operational scenarios in real-time. | Unified Inference Engine |
| **Cognitive Load Checker** | Decision support for demanding task assignments. | Task Complexity vs Fatigue Matrix |
| **Human + AI Decision Room** | Officer Accept/Modify/Reject overrides with feedback audit. | `ai_feedback` Table & Audit Logger |
| **Intervention Outcome Tracker**| Tracks before/after wellness score & recovery debt changes. | `interventions` & `intervention_outcomes` Tables |
| **Discreet SOS** | Discreet emergency field alert with GPS coordinates. | `sos_events` & Priority Queue |
| **Offline Field Mode** | Caches field screenings offline and auto-syncs when online. | IndexedDB (`idb-keyval`) & Service Handler |

---

## System Architecture

```
+-----------------------------------------------------------------------------------+
|                            REACT 18 + TS + TAILWIND CSS                           |
|      (Landing Page | Personnel Dashboard | Officer Command Room | Admin Control)  |
+-----------------------------------------+-----------------------------------------+
                                          | REST API (JWT & Axios)
                                          v
+-----------------------------------------------------------------------------------+
|                                FASTAPI BACKEND API                                |
|   (Security, RBAC, Data Sync, Audit Logger, Dual SQLite/PostgreSQL Engine)       |
+------------------+----------------------+--------------------+--------------------+
                   |                      |                    |
                   v                      v                    v
      +------------------------+ +-------------------+ +-----------------------+
      |  SQLAlchemy Database   | | ML Inference      | | Google OR-Tools       |
      |  (Dual SQLite/Postgres)| | (XGBoost, SHAP)   | | Duty Optimizer        |
      +------------------------+ +-------------------+ +-----------------------+
```

---

## Machine Learning & Optimization Pipeline

- **Dataset**: 10,000 synthetic records generated with documented deterministic operational rules (`ml/data/generate_dataset.py`).
- **Test Accuracy**: **92.30%** on held-out test split.
- **ROC-AUC (OVR)**: **0.9913**
- **Model Files Saved**:
  - `ml/models/risk_model.joblib`
  - `ml/models/preprocessor.joblib`
  - `ml/models/calibration_model.joblib`
  - `ml/models/anomaly_model.joblib`
  - `ml/models/model_metrics.json`

---

## Database Schema (27 Tables)

1. `users`
2. `roles`
3. `personnel_profiles`
4. `units`
5. `screenings`
6. `screening_answers`
7. `wellness_scores`
8. `wellness_baselines`
9. `anomalies`
10. `recovery_metrics`
11. `duty_records`
12. `shift_records`
13. `tasks`
14. `task_complexity`
15. `recommendations`
16. `interventions`
17. `intervention_outcomes`
18. `appointments`
19. `reports`
20. `sos_events`
21. `notifications`
22. `privacy_consents`
23. `audit_logs`
24. `ai_predictions`
25. `ai_feedback`
26. `model_metrics`
27. `scenario_simulations`

---

## Installation & Setup Guide

### Prerequisites
- Python 3.10+
- Node.js v18+ & npm

### Backend Setup
```bash
# Clone/navigate to project directory
cd uniformed_welfare_system

# Create Python virtual environment
python -m venv venv

# Activate virtual environment (Windows)
.\venv\Scripts\activate

# Install Python dependencies
pip install -r requirements.txt

# Run ML dataset generation & model training
python -c "from ml.data.generate_dataset import generate_synthetic_dataset; generate_synthetic_dataset(); from ml.training.train_risk_model import train_wellness_risk_model; train_wellness_risk_model(); from ml.training.train_anomaly_model import train_anomaly_detection_model; train_anomaly_detection_model()"

# Seed Database with demo accounts & 14-day history
python -m backend.app.database.seed_data

# Start FastAPI server
uvicorn backend.app.main:app --reload --port 8000
```

### Frontend Setup
```bash
cd frontend
npm install
npm run dev
```
Open `http://localhost:5173` in your browser.

---

## Demo Credentials & Scenarios

| Role | Email | Password | Scenario Focus |
| :--- | :--- | :--- | :--- |
| **Personnel 1** | `personnel1@defense.gov.in` | `Password123!` | Stable pattern (Baseline normal) |
| **Personnel 2** | `personnel2@defense.gov.in` | `Password123!` | High workload strain |
| **Personnel 3** | `personnel3@defense.gov.in` | `Password123!` | Repeated night shifts (5 consecutive) |
| **Personnel 4** | `personnel4@defense.gov.in` | `Password123!` | Reduced sleep (3.8h) + high duty (15h) |
| **Personnel 5** | `personnel5@defense.gov.in` | `Password123!` | Improving after intervention |
| **Personnel 6** | `personnel6@defense.gov.in` | `Password123!` | Anomaly case (Severe deviation) |
| **Welfare Officer**| `welfare@defense.gov.in` | `Password123!` | Full Welfare Command Center |
| **Admin** | `admin@defense.gov.in` | `Password123!` | System metrics & AI Fairness Monitor |

---

## SIH Live 5-Minute Presentation Flow

1. **Login as Personnel (`personnel1@defense.gov.in`)**.
2. **Complete Adaptive Screening** -> Submit check-in.
3. **Generate ML Prediction & View Baseline**: Observe personal baseline deviation.
4. **View Recovery Debt**: Check transparent $0-100$ indicator breakdown.
5. **Click "Why did my risk change?"**: View SHAP feature contributions.
6. **Trigger Silent SOS**: Verify emergency alert dispatch & audit trail.
7. **Switch to Welfare Officer (`welfare@defense.gov.in`)**: View Unit Heatmap & Anomaly Feed.
8. **Run Duty Optimizer**: Execute Google OR-Tools CP-SAT schedule optimizer.
9. **Open What-If Simulator**: Modify night shifts & rest hours -> Observe live model updates.
10. **Plan Intervention & Record Outcome**: Reassess & view before/after improvement.
11. **Demonstrate Privacy Firewall**: Show role-based access & audit trail.
12. **Demonstrate Offline Field Mode**: Toggle browser offline -> Submit screening -> Reconnect and verify auto-sync.
