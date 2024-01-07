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
   (handle_continue 2)
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
(defun bin-map () #m(exec "/Users/oubiwann/lab/oxur/mdsplode/bin/mdsplode"
                     cmd "shell"
                     args "--log-level debug --headless"))
(defun erlexec-opts (mgr-pid)
  `(stdin
    #(stdout ,mgr-pid)
    #(stderr ,mgr-pid)
    monitor))

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
  `#(ok ,state #(continue first-run)))

(defun handle_cast
  ((msg state)
   (unknown-cast msg)
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
     (timer:sleep ms-delay)
     (log-debug "Got output: ~p" (list output))
     `#(reply ,output ,state)))
  ((msg _from state)
   `#(reply ,(unknown-call msg) ,state)))

(defun handle_continue
  (('first-run state)
   (erlang:process_flag 'trap_exit 'true)
   (let ((`#(ok ,pid ,os-pid) (exec:run_link (executable (bin-map)) (erlexec-opts (self)))))
     `#(noreply ,(maps:merge state `#m(pid ,pid os-pid ,os-pid)))))
  ((msg state)
   `#(reply ,(unknown-continue msg) ,state)))

(defun handle_info
  ;; Output from mdsplode
  ((`#(ok, ()) state)
   `#(noreply ,state))
  ((`#(ok, (,head . ,tail)) state)
   (handle_info head state)
   (handle_info `#(ok ,tail) state))
  ;; Command-specific message handlers for mdsplode
  ((`#(result "ping" "pong") state)
   (log-info "The mdsplode binary is alive.")
   `#(noreply ,state))
  ((`#(result "version" ,version) state)
   (log-info "The mdsplode binary version: ~s" (list version))
   `#(noreply ,state))
  ;; Raw stdout from mdsplode
  ((`#(stdout ,_pid ,json) state)
   (let ((parsed (jsx:decode json '(#(labels atom)))))
     (log-debug "stdout: ~p~n" (list json))
     (handle_info `#(result
                     ,(binary_to_list (mref parsed 'command))
                     ,(binary_to_list (mref parsed 'result)))
                  state)
     `#(noreply ,state)))
  ;; Raw stderr from mdsplode
  ((`#(stderr ,_pid ,msg) state)
   (log-debug "stderr: ~s~n" (list (string:trim (lists:flatten (binary_to_list msg)))))
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

(defun unknown-call (data)
  (let ((msg (io_lib:format "Unknown call: ~p" `(,data))))
    (log-error msg)
    `#(error msg)))

(defun unknown-cast (data)
  (let ((msg (io_lib:format "Unknown cast: ~p" `(,data))))
    (log-error msg)
    `#(error msg)))

(defun unknown-continue (data)
  (let ((msg (io_lib:format "Unknown continuet: ~p" `(,data))))
    (log-error msg)
    `#(error msg)))

(defun unhandled-info (data)
  (let ((msg (io_lib:format "Unhandled info: ~p" `(,data))))
    (log-warn msg)
    `#(error msg)))

(defun executable (bin-map)
  (lists:flatten (io_lib:format "~s ~s ~s"
                                (list (mref bin-map 'exec)
                                      (mref bin-map 'cmd)
                                      (mref bin-map 'args)))))
