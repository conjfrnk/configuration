;; Performance improvements
(use-package! gcmh
  :init
  ;; Increase garbage collection threshold during startup
  (setq gc-cons-threshold most-positive-fixnum
        gc-cons-percentage 0.6)

  ;; More aggressive settings for GCMH
  (setq gcmh-idle-delay 10  ; slightly longer idle delay
        gcmh-high-cons-threshold (* 512 1024 1024)  ; 512MB during idle
        gcmh-verbose nil  ; reduce logging noise
        gcmh-low-cons-threshold (* 128 1024 1024))  ; 128MB active threshold
  :config
  ;; Start garbage collection mode
  (gcmh-mode 1)

  ;; Additional optimizations
  (add-hook! 'after-init-hook
    (setq gc-cons-threshold (* 256 1024 1024)))) ; 256MB after init

;; Faster file-name completion
(setq read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-ignore-case t)

;; Disable bidirectional text scanning
(setq-default bidi-paragraph-direction 'left-to-right)
(setq bidi-inhibit-bpa t)

;; LSP performance improvements
(setq lsp-idle-delay 0.500
      lsp-log-io nil
      lsp-completion-provider :capf)

;; Personal Information
(setq user-full-name "Connor Frank"
      user-mail-address "conjfrnk@gmail.com")

;; Theme Configuration
(setq doom-theme 'doom-gruvbox)

;; autosave and backup
(setq auto-save-default t
      make-backup-files t)

;; Line Numbers Configuration
(setq display-line-numbers-type 'relative)

;; Enable global auto-revert
(global-auto-revert-mode t)

(pixel-scroll-precision-mode 1)

;; Org Configuration
(after! org
  (setq org-directory "~/Notes/org/")
  (setq org-agenda-files
        (append (directory-files-recursively "~/Notes/org/" "\\.org$")
                (directory-files-recursively "~/Notes/org/roam/" "\\.org$")))
  (setq org-track-ordered-property-with-tag t)
  (setq org-agenda-log-mode-items '(closed clock state))
  (setq org-use-property-inheritance t) ; fix weird issue with src blocks
  (setq org-startup-with-inline-images t)
  (setq org-hide-emphasis-markers t)
  (setq org-edit-src-content-indentation 0)
  (setq org-startup-with-latex-preview t))

(after! org
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
      :weight medium)))

(after! org
  (add-to-list 'org-latex-packages-alist '("" "amsmath" t))
  (add-to-list 'org-latex-packages-alist '("" "amssymb" t))
  (add-to-list 'org-latex-packages-alist '("" "mathtools" t))
  (add-to-list 'org-latex-packages-alist '("" "mathrsfs" t)))

(use-package! org-latex-preview
  :after org
  :config
  (plist-put org-latex-preview-appearance-options
             :page-width 0.8)
  (add-hook 'org-mode-hook 'org-latex-preview-auto-mode)
  (setq org-latex-preview-auto-ignored-commands
        '(next-line previous-line mwheel-scroll
          scroll-up-command scroll-down-command))
  (setq org-latex-preview-numbered t)
  (setq org-latex-preview-live t)
  (setq org-latex-preview-live-debounce 0.25))


;; Function to find nodes excluding archives
(defun my/org-roam-node-find-no-archive ()
  (interactive)
  (org-roam-node-find nil nil
                      (lambda (node)
                        (not (member "archive" (org-roam-node-tags node))))))
(use-package! org-modern
  :after org
  :config
  (setq
   org-auto-align-tags t
   org-tags-column 0
   org-fold-catch-invisible-edits 'show-and-error
   org-special-ctrl-a/e t
   org-insert-heading-respect-content t

   ;; agenda
   org-agenda-tags-column 0
   org-agenda-block-separator ?─
   org-agenda-time-grid
   '((daily today require-timed)
     (800 1000 1200 1400 1600 1800 2000)
     " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
   org-agenda-current-time-string
   "⭠ now ─────────────────────────────────────────────────")

  (global-org-modern-mode))

;; Org-roam Configuration
(use-package! org-roam
  :custom
  (org-roam-directory (file-truename "~/Notes/org/roam/"))
  (org-roam-database-connector 'sqlite3)
  (org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-file-extensions '("org"))
  :bind
  (("C-c n l" . org-roam-buffer-toggle)
   ("C-c n f" . my/org-roam-node-find-no-archive)
   ("C-c n F" . org-roam-node-find)
   ;;("C-c n g" . org-roam-graph)
   ("C-c n i" . org-roam-node-insert)
   ("C-c n c" . org-roam-capture)
   ("C-c n j" . org-roam-dailies-capture-today)
   ("C-c n a" . my/org-roam-archive-note)
   ("C-c b"   . org-mark-ring-goto))
  :config

  (org-roam-db-autosync-mode 1)

  ;; Class tags functions
  (defun my/get-class-slugs ()
    (mapcar
     (lambda (node) (org-roam-node-slug node))
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

  ;; Archive function
  (defun my/org-roam-archive-note ()
    (interactive)
    (let* ((orig-file (buffer-file-name))
           (orig-dir (file-name-directory orig-file))
           (archive-dir (expand-file-name "archive/" org-roam-directory))
           (new-dir (replace-regexp-in-string (regexp-quote (expand-file-name org-roam-directory))
                                              archive-dir
                                              orig-dir))
           (new-file (expand-file-name (file-name-nondirectory orig-file) new-dir)))
      (unless (file-directory-p new-dir)
        (make-directory new-dir t))
      (save-excursion
        (goto-char (point-min))
        (if (re-search-forward "^#\\+filetags:" nil t)
            (progn
              (end-of-line)
              (insert " :archive:"))
          (insert "#+filetags: :archive:\n")))
      (save-buffer)
      (when (file-exists-p orig-file)
        (rename-file orig-file new-file t))
      (find-file new-file)
      (org-roam-db-sync)
      (message "Archived '%s'" new-file)))

  ;; Capture templates
  (setq org-roam-capture-templates
        '(("p" "Project" plain
           "%?"
           :target (file+head "projects/${slug}.org"
                              "#+title: ${title}\n#+filetags: :project:\n\n")
           :unnarrowed t)
          ("a" "Area" plain
           "%?"
           :target (file+head "areas/${slug}.org"
                              "#+title: ${title}\n#+filetags: :area:\n\n")
           :unnarrowed t)
          ("r" "Resource" plain
           "%?"
           :target (file+head "resources/${slug}.org"
                              "#+title: ${title}\n#+filetags: :resource:\n\n")
           :unnarrowed t)
          ("A" "Archive" plain
           "%?"
           :target (file+head "archive/${slug}.org"
                              "#+title: ${title}\n#+filetags: :archive:\n\n")
           :unnarrowed t)
          ("z" "Zettel" plain
           "%?"
           :target (file+head "resources/zettels/${slug}.org"
                              "#+title: ${title}\n#+filetags: :zettel:\n\n")
           :unnarrowed t)
          ("c" "Class (Project)" plain
           "%?"
           :target (file+head "projects/classes/${slug}.org"
                              "#+title: ${title}\n#+filetags: :project:class:${slug}:\n\n")
           :unnarrowed t)
          ("n" "Note" plain
           "%?"
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

;; Obsidian Configuration
(use-package! obsidian
  :after org
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

;; Evil Configuration
(use-package! evil-escape
  :config
  (setq evil-escape-key-sequence "kj"
        evil-escape-unordered-key-sequence t))

(map! :nv ";" #'evil-ex
      :nv ":" #'evil-repeat-find-char
      :nv "," #'evil-repeat-find-char-reverse)

;; VTerm Configuration
(use-package vterm
  :ensure t
  :commands vterm)

(after! ispell
  (setq ispell-program-name "hunspell")
  (setq ispell-dictionary "en_US")
  (setq ispell-hunspell-dictionary-alist
        '(("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US") nil utf-8))))

(after! yasnippet
  (setq yas-snippet-revival nil))

;; LaTeX
                                        ; use cdlatex completion instead of yasnippet
(map! :map cdlatex-mode-map
      :i "TAB" #'cdlatex-tab)
(map! :after latex
      :map cdlatex-mode-map
      :localleader
      :desc "Insert math symbol"
      "i" #'cdlatex-math-symbol
      :desc "Begin environment"
      "e" #'cdlatex-environment)
