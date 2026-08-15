# Role - Hardening

## Introduction
This role configures a system to apply different hardening configurations. It is module-based, so you can apply only the necessary for your use case. A list of the modules is provided below. Each task and block section has anotations related to Lynis recommendations.

> [!CAUTION]
> If you do not know what a specific module changes, do not activate it. The default modules activates are enough to provide a correct security in a system, but some options can lock you out of the system.

## Available modules
- `hardening_grub`: Deactivates GRUB recovery, sets a master password when starting GRUB (starting system). Default: `false`.
- `hardening_coredumps`: Deactivates all coredumps in the system. Default: `true`.
- `hardening_passwords`: Sets expiration to passwords, changes default umask, activates "su" logs, locks root account password, forces usage of SHA512, increases hashing rouds, installs `libpam-passwdqc` and `libpam-pwquality`. Default: `true`.
- `hardening_ports`: Disables USB, restricts access to serial ports, disables physical access, removes firewire-core and firewire-ohci. Default: `true`.
- `hardening_protocols`: Disables `dccp`, `sctp`, `rds` and `tipc` network protocols. Default: `true`.
- `hardening_banners`: Sets a custom banner in `/etc/issue` and `/etc/issue.net`. Default: `true`.
- `hardening_antivirus`: Installs `rkhunter` and `chkrootkit` software. Default: `true`.
- `hardening_patch_management`: Installs `debsums` and `apt-show-versions` software. Default: `true`.