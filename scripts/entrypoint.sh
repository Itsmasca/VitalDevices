#!/bin/sh
set -e

echo "VitalSync Node-RED IoT Simulator Starting..."
echo "==============================================================="

# ─────────────────────────────────────────────────────────────────
# Display configuration
# ─────────────────────────────────────────────────────────────────
echo "Configuration:"
echo "   API URL: ${VITALSYNC_API_URL:-http://vitalsync-api:8000}"
echo "   Auth Enabled: ${VITALSYNC_AUTH_ENABLED:-true}"
echo "   Timeout: ${VITALSYNC_API_TIMEOUT:-30000}ms"
echo "   Retry Attempts: ${VITALSYNC_RETRY_ATTEMPTS:-5}"

# ─────────────────────────────────────────────────────────────────
# Wait for VitalSync API to be ready
# ─────────────────────────────────────────────────────────────────
API_HOST=$(echo "${VITALSYNC_API_URL:-http://vitalsync-api:8000}" | sed 's|https\?://||' | cut -d: -f1)
API_PORT=$(echo "${VITALSYNC_API_URL:-http://vitalsync-api:8000}" | sed 's|.*:||' | grep -o '^[0-9]*')
API_PORT=${API_PORT:-8000}

echo "Waiting for VitalSync API at ${API_HOST}:${API_PORT}..."

max_attempts=${VITALSYNC_RETRY_ATTEMPTS:-30}
attempt=1

while ! nc -z "$API_HOST" "$API_PORT" 2>/dev/null; do
    if [ $attempt -ge $max_attempts ]; then
        echo "WARNING: Could not connect to VitalSync API after $max_attempts attempts"
        echo "   Node-RED will start anyway - configure API URL manually if needed"
        break
    fi
    echo "   Attempt $attempt/$max_attempts - waiting..."
    sleep 2
    attempt=$((attempt + 1))
done

if nc -z "$API_HOST" "$API_PORT" 2>/dev/null; then
    echo "VitalSync API is ready!"

    # Test health endpoint
    HEALTH_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "${VITALSYNC_API_URL}/api/health" 2>/dev/null || echo "000")

    if [ "$HEALTH_RESPONSE" = "200" ]; then
        echo "API Health Check passed!"
    else
        echo "WARNING: API Health Check returned: $HEALTH_RESPONSE"
    fi
fi

# ─────────────────────────────────────────────────────────────────
# Copy default files to /data if not present (for volume mounts)
# ─────────────────────────────────────────────────────────────────
if [ ! -f /data/flows.json ]; then
    echo "Copying default flows.json to /data..."
    cp /usr/local/lib/vitalsync/flows.json /data/flows.json 2>/dev/null || true
fi

if [ ! -f /data/settings.js ]; then
    echo "Copying default settings.js to /data..."
    cp /usr/local/lib/vitalsync/settings.js /data/settings.js 2>/dev/null || true
fi

# ─────────────────────────────────────────────────────────────────
# Start Node-RED
# ─────────────────────────────────────────────────────────────────
echo "==============================================================="
echo "Starting Node-RED..."
echo "   Dashboard: http://localhost:1880/ui"
echo "   Editor: http://localhost:1880"
echo "==============================================================="

# Execute the default Node-RED entrypoint
exec npm start -- --userDir /data
