;; (set w ((NSWindow alloc) initWithContentRect: '(8 8 300 200)
;;                                    styleMask: (| NSTitledWindowMask NSClosableWindowMask NSMiniaturizableWindowMask NSResizableWindowMask)
;;                                      backing: NSBackingStoreBuffered
;;                                        defer: 0))

;; (w center)
;; (w makeKeyAndOrderFront: nil)

;; (set tf ((NSTextField alloc) initWithFrame: '(0 100 300 100)))

;; (class SDButtonHandler is NSObject
;;     (imethod (void) buttonClicked: (id) sender is

;;         (tf setStringValue: ((Nu sharedParser) parseEval: (tf stringValue)))
;;         ))

;; (set t ((SDButtonHandler alloc) init))

;; (set b ((NSButton alloc) initWithFrame: '(0 0 300 100)))
;; (b set: (title: "Run Script" target: t action: "buttonClicked:"))

;; ((w contentView) addSubview: tf)
;; ((w contentView) addSubview: b)


(let ((w ((NSWindow alloc) initWithContentRect: '(8 8 300 200)
                                     styleMask: (| NSTitledWindowMask NSClosableWindowMask NSMiniaturizableWindowMask NSResizableWindowMask)
                                       backing: NSBackingStoreBuffered
                                         defer: 0)))
    )









(set w ((NSWindow alloc) initWithContentRect: '(8 8 300 200)
                                   styleMask: (| NSTitledWindowMask NSClosableWindowMask NSMiniaturizableWindowMask NSResizableWindowMask)
                                     backing: NSBackingStoreBuffered
                                       defer: 0))

(w center)
(w makeKeyAndOrderFront: nil)

(load "Webkit")

(set web ((WebView alloc) initWithFrame: '(0 0 300 200)))
(web setAutoresizingMask: (| NSViewWidthSizable NSViewHeightSizable))

;; (class SDButtonHandler is NSObject
;;     (imethod (void) buttonClicked: (id) sender is

;;         (tf setStringValue: ((Nu sharedParser) parseEval: (tf stringValue)))
;;         ))

;; (set t ((SDButtonHandler alloc) init))

;; (set b ((NSButton alloc) initWithFrame: '(0 0 300 100)))
;; (b set: (title: "Run Script" target: t action: "buttonClicked:"))

((w contentView) addSubview: web)
(web setMainFrameURL: "http://google.com")
