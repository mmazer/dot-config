### dot-config

Simple dotfile setup with no install script or symlinks required.

To create:

    git init --bare $HOME
    git config status.showUntrackedFiles no

To clone into existing home directory:

    git clone --bare git@github.com:mmazer/dot-config.git ~/.git
    git config status.showUntrackedFiles no
    git config core.bare false
    git checkout --

#### Git

Git configuration follows the XDG spec and resides under `.config/git`,
howerver, to support older versions of Git, a `~.gitconfig` symlink to
`~/config/git/config` should be created.

Local or site specific Git configuration is located in `~/.local/share/git/config`

### References

<https://news.ycombinator.com/item?id=11070797>
