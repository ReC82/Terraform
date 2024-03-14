#Connect-AZAccount

$sp = New-AzADServicePrincipal -DisplayName TerraformTest -Role "Contributor"
$sp.AppId
$sp.PasswordCredentials.SecretText
<#
PS C:\WINDOWS\system32> $sp.AppId

PS C:\WINDOWS\system32> $sp.PasswordCredentials.SecretText
py_8Q~EYsq_1Otfy9WxX8K2msoFtcXp_x7FMoaQO

[
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "fa58a207-6a0f-4b4e-a26b-8799c00b350c",
    "id": "c20f51b2-62aa-4af4-8033-ed6246ab50ca",
    "isDefault": true,
    "managedByTenants": [],
    "name": "Pass Azure - Sponsorship",
    "state": "Enabled",
    "tenantId": "fa58a207-6a0f-4b4e-a26b-8799c00b350c",
    "user": {
      "name": "lody.devops@gmail.com",
      "type": "user"
    }
  
#>