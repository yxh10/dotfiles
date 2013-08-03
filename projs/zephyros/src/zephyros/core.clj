(ns zephyros.core
  (:require [zephyros.api :refer :all]))

(defn -main []

  (bind "d" ["cmd" "shift"]
        (fn []
          (let [win (get-focused-window)
                _ (prn win)
                title (get-title win)
                _ (prn title)]

            (alert title 1))))

  (println "ready"))
