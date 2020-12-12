import re

import xattr

import ranger.api
from ranger.core.filter_stack import stack_filter, BaseFilter, FileManagerAware


@stack_filter('tag')
class TagFilter(BaseFilter, FileManagerAware):
    def __init__(self, tag):
        self.tag = tag

    def __call__(self, fobj):
        if fobj.realpath in fobj.fm.tags:
            return not self.tag or self.fm.tags.marker(fobj.realpath) == self.tag
        return False

    def __str__(self):
        return f'<Filter: tag == {self.tag or "any"}>'


@stack_filter('selected')
class SelectedFilter(BaseFilter, FileManagerAware):
    def __init__(self, _):
        self.selection = set(self.fm.thistab.get_selection())

    def __call__(self, fobj):
        return fobj in self.selection

    def __str__(self):
        return '<Filter: selected>'


@stack_filter('xattr')
class DmetaFilter(BaseFilter):
    def __init__(self, name_pattern):
        self.name, self.pattern = name_pattern.split(maxsplit=1)
        self.regex = re.compile(self.pattern)

    def __call__(self, fobj):
        try:
            value = xattr.getxattr(fobj.path, self.name).decode()
            return self.regex.search(value)
        except OSError as e:
            if e.errno == 61:   # No data available (xattr key not set).
                return False
            raise
        except UnicodeError:
            return False

    def __str__(self):
        return f'<Filter: xattr {self.name} =~ /{self.pattern}/>'


old_hook_init = ranger.api.hook_init


def init(fm):
    fm.execute_console('map .t<any> filter_stack add tag %any')
    fm.execute_console('map .T filter_stack add tag')
    fm.execute_console('map .s filter_stack add selected')
    fm.execute_console('map .x console filter_stack add xattr%space')
    return old_hook_init(fm)


ranger.api.hook_init = init
