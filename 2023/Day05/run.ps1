$Maps = @{}

Get-Content "input.txt" | ForEach-Object {
    $Line = $_.Trim()
    if ( $Line -match "^seeds: (?<Seeds>.*)$" ) {
        $Seeds = $Matches.Seeds -Split ' '
    }
    elseif ( $Line -match "^(?<MapName>.*) map:") {
        $MapName = $Matches.MapName
        $Maps[$MapName] = @{}
    }
    elseif ( $Line -match "^(?<DestStart>\d*) (?<SrcStart>\d*) (?<RangeLength>\d*)$" ) {
        $Maps[$MapName][$Matches.DestStart] = @{
            DestStart = [bigint] "$($Matches.DestStart)"
            SrcStart = [bigint] "$($Matches.SrcStart)"
            RangeLength = [bigint] "$($Matches.RangeLength)"
        }
    }
}

$MapOrder = @(
    "seed-to-soil",
    "soil-to-fertilizer",
    "fertilizer-to-water",
    "water-to-light",
    "light-to-temperature",
    "temperature-to-humidity",
    "humidity-to-location"
)

$LowestDest = $null

$Seeds | ForEach-Object {
    $seed = [bigint] "$_"

    $src = $seed

    foreach ( $mapname in $MapOrder ) {
        $dest = $null
        foreach ($map in $Maps[$mapname].Values) {
            # $map
            if ( ($src -ge $map.SrcStart) -and ($src -le ($map.SrcStart + $map.RangeLength - 1)) ) {
                $dest = $map.DestStart + $src - $map.SrcStart
            }
        }
        if ( $dest -eq $null ) {
            $dest = $src
        }
        # "$mapname : $src => $dest"
        $src = $dest
    }
    # "Seed: $seed => $dest"
    if ( $LowestDest -eq $null ) {
        $LowestDest = $dest
    }
    elseif ( $dest -lt $LowestDest ) {
        $LowestDest = $dest
    }
}

"Answer: $LowestDest"