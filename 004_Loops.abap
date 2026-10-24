REPORT zloops.

DATA lv_count TYPE i.
DATA lv_total TYPE i.
DATA lv_sum   TYPE i.
DATA lv_age   TYPE i.

WRITE: / '--- DO ... TIMES ---'.
DO 5 TIMES.
  WRITE: / 'Loop number', sy-index.
ENDDO.

WRITE: / '--- DO WHILE ... ENDDO ---'.
lv_count = 0.
lv_total = 0.
DO WHILE lv_total < 100.
  lv_count = lv_count + 1.
  lv_total = lv_total + 20.
ENDDO.
WRITE: / 'Needed', lv_count, 'steps to reach', lv_total.

WRITE: / '--- DO n ... ENDDO (with condition) ---'.
lv_sum = 0.
DO 10 TIMES.
  IF sy-index MOD 2 = 0.
    CONTINUE.
  ENDIF.
  lv_sum = lv_sum + sy-index.
ENDDO.
WRITE: / 'Sum of odd numbers 1..10 =', lv_sum.

WRITE: / '--- EXIT (stop early) ---'.
DO 100 TIMES.
  IF sy-index * sy-index > 50.
    WRITE: / 'First square above 50 is', sy-index * sy-index.
    EXIT.
  ENDIF.
ENDDO.

WRITE: / '--- Nested loops ---'.
lv_count = 0.
DO 3 TIMES.
  lv_count = lv_count + 1.
  DO 2 TIMES.
    WRITE: / 'Outer', lv_count, 'Inner', sy-index.
  ENDDO.
ENDDO.

WRITE: / '--- Table of multiplication (3 x 10) ---'.
lv_age = 3.
DO 10 TIMES.
  WRITE: / lv_age, 'x', sy-index, '=', lv_age * sy-index.
ENDDO.