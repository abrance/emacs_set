;; 不使用 lisp 语言版本。

;; 关闭工具栏，tool-bar-mode 即为一个 Minor Mode
;; (tool-bar-mode 0)
;; 关闭文件滑动控件
;; (scroll-bar-mode -1)
(menu-bar-no-scroll-bar)

;; 显示行号
;; (global-linum-mode 1)

;; 更改光标的样式（不能生效，解决方案见第二集）
;; (setq-default cursor-type 'box)
;;(scroll-bar-mode -1)

;; 关闭启动帮助画面
(setq inhibit-splash-screen 1)

;; 关闭缩进 (第二天中被去除)
;; (electric-indent-mode -1)

;; 更改显示字体大小 16pt
;; http://stackoverflow.com/questions/294664/how-to-set-the-font-size-in-emacs
(set-face-attribute 'default nil :height 160)

;; 快速打开配置文件
(defun open-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

;; 这一行代码，将函数 open-init-file 绑定到 <f2> 键上
(global-set-key (kbd "<f2>") 'open-init-file)

(setq make-backup-files nil)

(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-item 10)

;; 这个快捷键绑定可以用之后的插件 counsel 代替
(global-set-key (kbd "C-x C-r") 'recentf-open-files)

(delete-selection-mode 1)

(require 'package)
;; (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
;; 			 ("marmalade" . "https://marmalade-repo.org/packages/")
;; 			 ("melpa" . "http://elpa.emacs-china.org/melpa-stable/")))
(setq package-archives '(("gnu"   . "http://elpa.zilongshanren.com/gnu/")
                           ("melpa" . "http://elpa.zilongshanren.com/melpa/")))
(add-to-list 'load-path "~/.emacs.d/elpa/pangu-spacing-20190823.401")
(require 'pangu-spacing)

(global-pangu-spacing-mode 1)

(package-initialize)
;; 全局补全功能
(global-company-mode)

;; 括号匹配
(add-hook 'emacs-lisp-mode-hook 'show-paren-mode)

;; 当前行高亮
;; (global-hl-line-mode t)

;; (add-to-list 'load-path "/root/.emacs.d/elpa/emacs-application-framework")
;; (require 'eaf)

(electric-pair-mode 1)
;; 添加单引号补齐
(setq electric-pair-pairs
      '(
		(?\" . ?\")  ;; 添加双引号补齐
		(?\{ . ?\})  ;; 添加大括号补齐
		(?\' . ?\')
		(?\[ . ?\])
		)
      )

;; 逗号后自动加空格
(global-set-key (kbd ",")
                #'(lambda ()
                    (interactive)
                    (insert ", ")))
;; 快速切换缓存区
(global-set-key (kbd "<backtab>") #'(lambda ()
                                      (interactive)
                                      (switch-to-buffer (other-buffer (current-buffer) 1))))

;; C 语言开发风格改为 linux 内核模式（花括号缩进问题），缩进改为2
(setq c-default-style "linux"
			c-basic-offset 2)
(setq-default c-basic-offset 2
							tab-width 2
							indent-tabs-mode t)

;; desktop 保存桌面环境
(desktop-save-mode 1)

;; test area ----------------------------------------------------------------------
(require 'helm)
(require 'helm-config)
(global-set-key (kbd "C-x C-b") 'helm-buffers-list)


;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line t)

(defun spacemacs//helm-hide-minibuffer-maybe ()
  "Hide minibuffer in Helm session if we use the header line as input field."
  (when (with-helm-buffer helm-echo-input-in-header-line)
    (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
      (overlay-put ov 'window (selected-window))
      (overlay-put ov 'face
                   (let ((bg-color (face-background 'default nil)))
                     `(:background ,bg-color :foreground ,bg-color)))
      (setq-local cursor-type nil))))


(add-hook 'helm-minibuffer-set-up-hook
          'spacemacs//helm-hide-minibuffer-maybe)

(setq helm-autoresize-max-height 0)
(setq helm-autoresize-min-height 20)
(helm-autoresize-mode 1)

(helm-mode 1)

;; ----------------------------------------------------------------------
(global-flycheck-mode 1)
(with-eval-after-load 'flycheck
  (add-hook 'flycheck-mode-hook #'flycheck-pycheckers-setup))

(global-set-key (kbd "<C-tab>") 'company-complete)
                    ; 补全菜单选项快捷键

;; init.el end
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (helm-flycheck helm flycheck-pycheckers company))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
