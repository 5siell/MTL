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
        </select>
    </nav>
    <main>"

$footerTemplate = "    </main>
</body>
</html>"

# Παίρνουμε ΟΛΑ τα html και φιλτράρουμε με regex όσα ξεκινούν με 2 ψηφία (π.χ. 00, 01, 10...)
$files = Get-ChildItem -Path . -Filter "*.html" | Where-Object { $_.Name -match '^\d{2}' }
Write-Host "Vrethikan $($files.Count) arxeia me psifia." -ForegroundColor Cyan

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw -Encoding utf8
    
    # Έλεγχος για να μην ξανατυλίξουμε αρχεία που έχουν ήδη το menu μέσα
    if ($content -notmatch "site-nav") {
        Write-Host "Epexergasia kai tyligma tou: $($file.Name)" -ForegroundColor Yellow
        $wrapped = $headerTemplate + "`n" + $content + "`n" + $footerTemplate
        Set-Content -Path $file.FullName -Value $wrapped -Encoding utf8
    } else {
        Write-Host "To arxeio $($file.Name) einai idi etoimo (skipped)." -ForegroundColor DarkGray
    }
}

Write-Host "Oles oi allages oloklirothikan!" -ForegroundColor Green