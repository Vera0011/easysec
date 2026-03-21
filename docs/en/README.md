# EasySec - English
## Introduction
EasySec is a repository that includes a variety of roles, documentation, and tools designed to help small and medium-sized enterprises (SMEs) implement security measures within their own organizations, as well as promoting penetration testing and red teaming exercises. This file will serve as an index to make it easier to review and analyze the available tools and documentation. The tools and workflows implemented are idempotent. This means that no matter how many times they are run, the result will always be the same.

## Disclaimer and contributions
This project is completely open source, created by Vera and licensed under the [MIT License](./../../LICENSE.md). Any contributions, suggestions, or implementations can be submitted in the “Pull Requests” section.

## Roadmap
Depending on how the project progresses, these are the tools and environments I would like to implement:
- [X] Proxychains + Tor
- [X] Lynis
- [X] Grype
- [X] Syft
- [X] Grant
- [ ] Keycloak
- [ ] Netmaker
- [ ] Pomerium
- [ ] Netbird
- [ ] MISP
- [ ] TheHive
- [ ] Suricata
- [ ] Nftables
- [ ] Iptables
- [ ] UFW
- [ ] Teleport
- [ ] Jenkins
- [ ] Graylog
- [ ] OpenSCAP
- [ ] InSpec
- [ ] OpenVAS
- [ ] Nessus
- [ ] Trivy
- [ ] SOC environment - Wazuh
- [ ] SOAR environment - Shuffle
- [ ] Bandit
- [ ] HashiCorp Vault
- [ ] Checkov
- [ ] Trivy
- [ ] Gitleaks
- [ ] Betterleaks
- [ ] Fail2ban
- [ ] Aikido Safe-chain
- [ ] ScoutSuite
- [ ] Red Teaming Environment - Required Tools

## Resources
### Red Team
#### Tools
- Proxychains - Software for using proxies more conveniently. Information on implementation [here](./tools/red/proxychains.md)

### Blue team
#### Tools
- Lynis - Software for machine and container analysis and generating reports (based on specific guidelines). Information of implementation [here](./tools/blue/lynis.md)
- Grype - Software for machine, container and repository analysis and generating reports. Information of implementation [here](./tools/blue/grype.md)
- Syft - Software for SBOM generation. Information of implementation [here](./tools/blue/syft.md)
- Grant - Software to analyze currently used Licenses. Information of implementation [here](./tools/blue/grant.md)

#### Workflows
- Anchore - Workflow including multiple tools to analyze dependencies and licenses. Information of implementation [here](./workflows/blue/anchore.md)