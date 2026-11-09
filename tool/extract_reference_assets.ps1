# Extract supplied reference artwork without recreating it or embedding full UI screenshots.
param(
  [string]$HomeImage = 'C:/Users/jack_/AppData/Local/Temp/codex-clipboard-393929c3-8d1c-4efa-a7f2-6bae5ba7b6a4.jpg',
  [string]$MenuImage = 'C:/Users/jack_/AppData/Local/Temp/codex-clipboard-2e829956-e9e5-4db9-8a0f-19768df81a57.jpg'
)
Add-Type -AssemblyName System.Drawing
$ErrorActionPreference = 'Stop'
$outputDirectory = Join-Path $PSScriptRoot '../assets/images/reference'
New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null
function Export-Region($source, $name, $x, $y, $width, $height) {
  $image = [System.Drawing.Bitmap]::FromFile($source)
  try {
    $region = [System.Drawing.Rectangle]::new($x, $y, $width, $height)
    $crop = $image.Clone($region, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    try { $crop.Save((Join-Path $outputDirectory $name), [System.Drawing.Imaging.ImageFormat]::Png) }
    finally { $crop.Dispose() }
  } finally { $image.Dispose() }
}
Export-Region $MenuImage 'llama-avatar.png' 30 190 97 97
Export-Region $HomeImage 'restaurant.png' 42 468 312 191
Export-Region $HomeImage 'taxi.png' 384 468 312 191
Export-Region $HomeImage 'events.png' 54 766 157 109
Export-Region $HomeImage 'liquor.png' 250 766 157 109
Export-Region $HomeImage 'market.png' 445 766 157 109
Export-Region $HomeImage 'candy-promo.png' 61 1046 289 174
Export-Region $HomeImage 'braza-promo.png' 373 1046 289 174
