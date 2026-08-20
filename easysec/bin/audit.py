from __future__ import annotations

from pathlib import Path

from rich.console import Console
from rich.panel import Panel
from rich.table import Table

from easysec.ansible.runner import AnsibleRunner
from easysec.core.context import EasySecContext
from easysec.core.models.audit.AuditResult import AuditResult

console = Console()


def run_audit(
    context: EasySecContext,
    *,
    inventory: Path | str | None = None,
    limit: str | None = None,
    check: bool = False,
    output: Path | None = None,
    output_format: str = "console",
) -> int:
    inventory_value = str(inventory or context.inventory_dir)

    result = AuditResult.create(
        repository=str(context.root),
        inventory=inventory_value,
        limit=limit,
    )

    console.print()
    console.print(
        Panel.fit(
            "[bold cyan]EasySec Security Audit[/bold cyan]\n"
            f"Repository: {context.root}\n"
            f"Inventory:  {inventory_value}\n"
            f"Target:     {limit or 'all'}",
            border_style="cyan",
        )
    )

    if check:
        console.print(
            "\n[yellow]Check mode enabled — no changes will be made.[/yellow]\n"
        )

    if not context.audit_playbook.is_file():
        console.print(f"[red]Audit playbook not found:[/red] {context.audit_playbook}")
        return 2

    runner = AnsibleRunner(context.root)

    console.print("[bold]Running audit...[/bold]\n")

    ansible_result = runner.run(
        context.audit_playbook,
        inventory=inventory_value,
        limit=limit,
        check=check,
    )

    console.print(ansible_result.stdout)

    if ansible_result.stderr:
        console.print(f"[yellow]{ansible_result.stderr}[/yellow]")

    result.success = ansible_result.success

    if ansible_result.success:
        result.finished_at = result.started_at
        _render_success(result)
    else:
        console.print(
            Panel(
                f"Ansible exited with code {ansible_result.returncode}",
                title="Audit failed",
                border_style="red",
            )
        )

        result.finished_at = result.started_at

    if output:
        _write_result(result, output, output_format)

    return 0 if ansible_result.success else ansible_result.returncode


def _render_success(result: AuditResult) -> None:
    table = Table(title="Audit Summary")

    table.add_column("Status")
    table.add_column("Count", justify="right")

    table.add_row("[green]Passed[/green]", str(result.summary.passed))
    table.add_row("[red]Failed[/red]", str(result.summary.failed))
    table.add_row("[yellow]Skipped[/yellow]", str(result.summary.skipped))
    table.add_row("[red]Errors[/red]", str(result.summary.errors))

    console.print(table)

    console.print("\n[green]Audit completed successfully.[/green]")


def _write_result(
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

    console.print(f"\n[dim]Result written to {output}[/dim]")
