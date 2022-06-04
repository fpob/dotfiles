import readline
import atexit
import sys
import logging
from pathlib import Path
from os import environ as env

try:
    from rich import print as pp
    from rich import pretty
    pretty.install()
    del pretty
except ImportError:
    from pprint import pprint as pp

try:
    import sh
except ImportError:
    pass


HOME = Path(env['HOME'])


if 'get_ipython' in globals():
    ipy = get_ipython()
    # Disable exit confirmation
    ipy.confirm_exit = False

    # Disable tab-completion messages in ipython/ipdb
    logging.getLogger('parso').setLevel(logging.ERROR)

else:
    DATA_DIR = Path(env.get('XDG_DATA_HOME', HOME / '.local/share')) / 'python'
    DATA_DIR.mkdir(exist_ok=True)

    # Change history file path.

    HISTORY_FILE = DATA_DIR / 'history'

    def read_history():
        try:
            readline.read_history_file(HISTORY_FILE)
        except Exception:
            logging.exception(f'Failed to read history file {HISTORY_FILE}')

    def write_history():
        try:
            readline.write_history_file(HISTORY_FILE)
        except Exception:
            logging.exception(f'Failed to write history file {HISTORY_FILE}')

    read_history()
    atexit.register(write_history)


# vim:ft=python
