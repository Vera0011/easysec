from __future__ import annotations
import typer

from pathlib import Path
from typing import Annotated
from rich.panel import Panel

from cli.ansible.runner import AnsibleRunner
from cli.core.context import Context
from cli.core.models.audit.AnsibleResult import AnsibleResult
from cli.core.models.audit.AuditResult import AuditResult
from cli.output.io import _render_success, _write_result
from cli.core.exceptions import EasySecError


def audit(
    ctx: typer.Context,
    inventory: Annotated[
        Path,
        typer.Option(
            "--inventory",
            "-i",
            help="Ansible inventory path.",
            path_type=Path,
        ),
    ],
    check: Annotated[
        bool,
        typer.Option(
            "--check",
            "-c",
            help="Run Ansible in check mode. This means that the playbook will be executed but will not perform changes.",
        ),
    ] = True,
    diff: Annotated[
        bool,
        typer.Option(
            "--diff",
            "-d",
            help="Run Ansible in diff mode. This means that it will display changes on the system without executing it.",
        ),
    ] = True,
    output: Annotated[
        Path | None,
        typer.Option(
            "--output",
            "-o",
            help="Write audit results to a file.",
            path_type=Path,
        ),
    ] = None,
    output_format: Annotated[
        str,
        typer.Option(
            "--format",
            "-f",
            help="Output format: console or json.",
        ),
    ] = "console",
) -> None:
    """Run a security audit."""

    ctx: Context = ctx.obj

    if output_format not in {"console", "json"}:
        ctx.obj.console.print("[red]Error:[/red] format must be 'console' or 'json'.")
        raise typer.Exit(code=2)

    try:
        exit_code: int = run_audit(
            ctx,
            inventory=inventory,
            check=check,
            output=output,
        )

    except EasySecError as exc:
        ctx.obj.console.print(f"[red]Error:[/red] {exc}")
        raise typer.Exit(code=2) from exc

    raise typer.Exit(code=exit_code)


def run_audit(
    ctx: Context, *, inventory: Path, output: Path, check: bool = False
) -> int:
    """
    Executes an auditory

    Parameters
    ----------
    ctx: Context
        Context of the application
    inventory: Path
        The selected inventory
    output: Path
        Where the output should be displayed
    check: bool
        The parameter 'check' for the Ansible runner. Default to 'False'

    Returns
    -------
    int
        The result as int (0, 1, 2) depending Ansible result
    """

    inventory_value: str = str(inventory)
    result: AuditResult = AuditResult.create(inventory_value)

    ctx.console.print()
    ctx.console.print(
        Panel.fit(
            "[bold cyan]Security Audit[/bold cyan]\n"
            f"Repository: {ctx.root}\n"
            f"Inventory:  {inventory_value}\n",
            border_style="cyan",
        )
    )

    if not ctx.audit_playbook.is_file():
        ctx.console.print(f"[red]Audit playbook not found:[/red] {ctx.audit_playbook}")
        return 2

    runner: AnsibleRunner = AnsibleRunner(ctx.root)

    ctx.console.print("[bold]Running audit...[/bold]\n")

    ansible_result: AnsibleResult = runner.run(
        ctx.audit_playbook,
        inventory=inventory_value,
        check=check,
    )

    ctx.console.print(ansible_result.stdout)

    if ansible_result.stderr:
        ctx.console.print(f"[yellow]{ansible_result.stderr}[/yellow]")

    result.success = ansible_result.success

    if ansible_result.success:
        result.finished_at = result.started_at
        _render_success(ctx, result)
    else:
        ctx.console.print(
            Panel(
                f"Ansible exited with code {ansible_result.returncode}",
                title="Audit failed",
                border_style="red",
            )
        )

        result.finished_at = result.started_at

    if output:
        _write_result(ctx, result, output, "console")

    return 0 if ansible_result.success else ansible_result.returncode
