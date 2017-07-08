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
  "Enables rufo formatting of the buffer on save."
  :group 'rufo)

;;;###autoload
(defun rufo-format-buffer ()
  "Format the current file using rufo and revert from disk."
  (interactive)
  (when (rufo--is-ruby-file?)
    (let ((position (point)))
      (rufo--run-external-command)
      (goto-char position))))

(defun rufo-installed? ()
  "Verify that the binary rufo is present in the system's path."
  (zerop (call-process "which" nil nil nil "rufo")))

(defun rufo--is-ruby-file? ()
  "Check if the current buffer is in a known ruby mode."
  (member major-mode '(ruby-mode enh-ruby-mode)))

(defun rufo--enable-format-after-save-hook ()
  "If enabled, add the ‘after-save-hook’."
  (when rufo-enable-format-on-save
    (add-hook 'after-save-hook #'rufo-format-buffer t)))

(defun rufo--run-external-command ()
  "Handle execution of external command."
  (let ((original-buffer (current-buffer))
        (input (buffer-string)))
    (with-temp-buffer
      (insert input)
      (rufo--execute-on-region)
      (let ((output (buffer-string)))
        (when (> (length output) 0)
          (rufo--replace-buffer original-buffer output))))))

(defun rufo--execute-on-region ()
  "Execute rufo on whole region for current buffer, replacing its contents."
  (shell-command-on-region
   (goto-char (point-min))
   (goto-char (point-max))
   "rufo"
   (current-buffer)
   t
   (get-buffer-create "*rufo-error*")))

(defun rufo--replace-buffer (buffer contents)
  "Replace BUFFER with CONTENTS (deletes previous contents)."
  (with-current-buffer buffer
    (delete-region (goto-char (point-min))
                   (goto-char (point-max)))
    (insert contents)))

(add-hook 'ruby-mode-hook
          (lambda ()
            (define-key ruby-mode-map (kbd "C-c f") 'rufo-format-buffer)))
(add-hook 'enh-ruby-mode-hook
          (lambda ()
            (define-key enh-ruby-mode-map (kbd "C-c f") 'rufo-format-buffer)))
(add-hook 'ruby-mode-hook #'rufo--enable-format-after-save-hook)
(add-hook 'enh-ruby-mode-hook #'rufo--enable-format-after-save-hook)

(provide 'rufo)

;;; rufo.el ends here
