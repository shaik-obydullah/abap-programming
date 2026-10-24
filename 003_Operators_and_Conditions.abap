REPORT zoperators.

DATA lv_score TYPE i.
DATA lv_total TYPE p DECIMALS 2.
DATA lv_day   TYPE string.
DATA lv_name  TYPE string.

lv_score = 82.
lv_total = 100.
lv_day   = 'SAT'.
lv_name  = 'ALICE'.

WRITE: / 'Score is', lv_score.

IF lv_score >= 90.
  WRITE: / 'Grade: A'.
ELSEIF lv_score >= 75.
  WRITE: / 'Grade: B'.
ELSE.
  WRITE: / 'Grade: C or lower'.
ENDIF.

WRITE: / '  10 + 5  =', 10 + 5.
WRITE: / '  10 / 3  =', 10 / 3.
WRITE: / '  10 DIV 3 =', 10 DIV 3.
WRITE: / '  10 MOD 3 =', 10 MOD 3.
WRITE: / '  20% tax  =', lv_total * 20 / 100.

CASE lv_day.
  WHEN 'MON'.      WRITE: / 'Start of week'.
  WHEN 'FRI'.      WRITE: / 'Almost weekend!'.
  WHEN 'SAT' OR 'SUN'. WRITE: / 'Weekend!'.
  WHEN OTHERS.     WRITE: / 'Normal day'.
ENDCASE.

lv_name = lv_name && '_CUSTOMER'.
WRITE: / 'Name is', lv_name.