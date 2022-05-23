;; These are some functions and keybinds to help me navigate
;; Emacs. You can put this in the .emacs file for running at startup,
;; or you can eval in the scratch pad: (1) C-x C-b *scratch* to move
;; to the scratch pad. (2) M-x eval-buffer to run the whole buffer.


(defun newline-below()
  (interactive)
  (move-end-of-line 1)
  (newline-and-indent))

(defun newline-above()
  (interactive)
  (move-end-of-line 0)
  (newline-and-indent))

;; Helper function for line transposition.
;; From https://www.emacswiki.org/emacs/basic-edit-toolkit.el
(defun move-text-internal(arg)
  (let ((remember-point (point)))
    (goto-char (point-max))
    (if (not (bolp)) (newline))
    (goto-char remember-point)
    (cond ((and mark-active transient-mark-mode)
           (if (> (point) (mark))
               (exchange-point-and-mark))
           (let ((column (current-column))
                 (text (delete-and-extract-region (point) (mark))))
             (forward-line arg)
             (move-to-column column t)
             (set-mark (point))
             (insert text)
             (exchange-point-and-mark)
             (setq deactivate-mark nil)))
          (t
           (let ((column (current-column)))
             (beginning-of-line)
             (when (or (> arg 0) (not (bobp)))
               (forward-line 1)
               (when (or (< arg 0) (not (eobp)))
                 (transpose-lines arg))
               (forward-line -1))
             (move-to-column column t))
           ))))

(defun move-line-up()
  (interactive)
  (move-text-internal -1))

(defun move-line-down()
  (interactive)
  (move-text-internal 1))

(defun delete-word(arg)
  (interactive)
  (if (use-region-p)
      (delete-region (region-beginning) (region-end))
    (delete-region (point) (progn (forward-word arg) (point)))))

(defun delete-word-forward()
  (interactive)
  (delete-word 1))

(defun delete-word-backward()
  (interactive)
  (delete-word -1))


;; Key rebindings
(define-key cua-global-keymap (kbd "C-<return>") 'newline-below)
(define-key cua-global-keymap (kbd "C-S-<return>") 'newline-above)
(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)
(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "C-f") 'isearch-forward)
(define-key isearch-mode-map (kbd  "<return>") 'isearch-repeat-forward)
(define-key isearch-mode-map (kbd  "<return>") 'isearch-repeat-backward)
(global-set-key (kbd "C-S-f") 'isearch-backward)
(global-set-key (kbd "C-<tab>") 'other-window)
(define-key cua-global-keymap (kbd "C-M-<return>") 'cua-set-rectangle-mark)
(global-set-key (kbd "C-<backspace>") 'delete-word-backward)
(global-set-key (kbd "C-<delete>") 'delete-word-forward)
