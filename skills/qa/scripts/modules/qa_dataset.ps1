function Get-QaDatasetStatistics {
    param([object[]]$Records)

    $duplicateIds = @(
        $Records |
        Group-Object id |
        Where-Object { $_.Count -gt 1 } |
        ForEach-Object { $_.Name }
    )
    $duplicateQa = @(
        $Records |
        Group-Object { (("{0}" -f $_.qa) -replace '\s+', ' ').Trim().ToLowerInvariant() } |
        Where-Object { $_.Name -and $_.Count -gt 1 } |
        ForEach-Object { $_.Group[0].id }
    )

    return [pscustomobject]@{
        total = @($Records).Count
        needs_review = @($Records | Where-Object { $_.PSObject.Properties.Name -contains "needs_review" -and $_.needs_review }).Count
        duplicate_ids = @($duplicateIds)
        duplicate_qa = @($duplicateQa)
        by_category = @($Records | Group-Object category | Sort-Object Name | ForEach-Object {
                [pscustomobject]@{ name = $_.Name; count = $_.Count }
            })
        by_difficulty = @($Records | Group-Object difficulty | Sort-Object Name | ForEach-Object {
                [pscustomobject]@{ name = $_.Name; count = $_.Count }
            })
        by_module = @($Records | Group-Object module | Sort-Object Name | ForEach-Object {
                [pscustomobject]@{ name = $_.Name; count = $_.Count }
            })
        by_screen = @($Records | Group-Object screen | Sort-Object Name | ForEach-Object {
                [pscustomobject]@{ name = $_.Name; count = $_.Count }
            })
    }
}

function Get-QaExpectedChecks {
    param([pscustomobject]$Fixture)

    if ($Fixture.PSObject.Properties.Name -contains "expected" -and $Fixture.expected) {
        return [pscustomobject]@{
            must_contain = @($Fixture.expected.mustContain)
            must_not_contain = @($Fixture.expected.mustNotContain)
        }
    }

    return [pscustomobject]@{
        must_contain = @($Fixture.must_contain)
        must_not_contain = @($Fixture.must_not_contain)
    }
}

function New-QaFixtureRecord {
    param([pscustomobject]$Fixture)

    return [pscustomobject]@{
        id = $Fixture.id
        category = $Fixture.category
        module = $Fixture.module
        screen = $Fixture.screen
        topic = $Fixture.topic
        style = "business_understanding_confirm"
        difficulty = $Fixture.difficulty
        source_reference = $Fixture.source_reference
        input_context = $Fixture.input_context
        evidence = @($Fixture.evidence)
        current_understanding = @($Fixture.current_understanding)
        unclear_points = @($Fixture.unclear_points)
        confirmation_points = @($Fixture.confirmation_points)
        focus_label = $Fixture.focus_label
        qa = $null
    }
}

function Get-QaRecordSchemaIssues {
    param([pscustomobject]$Record)

    $issues = New-Object System.Collections.Generic.List[string]
    foreach ($field in @("id", "category", "module", "screen", "topic", "difficulty", "qa")) {
        if (-not ($Record.PSObject.Properties.Name -contains $field) -or [string]::IsNullOrWhiteSpace([string]$Record.$field)) {
            $issues.Add("Thiếu field bắt buộc: $field")
        }
    }

    if ($Record.PSObject.Properties.Name -contains "category" -and -not (Test-QaCategoryValue -Category $Record.category)) {
        $issues.Add("Category không hợp lệ: $($Record.category)")
    }

    if ($Record.PSObject.Properties.Name -contains "qa" -and [string]$Record.qa -match '^\s*$') {
        $issues.Add("QA rỗng.")
    }

    return @($issues)
}
