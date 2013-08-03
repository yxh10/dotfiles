(ns zephyros.core
  (:require [clojure.data.json :as json])
  (:import [java.net Socket]
           [java.util.concurrent ArrayBlockingQueue]
           [java.io PrintWriter InputStreamReader BufferedReader]))

(def zephyros-server {:name "localhost" :port 1235})

(declare conn-handler)

(def chans (ref {}))

(defn connect [server]
  (let [socket (Socket. (:name server) (:port server))
        in (BufferedReader. (InputStreamReader. (.getInputStream socket)))
        out (PrintWriter. (.getOutputStream socket))
        conn (ref {:in in :out out :socket socket})]
    (doto (Thread. #(conn-handler conn)) (.start))
    conn))

(defn write [conn msg]
  (doto (:out @conn)
    (.print msg)
    (.flush)))

(defn conn-handler [conn]
  (while (nil? (:exit @conn))
    (let [msg-size (Integer/parseInt (.readLine (:in @conn)))
          msg (take msg-size (repeatedly #(.read (:in @conn))))
          msg-str (apply str (map char msg))
          json (json/read-str msg-str)
          msg-id (json 0)
          chan (get @chans msg-id)]
      (.put chan json))))

(def conn (connect zephyros-server))
(def max-msg-id (atom 0))

(def api 0)

(defn send-msg [& args]
  (let [msg-id (swap! max-msg-id inc)
        json-str (json/write-str (concat [msg-id] args))
        json-str-size (count json-str)
        _ (prn "SENDING" json-str)
        chan (ArrayBlockingQueue. 10)]
    (dosync
     (alter chans assoc msg-id chan))
    (write conn (format "%s\n%s", json-str-size, json-str))
    chan))

(defn get-response [chan]
  (-> (.take chan)
      (second)))

(defn -main []
  (let [chan (send-msg api "bind" "d" ["cmd" "shift"])]
    (doseq [val (repeatedly #(get-response chan))]
      (prn "bind callback arg" val)
      (prn "alert respone " (get-response (send-msg api "alert" "hello world" 1)))

      (let [win (get-response (send-msg api "focused_window"))
            frame (get-response (send-msg win "frame"))
            _ (prn frame)
            frame (update-in frame ["x"] + 10)
            _ (prn frame)
            ]

        (send-msg win "set_frame" frame)

        ;; (prn win)
        ;; (prn "win frame " )
        ))))
