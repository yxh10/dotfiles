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
