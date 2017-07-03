;;; rufo.el --- Integratation with the rufo ruby formatter

;; Copyright (C) 2017 Edgar Cabrear

;; Author: Edgar Cabrera <edgar@cafeinacode.com>
;; Version: 0.1.1
;; Keywords: tools
;; URL: https://github.com/aleandros/emacs-rufo

;;; Commentary:

;; This package provides simple integration with `rufo`,
;; the ruby code formatter.

;;; Code:

(defcustom rufo-enable-format-on-save nil
  "Enables rufo formatting of the buffer on save.")

;;;###autoload
(defun rufo-format-buffer ()
  "Format the current file using rufo and revert from disk."
  (interactive)
  (when (rufo-is-ruby-file?)
    (progn
      (shell-command (format "rufo %s" buffer-file-name))
      (revert-buffer nil t t))))

(defun rufo-installed? ()
  "Verify that the binary rufo is present in the system's path."
  (= 0 (call-process "which" nil nil nil "rufo")))

(defun rufo-is-ruby-file? ()
  "Check if the current buffer is in a known ruby mode."
  (member major-mode '(ruby-mode enh-ruby-mode)))

(defun rufo-enable-format-after-save-hook ()
  "If enabled, add the ‘after-save-hook’."
  (when rufo-enable-format-on-save
    (add-hook 'after-save-hook #'rufo-format-buffer t)))

(add-hook 'ruby-mode-hook
          (lambda ()
            (define-key ruby-mode-map (kbd "C-c f") 'rufo-format-buffer)))
(add-hook 'enh-ruby-mode-hook
          (lambda ()
            (define-key enh-ruby-mode-map (kbd "C-c f") 'rufo-format-buffer)))
(add-hook 'ruby-mode-hook #'rufo-enable-format-after-save-hook)
(add-hook 'enh-ruby-mode-hook #'rufo-enable-format-after-save-hook)

(provide 'rufo)

;;; rufo.el ends here
