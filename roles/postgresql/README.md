# Role - PostgreSQL

## Introduction
This role installs and configures a PostgreSQL instance + cluster. This role also modifies `sysctl` parameters of the system to implement `hugepages` and protection against `OOM`. Be careful when installing if your system already overrides these values.
The version of PostgreSQL implemented in this role is `v18`.

## Usage
```yaml
- hosts: example-host
  become: true
  roles:
    - postgresql
  vars:
    postgresql_port: 5432
    postgresql_address: "'*'"

    postgresql_user_enable: true
    postgresql_database_enable: true
    postgresql_ssl_enable: true
    postgresql_oauth_enable: false
    postgresql_wal_enable: false

    postgresql_users:
      - { name: "easysec", password: "", superuser: true }
      - { name: "manager-easysec", password: "", superuser: false }

    postgresql_databases:
      - { name: "easysec", owner: "manager-easysec", encoding: "UTF-8" }
        
    postgresql_ssl_cert_path: "{{ postgresql_config_dir }}/server.crt"
    postgresql_ssl_key_path: "{{ postgresql_config_dir }}/server.key"
    postgresql_ssl_enable_dns: false
    postgresql_ssl_provider: "cloudflare"
    postgresql_ssl_credentials:
            token: "token1234"
    postgresql_ssl_generate: true
    postgresql_ssl_domain: "postgresql.easysec.x"
    postgresql_ssl_output_path: "{{ postgresql_cert_file }}"
    postgresql_ssl_privatekey_path: "{{ postgresql_key_file }}"
    postgresql_ssl_email: "admin@postgresql.easysec.x"
    postgresql_ssl_owner: "{{ postgresql_user }}"
    postgresql_ssl_group: "{{ postgresql_group }}"

    postgresql_oauth_provider: kc_validator
    postgresql_oauth_endpoint: https://<keycloak>/realms/<realm>/protocol/openid-connect/token
    postgresql_oauth_audience: postgres-resource
    postgresql_oauth_resource_name: appdb
    postgresql_oauth_client_id: postgres-resource
    postgresql_oauth_http_timeout: 2000
    postgresql_oauth_issuer: https://<keycloak>/realms/<realm>

    postgresql_wal_level: "replica"
    postgresql_wal_max_size: "1GB"
    postgresql_wal_min_size: "80MB"
    postgresql_wal_max_senders: 10
    postgresql_wal_max_replicas: 10

    postgresql_hba_entries:
      - { type: "local", database: "all", user: "postgres", address: "", method: "peer" }
      - { type: "hostssl", database: "all", user: "all", address: "0.0.0.0/0", method: "scram-sha-256" }
      - { type: "host", database: "all", user: "all", address: "0.0.0.0/0", method: "reject" }
```

## Properties
- `postgresql_port` (int): The number of the listening port. Default to `5432`
- `postgresql_address` (str): On which address should the server listen. Default to '*' (all)
- `postgresql_user_enable` (true/false): If the role must create users or not. If `true`, the variable `postgresql_users` must be modified. Defaul to `true`.
- `postgresql_database_enable` (true/false): If the role must create databases or not. If `true`, the variable `postgresql_databases` must be modified. Defaul to `true`.
- `postgresql_ssl_enable` (true/false): If the role must include SSL connections or not. If `true`, the variable `postgresql_ssl` must be modified. Default to `true`. 
- `postgresql_oauth_enable` (true/false): If the role must configure Oauth connections. If `true`, the variable `postgresql_oauth` must be modified. Default to `false`.
- `postgresql_wal_enable` (true/false): If the role must configure WAL and replication. If `true`, the variable `postgresql_wal` must be modified. Default to `false`

- `postgresql_users` (list of dicts): The information related to users to be created. Available fields are:
    - `name` (str): Name of the user.
    - `password` (str): Password in clear-text. If empty, the password is auto-generated and shown in Ansible logs.
    - `superuser` (true/false): If the user must be superuser or not. If not, "NOSUPERUSER,NOCREATEDB,NOCREATEROLE" are set.

- `postgresql_databases` (list of dicts): The information related to databases to be created. Available fields are:
    - `name` (str): Name of the database.
    - `owner` (str): Owner of the database (must be the name of the owner).
    - `encoding` (str): Encoding set. Normally, this should be UTF-8.

Some of these fields are related to the [SSL role](../ssl/README.md) and will not be specified here. Available fields:
- `postgresql_ssl_cert_path` (str): Where to store the generated certificate
- `postgresql_ssl_key_path` (str): Where to store the generated certificate private key

> [!CAUTION]
> Oauth module is only available in versions `18+`
- `postgresql_oauth_provider` (str): Name of the provider. Default to `kc_validator`
- `postgresql_oauth_endpoint` (str): URL of the provider endpoint. Default to `https://<keycloak>/realms/<realm>/protocol/openid-connect/token`
- `postgresql_oauth_audience` (str): Audience name from provider. Default to `postgres-resource`
- `postgresql_oauth_resource_name` (str): Resource name from provider. Default to `appdb`
- `postgresql_oauth_client_id` (str): Id from provider. Default to `postgres-resource`
- `postgresql_oauth_http_timeout` (int): Total of milliseconds for timeout. Default to `2000`
- `postgresql_oauth_issuer` (str): URL of the realm. Default to `https://<keycloak>/realms/<realm>`

- `postgresql_wal_level` (str): The replication level. Options can be found [here](https://www.postgresql.org/docs/18/runtime-config-wal.html). Default to `replica`
- `postgresql_wal_max_size` (str): Maximum size to let the WAL grow during checkpoints. More information [here](https://www.postgresql.org/docs/18/runtime-config-wal.html). Default to `1GB`
- `postgresql_wal_min_size` (str): Minimum size for WAL disk usage. More information [here](https://www.postgresql.org/docs/18/runtime-config-wal.html). Default to `80MB`
- `postgresql_wal_max_senders` (int): Maximum of concurrent connections from standby servers. More information [here](https://www.postgresql.org/docs/18/runtime-config-replication.html). Default to `10`
- `postgresql_wal_max_replicas` (int): Maximum of replication slots. More information [here](https://www.postgresql.org/docs/18/runtime-config-replication.html). Default to `10`

- `postgresql_hba_entries` (list of dicts): Entries that are set in `pg_hba.conf`. Available fields:
    - `type` (str): Connection type (`local`, `hostssl`, `host`)
    - `database` (str): Database name or `all`
    - `user` (str): Specific user name or `all`
    - `address` (str): Specific IP address or `""`
    - `method` (str): Specific method (`peer`, `reject`, `scram-sha-256`)
## Test suite
> [!CAUTION]
> This role has only been tested in single-node instance without Oauth
> The Oauth module has been mentioned for future implementations, for the moment it is not active
The role has been tested in the following hosts:
### Target hosts
- Ubuntu Server 22.04 (Jammy Jellyfish)
### Manager hosts
- Ubuntu Server 22.04 (Jammy Jellyfish)