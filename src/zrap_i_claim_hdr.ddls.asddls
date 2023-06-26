@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for Claims Header'
define root view entity ZRAP_I_CLAIM_HDR
  as select from zrap_claim_hdr as Header
  composition  [0..*] of ZRAP_I_CLAIM_ITM as _Item
  association  [0..1] to /DMO/I_Customer as _Customer on $projection.Customer = _Customer.CustomerID
  association [0..1] to I_Currency as _Currency on $projection.Currency = _Currency.Currency
  
{
    key Header.vbeln as ClaimNumber,
    crtyp as ClaimType,
    kunag as Customer,
    zuonr as Vin,
    vkorg as SalesOrg,
    vtweg as DistChannel,
    spart as Division,
    bundle_number as BundleNumber,
    waerk as Currency,
    xblnr as RefNumber,
    batch as Batch,
    fkdat as ClaimDate,
    btcdt as TransmissionDate,
    crsrc as ClaimSource,
    @Semantics.amount.currencyCode: 'Currency'
    subamt as Subamt,
    _Item, // Make association public
    _Customer,
    _Currency
}
