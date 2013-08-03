(ns zephyros.core
  (:require [zephyros.api :refer :all]))

(defn -main []

  (bind "d" ["cmd" "shift"]
        (fn []
          (alert "foo" 1)))

  (listen "app_launched"
          (fn [app]
            (prn "app launched!" app)))

  (bind "f" ["cmd" "shift"]
        (fn []
          (prn "waiting")
          (choose-from ["foo" "bar"] "stuff"
                       (fn [i]
                         (prn "it was" i)))))

  (println "ready"))
