(in-package #:raylisp)

;;; Start with a palette. DEFCOLOR defines an ordinary Lisp variable.
(defcolor *player-blue* 0 100 200)
(defcolor *player-orange* 230 110 20)
(defcolor *paper* 245 245 245)
(defcolor *ink* 30 35 45)

;;; Next, define two drawing functions. The style stays in the definition.
;;; Later we supply only the position (and, for a label, the text).
(defcircle draw-blue-player 14 *player-blue*)
(defcircle draw-orange-player 14 *player-orange*)
(deflabel draw-instruction 20 *ink*)

;;; DEFSTRUCT is built into Common Lisp. It gives us MAKE-PLAYER and the
;;; accessors PLAYER-X and PLAYER-ORANGE-P, which the controls can change.
(defstruct player (x 320) (orange-p nil))

;;; DEFKEYMAP defines READ-PLAYER-KEYS as a function taking one player.
;;; :HELD moves it every frame. :PRESSED switches color once per tap.
(defkeymap read-player-keys (player)
  (:held :left  (setf (player-x player) (max 14 (- (player-x player) 4))))
  (:held :right (setf (player-x player) (min 626 (+ (player-x player) 4))))
  (:pressed :space (setf (player-orange-p player) (not (player-orange-p player)))))

;;; DEFGAME defines a function you can call at the REPL. Opening the window
;;; creates a fresh player. Each frame reads input and then draws that player.
(defgame macros-demo (640 400 "Defining a game")
    ((player (make-player)))
    (:update (read-player-keys player) :background *paper*)
  (if (player-orange-p player)
      (draw-orange-player (player-x player) 200)
      (draw-blue-player (player-x player) 200))
  (draw-instruction "Left/Right: move    Space: change color    Esc: quit" 16 16))

;;; Try this without opening a window:
;;; (macroexpand-1 '(raylisp:defcircle draw-token 10 (raylisp:color 255 0 0)))
;;; Look for DEFUN in the result. Evaluating the original form defines
;;; DRAW-TOKEN, which you can then call as (draw-token 100 80) inside a frame.

;;; A second scene uses the reference constructions together.
(defpalette
  (*grid-blue* 55 130 190)
  (*cursor-gold* 245 175 40))

(defun drawing-macros-demo (&optional font-path)
  "Move the marker with the arrow keys; type a key to see its name."
  (with-window (640 400 "Drawing macros")
    (with-font (font font-path 28)
      (let ((cursor (vec2 320 230))
            (camera (camera-3d :position (vec3 4 4 6) :target (vec3 0 0 0)))
            (last-key "none"))
        (do-frames *paper*
          (do-pressed-keys (key)
            (setf last-key key))
          ;; MACROLET defines a little language only this control block needs.
          (macrolet ((step-if-held (key dx dy)
                       `(when (key-down-p ,key) (move-point-by cursor ,dx ,dy))))
            (step-if-held :left -3 0)
            (step-if-held :right 3 0)
            (step-if-held :up 0 -3)
            (step-if-held :down 0 3))
          (with-clip (16 60 608 320)
            (with-3d (camera)
              (draw-grid 12 1f0)
              (draw-cube (vec3 0 0.5 0) 1f0 1f0 1f0 *grid-blue*))
            ;; SETF on X and Y updates the point in place.
            (with-point-components (x y) cursor
              (setf x (max 26f0 (min x 614f0))
                    y (max 70f0 (min y 370f0))))
            (draw-circle-v cursor 10f0 *cursor-gold*))
          (draw-text-ex font (format nil "Arrow keys move the marker. Last key: ~A" last-key)
                        (vec2 16 16) 20f0 1f0 *ink*))))))

;;; Look up any construction without opening a window. Each quoted example
;;; is code as data. For instance, (macro-guide :with-frame) prints the call
;;; and exactly one expansion step. No calls to raylib take place.
(defparameter *macro-examples*
  '((when-key-pressed "Conditional body: splice any number of forms."
      (when-key-pressed :space (print "jump")))
    (with-mouse-position "Caller-chosen bindings: destructure the names."
      (with-mouse-position (x y) (list x y)))
    (with-frame "Paired calls: finish the frame on early exit."
      (with-frame *paper* (draw-blue-player 100 80)))
    (do-grid "Once-only bounds: GENSYM keeps temporary variables private."
      (do-grid (x y 3 2) (print (list x y))))
    (with-window "Keyword options: set a default with &KEY."
      (with-window (640 400 "Test" :fps 30) (print "open")))
    (do-frames "Composition: expand a loop into uses of another macro."
      (do-frames *paper* (draw-blue-player 100 80)))
    (defcolor "Define data: generate a DEFPARAMETER form."
      (defcolor *gold* 255 203 0))
    (defcircle "Define a function: insert the chosen style into its body."
      (defcircle draw-coin 10 *cursor-gold*))
    (deflabel "Partially specify a drawing operation when defining a function."
      (deflabel draw-score 20 *ink*))
    (defkeymap "Clause syntax: choose and validate each event at expansion time."
      (defkeymap handle-input (player) (:held :right (incf (player-x player)))))
    (defgame "Defining form with sections: separate state, updating and drawing."
      (defgame play (640 400 "Play") ((x 0)) (:update (incf x)) (draw-blue-player x 80)))
    (defpalette "Multiple definitions: emit one top-level form per entry."
      (defpalette (*sky* 100 170 255) (*shade* 0 0 0 80)))
    (do-pressed-keys "Iteration: bind the next event until the queue is empty."
      (do-pressed-keys (key) (print key)))
    (with-font "Resource lifetime: distinguish a loaded font from a borrowed font."
      (with-font (font "title.ttf" 32) (measure-text-ex font "Score" 32f0 1f0)))
    (with-point-components "Symbol macros: simple names can stand for writable places."
      (with-point-components (x y) cursor (incf x) (decf y)))
    (move-point-by "Generalized places: read, change and write with DEFINE-MODIFY-MACRO."
      (move-point-by (aref trail (incf index)) 4 0))
    (define-drawing-scope "A defining macro that generates another DEFMACRO."
      (define-drawing-scope with-my-camera (camera) begin-mode-3d end-mode-3d))
    (with-3d "Generated scope: end camera mode even on a nonlocal exit."
      (with-3d (camera) (draw-grid 10 1f0)))
    (with-clip "Another generated scope: the same expansion handles four arguments."
      (with-clip (0 0 320 200) (draw-blue-player 80 60)))
    (macrolet "Local macro: keep a scene-specific abbreviation inside its caller."
      (macrolet ((jump () '(incf height 10))) (expansion-of (jump))))
    (expansion-of "Capture an expansion as data, without evaluating it."
      (expansion-of (when-key-pressed :space (print "jump"))))))

(defun macro-guide (&optional name (stream *standard-output*))
  "List the constructions, or print a named example and its one-step expansion."
  (if name
      (let ((entry (find (string name) *macro-examples*
                         :key (lambda (row) (symbol-name (first row)))
                         :test #'string-equal)))
        (unless entry (error "Unknown construction ~S. Try (raylisp:macro-guide)." name))
        (destructuring-bind (operator lesson example) entry
          (format stream "~A~%~%Example~%~S~%~%~A~%~S~%" lesson example
                  (if (eq operator 'macrolet)
                      "Local example expansion" "One-step expansion")
                  (if (eq operator 'macrolet)
                      (macrolet ((jump () '(incf height 10))) (expansion-of (jump)))
                      (macroexpand-1 example)))))
      (dolist (entry *macro-examples*)
        (format stream "~A  ~A~%" (first entry) (second entry)))))
