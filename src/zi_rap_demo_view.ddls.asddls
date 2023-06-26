@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for table ZRAP_DEMO_TABLE'
@Search.searchable: true
define root view entity ZI_RAP_DEMO_VIEW as select from zrap_demo_table as Employee
 {
    @EndUserText.label: 'ID'
    @Search.defaultSearchElement: true
    key id as id,
    @EndUserText.label: 'FirstName' 
        first_name as FirstName,
         @EndUserText.label: 'LastName'
        last_name  as LastName,
         @EndUserText.label: 'BeginDate'
        begin_date as BeginDate,
         @EndUserText.label: 'EndDate'
        end_date   as EndDate,
       /*-- Admin data --*/
      @Semantics.user.createdBy: true
      created_by,
      @Semantics.systemDateTime.createdAt: true
      created_at,
      @Semantics.user.lastChangedBy: true
      last_changed_by,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at
}
