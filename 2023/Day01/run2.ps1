$Mappings = @{
    "zero" = "z0ro"
    "one" = "o1e"
    "two" = "t2o"
    "three" = "t3ree"
    "four" = "f4ur"
    "five" = "f5ve"
    "six" = "s6x"
    "seven" = "s7ven"
    "eight" = "e8ght"
    "nine" = "n9ne"
}

$re1 = [regex] "($($Mappings.Keys -join '|'))"

$Sum = 0

Get-Content "sample2.txt" | ForEach-Object {
    $line = $_
    $Mappings.GetEnumerator() | ForEach-Object { $line = $line -replace $_.Name, $_.Value }
    $line = $line -replace "[^0-9]", ""
    $Sum += [int] "$($line[0])$($line[$line.length - 1])"
}

"Sample2: $Sum"