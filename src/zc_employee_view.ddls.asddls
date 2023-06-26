@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for Employee'
@Search.searchable: true
@UI: { headerInfo: { typeName: 'Employee',
                     typeNamePlural: 'Employee',
                     title: { type: #STANDARD, label: 'Employee', value: 'id' } } }


define root view entity ZC_EMPLOYEE_VIEW as projection on ZI_EMPLOYEE_MODEL {

 @UI.facet: [          { id:                  'Employee',
                                   purpose:         #STANDARD,
                                   type:            #IDENTIFICATION_REFERENCE,
                                   label:           'Employee',
                                   position:        10 }      ]
    
   @EndUserText.label: 'ID'
                      @Search.defaultSearchElement: true
    @UI: { lineItem:       [ { position: 10,label: 'id', importance: #HIGH } ],
               identification: [ { position: 10, label: 'id' } ] }                   
                     key id,
      @EndUserText.label: 'First Name'                
       @Search.defaultSearchElement: true  
       @UI: { lineItem:       [ { position: 20,label: 'FirstName', importance: #HIGH } ],
               identification: [ { position: 20, label: 'FirstName' } ] }     
      first_name         as FirstName,

      @EndUserText.label: 'Last Name'
       @UI: { lineItem:       [ { position: 30,label: 'LastName', importance: #HIGH } ],
               identification: [ { position: 30, label: 'LastName' } ] }    
      last_name           as LastName,     
       @EndUserText.label: 'Begin Date'        
     @UI: { lineItem:       [ { position: 40,label: 'BeginDate', importance: #HIGH } ],
               identification: [ { position: 40, label: 'BeginDate' } ] }    
      begin_date         as BeginDate,
@UI: { lineItem:       [ { position: 50,label: 'EndDate', importance: #HIGH } ],
               identification: [ { position: 50, label: 'EndDate' } ] }   
       @EndUserText.label: 'End Date'
      end_date           as EndDate,    
      last_changed_at    as LastChangedAt            
}
