cls
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

$InstructionCount = $Instructions.Length
$ExNodes = @{}
foreach ( $Node in $Nodes.Values ) {
    $stepnum = 0
    foreach ( $step in $Instructions.ToCharArray() ) {
        # "$($Node.Name) $stepnum ($step) -> $($Nodes[$Node.Name]["$step"])"
        $ExNodes["$($Node.Name)$($stepnum.ToString("0000"))"] = @{
            Name = "$($Node.Name)$($stepnum.ToString("0000"))"
            Next = "$($Nodes[$Node.Name]["$step"])$((($stepnum + 1) % $InstructionCount).ToString("0000"))"
        }
        $stepnum++
    }
}

# $ExNodes

$lp = 0
$Answer = 0

$StartNodes = $ExNodes.Values | ForEach-Object { if ( $_.Name -match "^..A0000$" ) { $_.Name } }
$NodeInfo = @{}

foreach ( $StartNode in $StartNodes ) {
    # "StartNode $StartNode"
    $NodeInfo[$StartNode] = @{
        Name = $StartNode
        Visits = @{}
        History = @{}
        Candidates = @{}
    }
    $Step = 0
    $Node = $StartNode
    while ( !($NodeInfo[$StartNode].History.ContainsKey($Node)) ) {
        $NodeInfo[$StartNode].History[$Node] = $Step
        $NodeInfo[$StartNode].Visits[$Step] = $Node

        $Node = $ExNodes[$Node].Next

        if ( $NodeInfo[$StartNode].History.ContainsKey($Node) ) {
            # "Revisit: $Node at step $Step.  First visited at $($NodeInfo[$StartNode].History[$Node])"
            $NodeInfo[$StartNode].PeriodStartNode = $Node
            $NodeInfo[$StartNode].Period = $Step - $NodeInfo[$StartNode].History[$Node] + 1
            $NodeInfo[$StartNode].PeriodStartStep = $NodeInfo[$StartNode].History[$Node]
        }
        $Step++
    }

    # $NodeInfo[$StartNode].History.Keys | ForEach-Object { if ( $_ -match "^..Z....$" ) { @($_, $NodeInfo[$StartNode].History[$_]) } }
    (0..($NodeInfo[$StartNode].Visits.Count-1)) | ForEach-Object {
        # "$($NodeInfo[$StartNode].Visits[$_])$(
        #     if ( $_ -eq $NodeInfo[$StartNode].PeriodStartStep ) { "^" }
        #     elseif ( $_ -eq $NodeInfo[$StartNode].PeriodStartStep + $NodeInfo[$StartNode].Period - 1 ) { "-" }
        #     elseif ( $_ -gt $NodeInfo[$StartNode].PeriodStartStep -and $_ -lt $NodeInfo[$StartNode].PeriodStartStep + $NodeInfo[$StartNode].Period - 1 ) { "|" }
        #     else { " " }
        # )$(
        #     if ( $NodeInfo[$StartNode].Visits[$_] -match "^..Z....$" ) { "*" }
        #     else { " " }
        # )$(
        #     if ( $_ -eq 0 ) { " <<<<< " }
        # )"
        if ( $NodeInfo[$StartNode].Visits[$_] -match "^..Z....$" ) {
            $NodeInfo[$StartNode].Candidates[$NodeInfo[$StartNode].Visits[$_]] = @{
                # StartNode = $StartNode
                EndNode = $NodeInfo[$StartNode].Visits[$_]
                # StartStep = $NodeInfo[$StartNode].PeriodStartStep
                EndStep = $_ - $NodeInfo[$StartNode].PeriodStartStep
                Period = $NodeInfo[$StartNode].Period
                Formula = "(TotalSteps - $($NodeInfo[$StartNode].PeriodStartStep)) % $($NodeInfo[$StartNode].Period) = $($_ - $NodeInfo[$StartNode].PeriodStartStep)"
            }
        }
    }
}

$Answer = [bigint] 293
$NodeInfo.Keys | ForEach-Object { $Answer = $Answer * ($NodeInfo[$_].Period  / 293) }

"Answer: $Answer"
