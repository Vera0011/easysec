from __future__ import annotations
from dataclasses import dataclass
from pathlib import Path

from easysec.core.exceptions import RepositoryError


@dataclass(frozen=True)
class EasySecContext:
    """Runtime context for an EasySec command."""

    root: Path
    playbooks_dir: Path
    roles_dir: Path
    inventory_dir: Path
    reports_dir: Path

    @classmethod
    def discover(cls, start: Path | None = None) -> "EasySecContext":
        current = (start or Path.cwd()).resolve()

        for candidate in (current, *current.parents):
            if cls._is_repository(candidate):
                return cls.from_root(candidate)

        raise RepositoryError(
            "Could not find an EasySec repository.\n"
            "Run this command from the EasySec repository or use --root."
        )

    @classmethod
    def from_root(cls, root: Path) -> "EasySecContext":
        root = root.resolve()

        if not cls._is_repository(root):
            raise RepositoryError(
                f"{root} does not appear to be an EasySec repository."
            )

        return cls(
            root=root,
            playbooks_dir=root / "playbooks",
            roles_dir=root / "roles",
            inventory_dir=root / "inventory",
            reports_dir=root / "reports",
        )

    @staticmethod
    def _is_repository(root: Path) -> bool:
        return all(
            (
                (root / "playbooks").is_dir(),
                (root / "roles").is_dir(),
                (root / "inventory").is_dir(),
                (root / "ansible.cfg").is_file(),
            )
        )

    @property
    def audit_playbook(self) -> Path:
        return self.playbooks_dir / "audit.yml"
