import typer
from cli import __version__


def show_help(ctx: typer.Context) -> None:
    """
    Display EasySec version
    """

    typer.echo(ctx.parent.get_help())
