;;; config.el -*- lexical-binding: t; -*-

;; Theme and Font
(setq doom-theme 'doom-dracula)
(setq doom-font (font-spec :family "Hack Nerd Font" :size 24))

;; Line Numbers
(setq display-line-numbers-type t)

;; Org Directory
(setq org-directory "~/org/")

;; Performance Tweaks
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb

;; LSP and Formatting
(setq +format-with-lsp nil)
(setq +format-on-save-enabled-modes
      '(not emacs-lisp-mode sql-mode tex-mode latex-mode))

(use-package! lsp-tailwindcss)

(after! format
  (set-formatter! 'prettierd "prettierd" :modes '(js-mode js2-mode typescript-mode web-mode css-mode json-mode)))

;; Language-specific Configurations

;; Go
(after! go-mode
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save))

;; Python
(use-package! python-black
  :after python
  :hook (python-mode . python-black-on-save-mode)
  :config
  (setq python-black-extra-args '("--line-length" "88"))
  (map! :leader
        (:prefix ("c" . "code")
         :desc "Black buffer" "b" #'python-black-buffer
         :desc "Black region" "r" #'python-black-region)))

(after! python
  (setq lsp-pyright-use-library-code-for-types t))

;; TypeScript and Web
(after! (web-mode typescript-mode)
  (setq web-mode-enable-auto-quoting nil)
  (setq lsp-typescript-suggest-complete-function-calls t))

(setq-hook! 'typescript-mode-hook +format-with-lsp nil)
(setq-hook! 'typescript-tsx-mode-hook +format-with-lsp nil)

;; Org Mode Enhancements
(after! org
  (setq org-pretty-entities t)
  (setq org-pretty-entities-include-sub-superscripts nil)
  (setq org-use-sub-superscripts '{}))

(add-hook 'org-mode-hook 'turn-on-org-cdlatex)
(use-package! org-fragtog
  :after org
  :hook (org-mode . org-fragtog) ; this auto-enables it when you enter an org-buffer, remove if you do not want this
  :config
  )
(use-package org-latex-impatient
  :defer t
  :hook (org-mode . org-latex-impatient-mode)
  :init
  (setq org-latex-impatient-tex2svg-bin
        ;; location of tex2svg executable
        "~/node_modules/mathjax-node-cli/bin/tex2svg"))

;; Clipboard Management
(after! evil
  (setq evil-kill-on-visual-paste nil)
  (remove-hook 'evil-visual-state-entry-hook #'evil-visual-paste-char))

(defun copy-to-clipboard ()
  (interactive)
  (if (region-active-p)
      (progn
        (clipboard-kill-ring-save (region-beginning) (region-end))
        (message "Copied to clipboard!"))
    (message "No region active; can't copy to clipboard!")))

(defun cut-to-clipboard ()
  (interactive)
  (if (region-active-p)
      (progn
        (clipboard-kill-region (region-beginning) (region-end))
        (message "Cut to clipboard!"))
    (message "No region active; can't cut to clipboard!")))

(global-set-key (kbd "C-c c") 'copy-to-clipboard)
(global-set-key (kbd "C-c x") 'cut-to-clipboard)
(global-set-key (kbd "C-S-v") 'clipboard-yank)

;; Spell Checking
(setq ispell-dictionary "en_US")
(setq ispell-program-name "hunspell")

;; Miscellaneous
(setq initial-buffer-choice nil)

(setq org-latex-compiler "pdflatex")
