syn match yamlBlock "[>|]\d\?[+-]"
syn region yamlString matchgroup=yamlBlock start=/[>|]\s*\n\+\z(\s\+\)\S/rs=s+1 skip=/^\%(\z1\S\|^$\)/ end=/^\z1\@!.*/me=s-1
syn region yamlString matchgroup=yamlBlock start=/[>|]\(\d\|[+-]\)\s*\n\+\z(\s\+\)\S/rs=s+2 skip=/^\%(\z1\S\|^$\)/ end=/^\z1\@!.*/me=s-1
syn region yamlString matchgroup=yamlBlock start=/[>|]\d\(\d\|[+-]\)\s*\n\+\z(\s\+\)\S/rs=s+3 skip=/^\%(\z1\S\|^$\)/ end=/^\z1\@!.*/me=s-1

hi link yamlBlock Operator
hi link yamlString String
