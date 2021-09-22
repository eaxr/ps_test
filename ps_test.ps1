param (
    [Parameter(Mandatory=$true)]
    [String[]] $Fruits,
    [String] $Content
)

function Get-Test($Fruits, $text) {
    $result = @{}
    foreach ($name in $Fruits) {
        $regex = "(\s+$name|^$name)\s+:\s+(\d+);"
        if ($text -match $regex) {
            $result += @{$name=$matches[2]}
        }
    }
    return $result
}

$test = @{}
$proc = $false
$Fruits = [String[]]($Fruits -split ',')
foreach($line in Get-Content $Content) {
    if ($line -match '===START===') {
        $proc = $true
    } elseif ($line -match '===END===') {
        break
    }

    if ($proc -eq $true) {
        $test += Get-Test $Fruits $line
    }
}
$json = $test | ConvertTo-Json -Compress
Write-Host $json
