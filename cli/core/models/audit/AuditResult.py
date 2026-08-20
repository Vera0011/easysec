from __future__ import annotations
from datetime import datetime, timezone
from pydantic import BaseModel, Field

from cli.core.models.audit.Finding import Finding
from cli.core.models.audit.AuditSummary import AuditSummary


class AuditResult(BaseModel):
    """
    The result of an auditory

    Parameters
    ----------
    id: str
        Automatic generated ID
    started_at: datetime
        Start of the auditory (UTC)
    finished_at: datetime
        Finishing of the auditory (UTC)
    inventory: str
        Asset inventory where to execute the audit
    success: bool
        If the auditory was a success or not
    findings: list[Finding]
        A list of Finding objects
    summary: AuditSummary
        The summary of the auditory (total points)
    """

    id: str
    started_at: datetime
    finished_at: datetime | None = None
    inventory: str
    success: bool = False
    findings: list[Finding] = Field(default_factory=list)
    summary: AuditSummary = Field(default_factory=AuditSummary)

    @classmethod
    def create(cls, inventory: str) -> "AuditResult":
        """
        Creates an AuditResult object

        Parameters
        ----
        inventory: str
            Asset inventory where to execute the audit

        Returns
        -------
        AuditResult
            The result of the auditory
        """

        now: datetime = datetime.now(timezone.utc)

        return cls(
            id=now.strftime("%Y%m%dT%H%M%SZ"), started_at=now, inventory=inventory
        )
