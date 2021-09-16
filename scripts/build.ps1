param(
    [string]$version = "0.0.0"
)

[string]$nuget = '.nuget\nuget.exe'

# TODO: Keep an eye on https://github.com/NuGet/Home/issues/4254 for updates on when this script can be removed
# in favour of dotnet pack <nuspec file>

If (-not (Test-Path $nuget)) {
	If (-not (Test-Path '.nuget')) {
		mkdir '.nuget'
	}

	$nugetSource = 'https://dist.nuget.org/win-x86-commandline/latest/nuget.exe'
	Invoke-WebRequest $nugetSource -OutFile $nuget
	If (-not $?) {
		$host.ui.WriteErrorLine('Unable to download NuGet executable, aborting!')
		exit $LASTEXITCODE
	}
}

(Get-Content ./LPSoft.CSharp.Codestyles.template.props) -replace "#.#.#","$version" | Set-Content ./LPSoft.CSharp.Codestyles.props
&$nuget pack ./LPSoft.CSharp.Codestyles.nuspec -Version $version -OutputDirectory ./dist