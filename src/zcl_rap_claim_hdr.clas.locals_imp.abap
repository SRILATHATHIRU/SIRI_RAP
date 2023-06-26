CLASS lcl_buffer DEFINITION.

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_buffer_hdr.
             INCLUDE TYPE Zrap_claim_hdr AS data.
    TYPES:   flag TYPE c LENGTH 1,
           END OF ty_buffer_hdr.

    TYPES: BEGIN OF ty_buffer_itm.
             INCLUDE TYPE Zrap_claim_itm AS data.
    TYPES:   flag TYPE c LENGTH 1,
           END OF ty_buffer_itm.
    TYPES: tt_header TYPE SORTED TABLE OF ty_buffer_hdr WITH UNIQUE KEY vbeln.
    TYPES: tt_item TYPE SORTED TABLE OF ty_buffer_itm WITH UNIQUE KEY vbeln posnr.
    CLASS-DATA : lt_item TYPE TABLE OF Zrap_claim_itm.

    CLASS-DATA mt_buffer_hdr TYPE tt_header.
    CLASS-DATA mt_buffer_itm TYPE tt_item.
ENDCLASS.

CLASS lhc_header DEFINITION
   INHERITING FROM cl_abap_behavior_handler.

  .

  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR header RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Header RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE Header.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Header.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Header.

    METHODS read FOR READ
      IMPORTING keys FOR READ Header RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK Header.

    METHODS rba_item FOR READ
      IMPORTING keys_rba FOR READ Header\_Item FULL result_requested RESULT result LINK association_links.

    METHODS cba_item FOR MODIFY
      IMPORTING entities_cba FOR CREATE Header\_Item.




ENDCLASS.
CLASS lhc_header IMPLEMENTATION.



********************************************************************************
*
* Implements global authorization check
*
********************************************************************************
  METHOD get_global_authorizations.
  ENDMETHOD.
********************************************************************************
*
* Implements the dynamic action handling for travel instances
*
********************************************************************************
  METHOD get_instance_features.
    READ ENTITIES OF zrap_i_claim_hdr IN LOCAL MODE
      ENTITY Header
        FIELDS ( Claimnumber RefNumber )
        WITH CORRESPONDING #( keys )
    RESULT DATA(header_read_results)
    FAILED failed.







    result = VALUE #(
          FOR header_read_result IN header_read_results (
            %tky                                = header_read_result-%tky
                          %assoc-_Item               = COND #( WHEN header_read_result-refnumber IS INITIAL
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                                                             ) ).
  ENDMETHOD.

**********************************************************************
*
* Create travel instances
*
**********************************************************************
  METHOD create.
    DATA: messages   TYPE /dmo/t_message,
          header_in  TYPE zrap_claim_hdr,
          header_out TYPE zrap_claim_hdr.

    LOOP AT entities INTO DATA(ls__create).

      INSERT VALUE #( flag = 'C' data = CORRESPONDING #( ls__create-%data MAPPING FROM ENTITY  )  ) INTO TABLE lcl_buffer=>MT_BUFFER_hdr.
      IF ls__create-%cid IS NOT INITIAL.
        INSERT VALUE #( %cid = ls__create-%cid claimnumber = ls__create-claimnumber ) INTO TABLE mapped-header.
      ENDIF.





    ENDLOOP.
  ENDMETHOD.


**********************************************************************
*
* Update data of existing travel instances
*
**********************************************************************
  METHOD update.
    DATA: messages TYPE /dmo/t_message,
          header   TYPE zrap_claim_hdr.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<header_update>).

      SELECT SINGLE * FROM zrap_claim_hdr

        WHERE vbeln = @<header_update>-claimnumber INTO @DATA(header_old).


      header = CORRESPONDING #( <header_update> MAPPING FROM ENTITY USING CONTROL ).

      IF <header_update>-%control-claimtype =  '01'.
        header_old-crtyp = header-crtyp.

      ENDIF.

      IF <header_update>-%control-claimdate =  '01'.
        header_old-fkdat = header-fkdat.

      ENDIF.

      IF <header_update>-%control-transmissiondate =  '01'.
        header_old-btcdt = header-btcdt.

      ENDIF.

      IF <header_update>-%control-claimsource =  '01'.

        header_old-crsrc = header-crsrc.
      ENDIF.





      UPDATE zrap_claim_hdr FROM @header_old.
    ENDLOOP.

    "Loop on Entity to get current values from UI, all updated changed values will be available in <lfs_entity>
