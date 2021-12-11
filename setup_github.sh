#!/bin/bash

# https://stackoverflow.com/questions/52340114/check-ssh-with-github-com-before-running-a-script
function github-authenticated() {
  ssh -T -i "$1" git@github.com > /dev/null 2>&1
  RET=$?
  if [ "$RET" == 1 ]; then
    # user is authenticated, but fails to open a shell with GitHub 
    return 0
  elif [ "$RET" == 255 ]; then
    echo "Permission denied: check if a ssh public key is registered to github."
    return 1
  else
    echo "unknown exit code in attempt to ssh into git@github.com"
    return 1
  fi
}

SSH_KEYFILE="$HOME/git"
if ! github-authenticated $SSH_KEYFILE; then
    exit
fi

rm -rf $HOME/.ssh
git -c core.sshCommand="ssh -i ${SSH_KEYFILE} -F /dev/null" clone git@github.com:yukke42/dotssh.git ~/.ssh
cp "${SSH_KEYFILE}" $HOME/.ssh/conf.d/git
cp "${SSH_KEYFILE}.pub" $HOME/.ssh/pub_keys

ssh -T git@github.com
