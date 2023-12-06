$Races = @{}

Get-Content "input.txt" | ForEach-Object {
    ($_ -replace '\s+', '') -match "^(?<ArrayName>.*):\s*(?<ArrayData>.*)$" | Out-Null
    $Races[$Matches.ArrayName] = ($Matches.ArrayData -replace '\s+', ',').Split(',') | ForEach-Object { [bigint] $_ }
}

$d = [double] $Races.Distance
$r = [double] $Races.Time

"Answer: $([bigint] [Math]::Floor(0.5 * ( $r + [Math]::Sqrt($r * $r - 4.0 * $d) )) - [bigint] [Math]::Ceiling(0.5 * ( $r - [Math]::Sqrt($r * $r - 4.0 * $d) )) + 1)"