*    LOOP AT entities ASSIGNING FIELD-SYMBOL(<header_update>).
*
*      "Check whic values are changed by user
*      "01 = value is updated / changed , 00 = value is not changed
*
*      "Check if Course or CourseDuration values is changed by User
*      CHECK  <header_update>-%control-claimnumber EQ '01' OR <lfs_entity>-%control-Courseduration EQ '01'.
*
*      "Read Entity record and collect on Internal table
*      READ ENTITIES OF zi_student_5000 IN LOCAL MODE
*         ENTITY Student
*         FIELDS ( Course Courseduration ) WITH VALUE #(  (  %key = <lfs_entity>-%key ) )
*         RESULT DATA(lt_studentsCourse).
*
*      IF sy-subrc IS INITIAL.
*        READ TABLE lt_studentsCourse ASSIGNING FIELD-SYMBOL(<lfs_db_course>) INDEX 1.
*        IF sy-subrc IS INITIAL.
*
*          "Collect the updated value from Frontend. If user has updated value on Frontend then get updated value
*          "Else get the value from Database
*          <lfs_db_course>-Course = COND #(  WHEN <lfs_entity>-%control-Course EQ '01' THEN
*                                          <lfs_entity>-Course ELSE <lfs_db_course>-Course
*          ).
*
*          <lfs_db_course>-Courseduration = COND #(  WHEN <lfs_entity>-%control-Courseduration EQ '01' THEN
*                                          <lfs_entity>-Courseduration ELSE <lfs_db_course>-Courseduration
*          ).
*
*          "Business logic per requirement, We are validating Course Duration for Computers can not be less then 5 Yerars
*          IF <lfs_db_course>-Courseduration < 5.
*            IF <lfs_db_course>-Course = 'Computers'.
*
*              "Return Error Message to Frontend.
*              APPEND VALUE #(  %tky =  <lfs_entity>-%tky ) TO failed-student.
*              APPEND VALUE #(  %tky =  <lfs_entity>-%tky
*                               %msg = new_message_with_text(
*                                  severity = if_abap_behv_message=>severity-error
*                                  text = 'Invalid Course duration...'
*                                )  ) TO reported-student.
*            ENDIF.
*          ENDIF.
*        ENDIF.
*      ENDIF.
*    ENDLOOP.

  ENDMETHOD.


**********************************************************************
*
* Delete of travel instances
*
**********************************************************************
  METHOD delete.
    DATA: messages TYPE /dmo/t_message.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<header_delete>).

      DELETE FROM zrap_claim_hdr WHERE vbeln = @<header_delete>-claimnumber.
      DELETE FROM zrap_claim_itm WHERE vbeln = @<header_delete>-claimnumber.

    ENDLOOP.
  ENDMETHOD.


**********************************************************************
*
* Read travel data from buffer
*
**********************************************************************
  METHOD read.
    DATA: header_out TYPE zrap_claim_hdr,
          messages   TYPE /dmo/t_message.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<header_to_read>) GROUP BY <header_to_read>-%tky.

      SELECT SINGLE * FROM zrap_claim_hdr

        WHERE vbeln = @<header_to_read>-claimnumber INTO @header_out.

      IF sy-subrc = 0..
        INSERT CORRESPONDING #( header_out MAPPING TO ENTITY ) INTO TABLE result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


**********************************************************************
*
* Implements the locking logic
*
**********************************************************************
  METHOD lock.

  ENDMETHOD.


