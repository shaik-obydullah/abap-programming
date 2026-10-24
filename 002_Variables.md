# Variables & Data Types in ABAP

## 1. Theory

### What are Variables?
A variable is a named storage location that holds a value. In ABAP, you **declare** a variable with the `DATA` keyword, then you **assign** values to it with `=`, later **read** the value when needed, and optionally **change** it.

```abap
DATA lv_name TYPE string.      " declaration
lv_name = 'Shaik'.             " assignment
WRITE lv_name.                 " reading
lv_name = 'SAP'.               " reassignment
```

### Naming Conventions (Hungarian Notation)
SAP developers prefix variable names to show scope and type:
- `lv_` → **l**ocal **v**ariable (used inside a program/module)
- `gv_` or `g_` → **g**lobal variable
- `gs_` / `gt_` → **g**lobal **s**tructure / **t**able
- `is_` / `it_` → **i**mporting structure / table (interface parameters)

This is a *convention*, not enforced by the compiler — you can name a variable `x`, but readable code uses these prefixes.

### Core Data Types in ABAP

| TYPE | Meaning        | Example value | Notes                          |
|------|----------------|---------------|--------------------------------|
| `i`  | integer        | `42`          | whole numbers                  |
| `p`  | packed decimal | `19.99`       | for money/calc; `DECIMALS n` sets precision |
| `c`  | character (fixed-length) | `'AB'` | length fixed at declaration |
| `string` | variable-length text | `'Hello'` | grows automatically |
| `d`  | date           | `20260921`    | stored as YYYYMMDD             |
| `t`  | time           | `143000`      | stored as HHMMSS               |
| `x`  | hexadecimal    | `'FF'`        | bytes / binary data            |
| `b`  | boolean (SAP BTP only) | `abap_true`/`abap_false` | |
| `f`  | floating point | `3.14159`     | rarely used in ABAP            |

### Fixed vs. Variable Length Text
- `TYPE c LENGTH 5` declares a text field that is **always** 5 characters (left-aligned, padded with spaces).
- `TYPE string` has **no fixed length** — it grows and shrinks as needed.

### Data Objects are Created with `DATA`
```abap
DATA lv_num TYPE i.
DATA lv_text TYPE string.
DATA lv_price TYPE p LENGTH 8 DECIMALS 2.
DATA lv_date TYPE d.
DATA lv_time TYPE t.
```

The `TYPE` keyword defines which data type the variable has. This is sometimes called a **typed declaration**.

## 2. Code

```abap
REPORT zvariables.

DATA lv_name TYPE string.
DATA lv_age TYPE i.
DATA lv_price TYPE p DECIMALS 2.
DATA lv_date TYPE d.
DATA lv_time TYPE t.

lv_name      = 'Shaik'.
lv_age       = 25.
lv_price     = '99.99'.
lv_date      = '20260921'.
lv_time      = '143000'.

WRITE: / 'Name :', lv_name.
WRITE: / 'Age  :', lv_age.
WRITE: / 'Price:', lv_price.
WRITE: / 'Date :', lv_date.
WRITE: / 'Time :', lv_time.
```

### Output
```
Name :Shaik
Age  :25
Price:99.99
Date :20260921
Time :143000
```

### Line-by-line breakdown

| Line | Meaning |
|------|---------|
| `DATA lv_name TYPE string.` | Declares a text variable named `lv_name`. |
| `lv_age = 25.` | Assigns the value `25`. |
| `lv_price = '99.99'.` | Money values are typed as `p` with 2 decimals. |
| `WRITE: / 'Name :', lv_name.` | Prints label, then the variable's value on a new line. |
| `WRITE: / 'Date :', lv_date.` | Dates print as `YYYYMMDD` raw by default. |

## 3. Practice

1. Add an `lv_city` variable (type `string`), assign your city, and print it.
2. Change `lv_age` to your real age and re-run.
3. Try adding two integers and printing the sum:

```abap
DATA lv_a TYPE i.
DATA lv_b TYPE i.
DATA lv_sum TYPE i.

lv_a = 5.
lv_b = 7.
lv_sum = lv_a + lv_b.

WRITE: / 'Sum =', lv_sum.
```