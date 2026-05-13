# Role - SSL

## Introduction
This role installs, configures and creates a certificate, based on different options enabled in environment variables.
### Certbot
Certbot is used under the hood (for public domains). This allows to generate them via HTTP or DNS.  This role supports 3 DNS providers: DigitalOcean, Cloudflare and OVH

## Usage
```yaml
- hosts: example-host
  become: true
  roles:
    - ssl
  vars:
    ssl_dns_enabled: true
    ssl_provider: "cloudflare"
    ssl_credentials:
      token: "token1234"
    ssl_generate: true
    ssl_generate_config:
      domain: "easysec.x"
      output_path: "/opt/test/myfullchain.pem"
      privatekey_path: "/opt/test/mykey.key"
      email: "whoami@easysec.x"
      owner: "easysec"
      group: "easysec"
```

## Properties
- `ssl_dns_enabled` (true/false): If the certificate must be generated using DNS-01 verification or not
- `ssl_provider` (str): Which provider to use when generating certificates via DNS. Available options are: `cloudflare`, `ovh`, `digitalocean` and `selfsigned`
- `ssl_credentials` (dict): Required if `ssl_provider` is true. Credentials used if a provider is specified. Depending the provider, required fields are:
    - `token`
    - `secret`
    - `consumer`
- `ssl_generate` (true/false): If the role must generate a certificate or not
- `ssl_generate_config` (dict): Required if `ssl_generate` is true. These are the specifications of the certificate. Available fields:
    - `domain`: Name of the domain
    - `output_path`: Where to store the `fullchain.pem` file (absolute path). Performs a `cp`, not a `mv`
    - `privatekey_path`: Where to store the `privkey.key` file (absolute path). Performs a `cp`, not a `mv`
    - `email`: Contact email of the domain
    - `owner`: If the output files (keys) need a specific user. Defaults to the role user
    - `group`: If the output files (keys) need a specific group. Defaults to the role group

## Test suite
> [!CAUTION]
> This role has only been tested with the provider "selfsigned". No domain is currently used for this project, so the other options have not been tested
The role has been tested in the following hosts:
### Target hosts
- Ubuntu Server 22.04 (Jammy Jellyfish)
### Manager hosts
- Ubuntu Server 22.04 (Jammy Jellyfish)