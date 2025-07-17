# Home Assistant Add-on: Globalping Network Diagnostics

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]
![Supports armhf Architecture][armhf-shield]
![Supports armv7 Architecture][armv7-shield]
![Supports i386 Architecture][i386-shield]

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg

## About

This add-on integrates Globalping with Home Assistant, allowing you to run network diagnostics from a globally distributed network of probes. Monitor your services' availability and performance from different locations around the world.

## Features

- 🌐 **Global Network Testing**: Run tests from hundreds of probes worldwide
- 🔧 **Multiple Test Types**: Ping, traceroute, DNS lookups, and HTTP tests
- 🖥️ **Web Interface**: Easy-to-use web interface for manual testing
- 🤖 **Home Assistant Services**: Integrate tests into automations
- 📊 **Real-time Results**: Get instant feedback on network performance
- 🆓 **Free to Use**: Uses Globalping's free tier with generous limits

## Installation

1. Add this repository to your Home Assistant Add-on Store
2. Install the "Globalping Network Diagnostics" add-on
3. Configure the add-on (see configuration section below)
4. Start the add-on

## Configuration

### Add-on Configuration

```yaml
api_token: ""              # Optional: Your Globalping API token for increased limits
adoption_token: ""         # Optional: GP_ADOPTION_TOKEN for probe registration
default_location: "world"  # Default location for tests (world, europe, asia, etc.)
web_interface: true        # Enable the web interface on port 8080
log_level: "info"         # Log level (debug, info, warn, error)
```

### Configuration Options

#### Option: `api_token`

Your Globalping API token. This is optional but recommended for higher rate limits and additional features.

- Register at https://globalping.io/
- Generate an API token in your dashboard
- Paste it here

#### Option: `adoption_token`

Your Globalping adoption token for registering this instance as a probe. This is optional but allows your Home Assistant instance to contribute to the global Globalping network.

- Register at https://globalping.io/
- Generate an adoption token in your dashboard
- Paste it here to register as a probe

#### Option: `default_location`

The default location to use for tests when not specified.

Examples:
- `world` - Use probes from around the world
- `europe` - Use probes from Europe
- `us-east` - Use probes from US East Coast
- `germany` - Use probes from Germany
- `google` - Use probes hosted on Google Cloud

#### Option: `web_interface`

Enable or disable the web interface accessible on port 8080.

#### Option: `log_level`

Set the logging level for the add-on.

## Usage

### Web Interface

After starting the add-on, access the web interface at:
`http://homeassistant.local:8080`

The interface allows you to:
- Select test type (ping, traceroute, DNS, HTTP)
- Enter target hostname or URL
- Choose location
- View real-time results

### Home Assistant Services (Coming Soon)

*Note: Home Assistant service integration is planned for a future update. Currently, you can use the web interface for testing.*

The add-on will provide several services for use in automations:

#### Service: `globalping.ping` (Future)

```yaml
service: globalping.ping
data:
  target: "google.com"
  location: "europe"
  count: 4
```

#### Service: `globalping.traceroute` (Future)

```yaml
service: globalping.traceroute
data:
  target: "cloudflare.com"
  location: "us-west"
```

#### Service: `globalping.dns_lookup` (Future)

```yaml
service: globalping.dns_lookup
data:
  target: "example.com"
  location: "asia"
  record_type: "A"
```

#### Service: `globalping.http_test` (Future)

```yaml
service: globalping.http_test
data:
  target: "https://mywebsite.com"
  location: "north-america"
```

### Automation Examples (Future)

*These examples will work once Home Assistant service integration is implemented.*

#### Monitor Website Availability

```yaml
automation:
  - alias: "Global Website Health Check"
    trigger:
      - platform: time_pattern
        minutes: "/30"  # Every 30 minutes
    action:
      - service: globalping.ping
        data:
          target: "mywebsite.com"
          location: "europe,asia,north-america"
        response_variable: results
      - condition: template
        value_template: "{{ 'failed' in results.status }}"
      - service: notify.pushbullet
        data:
          message: "Website connectivity issues detected!"
```

#### DNS Monitoring

```yaml
automation:
  - alias: "Monitor DNS Resolution"
    trigger:
      - platform: time_pattern
        hours: "/6"  # Every 6 hours
    action:
      - service: globalping.dns_lookup
        data:
          target: "mydomain.com"
          location: "world"
          record_type: "A"
```

## Support

For issues with this add-on:
- Check the add-on logs in Home Assistant
- Open an issue on the GitHub repository

For Globalping-related questions:
- Visit https://globalping.io/
- Check the Globalping documentation

## Changelog & Releases

This repository keeps a change log using [GitHub's releases][releases]
functionality.

Releases are based on [Semantic Versioning][semver], and use the format
of `MAJOR.MINOR.PATCH`. In a nutshell, the version will be incremented
based on the following:

- `MAJOR`: Incompatible or major changes.
- `MINOR`: Backwards-compatible new features and enhancements.
- `PATCH`: Backwards-compatible bugfixes and package updates.

## License

MIT License

Copyright (c) 2025

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

[releases]: https://github.com/robbo600/ha-globalping-addon/releases
[semver]: http://semver.org/spec/v2.0.0.html