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