function Get-QaDecodedText {
    param([string]$Base64)
    return [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($Base64))
}

function Get-QaPhrase {
    param([ValidateSet(
            "related_to",
            "want_confirm_understanding",
            "understand_business",
            "confirm_points",
            "confirm_all",
            "confirm_understanding",
            "source_reference",
            "mapping_rule",
            "output_item",
            "data_source_rule",
            "confirmation_content",
            "case",
            "when_checked",
            "when_unchecked",
            "case_confirm",
            "screen",
            "of",
            "content",
            "request_content",
            "described_at",
            "sheet",
            "line"
        )]
        [string]$Name
    )

    $map = @{
        related_to = "TGnDqm4gcXVhbiDEkeG6v24="
        want_confirm_understanding = "Y2jDum5nIHTDtGkgbXXhu5FuIHjDoWMgbmjhuq1uIG5o4bqtbiB0aOG7qWMgbmjGsCBzYXU6"
        understand_business = "Y2jDum5nIHTDtGkgxJFhbmcgaGnhu4N1IG5naGnhu4dwIHbhu6UgbmjGsCBzYXU6"
        confirm_points = "Tmjhu50gQsOhYyB4w6FjIG5o4bqtbiB0aMOqbSBnacO6cCBjw6FjIMSRaeG7g20gc2F1Og=="
        confirm_all = "Tmjhu50gQsOhYyB4w6FjIG5o4bqtbiBnacO6cCBjaMO6bmcgdMO0aSBjw6FjIG7hu5lpIGR1bmcgdHLDqm4u"
        confirm_understanding = "Tmjhu50gQsOhYyB4w6FjIG5o4bqtbiBnacO6cCBjw6FjaCBoaeG7g3UgdHLDqm4gY8OzIMSRw7puZyBraMO0bmcg4bqhPw=="
        source_reference = "VuG7gSBuZ3Xhu5NuIHRoYW0gY2hp4bq/dQ=="
        mapping_rule = "VuG7gSBydWxlIG1hcHBpbmc="
        output_item = "VuG7gSBpdGVtIG91dHB1dA=="
        data_source_rule = "VuG7gSBuZ3Xhu5NuIGThu68gbGnhu4d1IHbDoCBydWxlIGhp4buDbiB0aOG7iw=="
        confirmation_content = "VuG7gSBu4buZaSBkdW5nIGPhuqduIHjDoWMgbmjhuq1u"
        case = "VHLGsOG7nW5nIGjhu6Nw"
        when_checked = "S2hpIG5nxrDhu51pIGTDuW5nIGNoZWNr"
        when_unchecked = "S2hpIG5nxrDhu51pIGTDuW5nIGtow7RuZyBjaGVjaw=="
        case_confirm = "VHLGsOG7nW5nIGjhu6NwIGPhuqduIHjDoWMgbmjhuq1u"
        screen = "bcOgbiBow6xuaA=="
        of = "Y+G7p2E="
        content = "buG7mWkgZHVuZw=="
        request_content = "buG7mWkgZHVuZyB5w6p1IGPhuqd1"
        described_at = "xJHGsOG7o2MgbcO0IHThuqMgdOG6oWk="
        sheet = "c2hlZXQ="
        line = "bGluZQ=="
    }

    return Get-QaDecodedText -Base64 $map[$Name]
}

function Convert-LegacyCategory {
    param([string]$Category)

    switch ($Category) {
        "impact_analysis" { return "impact_investigation" }
        "screen_scope" { return "scope_keep" }
        "search_condition" { return "search_item" }
        "workflow" { return "workflow_gap" }
        "status_transition" { return "multi_rule" }
        "csv_import" { return "import_csv" }
        "csv_export" { return "csv_output" }
        "mail_notification" { return "notification" }
        "data_mapping" { return "mapping" }
        default { return $Category }
    }
}

function Get-QAStyle {
    param([string]$Category)
    return "business_understanding_confirm"
}

function Get-FormatHint {
    param(
        [string]$Category,
        [string]$Topic,
        [string[]]$ConfirmationPoints,
        [string]$InputContext
    )

    $joined = (@($ConfirmationPoints) + @($InputContext)) -join " "
    if ($joined -match '(=|<>|!=|>=|<=)') { return "by_case" }
    if ($joined -match '\bcheck\b|\buncheck\b|checkbox|Khi |khi ') { return "state_transition" }
    if ($Category -in @("mapping", "csv_output") -and @($ConfirmationPoints).Count -ge 2) { return "grouped_topics" }
    if ($Category -in @("multi_rule", "workflow_gap")) { return "by_case" }
    if (@($ConfirmationPoints).Count -ge 3) { return "multi_understanding" }
    return "understanding_confirm"
}

