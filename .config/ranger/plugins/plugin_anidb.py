# -*- coding: utf-8 -*-

import ranger.api
from ranger.core.linemode import LinemodeBase

import os


@ranger.api.register_linemode
class MyLinemode(LinemodeBase):
    name = "anidb"

    def filetitle(self, fobj, metadata):
        return fobj.relative_path

    def infostring(self, fobj, metadata):
        aid_file = os.path.join(fobj.path, ".aid")
        if os.path.isfile(aid_file):
            with open(aid_file, "r") as f:
                return "https://anidb.net/a" + str(f.read())
        raise NotImplementedError
