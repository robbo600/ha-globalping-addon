# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-07-17

### Added
- Initial release of Globalping Home Assistant Add-on
- Web interface for manual network testing
- Home Assistant services for automation integration
- Support for ping, traceroute, DNS lookup, and HTTP tests
- Global probe network access via Globalping API
- Configurable default locations and API token support
- Multi-architecture support (amd64, aarch64, armhf, armv7, i386)
- Comprehensive documentation and examples

### Features
- **Web Interface**: Accessible on port 8080 with intuitive test interface
- **Home Assistant Services**: 
  - `globalping.ping` - Run ping tests from global probes
  - `globalping.traceroute` - Perform traceroute diagnostics
  - `globalping.dns_lookup` - DNS resolution testing
  - `globalping.http_test` - HTTP endpoint testing
- **Global Coverage**: Access to hundreds of probes worldwide
- **Flexible Location Selection**: Support for continents, countries, cities, ISPs, and cloud regions
- **Free Tier**: Generous limits with optional API token for increased quotas

### Technical Details
- Built on Alpine Linux for minimal footprint
- Uses official Globalping CLI for reliable API access
- Flask-based web interface with responsive design
- Comprehensive error handling and logging
- Home Assistant service integration with proper schemas

### Configuration Options
- `api_token`: Optional Globalping API token
- `default_location`: Default probe location (world, europe, asia, etc.)
- `web_interface`: Enable/disable web interface
- `log_level`: Configurable logging level

[1.0.0]: https://github.com/robbo600/ha-globalping-addon/releases/tag/v1.0.0