function Get-WsusProductTree
{
  param (
    [Microsoft.UpdateServices.Internal.BaseApi.UpdateServer]$Server,
    [switch]$ByGuid
  )
  $result = @{}
  $allproducts = $Server.GetUpdateCategories()
  $companies = $allproducts.Where({ $_.Type -eq 'Company' })
  foreach ($company in $companies)
  {
    if ($ByGuid.ToBool())
    {
      $result[$company.Id.Guid] = $company.Title
    }
    else
    {
      $result[$company.Title] = $company.Id.Guid
    }
    $families = $company.GetSubcategories()
    foreach ($family in $families)
    {
      if ($ByGuid.ToBool())
      {
        $result[$family.Id.Guid] = "$($company.Title)\$($family.Title)"
      }
      else
      {
        $result["$($company.Title)\$($family.Title)"] = $family.Id.Guid
      }
      $products = $family.GetSubcategories()
      foreach ($product in $products)
      {
        if ($ByGuid.ToBool())
        {
          $result[$product.Id.Guid] = "$($company.Title)\$($family.Title)\$($product.Title)"
        }
        else
        {
          $result["$($company.Title)\$($family.Title)\$($product.Title)"] = $product.Id.Guid
        }
      }
    }
  }
  return $result
}
