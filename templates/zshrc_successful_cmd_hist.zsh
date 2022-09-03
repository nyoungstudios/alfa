# credits: https://scarff.id.au/blog/2019/zsh-history-conditional-on-command-success/
function zshaddhistory() {
  # Remove line continuations since otherwise a "\" will eventually
  # get written to history with no newline.
  LASTHIST=${1//\\$'\n'/}
  # Return value 2: "... the history line will be saved on the internal
  # history list, but not written to the history file".
  return 2
}

# zsh hook called before the prompt is printed. See man zshmisc(1).
function precmd() {
  # Write the last command if successful and if the last command is not whitespace characters,
  # using the history buffered by zshaddhistory().
  if [[ $? == 0 && -n ${LASTHIST//[[:space:]\n]/} && -n $HISTFILE ]] ; then
    print -sr -- ${=${LASTHIST%%'\n'}}
  fi
}
