import typer
from cli import __version__


def version(ctx: typer.Context) -> None:
    """
    Display EasySec version
    """

    console = ctx.obj.console
    console.print(f"EasySec {__version__}")
