# Role - Hardening

## Introduction
This role configures a system to apply different hardening configurations. It is module-based, so you can apply only the necessary for your use case. A list of the modules is provided below. Each task and block section has anotations related to Lynis recommendations.

> [!CAUTION]
> If you do not know what a specific module changes, do not activate it. The default modules activates are enough to provide a correct security in a system, but some options can lock you out of the system.

## Available modules
- GRUB password activation. Sets a master password when accessign GRUB (starting system). Default: `false`.
- CoreDumps deactivation: Deactivates all coredumps in the system. Default: `true`.
- Password management: Sets expiration to passwords, activates SU logs, locks root account password, increases hashing rouds, installs `libpam-passwdqc` and `libpam-pwquality`. Default: `true`.
- Protocols: Disables `dccp`, `sctp`, `rds` and `tipc` network protocols. Default: `true`.