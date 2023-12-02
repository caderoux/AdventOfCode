$GameMax = @{
    Red = 12
    Green = 13
    Blue = 14
}

$Sum = 0
$SumPower = 0

Get-Content "sample1.txt" | ForEach-Object {
    ($_ -replace " ", "") -match "^Game(?<Game>\d*):(?<Draws>.*)$" | Out-Null
    $GameID = $Matches.Game
    "Game: $GameID"
    $Game = @{
        Red = 0
        Green = 0
        Blue = 0
    }
    $Matches.Draws -split ';' | ForEach-Object {
        "Draw: $_"
        $_ -split ',' | ForEach-Object {
            "Component: $_"
            $_ -match '^(?<Count>\d*)(?<Color>.*)$' | Out-Null
            if ( $Game[$Matches.Color] -lt [int] $Matches.Count ) {
                $Game[$Matches.Color] = [int] $Matches.Count
                "$($Matches.Color) => $([int] $Matches.Count)"
            }
        }
    }

    if ( $Game.Red -le $GameMax.Red -and $Game.Blue -le $GameMax.Blue -and $Game.Green -le $GameMax.Green ) {
        $Sum += $GameID
    }
    $SumPower += $Game.Red * $Game.Blue * $Game.Green
}

"Answer1: $Sum"
"Answer2: $SumPower"