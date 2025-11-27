# VitalSync Node-RED IoT Simulator

## 📋 Descripción

Este flujo de Node-RED simula dispositivos IoT wearable enviando datos de signos vitales a la API REST de VitalSync.

---

## ✅ Requisitos del Proyecto Cumplidos

| Requisito | Estado | Descripción |
|-----------|--------|-------------|
| Start/Stop switch | ✅ | Habilita/deshabilita la emisión de datos |
| Frequency slider | ✅ | Ajusta intervalo de 500ms a 3000ms |
| Anomaly toggle | ✅ | Inyecta valores fuera de rango (30% prob.) |
| 2+ Gauges | ✅ | Heart Rate + Oxygen Level |
| 1 Live chart | ✅ | Body Temperature (rolling 2 min) |
| Health indicator | ✅ | Estado de conexión con API |

---

## 🚀 Instalación

### Opción A: Docker Compose (Recomendado)

El flujo se carga automáticamente. En tu `docker-compose.yml`:

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

Luego:
```bash
docker-compose up -d nodered
```

### Opción B: Importar Manualmente

1. Abrir Node-RED: http://localhost:1880
2. **Menú (☰)** → **Import** → **Clipboard**
3. Pegar el contenido de `vitalsync_nodered_flow.json`
4. Click **"Import"**
5. Click **"Deploy"** (botón rojo arriba a la derecha)

### Opción C: Node-RED ya está corriendo

Si Node-RED ya está corriendo en una imagen:

```bash
# Copiar el flujo al contenedor
docker cp ./flows/vitalsync_nodered_flow.json vitalsync-nodered:/data/flows.json

# Reiniciar Node-RED para cargar el flujo
docker restart vitalsync-nodered
```

---

## 🌐 URLs

| Servicio | URL |
|----------|-----|
| **Node-RED Editor** | http://localhost:1880 |
| **Dashboard UI** | http://localhost:1880/ui |

---

## ⚙️ Configurar URL del API

El flujo necesita conectarse a la API. Por defecto usa `http://vitalsync-api:8000` (para Docker).

### Cambiar la URL:

1. En el **Dashboard** (http://localhost:1880/ui)
2. En el panel **Control Panel**
3. Campo **"API URL"** → Ingresar la URL correcta
4. Ejemplos:
   - Docker: `http://vitalsync-api:8000`
   - Local: `http://localhost:8000`
   - AWS: `https://api.vitalsync.example.com`

---

## 📊 Widgets del Dashboard

### ⚙️ Control Panel
| Widget | Función |
|--------|---------|
| **Data Emission** | ON/OFF para enviar datos |
| **Interval** | 500-3000ms entre envíos |
| **Anomaly Mode** | Inyectar valores críticos |
| **View** | Filtrar por familiar |
| **Reset Steps** | Reiniciar contadores |
| **API URL** | Cambiar URL del API |

### ❤️ Vital Signs
- **Heart Rate Gauge** (40-150 bpm)
- **SpO2 Gauge** (80-100%)

### 📊 Charts
- **Temperature Chart** - Rolling 2 minutos

### 📡 System Status
- **Steps** - Contador de pasos
- **Status** - Estado de emisión
- **API** - Conexión con API

### 🚨 Alerts
- **Alert Log** - Historial de alertas
- **Toast** - Notificaciones popup

---

## 👨‍👩‍👧 Dispositivos Simulados

| Familiar | Device ID | Tipo |
|----------|-----------|------|
| Roberto (Papá) | XIAOMI-PAPA-001 | Xiaomi Mi Band |
| Elena (Mamá) | APPLE-MAMA-002 | Apple Watch |
| José (Abuelo) | FITBIT-ABUELO-003 | Fitbit |
| Test | SIM-NODERED-004 | Simulator |

---

## 📡 Payload JSON

```json
{
  "deviceId": "XIAOMI-PAPA-001",
  "memberId": "familia-garcia-papa",
  "memberName": "Roberto García",
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

## 🚨 Umbrales de Alertas

| Métrica | 🔴 Critical | ⚠️ Warning | 🟢 Normal |
|---------|------------|------------|-----------|
| Heart Rate | <50 / >120 | 50-60 / 100-120 | 60-100 bpm |
| SpO2 | <90% | 90-95% | >95% |
| Temperature | <35° / >38° | 35-36.1° / 37.2-38° | 36.1-37.2°C |

---

## 🧪 Test del Flujo

1. ✅ Activar **"Data Emission"** → Ver datos en debug
2. ✅ Mover slider → Cambia frecuencia de envío
3. ✅ Activar **"Anomaly Mode"** → Ver alertas críticas
4. ✅ Gauges actualizan en tiempo real
5. ✅ Chart muestra últimos 2 minutos
6. ✅ API status muestra ✅ OK o ❌ Error

---

## 🐛 Troubleshooting

**Dashboard no aparece:**
```bash
# Instalar node-red-dashboard
docker exec vitalsync-nodered npm install node-red-dashboard
docker restart vitalsync-nodered
```

**API no responde:**
```bash
# Verificar API
curl http://localhost:8000/api/health

# Verificar red Docker
docker network ls
docker network inspect vitalsync-network
```

**Flujo no carga:**
```bash
# Ver logs
docker logs vitalsync-nodered

# Reimportar flujo
docker cp flows.json vitalsync-nodered:/data/flows.json
docker restart vitalsync-nodered
```

---

*VitalSync Node-RED - SIS4415 Final Project*
