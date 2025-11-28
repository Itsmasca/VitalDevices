# VitalSync Node-RED IoT Simulator

## Overview

This Node-RED flow simulates IoT wearable devices transmitting vital signs data to the VitalSync REST API.

**Important Notice:** This flow and its associated dashboard are designed exclusively for data ingestion simulation and ingestion metrics monitoring. The dashboard displays operational metrics related to the data transmission process, connection status, and system health indicators. It does not display or process sensitive patient health data. For visualization and analysis of actual patient vital signs and health records, a separate dedicated dashboard with appropriate security controls must be used.

---

## Project Requirements

| Requirement | Status | Description |
|-------------|--------|-------------|
| Start/Stop switch | Complete | Enables/disables data emission |
| Frequency slider | Complete | Adjusts interval from 500ms to 3000ms |
| Anomaly toggle | Complete | Injects out-of-range values (30% probability) |
| 2+ Gauges | Complete | Heart Rate + Oxygen Level |
| 1 Live chart | Complete | Body Temperature (rolling 2 min) |
| Health indicator | Complete | API connection status |

---

## Installation

### Option A: Docker Compose (Recommended)

The flow loads automatically. In your `docker-compose.yml`:

```yaml
nodered:
  image: nodered/node-red:latest
  container_name: vitalsync-nodered
  environment:
    TZ: America/Mexico_City
  volumes:
    - nodered_data:/data
    - ./Node-Red/flows/vitalsync_nodered_flow.json:/data/flows.json:ro
    - ./Node-Red/settings.js:/data/settings.js:ro
  ports:
    - "1880:1880"
  networks:
    - vitalsync-network
```

Then execute:
```bash
docker-compose up -d nodered
```

### Option B: Manual Import

1. Open Node-RED: http://localhost:1880
2. Navigate to Menu > Import > Clipboard
3. Paste the contents of `vitalsync_nodered_flow.json`
4. Click "Import"
5. Click "Deploy" (red button in the upper right corner)

### Option C: Node-RED Already Running

If Node-RED is already running in a container:

```bash
# Copy the flow to the container
docker cp ./flows/vitalsync_nodered_flow.json vitalsync-nodered:/data/flows.json

# Restart Node-RED to load the flow
docker restart vitalsync-nodered
```

---

## Service URLs

| Service | URL |
|---------|-----|
| Node-RED Editor | http://localhost:1880 |
| Dashboard UI | http://localhost:1880/ui |

---

## API URL Configuration

The flow requires connection to the API. The default URL is `http://vitalsync-api:8000` (for Docker environments).

### To Change the URL:

1. Access the Dashboard at http://localhost:1880/ui
2. Locate the Control Panel section
3. Enter the correct URL in the "API URL" field
4. Examples:
   - Docker: `http://vitalsync-api:8000`
   - Local: `http://localhost:8000`
   - AWS: `https://api.vitalsync.example.com`

---

## Dashboard Widgets

### Control Panel
| Widget | Function |
|--------|----------|
| Data Emission | ON/OFF toggle for data transmission |
| Interval | 500-3000ms between transmissions |
| Anomaly Mode | Inject critical values for testing |
| View | Filter by family member |
| Reset Steps | Reset step counters |
| API URL | Modify API endpoint |

### Vital Signs (Ingestion Preview)
- Heart Rate Gauge (40-150 bpm)
- SpO2 Gauge (80-100%)

Note: These gauges display simulated data being sent to the API for ingestion testing purposes only. They do not represent actual patient data.

### Charts
- Temperature Chart - Rolling 2-minute window

### System Status
- Steps - Step counter
- Status - Emission state
- API - API connection status

### Alerts
- Alert Log - Alert history
- Toast - Popup notifications

---

## Simulated Devices

| Family Member | Device ID | Type |
|---------------|-----------|------|
| Roberto (Father) | XIAOMI-PAPA-001 | Xiaomi Mi Band |
| Elena (Mother) | APPLE-MAMA-002 | Apple Watch |
| Jose (Grandfather) | FITBIT-ABUELO-003 | Fitbit |
| Test | SIM-NODERED-004 | Simulator |

---

## JSON Payload Structure

```json
{
  "deviceId": "XIAOMI-PAPA-001",
  "memberId": "familia-garcia-papa",
  "memberName": "Roberto Garcia",
  "relationship": "padre",
  "deviceType": "xiaomi_mi_band",
  "heartRate": 72,
  "oxygenLevel": 96.5,
  "bodyTemperature": 36.5,
  "steps": 3200,
  "timestamp": "2025-11-27T10:30:00.000Z",
  "isAnomaly": false
}
```

---

## Alert Thresholds

| Metric | Critical | Warning | Normal |
|--------|----------|---------|--------|
| Heart Rate | <50 / >120 | 50-60 / 100-120 | 60-100 bpm |
| SpO2 | <90% | 90-95% | >95% |
| Temperature | <35C / >38C | 35-36.1C / 37.2-38C | 36.1-37.2C |

---

## Flow Testing

1. Activate "Data Emission" - Verify data appears in debug
2. Adjust slider - Confirm transmission frequency changes
3. Enable "Anomaly Mode" - Verify critical alerts are generated
4. Confirm gauges update in real time
5. Verify chart displays the last 2 minutes of data
6. Confirm API status shows OK or Error appropriately

---

## Troubleshooting

**Dashboard not appearing:**
```bash
# Install node-red-dashboard
docker exec vitalsync-nodered npm install node-red-dashboard
docker restart vitalsync-nodered
```

**API not responding:**
```bash
# Verify API health
curl http://localhost:8000/api/health

# Verify Docker network
docker network ls
docker network inspect vitalsync-network
```

**Flow not loading:**
```bash
# View logs
docker logs vitalsync-nodered

# Re-import flow
docker cp flows.json vitalsync-nodered:/data/flows.json
docker restart vitalsync-nodered
```

---

VitalSync Node-RED - SIS4415 Final Project
