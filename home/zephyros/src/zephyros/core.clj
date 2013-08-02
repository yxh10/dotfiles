(ns zephyros.core
  (:require [clojure.data.json :as json])
  (:import [java.net Socket]
           [java.util.concurrent ArrayBlockingQueue]
           [java.io PrintWriter InputStreamReader BufferedReader]))

(def zephyros-server {:name "localhost" :port 1235})

(declare conn-handler)

(defn connect [server]
  (let [socket (Socket. (:name server) (:port server))
        in (BufferedReader. (InputStreamReader. (.getInputStream socket)))
        out (PrintWriter. (.getOutputStream socket))
        conn (ref {:in in :out out :chan (ArrayBlockingQueue. 10)})]
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
      (.put (:chan @conn) json))))

(defn -main []
  (let [s (json/write-str [1, 0, "bind", "d", ["cmd" "shift"]])
        size (count s)
        conn (connect zephyros-server)]
    (write conn (format "%s\n%s", size, s))
    (while (nil? (:exit @conn))
      (prn "its" (.take (:chan @conn)))

      )))
