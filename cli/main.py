from __future__ import annotations
import typer

from pathlib import Path
from typing import Annotated

from cli.bin.audit import audit
from cli.bin.version import version
from cli.core.context import Context
from cli.core.exceptions import EasySecError

app = typer.Typer(
    name="easysec",
    help="EasySec — Open source security automation",
    no_args_is_help=True,
    add_completion=False,
    rich_markup_mode="rich",
    epilog="Run 'easysec COMMAND --help' for details on a specific command",
    context_settings={"help_option_names": ["-h", "--help"]},
)


@app.callback()
def main(ctx: typer.Context) -> None:
    """
    This function sets up the context and starts the app
    """

    context: Context = Context.discover()
    ctx.obj = context

app.command(name="version")(version)
app.command(name="audit")(audit)