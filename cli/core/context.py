from __future__ import annotations
from dataclasses import dataclass
from pathlib import Path

from cli.core.exceptions import RepositoryError


@dataclass(frozen=True)
class Context:
    """
    Runtime context for a command

    Parameters
    ----------
    root: Path
        Main application path
    playbooks_dir: Path
        Path were are located playbooks
    roles_dir: Path
        Path were are located roles
    inventory_dir: Path
        Path were are located inventories
    reports_dir: Path
        Path were are located reports
    """

    root: Path
    playbooks_dir: Path
    roles_dir: Path
    inventory_dir: Path
    reports_dir: Path

    @classmethod
    def discover(cls) -> Context:
        current = Path.cwd().resolve()

        for candidate in (current, *current.parents):
            if cls._is_repository(candidate):
                return cls.from_root(candidate)

        raise RepositoryError(
            "Could not found the root repository.\n"
            "Run this command from the root repository."
        )

    @classmethod
    def from_root(cls, root: Path) -> Context:
        """
        Creates the context based on a provided path

        Parameters
        ----------
        root: Path
            Main path provided

        Returns
        -------
        EasySecContext
            The generated context
        """

        root = root.resolve()

        if not cls._is_repository(root):
            raise RepositoryError(
                f"{root} is not the root repository.\n"
                "Run this command from the root repository."
            )

        return cls(
            root=root,
            playbooks_dir=root / "playbooks",
            roles_dir=root / "roles",
            inventory_dir=root / "inventory",
            reports_dir=root / "reports",
        )

    @classmethod
    def _is_repository(cls, root: Path) -> bool:
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
        """
        Returns the audit playbook from this context

        Returns
        -------
        Path
            The built path
        """

        return self.playbooks_dir / "audit.yml"
