(ns zephyros.core
  (:require [zephyros.api :refer :all]))

(defn -main []

  (bind "d" ["cmd" "shift"]
        (fn []
          (let [win (get-focused-window)]
            (set-frame win
                       (-> (get-frame win)
                           (update-in [:w] - 20)))

            ;; (alert frame 1)
            )))

  (println "ready"))
