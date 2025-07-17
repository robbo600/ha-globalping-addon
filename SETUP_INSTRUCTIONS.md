# Setup Instructions for ha-globalping-addon

## Files Created
All files have been saved to: `C:\Users\rob\Downloads\ha-globalping-addon\`

## Directory Structure Created:
```
ha-globalping-addon/
├── README.md                    # Main repository documentation
├── repository.yaml              # Home Assistant repository config
├── LICENSE                      # MIT License file
├── SETUP_INSTRUCTIONS.md        # This file
└── globalping/                  # Add-on directory
    ├── config.yaml              # Add-on configuration
    ├── Dockerfile               # Container build instructions
    ├── README.md                # Add-on documentation
    ├── CHANGELOG.md             # Version history
    └── rootfs/                  # Root filesystem
        └── usr/
            └── bin/
                └── run.sh       # Startup script
```

## Next Steps

### 1. ✅ GitHub Username Updated

Your GitHub username `robbo600` has been automatically updated in all files. The repository is ready to upload!

### 2. Upload to GitHub

**Option A: Using GitHub Web Interface (Recommended)**
1. Go to https://github.com and sign in
2. Click the "+" icon in the top right corner
3. Select "New repository"
4. Name it: `ha-globalping-addon`
5. Add description: "Home Assistant add-on for Globalping network diagnostics"
6. Make it **Public** (required for Home Assistant add-ons)
7. Check "Add a README file"
8. Click "Create repository"
9. Delete the auto-generated README.md
10. Upload all files from `C:\Users\rob\Downloads\ha-globalping-addon\` maintaining the directory structure

**Option B: Using Git Command Line**
1. Install Git if not already installed
2. Open Command Prompt or PowerShell
3. Navigate to the folder: `cd C:\Users\rob\Downloads\ha-globalping-addon`
4. Initialize git: `git init`
5. Add remote: `git remote add origin https://github.com/robbo600/ha-globalping-addon.git`
6. Add files: `git add .`
7. Commit: `git commit -m "Initial commit - Globalping Home Assistant Add-on"`
8. Push: `git push -u origin main`

### 3. Add to Home Assistant

Once uploaded to GitHub:

1. In Home Assistant, go to **Settings** > **Add-ons** > **Add-on Store**
2. Click the three dots (⋮) in the top right corner
3. Select **Repositories**
4. Add your repository URL: `https://github.com/robbo600/ha-globalping-addon`
5. Click **Add**
6. Find "Globalping Network Diagnostics" in the store
7. Click **Install**
8. Configure and start the add-on

### 4. Configuration Options

After installation, configure the add-on with:

```yaml
api_token: ""              # Optional: Get from https://globalping.io/
adoption_token: ""         # Optional: GP_ADOPTION_TOKEN for probe registration
default_location: "world"   # Default probe location
web_interface: true         # Enable web interface on port 8080
log_level: "info"          # Logging level
```

### 5. Usage

**Web Interface:**
- Access at: `http://homeassistant.local:8080`
- Run manual network tests with an easy-to-use interface
- Test types: ping, traceroute, DNS lookup, HTTP tests

**Home Assistant Services (Future):**
- Service integration planned for future update
- Will include `globalping.ping`, `globalping.traceroute`, etc.
- Currently use web interface for testing

**Example Automation:**
```yaml
automation:
  - alias: "Website Health Check"
    trigger:
      - platform: time_pattern
        minutes: "/30"
    action:
      - service: globalping.ping
        data:
          target: "mywebsite.com"
          location: "europe,asia,north-america"
```

### 6. Troubleshooting

**Common Issues:**
- Repository not appearing: Ensure it's public and has correct structure
- Add-on won't start: Check logs in Home Assistant
- Web interface not accessible: Verify port 8080 is not blocked
- Services not working: Ensure Globalping API is accessible

**Getting Help:**
- Check add-on logs in Home Assistant
- Visit https://globalping.io/ for API documentation
- Open issues on your GitHub repository

### 7. Optional Enhancements

**Get Globalping API Token:**
1. Visit https://globalping.io/
2. Register for a free account
3. Generate an API token in your dashboard
4. Add it to the add-on configuration for higher rate limits

**Register as a Probe (Optional):**
1. Visit https://globalping.io/
2. Generate an adoption token in your dashboard
3. Add it to the add-on configuration as `adoption_token`
4. Your Home Assistant instance will become a registered Globalping probe
5. This helps contribute to the global network while giving you credits

**Customize Locations:**
Supported location formats:
- Countries: `germany`, `france`, `us`
- Continents: `europe`, `asia`, `north-america`
- Regions: `us-east`, `us-west`
- ISPs: `google`, `amazon`, `cloudflare`
- Cities: `london`, `tokyo`, `new-york`

## Support

If you encounter any issues:
1. Check the setup steps above
2. Verify all placeholder text has been replaced
3. Ensure the repository is public on GitHub
4. Check Home Assistant logs for error messages

Enjoy your new Globalping Home Assistant add-on! 🌐