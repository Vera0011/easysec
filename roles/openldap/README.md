# Role - OpenLDAP

## Introduction

## Usage
```yaml
- hosts: example-host
  become: true
  roles:
    - openldap
  vars:
    
```

## Properties
- `lynis_user` (string, optional): Name of the user that can execute the binary and access reports/logs (default: `lynis`)

## Test suite
The role has been tested in the following hosts:
### Target hosts
- Ubuntu Server 22.04 (Jammy Jellyfish)
### Manager hosts
- Ubuntu Server 22.04 (Jammy Jellyfish)