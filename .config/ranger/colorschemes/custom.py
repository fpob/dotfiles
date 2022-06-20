from ranger.colorschemes.default import Default
from ranger.gui.color import (
    black, blue, cyan, green, magenta, red, white, yellow, default,
    normal, bold, reverse, dim, BRIGHT,
    default_colors,
)


class Scheme(Default):
    def use(self, context):
        fg, bg, attr = Default.use(self, context)

        if context.in_titlebar and context.tab and context.good:
            bg = white
            fg = black

        return fg, bg, attr
