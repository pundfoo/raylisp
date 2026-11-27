(in-package #:raylisp)

;;; 1. Run code on a key press
;;;
;;; A macro receives pieces of Lisp code and returns a new form to evaluate.
;;; Backquote builds that form. A comma inserts one piece of code.
;;; &BODY collects the remaining forms in a list, and ,@ inserts them in order.

(defmacro when-key-pressed (key &body body)
  "Run BODY once on the frame when KEY is pressed."
  `(when (key-pressed-p ,key)
     ,@body))

;; Try this in the REPL, even before opening a window:
;; (macroexpand-1 '(raylisp:when-key-pressed :space (print "jump")))
;; You get (WHEN (RAYLISP:KEY-PRESSED-P :SPACE) (PRINT "jump")).
;; The quote lets you examine the code without polling the keyboard.

;;; 2. Give the caller two local names

(defmacro with-mouse-position ((x y) &body body)
  "Read the mouse coordinates once and bind them to the names X and Y."
  `(let ((,x (get-mouse-x))
         (,y (get-mouse-y)))
     ,@body))

;; (with-mouse-position (left top) (draw-rectangle left top 20 20 ink))
;; LEFT and TOP exist only inside the body. The caller chooses their names.

;;; 3. Pair the beginning and end of a frame

(defmacro with-frame (background &body body)
  "Clear one frame, draw BODY, and finish the frame even on an early exit."
  `(progn
     (begin-drawing)
     (unwind-protect
          (progn
            (clear-background ,background)
            ,@body)
       (end-drawing))))

;; PROGN groups several forms. UNWIND-PROTECT runs its cleanup even if
;; a drawing operation signals an error and you leave the debugger.

;;; 4. Introduce a loop with private variables

(defmacro do-grid ((column row columns rows) &body body)
  "Run BODY at each grid cell, starting at column zero and row zero."
  (let ((width (gensym "COLUMNS-"))
        (height (gensym "ROWS-")))
    `(let ((,width ,columns)
           (,height ,rows))
       (dotimes (,row ,height)
         (dotimes (,column ,width)
           ,@body)))))

;; (do-grid (x y 3 2) (print (list x y))) visits six cells, row by row.
;; The outer LET in the expansion evaluates both bounds once, even when
;; a bound is a calculation. GENSYM makes fresh names for those saved values
;; so the macro cannot accidentally hide a variable used by the caller.

;;; 5. Own a window for the duration of a body

(defmacro with-window ((width height title &key (fps 60)) &body body)
  "Open a window, set its frame rate, and close it when BODY exits."
  `(progn
     (init-window ,width ,height ,title)
     (unwind-protect
          (progn
            (set-target-fps ,fps)
            ,@body)
       (close-window))))

;; The parenthesized argument list keeps the window settings together.
;; For a different frame rate, use (with-window (640 400 "Test" :fps 30) ...).

;;; 6. Compose a loop from a smaller macro

(defmacro do-frames (background &body body)
  "Draw successive frames until the user presses Escape or closes the window."
  `(loop until (window-should-close-p)
         do (with-frame ,background
              ,@body)))

;; WITH-WINDOW runs its body once. DO-FRAMES repeats its body each frame.
;; Ordinary functions still do the actual drawing.

;;; Defining forms. Evaluate these at the top level of a game file.

(defmacro defcolor (name red green blue &optional (alpha 255))
  "Define a named RGBA color. By convention its name has *earmuffs*."
  `(defparameter ,name (color ,red ,green ,blue ,alpha)))

(defmacro defcircle (name radius tint)
  "Define a drawing function called as (NAME center-x center-y)."
  (let ((x (gensym "X")) (y (gensym "Y")))
    `(defun ,name (,x ,y)
       (draw-circle ,x ,y (float ,radius 1f0) ,tint))))

