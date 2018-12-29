from ranger.core.filter_stack import stack_filter, BaseFilter
from ranger.container.tags import Tags


@stack_filter("tag")
class TagFilter(BaseFilter):
    def __init__(self, tag=None):
        self.tag = tag or Tags.default_tag

    def __call__(self, fobj):
        return (fobj.realpath in fobj.fm.tags
                and fobj.fm.tags.marker(fobj.realpath) == self.tag)

    def __str__(self):
        return "<Filter: tag == {}>".format(self.tag)
