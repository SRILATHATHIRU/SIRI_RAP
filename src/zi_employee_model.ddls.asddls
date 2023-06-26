@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Model for employee'
define root view entity ZI_EMPLOYEE_MODEL as select from zrap_demo_table as Employee
 {
    
    key id,
        first_name,
        last_name,
        begin_date,
        end_date,
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
