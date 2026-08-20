
from dataclasses import dataclass

@dataclass
class AnsibleResult:
    """
    Class that returns an Ansible result
    """

    returncode: int
    stdout: str
    stderr: str

    @property
    def success(self) -> bool:
        return self.returncode == 0

    @property
    def error(self) -> str:
        return self.stderr

    @property
    def out(self) -> str:
        return self.stdout