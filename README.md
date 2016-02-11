### dot-config

Simple dotfile setup with no install script or symlinks required.

To create:

    git init --bare $HOME/.cfg
    alias cfg='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
    cfg config status.showUntrackedFiles no

To clone:

    git clone --separate-git-dir=~/.cfg <path> ~

### References

<https://news.ycombinator.com/item?id=11070797>
