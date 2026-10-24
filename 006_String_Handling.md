# String Handling in ABAP

## 1. Theory

### Recap: Types of Text
From lesson 002, ABAP has two text types:
- `TYPE string` — variable-length text, grows as needed.
- `TYPE c LENGTH n` — fixed-length text, always `n` chars (padded with spaces).

Most string commands work on both.

### Length — `strlen( )`
Returns how many characters the string contains:

```abap
DATA lv_text TYPE string.
lv_text = 'Hello'.
WRITE: / strlen( lv_text ).   " 5
```

### Change Case — `TRANSLATE ... TO UPPER / LOWER CASE`
```abap
TRANSLATE lv_text TO UPPER CASE.   " hello -> HELLO
TRANSLATE lv_text TO LOWER CASE.   " HELLO -> hello
```

### Trim & Collapse Spaces — `CONDENSE`
Removes leading/trailing spaces. By default also squeezes multiple middle spaces into one:

```abap
lv_text = '   a   b   '.
CONDENSE lv_text.            " 'a b'
CONDENSE lv_text NO-GAPS.    " 'ab'  (removes every space)
```

### Grab Part of a String — offset/length `+off(len)`
ABAP extracts a substring with a *slice* notation:

```abap
lv_text   = 'Hello SAP'.
lv_result = lv_text+0(5).   " first 5 chars -> 'Hello'
lv_result = lv_text+6(3).   " from char 7, 3 chars -> 'SAP'
```

Position 0 is the first character. The syntax is `text+offset(length)`.

### Search — `FIND ... IN`
`FIND` sets `sy-subrc = 0` if the text was found:

```abap
FIND 'SAP' IN lv_text.
IF sy-subrc = 0.
  WRITE 'Found'.
ENDIF.

FIND FIRST OCCURRENCE OF 'SAP' IN lv_text MATCH OFFSET lv_pos.
" lv_pos = 0-based position where 'SAP' starts
```

### Replace — `REPLACE ... IN ... WITH ...`
```abap
REPLACE 'SAP' IN lv_text WITH 'ABAP'.
REPLACE FIRST OCCURRENCE OF 'x' IN lv_text WITH 'y'.
```

### Split — `SPLIT ... AT ...`
Cuts a string into pieces. Pieces can go into separate variables or into an internal table:

```abap
SPLIT 'Shaik Obydullah' AT ' ' INTO lv_first lv_last.

DATA lt_words TYPE TABLE OF string.
SPLIT lv_text AT ' ' INTO TABLE lt_words.
```

### String Comparison Operators
Text versions of the comparison operators are very useful:

| Operator | Meaning                        | Example               |
|----------|--------------------------------|-----------------------|
| `CS`     | contains **s**tring            | `IF text CS 'SAP'`    |
| `NS`     | **n**ot contains string        | `IF text NS 'X'`      |
| `CP`     | contains **p**attern (`*`,`+`) | `IF text CP 'A*'`     |
| `NP`     | not contains pattern           |                       |
| `CO`     | contains **o**nly these chars  | `IF text CO 'ABC123'` |
| `CA`     | contains **a**ny of these chars| `IF text CA '0123'`   |
| `NA`     | not contains any               |                       |

For exact match you can write `text = 'SAP'` (or `text EQ 'SAP'`).

## 2. Code

```abap
REPORT zstrings.

DATA lv_text   TYPE string.
DATA lv_result TYPE string.
DATA lv_pos    TYPE i.
DATA lt_words  TYPE TABLE OF string.
DATA lv_word   TYPE string.

lv_text = 'Hello SAP World 2026'.

WRITE: / '--- Basics ---'.
WRITE: / 'Text   :', lv_text.
WRITE: / 'Length :', strlen( lv_text ).
WRITE: / 'First 5 chars:', lv_text+0(5).

lv_result = lv_text.
TRANSLATE lv_result TO UPPER CASE.
WRITE: / 'UPPER  :', lv_result.

TRANSLATE lv_result TO LOWER CASE.
WRITE: / 'lower  :', lv_result.

CONDENSE lv_text.
WRITE: / 'Trimmed:', lv_text.

WRITE: / '--- Search & Replace ---'.
FIND 'SAP' IN lv_text.
IF sy-subrc = 0.
  WRITE: / 'Contains SAP'.
ENDIF.

FIND FIRST OCCURRENCE OF 'World' IN lv_text MATCH OFFSET lv_pos.
WRITE: / 'World starts at position', lv_pos.

REPLACE 'SAP' IN lv_text WITH 'ABAP'.
WRITE: / 'After replace:', lv_text.

WRITE: / '--- Split into words ---'.
REPLACE '2026' IN lv_text WITH '2026 lesson'.
SPLIT lv_text AT ' ' INTO TABLE lt_words.
LOOP AT lt_words INTO lv_word.
  WRITE: / 'Word:', lv_word.
ENDLOOP.

WRITE: / '--- String comparisons ---'.
IF lv_text CS 'ABAP'.
  WRITE: / 'Contains (CS) ABAP'.
ENDIF.

IF lv_text CO 'ABCDEFGHIJKLMNOPQRSTUVWXYZ '.
  WRITE: / 'Only letters and spaces (CO)'.
ELSE.
  WRITE: / 'Has digits too (CO fails)'.
ENDIF.
```

### Output
```
--- Basics ---
Text   :Hello SAP World 2026
Length :        21
First 5 chars:Hello
UPPER  :HELLO SAP WORLD 2026
lower  :hello sap world 2026
Trimmed:Hello SAP World 2026
--- Search & Replace ---
Contains SAP
World starts at position        11
After replace:Hello ABAP World 2026
--- Split into words ---
Word:Hello
Word:ABAP
Word:World
Word:2026
Word:lesson
--- String comparisons ---
Contains (CS) ABAP
Has digits too (CO fails)
```

### Line-by-line breakdown

| Line | Meaning |
|------|---------|
| `strlen( lv_text )` | Returns the number of characters. |
| `lv_text+0(5)` | Slice: characters from offset 0, length 5. |
| `TRANSLATE lv_result TO UPPER CASE.` | Converts every letter to uppercase. |
| `CONDENSE lv_text.` | Removes leading/trailing spaces and collapses runs of spaces. |
| `FIND 'SAP' IN lv_text.` | Checks if the text is present; `sy-subrc = 0` means found. |
| `... MATCH OFFSET lv_pos.` | Also hands back where the match starts (0 = first character). |
| `REPLACE 'SAP' ... WITH 'ABAP'.` | Swaps the first occurrence of `SAP` for `ABAP`. |
| `SPLIT lv_text AT ' ' INTO TABLE lt_words.` | Cuts the text at every space, filling an internal table. |
| `IF lv_text CS 'ABAP'.` | True when the text *contains* the string `ABAP`. |
| `IF lv_text CO 'ABC ... Z '.` | True only if every character is a letter or space — digits break it. |

## 3. Practice

1. Split `'Shaik Obydullah'` into first name and last name and print each.
2. Find the position of the first `o` in `'Hello World'` and print it (use `FIND` + `MATCH OFFSET`).
3. Count how many words are in a sentence using `SPLIT ... INTO TABLE` and `lines( )`.
4. Take a word, convert it to uppercase, and check with `CO` whether it contains only letters.

```abap
DATA lv_full TYPE string.
DATA lv_first TYPE string.
DATA lv_last  TYPE string.

lv_full = 'Shaik Obydullah'.
SPLIT lv_full AT ' ' INTO lv_first lv_last.
WRITE: / 'First:', lv_first.
WRITE: / 'Last :', lv_last.
```