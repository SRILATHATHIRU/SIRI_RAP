@AbapCatalog.sqlViewName: 'ZEMPCDSODATA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Odata service for Employee'

define view zemp_cds_odata as select from zrap_demo_table as Employee
 {
    
    key id as id,
    
        first_name as FirstName,
        
        last_name  as LastName,
        
        begin_date as BeginDate,
         
        end_date   as EndDate
     
}
