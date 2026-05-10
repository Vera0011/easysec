# Role - Cosign

## Introduction
This role installs (and configures) Cosign in the specified host.

## Usage
```yaml
- hosts: example-host
  become: true
  roles:
    - cosign
  vars:

```

## Test suite
The role has been tested in the following hosts:
### Target hosts
- Ubuntu Server 22.04 (Jammy Jellyfish)
### Manager hosts
- Ubuntu Server 22.04 (Jammy Jellyfish)