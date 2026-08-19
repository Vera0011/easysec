# Role - Auditory
## Introduction
This role is an implementation of some auditory tools that generate an auditory report for the executioner. </br>
This role belong to the `Blue Team` section.

## Implementation
The implementation of this tool in Ansible is as follows:
1. Binaries and configuration files are compressed on the controller.
2. The compressed file is sent to the host and extracted there.
3. Binaries are executed on the host.
4. Generated reports are extracted from the host and stored on the controller.
5. Generated files and configurations and removed from the host
### Usage
1. Run the playbook (instructions can be found [here](../../../../roles/audit/README.md))
2. Generated reports found [here](../../../../roles/audit/reports/)