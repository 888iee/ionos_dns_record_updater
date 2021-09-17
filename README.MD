[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

<p align="center">
	<h1 align="center">IONOS DNS Record Updater</h1>
</p>

## About the Project
Since IONOS made an API available to manage your domains and I needed to change my 
records regularly I decided to create an automated dns record updater.

## Getting Started

### Prerequisites

```bash
apt install curl jq
```

### Installation
1. Get an API Key at [IONOS API Docs](https://developer.hosting.ionos.de/docs/getstarted)
2. Clone the repo
	```bash
	git clone https://github.com/888iee/ionos_dns_record_updater.git
	```
3. cd into directory
	```bash
	cd ionos_dns_record_updater
	```
4. Create a .env File
	```bash
	touch .env
	```
5. Paste your key and values in 
	```ini
	api_key="prefix.encryptionkey"
	domain="https://my.domain.com"
	dns_type="A"
	```

## Usage

You can run the updater script with following commands.
Replace my.ip.adr with your real ip adress
```bash
chmod +x updater.sh
./updater "my.ip.adr"
```

## License
Distributed under the MIT License. See `LICENSE` for more information.

## Dislaimer

Only IPv4 Adress was tested. 

