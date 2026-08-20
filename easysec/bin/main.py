from __future__ import annotations

from pathlib import Path
from typing import Annotated

import typer
from rich.console import Console

from easysec import __version__
from easysec.bin.audit import run_audit
from easysec.core.context import EasySecContext
from easysec.core.exceptions import EasySecError, RepositoryError

app = typer.Typer(
    name="easysec",
    help="EasySec — open source security automation",
    no_args_is_help=True,
)

console = Console()


@app.callback()
def main(
    ctx: typer.Context,
    root: Annotated[
        Path | None,
        typer.Option(
            "--root",
            help="EasySec repository root.",
            exists=True,
            file_okay=False,
            dir_okay=True,
            path_type=Path,
        ),
    ] = None,
) -> None:
    """EasySec security automation CLI."""

    if ctx.invoked_subcommand is None:
        return

    try:
        context = (
            EasySecContext.from_root(root) if root else (EasySecContext.discover())
        )

        ctx.obj = context

    except RepositoryError as exc:
        console.print(f"[red]Error:[/red] {exc}")
        raise typer.Exit(code=2) from exc


@app.command()
def version() -> None:
    """Show EasySec version."""

    console.print(f"EasySec {__version__}")


@app.command()
def audit(
    ctx: typer.Context,
    inventory: Annotated[
        Path | None,
        typer.Option(
            "--inventory",
            "-i",
            help="Ansible inventory path.",
            path_type=Path,
        ),
    ] = None,
    limit: Annotated[
        str | None,
        typer.Option(
            "--limit",
            "-l",
            help="Limit audit to an Ansible host/group.",
        ),
    ] = None,
    check: Annotated[
        bool,
        typer.Option(
            "--check",
            help="Run Ansible in check mode.",
        ),
    ] = False,
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
            help="Output format: console or json.",
        ),
    ] = "console",
) -> None:
    """Run a security audit."""

    context: EasySecContext = ctx.obj

    if output_format not in {"console", "json"}:
        console.print("[red]Error:[/red] format must be 'console' or 'json'.")
        raise typer.Exit(code=2)

    try:
        exit_code = run_audit(
            context,
            inventory=inventory,
            limit=limit,
            check=check,
            output=output,
            output_format=output_format,
        )

    except EasySecError as exc:
        console.print(f"[red]Error:[/red] {exc}")
        raise typer.Exit(code=2) from exc

    raise typer.Exit(code=exit_code)
