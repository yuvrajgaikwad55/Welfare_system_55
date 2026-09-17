@echo off
TITLE AI-Powered Welfare Monitoring & Preventive Support System - One-Click Launcher
COLOR 0A
cls

echo =====================================================================
echo  AI-POWERED WELFARE MONITORING & PREVENTIVE SUPPORT SYSTEM
echo  Detect Early. Understand the Cause. Prevent Escalation. Measure Recovery.
echo =====================================================================
echo.

:: 1. Check Python installation
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python is not installed or not in PATH! Please install Python 3.10+
    pause
    exit /b 1
)

:: 2. Check Node.js installation
node -v >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js is not installed or not in PATH! Please install Node.js 18+
    pause
    exit /b 1
)

:: 3. Setup Python Virtual Environment
if not exist "venv\Scripts\activate.bat" (
    echo [INFO] Creating Python virtual environment...
    python -m venv venv
)

echo [INFO] Activating virtual environment...
call venv\Scripts\activate.bat

:: 4. Install Backend Dependencies
echo [INFO] Verifying backend Python dependencies...
pip install -r requirements.txt --quiet

:: 5. Install Frontend Dependencies
if not exist "frontend\node_modules" (
    echo [INFO] Installing frontend npm dependencies...
    cd frontend
    call npm install
    cd ..
)

:: 6. Train Models if missing
if not exist "models\risk_model.joblib" (
    echo [INFO] Generating 10,000 synthetic dataset and training ML models...
    python -c "from ml.data.generate_dataset import generate_synthetic_dataset; generate_synthetic_dataset(); from ml.training.train_risk_model import train_wellness_risk_model; train_wellness_risk_model(); from ml.training.train_anomaly_model import train_anomaly_detection_model; train_anomaly_detection_model()"
)

:: 7. Seed Database
echo [INFO] Initializing and seeding demo database...
python -m backend.app.database.seed_data

echo.
echo =====================================================================
echo  STARTING SERVICES...
echo  - Backend API:  http://localhost:8000 (OpenAPI Docs: http://localhost:8000/docs)
echo  - Frontend UI:   http://localhost:5173
echo =====================================================================
echo.

:: 8. Launch Backend Server in new window
start "Welfare System Backend API (FastAPI)" cmd /k "venv\Scripts\activate.bat && python -m uvicorn backend.app.main:app --host 0.0.0.0 --port 8000 --reload"

:: 9. Launch Frontend Dev Server in new window
start "Welfare System Frontend (React Vite)" cmd /k "cd frontend && npm run dev -- --host 0.0.0.0 --port 5173"

echo [SUCCESS] Both backend and frontend services launched successfully!
echo Opening browser...
timeout /t 3 >nul
start http://localhost:5173
