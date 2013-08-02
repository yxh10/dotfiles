(ns zephyros.core
  (:require [clojure.data.json :as json])
  (:import (java.net Socket)
           (java.io PrintWriter InputStreamReader BufferedReader)))

(def zephyros-server {:name "localhost" :port 1235})

(declare conn-handler)

(defn connect [server]
  (let [socket (Socket. (:name server) (:port server))
        in (BufferedReader. (InputStreamReader. (.getInputStream socket)))
        out (PrintWriter. (.getOutputStream socket))
        conn (ref {:in in :out out})]
    (doto (Thread. #(conn-handler conn)) (.start))
    conn))

(defn write [conn msg]
  (doto (:out @conn)
    (.println (str msg "\r"))
    (.flush)))

(defn conn-handler [conn]
  (while (nil? (:exit @conn))
    (let [msg-size (Integer/parseInt (.readLine (:in @conn)))
          msg (take msg-size (repeatedly #(.read (:in @conn))))
          msg-str (apply str (map char msg))
          json (json/read-str msg-str)]
      (prn json))))

(defn -main []
  (let [s (json/write-str [1, 0, "alert", "hello", 2])
        size (count s)
        conn (connect zephyros-server)]
    (write conn (format "%s\n%s", size, s))))
