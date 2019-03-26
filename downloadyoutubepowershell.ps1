#Script for download playslist from youtube.

#Call for load name, for generate a input box to avoid hard code the url, in this way, always will be prompted for the url.
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null

#Adquire the playlist url and store as a variable.
$Playlisturl = [Microsoft.VisualBasic.Interaction]::InputBox("URL Playlist a descargar")

#Generate new folder and copy youtube-dl.exe
$newfolder = [Microsoft.VisualBasic.Interaction]::InputBox("Carpeta de descarga")
mkdir $newfolder
copy youtube-dl.exe $newfolder
cd $newfolder

$VideoUrls= (invoke-WebRequest -uri $Playlisturl).Links | ? {$_.HREF -like "/watch*"} | `
? innerText -notmatch ".[0-9]:[0-9]." | ? {$_.innerText.Length -gt 3} | Select innerText, `
@{Name="URL";Expression={'http://www.youtube.com' + $_.href}} | ? innerText -notlike "*Play all*"

ForEach ($video in $VideoUrls){
Write-Host "Downloading $($video.innerText)"
.\youtube-dl.exe $video.URL
}
end
