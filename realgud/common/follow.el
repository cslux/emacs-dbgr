;;; Copyright (C) 2015 Rocky Bernstein <rocky@gnu.org>
;;; Follows or goto's something
(require 'load-relative)

(declare-function realgud:cmd-frame 'realgud-cmds)

(defun realgud:follow-mark(mark)
  (when (markerp mark)
    (let ((buffer (marker-buffer mark)))
      (set-buffer buffer)
      (set-window-point (display-buffer buffer) mark)
      (goto-char mark)
    )))


(defun realgud:follow(pos)
  (interactive "%d")
  (let* ((mark (get-text-property pos 'mark))
	 (filename (get-text-property pos 'file))
	 (frame-num (get-text-property pos 'frame-num))
	 )
    (cond ((markerp mark) (realgud:follow-mark mark) 't)
	  ((stringp filename)
	   (find-file-other-window filename))
	  ((numberp frame-num) (realgud:cmd-frame frame-num))
	  ('t (message "No location property found here")))
    ))

(defun realgud:follow-point()
  (interactive "")
  (realgud:follow (point)))

(defun realgud:follow-event(event)
  (interactive "e")
  (realgud:follow (posn-point (event-end event))))

(provide-me "realgud-")
