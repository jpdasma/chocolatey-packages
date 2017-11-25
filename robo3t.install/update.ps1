﻿Import-Module AU

. $PSScriptRoot\..\_scripts\all.ps1

$download = 'https://robomongo.org/download'

function global:au_SearchReplace {
	@{
		".\tools\chocolateyInstall.ps1" = @{
			"(?i)(^\s*[$]packageName\s*=\s*)('.*')"    = "`$1'$($Latest.PackageName)'"
			"(?i)(^\s*[$]fileType\s*=\s*)('.*')"       = "`$1'$($Latest.FileType)'"
			"(?i)(^\s*[$]url64\s*=\s*)('.*')"          = "`$1'$($Latest.URL64)'"
			"(?i)(^\s*[$]checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
			"(?i)(^\s*[$]checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
		}
	}
}

function global:au_AfterUpdate {
	Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
	$downloadPage = Invoke-WebRequest -Uri $download

	$re = 'robo3t-.+-windows-x86_64-.+\.exe$'
	$url64 = $downloadPage.Links | Where-Object href -Match $re | Select-Object -First 1 -Expand href

	$version = $url64 -Split '-' | Select-Object -First 1 -Skip 1

	@{
		Version = $version
		URL64 = $url64
	}
}

if ($MyInvocation.InvocationName -NE '.') {
	Update-Package -ChecksumFor 64
}