function Parse-LegacyQASections {
    param([string]$QaText)

    $bullet = [regex]::Escape([string][char]0x25A0)
    $context = [regex]::Match($QaText, ("{0}.*?(?<content>[\s\S]*?){0}.*?{0}" -f $bullet))
    $understanding = [regex]::Match($QaText, ("{0}.*?(?<content>[\s\S]*?){0}" -f $bullet))
    $question = [regex]::Match($QaText, ("{0}.*?(?<content>[\s\S]*)$" -f $bullet))

    return [ordered]@{
        Context = Get-CleanLines -Text ($context.Groups["content"].Value)
        Understanding = Get-CleanLines -Text ($understanding.Groups["content"].Value)
        Questions = Get-CleanLines -Text ($question.Groups["content"].Value)
    }
}

function Get-CleanLines {
    param([string]$Text)

    $lines = New-Object System.Collections.Generic.List[string]
    foreach ($line in ($Text -split "`r?`n")) {
        $trimmed = $line.Trim()
        if (-not $trimmed) { continue }
        $trimmed = $trimmed -replace '^[\-\*\x{2022}\x{2460}-\x{2468}0-9\.]+\s*', ''
        if ($trimmed -match '^(Nh|Ne|Ca)') { continue }
        if ($trimmed -match '^Do ') {
            $trimmed = $trimmed.Substring(5).Trim()
        }
        if ($trimmed) {
            $lines.Add($trimmed)
        }
    }
    return $lines.ToArray()
}

function Split-Sentences {
    param([string[]]$Lines)

    $sentences = New-Object System.Collections.Generic.List[string]
    foreach ($line in @($Lines)) {
        foreach ($fragment in ($line -split '(?<=[\.\?\!])\s+')) {
            $trimmed = $fragment.Trim()
            if ($trimmed) {
                $sentences.Add($trimmed)
            }
        }
    }
    return $sentences.ToArray()
}

function Get-SourceReference {
    param(
        [pscustomobject]$Item,
        [string[]]$ContextLines
    )

    $joined = ((@($Item.input_context) + @($ContextLines)) -join " ")
    $sheetMatch = [regex]::Match($joined, '(?i)(sheet)\s+([A-Z]{1,4}\d{0,4})')
    $lineMatches = [regex]::Matches($joined, '(?i)\bline[s]?\s+([0-9]+(?:\s*[-]\s*[0-9]+)?)')
    $sheet = if ($sheetMatch.Success) { $sheetMatch.Groups[2].Value.Trim() } else { $null }

    $lines = New-Object System.Collections.Generic.List[string]
    foreach ($match in $lineMatches) {
        $value = ($match.Groups[1].Value -replace '\s+', '')
        if (-not $lines.Contains($value)) {
            $lines.Add($value)
        }
    }

    $reference = [ordered]@{}
    if ($sheet) { $reference["sheet"] = $sheet }
    if ($Item.screen) { $reference["screen"] = $Item.screen }
    if ($lines.Count -gt 0) { $reference["lines"] = $lines.ToArray() }
    if ($reference.Count -eq 0) { return $null }

    return [pscustomobject]$reference
}

function Get-FocusLabel {
    param(
        [pscustomobject]$Item,
        [string[]]$ContextLines
    )

    $input = [string]$Item.input_context
    $firstSentence = if ($input) { ($input -split '\.')[0].Trim() } else { "" }
    $quotedItem = [regex]::Match((@($ContextLines) -join " "), [string]([char]0x300C) + '[^' + [string]([char]0x300D) + ']+' + [string]([char]0x300D))
    $firstSentence = $firstSentence -replace '^\s*[:\-]\s*', ''
    $firstSentence = $firstSentence.Trim()

    if ($quotedItem.Success -and $firstSentence -notmatch [regex]::Escape([string][char]0x300C)) {
        if ($firstSentence) {
            return "$firstSentence $($quotedItem.Value)".Trim()
        }
        return "$(Get-QaPhrase -Name content) $($quotedItem.Value)"
    }
    if ($firstSentence) { return $firstSentence }
    return Get-QaPhrase -Name request_content
}

