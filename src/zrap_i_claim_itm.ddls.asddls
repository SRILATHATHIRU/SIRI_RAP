@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for claim items'
define view entity ZRAP_I_CLAIM_ITM as select from zrap_claim_itm as Item
association to parent ZRAP_I_CLAIM_HDR as _Header
    on $projection.ClaimNumber = _Header.ClaimNumber
{
    key Item.vbeln as ClaimNumber,
    key Item.posnr as Posnr,
    stadat as BellingDate,
    matid as Material,
    fkimg as Quantity,
    uomid as Uom,
    werks as Plant,
    zvin as Zvin,
    zmodyr as ModelYear,
    ztrim as ZTrim,
    zpyzip as Zip,
    zprocess_srce as SellSource,
    zinctvcd as IncentiveCode,
    zsitecd as SiteCode,
    zdest_cntry as Country,
    zpayee as Payee,
    _Header // Make association public
}
