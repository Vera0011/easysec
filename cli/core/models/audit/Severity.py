from enum import StrEnum


class Severity(StrEnum):
    """
    Defines the severity available in an auditory
    """

    CRITICAL = "critical"
    HIGH = "high"
    MEDIUM = "medium"
    LOW = "low"
    INFO = "info"
