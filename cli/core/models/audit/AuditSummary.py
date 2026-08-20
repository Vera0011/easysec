from __future__ import annotations
from pydantic import BaseModel


class AuditSummary(BaseModel):
    """
    Summary of an auditory

    Parameters
    ----------
    total: int
        Total executed tests
    passed: int
        Total passed tests
    failed: int
        Total failed tests
    skipped: int
        Total skipped tests
    errors: int
        Total errors generated
    critical: int
        Total critical findings
    high: int
        Total high findings
    medium: int
        Total medium findings
    low: int
        Total low findings
    """

    total: int = 0
    passed: int = 0
    failed: int = 0
    skipped: int = 0
    errors: int = 0

    critical: int = 0
    high: int = 0
    medium: int = 0
    low: int = 0
