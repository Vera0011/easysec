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
        self, playbook: Path, *, inventory: Path, check: bool = False
    ) -> AnsibleResult:
        """
        Executes a playbook given the specified parameters

        Parameters
        ----------
        playbook: str
            Path of the selected playbook
        inventory: str
            Path of the selected inventory
        check: bool
            If the parameter 'check' should be enabled or not. Default to 'False'

        Returns
        -------
        AnsibleResult
            The Ansible result as object
        """

        command = [
            "ansible-playbook",
            "-i",
            str(inventory or "inventory"),
            str(playbook),
        ]

        if check:
            command.append("--check")

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
