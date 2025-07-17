#!/usr/bin/with-contenv bashio

# ==============================================================================
# Home Assistant Add-on: Globalping Network Diagnostics
# Runs the Globalping service and exposes it to Home Assistant
# ==============================================================================

declare api_token
declare adoption_token
declare default_location
declare web_interface
declare log_level

# Read configuration
api_token=$(bashio::config 'api_token')
adoption_token=$(bashio::config 'adoption_token')
default_location=$(bashio::config 'default_location')
web_interface=$(bashio::config 'web_interface')
log_level=$(bashio::config 'log_level')

# Set log level
bashio::log.level "${log_level}"

bashio::log.info "Starting Globalping Network Diagnostics Add-on..."

# Create configuration directory
mkdir -p /data/globalping

# Set API token if provided
if [ -n "${api_token}" ]; then
    bashio::log.info "Setting up Globalping API token..."
    export GLOBALPING_API_TOKEN="${api_token}"
fi

# Set adoption token if provided (for probe registration)
if [ -n "${adoption_token}" ]; then
    bashio::log.info "Setting up Globalping adoption token for probe registration..."
    export GP_ADOPTION_TOKEN="${adoption_token}"
fi

# Set default location
export GLOBALPING_DEFAULT_LOCATION="${default_location}"

bashio::log.info "Default location set to: ${default_location}"

# Start the web interface if enabled
if bashio::var.true "${web_interface}"; then
    bashio::log.info "Starting Globalping web interface on port 8080..."
    
    # Create a simple web interface using Python Flask
    cat > /tmp/globalping_web.py << 'EOF'
from flask import Flask, render_template_string, request, jsonify
import subprocess
import json
import os

app = Flask(__name__)

HTML_TEMPLATE = '''
<!DOCTYPE html>
<html>
<head>
    <title>Globalping Network Diagnostics</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #333; text-align: center; margin-bottom: 30px; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; color: #555; }
        input, select, textarea { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; }
        button { background: #007bff; color: white; padding: 12px 24px; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
        button:hover { background: #0056b3; }
        .results { margin-top: 30px; padding: 20px; background: #f8f9fa; border-radius: 4px; border-left: 4px solid #007bff; }
        .loading { text-align: center; color: #666; font-style: italic; }
        pre { background: #f1f1f1; padding: 15px; border-radius: 4px; overflow-x: auto; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🌐 Globalping Network Diagnostics</h1>
        
        <form id="testForm">
            <div class="form-group">
                <label for="command">Test Type:</label>
                <select id="command" name="command" required>
                    <option value="ping">Ping</option>
                    <option value="traceroute">Traceroute</option>
                    <option value="dns">DNS Lookup</option>
                    <option value="http">HTTP Test</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="target">Target (hostname/IP):</label>
                <input type="text" id="target" name="target" placeholder="example.com" required>
            </div>
            
            <div class="form-group">
                <label for="location">Location:</label>
                <input type="text" id="location" name="location" placeholder="world, europe, US, etc." value="{{ default_location }}">
            </div>
            
            <div class="form-group">
                <button type="submit">Run Test</button>
            </div>
        </form>
        
        <div id="results" class="results" style="display: none;">
            <h3>Results:</h3>
            <div id="output"></div>
        </div>
    </div>

    <script>
        document.getElementById('testForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const formData = new FormData(e.target);
            const data = Object.fromEntries(formData);
            
            const resultsDiv = document.getElementById('results');
            const outputDiv = document.getElementById('output');
            
            resultsDiv.style.display = 'block';
            outputDiv.innerHTML = '<div class="loading">Running test...</div>';
            
            try {
                const response = await fetch('/api/test', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(data)
                });
                
                const result = await response.json();
                
                if (result.success) {
                    outputDiv.innerHTML = '<pre>' + result.output + '</pre>';
                } else {
                    outputDiv.innerHTML = '<div style="color: red;">Error: ' + result.error + '</div>';
                }
            } catch (error) {
                outputDiv.innerHTML = '<div style="color: red;">Error: ' + error.message + '</div>';
            }
        });
    </script>
</body>
</html>
'''

@app.route('/')
def index():
    default_location = os.environ.get('GLOBALPING_DEFAULT_LOCATION', 'world')
    return render_template_string(HTML_TEMPLATE, default_location=default_location)

@app.route('/api/test', methods=['POST'])
def run_test():
    try:
        data = request.json
        command = data.get('command')
        target = data.get('target')
        location = data.get('location', 'world')
        
        # Build globalping command
        cmd = ['globalping', command, target, 'from', location]
        
        # Add API token if available
        if os.environ.get('GLOBALPING_API_TOKEN'):
            cmd.extend(['--api-token', os.environ.get('GLOBALPING_API_TOKEN')])
        
        # Run the command
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=60)
        
        if result.returncode == 0:
            return jsonify({'success': True, 'output': result.stdout})
        else:
            return jsonify({'success': False, 'error': result.stderr or 'Command failed'})
            
    except subprocess.TimeoutExpired:
        return jsonify({'success': False, 'error': 'Test timed out'})
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=False)
EOF

    # Start the web interface in the background
    python3 /tmp/globalping_web.py &
    WEB_PID=$!
    bashio::log.info "Web interface started with PID: ${WEB_PID}"
fi

# Create Home Assistant service discovery
bashio::log.info "Setting up Home Assistant services..."

# Create service definitions for Home Assistant
cat > /tmp/services.yaml << 'EOF'
globalping_ping:
  name: Globalping Ping
  description: Run ping test from global probes
  fields:
    target:
      description: Target hostname or IP address
      example: "google.com"
      required: true
      selector:
        text:
    location:
      description: Location to run test from
      example: "europe"
      default: "world"
      selector:
        text:
    count:
      description: Number of ping packets
      example: 4
      default: 4
      selector:
        number:
          min: 1
          max: 10

globalping_traceroute:
  name: Globalping Traceroute
  description: Run traceroute from global probes
  fields:
    target:
      description: Target hostname or IP address
      example: "cloudflare.com"
      required: true
      selector:
        text:
    location:
      description: Location to run test from
      example: "us-east"
      default: "world"
      selector:
        text:

globalping_dns_lookup:
  name: Globalping DNS Lookup
  description: Perform DNS lookup from global probes
  fields:
    target:
      description: Domain name to lookup
      example: "example.com"
      required: true
      selector:
        text:
    location:
      description: Location to run test from
      example: "asia"
      default: "world"
      selector:
        text:
    record_type:
      description: DNS record type
      example: "A"
      default: "A"
      selector:
        select:
          options:
            - "A"
            - "AAAA"
            - "CNAME"
            - "MX"
            - "NS"
            - "TXT"

globalping_http_test:
  name: Globalping HTTP Test
  description: Run HTTP test from global probes
  fields:
    target:
      description: URL to test
      example: "https://example.com"
      required: true
      selector:
        text:
    location:
      description: Location to run test from
      example: "north-america"
      default: "world"
      selector:
        text:
EOF

# Copy services to the correct location if it exists
if [ -d "/config" ]; then
    mkdir -p /config/services
    cp /tmp/services.yaml /config/services/globalping.yaml 2>/dev/null || true
fi

bashio::log.info "Globalping Add-on is now running!"
bashio::log.info "Web interface available at: http://homeassistant.local:8080"

# Keep the container running
while true; do
    sleep 30
    
    # Check if web interface is still running
    if bashio::var.true "${web_interface}" && ! kill -0 $WEB_PID 2>/dev/null; then
        bashio::log.warning "Web interface stopped, restarting..."
        python3 /tmp/globalping_web.py &
        WEB_PID=$!
    fi
done