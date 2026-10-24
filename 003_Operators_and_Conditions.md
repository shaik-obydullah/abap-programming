# Operators & Conditions in ABAP

## 1. Theory

### Arithmetic Operators
ABAP supports the standard math operators. They work on `i`, `p`, `f` types.

| Operator | Meaning      | Example  | Result |
|----------|--------------|----------|--------|
| `+`      | addition     | `5 + 2`  | `7`    |
| `-`      | subtraction  | `5 - 2`  | `3`    |
| `*`      | multiplication | `5 * 2` | `10` |
| `/`      | division     | `5 / 2`  | `2.5`  |
| `DIV`    | integer division | `5 DIV 2` | `2` |
| `MOD`    | remainder    | `5 MOD 2` | `1`  |
| `**`     | exponent     | `2 ** 3` | `8`    |

```abap
DATA lv_result TYPE i.
lv_result = 10 + 5.     " 15
lv_result = (10 - 3) * 2. " 14
lv_result = 17 DIV 5.   " 3
lv_result = 17 MOD 5.   " 2
```

### Comparison Operators
Used to compare values; the result is always **true** or **false**.

| Operator | Alternative | Meaning              |
|----------|-------------|----------------------|
| `=`      | `EQ`        | equal                |
| `<>`     | `NE`        | not equal            |
| `<`      | `LT`        | less than            |
| `>`      | `GT`        | greater than         |
| `<=`     | `LE`        | less than or equal   |
| `>=`     | `GE`        | greater than or equal |

For text there are also `CP` (contains pattern), `CO`, `CS` (contains string), `CA`, etc.

### Logical Operators (AND / OR / NOT)
Combine multiple comparisons:

```abap
IF lv_age >= 18 AND lv_age <= 60.
  WRITE 'Adult working age'.
ENDIF.

IF lv_grade = 'A' OR lv_grade = 'B'.
  WRITE 'Passed with merit'.
ENDIF.

IF NOT lv_flag = abap_true.
  WRITE 'Flag is off'.
ENDIF.
```

### IF / ELSEIF / ELSE
The most common way to branch your code:

```abap
IF lv_score >= 90.
  WRITE 'Grade: A'.
ELSEIF lv_score >= 75.
  WRITE 'Grade: B'.
ELSEIF lv_score >= 50.
  WRITE 'Grade: C'.
ELSE.
  WRITE 'Grade: F'.
ENDIF.
```

- `IF` must always end with **`ENDIF`**.
- `ELSEIF` chains more conditions (only checked if previous ones were false).
- `ELSE` catches everything else.

### CASE / WHEN
Use `CASE` when you compare one variable against many specific values:

```abap
CASE lv_day.
  WHEN 'MON'.        WRITE 'Start of week'.
  WHEN 'FRI'.        WRITE 'Almost weekend!'.
  WHEN 'SAT' OR 'SUN'. WRITE 'Weekend'.
  WHEN OTHERS.       WRITE 'Normal day'.
ENDCASE.
```

- `CASE` ends with **`ENDCASE`**.
- `WHEN OTHERS` is the fallback (like `ELSE`).

### IF vs CASE — which to use?
- **IF** → ranges, multiple conditions, AND/OR combinations.
- **CASE** → exact equality against a fixed list of values.

### String Concatenation (joining text)
Use `&&` to join strings together:

```abap
DATA lv_first TYPE string.
DATA lv_last  TYPE string.
DATA lv_full  TYPE string.

lv_first = 'Shaik'.
lv_last  = 'Obydullah'.
lv_full  = lv_first && ' ' && lv_last.

WRITE lv_full.  " Shaik Obydullah
```

## 2. Code

```abap
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
```

### Output
```
Score is        82
Grade: B
  10 + 5  =        15
  10 / 3  =  3.3333333333333333
  10 DIV 3 =         3
  10 MOD 3 =         1
  20% tax  =        20
Weekend!
Name is ALICE_CUSTOMER
```

### Line-by-line breakdown

| Line | Meaning |
|------|---------|
| `DATA lv_total TYPE p DECIMALS 2.` | Decimal type for money/percent calculations. |
| `IF lv_score >= 75.` | Branches based on a comparison. |
| `10 / 3` | Normal division keeps all decimals. |
| `10 DIV 3` | Integer division drops the remainder. |
| `10 MOD 3` | Returns only the remainder (`10 / 3 = 3` remainder `1`). |
| `WHEN 'SAT' OR 'SUN'.` | One `WHEN` branch can match several values. |
| `lv_name = lv_name && '_CUSTOMER'.` | Appends text using the `&&` operator. |

## 3. Practice

1. Ask the user for a number stored in `lv_num` and print whether it is **even or odd** (use `MOD`).
2. Write a `CASE` that prints a message for your week's days.
3. Combine your name and city into one string with `&&`:

```abap
DATA lv_num TYPE i.
lv_num = 7.

IF lv_num MOD 2 = 0.
  WRITE: / 'Even'.
ELSE.
  WRITE: / 'Odd'.
ENDIF.
```