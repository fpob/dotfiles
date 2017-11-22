# -*- coding: utf-8 -*-

from ranger.api.commands import *
from ranger.core.loader import CommandLoader
import os
import shlex
import re


def trim(string, length=200):
    if len(string) > length:
        return string[:length] + "…"
    return string


class tar(Command):
    def execute(self):
        cwd = self.fm.thisdir
        original_path = cwd.path

        flags = self.arg(1)
        if not flags:
            return

        files = [os.path.relpath(f.path, cwd.path)
                 for f in self.fm.thistab.get_selection()]
        if not files:
            return
        if self.arg(2):
            files.insert(0, self.arg(2))

        def refresh(_):
            cwd = self.fm.get_directory(original_path)
            cwd.load_content()

        obj = CommandLoader(args=["tar", flags] + files,
                            descr=trim("{} {}".format(self.line, " ".join(files))))
        obj.signal_bind("after", refresh)
        self.fm.loader.add(obj)


class unar(Command):
    """
    :unar OPTIONS

    Extract selected archives.
    """

    def execute(self):
        original_path = self.fm.thisdir.path

        def refresh(_):
            cwd = self.fm.get_directory(original_path)
            cwd.load_content()

        for file in self.fm.thistab.get_selection():
            obj = CommandLoader(args=self.line.split() + ["-q", file.path],
                                descr=trim("{} {}".format(self.line, file.path)))
            obj.signal_bind("after", refresh)
            self.fm.loader.add(obj)


class tmux(Command):
    escape_macros_for_shell = True

    def execute(self):
        if not "TMUX" in os.environ:
            return self.fm.notify("Not in tmux", bad=True)
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

    TRASH_CMD = "trash"      # trash-cli
    #TRASH_CMD = "gvfs-trash" # gvfs-bin

    allow_abbrev = False
    escape_macros_for_shell = True

    def execute(self):
        if self.rest(1):
            files = shlex.split(self.rest(1))
        else:
            files = [file.path for file in self.fm.thistab.get_selection()]
        if files:
            obj = CommandLoader(args=[self.TRASH_CMD, "--"] + files, descr="Trash")
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
    LINK_CRE = re.compile('^\s*https?://.+/.*\s*$', re.I)

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
                links = [line.strip() for line in f
                         if self.LINK_CRE.match(line)]
        return links

    def _get_links(self):
        return dict(zip(self.HINT_KEYS,
                        self._parse_links_file(self._find_links_file())))

    def _draw_list(self):
        links = self._get_links()
        self.fm.ui.browser.draw_info = [" | ".join(i) for i in links.items()]

    def execute(self):
        links = self._get_links()
        if self.arg(1):
            self.fm.execute_command("$BROWSER '%s'" % links[self.arg(1)])
        elif len(links) == 1:
            self.fm.execute_command("$BROWSER '%s'" % links['a'])
        else:
            self._draw_list()
            self.fm.open_console('links ')

    def quick(self):
        if self.arg(0) == 'links' and not self.arg(1):
            self._draw_list()
        if self.arg(1):
            return True
