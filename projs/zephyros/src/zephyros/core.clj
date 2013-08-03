(ns zephyros.core
  (:require [zephyros.protocol :refer :all]))





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





(def api 0)

(defn alert [msg duration]
  (get-one-value api "alert" msg duration))

(defn choose-from [list title f]
  (do-callback-once f api "choose_from" list title 20 10))

(defn bind [key mods f]
  (future
    (let [resp (send-msg [api "bind" key mods])]
      ((:get-val resp))
      (doseq [val (repeatedly (:get-val resp))]
        (f)))))

(defn listen [event f]
  (future
    (let [resp (send-msg [api "listen" event])]
      ((:get-val resp))
      (doseq [val (repeatedly (:get-val resp))]
        (f)))))

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
