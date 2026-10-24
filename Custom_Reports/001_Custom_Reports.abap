REPORT zcustom_material_report.

TABLES: mara.

* Selection Screen
PARAMETERS: p_max TYPE i DEFAULT 50 OBLIGATORY.
SELECT-OPTIONS: s_mtart FOR mara-mtart,
                s_matkl FOR mara-matkl.

* Data Declarations
DATA: lt_mara TYPE TABLE OF mara,
      ls_mara TYPE mara.

* Main Logic
START-OF-SELECTION.

  " Select materials based on user input
  SELECT * FROM mara
    INTO TABLE lt_mara
    UP TO p_max ROWS
    WHERE mtart IN s_mtart
      AND matkl IN s_matkl.

  " Check if data exists
  IF sy-subrc <> 0 OR lt_mara IS INITIAL.
    WRITE: / 'No materials found for the selected criteria.'.
    EXIT.
  ENDIF.

  " Sort by material type
  SORT lt_mara BY mtart matnr.

* Output
END-OF-SELECTION.

  " Display using basic list
  WRITE: / 'Material List' COLOR COL_HEADING,
           40 'Total Records:', (10) lines( lt_mara ).
  SKIP 1.

  " Header
  WRITE: / 'Material' COLOR COL_HEADING,
           18 'Type' COLOR COL_HEADING,
           25 'Group' COLOR COL_HEADING,
           35 'Created On' COLOR COL_HEADING,
           50 'Base Unit' COLOR COL_HEADING.
  ULINE.

  " Data rows
  LOOP AT lt_mara INTO ls_mara.
    WRITE: / ls_mara-matnr,
             18 ls_mara-mtart,
             25 ls_mara-matkl,
             35 ls_mara-ersda,
             50 ls_mara-meins.
  ENDLOOP.

  SKIP 2.
  WRITE: / 'End of report.'.
