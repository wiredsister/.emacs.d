
;; ========================================================================
;; INTRODUCTION 📓
;; ========================================================================
;;
;; This is my Emacs init for OSX. A series of Copypastas and works in progress,
;; lovingly dumped without order or care into one large elisp file.
;;
;; I've included a help_yourself.md file in emacs.d that you can access
;; linked from the dashboard. It contains key-bindings and documentation
;; for all the packges I've used here.
;;
;; Feel free to take anything you want or PR anything you think I'm missing!
;; Inspired by:
;; - https://xenodium.com/my-emacs-eye-candy
;; - https://github.com/bzg/dotemacs/blob/master/emacs.md
;; - https://github.com/emacs-tw/awesome-emacs#macos
;;
;; Best,
;;   Gina

(setq user-full-name "Gina Marie Maini")
(setq user-mail-address "ginaandthecats@gmail.com")

;; ========================================================================
;; ARTIFACTORIES 📦
;; ========================================================================

;; Bring in to the environment all package management functions
(require 'package)                  

;; A list of package repositories
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org"   . "https://orgmode.org/elpa/")
	 		 ("nongnu" . "http://elpa.nongnu.org/nongnu/")
                         ("elpa"  . "https://elpa.gnu.org/packages/")))

;; Initializes the package system and prepares it to be used
(package-initialize)                 

(unless package-archive-contents     ; Unless a package archive already exists,
  (package-refresh-contents))        ; Refresh package contents so that Emacs knows which packages to load

