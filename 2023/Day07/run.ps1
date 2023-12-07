cls

$Answer = [bigint] 0

$Jokers = $false

$Cards = @{
    "A" = @{ Value = "A" }
    "K" = @{ Value = "B" }
    "Q" = @{ Value = "C" }
    "J" = @{ Value = if ( $Jokers ) { "Z" } else { "D" } }
    "T" = @{ Value = "E" }
    "9" = @{ Value = "F" }
    "8" = @{ Value = "G" }
    "7" = @{ Value = "H" }
    "6" = @{ Value = "I" }
    "5" = @{ Value = "J" }
    "4" = @{ Value = "K" }
    "3" = @{ Value = "L" }
    "2" = @{ Value = "M" }
}

$Hands = @{}

Get-Content "input.txt" | ForEach-Object {
    $_ -match "^(?<Hand>\S{5}) (?<Bid>\d+)$" | Out-Null
    $Bid = [bigint] $Matches.Bid
    $Hand = $Matches.Hand
    $SortKey = ($Hand.ToCharArray() | ForEach-Object { $Cards["$_"].Value }) -Join ""

    if ( $Jokers -and $Hand -eq "JJJJJ" ) {
        $ScoreHand = "AAAAA"
    }
    elseif ( $Jokers -and $Hand -match ".*J.*" ) {
        $ScoreHand = $Hand -replace "J", ($Hand.ToCharArray() | ForEach-Object { if ($_ -ne "J") { $_ } } | Group-Object -NoElement | Sort-Object -Property Count -Descending)[0].Name
    }
    else {
        $ScoreHand = $Hand
    }

    $Breakdown = $ScoreHand.ToCharArray() | Group-Object -NoElement | Sort-Object -Property Count -Descending
    $Strength = if ( $Breakdown[0].Count -eq 5 ) {
        1
    }
    elseif ( $Breakdown[0].Count -eq 4 ) {
        2
    }
    elseif ( $Breakdown[0].Count -eq 3 -and $Breakdown[1].Count -eq 2 ) {
        3
    }
    elseif ( $Breakdown[0].Count -eq 3 ) {
        4
    }
    elseif ( $Breakdown[0].Count -eq 2 -and $Breakdown[1].Count -eq 2 ) {
        5
    }
    elseif ( $Breakdown[0].Count -eq 2 ) {
        6
    }
    else {
        7
    }

    $Hands[$Hand] = @{
        Hand = $Hand
        ScoreHand = $ScoreHand
        SortKey = $SortKey
        Bid = [bigint] $Bid
        Breakdown = $Breakdown
        Strength = $Strength
    }
}

$Rank = 1
$Hands.Values | Sort-Object -Property @{expression = "Strength"; descending = $true}, @{expression = "SortKey"; descending = $true} | ForEach-Object {
    "Rank: $Rank, Hand: $($_.Hand), ScoreHand: $($_.ScoreHand), Strength: $($_.Strength), SortKey: $($_.SortKey), Bid: $($_.Bid)"
    $Answer += $_.Bid * $Rank
    $Rank++
}

"Answer: $Answer"