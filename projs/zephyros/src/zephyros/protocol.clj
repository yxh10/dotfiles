(ns zephyros.protocol
  (:require [clojure.data.json :as json])
  (:import [java.net Socket]
           [java.util.concurrent ArrayBlockingQueue]
           [java.io PrintWriter InputStreamReader BufferedReader]))

(def chans (ref {}))

(defn conn-handler [conn]
  (while (nil? (:exit @conn))
    (let [msg-size (Integer/parseInt (.readLine (:in @conn)))
          msg (take msg-size (repeatedly #(.read (:in @conn))))
          msg-str (apply str (map char msg))
          json (json/read-str msg-str)
          msg-id (json 0)
          chan (get @chans msg-id)]
      (.put chan json))))

(defn connect [server]
  (let [socket (Socket. (:name server) (:port server))
        in (BufferedReader. (InputStreamReader. (.getInputStream socket)))
        out (PrintWriter. (.getOutputStream socket))
        conn (ref {:in in :out out :socket socket})]
    (future (conn-handler conn))
    conn))

(defn write [conn msg]
  (doto (:out @conn)
    (.print msg)
    (.flush)))

(def zephyros-server {:name "localhost" :port 1235})
(def conn (connect zephyros-server))
(def max-msg-id (atom 0))

(defn send-msg [args]
  (let [msg-id (swap! max-msg-id inc)
        json-str (json/write-str (concat [msg-id] args))
        json-str-size (count json-str)
        _ (println "SENDING" json-str)
        chan (ArrayBlockingQueue. 10)]
    (dosync
     (alter chans assoc msg-id chan))
    (write conn (format "%s\n%s", json-str-size, json-str))
    {:kill-chan #(dosync (alter chans dissoc msg-id))
     :get-val #(second (.take chan))}))




(defn get-one-value [& args]
  (let [resp (send-msg args)
        val ((:get-val resp))]
    ((:kill-chan resp))
    val))

(defn do-callback-once [f & args]
  (future
    (let [resp (send-msg args)
          num-times ((:get-val resp))
          val ((:get-val resp))]
      ((:kill-chan resp))
      (f val))))

;; (defn do-callback-indefinitely [f & args]
;;   (future
;;     (let [resp (send-msg args)]
;;       ((:get-val resp))
;;       (doseq [val (repeatedly (:get-val resp))]
;;         (f)))))