function Get-ReferenceText {
    param([pscustomobject]$SourceReference)

    if (-not $SourceReference) { return $null }

    $parts = New-Object System.Collections.Generic.List[string]
    if ($SourceReference.PSObject.Properties.Name -contains "lines" -and @($SourceReference.lines).Count -gt 0) {
        $parts.Add(("{0} {1}" -f (Get-QaPhrase -Name line), ((@($SourceReference.lines)) -join ", ")))
    }
    if ($SourceReference.PSObject.Properties.Name -contains "screen" -and $SourceReference.screen) {
        $parts.Add(("{0} {1}" -f (Get-QaPhrase -Name screen), $SourceReference.screen))
    }
    if ($SourceReference.PSObject.Properties.Name -contains "sheet" -and $SourceReference.sheet) {
        $parts.Add(("{0} {1}" -f (Get-QaPhrase -Name sheet), $SourceReference.sheet))
    }

    if ($parts.Count -eq 0) { return $null }
    return ($parts -join (" " + (Get-QaPhrase -Name of) + " "))
}

function Convert-ContextToEvidence {
    param([string[]]$ContextLines)
    return Split-Sentences -Lines $ContextLines
}

function Get-UnclearPoints {
    param(
        [string[]]$ContextLines,
        [string[]]$QuestionLines
    )

    $unclear = New-Object System.Collections.Generic.List[string]
    foreach ($line in @($ContextLines)) {
        if ($line -match 'ch|kh|thi') {
            $unclear.Add($line)
        }
    }
    foreach ($line in @($QuestionLines)) {
        if ($line -notmatch '\?$') {
            $unclear.Add($line)
        }
    }
    return $unclear.ToArray()
}

function Normalize-ConfirmationPoints {
    param([string[]]$QuestionLines)

    $points = New-Object System.Collections.Generic.List[string]
    foreach ($line in @($QuestionLines)) {
        $trimmed = $line.Trim()
        if (-not $trimmed) { continue }
        $trimmed = $trimmed.TrimStart(',', ':', '-', ' ')
        if ($trimmed -match '^(?i)(do|nho|neu|chung)') { continue }
        if ($trimmed -match '(?i)phase') { continue }
        if ($trimmed -notmatch '\?$') {
            $trimmed = $trimmed + "?"
        }
        $points.Add($trimmed)
    }
    return $points.ToArray()
}

function Join-Paragraph {
    param([string[]]$Lines)
    return ((@($Lines) | Where-Object { $_ }) -join " ")
}

function Get-CleanConfirmationText {
    param([string]$Text)

    $clean = $Text.Trim()
    $clean = $clean.TrimEnd('?', '.', ' ', ';', ':')
    return $clean
}

function Get-SectionLabels {
    param([string]$Category)

    switch ($Category) {
        "mapping" { return @((Get-QaPhrase -Name source_reference), (Get-QaPhrase -Name mapping_rule)) }
        "csv_output" { return @((Get-QaPhrase -Name output_item), (Get-QaPhrase -Name data_source_rule)) }
        default { return @((Get-QaPhrase -Name confirmation_content)) }
    }
}

function Group-ConfirmationPoints {
    param(
        [string[]]$ConfirmationPoints,
        [string]$Category
    )

    if ($Category -notin @("mapping", "csv_output")) {
        return @([pscustomobject]@{
            Title = $null
            Points = $ConfirmationPoints
        })
    }

    $labels = Get-SectionLabels -Category $Category
    $groups = New-Object System.Collections.Generic.List[object]
    $mid = [Math]::Ceiling(@($ConfirmationPoints).Count / 2.0)
    $groups.Add([pscustomobject]@{
        Title = $labels[0]
        Points = @($ConfirmationPoints)[0..([Math]::Max($mid - 1, 0))]
    })
    if (@($ConfirmationPoints).Count -gt $mid) {
        $groups.Add([pscustomobject]@{
            Title = $labels[1]
            Points = @($ConfirmationPoints)[$mid..(@($ConfirmationPoints).Count - 1)]
        })
    }
    return $groups.ToArray()
}

