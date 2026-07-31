# Η λίστα με τα υπόλοιπα WR templates (πρόσθεσε ή άλλαξε ονόματα ελεύθερα)
$wrTemplates = @(
    "Great Lakes",
    "Europe",
    "Asia",
    "North America",
    "South America",
    "Africa",
    "Middle East",
    "Oceania",
    "Pangea Ultima"
    # Μπορείς να προσθέσεις όσα θες εδώ με κόμμα
)

# Ξεκινάμε την αρίθμηση από το 12 (αφού το Belarus είναι το 11)
$startIndex = 12

for ($i = 0; $i -lt $wrTemplates.Count; $i++) {
    $currentNumber = $startIndex + $i
    $templateName = $wrTemplates[$i]
    
    # Δημιουργία filename (αφαιρούμε τα κενά για το όνομα του αρχείου)
    $cleanName = $templateName -replace '\s+', ''
    $formattedNumber = $currentNumber.ToString("00") # Κάνει το 12 -> 12, αν θες τριψήφιο βάζεις "000"
    $fileName = "$formattedNumber$cleanName.html"
    
    # Δομή περιεχομένου για το νέο αρχείο
    $fileContent = @"
<section id='$cleanName.ToLower()'>
    <h1>$templateName</h1>
    <p>Strategy and details for $templateName...</p>
</section>
"@

    # Αν το αρχείο δεν υπάρχει, το δημιουργούμε
    if (-not (Test-Path $fileName)) {
        Set-Content -Path $fileName -Value $fileContent -Encoding utf8
        Write-Host "Dimioyrgithike: $fileName" -ForegroundColor Green
    } else {
        Write-Host "Yparxei idi: $fileName" -ForegroundColor Yellow
    }
}

Write-Host "Oloi oi fakeloi/arxeia dimioyrgithikan!" -ForegroundColor Cyan




