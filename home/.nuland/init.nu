(set w ((NSWindow alloc) initWithContentRect: '(1300 1300 500 500)
                                   styleMask: (| NSTitledWindowMask NSClosableWindowMask NSMiniaturizableWindowMask NSResizableWindowMask)
                                     backing: NSBackingStoreBuffered
                                       defer: 0))

(w makeKeyAndOrderFront: nil)

(set tf ((NSTextField alloc) initWithFrame: '(10 10 100 100)))

(class SDButtonHandler is NSObject
    (imethod (void) buttonClicked: (id) sender is

        (tf setStringValue: ((Nu sharedParser) parseEval: (tf stringValue)))
        ))

(set t ((SDButtonHandler alloc) init))

(set b ((NSButton alloc) initWithFrame: '(10 120 100 100)))
(b set: (title: "foobar" target: t action: "buttonClicked:"))

((w contentView) addSubview: tf)
((w contentView) addSubview: b)
