# Loops in ABAP

## 1. Theory

### What is a Loop?
A loop repeats a block of code. In ABAP the common way is `DO ... ENDDO`. Inside the loop, the special field `sy-index` tells you **which run number** you are on (starts at 1).

### DO ... TIMES (fixed number of repeats)
```abap
DO 5 TIMES.
  WRITE: / 'Run', sy-index.
ENDDO.
```
Prints `Run 1` up to `Run 5`.

### DO ... ENDDO with `TIMES` variable
```abap
DATA lv_repeat TYPE i.
lv_repeat = 3.
DO lv_repeat TIMES.
  ...
ENDDO.
```

### DO WHILE ... ENDDO (repeat while true)
`DO WHILE` keeps going **as long as** the condition is true:

```abap
lv_total = 0.
DO WHILE lv_total < 100.
  lv_total = lv_total + 20.
ENDDO.
```

- Danger: if the condition never becomes false, the loop runs forever (**infinite loop**). Always make sure something inside changes the condition.

### CONTINUE (skip one run)
Jumps to the next repetition straight away, skipping the rest of the current run:

```abap
DO 5 TIMES.
  IF sy-index = 3.
    CONTINUE.          " skip number 3
  ENDIF.
  WRITE sy-index.
ENDDO.
```
Prints `1 2 4 5`.

### EXIT (stop the whole loop)
Leaves the loop completely, even if more runs remain:

```abap
DO 100 TIMES.
  IF sy-index > 5.
    EXIT.
  ENDIF.
  WRITE sy-index.
ENDDO.
```
Prints `1 2 3 4 5` then stops.

### Nested loops
A loop inside a loop is fine. Each inner loop has its own `sy-index`, so track the outer run number with your own variable.

```abap
DATA lv_outer TYPE i.
lv_outer = 0.
DO 3 TIMES.
  lv_outer = lv_outer + 1.
  DO 2 TIMES.
    WRITE: / lv_outer, sy-index.
  ENDDO.
ENDDO.
```

## 2. Code

```abap
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
```

### Output
```
--- DO ... TIMES ---
Loop number         1
Loop number         2
Loop number         3
Loop number         4
Loop number         5
--- DO WHILE ... ENDDO ---
Needed          5 steps to reach         100
--- DO n ... ENDDO (with condition) ---
Sum of odd numbers 1..10 =         25
--- EXIT (stop early) ---
First square above 50 is         64
--- Nested loops ---
Outer          1 Inner          1
Outer          1 Inner          2
Outer          2 Inner          1
Outer          2 Inner          2
Outer          3 Inner          1
Outer          3 Inner          2
--- Table of multiplication (3 x 10) ---
          3 x          1 =          3
          3 x          2 =          6
          3 x          3 =          9
          3 x          4 =         12
          3 x          5 =         15
          3 x          6 =         18
          3 x          7 =         21
          3 x          8 =         24
          3 x          9 =         27
          3 x         10 =         30
```

### Line-by-line breakdown

| Line | Meaning |
|------|---------|
| `DO 5 TIMES.` | Repeats the block exactly 5 times. |
| `sy-index` | Built-in field holding the current run number (1, 2, 3...). |
| `DO WHILE lv_total < 100.` | Repeats only while the total is below 100. |
| `lv_count = lv_count + 1.` | Counts how many runs happened. |
| `IF sy-index MOD 2 = 0. CONTINUE.` | Odd/even check: skips even runs. |
| `EXIT.` | Ends the loop immediately. |
| `DO 3 TIMES. ... DO 2 TIMES.` | Nested loops — inner index resets each outer run. |

## 3. Practice

1. Print the numbers from **1 to 20** using `DO 20 TIMES` and `sy-index`.
2. Print the **even numbers** from 2 to 20 only (hint: `MOD` + `CONTINUE`).
3. Use a `DO WHILE` loop to add `7` over and over until the total passes `100`, then print how many additions it took.
4. Print a multiplication table for **7** (from `7 x 1` to `7 x 10`).

```abap
DATA lv_n TYPE i.
lv_n = 1.
DO WHILE lv_n <= 10.
  WRITE: / lv_n, 'squared =', lv_n * lv_n.
  lv_n = lv_n + 1.
ENDDO.
```