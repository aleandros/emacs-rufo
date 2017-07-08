(defvar rufo-test/root-path (f-parent (f-parent (f-this-file))))
(load (f-join rufo-test/root-path "rufo.el"))

(ert-deftest is-ruby-file? ()
  (with-temp-buffer
    (ruby-mode)
    (should (rufo--is-ruby-file?))
    (when (featurep 'enh-ruby-mode)
      (enh-ruby-mode)
      (should (rufo--is-ruby-file?)))
    (emacs-lisp-mode)
    (should-not (rufo--is-ruby-file?))))

(ert-deftest formats-buffer ()
  (skip-unless (rufo-installed?))
  (with-temp-buffer
    (ruby-mode)
    (insert "
def x
    a + b
end
")
    (rufo-format-buffer)
    (should (equal (buffer-string)
               "
def x
  a + b
end
"))))

(ert-deftest leaves-buffer-unmodifed-on-invalid-ruby ()
  (skip-unless (rufo-installed?))
  (with-temp-buffer
    (ruby-mode)
    (insert "-.-")
    (rufo-format-buffer)
    (should (equal (buffer-string) "-.-"))))
