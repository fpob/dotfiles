# -*- coding: utf-8 -*-

import ranger.api
from ranger.core.linemode import LinemodeBase
from ranger.api.commands import Command
from ranger.core.loader import CommandLoader

import os


def aid_read(directory):
    path = os.path.join(directory, '.aid')
    if os.path.isfile(path):
        with open(path, 'r') as f:
            return int(f.readline().strip())
    return None


@ranger.api.register_linemode
class MyLinemode(LinemodeBase):
    name = "anidb"

    def filetitle(self, fobj, metadata):
        return fobj.relative_path

    def infostring(self, fobj, metadata):
        aid = aid_read(fobj.path)
        if aid:
            return "https://anidb.net/a{}".format(aid)
        raise NotImplementedError


class anidb_open(Command):
    def anidb_open_aid(self, aid):
        self.fm.execute_command("xdg-open 'https://anidb.net/a{}'".format(aid))

    def execute(self):
        if self.arg(1):
            self.anidb_open_aid(self.arg(1))
        else:
            for sel in [self.fm.thisdir] + self.fm.thistab.get_selection():
                aid = aid_read(sel.path)
                if aid:
                    self.anidb_open_aid(aid)

