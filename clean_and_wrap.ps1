$headerTemplate = "<!DOCTYPE html>
<html lang='en'>
<head>
    <meta charset='UTF-8'>
    <title>MTL Strategy Guide</title>
    <link rel='stylesheet' href='style.css'>
</head>
<body>
    <nav class='site-nav'>
        <a href='index.html' class='home-btn'>Home / TOC</a>
        <select onchange='if(this.value) window.location.href=this.value'>
            <option value=''>-- Jump to Chapter --</option>
            <option value='00Abstract.html'>1. Abstract</option>
            <option value='01Introduction.html'>2. Introduction</option>
            <option value='02UsefulLinks.html'>3. Useful Links</option>
            <option value='03GeneralThings.html'>4. General Things</option>
            <option value='04MoveOrderandPickingPhase.html'>5. Move Order & Picking</option>
            <option value='05GeneralGameplay.html'>6. General Gameplay</option>
            <option value='06Rounding.html'>7. Rounding</option>
            <option value='07CardSettings.html'>8. Card Settings</option>
            <option value='08SpecificTricks.html'>9. Specific Tricks</option>
            <option value='09WRIntroduction.html'>10. WR Introduction</option>
            <option value='10WRKillRates.html'>11. WR Kill Rates</option>
            <option value='11Belarus.html'>12. Belarus</option>
        </select>
    </nav>
    <main>"

$footerTemplate = "    </main>
</body>
</html>"

$files = Get-ChildItem -Path . -Filter "*.html" | Where-Object { $_.Name -match '^\d{2}' }
Write-Host "Vrethikan $($files.Count) arxeia gia katharismo kai tyligma." -ForegroundColor Cyan

foreach ($file in $files) {
    $rawContent = Get-Content $file.FullName -Raw -Encoding utf8
    
    # 1. ΒΗΜΑ ΚΑΘΑΡΙΣΜΟΥ: Αν έχει μέσα <main>, κρατάμε μόνο ό,τι βρίσκεται ΜΕΣΑ στο τελευταίο <main>
    # (ή κόβουμε όλα τα επαναλαμβανόμενα wrappers)
    if ($rawContent -match '<main>') {
        # Παίρνουμε το περιεχόμενο μετά το τελευταίο <main>
        $parts = $rawContent -split '<main>'
        $cleanContent = $parts[-1]
        
        # Αν υπάρχει και κλείσιμο </main> στο τέλος, το αφαιρούμε
        $cleanContent = $cleanContent -replace '<\/main>\s*<\/body>\s*<\/html>\s*$', ''
    } else {
        $cleanContent = $rawContent
    }

    # 2. ΒΗΜΑ ΤΥΛΙΓΜΑΤΟΣ: Βάζουμε το header και το footer μία και μοναδική φορά
    $wrapped = $headerTemplate + "`n" + $cleanContent.Trim() + "`n" + $footerTemplate
    Set-Content -Path $file.FullName -Value $wrapped -Encoding utf8
    Write-Host "Katharistike kai tylixthike: $($file.Name)" -ForegroundColor Green
}

Write-Host "Ola ta arxeia diorthothikan epityxos!" -ForegroundColor Cyan