(defmacro deflabel (name font-size tint)
  "Define a text style called as (NAME text x y)."
  (let ((text (gensym "TEXT")) (x (gensym "X")) (y (gensym "Y")))
    `(defun ,name (,text ,x ,y)
       (draw-text ,text ,x ,y ,font-size ,tint))))

(defmacro defkeymap (name parameters &body bindings)
  "Define a function that polls each (:pressed KEY ...) or (:held KEY ...) clause."
  `(defun ,name ,parameters
     ,@(loop for (event key . actions) in bindings
             for predicate = (ecase event
                               (:pressed 'key-pressed-p)
                               (:held 'key-down-p))
             collect `(when (,predicate ,key) ,@actions))))

(defmacro defgame (name (width height title &key (fps 60)) state
                   (&key update background) &body drawing)
  "Define (NAME) to start a game. STATE uses LET* bindings, fresh on each run.
UPDATE runs once per frame before the background is cleared and DRAWING runs."
  `(defun ,name ()
     (with-window (,width ,height ,title :fps ,fps)
       (let* ,state
         (loop until (window-should-close-p)
               do ,update
                  (with-frame ,(or background '(color 245 245 245))
                    ,@drawing))))))

;;; Define several things with one form: DEFMACRO, LOOP and ,@
;;;
;;; Each palette entry has the same shape as the arguments to DEFCOLOR.
;;; Build one definition per entry. Top-level PROGN lets the compiler see
;;; each definition just as if the author had written them separately.
(defmacro defpalette (&body entries)
  "Define colors from (name red green blue [alpha]) entries."
  `(progn
     ,@(loop for entry in entries collect `(defcolor ,@entry))))

;;; Read a queue: a looping macro with an explicit stopping condition.
;;; NEXT-KEY-PRESSED consumes one event on each call and returns NIL at
;;; the end of the queue. Bind that result so BODY can use it repeatedly.
(defmacro do-pressed-keys ((key) &body body)
  "Run BODY for each queued key this frame, in the order raylib reports it."
  `(loop for ,key = (next-key-pressed)
         while ,key do (progn ,@body)))

;;; Acquire a resource: save who owns it as well as the resource itself.
(defmacro with-font ((name &optional path (size 32)) &body body)
  "Bind NAME to a font inside an open window. A supplied non-NIL PATH loads a font."
  (let ((source (gensym "PATH-"))
        (font (gensym "FONT-")))
    `(let* ((,source ,path)
            (,font (if ,source
                       (load-font-ex (namestring (pathname ,source)) ,size
                                     (cffi:null-pointer) 0)
                       (get-font-default))))
       (unwind-protect
            (let ((,name ,font))
              (unless (is-font-valid ,font)
                (error "Could not obtain a font for ~S." ,source))
              ,@body)
         ;; Raylib owns the default font. Release only a font we loaded.
         (when ,source (unload-font ,font))))))

;;; Name places: SYMBOL-MACROLET gives ordinary-looking names SETF behavior.
;;; A vec2 already has X and Y slots. Both aliases refer to the same point.
(defmacro with-point-components ((x y) point &body body)
  "Bind X and Y as editable aliases for the coordinates of one VEC2."
  (let ((p (gensym "POINT-")))
    `(let ((,p ,point))
       (symbol-macrolet ((,x (getf ,p 'x))
                         (,y (getf ,p 'y)))
         ,@body))))

;;; Update a generalized place: separate the arithmetic from the macro.
(defun offset-point (point dx dy)
  (vec2 (+ (getf point 'x) dx) (+ (getf point 'y) dy)))

(define-modify-macro move-point-by (dx dy) offset-point
  "Replace a point in a SETF place with a translated point.")

;; (move-point-by (aref trail (incf index)) 4 0)
;; Like INCF, DEFINE-MODIFY-MACRO arranges to evaluate the index only once.
;; OFFSET-POINT returns a fresh vec2, so other references keep the old point.

;;; Define a family of macros: share the expansion, keep each public name.
;;; First write the expansion as a function that takes pieces of code.
;;; EVAL-WHEN makes it available when compiling uses in this very file.
(eval-when (:compile-toplevel :load-toplevel :execute)
  (defun drawing-scope-form (begin arguments end body)
    `(progn
       (,begin ,@arguments)
       (unwind-protect (progn ,@body)
         (,end)))))

(defmacro define-drawing-scope (name parameters begin end)
  "Define (NAME (arguments...) body...) for a matching pair of raylib calls."
  (let ((body (gensym "BODY-")))
    `(defmacro ,name ((,@parameters) &body ,body)
       (drawing-scope-form ',begin (list ,@parameters) ',end ,body))))

(define-drawing-scope with-3d (camera) begin-mode-3d end-mode-3d)
(define-drawing-scope with-clip (x y width height) begin-scissor-mode end-scissor-mode)

;;; Inspect a local macro: &ENVIRONMENT refers to the caller's lexical scope.
;;; Return the expansion as quoted data so inspecting it cannot draw a frame.
(defmacro expansion-of (form &environment environment)
  "Return one step of macro expansion, including for a surrounding MACROLET."
  `',(macroexpand-1 form environment))
