;;;---------------------------------------------------------------------
;;; Startup & Performance Optimizations
;;;---------------------------------------------------------------------

;; Save original file-name-handler-alist and disable it for faster startup
(defvar my/original-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

;; Restore file-name-handler-alist after startup
(add-hook 'after-init-hook
          (lambda ()
            (setq file-name-handler-alist my/original-file-name-handler-alist)))

;; Additional performance tweaks
(setq fast-but-imprecise-scrolling t
      auto-window-vscroll nil
      inhibit-compacting-font-caches t
      read-process-output-max (* 1024 1024)) ; helps with LSP performance

;; Disable bidirectional text scanning
(setq-default bidi-paragraph-direction 'left-to-right)
(setq bidi-inhibit-bpa t)

;;;---------------------------------------------------------------------
;;; GCMH Configuration
;;;---------------------------------------------------------------------
(use-package! gcmh
  :init
  ;; We'll let GCMH handle the GC thresholds entirely.
  ;; Set startup thresholds high to speed up initialization.
  (setq gcmh-idle-delay 10                 ; Delay before going idle
        gcmh-high-cons-threshold (* 512 1024 1024) ; 512MB idle threshold
        gcmh-low-cons-threshold (* 256 1024 1024)  ; 256MB after init (final threshold)
        gcmh-verbose nil)
  :config
  ;; Set gc-cons-percentage to 0.1 after startup to match original config.
  (add-hook 'emacs-startup-hook (lambda () (setq gc-cons-percentage 0.1)))
  (gcmh-mode 1))

;;;---------------------------------------------------------------------
;;; Core Emacs Improvements
;;;---------------------------------------------------------------------
(setq read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-ignore-case t)

;; LSP performance improvements
(setq lsp-idle-delay 0.500
      lsp-log-io nil
      lsp-completion-provider :capf)

;;;---------------------------------------------------------------------
;;; Personal Information & Theme
;;;---------------------------------------------------------------------
(setq user-full-name "Connor Frank"
      user-mail-address "conjfrnk@gmail.com")

(setq doom-theme 'doom-gruvbox)

;;;---------------------------------------------------------------------
;;; Backups & Autosaves
;;;---------------------------------------------------------------------
(setq auto-save-default t
      make-backup-files t)

;;;---------------------------------------------------------------------
;;; Display & Line Numbers
;;;---------------------------------------------------------------------
(setq display-line-numbers-type 'relative)

(global-auto-revert-mode t)
(when (eq system-type 'gnu/linux)
  (pixel-scroll-precision-mode 1))

;;;---------------------------------------------------------------------
;;; Org Configuration (Consolidated)
;;;---------------------------------------------------------------------
(after! org
  ;; General Org setup
  (setq org-directory "~/Notes/org/"
        org-track-ordered-property-with-tag t
        org-agenda-log-mode-items '(closed clock state)
        org-use-property-inheritance t
        org-startup-with-inline-images t
        org-hide-emphasis-markers t
        org-edit-src-content-indentation 0
        org-startup-with-latex-preview t)

  ;; Lazy load org-agenda-files
  (defvar my/org-agenda-files-loaded nil "Track if agenda files are loaded.")
  (defun my/lazy-load-org-agenda-files ()
    "Load org-agenda-files just before org-agenda is called."
    (unless my/org-agenda-files-loaded
      (setq org-agenda-files
            (append (directory-files-recursively "~/Notes/org/" "\\.org$")
                    (directory-files-recursively "~/Notes/org/roam/" "\\.org$")))
      (setq my/org-agenda-files-loaded t)))

  (advice-add 'org-agenda :before #'my/lazy-load-org-agenda-files)

  ;; Custom faces for Org
  (custom-set-faces!
    `((org-document-title)
      :foreground ,(face-attribute 'org-document-title :foreground)
      :height 1.3 :weight bold)
    `((org-level-1)
      :foreground ,(face-attribute 'outline-1 :foreground)
      :height 1.1 :weight medium)
    `((org-level-2)
      :foreground ,(face-attribute 'outline-2 :foreground)
      :weight medium)
    `((org-level-3)
      :foreground ,(face-attribute 'outline-3 :foreground)
      :weight medium)
    `((org-level-4)
      :foreground ,(face-attribute 'outline-4 :foreground)
      :weight medium)
    `((org-level-5)
      :foreground ,(face-attribute 'outline-5 :foreground)
      :weight medium))

  ;; Additional LaTeX packages in Org
  (add-to-list 'org-latex-packages-alist '("" "amsmath" t))
  (add-to-list 'org-latex-packages-alist '("" "amssymb" t))
  (add-to-list 'org-latex-packages-alist '("" "mathtools" t))
  (add-to-list 'org-latex-packages-alist '("" "mathrsfs" t))
  )

;;;---------------------------------------------------------------------
;;; Org-Latex-Preview
;;;---------------------------------------------------------------------
(use-package! org-latex-preview
  :after org
  :defer t
  :config
  (plist-put org-latex-preview-appearance-options :page-width 0.8)
  (add-hook 'org-mode-hook 'org-latex-preview-auto-mode)
  (setq org-latex-preview-auto-ignored-commands
        '(next-line previous-line mwheel-scroll scroll-up-command scroll-down-command)
        org-latex-preview-numbered t
        org-latex-preview-live t
        org-latex-preview-live-debounce 0.25))

;;;---------------------------------------------------------------------
;;; Org-Modern for Visual Enhancements
;;;---------------------------------------------------------------------
(use-package! org-modern
  :after org
  :defer t
  :hook (org-mode . org-modern-mode) ;; Enable only in Org buffers
  :config
  (setq org-auto-align-tags t
        org-tags-column 0
        org-fold-catch-invisible-edits 'show-and-error
        org-special-ctrl-a/e t
        org-insert-heading-respect-content t
        org-agenda-tags-column 0
        org-agenda-block-separator ?─
        org-agenda-time-grid '((daily today require-timed)
                               (800 1000 1200 1400 1600 1800 2000)
                               " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
        org-agenda-current-time-string "⭠ now ─────────────────────────────────────────────────"))
;;;---------------------------------------------------------------------
;;; Org-Roam Configuration
;;;---------------------------------------------------------------------

;; Define this function before use-package so it can be autoloaded and used anywhere.
(defun my/org-roam-node-find-no-archive ()
  "Find an org-roam node excluding those with the 'archive' tag."
  (interactive)
  (org-roam-node-find nil nil
                      (lambda (node)
                        (not (member "archive" (org-roam-node-tags node))))))

(use-package! org-roam
  ;; We don't use :after org here, because we want org-roam commands available at any time.
  ;; org-roam will autoload org if necessary.
  :commands (org-roam-node-find
             my/org-roam-node-find-no-archive
             org-roam-node-insert
             org-roam-capture
             org-roam-buffer-toggle
             org-roam-dailies-capture-today
             org-mark-ring-goto)
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . my/org-roam-node-find-no-archive)
         ("C-c n F" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ("C-c n j" . org-roam-dailies-capture-today)
         ("C-c n a" . my/org-roam-archive-note)
         ("C-c b"   . org-mark-ring-goto))
  :init
  (setq org-roam-directory (file-truename "~/Notes/org/roam/")
        org-roam-database-connector 'sqlite3
        org-roam-node-display-template (concat "${title:*} "
                                               (propertize "${tags:10}" 'face 'org-tag))
        org-roam-file-extensions '("org"))
  :config
  (org-roam-db-autosync-mode 1)

  (defun my/get-class-slugs ()
    (mapcar (lambda (node) (org-roam-node-slug node))
            (cl-remove-if-not
             (lambda (node)
               (and (member "class" (org-roam-node-tags node))
                    (not (member "archive" (org-roam-node-tags node)))))
             (org-roam-node-list))))

  (defun my/select-class-tags ()
    (let ((class-slugs (my/get-class-slugs)))
      (if class-slugs
          (let ((selected (completing-read-multiple "Select class: " class-slugs nil t)))
            (if selected
                (concat ":" (string-join selected ":") ":")
              ""))
        "")))

  (defun my/org-roam-archive-note ()
    (interactive)
    (let* ((orig-file (buffer-file-name))
           (orig-dir (file-name-directory orig-file))
           (archive-dir (expand-file-name "archive/" org-roam-directory))
           (new-dir (replace-regexp-in-string (regexp-quote (expand-file-name org-roam-directory))
                                              archive-dir orig-dir))
           (new-file (expand-file-name (file-name-nondirectory orig-file) new-dir)))
      (unless (file-directory-p new-dir)
        (make-directory new-dir t))
      (save-excursion
        (goto-char (point-min))
        (if (re-search-forward "^#\\+filetags:" nil t)
            (progn (end-of-line) (insert " :archive:"))
          (insert "#+filetags: :archive:\n")))
      (save-buffer)
      (when (file-exists-p orig-file)
        (rename-file orig-file new-file t))
      (find-file new-file)
      (org-roam-db-sync)
      (message "Archived '%s'" new-file)))

  (setq org-roam-capture-templates
        '(("p" "Project" plain "%?"
           :target (file+head "projects/${slug}.org"
                              "#+title: ${title}\n#+filetags: :project:\n\n")
           :unnarrowed t)
          ("a" "Area" plain "%?"
           :target (file+head "areas/${slug}.org"
                              "#+title: ${title}\n#+filetags: :area:\n\n")
           :unnarrowed t)
          ("r" "Resource" plain "%?"
           :target (file+head "resources/${slug}.org"
                              "#+title: ${title}\n#+filetags: :resource:\n\n")
           :unnarrowed t)
          ("A" "Archive" plain "%?"
           :target (file+head "archive/${slug}.org"
                              "#+title: ${title}\n#+filetags: :archive:\n\n")
           :unnarrowed t)
          ("z" "Zettel" plain "%?"
           :target (file+head "resources/zettels/${slug}.org"
                              "#+title: ${title}\n#+filetags: :zettel:\n\n")
           :unnarrowed t)
          ("c" "Class (Project)" plain "%?"
           :target (file+head "projects/classes/${slug}.org"
                              "#+title: ${title}\n#+filetags: :project:class:${slug}:\n\n")
           :unnarrowed t)
          ("n" "Note" plain "%?"
           :target (file+head "notes/${slug}.org"
                              "#+title: ${title}\n#+filetags: :note:${slug}:%(my/select-class-tags)\n\n")
           :immediate-finish nil
           :unnarrowed t
           :after-finalize (lambda (&rest _)
                             (org-mode)
                             (font-lock-ensure)
                             (when (fboundp 'doom/reload-font)
                               (doom/reload-font))
                             (when (fboundp 'doom-init-themes-h)
                               (doom-init-themes-h)))))))

;;;---------------------------------------------------------------------
;;; Obsidian Configuration
;;;---------------------------------------------------------------------
(use-package! obsidian
  :after org
  :defer t
  :commands (obsidian-follow-link-at-point obsidian-insert-wikilink obsidian-backlink-jump
                                           obsidian-jump obsidian-capture obsidian-daily-note obsidian-mode)
  :config
  (obsidian-specify-path "~/Notes/obsidian")
  (setq obsidian-inbox-directory "Inbox")
  (map! :map obsidian-mode-map
        "C-c C-o" #'obsidian-follow-link-at-point
        "C-c C-l" #'obsidian-insert-wikilink
        "C-c C-b" #'obsidian-backlink-jump)
  (map! "C-c o" #'obsidian-jump
        "C-c c" #'obsidian-capture
        "C-c d" #'obsidian-daily-note)
  (global-obsidian-mode +1))

;;;---------------------------------------------------------------------
;;; Evil Configuration
;;;---------------------------------------------------------------------
(use-package! evil-escape
  :config
  (setq evil-escape-key-sequence "kj"
        evil-escape-unordered-key-sequence t))

(map! :nv ";" #'evil-ex
      :nv ":" #'evil-repeat-find-char
      :nv "," #'evil-repeat-find-char-reverse)

;;;---------------------------------------------------------------------
;;; VTerm Configuration
;;;---------------------------------------------------------------------
(use-package vterm
  :commands vterm
  :defer t)

;;;---------------------------------------------------------------------
;;; Ispell Configuration
;;;---------------------------------------------------------------------
(after! ispell
  (setq ispell-program-name "hunspell"
        ispell-dictionary "en_US"
        ispell-hunspell-dictionary-alist
        '(("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US") nil utf-8))))

;;;---------------------------------------------------------------------
;;; Yasnippet Configuration
;;;---------------------------------------------------------------------
(after! yasnippet
  (setq yas-snippet-revival nil))

;;;---------------------------------------------------------------------
;;; LaTeX & CDLaTeX Configuration
;;;---------------------------------------------------------------------
(map! :map cdlatex-mode-map
      :i "TAB" #'cdlatex-tab)
(map! :after latex
      :map cdlatex-mode-map
      :localleader
      :desc "Insert math symbol"
      "i" #'cdlatex-math-symbol
      :desc "Begin environment"
      "e" #'cdlatex-environment)

;;;---------------------------------------------------------------------
;;; Python Formatting with Black
;;;---------------------------------------------------------------------
(use-package! blacken
  :defer t
  :hook (python-mode . blacken-mode)
  :config
  (setq blacken-line-length 79))

;;;---------------------------------------------------------------------
;;; Display Fill Column Indicator at 79 Characters
;;;---------------------------------------------------------------------
(setq-default fill-column 79)
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)

;;;---------------------------------------------------------------------
;;; End of Configuration
;;;---------------------------------------------------------------------
