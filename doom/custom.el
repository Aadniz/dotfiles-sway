;; Automatically sync org files when saving
(defun sync-to-unison ()
  "Sync org file with unison."
  (when (and (eq major-mode 'org-mode)
             (string-prefix-p (expand-file-name "~/Documents/org") buffer-file-name))
    (message "Syncing org files with unison...")
    (let ((output (with-output-to-string
                    (with-current-buffer standard-output
                      (unless (= 0 (call-process-shell-command "unison org-files"))
                        (error "Error: SYNCING FAILED! please run \"unison org-files\" manually"))))))
      (message "Org files synced successfully"))))
(add-hook 'after-save-hook #'sync-to-unison)
(add-hook 'find-file-hook #'sync-to-unison)
