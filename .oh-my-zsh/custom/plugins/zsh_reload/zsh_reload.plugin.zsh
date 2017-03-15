# reload zshrc
function zsh_reload ()
{
  autoload -U compinit zrecompile
  compinit -d "$ZSH_CACHE_DIR/zcomp-$HOST"

  for f in ~/.zshrc "$ZSH_CACHE_DIR/zcomp-$HOST"; do
    zrecompile -p $f && command rm -f $f.zwc.old
  done

  source ~/.zshrc
}
