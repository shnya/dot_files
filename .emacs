;; byte-compile

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(add-hook 'kill-emacs-hook
          (lambda ()
            (if (file-newer-than-file-p "~/.emacs" "~/.emacs.elc")
                (progn
                  (require 'bytecomp)
                  (displaying-byte-compile-warnings
                   (unless (byte-compile-file "~/.emacs")
                     (signal nil nil)))))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 日本語表示の設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(set-language-environment 'Japanese)
(set-default-coding-systems 'utf-8-unix)
(set-terminal-coding-system 'utf-8-unix)
(set-keyboard-coding-system 'utf-8-unix)
(set-clipboard-coding-system 'utf-8-unix)
(setq-default buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; 日本語 info が文字化けしないように
(auto-compression-mode t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; load-path
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun add-load-path-rec (root)
  (mapc '(lambda (file)
           (and (not (string-match "\\.+$" file))
                (file-directory-p file)
                (push  file load-path)))
        (directory-files root t))
  (push root load-path))

(when (file-exists-p "~/.elisp")
  (add-load-path-rec "~/.elisp/"))
(when (file-exists-p "~/src/elisp")
  (add-load-path-rec "~/src/elisp/"))
(when (file-exists-p "/opt/local/share/emacs/site-lisp/")
  (add-load-path-rec "/opt/local/share/emacs/site-lisp/"))

(setq Info-default-directory-list
      (cons (expand-file-name "~/.elisp/elisp-src")
            (cons (expand-file-name "~/.elisp/info")
                  Info-default-directory-list)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 漢字変換 (skk) の設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (when (locate-library "skk-autoloads")
;;   (require 'skk-autoloads)
;;   (add-hook 'isearch-mode-hook
;;             #'(lambda ()
;;                 (when (and (boundp 'skk-mode)
;;                            skk-mode
;;                            skk-isearch-mode-enable)
;;                   (skk-isearch-mode-setup))))
;;   (add-hook 'isearch-mode-end-hook
;;             #'(lambda ()
;;                 (when (and (featurep 'skk-isearch)
;;                            skk-isearch-mode-enable)
;;                   (skk-isearch-mode-cleanup))))
;;   (setq skk-kakutei-key "\C-o")
;;   (global-set-key "\C-x\C-j" 'skk-mode)
;;   (set-input-method "japanese-skk")
;;   (setq skk-server-host "localhost")
;;   (setq skk-server-portnum 1178)
;;   (setq skk-cdb-large-jisyo "~/.elisp/ddskk/dic/SKK-JISYO.L.cdb")
;;   (toggle-input-method nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Xでのカラー表示や見た目
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(when window-system
  (require 'font-lock)
  (global-font-lock-mode t)
  (setq transient-mark-mode t)
  (setq search-highlight t)
  (setq query-replace-highlight t)
  (setq initial-frame-alist '((width . 80) (height . 40)))
  ;; font
  (set-frame-parameter (selected-frame) 'alpha '(90 80))
  ;;  (set-frame-font "-unknown-VL ゴシック-normal-normal-normal-*-13-*-*-*-*-0-iso10646-1")
  ;;  (set-fontset-font (frame-parameter nil 'font) 'japanese-jisx0208 '("VL ゴシック" . "unicode-bmp") ) '("VL ゴシック:weight=bold" . "unicode-bmp")
  ;; DeleteKey
  (define-key function-key-map [delete] [8])
  (put 'delete 'ascii-character 8)
  ;; カーソルの点滅をやめる
  (setq lazy-highlight-initial-delay 0)
  (blink-cursor-mode 0)
  (tool-bar-mode 0)
  ;; よそのウィンドウにはカーソルを表示しない
  (setq cursor-in-non-selected-windows nil)
  (defun toggle-fullscreen ()
    (interactive)
    (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
                           '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
    (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
                           '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
    )
  ;;(toggle-fullscreen)
  (set-foreground-color "white")
  (set-background-color "Gray9")
  (setq frame-cursor-color "gray"))

;;startup
(setq inhibit-startup-message t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  キーバインド
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key "\M-n" 'next-buffer)
(global-set-key "\M-p" 'previous-buffer)
(add-hook 'compilation-mode-hook
          (lambda ()
            (define-key compilation-mode-map "\M-n" 'next-buffer)
            (define-key compilation-mode-map "\M-p" 'previous-buffer)))


;; Deleteキーでカーソル位置の文字が消えるようにする
(global-set-key [delete] 'delete-char)
(global-set-key "\C-h" 'backward-delete-char-untabify)
(global-set-key "\M-h" 'help-command)
;; for printer
(setq-default lpr-switches '("-2P"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ホイールマウス対応
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun up-slightly () (interactive) (scroll-up 5))
(defun down-slightly () (interactive) (scroll-down 5))
(global-set-key [mouse-4] 'down-slightly)
(global-set-key [mouse-5] 'up-slightly)
(defun up-one () (interactive) (scroll-up 1))
(defun down-one () (interactive) (scroll-down 1))
(global-set-key [S-mouse-4] 'down-one)
(global-set-key [S-mouse-5] 'up-one)
(defun up-a-lot () (interactive) (scroll-up))
(defun down-a-lot () (interactive) (scroll-down))
(global-set-key [C-mouse-4] 'down-a-lot)
(global-set-key [C-mouse-5] 'up-a-lot)

;;実行権限付与
(defun make-file-executable ()
  "Make the file of this buffer executable, when it is a script source."
  (save-restriction
    (widen)
    (if (or
         (string= "#!" (buffer-substring-no-properties 1 (min 3 (point-max))))
         (string= "#if" (buffer-substring-no-properties 1 (min 4 (point-max)))))
        (let ((name (buffer-file-name)))
          (or (equal ?. (string-to-char (file-name-nondirectory name)))
              (let ((mode (file-modes name)))
                (set-file-modes name (logior mode (logand (/ mode 4) 73)))
                (message (concat "Wrote " name " (+x)"))))))))
(add-hook 'after-save-hook 'make-file-executable)

;; mic paren
(when (locate-library "mic-paren")
  (require 'mic-paren)
  (paren-activate))


;; eshell
(require 'eshell)
(defun eshell-beginning-of-line ()
  (interactive)
  (beginning-of-line)
  (when (< (count-lines (point) (point-max)) 2)
    (search-forward "$ ")))
(add-hook 'eshell-mode-hook
          (lambda ()
            (local-set-key "\C-a" 'eshell-beginning-of-line)))

;;; 終了時にオートセーブファイルを消す
(setq delete-auto-save-files t)
;;行全体を削除
(setq kill-whole-line t)


;; python-mode
(add-hook 'python-mode-hook
          '(lambda ()
             (local-set-key "\C-c\ p" 'python-pep8)
             (setq-default indent-tabs-mode nil)
             (setq-default tab-width 4)
             (define-key python-mode-map "\C-m" 'newline-and-indent)))

;; backup-dir
(setq backup-directory-alist (cons (cons "\\.*$" "~/.emacs.d/backup") backup-directory-alist))

;; 行末スペース削除
(defun ys:trim-whitespaces ()
  "Trim excess whitespaces."
  (let ((reg (and transient-mark-mode mark-active)))
    (save-excursion
      (save-restriction
        (if reg
            (narrow-to-region (region-beginning) (region-end)))
        (goto-char (point-min))
        (while (re-search-forward "[ \t]+$" nil t)
          (replace-match "" nil nil))
        (if reg nil
          (goto-char (point-max))
          (delete-blank-lines))
        (untabify (point-min) (point-max)))))
  (deactivate-mark))

;; indent-current-buffer
(defun indent-current-buffer ()
  (interactive)
  (let ((x (point-min))
        (y  (point-max)))
    (indent-region x y nil)
    (ys:trim-whitespaces)))

(setq-default tab-width 2 indent-tabs-mode nil)
(global-set-key "\M-u" 'indent-current-buffer)

;;goto-line
(global-set-key "\M-g" 'goto-line)
;;buffer移動
(global-set-key "\M-," 'other-window)
(global-set-key "\M-k" 'kill-buffer)

;; mode-compile
(when (locate-library "mode-compile")
  (autoload 'mode-compile "mode-compile"
    "Command to compile current buffer file based on the major mode" t)
  (global-set-key "\C-cc" 'mode-compile)
  (autoload 'mode-compile-kill "mode-compile"
    "Command to kill a compilation launched by `mode-compile'" t)
  (global-set-key "\C-ck" 'mode-compile-kill)
  ;; 全てバッファを自動的にセーブする
  (setq mode-compile-always-save-buffer-p t)
  ;; コマンドをいちいち確認しない
  (setq mode-compile-never-edit-command-p t)
  ;; メッセージ出力を抑制
  (setq mode-compile-expert-p t)
  ;; メッセージを読む場合に下記の時間待つ
  (setq mode-compile-reading-time 0)
  ;; コンパイルが完了したらウィンドウを閉じる
  (setq compilation-finish-functions 'compile-autoclose)
  (defun compile-autoclose (buffer string)
    (cond ((string-match "finished" string)
           (message "Build maybe successful: closing window.")
           ;; (if (string-match "-o \\(.*\\)" (buffer-string))
           ;;     (let ((matched (match-string-no-properties 1 (buffer-string))))
           ;;       (shell-command (concat "./" matched)))))
           (run-with-timer 0.3 nil
                           'delete-window
                           (get-buffer-window buffer t)))
          (t (message "Compilation exited abnormally: %s" string)))))

;;info
(setq Info-default-directory-list
      (append Info-default-directory-list (list (expand-file-name "~/.elisp/info"))))


;; yasnippet
;; http://code.google.com/p/yasnippet/
(when (locate-library "yasnippet")
  (require 'yasnippet)
  (yas-global-mode 1))

;;C-x C-b バッファ画面切替
(global-set-key "\C-x\C-b" 'electric-buffer-list)

;;;;  flymake
(when (locate-library "flymake")
  (require 'flymake)
  ;; 全てのファイルでflymakeを有効化
  (add-hook 'find-file-hook 'flymake-find-file-hook)

  ;; miniBufferにエラーを出力
  (defun flymake-show-and-sit ()
    "Displays the error/warning for the current line in the minibuffer"
    (interactive)
    (progn
      (let* ((line-no (flymake-current-line-no) )
             (line-err-info-list (nth 0 (flymake-find-err-info flymake-err-info line-no)))
             (count (length line-err-info-list)))
        (while (> count 0)
          (when line-err-info-list
            (let* ((file (flymake-ler-file (nth (1- count) line-err-info-list)))
                   (full-file
                    (flymake-ler-full-file (nth (1- count) line-err-info-list)))
                   (text (flymake-ler-text (nth (1- count) line-err-info-list)))
                   (line (flymake-ler-line (nth (1- count) line-err-info-list))))
              (message "[%s] %s" line text)))
          (setq count (1- count)))))
    (sit-for 60.0))
  (global-set-key "\C-cd" 'flymake-show-and-sit)

  (set-face-background 'flymake-errline "red4")
  (set-face-background 'flymake-warnline "dark slate blue")

  ;; ;; flymake for python
  ;; (when (load "flymake" t)
  ;;   (defun flymake-pyflakes-init ()
  ;;     (let* ((temp-file (flymake-init-create-temp-buffer-copy
  ;;                        'flymake-create-temp-inplace))
  ;;            (local-file (file-relative-name
  ;;                         temp-file
  ;;                         (file-name-directory buffer-file-name))))
  ;;       (list "pyflakes"  (list local-file))))
  ;;   (add-to-list 'flymake-allowed-file-name-masks
  ;;                '("\\.py\\'" flymake-pyflakes-init)))
  ;; (global-set-key [f10] 'flymake-goto-prev-error)
  ;; (global-set-key [f11] 'flymake-goto-next-error)

  ;; Minibufに文法エラーを出力
  (defun flymake-display-err-minibuf-for-current-line ()
    "Displays the error/warning for the current line in the minibuffer"
    (interactive)
    (let* ((line-no (flymake-current-line-no))
           (line-err-info-list
            (nth 0 (flymake-find-err-info flymake-err-info line-no)))
           (count (length line-err-info-list)))
      (while (> count 0)
        (when line-err-info-list
          (let* ((file (flymake-ler-file (nth (1- count) line-err-info-list)))
                 (full-file
                  (flymake-ler-full-file (nth (1- count) line-err-info-list)))
                 (text (flymake-ler-text (nth (1- count) line-err-info-list)))
                 (line (flymake-ler-line (nth (1- count) line-err-info-list))))
            (message "[%s] %s" line text)))
        (setq count (1- count)))))

  ;; Makefile が無くてもC/C++のチェック
  (defun flymake-simple-generic-init (cmd &optional opts)
    (let* ((temp-file  (flymake-init-create-temp-buffer-copy
                        'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list cmd (append opts (list local-file)))))

  (defun flymake-simple-make-or-generic-init (cmd &optional opts)
    (if (file-exists-p "Makefile")
        (flymake-simple-make-init)
      (flymake-simple-generic-init cmd opts)))

  (defun flymake-c-init ()
    (flymake-simple-make-or-generic-init
     "gcc" '("-Wall" "-Wextra" "-pedantic" "-fsyntax-only")))

  (defun flymake-cc-init ()
    (flymake-simple-make-or-generic-init
     "g++" '("-Wall" "-Wextra" "-pedantic" "-fsyntax-only")))

  (push '("\\.c\\'" flymake-c-init) flymake-allowed-file-name-masks)
  (push '("\\.\\(cc\\|cpp\\|C\\|CPP\\|hpp\\)\\'" flymake-cc-init)
        flymake-allowed-file-name-masks))



;;customize
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(adaptive-fill-mode nil)
 '(auto-compression-mode t nil (jka-compr))
 '(auto-save-default nil)
 '(blink-cursor-mode nil)
 '(case-fold-search t)
 '(default-input-method "japanese")
 '(flymake-allowed-file-name-masks
   (quote
    (("\\.\\(cc\\|cpp\\|C\\|CPP\\|hpp\\)\\'" flymake-cc-init nil nil)
     ("\\.c\\'" flymake-c-init nil nil)
     ("\\.\\(?:c\\(?:pp\\|xx\\|\\+\\+\\)?\\|CC\\)\\'" flymake-simple-make-init nil nil)
     ("\\.cs\\'" flymake-simple-make-init nil nil)
     ("\\.p[ml]\\'" flymake-perl-init nil nil)
     ("\\.php[345]?\\'" flymake-php-init nil nil)
     ("\\.h\\'" flymake-master-make-header-init flymake-master-cleanup nil)
     ("\\.java\\'" flymake-simple-make-java-init flymake-simple-java-cleanup nil)
     ("[0-9]+\\.tex\\'" flymake-master-tex-init flymake-master-cleanup nil)
     ("\\.tex\\'" flymake-simple-tex-init nil nil)
     ("\\.idl\\'" flymake-simple-make-init nil nil))))
 '(frame-background-mode nil)
 '(package-selected-packages (quote (yasnippet)))
 '(safe-local-variable-values (quote ((Package . XREF) (Syntax . Common-lisp))))
 '(standard-indent 2)
 '(transient-mark-mode t)
 '(truncate-lines nil)
 '(w3m-cookie-accept-bad-cookies (quote ask)))

(when (locate-library "whitespace")
  (require 'whitespace)
  (setq whitespace-style
        '(face
          trailing
          tabs
          space-mark
          tab-mark))
  (setq whitespace-display-mappings
        '((tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])))
  (global-whitespace-mode 1))


(when (locate-library "carun")
  (require 'carun)
  (global-set-key "\C-cr" 'carun-exec-retry)
  (global-set-key "\C-c\C-r" 'carun-exec))
(setq x-select-enable-clipboard t)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
