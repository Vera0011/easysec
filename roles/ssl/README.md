# Role - SSL

## Introduction
This role installs, configures and creates a certificate, based on different options enabled in environment variables.

> [!CAUTION]
> This role also creates the group `ssl-cert`, so services can access their specific private keys. Be aware of this when using this role with other role services (for example, PostgreSQL), to ensure that the service user also has access to this group.

## Usage
```yaml
- hosts: example-host
  become: true
  roles:
    - ssl
  vars:
    # -- DNS-related configuration --#
    ssl_dns: false
    ssl_provider: "cloudflare"
    ssl_credentials:
      token: "token1234"
      secret: "secret1234"
      consumer: "consumer1234"

    # -- Certificate generation --#
    ssl_generate: true
    ssl_move_cert: true
    ssl_move_key: true

    ssl_cert_path: ""/etc/ssl/certs/easysec.pem"
    ssl_key_path: ""/etc/ssl/private/easysec.key"

    ssl_domain: "easysec.x"
```

## Properties
### Configuration
- `ssl_dns` *(bool)*: If the role must generate the certificate via DNS-01 challenge or not. Default to `false`.
- `ssl_provider` *(enum)*: The provider used to generate the certificate. Available options:
    - `ovh` - requires `ssl_credentials`. [Documentation](https://certbot-dns-ovh.readthedocs.io/en/stable/).
    - `digitalocean` - requires `ssl_credentials`. [Documentation](https://certbot-dns-digitalocean.readthedocs.io/en/stable/).
    - `cloudflare` - requires `ssl_credentials`. [Documentation](https://certbot-dns-cloudflare.readthedocs.io/en/stable/).
    - `selfsigned` - no credentials required.
- `ssl_credentials` *(dict)*: Credentials used for the specific provider. Required fields:
    - `token` *(str)* - Required for `ovh`, `digitalocean` and `cloudflare` providers.
    - `secret` *(str)* - Required for `ovh` provider.
    - `consumer` *(str)* - Required for `ovh` provider.
### Generation
- `ssl_generate` *(bool)*: If the role must generate a certificate or not. Default to `true`.
- `ssl_domain` *(str)*: The domain name to generate. Defaults to `easysec.x`.
- `ssl_move_cert` *(bool)*: If the generated certificate must be moved to a specific location. Default to `false`.
- `ssl_move_key` *(bool)*: If the generated key of the certificate must be moved to a specific location. Default to `false`.
- `ssl_move_csr` *(bool)*: If the generated CSR certificate must be moved to a specific location. Default to `false`.
- `ssl_cert_path` *(str)*: The new path were to send the generated certificate. Defaults to `/tmp/{{ ssl_domain }}.crt`.
- `ssl_key_path` *(str)*: The new path were to send the generated key. Defaults to `/tmp/{{ ssl_domain }}.key`.
- `ssl_csr_path` *(str)*: The new path were to send the generated certificate. Defaults to `/tmp/{{ ssl_domain }}.csr`.
- `ssl_csr_config` *(dict)*: The CSR needs some information to be generated and valid. Required fields:
    - `country` *(str)*: The country of the CA. Defaults to `ES`.
    - `organization_name` *(str)*: The organization name of the CA. Defaults to `EasySec`.
    - `unit_name` *(str)*: The Unit name of the CA. Defaults to `Security`.
- `ssl_email` *(str)*: The contact email used in the certificate generation. Defaults to `whoami@easysec.x`-
- `ssl_new_owner` *(str)*: If the certficate/key is moved, a new owner can be set. Defaults to the defined owner of the role
- `ssl_new_group` *(str)*: If the certficate/key is moved, a new group can be set. Defaults to the defined group of the role

## Test suite
> [!CAUTION]
> This role has only been tested with the provider "selfsigned". No domain is currently used for this project, so the other options have not been tested

The role has been tested in the following hosts:
### Target hosts
- Ubuntu Server 22.04 (Jammy Jellyfish)
### Manager hosts
- Ubuntu Server 22.04 (Jammy Jellyfish)