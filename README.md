### dot-config

Simple dotfile setup with no install script or symlinks required.

To create:

    git init --bare $HOME
    git config status.showUntrackedFiles no

To clone into existing home directory:

    git clone --bare git@github.com:mmazer/dot-config.git ~/.git
    git config status.showUntrackedFiles no
    git config core.bare false
    git checkout -- .

### References

<https://news.ycombinator.com/item?id=11070797>
