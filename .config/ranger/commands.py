import os
import re
import itertools
import webbrowser

from ranger.api.commands import Command
from ranger.core.loader import CommandLoader


def _trim_long(string, length=200):
    if len(string) > length:
        return string[:length] + "…"
    return string


def _find_command(commands):
    for c in commands:
        if os.system(f'which {c} >/dev/null 2>&1') == 0:
            return c
    return None


class unar(Command):
    """
    :unar OPTIONS

    Extract selected archives.
    """

    def execute(self):
        command = ['unar', '-q', '-o', self.fm.thisdir.path] + self.args[1:] + ['--']
        for file in self.fm.thistab.get_selection():
            obj = CommandLoader(args=command + [file.path],
                                descr=_trim_long('unar ' + file.path))
            obj.signal_bind('after', lambda _: self.fm.thisdir.load_content())
            self.fm.loader.add(obj)


class tmux(Command):
    escape_macros_for_shell = True

    def execute(self):
        if 'TMUX' not in os.environ:
            return self.fm.notify('Not in tmux', bad=True)
        self.fm.execute_command(self.line)


class take(Command):
    """
    :take DIR_NAME

    mkdir & cd
    """

    def execute(self):
        self.fm.execute_console("mkdir " + self.rest(1))
        self.fm.execute_console("cd " + self.rest(1))


class trash(Command):
    """
    :trash

    Move selection or files passed in arguments to trash.
    """

    THRASH_CMD = _find_command(['trash', 'gvfs-trash'])

    allow_abbrev = False
    escape_macros_for_shell = True

    def execute(self):
        files = [file.path for file in self.fm.thistab.get_selection()]
        if files:
            obj = CommandLoader(args=[self.THRASH_CMD, '--'] + files,
                                descr='Trash')
            obj.signal_bind('after', lambda _: self.fm.thisdir.load_content())
            self.fm.loader.add(obj)

    def tab(self, tabnum):
        return self._tab_directory_content()


class links(Command):
    """
    :links
    :links *

    Read links from links file (.links|_links|links|_links.txt|links.txt)
    and open it in browser.
    If there is only one link opens browser immediately, otherwise show
    hint popup with loaded links.
    """

    FILE_NAMES = ('.links', '_links', 'links', '_links.txt', 'links.txt')
    HINT_KEYS = tuple('asdfghjklqwertyuiopzxcvbnm')
    LINK_CRE = re.compile(r'^https?://.+/.*$', re.I)

    def _find_links_file(self):
        selection = iter(self.fm.thistab.get_selection())
        file_path = self._find_links_file_in(self.fm.thisdir.path)
        while not file_path:
            file = next(selection)
            if file.is_directory:
                file_path = self._find_links_file_in(file.path)
        return file_path

    def _find_links_file_in(self, directory):
        for file in self.FILE_NAMES:
            file_path = os.path.join(directory, file)
            if os.path.isfile(file_path):
                return file_path

    def _parse_links_file(self, file_path):
        links = list()
        if file_path:
            with open(file_path) as f:
                for line in f:
                    line = line.strip()
                    if line not in links and self.LINK_CRE.match(line):
                        links.append(line)
        return links

    def _get_hint_keys(self, length=1):
        if length == 1:
            return self.HINT_KEYS
        return [''.join(keys)
                for keys in itertools.product(self.HINT_KEYS, repeat=length)]

    def _get_links(self):
        links = self._parse_links_file(self._find_links_file())
        for i in itertools.count(start=1):
            hint_keys = self._get_hint_keys(i)
            if len(links) <= len(hint_keys):
                return dict(zip(hint_keys, links))

    def _draw_list(self):
        links = sorted(self._get_links().items(),
                       key=lambda i: tuple(self.HINT_KEYS.index(c) for c in i[0]))
        self.fm.ui.browser.draw_info = [' | '.join(i) for i in links]

    def execute(self):
        links = self._get_links()
        if self.arg(1) in links:
            webbrowser.open(links[self.arg(1)])
        elif len(links) == 1:
            webbrowser.open(links['a'])
        else:
            self._draw_list()
            self.fm.open_console('links ')

    def quick(self):
        if self.arg(0) == 'links' and not self.arg(1):
            self._draw_list()
        if self.arg(1) and self.arg(1) in self._get_links():
            return True
