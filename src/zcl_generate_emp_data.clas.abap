CLASS zcl_generate_emp_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
   INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GENERATE_EMP_DATA IMPLEMENTATION.


METHOD if_oo_adt_classrun~main.

    DATA itab TYPE TABLE OF zrap_demo_table.

*   fill internal travel table (itab)
    itab = VALUE #(
      ( id = '0000000005' first_name = 'David' last_name = 'Noe'  begin_date = '20220620' end_date = '99991231'
        created_by = 'XXXXXX' created_at = '20220612133945.5960060' last_changed_by = 'XXXXXX' last_changed_at = '20220702105400.3647680' )

      ( id = '0000000006' first_name = 'Ram' last_name = 'Th'  begin_date = '20220620' end_date = '99991231'
        created_by = 'XXXXXX' created_at = '20220612133945.5960060' last_changed_by = 'XXXXXX' last_changed_at = '20220702105400.3647680' )

      ( id = '0000000007' first_name = 'Mani' last_name = 'G'  begin_date = '20220620' end_date = '99991231'
        created_by = 'XXXXXX' created_at = '20220612133945.5960060' last_changed_by = 'XXXXXX' last_changed_at = '20220702105400.3647680' )

    ).

*   delete existing entries in the database table
    DELETE FROM zrap_demo_table.

*   insert the new table entries
    INSERT zrap_demo_table FROM TABLE @itab.

*   output the result as a console message
    out->write( |{ sy-dbcnt } travel entries inserted successfully!| ).

    ENDMETHOD.
ENDCLASS.
