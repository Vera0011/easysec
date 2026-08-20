from __future__ import annotations
from datetime import datetime, timezone
from pydantic import BaseModel, Field

from easysec.core.models.audit.Finding import Finding
from easysec.core.models.audit.AuditSummary import AuditSummary

class AuditResult(BaseModel):
    id: str
    started_at: datetime
    finished_at: datetime | None = None

    repository: str
    inventory: str
    limit: str | None = None

    success: bool = False

    findings: list[Finding] = Field(default_factory=list)
    summary: AuditSummary = Field(default_factory=AuditSummary)

    @classmethod
    def create(
        cls,
        *,
        repository: str,
        inventory: str,
        limit: str | None = None,
    ) -> "AuditResult":
        return cls(
            id=datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ"),
            started_at=datetime.now(timezone.utc),
            repository=repository,
            inventory=inventory,
            limit=limit,
        )
