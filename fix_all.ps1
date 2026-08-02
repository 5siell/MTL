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
            <option value='03GeneralThings.html'>4. General Things regarding the MTL</option>
            <option value='04MoveOrderandPickingPhase.html'>5. Move Order & Picking Phase</option>
            <option value='05GeneralGameplay.html'>6. General Gameplay</option>
            <option value='06Rounding.html'>7. Rounding</option>
            <option value='07CardSettings.html'>8. Card Settings</option>
            <option value='08SpecificTricks.html'>9. Specific Tricks</option>
            <option value='09WRIntroduction.html'>10. WR Introduction</option>
            <option value='10WRKillRates.html'>11. WR Kill Rates</option>
            <option value='11Belarus.html'>12. Belarus</option>
            <option value='12GreatLakes.html'>13. Great Lakes</option>
            <option value='13BritishRaj.html'>14. British Raj</option>
            <option value='14RandomisedStratME.html'>15. Randomised Strat ME</option>
            <option value='15StratME.html'>16. Strat ME</option>
            <option value='16Phobia.html'>17. Phobia</option>
            <option value='17FinalFantasyVII.html'>18. Final Fantasy VII</option>
            <option value='18Tor-ture.html'>19. Tor-ture</option>
            <option value='19StrategicCommanders.html'>20. Strategic Commanders</option>
            <option value='20PangeaUltima.html'>21. Pangea Ultima</option>
            <option value='31FrenchBrawl.html'>French Brawl</option>
            <option value='32YorkshireBrawl.html'>Yorkshire Brawl</option>
            <option value='33.Guiroma.html'>Guiroma</option>
            <option value='34BfME.html'>BfME</option>
            <option value='41_7550KillRates.html'>7550 Kill Rates</option>
            <option value='42_TimidLands.html'>Timid Lands</option>
            <option value='43_FastEarth.html'>Fast Earth</option>
            <option value='51_Local Deployment.html'>Local Deployment</option>
            <option value='52_TurkeyLD.html'>Turkey LD</option>
            <option value='53_GreeceLD.html'>Greece LD</option>
            <option value='54_SuccessionWars.html'>Succession Wars</option>
            <option value='55ArmyCap.html'>Army Cap</option>
            <option value='56GeorgiaAC.html'>Georgia Army Cap</option>
            <option value='58Multi-Attack.html'>Multi Attack</option>
            <option value='59Bork.html'>Bork</option>
            <option value='60MALD.html'>MALD</option>
            <option value='61BIVMA.html'>Battle Islands IV MA</option>
            <option value='62IslandOfRuins.html'>Island of Ruins</option>
            <option value='63LampuriaSwap.html'>Lampuria Swap</option>
            <option value='64MacedoniaNoSplit.html'>Macedonia No Split</option>
            <option value='65Landria.html'>Landria</option>
            <option value='66Earthsea.html'>Earthsea</option>
            <option value='67Tarabonia's Choice.html'>Tarabonia's Choice</option>
            <option value='68_INSS.html'>INSS</option>
            <option value='69_ElitistAfrica.html'>Elitist Africa</option>
            <option value='70_BiomesOfAmerica.html'>Biomes of America</option>
            <option value='71_AseridithIslands.html'>Aseridith Islands</option>
            <option value='72__StratGreece.html'>Strategic Greece</option>
            <option value='73__BlackSea.html'>Black Sea</option>
            <option value='74__Malvia.html'>Malvia</option>
            <option value='75__VolcanoIsland.html'>Volcano Island</option>
            <option value='76__WorldofWarhammer.html'>World of Warhammer</option>
            <option value='77__Post-meltAntarctica.html'>Post-melt Antarctica</option>
            <option value='78__Basileia.html'>Basileia</option>
            <option value='79__BIV.html'>BIV</option>
            <option value='80__StratMME.html'>Strat MME</option>
            <option value='81__Laketown.html'>Laketown</option>
            <option value='82__SaudiArabia.html'>Saudi Arabia</option>
            <option value='83__TreasureMap.html'>Treasure Map</option>
            <option value='84__UnicornIsland.html'>Unicorn Island</option>
            <option value='85__Discovery.html'>Discovery</option>
            <option value='86__GMEIII.html'>GME III</option>
            <option value='87__Hannibal.html'>Hannibal at the Gates</option>
            <option value='88__Australia.html'>Australia</option>
            <option value='89__Numenor.html'>Numenor</option>
            <option value='90__SlowBurn.html'>Slow Burn</option>
            <option value='91How_Luck_Works.html'>How Luck Works</option>
            <option value='92CalculatingLuck.html'>Calculating Luck</option>
        </select>
    </nav>
    <main>"

$footerTemplate = "    </main>
</body>
</html>"

# Σαρώνει αρχεία είτε ξεκινούν με ψηφία είτε περιέχουν γράμματα/αριθμούς (ώστε να πιάνει όλη τη λίστα)
$files = Get-ChildItem -Path . -Filter "*.html" | Where-Object { $_.Name -match '^\d{2}' -or $_.Name -match '^\d{1,2}[_A-Za-z]' }
Write-Host "Vrethikan $($files.Count) arxeia gia pliri katharismo." -ForegroundColor Cyan

foreach ($file in $files) {
    # Αποφυγή επεξεργασίας του ίδιου του index.html
    if ($file.Name -eq "index.html") { continue }

    $content = Get-Content $file.FullName -Raw -Encoding utf8

    # Καθαρισμός ΟΛΩΝ των παλιών wrappers
    $content = $content -replace '(?i)<!DOCTYPE[^>]*>', ''
    $content = $content -replace '(?i)</?html[^>]*>', ''
    $content = $content -replace '(?i)<head>[\s\S]*?</head>', ''
    $content = $content -replace '(?i)</?body[^>]*>', ''
    $content = $content -replace '(?i)<nav class=["\x27]site-nav["\x27]>[\s\S]*?</nav>', ''
    $content = $content -replace '(?i)</?main[^>]*>', ''

    $cleanContent = $content.Trim()

    # Τυλίγουμε το περιεχόμενο με το νέο ενημερωμένο header και footer
    $wrapped = $headerTemplate + "`n" + $cleanContent + "`n" + $footerTemplate
    Set-Content -Path $file.FullName -Value $wrapped -Encoding utf8
    
    Write-Host "Katharistike kai tylixthike sosta: $($file.Name)" -ForegroundColor Green
}

Write-Host "Oles oi allages kai o katharismos oloklirothikan epityxos!" -ForegroundColor Cyan