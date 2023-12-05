$Maps = @{}
$MapOrder = @()

$min = [bigint] 0
$max = [bigint] 0

Get-Content "input.txt" | ForEach-Object {
    $Line = $_.Trim()
    if ( $Line -match "^seeds: (?<Seeds>.*)$" ) {
        $Seeds = $Matches.Seeds -Split ' '
        $SeedRanges = @{}
        for ( $seedindex = 0 ; $seedindex -lt $Seeds.Count ; $seedindex += 2 ) {
            $SeedRanges[$seedindex / 2] = @{
                RangeStart = [bigint] $Seeds[$seedindex]
                RangeEnd = [bigint] $Seeds[$seedindex] + [bigint] $Seeds[$seedindex + 1] - 1
                RangeLength = [bigint] $Seeds[$seedindex + 1]
            }
            if ( [bigint] $Seeds[$seedindex] + [bigint] $Seeds[$seedindex + 1] - 1 -gt $max ) {
                $max = [bigint] $Seeds[$seedindex] + [bigint] $Seeds[$seedindex + 1] - 1
            }
        }
    }
    elseif ( $Line -match "^(?<MapName>.*) map:") {
        $MapName = $Matches.MapName
        $Maps[$MapName] = @{}
        $MapOrder += $MapName
    }
    elseif ( $Line -match "^(?<DestStart>\d*) (?<SrcStart>\d*) (?<RangeLength>\d*)$" ) {
        $Maps[$MapName][[bigint] $Matches.SrcStart] = @{
            SrcStart = [bigint] $Matches.SrcStart
            SrcEnd = [bigint] $Matches.SrcStart + [bigint] $Matches.RangeLength - 1
            DestStart = [bigint] $Matches.DestStart
        }
        if ( [bigint] $Matches.SrcStart + [bigint] $Matches.RangeLength - 1 -gt $max ) {
            $max = [bigint] $Matches.SrcStart + [bigint] $Matches.RangeLength - 1
        }
        if ( [bigint] $Matches.DestStart + [bigint] $Matches.RangeLength - 1 -gt $max ) {
            $max = [bigint] $Matches.DestStart + [bigint] $Matches.RangeLength - 1
        }
    }
}

foreach ( $mapname in $MapOrder ) {
    $map = $Maps[$mapname].GetEnumerator() | Sort-Object Name
    if ( $map[0].Value.SrcStart -ne 0 ) {
        $Maps[$mapname][0] = @{
            SrcStart = [bigint] 0
            SrcEnd = [bigint] $map[0].Value.SrcStart - 1
            DestStart = [bigint] 0
        }
    }
    if ( $map[-1].Value.SrcEnd -lt $max ) {
        $Maps[$mapname][$map[-1].Value.SrcEnd + 1] = @{
            SrcStart = [bigint] $map[-1].Value.SrcEnd + 1
            SrcEnd = [bigint] $max
            DestStart = [bigint] $map[-1].Value.SrcEnd + 1
        }
    }

    $map = $Maps[$mapname].GetEnumerator() | Sort-Object Name
    for ( $lp = 0 ; $lp -lt $map.Count - 1 ; $lp++ ) {
        if ( $map[$lp + 1].SrcStart - $map[$lp].SrcEnd -gt 1 ) {
            $Maps[$mapname][$map[$lp].SrcEnd + 1] = @{
                SrcStart = $map[$lp].SrcEnd + 1
                SrcEnd = $map[$lp + 1].SrcStart - 1
                DstStart = $map[$lp].SrcEnd + 1
                DstEnd = $map[$lp + 1].SrcStart - 1
            }            
        }
    }
}

$locationstarts = @()

$SeedRanges.Values | ForEach-Object {
    $src = @{}
    $src[$_.RangeStart] = $_
    foreach ( $mapname in $MapOrder ) {
        $dest = @{}
        foreach ($srcItem in $src.Values) {
            $map = $Maps[$mapname].GetEnumerator() | Sort-Object Name
            $lp = 0
            while ( $srcItem.RangeLength -gt 0 -and $lp -lt $map.Count ) {
                if ( $srcItem.RangeStart -ge $map[$lp].Value.SrcStart -and $srcItem.RangeStart -le $map[$lp].Value.SrcEnd ) {
                    $fitstart = $srcItem.RangeStart
                    $fitend = if ( $map[$lp].Value.SrcEnd -lt $srcItem.RangeEnd ) { $map[$lp].Value.SrcEnd } else { $srcItem.RangeEnd }
                    $fitlength = $fitend - $fitstart + 1

                    # Map the part that fits
                    $new = @{
                        RangeStart = $map[$lp].Value.DestStart + ($fitstart - $map[$lp].Value.SrcStart)
                        RangeLength = $fitlength
                        RangeEnd = $map[$lp].Value.DestStart + ($fitstart - $map[$lp].Value.SrcStart) + $fitlength - 1
                    }
                    $dest[$new.RangeStart] = $new

                    # Update the remainder to be checked in the next
                    $srcItem.RangeStart = $fitend + 1
                    $srcItem.RangeLength = $srcItem.RangeLength - $fitlength
                    $srcItem.RangeEnd = $srcItem.RangeStart + $srcItem.RangeLength - 1
    
                }
                $lp++
            }
        }
        $src = $dest
    }

    $locationstarts += $dest.Keys
}

($locationstarts | Sort-Object)[0]
