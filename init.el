
;; -*- mode: emacs-lisp -*-
;; Simple .emacs configuration

;; ---------------------
;; -- Global Settings --
;; ---------------------

(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
;; Make cursor a line
(setq-default cursor-type 'bar)

;; Turn off sound
(setq visible-bell t)

;; Turn off messages
(setq inhibit-startup-message t)

;; Full Screen
(scroll-bar-mode 0)
(tool-bar-mode 1)

;; Automatically indent
(define-key global-map (kbd "RET") 'newline-and-indent)

;; Set C indentation style to K&R
(setq c-default-style "k&r"
      c-basic-offset 4)

;; Show useless whitespace
(setq show-trailing-whitespace t)

