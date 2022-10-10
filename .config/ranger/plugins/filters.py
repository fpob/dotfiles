import re

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
        self.fm.signal_bind('loader.before', self.refresh)
        self.refresh()

    def refresh(self):
        self.selection = set(self.fm.thistab.get_selection())

    def __call__(self, fobj):
        return fobj in self.selection

    def __str__(self):
        return '<Filter: selected>'


old_hook_init = ranger.api.hook_init


def init(fm):
    fm.execute_console('map .t<any> filter_stack add tag %any')
    fm.execute_console('map .T filter_stack add tag')
    fm.execute_console('map .s filter_stack add selected')
    return old_hook_init(fm)


ranger.api.hook_init = init
