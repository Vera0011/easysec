from __future__ import annotations
from enum import StrEnum
from pydantic import BaseModel, Field

from easysec.core.models.audit.Severity import Severity

class FindingStatus(StrEnum):
    """
    Status of findings - For each mapped model
    """

    PASS = "pass"
    FAIL = "fail"
    SKIPPED = "skipped"
    ERROR = "error"


class Finding(BaseModel):
    """
    A finding from the audit
    """

    id: str
    title: str
    severity: Severity
    status: FindingStatus
    host: str | None = None
    category: str | None = None
    description: str | None = None
    evidence: str | None = None
    remediation: str | None = None
    references: list[str] = Field(default_factory=list)