**********************************************************************
*
* Read booking data by association from buffer
*
**********************************************************************
  METHOD rba_item.
    DATA: header_out TYPE zrap_claim_hdr,
          item_out   TYPE TABLE OF zrap_claim_itm,
          item       LIKE LINE OF result,
          messages   TYPE /dmo/t_message.


    LOOP AT keys_rba ASSIGNING FIELD-SYMBOL(<header_rba>) GROUP BY <header_rba>-claimnumber.

      SELECT SINGLE * FROM zrap_claim_hdr
       WHERE vbeln = @<header_rba>-claimnumber INTO @header_out.
      IF sy-subrc = 0.
        SELECT * FROM zrap_claim_itm
      WHERE vbeln = @<header_rba>-claimnumber INTO TABLE @item_out.
      ENDIF.

      IF sy-subrc = 0.
        LOOP AT item_out ASSIGNING FIELD-SYMBOL(<item>).
          "fill link table with key fields

          INSERT
            VALUE #(
              source-%tky = <header_rba>-%tky
              target-%tky = VALUE #(
                                claimnumber  = <item>-vbeln
                                posnr = <item>-posnr
              ) )
            INTO TABLE association_links.

          IF result_requested = abap_true.
            item = CORRESPONDING #( <item> MAPPING TO ENTITY ).
            INSERT item INTO TABLE result.
          ENDIF.

        ENDLOOP.
      ENDIF.

    ENDLOOP.

    SORT association_links BY target ASCENDING.
    DELETE ADJACENT DUPLICATES FROM association_links COMPARING ALL FIELDS.

    SORT result BY %tky ASCENDING.
    DELETE ADJACENT DUPLICATES FROM result COMPARING ALL FIELDS.
  ENDMETHOD.


**********************************************************************
*
* Create associated booking instances
*
**********************************************************************
  METHOD cba_item.
    DATA: messages        TYPE /dmo/t_message,
          item_old        TYPE zrap_claim_itm,
          item            TYPE zrap_claim_itm,
          lt_item         TYPE TABLE OF zrap_claim_itm,
          last_booking_id TYPE /dmo/booking_id VALUE '0'.

    LOOP AT entities_cba ASSIGNING FIELD-SYMBOL(<header>).

      DATA(claimnumber) = <header>-claimnumber.

      LOOP AT <header>-%target ASSIGNING FIELD-SYMBOL(<item_create>).

        INSERT VALUE #( flag = 'C' data = CORRESPONDING #( <item_create>-%data MAPPING FROM ENTITY  ) vbeln = claimnumber ) INTO TABLE lcl_buffer=>mt_buffer_itm.
        INSERT VALUE #( %cid = <item_create>-%cid claimnumber = <header>-claimnumber posnr = <item_create>-posnr ) INTO TABLE mapped-item.


      ENDLOOP.

    ENDLOOP.



  ENDMETHOD.






ENDCLASS.



**********************************************************************
*
* Saver class implements the save sequence for data persistence
*
**********************************************************************

CLASS lsc_I_header_U DEFINITION
  INHERITING FROM cl_abap_behavior_saver

  .

  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.



    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_I_header_U IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.



  METHOD save.
    DATA: lt_data_hdr TYPE STANDARD TABLE OF zrap_claim_hdr.
    DATA: lt_data_itm TYPE STANDARD TABLE OF zrap_claim_itm.

    lt_data_hdr = VALUE #( FOR row IN lcl_buffer=>mt_buffer_hdr WHERE ( flag = 'C' ) ( row-data ) ).
    IF lt_data_hdr IS NOT INITIAL.
      INSERT zrap_claim_hdr FROM TABLE @lt_data_hdr.
    ENDIF.
    lt_data_itm = VALUE #( FOR row_itm IN lcl_buffer=>mt_buffer_itm WHERE ( flag = 'C' ) ( row_itm-data ) ).
    IF lt_data_itm  IS NOT INITIAL.
      INSERT zrap_claim_itm FROM TABLE @lt_data_itm .
      IF sy-subrc = 0.
*        data(ls_data_itm) = LT_DATA_ITM[ 1 ].
*        update zrap_claim_hdr set xblnr = 'Created' where vbeln = @ls_data_itm-vbeln.
      ENDIF.
    ENDIF.
    CLEAR lcl_buffer=>mt_buffer_hdr.
    CLEAR lcl_buffer=>lt_item.
  ENDMETHOD.

  METHOD cleanup.
*  CALL FUNCTION '/DMO/FLIGHT_TRAVEL_INITIALIZE'.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
