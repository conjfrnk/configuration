;; Personal Information
(setq user-full-name "Connor Frank"
      user-mail-address "conjfrnk@gmail.com")

;; Theme Configuration
(setq doom-theme 'doom-gruvbox)

;; Line Numbers Configuration
(setq display-line-numbers-type 'relative)

;; Enable global auto-revert
(global-auto-revert-mode t)

;; Org Configuration
(after! org
  (setq org-directory "~/Notes/org/")
  (setq org-agenda-files
        (append (directory-files-recursively "~/Notes/org/" "\\.org$")
                (directory-files-recursively "~/Notes/org/roam/" "\\.org$")))
  (setq org-track-ordered-property-with-tag t)
  (setq org-agenda-log-mode-items '(closed clock state)))

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

  ;; Function to find nodes excluding archives
  (defun my/org-roam-node-find-no-archive ()
    "Find and open an Org-roam node, excluding archived nodes."
    (interactive)
    (org-roam-node-find nil nil
                        (lambda (node)
                          (not (member "archive" (org-roam-node-tags node))))))

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
