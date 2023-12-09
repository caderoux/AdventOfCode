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

    $stack = New-Object System.Collections.Stack
    while ( $Seq | % { if ( $_ -ne 0 ) { $true } } ) {
        $stack.Push($Seq[0])
        $Seq = (0..($Seq.Count-2) | % { $Seq[$_ + 1] - $Seq[$_] })
    }

    $prequel = 0
    while ( $stack.Count -gt 0 ) {
        $prequel = $stack.Pop() - $prequel
    }
    $Answer += $prequel
}

"Answer: $Answer"