(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

(setq-default
 coding-system-for-read 'utf-8                 ; Use UTF-8 by default
 coding-system-for-write 'utf-8
 help-window-select t                          ; Focus new help windows when opened
 indent-tabs-mode nil                          ; Prefer spaces over tabs
 indicate-empty-lines t                        ; Display bitmap in left fringe on empty lines
 inhibit-startup-screen t                      ; Remove default start screen
 ring-bell-function 1                          ; Use a visual bell
 visible-bell t                                ; Use a visual bell
 select-enable-clipboard t                     ; Merge emacs and system clipboard
 tab-always-indent 'complete                   ; Use tab as a completion instead of C-M-i
 read-extended-command-predicate #'command-completion-default-include-p ; Hide commands in M-x not apply to current mode
 tab-width 4                                   ; Set width for tabs
 truncate-lines t                              ; Don't wrap lines by default
 view-read-only t                              ; Always open read-only buffers in view-mode
 vc-follow-symlinks t                          ; Don't ask for confirmation following symlinked files
 mouse-wheel-scroll-amount '(1 ((shift) . 1))  ; Mouse scroll one line at a time
 mouse-wheel-progressive-speed nil             ; Don't accelerate scrolling
 mouse-wheel-follow-mouse t                    ; Scroll window under mouse
 scroll-step 1                                 ; Keyboard scroll one line at a time
 scroll-conservatively 10000
 auto-window-vscroll nil)

(global-auto-revert-mode 1)                   ; Update buffer if file changes on disk
(global-hl-line-mode 0)                       ; Highlight current line
(global-display-fill-column-indicator-mode 0) ; Add indicator for the fill line
(column-number-mode 1)                        ; Show the column number
(fset 'yes-or-no-p 'y-or-n-p)                 ; Replace yes/no prompts with y/n
(tool-bar-mode -1)                            ; Hide the toolbar
(menu-bar-mode -1)                            ; Hide the menubar
(tooltip-mode -1)                             ; Remove mouse hover tooltips
(scroll-bar-mode -1)                          ; Hide the scrollbar
(blink-cursor-mode 0)                         ; Don't blink the cursor
(show-paren-mode 1)                           ; Show matching parens

(setq backup-directory-alist `(("." . "~/.backups/"))
      backup-by-copying t
      version-control t
      delete-old-versions nil
      kept-new-versions 20
      kept-old-versions 5)

(progn (set-face-attribute 'default nil
                           :family "JetBrains Mono"
                           :height 130
                           :weight 'medium)
       (setq line-spacing 0.2))

(load-theme 'modus-vivendi t)

(use-package exec-path-from-shell
  :init
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(use-package subword
  :straight (:type built-in)
  :hook prog-mode)

(use-package linum
  :straight (:type built-in)
  :hook prog-mode)

(use-package vertico
  :init
  (vertico-mode))

(use-package marginalia
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

(use-package consult
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
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles . (partial-completion))))))

(use-package embark
  :bind
  (("C-." . embark-act)
   ("C-;" . embark-dwim)
   ("C-h B" . embark-bindings))

  :config
  (add-to-list 'display-buffer-alist
	     '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
	       nil
	       (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package corfu
  :init
  (global-corfu-mode))

(use-package kind-icon
  :after corfu
  :custom
  (kind-icon-default-face 'corfu-default) ; to compute blended backgrounds correctly
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package tree-sitter
  :init
  (global-tree-sitter-mode 1))
(use-package tree-sitter-langs)

(use-package vundo
  :straight (vundo :type git :host github :repo "casouri/vundo")
  :bind ("C-c u" . vundo))

(use-package magit)

(use-package eglot
  :commands (eglot eglot-ensure))

(use-package minions
  :init
  (minions-mode 1)
  :custom
  (minions-prominent-modes '(flymake-mode)))
