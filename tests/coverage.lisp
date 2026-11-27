(in-package #:raylisp/tests)

(defun header-function-names (path)
  ;; raylib places each public prototype on one line prefixed with RLAPI.
  (loop for line in (uiop:read-file-lines path)
        when (uiop:string-prefix-p "RLAPI " line)
          collect (let* ((end (position #\( line))
                         (start (position-if-not #'alphanumericp line :end end :from-end t)))
                    (subseq line (1+ start) end))))

(defun check-coverage ()
  (let ((names (make-hash-table :test #'equal))
        (header (or (uiop:getenv "RAYLIB_HEADER")
                    (some #'probe-file '("/opt/homebrew/include/raylib.h"
                                         "/home/linuxbrew/.linuxbrew/include/raylib.h"
                                         "/usr/local/include/raylib.h" "/usr/include/raylib.h"))))
        (*package* (find-package :raylisp))
        (*read-eval* nil))
    (with-open-file (source (asdf:system-relative-pathname "raylisp" "api.lisp"))
      (loop for form = (read source nil :end) until (eq form :end)
            when (and (consp form) (eq (first form) 'cffi:defcfun))
              do (destructuring-bind (native binding) (second form)
                   (let ((public (string-left-trim "%" (symbol-name binding))))
                     (multiple-value-bind (symbol status) (find-symbol public :raylisp)
                       (assert (and (eq status :external) (fboundp symbol)) () "~A" public)))
                   (assert (cffi:foreign-symbol-pointer native) () "Missing native function ~A" native)
                   (assert (not (gethash native names)) () "Duplicate binding for ~A" native)
                   (setf (gethash native names) t))))
    (assert (= 619 (hash-table-count names)))
    (when header
      (let ((expected (header-function-names header)))
        (assert (= (length expected) (hash-table-count names)))
        (dolist (native expected)
          (assert (gethash native names) () "Missing binding for ~A" native))))
    (format t "~&Verified ~D public bindings against the shared library~@[ and ~A~].~%"
            (hash-table-count names) header)))

(defun check-media ()
  (let* ((ink (raylisp:color 24 50 200))
         (image (raylisp:gen-image-color 3 2 ink)))
    (unwind-protect
         (cffi:with-foreign-object (storage '(:struct raylisp:image))
           (assert (raylisp:is-image-valid image))
           (setf (cffi:mem-ref storage '(:struct raylisp:image)) image)
           (raylisp:image-draw-pixel storage 1 0 (raylisp:color 0 0 0))
           (assert (not (raylisp:color-is-equal ink (raylisp:get-image-color image 1 0))))
           (assert (raylisp:color-is-equal ink (raylisp:get-image-color image 0 0)))
           (assert (= 24 (raylisp:get-pixel-data-size 3 2 :uncompressed-r8g8b8a8))))
      (raylisp:unload-image image)))
  ;; Copy a short PCM wave. Reading samples needs no playback device.
  (cffi:with-foreign-object (pcm :int16 2)
    (setf (cffi:mem-aref pcm :int16 0) 0 (cffi:mem-aref pcm :int16 1) 16384)
    (let ((copy (raylisp:wave-copy
                 (list 'raylisp::frame-count 2 'raylisp::sample-rate 8000
                       'raylisp::sample-size 16 'raylisp::channels 1 'raylisp::data pcm))))
      (unwind-protect
           (let ((samples (raylisp:load-wave-samples copy)))
             (unwind-protect
                  (progn
                    (assert (raylisp:is-wave-valid copy))
                    (assert (zerop (cffi:mem-aref samples :float 0)))
                    (assert (< 0.49 (cffi:mem-aref samples :float 1) 0.51)))
               (raylisp:unload-wave-samples samples)))
        (raylisp:unload-wave copy)))))
