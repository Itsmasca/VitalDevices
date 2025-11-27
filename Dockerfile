# ═══════════════════════════════════════════════════════════════
# VitalSync Node-RED Dockerfile
# ═══════════════════════════════════════════════════════════════
# IoT Simulator for Health Monitoring Platform
# ═══════════════════════════════════════════════════════════════

FROM nodered/node-red:latest

# ─────────────────────────────────────────────────────────────────
# Install required Node-RED palettes
# ─────────────────────────────────────────────────────────────────
RUN npm install --save \
    node-red-dashboard \
    && npm cache clean --force

# ─────────────────────────────────────────────────────────────────
# Copy flow and settings
# ─────────────────────────────────────────────────────────────────
COPY flows/vitalsync_nodered_flow.json /data/flows.json
COPY settings.js /data/settings.js

# ─────────────────────────────────────────────────────────────────
# Environment variables
# ─────────────────────────────────────────────────────────────────
ENV NODE_RED_ENABLE_PROJECTS=false
ENV TZ=America/Mexico_City

# ─────────────────────────────────────────────────────────────────
# Healthcheck
# ─────────────────────────────────────────────────────────────────
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:1880/ || exit 1

# ─────────────────────────────────────────────────────────────────
# Expose port
# ─────────────────────────────────────────────────────────────────
EXPOSE 1880

# ─────────────────────────────────────────────────────────────────
# Volume for persistent data
# ─────────────────────────────────────────────────────────────────
VOLUME ["/data"]

# ─────────────────────────────────────────────────────────────────
# Labels
# ─────────────────────────────────────────────────────────────────
LABEL maintainer="VitalSync Team"
LABEL description="VitalSync IoT Simulator - Node-RED"
LABEL version="1.0.0"
