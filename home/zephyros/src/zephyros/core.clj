(ns zephyros.core
  (:require [clojure.data.json :as json]))

(prn "one")
(use 'lamina.core 'aleph.tcp 'gloss.core)
(prn "two")

(defn -main []
  (let [s (json/write-str [1, 0, "alert", "hello", 2])
        size (count s)
        ch (wait-for-result
            (tcp-client {:host "localhost",
                         :port 1235,}))]
    (enqueue ch (format "%s\n%s", size, s))
    (wait-for-message ch)))
