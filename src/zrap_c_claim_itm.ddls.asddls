@EndUserText.label: 'Claim Item - Projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZRAP_C_CLAIM_ITM as projection on ZRAP_I_CLAIM_ITM
{
@EndUserText.label: 'ClaimNumber' 
    key ClaimNumber,
@EndUserText.label: 'ClaimItem'     
    key Posnr,
@EndUserText.label: 'Billing Date'     
    BellingDate,
@EndUserText.label: 'Materia'     
    Material,
@EndUserText.label: 'Quantity'     
    Quantity,
@EndUserText.label: 'UOM'     
    Uom,
@EndUserText.label: 'Plant'     
    Plant,
@EndUserText.label: 'ZVin'     
    Zvin,
@EndUserText.label: 'Model Year'     
    ModelYear,
@EndUserText.label: 'Ztrim'     
    ZTrim,
@EndUserText.label: 'Zip'     
    Zip,
@EndUserText.label: 'SellSource'     
    SellSource,
@EndUserText.label: 'Incentive code'     
    IncentiveCode,
@EndUserText.label: 'SiteCode'     
    SiteCode,
@EndUserText.label: 'Country'     
    Country,
@EndUserText.label: 'Payee'     
    Payee,
    /* Associations */
    _Header : redirected to parent ZRAP_C_CLAIM_HDR
} 
