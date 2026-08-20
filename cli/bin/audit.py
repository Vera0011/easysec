from __future__ import annotations

from pathlib import Path

from rich.console import Console
from rich.panel import Panel

from cli.ansible.runner import AnsibleRunner
from cli.core.context import Context
from cli.core.models.audit.AnsibleResult import AnsibleResult
from cli.core.models.audit.AuditResult import AuditResult
from cli.output.io import _render_success, _write_result

# Console context - Used for output
console = Console()


def run_audit(
    context: Context, *, inventory: Path, output: Path, check: bool = False
) -> int:
    """
    Executes an auditory

    Parameters
    ----------
    context: Context
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

    console.print()
    console.print(
        Panel.fit(
            "[bold cyan]Security Audit[/bold cyan]\n"
            f"Repository: {context.root}\n"
            f"Inventory:  {inventory_value}\n",
            border_style="cyan",
        )
    )

    if not context.audit_playbook.is_file():
        console.print(f"[red]Audit playbook not found:[/red] {context.audit_playbook}")
        return 2

    runner: AnsibleRunner = AnsibleRunner(context.root)

    console.print("[bold]Running audit...[/bold]\n")

    ansible_result: AnsibleResult = runner.run(
        context.audit_playbook,
        inventory=inventory_value,
        check=check,
    )

    console.print(ansible_result.stdout)

    if ansible_result.stderr:
        console.print(f"[yellow]{ansible_result.stderr}[/yellow]")

    result.success = ansible_result.success

    if ansible_result.success:
        result.finished_at = result.started_at
        _render_success(console, result)
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
        _write_result(console, result, output, "console")

    return 0 if ansible_result.success else ansible_result.returncode