function Get-CaseTitles {
    param([string[]]$ConfirmationPoints)

    $titles = New-Object System.Collections.Generic.List[string]
    $leftQuote = [string][char]0x300C
    $rightQuote = [string][char]0x300D
    foreach ($point in @($ConfirmationPoints)) {
        $match = [regex]::Match($point, [regex]::Escape($leftQuote) + '[^' + [regex]::Escape($rightQuote) + ']+' + [regex]::Escape($rightQuote))
        if ($match.Success) {
            $titles.Add(("{0} {1}" -f (Get-QaPhrase -Name case), $match.Value))
            continue
        }
        if ($point -match '(=|<>|!=|>=|<=)') {
            $titles.Add(("{0} {1}" -f (Get-QaPhrase -Name case), ($point -replace '\?.*$', '')))
            continue
        }
        if ($point -match '(?i)check') {
            $titles.Add((Get-QaPhrase -Name when_checked))
            continue
        }
        if ($point -match '(?i)uncheck') {
            $titles.Add((Get-QaPhrase -Name when_unchecked))
            continue
        }
        $titles.Add((Get-QaPhrase -Name case_confirm))
    }
    return $titles.ToArray()
}

function Build-OpeningLine {
    param(
        [string]$FocusLabel,
        [pscustomobject]$SourceReference,
        [string]$FormatHint
    )

    $referenceText = Get-ReferenceText -SourceReference $SourceReference
    $scopeText = if ($referenceText) {
        "{0} {1} {2}" -f $FocusLabel, (Get-QaPhrase -Name described_at), $referenceText
    }
    else {
        $FocusLabel
    }

    switch ($FormatHint) {
        "grouped_topics" { return "{0} {1}, {2}" -f (Get-QaPhrase -Name related_to), $scopeText, (Get-QaPhrase -Name want_confirm_understanding) }
        default { return "{0} {1}, {2}" -f (Get-QaPhrase -Name related_to), $scopeText, (Get-QaPhrase -Name understand_business) }
    }
}

function Build-QAText {
    param([pscustomobject]$Record)

    $formatHint = Get-FormatHint -Category $Record.category -Topic $Record.topic -ConfirmationPoints $Record.confirmation_points -InputContext $Record.input_context
    $opening = Build-OpeningLine -FocusLabel $Record.focus_label -SourceReference $Record.source_reference -FormatHint $formatHint
    $understanding = @($Record.current_understanding)
    $unclearPoints = @($Record.unclear_points | Where-Object { $_ })
    $confirmation = @($Record.confirmation_points)

    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add($opening)
    $lines.Add("")

    switch ($formatHint) {
        "grouped_topics" {
            $groups = Group-ConfirmationPoints -ConfirmationPoints $confirmation -Category $Record.category
            $index = 1
            foreach ($group in $groups) {
                if ($group.Title) {
                    $lines.Add("$index. $($group.Title):")
                    $lines.Add("")
                    foreach ($u in $understanding) {
                        $lines.Add($u)
                    }
                }
                else {
                    foreach ($u in $understanding) {
                        $lines.Add("$index. $u")
                        $index++
                    }
                }
                if ($group.Title) {
                    $lines.Add("")
                    $lines.Add((Get-QaPhrase -Name confirm_points))
                    $questionIndex = 1
                    foreach ($point in $group.Points) {
                        $lines.Add("$questionIndex. $(Get-CleanConfirmationText -Text $point)?")
                        $questionIndex++
                    }
                    $lines.Add("")
                    $index++
                }
            }
        }
        "by_case" {
            $caseTitles = Get-CaseTitles -ConfirmationPoints $confirmation
            $commonIndex = 1
            foreach ($u in $understanding) {
                $lines.Add("$commonIndex. $u")
                $commonIndex++
            }
            foreach ($unclear in $unclearPoints) {
                $lines.Add("$commonIndex. $unclear")
                $commonIndex++
            }
            $caseIndex = $commonIndex
            for ($i = 0; $i -lt $confirmation.Count; $i++) {
                $lines.Add("")
                $lines.Add("$caseIndex. $($caseTitles[$i]):")
                $lines.Add("   - $(Get-CleanConfirmationText -Text $confirmation[$i])?")
                $caseIndex++
            }
        }
        "state_transition" {
            for ($i = 0; $i -lt $understanding.Count; $i++) {
                $lines.Add(("{0}. {1}" -f ($i + 1), $understanding[$i]))
            }
            $offset = $understanding.Count
            foreach ($unclear in $unclearPoints) {
                $offset++
                $lines.Add(("{0}. {1}" -f $offset, $unclear))
            }
            for ($i = 0; $i -lt $confirmation.Count; $i++) {
                $lines.Add("")
                $lines.Add(("{0}. {1}?" -f ($offset + $i + 1), (Get-CleanConfirmationText -Text $confirmation[$i])))
            }
        }
        default {
            for ($i = 0; $i -lt $understanding.Count; $i++) {
                $lines.Add(("{0}. {1}" -f ($i + 1), $understanding[$i]))
            }
            $nextIndex = $understanding.Count + 1
            foreach ($unclear in $unclearPoints) {
                $lines.Add(("{0}. {1}" -f $nextIndex, $unclear))
                $nextIndex++
            }
            if ($confirmation.Count -gt 0) {
                $lines.Add("")
                $lines.Add((Get-QaPhrase -Name confirm_points))
                $questionIndex = 1
                foreach ($point in $confirmation) {
                    $lines.Add("$questionIndex. $(Get-CleanConfirmationText -Text $point)?")
                    $questionIndex++
                }
            }
        }
    }

    $lines.Add("")
    if ($formatHint -eq "grouped_topics") {
        $lines.Add((Get-QaPhrase -Name confirm_all))
    }
    else {
        $lines.Add((Get-QaPhrase -Name confirm_understanding))
    }

    return ($lines -join "`n")
}

