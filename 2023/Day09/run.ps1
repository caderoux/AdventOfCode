cls
$Answer = [bigint] 0

$Sequences = @{}
$lp = 0
Get-Content "input.txt" | ForEach-Object {
    $Sequences[$lp] = ($_ -Split " ") | % { [int] $_ }
    $lp++
}

foreach ( $Sequence in $Sequences.Values ) {
    $Seq = $Sequence

    while ( $Seq | % { if ( $_ -ne 0 ) { $true } } ) {
        $Answer += $Seq[-1]
        $Seq = (0..($Seq.Count-2) | % { $Seq[$_ + 1] - $Seq[$_] })
    }
}


"Answer: $Answer"