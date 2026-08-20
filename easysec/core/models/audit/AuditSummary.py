from __future__ import annotations
from pydantic import BaseModel

class AuditSummary(BaseModel):
    total: int = 0
    passed: int = 0
    failed: int = 0
    skipped: int = 0
    errors: int = 0

    critical: int = 0
    high: int = 0
    medium: int = 0
    low: int = 0