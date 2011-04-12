;;; Copyright (C) 2011 Rocky Bernstein <rocky@gnu.org>
;;; Stock Perl debugger perldb

(eval-when-compile (require 'cl))

(require 'load-relative)
(require-relative-list '("../regexp" "../loc") "dbgr-")

(defvar dbgr-pat-hash)
(declare-function make-dbgr-loc-pat (dbgr-loc))

(defvar dbgr-perldb-pat-hash (make-hash-table :test 'equal)
  "Hash key is the what kind of pattern we want to match: backtrace, prompt, etc. 
The values of a hash entry is a dbgr-loc-pat struct")

(declare-function make-dbgr-loc "dbgr-loc" (a b c d e f))

;; Regular expression that describes a perldb location generally shown
;; before a command prompt.
;;
;; Program-location lines look like this:
;;   main::(/usr/bin/latex2html:102):
;;   main::CODE(0x9407ac8)(l2hconf.pm:6):
;; or MS Windows:
;;   ???
(setf (gethash "loc" dbgr-perldb-pat-hash)
      (make-dbgr-loc-pat
       :regexp "\\(?:CODE(0x[0-9a-h]+)\\)?(\\(.+\\):\\(\[0-9]+\\)):"
       :file-group 1
       :line-group 2))

(setf (gethash "prompt" dbgr-perldb-pat-hash)
      (make-dbgr-loc-pat
       :regexp   "\\(?:\\[pid=[0-9]+->[0-9]+\\]\\)?  DB<\\([0-9]+\\)> "
       :num 1
       ))

;;  Regular expression that describes a Perl backtrace line.
;; $ = main::top_navigation_panel called from file `./latex2html' line 7400
;; $ = main::BEGIN() called from file `(eval 19)[/usr/bin/latex2html:126]' line 2
(setf (gethash "frame" dbgr-perldb-pat-hash)
      (make-dbgr-loc-pat
       :regexp   "\s+called from file `\\(.+\\)' line \\([0-9]+\\)"
       :file-group 1
       :line-group 2))

(defvar dbgr-perldb-command-hash (make-hash-table :test 'equal)
  "Hash key is command name like 'quit' and the value is 
  the perldb command to use, like 'q'")

(setf (gethash "break"    dbgr-perldb-command-hash) "b %l")
(setf (gethash "continue" dbgr-perldb-command-hash) "c")
(setf (gethash "quit"     dbgr-perldb-command-hash) "q")
(setf (gethash "restart"  dbgr-perldb-command-hash) "R")
(setf (gethash "run"      dbgr-perldb-command-hash) "R")
(setf (gethash "step"     dbgr-perldb-command-hash) "s")
(setf (gethash "next"     dbgr-perldb-command-hash) "n")
(setf (gethash "perldb" dbgr-command-hash) dbgr-perldb-command-hash)

(setf (gethash "perldb" dbgr-pat-hash) dbgr-perldb-pat-hash)

(provide-me "dbgr-perldb-")