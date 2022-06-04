syn match pythonInclude "\(from\)\@<= \.\+"
syn match pythonExtraOperator ":="
syn match pythonPatternMatching "\(^\s*\)\@<=\%(match\|case\)\(\s\+\(\([\[{]\|\w*(\).*\|.*[:\\]\)$\)\@="

hi def link  pythonPatternMatching  Conditional
