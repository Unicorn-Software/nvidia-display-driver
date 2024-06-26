Install-Module au -Force
Import-Module au

$releases64 = 'https://gfwsl.geforce.com/services_toolkit/services/com/nvidia/services/AjaxDriverService.php?func=DriverManualLookup&psid=98&osID=57&languageCode=1033&beta=0&isWHQL=1&dltype=-1&dch=1&upCRD=0&sort1=0&numberOfResults=1'
$releases7864 = 'https://gfwsl.geforce.com/services_toolkit/services/com/nvidia/services/AjaxDriverService.php?func=DriverManualLookup&psid=98&osID=19&languageCode=1033&beta=0&isWHQL=1&dltype=-1&dch=0&upCRD=0&sort1=0&numberOfResults=1'

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*url64\s*=\s*)('.*')"                          = "`$1'$($Latest.URL64)'"
      "(?i)(^\s*checksum64\s*=\s*)('.*')"                     = "`$1'$($Latest.Checksum64)'"
      "(?i)(^\s*checksumType64\s*=\s*)('.*')"                 = "`$1'$($Latest.ChecksumType64)'"
      "(?i)(^\s*[$]packageArgs\['url64'\]\s*=\s*)('.*')"      = "`$1'$($Latest.URL7864)'"
      "(?i)(^\s*[$]packageArgs\['checksum64'\]\s*=\s*)('.*')" = "`$1'$($Latest.Checksum7864)'"
    }
    ".\nvidia-display-driver.nuspec" = @{
      "(?i)(^\s*<releaseNotes>)(.*)" = "`${1}https://us.download.nvidia.com/Windows/$($Latest.Version)/$($Latest.Version)-win11-win10-win8-win7-release-notes.pdf</releaseNotes>"
    }
  }
}

function global:au_GetLatest {
  $rest64   = Invoke-RestMethod $releases64 -UseBasicParsing
  $rest7864 = Invoke-RestMethod $releases7864 -UseBasicParsing
  $version  = $rest64.IDS[0].downloadInfo.Version
  $url64    = "http"+$rest64.IDS[0].downloadInfo.DownloadURL.Substring(5)
  $url7864  = "http"+$rest7864.IDS[0].downloadInfo.DownloadURL.Substring(5)

  return @{
    Version = $version
    URL64   = $url64
    URL7864 = $url7864
  }
}

$au_Push      = $false 

Update-Package -ChecksumFor none -NoCheckChocoVersion -Force
