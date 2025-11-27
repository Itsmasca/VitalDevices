/**
 * VitalSync Node-RED Settings
 * 
 * This file configures Node-RED for the VitalSync IoT simulator.
 * Copy this to your Node-RED user directory (usually ~/.node-red/)
 */

module.exports = {
    // Flow file name
    flowFile: 'flows.json',
    
    // Flow file pretty printing
    flowFilePretty: true,
    
    // User directory
    userDir: '/data',
    
    // Node-RED admin interface
    uiPort: process.env.PORT || 1880,
    uiHost: "0.0.0.0",
    
    // Admin authentication (optional - uncomment to enable)
    // adminAuth: {
    //     type: "credentials",
    //     users: [{
    //         username: "admin",
    //         password: "$2b$08$wuAqPiKJlVN27eF5qJp.Hu", // "vitalsync"
    //         permissions: "*"
    //     }]
    // },
    
    // Disable editor in production (uncomment if needed)
    // disableEditor: true,
    
    // HTTP admin root
    httpAdminRoot: '/',
    
    // HTTP node root
    httpNodeRoot: '/',
    
    // HTTP static files
    httpStatic: '/data/public',
    
    // Function global context
    functionGlobalContext: {
        // Make environment variables available in function nodes
        env: process.env,
        // OS module for system info
        os: require('os')
    },
    
    // External modules that can be loaded in function nodes
    functionExternalModules: true,
    
    // Context storage
    contextStorage: {
        default: {
            module: "localfilesystem"
        }
    },
    
    // Export global context to function nodes
    exportGlobalContextKeys: true,
    
    // Logging
    logging: {
        console: {
            level: "info",
            metrics: false,
            audit: false
        }
    },
    
    // Editor theme
    editorTheme: {
        page: {
            title: "VitalSync IoT Simulator"
        },
        header: {
            title: "VitalSync Node-RED",
            image: null,
            url: null
        },
        palette: {
            editable: true
        },
        projects: {
            enabled: false
        },
        menu: {
            "menu-item-help": {
                label: "VitalSync Docs",
                url: "https://github.com/YOUR_USER/vitalsync"
            }
        }
    },
    
    // Dashboard configuration
    ui: {
        path: "ui",
        middleware: null
    }
};
