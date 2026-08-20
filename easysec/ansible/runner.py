from __future__ import annotations

import shutil
import subprocess
from pathlib import Path

from easysec.core.exceptions import DependencyError
from easysec.core.models.audit.AnsibleResult import AnsibleResult

class AnsibleRunner:
    """Thin wrapper around ansible-playbook."""

    def __init__(self, repository_root: Path):
        self.repository_root = repository_root

    def check_available(self) -> None:
        if shutil.which("ansible-playbook") is None:
            raise DependencyError(
                "ansible-playbook was not found in PATH.\n"
                "Install Ansible before running an EasySec audit."
            )

    def run(
        self,
        playbook: Path,
        *,
        inventory: Path | str | None = None,
        limit: str | None = None,
        check: bool = False,
        extra_vars: dict[str, str] | None = None,
    ) -> AnsibleResult:
        self.check_available()

        command = [
            "ansible-playbook",
            "-i",
            str(inventory or "inventory"),
            str(playbook),
        ]

        if limit:
            command.extend(["--limit", limit])

        if check:
            command.append("--check")

        for key, value in (extra_vars or {}).items():
            command.extend(["--extra-vars", f"{key}={value}"])

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
