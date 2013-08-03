(ns zephyros.api
  (:require [zephyros.protocol :refer :all]))

(defn keywordize [m]
  (into {} (for [[k v] m]
             [(keyword k) v])))


;; top level

(defn get-focused-window [] (get-one-value 0 "focused_window"))
(defn bind [key mods f] (do-callback-indefinitely (fn [_] (f)) 0 "bind" key mods))
(defn listen [event f] (do-callback-indefinitely #(f %) 0 "listen" event))

(defn get-all-screens [] (get-one-value 0 "all_screens"))
(defn get-running-apps [] (get-one-value 0 "running_apps"))
(defn get-visible-windows [] (get-one-value 0 "visible_windows"))
(defn get-all-windows [] (get-one-value 0 "all_windows"))
(defn get-main-screen [] (get-one-value 0 "main_screen"))

(defn alert [msg duration] (get-one-value 0 "alert" msg duration))
(defn log [msg] (get-one-value 0 "log" msg))
(defn choose-from [list title f] (do-callback-once f 0 "choose_from" list title 20 10))

(defn relaunch-config [] (get-one-value 0 "relaunch_config"))
(defn get-clipboard-contents [] (get-one-value 0 "clipboard_contents"))


;; window

(defn get-window-title [w] (get-one-value w "title"))

(defn get-frame [w] (keywordize (get-one-value w "frame")))
(defn get-size [w] (keywordize (get-one-value w "size")))
(defn get-top-left [w] (keywordize (get-one-value w "top_left")))

(defn set-frame [w f] (get-one-value w "set_frame" f))
(defn set-size [w s] (get-one-value w "set_size" s))
(defn set-top-left [w tl] (get-one-value w "set_top_left" tl))

(defn minimize [w] (get-one-value w "minimize"))
(defn maximize [w] (get-one-value w "maximize"))
(defn un-minimize [w] (get-one-value w "un_minimize"))

(defn get-app-for-window [w] (get-one-value w "app"))
(defn get-screen-for-window [w] (get-one-value w "screen"))

(defn focus-window [w] (get-one-value w "focus_window"))
(defn focus-window-left [w] (get-one-value w "focus_window_left"))
(defn focus-window-right [w] (get-one-value w "focus_window_right"))
(defn focus-window-up [w] (get-one-value w "focus_window_up"))
(defn focus-window-down [w] (get-one-value w "focus_window_down"))

(defn normal-window? [w] (get-one-value w "normal_window?"))
(defn minimized? [w] (get-one-value w "minimized?"))


;; app

(defn visible-windows-for-app [w] (get-one-value w "visible_windows"))
(defn all-windows-for-app [w] (get-one-value w "all_windows"))

(defn get-app-title [w] (get-one-value w "title"))
(defn app-hidden? [w] (get-one-value w "hidden?"))

(defn show-app [w] (get-one-value w "show"))
(defn hide-app [w] (get-one-value w "hide"))

(defn kill-app [w] (get-one-value w "kill"))
(defn kill9-app [w] (get-one-value w "kill9"))


;; screen

(defn screen-frame-including-dock-and-menu [w] (keywordize (get-one-value w "frame_including_dock_and_menu")))
(defn screen-frame-without-dock-or-menu [w] (keywordize (get-one-value w "frame_without_dock_or_menu")))

(defn next-screen [w] (get-one-value w "next_screen"))
(defn previous-screen [w] (get-one-value w "previous_screen"))
