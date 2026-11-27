(in-package #:raylisp)

(defun shapes-2d-demo ()
  "Move the mouse into the rectangle. The overlapping area turns orange."
  (with-window (720 420 "2D shapes: intersections and splines")
    (let ((target (rectangle 240 115 240 145))
          (start (vec2 100 340)) (control (vec2 360 225)) (end (vec2 620 340))
          (paper (color 245 245 245)) (ink (color 30 35 45))
          (blue (color 0 110 200)) (orange (color 245 135 20)))
      (lesson-frames (:shapes-2d paper)
        (let ((cursor (rectangle (- (get-mouse-x) 35) (- (get-mouse-y) 25) 70 50)))
          (draw-rectangle-rec target blue)
          (when (check-collision-recs cursor target)
            (draw-rectangle-rec (get-collision-rec cursor target) orange))
          (draw-rectangle-lines-ex cursor 2f0 ink))
        (draw-spline-segment-bezier-quadratic start control end 3f0 ink)
        ;; A spline can supply coordinates for animation as well as drawing.
        (let ((fraction (float (mod (/ (get-time) 3) 1) 1f0)))
          (draw-circle-v (get-spline-point-bezier-quadratic start control end fraction)
                         8f0 orange))
        (draw-text "Move the mouse to test rectangle overlap" 16 16 20 ink)))))

;; (shapes-demo) also shows every 2D draw call one at a time.
;; (api-guide :shapes-2d "collision")

;; A C output parameter is a place for raylib to store an extra result.
;; Return that point as an ordinary Lisp value. NIL means the lines missed.
(defun line-intersection (a b c d)
  (cffi:with-foreign-object (point '(:struct vector-2))
    (when (check-collision-lines a b c d point)
      (cffi:mem-ref point '(:struct vector-2)))))

;; Raylib expects adjacent vertices for a polygon. The same helper is used
;; in the drawing bindings for triangle strips and splines.
(defun inside-polygon-p (point corners)
  (when (>= (length corners) 3)
    (with-point-array (vertices corners (:struct vector-2))
      (check-collision-point-poly point vertices (length corners)))))
