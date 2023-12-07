$Answer = [bigint] 0

Get-Content "sample.txt" | ForEach-Object {
    $_
}

"Answer: $Answer"