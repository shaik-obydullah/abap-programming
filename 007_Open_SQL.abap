REPORT zsql.

DATA ls_flight  TYPE spfli.
DATA lt_flights TYPE TABLE OF spfli.
DATA lv_cnt     TYPE i.
DATA lv_sum     TYPE i.

WRITE: / '--- 1. All rows (limited to 5) ---'.
SELECT * FROM spfli UP TO 5 ROWS INTO TABLE lt_flights.
WRITE: / 'Rows selected:', lines( lt_flights ).

WRITE: / '--- 2. Filter with WHERE ---'.
SELECT * FROM spfli INTO TABLE lt_flights
       WHERE carrid = 'LH' AND cityfrom = 'FRANKFURT'.
WRITE: / 'LH flights from Frankfurt ->', lines( lt_flights ), 'rows'.

WRITE: / '--- 3. Specific columns only ---'.
SELECT carrid connid cityfrom cityto
       FROM spfli
       INTO CORRESPONDING FIELDS OF TABLE lt_flights
       WHERE cityfrom = 'NEW YORK'.
LOOP AT lt_flights INTO ls_flight.
  WRITE: / ls_flight-carrid, ls_flight-connid,
           ls_flight-cityfrom, '->', ls_flight-cityto.
ENDLOOP.

WRITE: / '--- 4. SELECT SINGLE ---'.
SELECT SINGLE * FROM spfli INTO ls_flight
       WHERE carrid = 'LH' AND connid = '400'.
IF sy-subrc = 0.
  WRITE: / 'Found:', ls_flight-carrid, ls_flight-connid,
           ls_flight-cityfrom, '->', ls_flight-cityto,
           'departs at', ls_flight-deptime.
ENDIF.

WRITE: / '--- 5. Aggregates ---'.
SELECT COUNT( * ) FROM spfli INTO lv_cnt WHERE carrid = 'LH'.
WRITE: / 'Total LH connections:', lv_cnt.

SELECT SUM( distance ) FROM spfli INTO lv_sum WHERE carrid = 'LH'.
WRITE: / 'Total LH distance:', lv_sum.

WRITE: / '--- 6. GROUP BY ---'.
DATA: BEGIN OF ls_grp,
        carrid TYPE spfli-carrid,
        cnt    TYPE i,
      END OF ls_grp.
DATA lt_grp LIKE TABLE OF ls_grp.

SELECT carrid COUNT( * ) AS cnt
       FROM spfli
       INTO CORRESPONDING FIELDS OF TABLE lt_grp
       GROUP BY carrid
       ORDER BY cnt DESCENDING.
LOOP AT lt_grp INTO ls_grp.
  WRITE: / ls_grp-carrid, 'has', ls_grp-cnt, 'connections'.
ENDLOOP.

WRITE: / '--- 7. JOIN with SCARR ---'.
DATA: BEGIN OF ls_join,
        carrid   TYPE spfli-carrid,
        connid   TYPE spfli-connid,
        carrname TYPE scarr-carrname,
      END OF ls_join.
DATA lt_join LIKE TABLE OF ls_join.

SELECT spfli~carrid spfli~connid scarr~carrname
       FROM spfli
       INNER JOIN scarr ON scarr~carrid = spfli~carrid
       INTO CORRESPONDING FIELDS OF TABLE lt_join
       WHERE spfli~carrid = 'LH'
       UP TO 5 ROWS.
LOOP AT lt_join INTO ls_join.
  WRITE: / ls_join-carrid, ls_join-connid, '->', ls_join-carrname.
ENDLOOP.