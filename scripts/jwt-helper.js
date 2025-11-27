/**
 * VitalSync JWT Helper Functions
 * Para usar en nodos Function de Node-RED
 *
 * Uso en Function node:
 *   const jwt = global.get('jwtHelper');
 *   const token = await jwt.getToken(global);
 */

const jwtHelper = {
    // Token storage keys
    TOKEN_KEY: 'vitalsync_jwt_token',
    REFRESH_KEY: 'vitalsync_refresh_token',
    EXPIRY_KEY: 'vitalsync_token_expiry',

    /**
     * Check if current token is valid and not expired
     */
    isTokenValid: function(globalContext) {
        const token = globalContext.get(this.TOKEN_KEY);
        const expiry = globalContext.get(this.EXPIRY_KEY);

        if (!token || !expiry) return false;

        // Check if token expires in less than 5 minutes
        const now = Date.now();
        const expiryTime = new Date(expiry).getTime();
        const bufferTime = 5 * 60 * 1000; // 5 minutes buffer

        return now < (expiryTime - bufferTime);
    },

    /**
     * Store token data in global context
     */
    storeToken: function(globalContext, tokenData) {
        globalContext.set(this.TOKEN_KEY, tokenData.token);
        if (tokenData.refresh_token) {
            globalContext.set(this.REFRESH_KEY, tokenData.refresh_token);
        }

        // Calculate expiry (default 24 hours if not provided)
        const expiryHours = tokenData.expires_in || 24;
        const expiry = new Date(Date.now() + (expiryHours * 60 * 60 * 1000));
        globalContext.set(this.EXPIRY_KEY, expiry.toISOString());
    },

    /**
     * Get current token or null if invalid/expired
     */
    getToken: function(globalContext) {
        if (this.isTokenValid(globalContext)) {
            return globalContext.get(this.TOKEN_KEY);
        }
        return null;
    },

    /**
     * Clear all token data
     */
    clearToken: function(globalContext) {
        globalContext.set(this.TOKEN_KEY, null);
        globalContext.set(this.REFRESH_KEY, null);
        globalContext.set(this.EXPIRY_KEY, null);
    },

    /**
     * Get refresh token if available
     */
    getRefreshToken: function(globalContext) {
        return globalContext.get(this.REFRESH_KEY);
    }
};

module.exports = jwtHelper;
