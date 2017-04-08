# -*- coding: utf-8 -*-

from ranger.api.commands import *
from ranger.core.loader import CommandLoader
import os


def trim(string, length=200):
    if len(string) > length:
        return string[:200] + "…"
    return string


class tar(Command):
    """:tar OPTIONS"""

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
    """:unar OPTIONS"""

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
    def execute(self):
        if not "TMUX" in os.environ:
            return self.fm.notify("Not in tmux", bad=True)
        self.fm.execute_console("shell " + self.line)
