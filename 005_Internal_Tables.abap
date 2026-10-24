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