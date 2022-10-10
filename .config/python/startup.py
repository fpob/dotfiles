from os import environ as env
from pathlib import Path

try:
    import sh
except ImportError:
    pass


def _setup_python():
    import atexit
    import logging
    import pprint
    import readline
    import sys

    state_dir = Path(env['XDG_STATE_HOME']) / 'python'
    state_dir.mkdir(exist_ok=True)

    # Change history file path.

    history_file = state_dir / 'history'

    def read_history():
        if history_file.exists():
            try:
                readline.read_history_file(history_file)
            except Exception:
                logging.exception(f'Failed to read history file {history_file}')

    def write_history():
        try:
            readline.write_history_file(history_file)
        except Exception:
            logging.exception(f'Failed to write history file {history_file}')

    read_history()
    atexit.register(write_history)

    # Pretty print by default.

    def displayhook(value):
        if value is not None:
            __builtins__._ = value
            pprint.pprint(value)

    sys.displayhook = displayhook

    # Prompt.

    sys.ps1 = '\x1b[32m>>>\x1b[0m '
    sys.ps2 = '\x1b[32m...\x1b[0m '


def _setup_ipython():
    import logging

    state_dir = Path(env['XDG_STATE_HOME']) / 'ipython'
    state_dir.mkdir(exist_ok=True)

    ipy = get_ipython()

    # Disable exit confirmation.
    ipy.confirm_exit = False

    # Change debugger history file path.
    ipy.debugger_history_file = str(state_dir / 'pdbhistory')

    # Change synxtax color scheme.
    ipy.highlighting_style = 'one-dark'

    # Disable tab-completion messages in ipython/ipdb.
    logging.getLogger('parso').setLevel(logging.ERROR)


if 'get_ipython' in globals():
    _setup_ipython()
else:
    _setup_python()
