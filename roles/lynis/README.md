# Role - Lynis

## Introduction
This role installs (and configures) lynis in the specified host.

## Usage
```yaml
- hosts: example-host
  become: true
  roles:
    - lynis
  vars:
    lynis_user: lynis
    lynis_group: lynis
    lynis_time: "0 */12 * * * *"
```

## Properties
- `lynis_user` (true/false): If the role must be executed in clean mode (to remove all proxies) or not
- `lynis_group` (int): Number of proxies to setup
- `lynis_time`

## Test suite
The role has been tested in the following hosts:
### Target hosts
- `Ubuntu Server 22.04 (Jammy Jellyfish)`
### Manager hosts
- `Ubuntu Server 22.04 (Jammy Jellyfish)`