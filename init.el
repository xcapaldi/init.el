(require 'use-package)

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

(package-initialize)

(setq custom-file (concat user-emacs-directory "custom.el"))

(require 'use-package)

(unless (package-installed-p 'vc-use-package)
  (package-vc-install "https://github.com/slotThe/vc-use-package"))

(use-package no-littering
  :ensure t
  :config (no-littering-theme-backups))

(use-package emacs
  :config
  (setq-default
   coding-system-for-read 'utf-8     ; Use UTF-8 by default
   coding-system-for-write 'utf-8
   cursor-in-non-selected-windows t  ; Don't hide the cursor in inactive windows
   help-window-select t              ; Focus new help windows when opened
   indent-tabs-mode -1               ; Use spaces by default instead of tabs
   tab-width 4                       ; Set width for tabs
   indicate-empty-lines t            ; Display bitmap in left fringe on empty lines
   indicate-buffer-boundaries 'left  ; Indicate last newline in buffer
   require-final-newline t           ; Always insert final newline on save
   show-trailing-whitespace t        ; Highlight trailing whitespace at end of line
   inhibit-startup-screen t          ; Remove default start screen
   select-enable-clipboard t         ; Merge Emacs and system clipboard
   view-read-only t                  ; Always open read-only buffers in view-mode
   visible-bell t                    ; Use a visual bell
   vc-follow-symlinks t              ; Don't ask for confirmation following symlinked files
   sentence-end-double-space nil     ; Sentences end with punctuation and a single space
   show-paren-delay 0)               ; No delay on highlighting matching paren

  (fset 'yes-or-no-p 'y-or-n-p)  ; Replace yes/no prompts with y/n

  ;; global modes
  (column-number-mode 1)                   ; Show the column number in modeline
  (tool-bar-mode 1)                        ; Show the toolbar
  (menu-bar-mode 1)                        ; Show the menubar
  (context-menu-mode 1)                    ; Replace standard mouse-3 actions with context menu
  (global-auto-revert-mode 1)              ; If file changes on disk, update the buffer automatically
  (pixel-scroll-precision-mode 1)          ; Smooth scrolling
  (set-scroll-bar-mode 'right)             ; Show the scrollbar and display on the right side
  (display-fill-column-indicator-mode -1)  ; Don't display indicator for the fill line
  (global-hl-line-mode -1)                 ; Don't highlight current line globally
  (show-paren-mode 1)                      ; Show matching parens
  (blink-cursor-mode 1)                    ; Blink the cursor
  (tooltip-mode -1)                        ; Hide mouse hover tooltips
  (global-visual-line-mode -1)             ; Wrap lines instead of extending past view
  (auto-fill-mode -1)                      ; Don't auto-wrap lines

  ;; load theme
  (load-theme 'modus-vivendi t)

  ;; only enable font if available on system
  (when (member "Unifont" (font-family-list))
    (set-frame-font "Unifont-12:regular" nil t)
    (add-to-list 'initial-frame-alist '(font . "Unifont-12:regular"))
    (add-to-list 'default-frame-alist '(font . "Unifont-12:regular")))
  ;; set fallback fonts for symbols and emoji
  (set-fontset-font t 'symbol (font-spec :family "Apple Symbols") nil 'prepend)
  (set-fontset-font t 'symbol (font-spec :family "Apple Color Emoji") nil 'prepend)
  ;; set line spacing (0.1 == 1x)
  (setq-default line-spacing 0.1)

  ;; rebind keys on MacOS
  (when (equal system-type 'darwin)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'super))

    ;; disable lockfiles
  (setq create-lockfiles nil))

(use-package corfu
  :ensure t
  :init
  (global-corfu-mode))

(use-package dired
  :ensure nil
  :custom ((dired-listing-switches "-alh"))
  :config (put 'dired-find-alternate-file 'disabled nil))

(use-package display-line-numbers
  :ensure nil
  :hook (prog-mode . display-line-numbers-mode))

(use-package dumb-jump
  :ensure t
  :after xref
  :custom (dumb-jump-force-searcher 'rg)
  :config (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

(use-package eglot
  :ensure nil)
  ;;:hook (python-mode
  ;;       c-mode))

(use-package exec-path-from-shell
  :ensure t
  :init
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(use-package hippie-exp
  :ensure nil
  :bind ([remap dabbrev-expand] . hippie-expand)) ;; M-/ and C-M-/

(use-package ibuffer
  :ensure nil
  :bind ([remap list-buffers] . ibuffer)) ;; C-x C-b

(use-package magit
  :ensure t)

(use-package minions
  :ensure t
  :init
  (minions-mode 1)
  :custom
  (minions-prominent-modes '(flymake-mode)))

(use-package subword
  :ensure nil
  :hook prog-mode)

(use-package vundo
  :ensure t
  :bind ("C-c u" . vundo))

(use-package browse-at-remote
  :ensure t
  :bind ("C-c g g" . browse-at-remote))

(use-package vertico
  :ensure t
  :init
  (vertico-mode))

(use-package marginalia
  :ensure t
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

(use-package consult
  :ensure t
  :bind (([remap switch-to-buffer] . consult-buffer)
         ([remap switch-to-buffer-other-window] . consult-buffer-other-window)
         ([remap switch-to-buffer-other-frame] . consult-buffer-other-frame)
         ([remap bookmark-jump] . consult-bookmark)
         ([remap project-switch-to-buffer] . consult-project-buffer)
         ([remap yank-pop] . consult-yank-pop)
         :map isearch-mode-map
         ([remap isearch-edit-string] . consult-isearch-history)
         ("C-c l" . consult-line)
         ("C-c L" . consult-line-multi)
         :map minibuffer-local-map
         ([remap next-matching-history-element] . consult-history)
         ([remap previous-matching-history-element] . consult-history)))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles . (partial-completion))))))

(load custom-file)
