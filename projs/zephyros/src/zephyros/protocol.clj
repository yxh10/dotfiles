(ns zephyros.protocol
  (:require [clojure.data.json :as json])
  (:import [java.net Socket]
           [java.util.concurrent ArrayBlockingQueue]
           [java.io PrintWriter InputStreamReader BufferedReader]))

(def chans (ref {}))

(defmacro safely-do-in-background [& body]
  `(future
     (try
       ~@body
       (catch Exception e#
         (.printStackTrace e#)))))

(defn conn-handler [conn]
  (while (nil? (:exit @conn))
    (let [msg-size (Integer/parseInt (.readLine (:in @conn)))
          msg (take msg-size (repeatedly #(.read (:in @conn))))
          msg-str (apply str (map char msg))
          json (json/read-str msg-str)
          ;; _ (println "GOT" json)
          msg-id (json 0)
          chan (get @chans msg-id)]
      (.put chan json))))

(defn connect [server]
  (let [socket (Socket. (:name server) (:port server))
        in (BufferedReader. (InputStreamReader. (.getInputStream socket) "UTF-8"))
        out (PrintWriter. (.getOutputStream socket))
        conn (ref {:in in :out out :socket socket})]
    (safely-do-in-background (conn-handler conn))
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
        ;; _ (println "SENDING" json-str)
        json-str-size (count json-str)
        chan (ArrayBlockingQueue. 10)]
    (dosync
     (alter chans assoc msg-id chan))
    (write conn (format "%s\n%s", json-str-size, json-str))
    {:kill #(dosync (alter chans dissoc msg-id))
     :get #(second (.take chan))}))

(defn get-one-value [& args]
  (let [resp (send-msg args)
        val ((:get resp))]
    ((:kill resp))
    val))

(defn do-callback-once [f & args]
  (safely-do-in-background
    (let [resp (send-msg args)
          num-times ((:get resp))
          val ((:get resp))]
      ((:kill resp))
      (f val))))

(defn do-callback-indefinitely [f & args]
  (safely-do-in-background
    (let [resp (send-msg args)]
      ((:get resp))
      (doseq [val (repeatedly (:get resp))]
        (f val)))))
