xrdb -merge .Xresources
xset r rate 200 30

# TODO: keys for copy/paste

~/.dropbox-dist/dropboxd &

emacs --daemon

exec awesome
