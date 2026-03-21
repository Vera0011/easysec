# Role - Lynis

## Introduction
This role installs (and configures) Lynis in the specified host. The role can also set a custom time to trigger the report generation (with cron jobs).

## Usage
```yaml
- hosts: example-host
  become: true
  roles:
    - lynis
  vars:
    lynis_lang: en
    lynis_user: lynis
    lynis_group: lynis
    lynis_time:
      month: "0"
      day: "0"
      weekday: "0"
      hour: "0"
      minute: "0"
```

## Properties
- `lynis_user` (string, optional): Name of the user that can execute the binary and access reports/logs (default: `lynis`)
- `lynis_group` (string, optional): Name of the group that can execute the binary and access reports/logs (default: `lynis`)
- `lynis_lang` (string, optional): Language of the report (default: `en`)
- `lynis_time` (dictionary, optional): If present, a cron job will be executed at the specified time. Default: `weekday: "0"`, `hour: "3"`, `minute: "0"` (every Sunday at 3 AM). Available fields:
```yaml
  month: "0"
  day: "0"
  weekday: "0"
  hour: "0"
  minute: "0"
```

## Test suite
The role has been tested in the following hosts:

### Target hosts
- Ubuntu Server 22.04 (Jammy Jellyfish)
- Ubuntu Server 24.04 (Noble Numbat)

### Manager hosts
- Ubuntu Server 22.04 (Jammy Jellyfish)