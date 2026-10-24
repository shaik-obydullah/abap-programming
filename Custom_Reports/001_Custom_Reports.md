# Custom Reports Basics

## 1. Theory

### What is a Custom Report?
A **custom report** (also called a Z/Y report) is an executable ABAP program you create to meet a specific business requirement. Unlike standard SAP reports, you design the selection criteria, logic, and output yourself.

### Report Structure
A typical custom report follows this flow:

```
REPORT zmy_report.                " 1. Program declaration
TABLES: mara.                     " 2. (Optional) Table for selection screens
* Selection screen
PARAMETERS: p_matnr TYPE mara-matnr.
SELECT-OPTIONS: s_mtart FOR mara-mtart.
* Data declarations
DATA: lt_mara TYPE TABLE OF mara,
      ls_mara TYPE mara.
* Events
START-OF-SELECTION.               " 3. Main logic
  SELECT * FROM mara INTO TABLE lt_mara WHERE ...
* Output
END-OF-SELECTION.                 " 4. Display
  ...
```

### Key Elements

| Element | Purpose | Notes |
| --- | --- | --- |
| `REPORT` | Must be first statement in executable report | Use Z or Y namespace for custom objects |
| `PARAMETERS` | Single value input | Good for exact values, dates, flags |
| `SELECT-OPTIONS` | Range/multiple values | Most common for filtering; supports ranges, excludes, multiple entries |
| `START-OF-SELECTION` | Default event, runs after selection screen | Where you put your main processing logic |
| `END-OF-SELECTION` | Runs after START-OF-SELECTION | Good place for output (especially when using ALV) |
| `TOP-OF-PAGE` | For basic lists | Prints header when using WRITE with page breaks |

### Best Practices
- **Use clear names**: `ZREPORT_MATERIAL_LIST` is better than `ZREP1`
- **Validate input**: Check if required fields are filled or if results exist
- **Limit data**: Don't select without WHERE clauses on large tables
- **Use internal tables**: Process data in memory before displaying
- **Consider ALV**: For user-friendly reports with sorting/filtering/exporting

## 2. Code

Create this as `ZCUSTOM_MATERIAL_REPORT` in your system. For learning, save it as `001_Custom_Reports_Basics.abap`.

```abap
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
```

### What this does:
1. Prompts user for max records and material type/group filters
2. Selects up to `p_max` rows from MARA (Material Master)
3. Validates results
4. Displays a formatted basic list with headers and lines

## 3. Practice

Try these exercises to solidify your understanding:

1. **Add a new filter**: Add `SELECT-OPTIONS` for `ERSDA` (Created On) and include it in the WHERE clause.
2. **Add totals**: Count materials by `MTART` and display a summary at the end.
3. **Convert to ALV**: Replace the basic list with `REUSE_ALV_GRID_DISPLAY` (like lesson 008). You'll need to pass `lt_mara` directly since MARA is a transparent table.
4. **Add validation**: If user enters `p_max` less than 1 or greater than 1000, display an error message using `MESSAGE e000(00) WITH 'Invalid value'` or `WRITE` with exit.
5. **Add selection screen text**: Use `SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.` to group your fields nicely.

### Hint for exercise 3:
```abap
* Replace END-OF-SELECTION output with:
END-OF-SELECTION.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_structure_name = 'MARA'
    TABLES
      t_outtab         = lt_mara.
```

**Tip:** In real projects, you'd create this as a report transaction (SE93) so users can run it without going into SE38!
