xrdb -merge .Xresources
xset r rate 200 30

xset +fp /usr/share/fonts/local
xset fp rehash

# TODO: keys for copy/paste

[ ! -s ~/.config/mpd/pid ] && mpd

unclutter &

~/.dropbox-dist/dropboxd &

emacs --daemon

exec awesome
