(ns zephyros.api
  (:require [zephyros.protocol :refer :all]))

(defn keywordize [m]
  (into {} (for [[k v] m]
             [(keyword k) v])))


;; top level

(def api 0)

(defn alert [msg duration]
  (get-one-value api "alert" msg duration))

(defn get-focused-window []
  (get-one-value api "focused_window"))

(defn choose-from [list title f]
  (do-callback-once f api "choose_from" list title 20 10))

(defn bind [key mods f]
  (do-callback-indefinitely (fn [_] (f)) api "bind" key mods))

(defn listen [event f]
  (do-callback-indefinitely #(f %) api "listen" event))


;; window

(defn get-title [w]
  (get-one-value w "title"))

(defn get-frame [w]
  (keywordize (get-one-value w "frame")))

(defn get-size [w]
  (keywordize (get-one-value w "size")))

(defn get-top-left [w]
  (keywordize (get-one-value w "top_left")))

(defn set-frame [w f]
  (keywordize (get-one-value w "set_frame" f)))

(defn set-size [w s]
  (keywordize (get-one-value w "set_size" s)))

(defn set-top-left [w tl]
  (keywordize (get-one-value w "set_top_left" tl)))
