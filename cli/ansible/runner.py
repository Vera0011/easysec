from __future__ import annotations

import subprocess
from pathlib import Path

from cli.core.models.audit.AnsibleResult import AnsibleResult


class AnsibleRunner:
    """
    Wrapper around ansible-playbook binary
    """

    def __init__(self, repository_root: Path):
        self.repository_root = repository_root

    def run(
        self,
        playbook: Path,
        *,
        inventory: Path,
        ssh_key: str,
        ssh_user: str,
        check: bool,
        diff: bool,
    ) -> AnsibleResult:
        """
        Executes a playbook given the specified parameters

        Parameters
        ----------
        playbook: str
            Path of the selected playbook
        inventory: str
            Path of the selected inventory
        ssh_key: str
            If an access key must be used
        ssh_user: str
            If an access user must be used
        check: bool
            If the parameter 'check' should be enabled or not
        diff: bool
            If the parameter 'diff' should be enabled or not

        Returns
        -------
        AnsibleResult
            The Ansible result as object
        """

        command = [
            "ansible-playbook",
            "-i",
            str(inventory),
            str(playbook),
        ]

        if check:
            command.append("--check")

        if diff:
            command.append("--diff")

        if len(ssh_key) != 0:
            command.extend(["--private-key", str(ssh_key)])

        if len(ssh_user) != 0:
            command.extend(["--user", str(ssh_user)])

        completed = subprocess.run(
            command,
            cwd=self.repository_root,
            text=True,
            capture_output=True,
            check=False,
        )

        return AnsibleResult(
            returncode=completed.returncode,
            stdout=completed.stdout,
            stderr=completed.stderr,
        )
