from ranger.core.filter_stack import stack_filter, BaseFilter


@stack_filter("tag")
class TagFilter(BaseFilter):
    def __init__(self, tag):
        self.tag = tag

    def __call__(self, fobj):
        return (fobj.realpath in fobj.fm.tags
                and fobj.fm.tags.marker(fobj.realpath) == self.tag)

    def __str__(self):
        return "<Filter: tag == {}>".format(self.tag)


@stack_filter("tagged")
class TaggedFilter(BaseFilter):
    def __init__(self, _):
        pass

    def __call__(self, fobj):
        return fobj.realpath in fobj.fm.tags

    def __str__(self):
        return "<Filter: tagged>"
