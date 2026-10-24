# SQL (Open SQL) in ABAP

## 1. Theory

### What is Open SQL?
Open SQL is SAP's own SQL dialect. It works **identically on every database** (HANA, Oracle, DB2, SQL Server) because the system translates it in the background. You use it to read and change data in SAP's dictionary (DDIC) tables from inside your ABAP program.

Key rules:
- Every statement ends with a period `.`
- Keywords are uppercase by convention (not required)
- Results are stored in **internal tables** or single work areas
- The classic flight model tables are used everywhere for practice: `SPFLI` (flight schedule), `SCARR` (airlines), `SFLIGHT` (bookable flight dates)

### The basic SELECT — load rows into an internal table
```abap
DATA lt_flights TYPE TABLE OF spfli.

SELECT * FROM spfli INTO TABLE lt_flights.
```
- `SELECT *` means **all columns**.
- `INTO TABLE lt_...` loads **many rows** at once.
- No `WHERE` means the whole table — fine for tiny tables, dangerous on big ones.

### WHERE — filter the rows
```abap
SELECT * FROM spfli INTO TABLE lt_flights
       WHERE carrid = 'LH'
       AND   cityfrom = 'FRANKFURT'.
```
Operators: `=` `<` `>` `<=` `>=` `<>` (not equal). Text also supports `LIKE` with `%` (any characters) and `_` (exactly one):

```abap
WHERE cityfrom LIKE 'FR%'       " starts with 'FR'
WHERE carrid IN ('LH', 'AA')     " matches a list
WHERE distance BETWEEN 3000 AND 8000
```

Combine with `AND` / `OR`; use parentheses when mixing them so the logic is clear:
```abap
WHERE ( carrid = 'LH' AND cityfrom = 'FRANKFURT' )
   OR  carrid = 'AA'
```

### INTO — table vs. single row
- `INTO TABLE lt_rows` → many rows.
- `INTO ls_row`   → one row; combine with `SELECT SINGLE`.

### SELECT SINGLE — exactly one row
```abap
SELECT SINGLE carrid connid FROM spfli
       INTO CORRESPONDING FIELDS OF ls_flight
       WHERE carrid = 'LH' AND connid = '400'.
```
- `sy-subrc = 0` means a row was found, `4` means none.

### Specific columns + CORRESPONDING FIELDS
List only the columns you need; `CORRESPONDING FIELDS` matches them by name into the target:
```abap
SELECT carrid connid cityfrom cityto
       FROM spfli
       INTO CORRESPONDING FIELDS OF TABLE lt_flights
       WHERE cityfrom = 'NEW YORK'.
```

### ORDER BY / UP TO n ROWS
```abap
SELECT * FROM spfli
       INTO TABLE lt_flights
       WHERE carrid = 'LH'
       ORDER BY distance DESCENDING
       UP TO 10 ROWS.
```
`ASCENDING` is the default; `UP TO n ROWS` limits the result.

### Aggregates — COUNT, SUM, AVG, MIN, MAX
```abap
DATA lv_cnt TYPE i.
SELECT COUNT( * ) FROM spfli INTO lv_cnt
       WHERE carrid = 'LH'.

SELECT SUM( distance ) FROM spfli INTO lv_sum
       WHERE carrid = 'LH'.
```
The result is stored with `INTO` + a simple variable (without a table).

### GROUP BY — one row per group
```abap
SELECT carrid COUNT( * ) AS cnt
       FROM spfli
       INTO CORRESPONDING FIELDS OF TABLE lt_grp
       GROUP BY carrid.
```
Each airline appears once, with the count of its flights. `HAVING` would filter groups (like `WHERE` does for rows).

### JOIN — combine two tables
Columns are prefixed with the table name and a tilde `~`:
```abap
SELECT spfli~carrid spfli~connid scarr~carrname
       FROM spfli
       INNER JOIN scarr ON scarr~carrid = spfli~carrid
       INTO CORRESPONDING FIELDS OF TABLE lt_join
       WHERE spfli~carrid = 'LH'.
```

### sy-subrc and sy-dbcnt
- `sy-subrc = 0` success, `4` = no rows matched.
- `sy-dbcnt` = number of rows processed by the last DB statement.

### Modifying data (short intro)
```abap
INSERT ztable FROM ls_row.          " add a row
UPDATE ztable SET field = 'x' WHERE key = ... .   " change rows
DELETE FROM ztable WHERE key = ... .              " remove rows
MODIFY ztable FROM ls_row.          " insert or update
```
Modifications need **Database Update Authorization** and are usually done via function modules / BAPIs in real projects. This lesson focuses on `SELECT`, which reports use all the time.

## 2. Code

```abap
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
```

### Output
The numbers depend on the flight data in **your** system. Example from a standard demo system:

```
--- 1. All rows (limited to 5) ---
Rows selected:          5
--- 2. Filter with WHERE ---
LH flights from Frankfurt ->          8 rows
--- 3. Specific columns only ---
AA          17 NEW YORK -> SAN FRANCISCO
AA         218 NEW YORK -> CHICAGO
...
--- 4. SELECT SINGLE ---
Found: LH        400 FRANKFURT -> NEW YORK departs at        0730
--- 5. Aggregates ---
Total LH connections:          8
Total LH distance:      45524
--- 6. GROUP BY ---
LH has         8 connections
AA has         6 connections
...
--- 7. JOIN with SCARR ---
LH        400 -> Lufthansa
LH        402 -> Lufthansa
```

### Line-by-line breakdown

| Line | Meaning |
|------|---------|
| `SELECT * FROM spfli INTO TABLE lt_flights.` | Loads all columns of all rows into an internal table. |
| `INTO TABLE` | Target for many rows (internal table). |
| `WHERE carrid = 'LH' AND cityfrom = 'FRANKFURT'.` | Filters rows on the database — only matching rows are loaded. |
| `INTO CORRESPONDING FIELDS OF TABLE ...` | Fills only the fields with matching names. |
| `SELECT SINGLE ... INTO ls_flight.` | Reads at most one row into a work area. |
| `COUNT( * ) ... INTO lv_cnt` | Aggregate result into a simple variable. |
| `GROUP BY carrid` | Collapses rows per airline; one result row per group. |
| `INNER JOIN scarr ON scarr~carrid = spfli~carrid` | Combines rows that match on the key field. |
| `spfli~carrid` | Tilde is how you write `<table>~<column>` in Open SQL joins. |
| `sy-subrc = 0` | After `SELECT SINGLE`: 0 = found, 4 = not found. |

## 3. Practice

1. `SELECT *` from `SCARR` into an internal table and print each airline code + name.
2. Count flights per airline with `GROUP BY carrid` and print each count.
3. Join `SPFLI` and `SCARR` for flights from your favourite city.
4. Find the **longest** flight: `ORDER BY distance DESCENDING UP TO 1 ROWS`.

```abap
DATA ls_carr  TYPE scarr.
DATA lt_carr  TYPE TABLE OF scarr.

SELECT * FROM scarr INTO TABLE lt_carr.
LOOP AT lt_carr INTO ls_carr.
  WRITE: / ls_carr-carrid, ls_carr-carrname.
ENDLOOP.
```