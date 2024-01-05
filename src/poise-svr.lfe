(defmodule poise-svr
  (behaviour gen_server)
  ;; gen_server implementation
  (export
   (start_link 0)
   (stop 0))
  ;; callback implementation
  (export
   (init 1)
   (handle_call 3)
   (handle_cast 2)
   (handle_info 2)
   (terminate 2)
   (code_change 3)))

(include-lib "logjam/include/logjam.hrl")

;;; ----------------
;;; config functions
;;; ----------------

(defun SERVER () (MODULE))
(defun initial-state () #m())
(defun genserver-opts () '())

;;; -------------------------
;;; gen_server implementation
;;; -------------------------

(defun start_link ()
  (gen_server:start_link `#(local ,(SERVER))
                         (MODULE)
                         (initial-state)
                         (genserver-opts)))

(defun stop ()
  (gen_server:call (SERVER) 'stop))

;;; -----------------------
;;; callback implementation
;;; -----------------------

(defun init (state)
  (log-info "Initialising poise server ...")
  (erlang:process_flag 'trap_exit 'true)
  (let ((`#(ok ,pid ,os-pid) (exec:run_link "mdsploder" (erlexec-opts (self)))))
    `#(ok ,(maps:merge state `#m(pid ,pid os-pid ,os-pid)))))

(defun handle_cast
  ((msg state)
   (unknown-command msg)
   `#(noreply ,state)))

(defun handle_call
  (('stop _from state)
   `#(stop shutdown ok ,state))
  ((`#(cmd echo ,msg) _from state)
   `#(reply ,msg ,state))
  ((`#(cmd ping) _from state)
   `#(reply pong ,state))
  ((`#(cmd state) _from state)
   `#(reply ,state ,state))
  ((`#(cmd mdsplode ,cmd) from state)
   (handle_call `#(cmd mdsplode ,cmd delay 0) from state))
  ((`#(cmd mdsplode ,cmd delay ,ms-delay) _from (= `#m(os-pid ,os-pid) state))
   (log-debug "Sending command: ~s" (list cmd))
   (let ((output (exec:send os-pid (list_to_binary (++ cmd "\n")))))
     ;; (log-debug (string:substr output 0 1000))
     ;; for some operations, erlexec needs to give mdsplode a little time to catch up:
     (timer:sleep ms-delay))
   `#(reply ok ,state))
  ((msg _from state)
   `#(reply ,(unknown-command msg) ,state)))

(defun handle_info
  ;; Output from mdsploder
  ((`#(stdout ,_pid ,msg) state)
   (io:format "~s~n" (list (string:substr (binary_to_list msg) 1 1000)))
   `#(noreply ,state))
  ;; Output from mdsploder
  ((`#(stderr ,_pid ,msg) state)
   (io:format "~s~n" (list (string:substr (binary_to_list msg) 1 1000)))
   `#(noreply ,state))
  ((`#(EXIT ,_from normal) state)
   `#(noreply ,state))
  ((`#(EXIT ,pid ,reason) state)
   (log-warn "Process ~p exited! (Reason: ~p)~n" `(,pid ,reason))
   `#(noreply ,state))
  ((msg state)
   (unhandled-info msg)
   `#(noreply ,state)))

(defun terminate (_reason _state)
  'ok)

(defun code_change (_old-version state _extra)
  `#(ok ,state))

;;; -----------------------
;;; private functions
;;; -----------------------

(defun erlexec-opts (mgr-pid)
  `(stdin
    pty
    #(stdout ,mgr-pid)
    #(stderr ,mgr-pid)
    monitor))

(defun unknown-command (data)
  (let ((msg (io_lib:format "Unknown command: ~p" `(,data))))
    (log-error msg)
    #(error mag)))

(defun unhandled-info (data)
  (let ((msg (io_lib:format "Unhandled info: ~p" `(,data))))
    (log-warn msg)
    #(error mag)))
