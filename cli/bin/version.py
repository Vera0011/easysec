from cli import __version__
from cli.main import console, app

@app.command()
def version(console: Console) -> None:
    """
    Display EasySec version
    """

    console.print(f"EasySec {__version__}")
