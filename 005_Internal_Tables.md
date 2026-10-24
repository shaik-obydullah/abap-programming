# Structures & Internal Tables in ABAP

## 1. Theory

### What is a Structure?
A **structure** bundles several fields into one object. You access the fields with a dash `-`.

```abap
DATA: BEGIN OF ls_person,
        name TYPE string,
        age  TYPE i,
        city TYPE string,
      END OF ls_person.

ls_person-name = 'Shaik'.
ls_person-age  = 25.
WRITE: / ls_person-name, ls_person-age.
```

The `BEGIN OF ... END OF` block creates a structure data object. Tip: prefer defining it as a **type** first so it can be reused:

```abap
TYPES: BEGIN OF ty_person,
         name TYPE string,
         age  TYPE i,
         city TYPE string,
       END OF ty_person.

DATA ls_person TYPE ty_person.
```

- `TYPES` only *defines* the shape (no memory used yet).
- `DATA ... TYPE ty_person` creates an actual variable of that shape.

### What is an Internal Table?
An **internal table** is a list kept in memory where **every row has the same structure**. On disk they are called *database tables* — internal tables are the same idea, but live only inside your program.

```abap
DATA lt_people TYPE TABLE OF ty_person.
```

- `lt_` prefix = **l**ocal **t**able.
- Empty at first — you must add rows with `APPEND`.

### APPEND (add a row)
Fill a work area, then copy it into the table:

```abap
ls_person-name = 'Shaik'.
ls_person-age  = 25.
APPEND ls_person TO lt_people.
```

One `APPEND` adds one *copy* of the work area as the last row. The work area keeps its values, so refill it for each row.

### LOOP AT (go through all rows)
`LOOP AT ... INTO` walks each row and copies it into the work area:

```abap
LOOP AT lt_people INTO ls_person.
  WRITE: / ls_person-name, ls_person-age.
ENDLOOP.
```

- Must end with **`ENDLOOP`**.
- `sy-tabix` holds the current row number inside the loop (1, 2, 3...).

### READ TABLE (find one row)
Searches for a matching row and **returns `sy-subrc = 0` if found**:

```abap
READ TABLE lt_people INTO ls_person WITH KEY name = 'Alice'.
IF sy-subrc = 0.
  WRITE: / 'Found', ls_person-city.
ELSE.
  WRITE: / 'Not found'.
ENDIF.
```

### SORT (order the rows)
Sorts the table in place:

```abap
SORT lt_people BY age.
SORT lt_people BY name DESCENDING.
```

### LINES (how many rows?)
Built-in function returning the row count:

```abap
WRITE: / 'Total people', lines( lt_people ).
```

### Common table commands at a glance

| Command       | What it does                          |
|---------------|---------------------------------------|
| `APPEND wa TO itab.`   | Adds a copy of wa as the last row |
| `INSERT wa INTO itab INDEX 1.` | Adds a row at a specific position |
| `LOOP AT itab INTO wa.` | Processes each row one by one |
| `READ TABLE itab INTO wa WITH KEY f = v.` | Finds the first matching row |
| `MODIFY itab FROM wa INDEX 3.` | Changes the row at position 3 |
| `DELETE itab INDEX 3.` | Removes the row at position 3 |
| `SORT itab BY field.`   | Sorts the rows |
| `CLEAR itab.`           | Removes all rows |

## 2. Code

```abap
REPORT ztables.

TYPES: BEGIN OF ty_person,
         name TYPE string,
         age  TYPE i,
         city TYPE string,
       END OF ty_person.

DATA ls_person TYPE ty_person.
DATA lt_people TYPE TABLE OF ty_person.

ls_person-name = 'Shaik'.
ls_person-age  = 25.
ls_person-city = 'Hyderabad'.
APPEND ls_person TO lt_people.

ls_person-name = 'Alice'.
ls_person-age  = 30.
ls_person-city = 'Bengaluru'.
APPEND ls_person TO lt_people.

ls_person-name = 'Bob'.
ls_person-age  = 22.
ls_person-city = 'Chennai'.
APPEND ls_person TO lt_people.

WRITE: / 'Total people:', lines( lt_people ).

WRITE: / '--- All rows ---'.
LOOP AT lt_people INTO ls_person.
  WRITE: / sy-tabix, ls_person-name, '|', ls_person-age, '|', ls_person-city.
ENDLOOP.

WRITE: / '--- Find Alice ---'.
READ TABLE lt_people INTO ls_person WITH KEY name = 'Alice'.
IF sy-subrc = 0.
  WRITE: / 'Found', ls_person-name, 'age', ls_person-age, 'in', ls_person-city.
ELSE.
  WRITE: / 'Not found'.
ENDIF.

WRITE: / '--- Sorted by age (ascending) ---'.
SORT lt_people BY age.
LOOP AT lt_people INTO ls_person.
  WRITE: / ls_person-name, '|', ls_person-age.
ENDLOOP.

WRITE: / '--- Sorted by name (descending) ---'.
SORT lt_people BY name DESCENDING.
LOOP AT lt_people INTO ls_person.
  WRITE: / ls_person-name, '|', ls_person-age.
ENDLOOP.
```

### Output
```
Total people:          3
--- All rows ---
         1 Shaik |          25 | Hyderabad
         2 Alice |          30 | Bengaluru
         3 Bob   |          22 | Chennai
--- Find Alice ---
Found Alice age          30 in Bengaluru
--- Sorted by age (ascending) ---
Bob   |          22
Shaik |          25
Alice |          30
--- Sorted by name (descending) ---
Shaik |          25
Bob   |          22
Alice |          30
```

### Line-by-line breakdown

| Line | Meaning |
|------|---------|
| `TYPES: BEGIN OF ty_person, ... END OF ty_person.` | Defines the *shape* of one row. |
| `DATA lt_people TYPE TABLE OF ty_person.` | Creates an empty internal table whose rows are `ty_person`. |
| `ls_person-name = 'Shaik'.` | Fills one field of the work area. |
| `APPEND ls_person TO lt_people.` | Copies the work area into the table as a new last row. |
| `LOOP AT lt_people INTO ls_person.` | Repeats once per row, loading each row into the work area. |
| `sy-tabix` | Row number of the current loop pass (starts at 1). |
| `READ TABLE ... WITH KEY name = 'Alice'.` | Looks up a row; `sy-subrc = 0` means found. |
| `SORT lt_people BY age.` | Sorts rows by age, smallest first. |
| `SORT ... BY name DESCENDING.` | Sorts in reverse alphabetical order. |
| `lines( lt_people )` | Returns the number of rows in the table. |

## 3. Practice

1. Add a 4th person (e.g. `Diana`, 35, `Pune`) with `APPEND` and print all rows again.
2. Use `READ TABLE` to find the youngest person and print their name and age.
3. Loop over the table and count how many people are older than 25:

```abap
DATA lv_count TYPE i.
lv_count = 0.
LOOP AT lt_people INTO ls_person.
  IF ls_person-age > 25.
    lv_count = lv_count + 1.
  ENDIF.
ENDLOOP.
WRITE: / 'People older than 25:', lv_count.
```