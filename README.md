### dot-config

Simple dotfile setup with no install script or symlinks required.

To checkout:

 1. `alias cfg='git --git-dir=$HOME/.cfg --work-tree=$HOME'`
 2. `git clone --bare git@github.com:mmazer/dot-config.git $HOME/.cfg`
 3. `cfg checkout`
 4. `cfg config --local status.showUntrackedFiles no`

If on initial checkout, Git reports an error related to overwriting files, you
can backup the existing files:

    mkdir -p .cfg-backup && \
      cfg checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
      xargs -I{} mv {} .cfg-backup/{}

#### Bash

Local or site specific settings are placed in `~/.local/share/etc/bashrc`

To run `ssh-agent`, add the following to the local settings:

```
# only run if in interactive shell
[[ $- == *i* ]] && source ~/.config/bash/ssh-agent
```

#### Git

Newer versiions of Git support the XDG spec and configuration can be placed
under `.config/git`, however, to support older versions of Git, a `~.gitconfig`
symlink to `~/config/git/config` should be created.

Local or site specific Git configuration is located in
`~/.local/share/git/config`

#### Neovim

Local nvim setings are under `~/.local/share/nvim/site/plugin`.

### References

<https://news.ycombinator.com/item?id=11070797>

<https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/>
