[CmdletBinding(PositionalBinding = $false)]
param(
  [Parameter(Mandatory = $true)]
  [string[]]$Path,

  [int]$MaxSheets = 6,
  [int]$MaxRows = 10,
  [int]$MaxCols = 8
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.IO.Compression.FileSystem

function Get-EntryText {
  param(
    [System.IO.Compression.ZipArchive]$Zip,
    [string]$Name
  )

  $entry = $Zip.GetEntry($Name)
  if (-not $entry) {
    return $null
  }

  $reader = New-Object System.IO.StreamReader($entry.Open())
  try {
    return $reader.ReadToEnd()
  }
  finally {
    $reader.Close()
  }
}

function Get-ColumnNumber {
  param([string]$Letters)

  $sum = 0
  foreach ($ch in $Letters.ToCharArray()) {
    $sum = ($sum * 26) + ([int][char]$ch - [int][char]'A' + 1)
  }
  return $sum
}

function Get-SharedStrings {
  param([System.IO.Compression.ZipArchive]$Zip)

  $text = Get-EntryText -Zip $Zip -Name "xl/sharedStrings.xml"
  if (-not $text) {
    return @()
  }

  $xml = [xml]$text
  $ns = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
  $ns.AddNamespace("x", "http://schemas.openxmlformats.org/spreadsheetml/2006/main")

  $values = @()
  foreach ($si in $xml.SelectNodes("//x:si", $ns)) {
    $textNode = $si.SelectSingleNode("./x:t", $ns)
    if ($textNode) {
      $values += [string]$textNode.InnerText
      continue
    }

    $runs = $si.SelectNodes("./x:r/x:t", $ns)
    if ($runs) {
      $values += (($runs | ForEach-Object { $_.InnerText }) -join "")
    }
    else {
      $values += ""
    }
  }

  return $values
}

function Get-CellText {
  param(
    [System.Xml.XmlElement]$Cell,
    [string[]]$SharedStrings,
    [System.Xml.XmlNamespaceManager]$NamespaceManager
  )

  $type = $Cell.GetAttribute("t")
  $valueNode = $Cell.SelectSingleNode("./x:v", $NamespaceManager)
  if (-not $valueNode) {
    $inlineNode = $Cell.SelectSingleNode("./x:is/x:t", $NamespaceManager)
    if ($inlineNode) {
      return [string]$inlineNode.InnerText
    }
    return ""
  }

  $raw = [string]$valueNode.InnerText
  if ($type -eq "s") {
    $index = [int]$raw
    if ($index -lt $SharedStrings.Count) {
      return $SharedStrings[$index]
    }
  }

  return $raw
}

function Get-WorkbookRelationships {
  param([System.IO.Compression.ZipArchive]$Zip)

  $xml = [xml](Get-EntryText -Zip $Zip -Name "xl/_rels/workbook.xml.rels")
  $ns = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
  $ns.AddNamespace("pr", "http://schemas.openxmlformats.org/package/2006/relationships")

  $map = @{}
  foreach ($rel in $xml.SelectNodes("//pr:Relationship", $ns)) {
    $map[$rel.Id] = $rel.Target
  }

  return $map
}

function Show-XlsxSummary {
  param([string]$WorkbookPath)

  if ([System.IO.Path]::GetExtension($WorkbookPath).ToLowerInvariant() -ne ".xlsx") {
    throw "Only .xlsx is supported: $WorkbookPath"
  }

  $zip = [System.IO.Compression.ZipFile]::OpenRead($WorkbookPath)
  try {
    $workbookXml = [xml](Get-EntryText -Zip $zip -Name "xl/workbook.xml")
    $ns = New-Object System.Xml.XmlNamespaceManager($workbookXml.NameTable)
    $ns.AddNamespace("x", "http://schemas.openxmlformats.org/spreadsheetml/2006/main")
    $ns.AddNamespace("r", "http://schemas.openxmlformats.org/officeDocument/2006/relationships")

    $sharedStrings = Get-SharedStrings -Zip $zip
    $relationshipMap = Get-WorkbookRelationships -Zip $zip
    $sheetNodes = $workbookXml.SelectNodes("//x:sheets/x:sheet", $ns)

    Write-Output ("FILE`t" + [System.IO.Path]::GetFileName($WorkbookPath))
    Write-Output ("SHEETS`t" + (($sheetNodes | ForEach-Object { $_.GetAttribute("name") }) -join " | "))

    $count = [Math]::Min($MaxSheets, $sheetNodes.Count)
    for ($i = 0; $i -lt $count; $i++) {
      $sheet = $sheetNodes[$i]
      $relationshipId = $sheet.GetAttribute("id", "http://schemas.openxmlformats.org/officeDocument/2006/relationships")
      $target = $relationshipMap[$relationshipId]
      if (-not $target) {
        continue
      }

      if ($target -notlike "xl/*") {
        $target = "xl/" + $target.TrimStart("/")
      }

      $sheetXml = [xml](Get-EntryText -Zip $zip -Name $target)
      $sheetNs = New-Object System.Xml.XmlNamespaceManager($sheetXml.NameTable)
      $sheetNs.AddNamespace("x", "http://schemas.openxmlformats.org/spreadsheetml/2006/main")

      $rowsOut = @()
      foreach ($row in $sheetXml.SelectNodes("//x:sheetData/x:row[position()<=$MaxRows]", $sheetNs)) {
        $map = @{}
        foreach ($cell in $row.SelectNodes("./x:c", $sheetNs)) {
          $reference = $cell.GetAttribute("r")
          if ($reference -match "^([A-Z]+)(\d+)$") {
            $map[(Get-ColumnNumber -Letters $matches[1])] = Get-CellText -Cell $cell -SharedStrings $sharedStrings -NamespaceManager $sheetNs
          }
        }

        $values = @()
        foreach ($col in 1..$MaxCols) {
          $text = ""
          if ($map.ContainsKey($col)) {
            $text = $map[$col]
          }

          $values += (($text -replace "\r?\n", " ") -replace "/", " ")
        }

        $rowsOut += ($values -join "/")
      }

      Write-Output ("TOP`t" + $sheet.GetAttribute("name") + "`t" + ($rowsOut -join " || "))
    }

    Write-Output "---"
  }
  finally {
    $zip.Dispose()
  }
}

foreach ($item in $Path) {
  Show-XlsxSummary -WorkbookPath (Resolve-Path $item)
}
