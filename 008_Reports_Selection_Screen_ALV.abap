REPORT zreport_flights.

TABLES: spfli.

PARAMETERS: p_city TYPE spfli-cityfrom DEFAULT 'FRANKFURT',
            p_top  TYPE i DEFAULT 10,
            p_asc  AS CHECKBOX.
SELECT-OPTIONS: s_car FOR spfli-carrid.

DATA lt_flights TYPE TABLE OF spfli.
DATA ls_flight  TYPE spfli.

SELECT * FROM spfli
       INTO TABLE lt_flights
       WHERE carrid IN s_car
         AND cityfrom = p_city.

IF sy-subrc <> 0.
  WRITE: / 'No flights found for the selected criteria.'.
  EXIT.
ENDIF.

IF p_asc = abap_true.
  SORT lt_flights BY distance ASCENDING.
ELSE.
  SORT lt_flights BY distance DESCENDING.
ENDIF.

IF lines( lt_flights ) > p_top.
  DELETE lt_flights TO p_top.
ENDIF.

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    i_structure_name = 'SPFLI'
  TABLES
    t_outtab         = lt_flights.