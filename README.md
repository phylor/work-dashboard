# Work Dashboard

![Dashboard](docs/dashboard.png)

This is my personal dashboard used at work. It includes:

- Ratio of billable versus non-billable work time of the current month
- Stable versions of Ruby
- Latest stable Rails version

## Setup

Set the following environment variables:

```
HLEDGER_CLIENTS   # The file path to clients.yml
RACK_SECRET       # Random secret for Rack
```

Start the dashboard:

```
bundle
bundle exec smashing start
```
