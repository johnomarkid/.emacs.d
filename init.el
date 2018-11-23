(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("ed4b75a4f5cf9b1cd14133e82ce727166a629f5a038ac8d91b062890bc0e2d1b" default)))
 '(package-selected-packages
   (quote
    (lispy org-plus-contrib granger-theme parinfer go-mode magit projectile ubuntu-theme exec-path-from-shell evil-escape-mode evil-escape evil-surround auto-package-update rust-mode gruber-darker-theme cider counsel ivy monokai-theme use-package undo-tree goto-chg))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

;; guide to customize evil
;; https://github.com/noctuid/evil-guide
(use-package evil
  :ensure t
  :config

  (define-key evil-normal-state-map (kbd "q") nil)
  
  (use-package evil-leader
    :ensure t
    :init
    (global-evil-leader-mode)
    :config
    (evil-leader/set-leader ",")
    (evil-leader/set-key
      "b" 'switch-to-buffer
      "f" 'find-file
      "," 'projectile-find-file
      "g" 'projectile-grep
      "TAB" 'evil-switch-to-windows-last-buffer
      "w" 'other-window
      "m" 'magit-status)

    (evil-leader/set-key-for-mode 'clojure-mode
      "ee" 'cider-eval-last-sexp
      "eb" 'cider-load-buffer
      "jj" 'cider-jack-in
      "t" 'cider-test-run-tests))

  (use-package evil-surround
    :ensure t
    :config
    (global-evil-surround-mode))

  (evil-mode 1))

(use-package org-drill
  :defer t
  :ensure org-plus-contrib
  :config (progn)
      (add-to-list 'org-modules 'org-drill))

(use-package ivy :demand
  :config
  (ivy-mode 1)
          ; Use Enter on a directory to navigate into the directory, not open it with dired.
  (define-key ivy-minibuffer-map (kbd "C-m") 'ivy-alt-done)
  (setq ivy-use-virtual-buffers t
        ivy-count-format "%d/%d "))

(use-package projectile
  :ensure t
  :config
  (projectile-global-mode)
  (setq projectile-completion-system 'ivy))

(use-package magit
  :ensure t)

(use-package clojure-mode
  :ensure t)

(use-package cider
  :ensure t
  :defer t
  :config
  (cider-repl-toggle-pretty-printing))

(use-package rust-mode
  :ensure t
  :config
  (setq rust-format-on-save t))

(use-package parinfer
  :ensure t
  :bind
  (("C-," . parinfer-toggle-mode))
  :init
  (progn
    (setq parinfer-extensions
          '(defaults       ; should be included.
            pretty-parens  ; different paren styles for different modes.
            evil))   ; Yank behavior depend on mode.
    (add-hook 'clojure-mode-hook #'parinfer-mode)
    (add-hook 'emacs-lisp-mode-hook #'parinfer-mode)
    (add-hook 'common-lisp-mode-hook #'parinfer-mode)
    (add-hook 'scheme-mode-hook #'parinfer-mode)
    (add-hook 'lisp-mode-hook #'parinfer-mode)))

(use-package ubuntu-theme
  :ensure t
  :init
  (load-theme 'ubuntu))

;;(set-default-font "Ubuntu Mono Regular -16")
(set-face-attribute 'default nil
                    :family "Ubuntu Mono"
                    :height 170)

;; Essential settings.
(setq inhibit-splash-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(show-paren-mode 1)
(electric-pair-mode 1)
(setq visible-bell t)
(global-linum-mode 1)
(add-to-list 'exec-path "/usr/local/bin")

;; Disable backup files
(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files

(defun switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

;; Need this to load bin into shell
(add-to-list 'exec-path "/usr/local/bin")

;; Shows ctrl-g bell in mode line instead of full screen
(setq ring-bell-function
   (lambda ()
     (let ((orig-fg (face-foreground 'mode-line)))
       (set-face-foreground 'mode-line "#F2804F")
       (run-with-idle-timer 0.1 nil
                            (lambda (fg) (set-face-foreground 'mode-line fg))
                            orig-fg))))
