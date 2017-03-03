[string[]]$List = "MySql","Oracle","PostGre","SQLite"
[string]$baseOutput = Join-Path $PSScriptRoot "output"

If(Test-Path $baseOutput) { Remove-Item $baseOutput -Recurse -Force }
New-Item -Path $baseOutput -ItemType Directory  | Out-Null

ForEach($i in $List) {
    Write-Host "Processing $i"
    $buildPath = Join-Path $PSScriptRoot "$i\bin\Release"
    $outputPath = Join-Path $baseOutput $i
    New-Item -Path $outputPath -ItemType Directory | Out-Null
    If(Test-Path $buildPath) {
        Get-ChildItem $buildPath -Filter "*.dll" -Recurse |
            Where-Object name -ne "test.dll" |
            ForEach-Object {
                $newName = $_.Fullname.Replace($buildPath, $outputPath)
                Write-Host ("  ...{0}" -f $newName.Replace($outputPath,""))
                If(-not ($newName | Split-Path | Test-Path)) { 
                    New-Item ($newName | Split-Path) -ItemType Directory | Out-Null
                }
                Copy-Item -Path $_.FullName -Destination $newName -Force                
            }
    }
    Else {
        Write-Host "  $buildPath does not exist!" -ForegroundColor Yellow
    }

}