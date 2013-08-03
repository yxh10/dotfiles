(ns zephyros.core
  (:require [clojure.data.json :as json])
  (:import [java.net Socket]
           [java.util.concurrent ArrayBlockingQueue]
           [java.io PrintWriter InputStreamReader BufferedReader]))

(def zephyros-server {:name "localhost" :port 1235})

(declare conn-handler)

(def chans (ref {}))

(defmacro do-in-background [& body]
  `(doto (Thread. (fn [] ~@body))
     (.start)))

(defn connect [server]
  (let [socket (Socket. (:name server) (:port server))
        in (BufferedReader. (InputStreamReader. (.getInputStream socket)))
        out (PrintWriter. (.getOutputStream socket))
        conn (ref {:in in :out out :socket socket})]
    (do-in-background (conn-handler conn))
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


(defn send-msg [& args]
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





(def api 0)

(defn alert [msg duration]
  (let [resp (send-msg api "alert" msg duration)
        val ((:get-val resp))]
    ((:kill-chan resp))
    val))


(defn choose-from [list title f]
  (do-in-background
   (let [resp (send-msg api "choose_from" list title 20 10)
         num-times ((:get-val resp))
         idx ((:get-val resp))]
     ((:kill-chan resp))
     (f idx))))

(defn bind [key mods f]
  (do-in-background
   (let [resp (send-msg api "bind" key mods)]
     ((:get-val resp))
     (doseq [val (repeatedly (:get-val resp))]
       (f)))))

(defn -main []
  (bind "d" ["cmd" "shift"]
        (fn []
          (alert "foo" 1)))
  (prn "ok")
  (bind "f" ["cmd" "shift"]
        (fn []
          (prn "waiting")
          (choose-from ["foo" "bar"] "stuff"
                       (fn [i]
                         (prn "it was" i)))))

  ;; (let []
  ;;   ;;   ;; (let [win ((:get-val (send-msg api "focused_window")))
  ;;   ;;   ;;       frame ((:get-val (send-msg win "frame")))
  ;;   ;;   ;;       _ (prn frame)
  ;;   ;;   ;;       frame (update-in frame ["x"] + 10)
  ;;   ;;   ;;       _ (prn frame)
  ;;   ;;   ;;       ]
  ;;   ;;   ;;   (send-msg win "set_frame" frame)
  ;;   ;;   ;;   ;; (prn win)
  ;;   ;;   ;;   ;; (prn "win frame " )
  ;;   ;;   ;;   )
  ;;   ;;   )
  ;;   )
  )
