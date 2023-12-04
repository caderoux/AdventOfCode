$Sum = 0

$Cards = @{}

Get-Content "input.txt" | ForEach-Object {
    $_ -match "^Card *(?<Card>\d*):(?<CardWinners>.*)\|(?<Chosen>.*)$" | Out-Null
    # $_
    $Card = [int] "$($Matches.Card.Trim())"
    $Chosen = $Matches.Chosen.Trim().Split(' ').Trim() | ForEach-Object { if ($_ -ne '') { [int] "$_" } } | Sort-Object | Get-Unique
    $CardWinners = $Matches.CardWinners.Trim().Split(' ').Trim() | ForEach-Object { if ($_ -ne '') { [int] "$_" } } | Sort-Object | Get-Unique
    $Winners = $CardWinners | ForEach-Object {
        if ( $Chosen -contains $_ ) {
            $_
        }
    }
    # "Card $Card : $CardWinners, $Chosen -> $Winners => $(if ($Winners.Count -gt 0) { [bigint]::Pow(2, $Winners.Count - 1) } else { 0 })"
    if ( $Winners.Count -gt 0 ) {
        $Sum += [bigint]::Pow(2, $Winners.Count - 1)
    }
    $Cards[$Card] = @{
        # Card = $Card
        # Chosen = $Chosen
        # CardWinners = $CardWinners
        # Winners = $Winners
        WinnerCount = $Winners.Count
        CardCount = 1
    }
}

"Total: $Sum"

for ( $Card = 1 ; $Card -le $Cards.Count ; $Card++ ) {
    # "`$Card = $Card"
    # "Winnercount: $($Cards[$Card].WinnerCount)"
    for ( $Award = 1 ; $Award -le ($Cards[$Card].WinnerCount) ; $Award++ ) {
        # "`$Award = $Award"
        $Cards[$Card + $Award].CardCount += $Cards[$Card].CardCount
    }
}

# $Cards

$CardCount = 0

$Cards.Values | ForEach-Object { $CardCount += $_.CardCount }

"Cards: $CardCount"