;;; -*- encoding: utf-8; indent-tabs-mode: nil -*-
;;;
;;; Fixing issue 1 from 2025-03-05, an off-by-one error on day names.
;;;

(defun fix-issue () (interactive)
(progn
  (set-buffer-file-coding-system 'utf-8)
  (beginning-of-buffer)(query-replace "Segno"    "Ihud")
  (beginning-of-buffer)(query-replace "Maksegno" "Sanyo")
  (beginning-of-buffer)(query-replace "Rob"      "Maksanyo")     ; beware of Rob as the abbreviation of a 3-letter word!
  (beginning-of-buffer)(query-replace "Hamus"    "Rob")
  (beginning-of-buffer)(query-replace "Arb"      "Hamus")        ; beware of Arb as the abbreviation of a 3-letter word!
  (beginning-of-buffer)(query-replace "Qedame"   "Arb")
  (beginning-of-buffer)(query-replace "Ehud"     "Kidamme")
  (beginning-of-buffer)(query-replace-regexp "\\<Seg\\>" "Ihu")
  (beginning-of-buffer)(query-replace-regexp "\\<Mak\\>" "San")
  (beginning-of-buffer)(query-replace-regexp "\\<Rob\\>" "Mak")  ; beware of Rob as a full 3-letter word!
  (beginning-of-buffer)(query-replace-regexp "\\<Ham\\>" "Rob")
  (beginning-of-buffer)(query-replace-regexp "\\<Arb\\>" "Ham")  ; beware of Ham as the abbreviation of month Ḥamle!
  (beginning-of-buffer)(query-replace-regexp "\\<Qed\\>" "Arb")  ; beware of Arb as a full 3-letter word!
  (beginning-of-buffer)(query-replace-regexp "\\<Ehu\\>" "Kid")
))
