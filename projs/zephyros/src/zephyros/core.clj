(ns zephyros.core
  (:require [zephyros.api :refer :all]))

(defn -main []

  (bind "d" ["cmd" "shift"]
        (fn []
          (let [win (get-focused-window)
                frame (-> (get-frame win)
                          (update-in [:w] - 20))
                _ (set-frame win frame)]

            ;; (alert frame 1)
            )))

  (println "ready"))
