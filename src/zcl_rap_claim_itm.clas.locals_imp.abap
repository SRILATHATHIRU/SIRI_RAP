
CLASS lhc_item DEFINITION
  INHERITING FROM cl_abap_behavior_handler

  .
  PRIVATE SECTION.



    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE item.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE item.

    METHODS read FOR READ
      IMPORTING keys FOR READ item RESULT result.


    METHODS rba_header FOR READ
      IMPORTING keys_rba FOR READ item\_Header FULL result_requested RESULT result LINK association_links.



ENDCLASS.

CLASS lhc_item IMPLEMENTATION.

**********************************************************************
*
* Implements the UPDATE operation for a set of booking instances
*
**********************************************************************
  METHOD update.
    DATA: messages TYPE /dmo/t_message,
          item TYPE zrap_claim_itm.


    LOOP AT entities ASSIGNING FIELD-SYMBOL(<item>).

      item = CORRESPONDING #( <item> MAPPING FROM ENTITY  ).


      update zrap_claim_itm from @item.

    ENDLOOP.
  ENDMETHOD.


**********************************************************************
*
* Implements the DELETE operation for a set of booking instances
*
**********************************************************************
  METHOD delete.
    DATA messages TYPE /dmo/t_message.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<item>).

      delete from zrap_claim_itm where  vbeln = @<item>-claimnumber
                                 and    posnr = @<item>-posnr.
    ENDLOOP.
  ENDMETHOD.


**********************************************************************
*
* Read booking data from buffer
*
**********************************************************************
  METHOD read.
    DATA: header_out   TYPE zrap_claim_hdr,
          items_out TYPE table of zrap_claim_itm,
          messages     TYPE /dmo/t_message.

     "Only one function call for each requested travelid
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<item_by_header>)
                               GROUP BY <item_by_header>-claimnumber .

    select single * from zrap_claim_hdr
       where vbeln = @<item_by_header>-claimnumber into @header_out.
       if sy-subrc = 0.
         select * from zrap_claim_itm
       where vbeln = @<item_by_header>-claimnumber into table @items_out.
       endif.

      IF sy-subrc = 0.
        "For each travelID find the requested bookings
        LOOP AT GROUP <item_by_header> ASSIGNING FIELD-SYMBOL(<item>)
                                          GROUP BY <item>-%tky.

          READ TABLE items_out INTO DATA(item_out) WITH KEY vbeln  = <item>-%key-claimnumber
                                                            posnr  = <item>-%key-posnr .
          "if read was successful
          IF sy-subrc = 0.
            INSERT CORRESPONDING #( item_out MAPPING TO ENTITY ) INTO TABLE result.
          ELSE.
            "BookingID not found

          ENDIF.
        ENDLOOP.
      ENDIF.

    ENDLOOP.


  ENDMETHOD.




***********************************************************************
*
* Read associated travels
*
***********************************************************************
  METHOD rba_Header.
    DATA: header   TYPE zrap_claim_hdr,
          messages TYPE /dmo/t_message.

    "Only one function call for each requested
    LOOP AT keys_rba ASSIGNING FIELD-SYMBOL(<item_by_header>)
                               GROUP BY <item_by_header>-claimnumber .




      IF sy-subrc = 0.
        LOOP AT keys_rba ASSIGNING FIELD-SYMBOL(<header>) USING KEY entity WHERE claimnumber = <item_by_header>-claimnumber.
          INSERT VALUE #(
              source-%tky     = <header>-%tky
              target-claimnumber = <header>-claimnumber
            ) INTO TABLE association_links.

          IF result_requested = abap_true.
            APPEND CORRESPONDING #( header MAPPING TO ENTITY ) TO result.
          ENDIF.
        ENDLOOP.
      ENDIF.

    ENDLOOP.

    SORT association_links BY source ASCENDING.
    DELETE ADJACENT DUPLICATES FROM association_links COMPARING ALL FIELDS.

    SORT result BY %tky ASCENDING.
    DELETE ADJACENT DUPLICATES FROM result COMPARING ALL FIELDS.
  ENDMETHOD.







ENDCLASS.
