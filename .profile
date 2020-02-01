if [ -f ~/.local/share/etc/i3 ]; then
    cat ~/.local/share/etc/i3 >  ~/.i3/config
else
    cat /dev/null > ~/.i3/config
fi

cat ~/.i3/config.in >> ~/.i3/config