function Convert-LegacyRecord {
    param([pscustomobject]$Item)

    $parsed = Parse-LegacyQASections -QaText $Item.qa
    $sourceReference = Get-SourceReference -Item $Item -ContextLines $parsed.Context

    $record = [ordered]@{
        id = ($Item.id -replace '^QA', 'BI-QA')
        category = Convert-LegacyCategory -Category $Item.category
        module = $Item.module
        screen = $Item.screen
        topic = $Item.topic
        style = Get-QAStyle -Category (Convert-LegacyCategory -Category $Item.category)
        difficulty = $Item.difficulty
        source_type = if ($Item.PSObject.Properties.Name -contains "source_type") { $Item.source_type } else { $null }
        source_file = if ($Item.PSObject.Properties.Name -contains "source_file") { $Item.source_file } else { $null }
        source_reference = $sourceReference
        input_context = $Item.input_context
        evidence = Convert-ContextToEvidence -ContextLines $parsed.Context
        current_understanding = @($parsed.Understanding)
        unclear_points = Get-UnclearPoints -ContextLines $parsed.Context -QuestionLines $parsed.Questions
        confirmation_points = Normalize-ConfirmationPoints -QuestionLines $parsed.Questions
        focus_label = Get-FocusLabel -Item $Item -ContextLines $parsed.Context
        needs_review = if ($Item.PSObject.Properties.Name -contains "needs_review") { [bool]$Item.needs_review } else { $false }
        review_notes = if ($Item.PSObject.Properties.Name -contains "review_notes") { @($Item.review_notes) } else { @() }
        qa = $null
    }

    $record.qa = Build-QAText -Record ([pscustomobject]$record)
    return [pscustomobject]$record
}

function Normalize-ExistingRecord {
    param([pscustomobject]$Item)

    $record = [ordered]@{
        id = $Item.id
        category = $Item.category
        module = $Item.module
        screen = $Item.screen
        topic = $Item.topic
        style = if ($Item.PSObject.Properties.Name -contains "style" -and $Item.style) { $Item.style } else { "business_understanding_confirm" }
        difficulty = $Item.difficulty
        source_type = if ($Item.PSObject.Properties.Name -contains "source_type") { $Item.source_type } else { $null }
        source_file = if ($Item.PSObject.Properties.Name -contains "source_file") { $Item.source_file } else { $null }
        source_reference = if ($Item.PSObject.Properties.Name -contains "source_reference") { $Item.source_reference } else { $null }
        input_context = $Item.input_context
        evidence = if ($Item.PSObject.Properties.Name -contains "evidence") { @($Item.evidence) } else { @() }
        current_understanding = if ($Item.PSObject.Properties.Name -contains "current_understanding") { @($Item.current_understanding) } else { @() }
        unclear_points = if ($Item.PSObject.Properties.Name -contains "unclear_points") { @($Item.unclear_points) } else { @() }
        confirmation_points = Normalize-ConfirmationPoints -QuestionLines (@($Item.confirmation_points))
        focus_label = if ($Item.PSObject.Properties.Name -contains "focus_label" -and $Item.focus_label) {
            $Item.focus_label
        }
        else {
            Get-FocusLabel -Item $Item -ContextLines @($Item.evidence)
        }
        needs_review = if ($Item.PSObject.Properties.Name -contains "needs_review") { [bool]$Item.needs_review } else { $false }
        review_notes = if ($Item.PSObject.Properties.Name -contains "review_notes") { @($Item.review_notes) } else { @() }
        qa = $null
    }

    $record.qa = Build-QAText -Record ([pscustomobject]$record)
    return [pscustomobject]$record
}
