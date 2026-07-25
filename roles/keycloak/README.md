# Role - Keycloak

## Introduction
This role installs (and configures) Keycloak in the specified host. The role also creates a temporary admin and then outputs the credentials [here](../../generated/keycloak_admin.txt).

> [!CAUTION]
> SSL is not handled by this role. For that, please ensure to invoque the (before using this role) the [SSL role](../ssl/README.md).
> Also, this role can not be installed alone, please refer to [this example](../../workflows/keycloak.yml).

## Usage
```yaml
- hosts: example-host
  become: true
  roles:
    - keycloak
  vars:
    keycloak_database_host: localhost
    keycloak_database_port: 5432
    keycloak_database_name: keycloak
    keycloak_database_user: keycloak
    keycloak_database_password: keycloak
```

## Properties
- `keycloak_database_host` (string): The host (IP address, hostname) of the PostgreSQL instance (default: `localhost`)
- `keycloak_database_port` (integer): The port of the PostgreSQL instance (default: 5432)
- `keycloak_database_name` (string): Name of the database used for Keycloak the PostgreSQL instance (default: `keycloak`)
- `keycloak_database_user` (string): Name of the user used in the PostgreSQL instance (default: `keycloak`)
- `keycloak_database_password` (string, optional): Password of the user used in Keycloak the PostgreSQL instance (default: `localhost`)

> [!CAUTION]
> The variable `keycloak_database_password` can be set manually. If not set, the role will try to read the generated file from PostgreSQL.

## Test suite
> [!CAUTION]
> This role has only been tested in single-node instance (PostgreSQL and Keycloak).
The role has been tested in the following hosts:
### Target hosts
- Ubuntu Server 22.04 (Jammy Jellyfish)
### Manager hosts
- Ubuntu Server 22.04 (Jammy Jellyfish)