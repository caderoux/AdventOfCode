$Answer = [bigint] 0

$lp = 0
$Nodes = @{}
Get-Content "input.txt" | ForEach-Object {
    # $_
    if ( $lp -eq 0 ) {
        $Instructions = $_
    }
    elseif ( $_ -match "^(?<Node>\S{3}) = \((?<L>\S{3}), (?<R>\S{3})\)$" ) {
        $Nodes[$Matches.Node] = @{Name = $Matches.Node; L = $Matches.L; R = $Matches.R}
    }
    $lp++
}

$Nodes

$lp = 0
$Answer = 0
$Node = $Nodes["AAA"]
while ( $Node.Name -ne "ZZZ" ) {
    "$($Node.Name) > $($Instructions[$lp])"
    $Node = $Nodes[$Node["$($Instructions[$lp])"]]
    $lp++
    if ( $lp -ge $Instructions.Length ) {
        $lp = 0
    }
    $Answer++
}

"Answer: $Answer"