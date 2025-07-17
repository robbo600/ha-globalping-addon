# Home Assistant Globalping Add-on Repository

This repository provides a Home Assistant add-on for Globalping, allowing you to run network diagnostics (ping, traceroute, DNS lookups) from a globally distributed network of probes directly from your Home Assistant instance.

## 🌐 What is Globalping?

Globalping is a platform that allows anyone to run networking commands such as ping, traceroute, dig, curl and mtr on probes distributed all around the world. Our goal is to provide a free and simple service for everyone out there to make the internet faster.

## 🚀 Installation

### Step 1: Add this Repository to Home Assistant

1. In Home Assistant, go to **Settings** > **Add-ons** > **Add-on Store**
2. Click the three dots (⋮) in the top right corner
3. Select **Repositories**
4. Add this repository URL: `https://github.com/robbo600/ha-globalping-addon`
5. Click **Add**

[![Open your Home Assistant instance and show the add-on store.](https://my.home-assistant.io/badges/supervisor_store.svg)](https://my.home-assistant.io/redirect/supervisor_store/)

### Step 2: Install the Globalping Add-on

1. Find the "Globalping Network Diagnostics" add-on in the store
2. Click **Install**
3. Wait for the installation to complete
4. Click **Start**

## 🔧 Configuration

The add-on supports the following configuration options:

```yaml
api_token: ""              # Optional: Globalping API token for increased limits
adoption_token: ""         # Optional: GP_ADOPTION_TOKEN for probe registration
default_location: "world"  # Default location for tests
web_interface: true        # Enable web interface on port 8080
log_level: "info"         # Log level (debug, info, warn, error)
```

## 📡 Usage

### Web Interface

Access the Globalping web interface at `http://homeassistant.local:8080` (or your Home Assistant IP with port 8080).

### Home Assistant Services

The add-on exposes several services for use in automations:

#### `globalping.ping`
Run ping tests from specified locations.

```yaml
service: globalping.ping
data:
  target: "google.com"
  location: "germany"
  count: 4
```

#### `globalping.traceroute`
Perform traceroute from specified locations.

```yaml
service: globalping.traceroute
data:
  target: "cloudflare.com"
  location: "us-east"
```

#### `globalping.dns_lookup`
DNS resolution from different locations.

```yaml
service: globalping.dns_lookup
data:
  target: "example.com"
  location: "asia"
  record_type: "A"
```

### Automation Example

Monitor your website's availability from multiple locations:

```yaml
automation:
  - alias: "Check Website Global Availability"
    trigger:
      - platform: time_pattern
        minutes: "/15"  # Every 15 minutes
    action:
      - service: globalping.ping
        data:
          target: "mywebsite.com"
          location: "europe,asia,north-america"
        response_variable: ping_results
      - condition: template
        value_template: "{{ ping_results.failed > 0 }}"
      - service: notify.mobile_app
        data:
          message: "Website connectivity issues detected from {{ ping_results.failed_locations }}"
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Credits

- Globalping by the jsDelivr team
- Home Assistant Community

---

**Note**: This add-on requires an internet connection and uses the free Globalping service. Register on the Globalping Dashboard to increase your limits and adopt probes to earn free credits!
