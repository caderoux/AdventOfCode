# $racetime = 
# $chargetime = 
# $runtime = $racetime - $chargetime
# $distance = $chargetime * $runtime = $chargetime * ($racetime - $chargetime)

$Races = @{}

Get-Content "input.txt" | ForEach-Object {
    $_ -match "^(?<ArrayName>.*):\s*(?<ArrayData>.*)$" | Out-Null
    $Races[$Matches.ArrayName] = ($Matches.ArrayData -replace '\s+', ',').Split(',') | ForEach-Object { [int] $_ }
}

$margin = 1

for ( $lp = 0 ; $lp -lt $Races.Time.Count ; $lp++ ) {
    $wincount = 0
    $racetime = $Races.Time[$lp]
    $record = $Races.Distance[$lp]
    "Record: $record mm over $racetime ms"
    for ( $chargetime = 1 ; $chargetime -lt $racetime ; $chargetime++ ) {
        $distance = $chargetime * ($racetime - $chargetime)
        "Run: $distance mm over $racetime ms after $chargetime ms charging: $(if ( $distance -gt $record ) { "WIN" } else { "LOSE" } )"
        if ( $distance -gt $record ) { $wincount++ }
    }
    $margin *= $wincount
}

$margin