;; Initialize use-package on non-linux platforms
(unless (package-installed-p 'use-package)        ; Unless "use-package" is installed, install "use-package"
  (package-install 'use-package))

;; Precompute activation actions to speed up startup
(setq package-quickstart t)

;; Require `use-package' when compiling
(eval-when-compile (require 'use-package))

;; Make sure packages are downloaded and installed before they are run
;; also frees you from having to put :ensure t after installing EVERY PACKAGE.
(setq use-package-always-ensure t)

;;========================================================================
;; USER EXPERIENCE 🖥️
;;========================================================================

;; Key Bindings
(global-set-key (kbd "C-'") 'toggle-window-split)
(global-set-key (kbd "M-'") 'transpose-windows)
(global-set-key (kbd "<C-return>") 'next-buffer)
(global-set-key (kbd "<C-M-right>") 'other-window)
(global-set-key (kbd "<C-M-left>") 'previous-multiframe-window)
(global-set-key (kbd "C-c C-g") 'google-this-noconfirm)

;; Stop polluting the directory with auto-saved files and backup
(setq auto-save-default nil)
(setq make-backup-files nil)
(setq auto-save-list-file-prefix nil)

;; Project Sugar
(projectile-mode +1)

;; Initialize my `exec-path' and `load-path' with custom paths
(exec-path-from-shell-initialize)
(add-to-list 'exec-path "/usr/local/bin")
(add-to-list 'exec-path "/opt/homebrew/bin")

;; Snappy Movement
(global-set-key (kbd "M-n") 'forward-paragraph)
(global-set-key (kbd "M-p") 'backward-paragraph)

;; Load into Repositories by default
(let ((default-directory "~/Repositories/"))
  (normal-top-level-add-subdirs-to-load-path))

;; The default is to wait 1 second, which I find a bit long
(setq echo-keystrokes 0.1)

;; No Alarms by default.
(setq ring-bell-function 'ignore)

;; No scrollbar by default.
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;; The t parameter apends to the hook, instead of prepending
;; this means it'd be run after other hooks that might fiddle
;; with the frame size
(add-hook 'window-setup-hook 'toggle-frame-maximized t)

;; No toolbar by default.
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

;; Transparent title Bar
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))

;; Battery
(display-battery-mode t)

;; Time
(display-time-mode 1)

;; Highlight Paren
(show-paren-mode t)

;; Drag Stuff: https://github.com/rejeep/drag-stuff.el
(drag-stuff-global-mode 1)
(drag-stuff-define-keys)

;; Debug on Error
(setq debug-on-error t)

;; Go-to Line Preview: https://github.com/emacs-vs/goto-line-preview
(global-set-key [remap goto-line] 'goto-line-preview)

;; Tabs & Ribbons:  https://github.com/tarsius/moody
(use-package moody
  :ensure t
  :config
  (setq x-underline-at-descent-line t)

  (setq-default mode-line-format
                '(" "
                  mode-line-front-space
                  mode-line-client
                  mode-line-frame-identification
                  mode-line-buffer-identification " " mode-line-position
                  (vc-mode vc-mode)
                  (multiple-cursors-mode mc/mode-line)
                  " " mode-line-modes
                  mode-line-end-spaces))

  (setq global-mode-string (remove 'display-time-string global-mode-string))

  (moody-replace-mode-line-buffer-identification)
  (moody-replace-vc-mode))

;; Use y/n instead of yes/no confirms.
;; From http://pages.sachachua.com/.emacs.d/Sacha.html#sec-1-4-8
(fset 'yes-or-no-p 'y-or-n-p)

(use-package fullframe
  :ensure t
  :defer)

(use-package face-remap
  :bind(("C-+" . text-scale-increase)
        ("C--" . text-scale-decrease)))

;; Ivy, Counsel, & Helm: https://github.com/abo-abo/swiper
(ivy-mode)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
;; enable this if you want `swiper' to use it
(setq search-default-mode #'char-fold-to-regexp)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> o") 'counsel-describe-symbol)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)

;;========================================================================
;; LOOK AND FEEL 🎨
;;========================================================================

;; Display Icons when Packages Need Them
(use-package all-the-icons
  :if (display-graphic-p))

;; Display Page Breaks
(page-break-lines-mode)

;; Disable Line Mode in Neotree & Toggle it on TAB
(add-hook 'neotree-mode-hook #'hide-mode-line-mode)
(global-set-key (kbd "<f8>") #'neotree-toggle)
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))
(setq-default neo-show-hidden-files t)

;; Beacon mode: https://github.com/Malabarba/beacon
(setq beacon-size 80)
(setq beacon-color 0.6)

;; Sublimity: https://github.com/zk-phi/sublimity
(require 'sublimity)
;; Very buggy & experimental
;;(require 'sublimity-map)
(require 'sublimity-attractive)

(sublimity-mode 1)

(setq sublimity-scroll-weight 10
      sublimity-scroll-drift-length 5)

;; To be uncommented when it's less buggy :)
;; Currently using minimap
(global-set-key (kbd "<f9>") #'minimap-mode)
;; (setq sublimity-map-size 20)
;; (setq sublimity-map-fraction 0.3)
;; (setq sublimity-map-text-scale -7)
;; (sublimity-map-set-delay 1)

;; https://github.com/TeMPOraL/nyan-mode
(use-package nyan-mode
  :ensure t
  :defer 20
  :if (display-graphic-p)
  :config
  (nyan-mode +1))

(nyan-mode 1)
(setq nyan-wavy-trail t)

(require 'zone)
(require 'zone-rainbow)
(setq zone-programs [zone-rainbow])
(zone-when-idle 90)

(when (display-graphic-p)
  ;; No title. See init.el for initial value.
  (setq-default frame-title-format nil)
  ;; Hide the cursor in inactive windows.
  (setq cursor-in-non-selected-windows nil)
  ;; Avoid native dialogs.
  (setq use-dialog-box nil))

;; https://github.com/cpaulik/emacs-material-theme
(use-package material-theme
  :ensure t
  :config
  (load-theme 'material t)
  (ar/load-material-org-tweaks)
  :init
  (defun ar/load-material-org-present-tweaks ()
    (with-eval-after-load 'frame
      (set-cursor-color "#2BA3FF"))

    (with-eval-after-load 'faces
      (set-face-attribute 'org-level-1 nil :foreground "#ff69b4" :background nil :box nil)
      (set-face-attribute 'org-level-2 nil :inherit 'lisp-extra-font-lock-quoted :foreground nil :background nil :box nil)
      (set-face-attribute 'org-block nil :background "grey11" :box nil)))

  (defun ar/drop-material-org-present-tweaks ()
    (with-eval-after-load 'frame
      (set-cursor-color "orange"))

    (with-eval-after-load 'faces
      (set-face-attribute 'org-level-1 nil :foreground nil :background nil :box nil)
      (set-face-attribute 'org-level-2 nil :inherit nil :foreground nil :background nil :box nil)
      (set-face-attribute 'org-block nil :background nil :box nil)))

  (defun ar/load-material-org-tweaks ()
    (with-eval-after-load 'frame
      (set-cursor-color "orange"))
    
    (with-eval-after-load 'faces
      (set-face-attribute 'header-line nil :background "#212121" :foreground "dark grey")
      (set-face-attribute 'default nil :stipple nil :background "#212121" :foreground "#eeffff" :inverse-video nil
			  :height 120 :font "Fira Code"
                          :box nil :strike-through nil :overline nil :underline nil :slant 'normal :weight 'ultra-light
                          :width 'normal :foundry "nil")

      ;; Enable rendering SF symbols on macOS.
      (when (memq system-type '(darwin))
        (set-fontset-font t nil "SF Pro Display" nil 'append))

      ;; Emoji's: welcome back to Emacs
      ;; https://github.crookster.org/emacs27-from-homebrew-on-macos-with-emoji/
      (when (>= emacs-major-version 27)
        (set-fontset-font t 'symbol (font-spec :family "Apple Color Emoji") nil 'prepend))

      ;; Hardcode region theme color.
      (set-face-attribute 'region nil :background "#3f464c" :foreground "#eeeeec" :underline nil)
      (set-face-attribute 'mode-line nil :background "#191919" :box nil)

      ;; Styling moody https://github.com/tarsius/moody
      (let ((line (face-attribute 'mode-line :underline)))
        (set-face-attribute 'mode-line nil :overline   line)
        (set-face-attribute 'mode-line-inactive nil :overline   line)
        (set-face-attribute 'mode-line-inactive nil :underline  line)
        (set-face-attribute 'mode-line nil :box nil)
        (set-face-attribute 'mode-line-inactive nil :box nil)
        (set-face-attribute 'mode-line-inactive nil :background "#212121" :foreground "#5B6268")))

    (with-eval-after-load 'font-lock
      (set-face-attribute 'font-lock-constant-face nil :foreground "#C792EA")
      (set-face-attribute 'font-lock-keyword-face nil :foreground "#2BA3FF" :slant 'italic)
      (set-face-attribute 'font-lock-preprocessor-face nil :inherit 'bold :foreground "#2BA3FF" :slant 'italic :weight 'normal)
      (set-face-attribute 'font-lock-string-face nil :foreground "#C3E88D")
      (set-face-attribute 'font-lock-type-face nil :foreground "#FFCB6B")
      (set-face-attribute 'font-lock-variable-name-face nil :foreground "#FF5370"))

    (with-eval-after-load 'em-prompt
      (set-face-attribute 'eshell-prompt nil :foreground "#eeffff"))

    (with-eval-after-load 'company
      (set-face-attribute 'company-preview-search nil :foreground "sandy brown" :background nil)
      (set-face-attribute 'company-preview-common nil :inherit 'default :foreground nil :background "#212121"))

    (with-eval-after-load 'company-box
      (set-face-attribute 'company-box-candidate  nil :inherit 'default :foreground "#eeffff" :background "#212121" :box nil)
      (set-face-attribute 'company-box-background nil :inherit 'default :background "#212121" :box nil)
      (set-face-attribute 'company-box-annotation nil :inherit 'company-tooltip-annotation :background "#212121" :foreground "dim gray")
      (set-face-attribute 'company-box-selection nil :inherit 'company-tooltip-selection :foreground "sandy brown"))

    (with-eval-after-load 'popup
      (set-face-attribute 'popup-menu-face nil
                          :foreground (face-foreground 'default)
                          :background (face-background 'default))
      (set-face-attribute 'popup-menu-selection-face nil
                          :foreground "sandy brown"
                          :background "dim gray"))

    (with-eval-after-load 'paren
      (set-face-attribute 'show-paren-match nil
                          :background nil
                          :foreground "#FA009A"))

    (with-eval-after-load 'org-indent
      (set-face-attribute 'org-indent nil :background "#212121"))

    (with-eval-after-load 'org-faces
      (set-face-attribute 'org-hide nil :foreground "#212121" :background "#212121" :strike-through nil)
      (set-face-attribute 'org-done nil :foreground "#b9ccb2" :strike-through nil)
      (set-face-attribute 'org-agenda-date-today nil :foreground "#Fb1d84")
      (set-face-attribute 'org-agenda-done nil :foreground "#b9ccb2" :strike-through nil)
      (set-face-attribute 'org-table nil :background nil)
      (set-face-attribute 'org-code nil :background nil)
      (set-face-attribute 'org-level-1 nil :background nil :box nil)
      (set-face-attribute 'org-level-2 nil :background nil :box nil)
      (set-face-attribute 'org-level-3 nil :background nil :box nil)
      (set-face-attribute 'org-level-4 nil :background nil :box nil)
      (set-face-attribute 'org-level-5 nil :background nil :box nil)
      (set-face-attribute 'org-level-6 nil :background nil :box nil)
      (set-face-attribute 'org-level-7 nil :background nil :box nil)
      (set-face-attribute 'org-level-8 nil :background nil :box nil)
      (set-face-attribute 'org-block-begin-line nil :background nil :box nil)
      (set-face-attribute 'org-block-end-line nil :background nil :box nil)
      (set-face-attribute 'org-block nil :background nil :box nil))

    (with-eval-after-load 'mu4e-vars
      (set-face-attribute 'mu4e-header-highlight-face nil :inherit 'default :foreground "sandy brown" :weight 'bold :background nil)
      (set-face-attribute 'mu4e-unread-face nil :inherit 'default :weight 'bold :foreground "#2BA3FF" :underline nil))

    ;; No color for fringe, blends with the rest of the window.
    (with-eval-after-load 'fringe
      (set-face-attribute 'fringe nil
                          :foreground (face-foreground 'default)
                          :background (face-background 'default)))

    ;; No color for sp-pair-overlay-face.
    (with-eval-after-load 'smartparens
      (set-face-attribute 'sp-pair-overlay-face nil
                          :foreground (face-foreground 'default)
                          :background (face-background 'default)))

    ;; Remove background so it doesn't look selected with region.
    ;; Make the foreground the same as `diredfl-flag-mark' (ie. orange).
    (with-eval-after-load 'diredfl
      (set-face-attribute 'diredfl-flag-mark-line nil
                          :foreground "orange"
                          :background nil))

    (with-eval-after-load 'dired-subtree
      (set-face-attribute 'dired-subtree-depth-1-face nil
                          :background nil)
      (set-face-attribute 'dired-subtree-depth-2-face nil
                          :background nil)
      (set-face-attribute 'dired-subtree-depth-3-face nil
                          :background nil)
      (set-face-attribute 'dired-subtree-depth-4-face nil
                          :background nil)
      (set-face-attribute 'dired-subtree-depth-5-face nil
                          :background nil)
      (set-face-attribute 'dired-subtree-depth-6-face nil
                          :background nil))

    ;; Trying out line underline (instead of wave).
    (mapatoms (lambda (atom)
                (let ((underline nil))
                  (when (and (facep atom)
                             (setq underline
                                   (face-attribute atom
                                                   :underline))
                             (eq (plist-get underline :style) 'wave))
                    (plist-put underline :style 'line)
                    (set-face-attribute atom nil
                                        :underline underline)))))))

;; ========================================================================
;; FIRA CODE TYPEFACE 🔤
;; ========================================================================

;; Enable the www ligature in every possible major mode
(ligature-set-ligatures 't '("www"))

;; Enable ligatures in programming modes                                                           
(ligature-set-ligatures 'prog-mode '("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\" "{-" "::"
                                     ":::" ":=" "!!" "!=" "!==" "-}" "----" "-->" "->" "->>"
                                     "-<" "-<<" "-~" "#{" "#[" "##" "###" "####" "#(" "#?" "#_"
                                     "#_(" ".-" ".=" ".." "..<" "..." "?=" "??" ";;" "/*" "/**"
                                     "/=" "/==" "/>" "//" "///" "&&" "||" "||=" "|=" "|>" "^=" "$>"
                                     "++" "+++" "+>" "=:=" "==" "===" "==>" "=>" "=>>" "<="
                                     "=<<" "=/=" ">-" ">=" ">=>" ">>" ">>-" ">>=" ">>>" "<*"
                                     "<*>" "<|" "<|>" "<$" "<$>" "<!--" "<-" "<--" "<->" "<+"
                                     "<+>" "<=" "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<=" "<<<"
                                     "<~" "<~~" "</" "</>" "~@" "~-" "~>" "~~" "~~>" "%%"))

(global-ligature-mode 't)

;; ========================================================================
;; DASHBOARD 🧭
;; ========================================================================

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))

(add-hook 'dashboard-mode-hook #'hide-mode-line-mode)

;; Set the title
(setq dashboard-banner-logo-title "👩‍💻 Gina's Emacs Editor 💖")

;; Set the banner
(setq dashboard-startup-banner "/Users/gina.maini/.emacs.d/emacs-desktop-background.gif")

;; Content is not centered by default. To center, set
(setq dashboard-center-content t)
(setq dashboard-set-navigator t)
(setq dashboard-page-separator "\n\f\n")


(setq dashboard-navigator-buttons
      `(;; line1
        ((,(all-the-icons-octicon "mark-github" :height 1.1 :v-adjust 0.0 :face 'dashboard-navigator)
         "wiredsister"
         "Github Home"
         (lambda (&rest _) (browse-url "https://github.com/wiredsister")))
         ("λ" "Hacker News" "Browse Hacker News" (lambda (&rest _) (browse-url "https://news.ycombinator.com/")))
	 ("🎧" "Lo-Fi" "Listen to Lo-Fi Music" (lambda (&rest _) (browse-url "https://www.lofiatc.com/")))
	 ("📰" "Daily Beast" "news" (lambda (&rest _) (browse-url "https://dailybeast.com/cheat-sheet"))))
         ;; line 2
        ((,(all-the-icons-faicon "medium" :height 1.1 :v-adjust 0.0 :face 'dashboard-navigator)
          "Medium Blog"
          "Medium Blog"
          (lambda (&rest _) (browse-url "https://wiredsis.medium.com")))
	 ("🃏" "Dominion" "Dominion Card Game Online" (lambda (&rest _) (browse-url "https://dominion.games")))
	 ("🤖" "Chat GPT" "Open AI: Chat GPT" (lambda (&rest _) (browse-url "https://chat.openai.com/")))
	 (,(all-the-icons-faicon "trello" :height 1.1 :v-adjust 0.0 :face 'dashboard-navigator)
          "Trello Board"
          "TODOs"
          (lambda (&rest _) (browse-url "https://trello.com/b/E3ZBVw7z/life")))
	 )))


;; Set dashboard items
(setq dashboard-items '((recents  . 5)
                        (bookmarks . 5)
                        (projects . 5)
			(agenda . 5)))

;; To disable shortcut "jump" indicators for each section, set
(setq dashboard-show-shortcuts nil)

;; To add icons to the widget headings and their items
(setq dashboard-set-heading-icons t)
(setq dashboard-set-file-icons t)

;; Projects with Counsel
(setq dashboard-projects-switch-function 'counsel-projectile-switch-project-by-name)

;; ==================================================================
;; PROGRAMMING LANGUAGE & FILE TYPE SPECIFICS 🈴
;; ==================================================================

;; Company Mode Everywhere
(add-hook 'after-init-hook 'global-company-mode)

;; FSharp

(add-to-list 'auto-minor-mode-alist '("\\.fs?\\'" . beacon-mode))

(use-package eglot-fsharp
  :ensure t)

(use-package fsharp-mode
  :defer t
  :ensure t)

(add-hook 'fsharp-mode-hook 'highlight-indentation-mode)

(setq-default fsharp-indent-offset 4)

;; Markdown
(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))

;; Git Delta Views
(use-package magit-delta
  :hook (magit-mode . magit-delta-mode))

;; Ruby: https://worace.works/2016/06/07/getting-started-with-emacs-for-ruby

(global-rbenv-mode)
(rbenv-use-global)

;; Optional -- if your RBENV installation is located somewhere besides
;; ~/.rbenv, you will need to configure this:
;;(setq rbenv-installation-dir "/usr/local/rbenv")

;; Skeletons definitions for common includes.
(define-skeleton my-org-defaults
  "Org defaults I use"
  nil
  "#+AUTHOR:   Gina Maini\n"
  "#+EMAIL:    ginaandthecats@gmail.com\n"
  "#+LANGUAGE: en\n"
  "#+LATEX_HEADER: \\usepackage{lmodern}\n"
  "#+LATEX_HEADER: \\usepackage[T1]{fontenc}\n"
  "#+OPTIONS:  toc:nil num:0\n"
  "An introduction.\n"
  "* A Heading\n"
  "Some text.\n"
  "** Sub-Topic 1\n"
  "** Sub-Topic 2\n"
  "*** Additional entry\n")

(define-skeleton my-html-defaults
  "Minimum HTML needed"
  nil
  "<!DOCTYPE html>\n"
  "<html>\n"
  "<head>\n"
  "<html lang=\"en\">\n"
  "<meta charset=\"utf-8\">\n"
  "<title>Work In Progress</title>\n"
  "<meta name=\"keywords\" content=\"HTML, CSS, JavaScript\">\n"
  "<meta name=\"description\" content=\"HTML5\">\n"
  "<meta name=\"author\" content=\"Gina Maini\">\n"
  "<link rel=\"stylesheet\" href=\"css/styles.css?v=1.0\">\n"
  "<!--[if lt IE 9]>\n"
  "<script src=\"http://html5shiv.googlecode.com/svn/trunk/html5.js\"></script>\n"
  "<![endif]-->\n"
  "</head>\n"
  "<body>\n"
  "<script src=\"js/scripts.js\"></script>\n"
  "</body>\n"
  "</html>\n")

(define-skeleton my-js-defaults
  "strict mode declaration for js"
  nil
  "\"use strict\";\n")

;; Org Mode
(with-eval-after-load 'org (global-org-modern-mode))

(define-auto-insert "\\.org\\'" 'my-org-defaults)
(add-to-list 'auto-minor-mode-alist '("\\.org?\\'" . beacon-mode))

(setq org-agenda-files (list "~/Documents/Notes/Life.org" "~/Documents/Notes/SprintWork.org"))

(setq
 ;; Edit settings
 org-auto-align-tags nil
 org-tags-column 0
 org-catch-invisible-edits 'show-and-error
 org-special-ctrl-a/e t
 org-insert-heading-respect-content t

 ;; Org styling, hide markup etc.
 org-hide-emphasis-markers t
 org-pretty-entities t
 org-ellipsis "…"

 ;; Agenda styling
 org-agenda-tags-column 0
 org-agenda-block-separator ?─
 org-agenda-time-grid
 '((daily today require-timed)
   (800 1000 1200 1400 1600 1800 2000)
   " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
 org-agenda-current-time-string
 "⭠ now ─────────────────────────────────────────────────")

;; Web Development

(define-auto-insert "\\.html\\'" 'my-html-defaults)
(define-auto-insert "\\.js\\'" 'my-js-defaults)

(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-minor-mode-alist '("\\.html?\\'" . rainbow-mode))
(add-to-list 'auto-minor-mode-alist '("\\.html?\\'" . beacon-mode))

(add-to-list 'auto-mode-alist '("\\.js?\\'" . web-mode))
(add-to-list 'auto-minor-mode-alist '("\\.js?\\'" . rainbow-mode))
(add-to-list 'auto-minor-mode-alist '("\\.js?\\'" . beacon-mode))

(add-to-list 'auto-mode-alist '("\\.css?\\'" . web-mode))
(add-to-list 'auto-minor-mode-alist '("\\.css?\\'" . rainbow-mode))
(add-to-list 'auto-minor-mode-alist '("\\.css?\\'" . beacon-mode))

(add-to-list 'auto-mode-alist '("\\.scss?\\'" . web-mode))
(add-to-list 'auto-minor-mode-alist '("\\.scss?\\'" . rainbow-mode))
(add-to-list 'auto-minor-mode-alist '("\\.scss?\\'" . beacon-mode))

(add-to-list 'auto-mode-alist '("\\.sass?\\'" . web-mode))
(add-to-list 'auto-minor-mode-alist '("\\.sass?\\'" . rainbow-mode))
(add-to-list 'auto-minor-mode-alist '("\\.sass?\\'" . beacon-mode))


;; Just for editing elisp init files

(add-to-list 'auto-minor-mode-alist '("\\.el?\\'" . rainbow-mode))
(add-to-list 'auto-minor-mode-alist '("\\.el?\\'" . beacon-mode))

;; OCaml Development

(add-to-list 'auto-minor-mode-alist '("\\.ml?\\'" . beacon-mode))
(setq tuareg-match-patterns-aligned t)
(add-hook 'tuareg-mode-hook
          (lambda() (setq tuareg-mode-name "🐫")))

;; Ruby Development

(add-to-list 'auto-mode-alist
             '("\\.\\(?:cap\\|gemspec\\|irbrc\\|gemrc\\|rake\\|rb\\|ru\\|thor\\)\\'" . ruby-mode))
(add-to-list 'auto-minor-mode-alist
             '("\\.\\(?:cap\\|gemspec\\|irbrc\\|gemrc\\|rake\\|rb\\|ru\\|thor\\)\\'" . beacon-mode))
(add-to-list 'auto-mode-alist
             '("\\(?:Brewfile\\|Capfile\\|Gemfile\\(?:\\.[a-zA-Z0-9._-]+\\)?\\|[rR]akefile\\)\\'" . ruby-mode))
(add-to-list 'auto-minor-mode-alist
             '("\\(?:Brewfile\\|Capfile\\|Gemfile\\(?:\\.[a-zA-Z0-9._-]+\\)?\\|[rR]akefile\\)\\'" . beacon-mode))


;; Used when exporting org source blocks.
(use-package github-modern-theme
  :defer
  :ensure t)

;; ==================================================================
;; CUSTOM VARS 🔌
;; ==================================================================

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(highlight-indentation flycheck dashboard zone-rainbow fireplace zones company-quickhelp latex-unicode-math-mode counsel swiper ivy drag-stuff rbenv ruby-electric helm-ag helm-projectile helm minimap goto-line-preview auto-minor-mode beacon sublimity github-modern-theme utop company tuareg eglot-fsharp fsharp-mode merlin web-mode magit-delta markdown-mode magit org-modern ligature rainbow-mode page-break-lines projectile all-the-icons minions nyan-mode menu-bar frame fira-code-mode use-package moody material-theme hide-mode-line github-theme fullframe)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
