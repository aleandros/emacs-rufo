;;; rufo.el --- Integrate rufo ruby formatter with emacs

;; Copyright (C) 2017 Edgar Cabrear

;; Author: Edgar Cabrera <edgar@cafeinacode.com>
;; Version: 0.1.0
;; Keywords: ruby, formatter, rufo
;; URL: https://github.com/aleandros/emacs-rufo

;;; Commentary:

;; This package provides simple integration with `rufo`,
;; the ruby code formatter.

(defcustom enable-rufo-on-save nil
  "Enables rufo formatting of the buffer on save")

;;;###autoload
(defun rufo-format-buffer ()
  "Format the current file using rufo and revert from disk"
  (interactive)
  (when (is-ruby-file?)
    (progn
      (shell-command (format "rufo %s" buffer-file-name))
      (revert-buffer nil t))))

(defun is-rufo-installed? ()
  (= 0 (call-process "which" nil nil nil "rufo")))

(defun is-ruby-file? ()
  (member major-mode '(ruby-mode enh-ruby-mode)))

(defun enable-rufo-after-save ()
  (when enable-rufo-on-save
    (add-hook 'after-save-hook #'rufo-format-buffer t)))

(add-hook 'ruby-mode-hook
          (lambda ()
            (define-key ruby-mode-map (kbd "C-c f") 'rufo-format-buffer)))
(add-hook 'enh-ruby-mode-hook
          (lambda ()
            (define-key enh-ruby-mode-map (kbd "C-c f") 'rufo-format-buffer)))
(add-hook 'ruby-mode-hook #'enable-rufo-after-save)
(add-hook 'enh-ruby-mode-hook #'enable-rufo-after-save)

;; rufo.el ends here
