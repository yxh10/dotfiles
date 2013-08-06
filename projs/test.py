import sys
sys.path.insert(0, '/Users/sdegutis/projects/zephyros/libs')
import zephyros

@zephyros.zephyros
def myscript():
    def bindFn():
        zephyros.api.alert('foo BAR')
        win = zephyros.api.focused_window()
        f = win.frame()
        print f.x
        f.x += 3
        print f.x
        win.set_frame(f)

    def bindFn2():
      zephyros.api.choose_from(['foo', 'basdfar'], 'title here', 20, 20, fn=chooseFn)

    def foo(app):
      print 'ok fine', app

    def chooseFn(obj):
      print 'ok fine', obj


    zephyros.api.listen('app_launched', foo)

    zephyros.api.bind('f', ['cmd', 'shift'], bindFn2)
    zephyros.api.bind('d', ['cmd', 'shift'], bindFn)
