class EasySecError(Exception):
    """Base exception for expected EasySec errors."""


class DependencyError(EasySecError):
    """A required external dependency is missing."""


class AuditError(EasySecError):
    """An audit could not be executed."""

class RepositoryError(RuntimeError):
    """Raised when the EasySec repository cannot be resolved."""