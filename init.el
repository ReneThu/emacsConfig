;; Package configs
(require 'package)
(setq package-enable-at-startup nil)

;; straight Package manager
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; TODO check emacs version
(setq package-check-signature nil)

;;
(setq package-archives '(("org"   . "http://orgmode.org/elpa/")
                         ("gnu"   . "http://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

;; Fullscreen
;;(add-hook 'window-setup-hook 'toggle-frame-maximized t)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq package-list '(nyan-mode zone-nyan json-mode yaml-mode ranger magit))

; activate all the packages
(package-initialize)

; fetch the list of packages available 
(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-refresh-contents) ;TODO rethink package installing process
    (package-install package)))

;; install helm

(straight-use-package 'helm)

;; Bootstrap `use-package`
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; yaml mode
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

;; Minimal UI
(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)
(menu-bar-mode   -1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   (quote
    ("~/emacs-org/1.org" "~/emacs-org/mentership.org" "~/emacs-org/enzo_block.org" "~/emacs-org/xdcam.org")))
 '(ediff-split-window-function (quote split-window-horizontally)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;;;Org mode configuration
;; Enable Org mode
(require 'org)
;; Make Org mode work with files ending in .org
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
;; The above is the default in recent emacsen
;; Set keywords for TODOs
(setq org-todo-keywords
  '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE")))
;; Expand all in org file
(setq org-startup-folded nil)

(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c C-l") 'org-insert-link)


;;Theme and Nyanyanyanyanyanyanyanyan
(use-package spacemacs-theme
  :defer t
  :init (load-theme 'spacemacs-dark t))

(setq zone-programs [zone-nyan])
;;(setq initial-buffer-choice 'zone)
(setq inhibit-startup-screen t)
(nyan-mode)

;;TODO fix slime
;;(load (expand-file-name "~/.quicklisp/slime-helper.el"))
;;(setq inferior-lisp-program "sbcl")
;;(ffap-bindings)
;;(global-set-key (kbd "C-x r <RET>") 'ranger)

(defvar-local endless/display-images t)

(defun endless/toggle-image-display ()
  "Toggle images display on current buffer."
  (interactive)
  (setq endless/display-images
        (null endless/display-images))
  (endless/backup-display-property endless/display-images))

(defun endless/backup-display-property (invert &optional object)
  "Move the 'display property at POS to 'display-backup.
Only applies if display property is an image.
If INVERT is non-nil, move from 'display-backup to 'display
instead.
Optional OBJECT specifies the string or buffer. Nil means current
buffer."
  (let* ((inhibit-read-only t)
         (from (if invert 'display-backup 'display))
         (to (if invert 'display 'display-backup))
         (pos (point-min))
         left prop)
    (while (and pos (/= pos (point-max)))
      (if (get-text-property pos from object)
          (setq left pos)
        (setq left (next-single-property-change pos from object)))
      (if (or (null left) (= left (point-max)))
          (setq pos nil)
        (setq prop (get-text-property left from object))
        (setq pos (or (next-single-property-change left from object)
                      (point-max)))
        (when (eq (car prop) 'image)
          (add-text-properties left pos (list from nil to prop) object))))))

(defun my-open-init-file ()
  "Open the init file."
  (interactive)
  (find-file user-init-file))

;; Key bindings
(global-set-key (kbd "C-x t") 'endless/toggle-image-display)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key [mouse-6] 'scroll-right)
(global-set-key [mouse-7] 'scroll-left)

;;Disabled commands
(put 'scroll-right 'disabled nil)
(put 'scroll-left 'disabled nil)

(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
  backup-by-copying t    ; Don't delink hardlinks
  version-control t      ; Use version numbers on backups
  delete-old-versions t  ; Automatically delete excess backups
  kept-new-versions 20   ; how many of the newest versions to keep
  kept-old-versions 5    ; and how many of the old
  )

