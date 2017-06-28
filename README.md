# emacs-rufo

Simple package for integrating emacs with [rufo](https://github.com/asterite/rufo).

Provides a function, `rufo-format-buffer`, which replaces the current buffer
with its formatted version.

## Instal rufo

```
$ gem install rufo
```

Note that if the installations is global you might need to run the previous command
with `sudo`.

## Enable format on save

Add this to your configuration file:

```elisp
(setq enable-rufo-on-save t)
```

## Key-binding

`C-c f` is enabled in both ruby and enh-ruby modes.
