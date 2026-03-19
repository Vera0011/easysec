# Role - Proxychains

## Introduction
This role installs (and configures) proxychains in the specified host. For each proxy, the role starts a Tor service in a specific port. </br>
### Tor
This role uses Tor under the hood. Before creating the new Tor services, the role removes all the custom Tor services, creates a new one, sets a system unit (that is shared across instances) and sets a specific config. These instances can be used with Proxychains
### Proxychains
Proxychains configuration is applied and sets round-robin method (in the usage of Tor)

## Usage
```yaml
- hosts: example-host
  become: true
  roles:
    - proxychains
  vars:
    proxychains_clean: false
    proxychains_total_proxies: 10
```

## Properties
- `proxychains_clean` (true/false): If the role must be executed in clean mode (to remove all proxies) or not
- `proxychains_total_proxies` (int): Number of proxies to setup

## Test suite
The role has been tested in the following hosts:
### Target hosts
- `Kali Linux - Rolling`
### Manager hosts
- `Ubuntu Server 22.04 (Jammy Jellyfish)`