$Mappings = @{
    "0" = "0"
    "1" = "1"
    "2" = "2"
    "3" = "3"
    "4" = "4"
    "5" = "5"
    "6" = "6"
    "7" = "7"
    "8" = "8"
    "9" = "9"
    "zero" = "0"
    "one" = "1"
    "two" = "2"
    "three" = "3"
    "four" = "4"
    "five" = "5"
    "six" = "6"
    "seven" = "7"
    "eight" = "8"
    "nine" = "9"
    "orez" = "0"
    "eno" = "1"
    "owt" = "2"
    "eerht" = "3"
    "ruof" = "4"
    "evif" = "5"
    "xis" = "6"
    "neves" = "7"
    "thgie" = "8"
    "enin" = "9"
}

$Sum = 0

Get-Content "sample1.txt" | ForEach-Object {
    $_ | Select-String -Pattern "(0|1|2|3|4|5|6|7|8|9)" -AllMatches | ForEach-Object {
        $Sum += [int] "$($Mappings[$_.Matches[0].Value])$($Mappings[$_.Matches[$_.Matches.Count - 1].Value])"
    }
}

"Sample1: $Sum"

$Sum = 0

Get-Content "calibration.txt" | ForEach-Object {
    $_ | Select-String -Pattern "(0|1|2|3|4|5|6|7|8|9)" -AllMatches | ForEach-Object {
        $Sum += [int] "$($Mappings[$_.Matches[0].Value])$($Mappings[$_.Matches[$_.Matches.Count - 1].Value])"
    }
}

"Answer1: $Sum"

$Pattern = "0|1|2|3|4|5|6|7|8|9|zero|one|two|three|four|five|six|seven|eight|nine"
$PatternRev = $Pattern[-1..-$Pattern.Length] -join ''

$Sum = 0

Get-Content "sample2.txt" | ForEach-Object {
    $line = $_
    $linerev = $line[-1..-$line.Length] -join ''
    $line -match "($Pattern)" | Out-Null
    $Sum += 10 * [int] $Mappings[$Matches[0]]
    $linerev -match "($PatternRev)" | Out-Null
    $Sum += [int] $Mappings[$Matches[0]]
}

"Sample2: $Sum"

$Sum = 0

Get-Content "calibration.txt" | ForEach-Object {
    $line = $_
    $linerev = $line[-1..-$line.Length] -join ''
    $line -match "($Pattern)" | Out-Null
    $Sum += 10 * [int] $Mappings[$Matches[0]]
    $linerev -match "($PatternRev)" | Out-Null
    $Sum += [int] $Mappings[$Matches[0]]
}

"Answer2: $Sum"