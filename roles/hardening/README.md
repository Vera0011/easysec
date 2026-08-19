# Role - Hardening

## Introduction
This role configures a system to apply different hardening configurations. It is module-based, so you can apply only the necessary for your use case. A list of the modules is provided below. Each task and block section has anotations related to Lynis recommendations.

> [!CAUTION]
> If you do not know what a specific module changes, do not activate it. The default modules activated are normally enough to provide a correct security in a system, but some options can lock you out of the system.

## Available modules
- `hardening_grub`: Deactivates GRUB recovery, sets a master password when starting GRUB (starting system). Default: `false`.
- `hardening_coredumps`: Deactivates all coredumps in the system. Default: `true`.
- `hardening_passwords`: Sets expiration to passwords, changes default umask, activates "su" logs, locks root account password, forces usage of SHA512, increases hashing rouds, installs `libpam-passwdqc` and `libpam-pwquality`. Default: `true`.
- `hardening_ports`: Disables USB, restricts access to serial ports, disables physical access, removes firewire-core and firewire-ohci. Default: `true`.
- `hardening_protocols`: Disables `dccp`, `sctp`, `rds` and `tipc` network protocols. Default: `true`.
- `hardening_banners`: Sets a custom banner in `/etc/issue` and `/etc/issue.net`. Default: `true`.
- `hardening_antivirus`: Installs `rkhunter`, `clamav` `chkrootkit` software. Default: `true`.
- `hardening_patch_management`: Installs `debsums`, `unattended-upgrades`, `apt-listchanges` and `apt-show-versions` software. Enables automatic updates (only security ones). Default: `true`.
- `hardening_partitions`: Moves partitions `/home`, `/var` and `/tmp` to a new disk (maintaining data and required an empty disk). Creates partition `/secrets` LUKS encrypted. Default: `false`.
- `hardening_auditory`: Downloads AIDE, Sysstat and AuditD, inits and starts software, adds custom audit rules (from Neo23x0)
- `hardening_services`: Hardens different services (Systemd unit and AppArmor are enabled). For the moment, only the `UFW` service is executed. Default: `true`.

## Consequences
> [!CAUTION]
For the following modules, implemented without knowledge, can lead to outages. A list of problems is proposed:
- `GRUB modifcation`: No more access to system if GRUB password is lost, unable to use the system due to broken structure.
- `Partition modification`: Losing data, unable to access encrypted partition if decryption key is lost, unable to use the system due to broken structure.

## Usage
```yaml
- hosts: example-host
  become: true
  roles:
    - hardening
  vars:
    hardening_grub: false
    hardening_coredumps: false
    hardening_passwords: true
    hardening_ports: true
    hardening_protocols: true
    hardening_banners: true
    hardening_antivirus: true
    hardening_patch_management: true
    hardening_partitions: false
    hardening_auditory: true
    hardening_services: true
```
## Properties
- `hardening_grub`: Activate module related to GRUB. Default: `false`.
- `hardening_coredumps`: Activate module related to CoreDumps. Default: `true`.
- `hardening_passwords`: Activate module related to password hardening. Default: `true`.
- `hardening_ports`: Activate module related to port hardening (USB and media). Default: `true`.
- `hardening_protocols`: Activate module related to protocol hardening. Default: `true`.
- `hardening_banners`: Activate module related to banner hardening. Default: `true`.
- `hardening_antivirus`: Activate module related to antivirus installation and configuration. Default: `true`.
- `hardening_patch_management`: Activate module related to patch management. Default: `true`.
- `hardening_partitions`: Activate module related to partitions. Default: `false`.
- `hardening_auditory`: Activate module related to auditory. Default: `true`.
- `hardening_services`: Activate module related to service hardening. Default: `true`.

## Test suite
The role has been tested in the following hosts:

### Target hosts
- Ubuntu Server 22.04 (Jammy Jellyfish)

### Manager hosts
- Ubuntu Server 22.04 (Jammy Jellyfish)