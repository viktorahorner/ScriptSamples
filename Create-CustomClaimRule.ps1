function Create-CustomClaimRule
{
#Edit this part if you want editional claims in your token
$claimdefinition = @('{
	    "ClaimsMappingPolicy":{
	        "Version": 1,
	        "IncludeBasicClaimSet": "true",
	        "ClaimsSchema": [
	            {
	                "Source": "user",
	                "ID": "onpremisessamaccountname",
	                "JwtClaimType": "onpremisessamaccountname"
	            },
	            {
	                "Source": "user",
	                "ID": "extensionattribute12",
	                "JwtClaimType": "extensionattribute12"
	            }
	        ]
	    }
	}')
  #--- End claim configuration
  $claimrulename = 'SamAccountName-Attribute12' #Here you can configure the name of your policy
  write-host 'Trying to create '$claimrulename -backgroundcolor DarkGray
  try
  {
  $custompolicy = New-AzureADPolicy -Definition $claimdefinition -DisplayName $claimrulename -Type "ClaimsMappingPolicy" -ErrorAction stop #policy is created in this line
  write-host 'Successful created '$claimrulename -ForegroundColor Green
  }
  catch
  {
    write-host 'Creation of '$claimrulename' failed' -backgroundcolor DarkRed
  }

  $serviceprincipal = (Get-AzureADServicePrincipal -top 1).objectid #geting ServicePrincipalID from your tenant
    write-host 'Trying to Activate '$claimrulename -backgroundcolor DarkGray
  try
  {
  Add-AzureADServicePrincipalPolicy -Id $serviceprincipal -RefObjectId $custompolicy.id -ErrorAction stop
    write-host 'Successful activated '$claimrulename -ForegroundColor Green
  }
  catch
  {
      write-host 'Activation of '$claimrulename' failed' -backgroundcolor DarkRed
  }
  }
