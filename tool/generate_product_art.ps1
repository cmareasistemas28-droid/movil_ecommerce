# Original Cibermax demo illustrations. No third-party assets.
Add-Type -AssemblyName System.Drawing
$ErrorActionPreference = 'Stop'
$outDir = Join-Path $PSScriptRoot '../assets/images/products'
New-Item -ItemType Directory -Force -Path $outDir | Out-Null
function Brush($color) { [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($color)) }
function Rect($color, $x, $y, $w, $h) { $b=Brush $color; $g.FillRectangle($b, $x, $y, $w, $h); $b.Dispose() }
function Oval($color, $x, $y, $w, $h) { $b=Brush $color; $g.FillEllipse($b, $x, $y, $w, $h); $b.Dispose() }
function Line($color, $width, $x1, $y1, $x2, $y2) { $p=[System.Drawing.Pen]::new([System.Drawing.ColorTranslator]::FromHtml($color),$width); $p.StartCap='Round'; $p.EndCap='Round'; $g.DrawLine($p,$x1,$y1,$x2,$y2); $p.Dispose() }
foreach ($kind in @('speakers','gpu','cable','keyboard','ssd','headphones')) {
  $bitmap=[System.Drawing.Bitmap]::new(600,450)
  $g=[System.Drawing.Graphics]::FromImage($bitmap)
  $g.SmoothingMode='AntiAlias'
  Oval '#E1E5E0' 90 373 420 22
  switch ($kind) {
    'speakers' {
      foreach ($x in @(110,325)) {
        Rect '#122C28' ($x+14) 86 140 274
        Rect '#30433F' $x 76 140 274
        Rect '#415750' ($x+8) 84 124 258
        Oval '#192D29' ($x+23) 108 94 94
        Oval '#60776C' ($x+31) 116 78 78
        Oval '#263C35' ($x+49) 134 42 42
        Oval '#152C25' ($x+17) 219 106 106
        Oval '#718479' ($x+24) 226 92 92
        Oval '#30483E' ($x+40) 242 60 60
        Oval '#10291E' ($x+52) 254 36 36
        Rect '#D6B880' ($x+56) 333 28 3
      }
    }
    'gpu' {
      Rect '#122321' 58 158 480 170
      Rect '#52625C' 50 145 480 166
      Rect '#273D35' 62 154 454 146
      Rect '#D2C18E' 94 312 300 15
      foreach ($x in @(94,310)) {
        Oval '#142822' $x 161 136 136
        Oval '#759483' ($x+7) 168 122 122
        Oval '#233F32' ($x+13) 174 110 110
        foreach ($a in @(0,45,90,135,180,225,270,315)) {
          $rad=$a*[Math]::PI/180
          $cx=$x+68; $cy=229
          Line '#567A65' 14 $cx $cy ($cx+[Math]::Cos($rad)*43) ($cy+[Math]::Sin($rad)*43)
        }
        Oval '#A9CBB2' ($x+49) 210 38 38
      }
      Rect '#B7C3BC' 33 131 15 198
      Rect '#94CBAA' 260 172 14 111
    }
    'cable' {
      $p=[System.Drawing.Pen]::new([System.Drawing.ColorTranslator]::FromHtml('#234B3F'),26)
      $g.DrawArc($p,130,95,310,250,0,310)
      $p.Dispose()
      $p=[System.Drawing.Pen]::new([System.Drawing.ColorTranslator]::FromHtml('#527C69'),5)
      $g.DrawArc($p,124,89,310,250,0,310)
      $p.Dispose()
      Line '#234B3F' 25 280 342 190 370
      Rect '#77988C' 110 342 110 48
      Rect '#C4CCC7' 81 351 35 30
      Rect '#233F36' 78 357 16 18
      Rect '#77988C' 387 95 48 104
      Rect '#C4CCC7' 396 68 30 34
      Rect '#233F36' 402 65 18 17
    }
    'keyboard' {
      Rect '#273C35' 46 142 510 192
      Rect '#81988B' 40 128 510 190
      Rect '#1B3029' 49 137 492 171
      for ($r=0;$r -lt 5;$r++) {
        for ($c=0;$c -lt 14;$c++) {
          $color=if($c -lt 2){'#9BBEA8'}else{'#D8E2D7'}
          Rect $color (61+$c*34) (149+$r*29) 28 23
          Rect '#738B7B' (70+$c*34) (157+$r*29) 5 3
        }
      }
      Rect '#97BAA4' 163 265 210 23
      Rect '#FF973F' 61 149 28 23
    }
    'ssd' {
      Rect '#172E25' 64 170 470 132
      Rect '#2E4B36' 57 161 470 132
      foreach($x in @(78,146,214,282)) { Rect '#14251E' $x 180 55 76 }
      Rect '#D4D8C9' 344 178 147 81
      Rect '#19633F' 354 187 126 13
      Rect '#829384' 354 211 85 5
      Rect '#829384' 354 224 105 5
      Rect '#829384' 354 237 64 5
      for($i=0;$i -lt 10;$i++){ Rect '#C7A65E' 509 (169+$i*11) 26 6 }
      Oval '#A9B6A8' 62 213 17 17
    }
    'headphones' {
      $p=[System.Drawing.Pen]::new([System.Drawing.ColorTranslator]::FromHtml('#284A3C'),46)
      $g.DrawArc($p,145,65,300,280,180,180); $p.Dispose()
      $p=[System.Drawing.Pen]::new([System.Drawing.ColorTranslator]::FromHtml('#8EAB99'),14)
      $g.DrawArc($p,145,65,300,280,192,156); $p.Dispose()
      Rect '#738F7D' 127 213 40 92
      Rect '#738F7D' 425 213 40 92
      Oval '#1D362B' 103 198 102 157
      Oval '#496A55' 111 199 77 151
      Oval '#1D362B' 393 198 102 157
      Oval '#496A55' 407 199 77 151
      Oval '#A5BCA8' 122 233 40 81
      Oval '#A5BCA8' 432 233 40 81
    }
  }
  $bitmap.Save((Join-Path $outDir "$kind.png"),[System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose(); $bitmap.Dispose()
}
