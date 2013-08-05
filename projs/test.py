import sys
sys.path.insert(0, '/Users/sdegutis/projects/zephyros/libs')
import zephyros

@zephyros.zephyros
def myscript():
    def bindFn():
        win = zephyros.api.focused_window()
        f = win.frame()
        f['x'] += 3
        win.set_frame(f)

    # def bindFn2():
    #   zephyros.api.choose_from(['foo', 'basdfar'], 'title here', 20, 20, fn=chooseFn)

    # def chooseFn(obj):
    #   print 'ok fine', obj

    # zephyros.api.bind('f', ['cmd', 'shift'], bindFn2)
    zephyros.api.bind('d', ['cmd', 'shift'], bindFn)
