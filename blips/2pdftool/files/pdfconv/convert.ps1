# Logging für Ausgabe erstellen
$ErrorActionPreference = "SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"
Start-Transcript -path ".\log.txt" -append

#Word öffnen
$word = New-Object -ComObject Word.Application
$inputFolder = ".\IN"
$word.Visible = $false

#Dateien finden
$path = Get-ChildItem -Path $inputFolder -Force -Recurse | % { $_.FullName }

#Alle Dateien einzeln einlesen und konvertieren
foreach ($file in $path) {
    $doc = $word.Documents.Open($file)

    $outpath = Resolve-Path -Path ".\OUT\" 
    $outfile = $outpath.Path + $doc.name -replace".docx",".pdf" -replace".doc",".pdf" -replace".dotx",".pdf" -replace".dotm",".pdf" -replace".docm",".pdf" -replace".dot",".pdf" -replace".odt",".pdf" -replace".odf",".pdf" 

    echo $outfile
    #Als PDF nach Adobe-Spec exportieren
    $doc.ExportAsFixedFormat($outfile, 17)
    $doc.close()
}

#Schließen aller Programme
$word.Quit()

Stop-Transcript