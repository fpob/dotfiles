import os

import yaml

from ranger.api import register_linemode
from ranger.core.linemode import LinemodeBase
from ranger.api.commands import Command


def _metadata_read(directory):
    path = os.path.join(directory, '.anime.yml')
    if os.path.isfile(path):
        with open(path, 'r') as f:
            # Load all documents but return only first.
            return next(yaml.load_all(f, Loader=yaml.SafeLoader))
    return None


@register_linemode
class AnimeLinemode(LinemodeBase):
    name = 'anime'

    def filetitle(self, fobj, metadata):
        meta = _metadata_read(fobj.path)
        if meta and 'title' in meta:
            return meta['title']
        return fobj.relative_path

    def infostring(self, fobj, metadata):
        raise NotImplementedError


class anidb_open(Command):
    def _open(self, aid):
        self.fm.execute_command(f'xdg-open "https://anidb.net/a{aid}"')

    def execute(self):
        if self.arg(1):
            self._open(self.arg(1))
        else:
            selected_dirs = [f.path for f in self.fm.thistab.get_selection()
                             if os.path.isdir(f.path)]
            if not selected_dirs:
                selected_dirs = [self.fm.thisdir.path]
            for f in selected_dirs:
                meta = _metadata_read(f)
                if meta:
                    self._open(meta['aid'])
