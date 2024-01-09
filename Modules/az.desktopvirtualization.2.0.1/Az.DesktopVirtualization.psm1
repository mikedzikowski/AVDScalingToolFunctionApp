# region Generated 
  # ----------------------------------------------------------------------------------
  #
  # Copyright Microsoft Corporation
  # Licensed under the Apache License, Version 2.0 (the "License");
  # you may not use this file except in compliance with the License.
  # You may obtain a copy of the License at
  # http://www.apache.org/licenses/LICENSE-2.0
  # Unless required by applicable law or agreed to in writing, software
  # distributed under the License is distributed on an "AS IS" BASIS,
  # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  # See the License for the specific language governing permissions and
  # limitations under the License.
  # ----------------------------------------------------------------------------------
  # Load required Az.Accounts module
  $accountsName = 'Az.Accounts'
  $accountsModule = Get-Module -Name $accountsName
  if(-not $accountsModule) {
    $localAccountsPath = Join-Path $PSScriptRoot 'generated\modules'
    if(Test-Path -Path $localAccountsPath) {
      $localAccounts = Get-ChildItem -Path $localAccountsPath -Recurse -Include 'Az.Accounts.psd1' | Select-Object -Last 1
      if($localAccounts) {
        $accountsModule = Import-Module -Name ($localAccounts.FullName) -Scope Global -PassThru
      }
    }
    if(-not $accountsModule) {
      $hasAdequateVersion = (Get-Module -Name $accountsName -ListAvailable | Where-Object { $_.Version -ge [System.Version]'1.8.1' } | Measure-Object).Count -gt 0
      if($hasAdequateVersion) {
        $accountsModule = Import-Module -Name $accountsName -MinimumVersion 1.8.1 -Scope Global -PassThru
      }
    }
  }

  if(-not $accountsModule) {
    Write-Error "`nThis module requires $accountsName version 1.8.1 or greater. For installation instructions, please see: https://docs.microsoft.com/en-us/powershell/azure/install-az-ps" -ErrorAction Stop
  } elseif (($accountsModule.Version -lt [System.Version]'1.8.1') -and (-not $localAccounts)) {
    Write-Error "`nThis module requires $accountsName version 1.8.1 or greater. An earlier version of Az.Accounts is imported in the current PowerShell session. If you are running test, please try to remove '.PSSharedModules' in your home directory. Otherwise please open a new PowerShell session and import this module again.`nAdditionally, this error could indicate that multiple incompatible versions of Azure PowerShell modules are installed on your system. For troubleshooting information, please see: https://aka.ms/azps-version-error" -ErrorAction Stop
  }
  Write-Information "Loaded Module '$($accountsModule.Name)'"

  # Load the private module dll
  $null = Import-Module -Name (Join-Path $PSScriptRoot './bin/Az.DesktopVirtualization.private.dll')

  # Get the private module's instance
  $instance = [Microsoft.Azure.PowerShell.Cmdlets.DesktopVirtualization.Module]::Instance

  # Ask for the shared functionality table
  $VTable = Register-AzModule
  
  # Tweaks the pipeline on module load
  $instance.OnModuleLoad = $VTable.OnModuleLoad
  
  # Tweaks the pipeline per call
  $instance.OnNewRequest = $VTable.OnNewRequest
  
  # Gets shared parameter values
  $instance.GetParameterValue = $VTable.GetParameterValue
  
  # Allows shared module to listen to events from this module
  $instance.EventListener = $VTable.EventListener
  
  # Gets shared argument completers
  $instance.ArgumentCompleter = $VTable.ArgumentCompleter
  
  # The name of the currently selected Azure profile
  $instance.ProfileName = $VTable.ProfileName

 
  # Load the custom module
  $customModulePath = Join-Path $PSScriptRoot './custom/Az.DesktopVirtualization.custom.psm1'
  if(Test-Path $customModulePath) {
    $null = Import-Module -Name $customModulePath
  }
  
  # Export nothing to clear implicit exports
  Export-ModuleMember

  # Export proxy cmdlet scripts
  $exportsPath = Join-Path $PSScriptRoot './exports'
  $directories = Get-ChildItem -Directory -Path $exportsPath
  $profileDirectory = $null
  if($instance.ProfileName) {
    if(($directories | ForEach-Object { $_.Name }) -contains $instance.ProfileName) {
      $profileDirectory = $directories | Where-Object { $_.Name -eq $instance.ProfileName }
    } else {
      # Don't export anything if the profile doesn't exist for the module
      $exportsPath = $null
      Write-Warning "Selected Azure profile '$($instance.ProfileName)' does not exist for module '$($instance.Name)'. No cmdlets were loaded."
    }
  } elseif(($directories | Measure-Object).Count -gt 0) {
    # Load the last folder if no profile is selected
    $profileDirectory = $directories | Select-Object -Last 1
  }
  
  if($profileDirectory) {
    Write-Information "Loaded Azure profile '$($profileDirectory.Name)' for module '$($instance.Name)'"
    $exportsPath = $profileDirectory.FullName
  }
  
  if($exportsPath) {
    Get-ChildItem -Path $exportsPath -Recurse -Include '*.ps1' -File | ForEach-Object { . $_.FullName }
    $cmdletNames = Get-ScriptCmdlet -ScriptFolder $exportsPath
    Export-ModuleMember -Function $cmdletNames -Alias (Get-ScriptCmdlet -ScriptFolder $exportsPath -AsAlias)
  }

  # Finalize initialization of this module
  $instance.Init();
  Write-Information "Loaded Module '$($instance.Name)'"
