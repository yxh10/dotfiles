import sys
sys.path.insert(0, '/Users/sdegutis/projects/zephyros/libs')
import zephyros

@zephyros.zephyros
def myscript():
    def bind_fn():
        win = zephyros.api.focused_window()
        f = win.frame()
        f.x += 3
        win.set_frame(f)

    zephyros.api.bind('d', ['cmd', 'shift'], bind_fn)
