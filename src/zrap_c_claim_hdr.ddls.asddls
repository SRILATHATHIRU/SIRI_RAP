@EndUserText.label: 'Claims Processing'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

@Search.searchable: true

@ObjectModel.semanticKey: [ 'ClaimNumber' ]
define root view entity ZRAP_C_CLAIM_HDR 
provider contract transactional_query
as projection on ZRAP_I_CLAIM_HDR
{
       
@ObjectModel.text.element: ['ClaimNumber']
@EndUserText.label: 'ClaimNumber'      
@Search.defaultSearchElement: true
    key ClaimNumber,
@EndUserText.label: 'Claim Type'     
    ClaimType,
@EndUserText.label: 'Customer'    
@Consumption.valueHelpDefinition: [{

               entity: {
                   name: '/DMO/I_Customer',
                   element: 'CustomerID'
               }}] 
    Customer,
@ObjectModel.text.element: ['VIN']
@Search.defaultSearchElement: true
@EndUserText.label: 'Vin'     
    Vin,
@EndUserText.label: 'Sales .Org'        
    SalesOrg,
@EndUserText.label: 'Dist Channel' 
    DistChannel,
@EndUserText.label: 'Division'     
    Division,
@EndUserText.label: 'Bundle Number'     
    BundleNumber,
@EndUserText.label: 'Currency'      
    Currency,
@EndUserText.label: 'RefNumber'    
    RefNumber,
@EndUserText.label: 'Batch'     
    Batch,
@EndUserText.label: 'Claim Date'      
    ClaimDate,
@EndUserText.label: 'Transimission Date'    
    TransmissionDate,
@EndUserText.label: 'Claim Source'      
    ClaimSource,
@EndUserText.label: 'Amount'     
    Subamt,
    /* Associations */
    _Item : redirected to composition child ZRAP_C_CLAIM_ITM
}