# endregion

# SIG # Begin signature block
# MIIjlQYJKoZIhvcNAQcCoIIjhjCCI4ICAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCojpTmGavLcrN+
# 3UZ3ZZKzoUDMA+h0ZNvTuRPzxWxIMaCCDYUwggYDMIID66ADAgECAhMzAAABiK9S
# 1rmSbej5AAAAAAGIMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjAwMzA0MTgzOTQ4WhcNMjEwMzAzMTgzOTQ4WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQCSCNryE+Cewy2m4t/a74wZ7C9YTwv1PyC4BvM/kSWPNs8n0RTe+FvYfU+E9uf0
# t7nYlAzHjK+plif2BhD+NgdhIUQ8sVwWO39tjvQRHjP2//vSvIfmmkRoML1Ihnjs
# 9kQiZQzYRDYYRp9xSQYmRwQjk5hl8/U7RgOiQDitVHaU7BT1MI92lfZRuIIDDYBd
# vXtbclYJMVOwqZtv0O9zQCret6R+fRSGaDNfEEpcILL+D7RV3M4uaJE4Ta6KAOdv
# V+MVaJp1YXFTZPKtpjHO6d9pHQPZiG7NdC6QbnRGmsa48uNQrb6AfmLKDI1Lp31W
# MogTaX5tZf+CZT9PSuvjOCLNAgMBAAGjggGCMIIBfjAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUj9RJL9zNrPcL10RZdMQIXZN7MG8w
# VAYDVR0RBE0wS6RJMEcxLTArBgNVBAsTJE1pY3Jvc29mdCBJcmVsYW5kIE9wZXJh
# dGlvbnMgTGltaXRlZDEWMBQGA1UEBRMNMjMwMDEyKzQ1ODM4NjAfBgNVHSMEGDAW
# gBRIbmTlUAXTgqoXNzcitW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8v
# d3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIw
# MTEtMDctMDguY3JsMGEGCCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDov
# L3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDEx
# XzIwMTEtMDctMDguY3J0MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIB
# ACnXo8hjp7FeT+H6iQlV3CcGnkSbFvIpKYafgzYCFo3UHY1VHYJVb5jHEO8oG26Q
# qBELmak6MTI+ra3WKMTGhE1sEIlowTcp4IAs8a5wpCh6Vf4Z/bAtIppP3p3gXk2X
# 8UXTc+WxjQYsDkFiSzo/OBa5hkdW1g4EpO43l9mjToBdqEPtIXsZ7Hi1/6y4gK0P
# mMiwG8LMpSn0n/oSHGjrUNBgHJPxgs63Slf58QGBznuXiRaXmfTUDdrvhRocdxIM
# i8nXQwWACMiQzJSRzBP5S2wUq7nMAqjaTbeXhJqD2SFVHdUYlKruvtPSwbnqSRWT
# GI8s4FEXt+TL3w5JnwVZmZkUFoioQDMMjFyaKurdJ6pnzbr1h6QW0R97fWc8xEIz
# LIOiU2rjwWAtlQqFO8KNiykjYGyEf5LyAJKAO+rJd9fsYR+VBauIEQoYmjnUbTXM
# SY2Lf5KMluWlDOGVh8q6XjmBccpaT+8tCfxpaVYPi1ncnwTwaPQvVq8RjWDRB7Pa
# 8ruHgj2HJFi69+hcq7mWx5nTUtzzFa7RSZfE5a1a5AuBmGNRr7f8cNfa01+tiWjV
# Kk1a+gJUBSP0sIxecFbVSXTZ7bqeal45XSDIisZBkWb+83TbXdTGMDSUFKTAdtC+
# r35GfsN8QVy59Hb5ZYzAXczhgRmk7NyE6jD0Ym5TKiW5MIIHejCCBWKgAwIBAgIK
# YQ6Q0gAAAAAAAzANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNV
# BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
# c29mdCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlm
# aWNhdGUgQXV0aG9yaXR5IDIwMTEwHhcNMTEwNzA4MjA1OTA5WhcNMjYwNzA4MjEw
# OTA5WjB+MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
# BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSgwJgYD
# VQQDEx9NaWNyb3NvZnQgQ29kZSBTaWduaW5nIFBDQSAyMDExMIICIjANBgkqhkiG
# 9w0BAQEFAAOCAg8AMIICCgKCAgEAq/D6chAcLq3YbqqCEE00uvK2WCGfQhsqa+la
# UKq4BjgaBEm6f8MMHt03a8YS2AvwOMKZBrDIOdUBFDFC04kNeWSHfpRgJGyvnkmc
# 6Whe0t+bU7IKLMOv2akrrnoJr9eWWcpgGgXpZnboMlImEi/nqwhQz7NEt13YxC4D
# dato88tt8zpcoRb0RrrgOGSsbmQ1eKagYw8t00CT+OPeBw3VXHmlSSnnDb6gE3e+
# lD3v++MrWhAfTVYoonpy4BI6t0le2O3tQ5GD2Xuye4Yb2T6xjF3oiU+EGvKhL1nk
# kDstrjNYxbc+/jLTswM9sbKvkjh+0p2ALPVOVpEhNSXDOW5kf1O6nA+tGSOEy/S6
# A4aN91/w0FK/jJSHvMAhdCVfGCi2zCcoOCWYOUo2z3yxkq4cI6epZuxhH2rhKEmd
# X4jiJV3TIUs+UsS1Vz8kA/DRelsv1SPjcF0PUUZ3s/gA4bysAoJf28AVs70b1FVL
# 5zmhD+kjSbwYuER8ReTBw3J64HLnJN+/RpnF78IcV9uDjexNSTCnq47f7Fufr/zd
# sGbiwZeBe+3W7UvnSSmnEyimp31ngOaKYnhfsi+E11ecXL93KCjx7W3DKI8sj0A3
# T8HhhUSJxAlMxdSlQy90lfdu+HggWCwTXWCVmj5PM4TasIgX3p5O9JawvEagbJjS
# 4NaIjAsCAwEAAaOCAe0wggHpMBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBRI
# bmTlUAXTgqoXNzcitW2oynUClTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTAL
# BgNVHQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBRyLToCMZBD
# uRQFTuHqp8cx0SOJNDBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3JsLm1pY3Jv
# c29mdC5jb20vcGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFf
# MDNfMjIuY3JsMF4GCCsGAQUFBwEBBFIwUDBOBggrBgEFBQcwAoZCaHR0cDovL3d3
# dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFf
# MDNfMjIuY3J0MIGfBgNVHSAEgZcwgZQwgZEGCSsGAQQBgjcuAzCBgzA/BggrBgEF
# BQcCARYzaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9kb2NzL3ByaW1h
# cnljcHMuaHRtMEAGCCsGAQUFBwICMDQeMiAdAEwAZQBnAGEAbABfAHAAbwBsAGkA
# YwB5AF8AcwB0AGEAdABlAG0AZQBuAHQALiAdMA0GCSqGSIb3DQEBCwUAA4ICAQBn
# 8oalmOBUeRou09h0ZyKbC5YR4WOSmUKWfdJ5DJDBZV8uLD74w3LRbYP+vj/oCso7
# v0epo/Np22O/IjWll11lhJB9i0ZQVdgMknzSGksc8zxCi1LQsP1r4z4HLimb5j0b
# pdS1HXeUOeLpZMlEPXh6I/MTfaaQdION9MsmAkYqwooQu6SpBQyb7Wj6aC6VoCo/
# KmtYSWMfCWluWpiW5IP0wI/zRive/DvQvTXvbiWu5a8n7dDd8w6vmSiXmE0OPQvy
# CInWH8MyGOLwxS3OW560STkKxgrCxq2u5bLZ2xWIUUVYODJxJxp/sfQn+N4sOiBp
# mLJZiWhub6e3dMNABQamASooPoI/E01mC8CzTfXhj38cbxV9Rad25UAqZaPDXVJi
# hsMdYzaXht/a8/jyFqGaJ+HNpZfQ7l1jQeNbB5yHPgZ3BtEGsXUfFL5hYbXw3MYb
# BL7fQccOKO7eZS/sl/ahXJbYANahRr1Z85elCUtIEJmAH9AAKcWxm6U/RXceNcbS
# oqKfenoi+kiVH6v7RyOA9Z74v2u3S5fi63V4GuzqN5l5GEv/1rMjaHXmr/r8i+sL
# gOppO6/8MO0ETI7f33VtY5E90Z1WTk+/gFcioXgRMiF670EKsT/7qMykXcGhiJtX
# cVZOSEXAQsmbdlsKgEhr/Xmfwb1tbWrJUnMTDXpQzTGCFWYwghViAgEBMIGVMH4x
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01p
# Y3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTECEzMAAAGIr1LWuZJt6PkAAAAA
# AYgwDQYJYIZIAWUDBAIBBQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIO4a
# MZ/oqArwerdufEFUrdXg6gAkFjQIpgnvFSLKQbILMEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEAKqVzNELOTNIboR9AwzfsG8VldPx1eOXdkaJC
# v1r2Y+kY3p7T98rT7YAixnGBwXxiJYnUjj2/XO3ZvKxHzmFrYw+R2apkeghuCT4X
# bJkrj49Z13W4WUcUcb/niBQDvcsOLT/rsSoh4IoHqzwijahoANfWGVSQUdQqKMAU
# 5rhmto5Pi5YpafGJa/AVOHZp2cKIrN2jfzsQbb9ims9QIIQks/JNW5Mkf3mVEAeP
# 1xVMK8BifPF4IbzsH8AncRGnAbftX6QIlY5bzNqdRauoA6tPFjjxtNbgBYz6lKVd
# Jh8lJuSBtOCUd2tc07VMEY3IqnX87AQEtEG2HGz9jPdzVJndeaGCEvAwghLsBgor
# BgEEAYI3AwMBMYIS3DCCEtgGCSqGSIb3DQEHAqCCEskwghLFAgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFVBgsqhkiG9w0BCRABBKCCAUQEggFAMIIBPAIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCDXqOHSNU1W9EIuSFTW7zQ4G7VXMl3aFCmJ
# gFxqaf8HjwIGX63Eao+pGBMyMDIwMTExMzA4MTkzMS40MzlaMASAAgH0oIHUpIHR
# MIHOMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSkwJwYDVQQL
# EyBNaWNyb3NvZnQgT3BlcmF0aW9ucyBQdWVydG8gUmljbzEmMCQGA1UECxMdVGhh
# bGVzIFRTUyBFU046MzJCRC1FM0Q1LTNCMUQxJTAjBgNVBAMTHE1pY3Jvc29mdCBU
# aW1lLVN0YW1wIFNlcnZpY2Wggg5DMIIE9TCCA92gAwIBAgITMwAAAS6o0hkHk/Rr
# 6AAAAAABLjANBgkqhkiG9w0BAQsFADB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMK
# V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0Eg
# MjAxMDAeFw0xOTEyMTkwMTE1MDVaFw0yMTAzMTcwMTE1MDVaMIHOMQswCQYDVQQG
# EwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwG
# A1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSkwJwYDVQQLEyBNaWNyb3NvZnQg
# T3BlcmF0aW9ucyBQdWVydG8gUmljbzEmMCQGA1UECxMdVGhhbGVzIFRTUyBFU046
# MzJCRC1FM0Q1LTNCMUQxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNl
# cnZpY2UwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCu00yiUVNfeixS
# IzEPav1I6T4c+N5uUZx4BwFadmBp4u+PpbbGKDtZ2efK02yYQkPBmB8vAeHXr4G6
# qmD0DVN4vna6RLRHDS27DK+DBKt0jPrzt2ukDBXdZQ0cuyECzyTSyr3DOvTbe5Lt
# WMjOTZzzQ3ESbJ1G//GMf83FuXFo56I/LPX0PdwT3/ye+KjNapdgnc0Fe+DwYrDD
# /7aaQJ0rjcKPCO/rlq+r36Qcp0lg7yXjA63LGutl7Juw2wdTZ0rDxgBrd0c5QVfS
# lYnIs3uFN36OHIXaAdvkC7tez2hJo9O6qu9NAhuVyZKRGDo3nTRYgcgKRe2Eb0Kz
# mUNO0GIjAgMBAAGjggEbMIIBFzAdBgNVHQ4EFgQUhpqJJk4LiTe7qkk0NVIS8LdU
# TmwwHwYDVR0jBBgwFoAU1WM6XIoxkPNDe3xGG8UzaFqFbVUwVgYDVR0fBE8wTTBL
# oEmgR4ZFaHR0cDovL2NybC5taWNyb3NvZnQuY29tL3BraS9jcmwvcHJvZHVjdHMv
# TWljVGltU3RhUENBXzIwMTAtMDctMDEuY3JsMFoGCCsGAQUFBwEBBE4wTDBKBggr
# BgEFBQcwAoY+aHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWNU
# aW1TdGFQQ0FfMjAxMC0wNy0wMS5jcnQwDAYDVR0TAQH/BAIwADATBgNVHSUEDDAK
# BggrBgEFBQcDCDANBgkqhkiG9w0BAQsFAAOCAQEAjeAEaqcwrrrTamNp1iQw149+
# YmonZYLSf27KWLAF/GrSZdfSH1CiM07rklVN3Gl2ev2LzDGDHG7DWv+CdvLrNtyu
# j1mQJYyI9BvELcAzJUB46yp63K+BQQM+marwekqzd/1m29EEivzpcbFNJnw+8/O0
# diTOIMCibx+hCC7gBLY8FBkgdTSpt08K5udXwg9I8b1sc2lEtnrbzD64fAza6xyy
# QUd1B74PzV0tiM3UJ9tMY47FtAVAIk3/jQkacVL7v4/NDW9fvr53o4m36UCdiJV4
# iXSIvh2/ji91zq/DGgw0mDmkRQCH3KKt1T4uAZL0gvEBq74YwGWn5BO0ei+RSTCC
# BnEwggRZoAMCAQICCmEJgSoAAAAAAAIwDQYJKoZIhvcNAQELBQAwgYgxCzAJBgNV
# BAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4w
# HAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xMjAwBgNVBAMTKU1pY3Jvc29m
# dCBSb290IENlcnRpZmljYXRlIEF1dGhvcml0eSAyMDEwMB4XDTEwMDcwMTIxMzY1
# NVoXDTI1MDcwMTIxNDY1NVowfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hp
# bmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jw
# b3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAw
# ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCpHQ28dxGKOiDs/BOX9fp/
# aZRrdFQQ1aUKAIKF++18aEssX8XD5WHCdrc+Zitb8BVTJwQxH0EbGpUdzgkTjnxh
# MFmxMEQP8WCIhFRDDNdNuDgIs0Ldk6zWczBXJoKjRQ3Q6vVHgc2/JGAyWGBG8lhH
# hjKEHnRhZ5FfgVSxz5NMksHEpl3RYRNuKMYa+YaAu99h/EbBJx0kZxJyGiGKr0tk
# iVBisV39dx898Fd1rL2KQk1AUdEPnAY+Z3/1ZsADlkR+79BL/W7lmsqxqPJ6Kgox
# 8NpOBpG2iAg16HgcsOmZzTznL0S6p/TcZL2kAcEgCZN4zfy8wMlEXV4WnAEFTyJN
# AgMBAAGjggHmMIIB4jAQBgkrBgEEAYI3FQEEAwIBADAdBgNVHQ4EFgQU1WM6XIox
# kPNDe3xGG8UzaFqFbVUwGQYJKwYBBAGCNxQCBAweCgBTAHUAYgBDAEEwCwYDVR0P
# BAQDAgGGMA8GA1UdEwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAU1fZWy4/oolxiaNE9
# lJBb186aGMQwVgYDVR0fBE8wTTBLoEmgR4ZFaHR0cDovL2NybC5taWNyb3NvZnQu
# Y29tL3BraS9jcmwvcHJvZHVjdHMvTWljUm9vQ2VyQXV0XzIwMTAtMDYtMjMuY3Js
# MFoGCCsGAQUFBwEBBE4wTDBKBggrBgEFBQcwAoY+aHR0cDovL3d3dy5taWNyb3Nv
# ZnQuY29tL3BraS9jZXJ0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcnQwgaAG
# A1UdIAEB/wSBlTCBkjCBjwYJKwYBBAGCNy4DMIGBMD0GCCsGAQUFBwIBFjFodHRw
# Oi8vd3d3Lm1pY3Jvc29mdC5jb20vUEtJL2RvY3MvQ1BTL2RlZmF1bHQuaHRtMEAG
# CCsGAQUFBwICMDQeMiAdAEwAZQBnAGEAbABfAFAAbwBsAGkAYwB5AF8AUwB0AGEA
# dABlAG0AZQBuAHQALiAdMA0GCSqGSIb3DQEBCwUAA4ICAQAH5ohRDeLG4Jg/gXED
# PZ2joSFvs+umzPUxvs8F4qn++ldtGTCzwsVmyWrf9efweL3HqJ4l4/m87WtUVwgr
# UYJEEvu5U4zM9GASinbMQEBBm9xcF/9c+V4XNZgkVkt070IQyK+/f8Z/8jd9Wj8c
# 8pl5SpFSAK84Dxf1L3mBZdmptWvkx872ynoAb0swRCQiPM/tA6WWj1kpvLb9BOFw
# nzJKJ/1Vry/+tuWOM7tiX5rbV0Dp8c6ZZpCM/2pif93FSguRJuI57BlKcWOdeyFt
# w5yjojz6f32WapB4pm3S4Zz5Hfw42JT0xqUKloakvZ4argRCg7i1gJsiOCC1JeVk
# 7Pf0v35jWSUPei45V3aicaoGig+JFrphpxHLmtgOR5qAxdDNp9DvfYPw4TtxCd9d
# dJgiCGHasFAeb73x4QDf5zEHpJM692VHeOj4qEir995yfmFrb3epgcunCaw5u+zG
# y9iCtHLNHfS4hQEegPsbiSpUObJb2sgNVZl6h3M7COaYLeqN4DMuEin1wC9UJyH3
# yKxO2ii4sanblrKnQqLJzxlBTeCG+SqaoxFmMNO7dDJL32N79ZmKLxvHIa9Zta7c
# RDyXUHHXodLFVeNp3lfB0d4wwP3M5k37Db9dT+mdHhk4L7zPWAUu7w2gUDXa7wkn
# HNWzfjUeCLraNtvTX4/edIhJEqGCAtEwggI6AgEBMIH8oYHUpIHRMIHOMQswCQYD
# VQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEe
# MBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSkwJwYDVQQLEyBNaWNyb3Nv
# ZnQgT3BlcmF0aW9ucyBQdWVydG8gUmljbzEmMCQGA1UECxMdVGhhbGVzIFRTUyBF
# U046MzJCRC1FM0Q1LTNCMUQxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1w
# IFNlcnZpY2WiIwoBATAHBgUrDgMCGgMVAPtfwjegSC3lNcgxqPm+lpKS6EKboIGD
# MIGApH4wfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNV
# BAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQG
# A1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwDQYJKoZIhvcNAQEF
# BQACBQDjWELlMCIYDzIwMjAxMTEzMDMyNTI1WhgPMjAyMDExMTQwMzI1MjVaMHYw
# PAYKKwYBBAGEWQoEATEuMCwwCgIFAONYQuUCAQAwCQIBAAIBOgIB/zAHAgEAAgIR
# qTAKAgUA41mUZQIBADA2BgorBgEEAYRZCgQCMSgwJjAMBgorBgEEAYRZCgMCoAow
# CAIBAAIDB6EgoQowCAIBAAIDAYagMA0GCSqGSIb3DQEBBQUAA4GBABqc8TV6hSjs
# Vu9ROk1E4GB1YwXWb7ZoNaa5hAi0NwOlwGjxGSvjyrsY/58MMk+g3kLif2NvUpM3
# ktrNZUBJwO/0azXKH3q0LAzJX+w4oO1W+HYdHGypN3rwWDhcGE9C+JNwUgEl9SBW
# GtRQp48fuJbdaVmbsN67t1nXGSGy6c2JMYIDDTCCAwkCAQEwgZMwfDELMAkGA1UE
# BhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAc
# BgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0
# IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAAEuqNIZB5P0a+gAAAAAAS4wDQYJYIZI
# AWUDBAIBBQCgggFKMBoGCSqGSIb3DQEJAzENBgsqhkiG9w0BCRABBDAvBgkqhkiG
# 9w0BCQQxIgQgsGkQ5vXlLdJGXnW3kriLAVCs0TP2C91GTDSCONadzswwgfoGCyqG
# SIb3DQEJEAIvMYHqMIHnMIHkMIG9BCDa/s3O8YhWiqpVN0kTeK+x2m0RAh17JpR6
# DiFoTILJKTCBmDCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5n
# dG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9y
# YXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMz
# AAABLqjSGQeT9GvoAAAAAAEuMCIEIJLVH+0KrBNGBv/XQAgoV8F67Rrdzev/cCxH
# jSxOycSFMA0GCSqGSIb3DQEBCwUABIIBAIOUjGxs9M/Fp9xowPFVpX4wY5JxW5oO
# y06BJVVHiLTVz1xNlesdKcEaIUsrjPcbAmARvxhKuXwRKvlOFZPMnvOSMKjXW4Zy
# 4y/RidKl44pmA+S2RclQxAst4xMKiV28y380pvxX9GAcnnXVDtHy75SDZbPsM9MI
# dtHlw440MlMQHNTEHATRiOCeih2MD74ZhtKik0XTd31+eHRpRWBKiyJawfivpgUA
# we9hvs6xamkl+rwMYH3jIAkIyFUNHrq6VZPGZEcvqpE9TuKsobI5obZ60ExKR6J2
# DQOPFpL4OBWVAedDVFLHykZvb5LYQPDcyZvCgUPP6/R06BooP8k3Xx0=
# SIG # End signature block
