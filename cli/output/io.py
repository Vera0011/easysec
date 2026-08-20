from __future__ import annotations
import typer
from pathlib import Path
from datetime import datetime, timezone
from rich.console import Console
from rich.table import Table

from cli.core.models.audit.AuditResult import AuditResult


def _render_success(context: typer.Context, result: AuditResult) -> None:
    table = Table(title=f"Audit Summary - {datetime.now(timezone.utc)}")

    table.add_column("Status")
    table.add_column("Count", justify="right")

    table.add_row("[green]Passed[/green]", str(result.summary.passed))
    table.add_row("[red]Failed[/red]", str(result.summary.failed))
    table.add_row("[yellow]Skipped[/yellow]", str(result.summary.skipped))
    table.add_row("[red]Errors[/red]", str(result.summary.errors))

    context.console.print(table)
    context.console.print("\n[green]Audit completed successfully.[/green]")


def _write_result(
    context: typer.Context,
    result: AuditResult,
    output: Path,
    output_format: str,
) -> None:
    output.parent.mkdir(parents=True, exist_ok=True)

    if output_format != "json":
        raise ValueError(f"Unsupported output format: {output_format}")

    output.write_text(
        result.model_dump_json(indent=2),
        encoding="utf-8",
    )

    context.console.print(f"\n[dim]Result written to {output}[/dim]")
