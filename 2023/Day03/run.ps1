$row = [int] 1
$rows = @{}
$gearhubs = @{}
$gearparts = @{}

Get-Content "input.txt" | ForEach-Object {
    $rows[$row] = ".$_."
    $row++
    $colmax = $_.Length + 1
}

$rows[$row] = "".PadLeft($colmax + 1, '.')
$rows[0] = $rows[$row]

$rowmin = 0
$rowmax = $row
$colmin = 0

$partSum = 0

for ( $row = $rowmin ; $row -le $rowmax; $row++ ) {
    # $rows[$row]
    $part = 0
    for ( $col = $colmin ; $col -le $colmax; $col++ ) {
        $ch = $rows[$row][$col]
        # $ch
        if ( $ch -match "\d" ) {
            if ( $part -ne 0 ) {
                $part = 10 * $part + [int] "$ch"
            }
            else {
                $partstart = $col
                $part = 10 * $part + [int] "$ch"
            }
        }
        else {
            if ( $part -ne 0 ) {
                $partend = $col - 1
                # $part
                $check = (($rows[$row-1][($partstart-1)..($partend+1)] + $rows[$row][($partstart-1)..($partend+1)] + $rows[$row+1][($partstart-1)..($partend+1)]) -join "") -replace "[.0-9]", ""
                if ( $check -ne '' ) {
                    $partSum += $part
                }
                if ( $check -match "\*" ) {
                    $gearpart = @{
                        row = $row
                        partstart = $partstart
                        partend = $partend
                        part = $part
                    }                    
                    $gearparts[$row * 1000 + $partstart] = $gearpart
                }
                $part = 0
            }
        }
    }
    if ( $part -ne 0 ) {
        $partend = $col - 1
        # $part
        $check = (($rows[$row-1][($partstart-1)..($partend+1)] + $rows[$row][($partstart-1)..($partend+1)] + $rows[$row+1][($partstart-1)..($partend+1)]) -join "") -replace "[.0-9]", ""
        if ( $check -ne '' ) {
            $partSum += $part
        }
        if ( $check -match "\*" ) {
            $gearpart = @{
                row = $row
                partstart = $partstart
                partend = $partend
                part = $part
            }                    
            $gearparts[$row * 1000 + $partstart] = $gearpart
        }
        $part = 0
    }
}

for ( $row = $rowmin ; $row -le $rowmax; $row++ ) {
    for ( $col = $colmin ; $col -le $colmax; $col++ ) {
        $ch = $rows[$row][$col]
        if ( $ch -match "\*" ) {
            $gearhubs[$row * 1000 + $col] = @{
                row = $row
                col = $col
            }
        }
    }
}

"Sum: $partSum"

# $gearparts

# $gearhubs

$GearRatioSum = 0

foreach ( $gearhub in $gearhubs.Keys ) {
    # $gearhub
    $attachedparts = @{}
    foreach ( $rowoffset in (-1..1) ) {
        # "Checking row $(($gearhubs[$gearhub].row + $rowoffset))"
        foreach ( $coloffset in (-1..1) ) {
            # "Checking col $(($gearhubs[$gearhub].col + $coloffset))"
            # "$rowoffset, $coloffset"
            foreach ( $gearpart in $gearparts.Keys ) {
                # $gearpart
                # $gearparts[$gearpart]
                if ( $gearparts[$gearpart].row -eq ($gearhubs[$gearhub].row + $rowoffset) ) {
                    # '>> row'
                    if ( ($gearhubs[$gearhub].col + $coloffset) -in ($gearparts[$gearpart].partstart)..($gearparts[$gearpart].partend) ) {
                        # '>> *'
                        # $gearparts[$gearpart]
                        $attachedparts[$gearpart] = $gearparts[$gearpart]
                    }
                }
            }
        }
    }
    # $gearhubs[$gearhub]
    # "Attached: $($attachedparts.Count)"
    if ( $attachedparts.Count -eq 2 ) {
        $a = @()
        $a += $attachedparts.Values
        $GearRatioSum += $a[0].part * $a[1].part
    }
}

"GearRatioSum = $GearRatioSum"