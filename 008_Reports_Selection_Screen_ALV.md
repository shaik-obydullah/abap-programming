# Selection Screens & ALV Reports in ABAP

## 1. Theory

This lesson is the big one: it combines **user input + database + formatted output** into a complete custom report. You now know internal tables (005) and Open SQL (007) — here you learn how the user drives the report.

### What is a Selection Screen?
Every executable report shows an **input screen** before the logic runs. The user enters criteria, presses **Execute (F8)**, and only then does your `SELECT`/`WRITE` code run.

Two statements create the input fields:

### PARAMETERS — a single input field
```abap
PARAMETERS p_city TYPE c LENGTH 20 DEFAULT 'FRANKFURT'.
PARAMETERS p_top  TYPE i DEFAULT 10.
PARAMETERS p_asc  AS CHECKBOX.
```
- `TYPE` → the data type of the value.
- `DEFAULT` → pre-filled value the user can change.
- `AS CHECKBOX` → a tick-box storing `abap_true`/`abap_false`.
- `OBLIGATORY` → value must not be empty.
- For radio buttons: `RADIOBUTTON GROUP grp1`.

### SELECT-OPTIONS — a range / multi-value field
```abap
SELECT-OPTIONS s_car FOR spfli-carrid.
```
A selection screen table where the user can enter:
- a **single value** (`LH`),
- a **range** (`low = 400`, `high = 500`),
- several rows, and/or
- **excluded** values (green/red traffic light icons).

Internally it is a little table with columns `SIGN`, `OPTION`, `LOW`, `HIGH`. You rarely touch those — you feed it straight into `WHERE ... IN`:

```abap
WHERE carrid IN s_car.
```
The `IN` handles all the sign/option logic for you.

> Old ABAP first declares the table with `TABLES spfli.` so `s_car FOR spfli-carrid` resolves. It still works and is used below.

### Basic flow of a report
```
Selection screen (user input)
        │
        ▼
SELECT ... INTO an internal table    (lesson 007)
        │
        ▼
Process / sort / trim the data       (lessons 005, 009-style logic)
        │
        ▼
Display: basic list (WRITE) or ALV grid
```

### Display options
1. **Basic list** — `WRITE` lines. Simple but plain: no sorting, no totals, no export.
2. **ALV (ABAP List Viewer)** — the standard grid SAP users expect: column headings, sorting, filtering, totals, download to Excel, highlight colors.

### Classic ALV — `REUSE_ALV_GRID_DISPLAY`
Works in every SAP system and compiles even in older releases:

```abap
CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    i_structure_name = 'SPFLI'
  TABLES
    t_outtab         = lt_flights.
```
- `i_structure_name` = name of a DDIC structure/table; ALV builds the **field catalog** (column list) from it.
- `t_outtab` = the internal table holding your data.

### Modern ALV — SALV (object-oriented)
The newer, cleaner way; the `TABLE OF` type is enough, no structure name needed:

```abap
DATA lo_alv TYPE REF TO cl_salv_table.
cl_salv_table=>factory(
  IMPORTING
    r_salv_table = lo_alv
  CHANGING
    t_table      = lt_flights ).
lo_alv->display( ).
```

**Which one?** For new code SAP recommends SALV. This lesson shows the classic function module because it is everywhere in existing systems and is the minimum to produce a real report.

## 2. Code

```abap
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
```

### What happens when you run it (F8)
1. A **selection screen** appears: one field for city (pre-filled `FRANKFURT`), one numeric field (top N), a checkbox "p_asc", and the multi-value carrier selection.
2. Press **Execute** → the report reads the flights matching your criteria into `lt_flights`.
3. The grid opens, tabular, with column headings **CarrID, ConnID, Country, CityFrom, AirpFr, Country, CityTo ...**, rows you can sort/filter and export.

Example grid content:
```
CarrID  ConnID  CityFrom     CityTo        Distance
LH      400     FRANKFURT    NEW YORK      6185
LH      402     FRANKFURT    NEW YORK      6185
LH      410     FRANKFURT    CAPE TOWN     6006
...
```

### Same data as a basic list (alternative output)
```abap
LOOP AT lt_flights INTO ls_flight.
  WRITE: / ls_flight-carrid, ls_flight-connid,
           ls_flight-cityfrom, '->', ls_flight-cityto,
           ls_flight-distance.
ENDLOOP.
```

### Line-by-line breakdown

| Line | Meaning |
|------|---------|
| `PARAMETERS p_city TYPE spfli-cityfrom DEFAULT 'FRANKFURT'.` | Single input field on the selection screen, pre-filled. |
| `PARAMETERS p_top TYPE i DEFAULT 10.` | Numeric input for "show only the top N". |
| `PARAMETERS p_asc AS CHECKBOX.` | Boolean tick-box on the selection screen. |
| `SELECT-OPTIONS s_car FOR spfli-carrid.` | Multi-value / range input, with automatic F4 value help. |
| `WHERE carrid IN s_car` | Applies the whole selection (sign/option/low/high) to the query. |
| `IF sy-subrc <> 0. ... EXIT.` | Empty result → message and end the report. |
| `IF p_asc = abap_true.` | Reading the checkbox to decide the sort order. |
| `SORT lt_flights BY distance ...` | Sorting table 005-style instead of in SQL. |
| `DELETE lt_flights TO p_top.` | Removes all rows after position `p_top` (keeps the first N). |
| `CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY' ...` | Displays the result as an interactive grid. |

## 3. Practice

1. Add `PARAMETERS p_min TYPE i DEFAULT 1000.` and only keep flights with `distance >= p_min` (add to the `WHERE`).
2. Instead of `cityfrom`, select flights to a destination: `PARAMETERS p_city TYPE spfli-cityto DEFAULT 'NEW YORK'.`
3. Replace the ALV call with the `LOOP ... WRITE` list version and run it.
4. Test with `s_car`: enter `LH` only, then `LH`..`AA` as a range, then exclude one value using the traffic-light column.

```abap
SELECT * FROM spfli
       INTO TABLE lt_flights
       WHERE carrid IN s_car
         AND distance >= p_min
         AND cityto = p_city.
```