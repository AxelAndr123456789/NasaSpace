# Genera los iconos de lanzador de Android a partir de lib/images/aura.png.
# - mipmap-*/ic_launcher.png          : icono legacy (versiones antiguas)
# - mipmap-*/ic_launcher_foreground.png : capa frontal del icono adaptativo (Android 8+)
#   El fondo del icono adaptativo es el azul marino del propio logo.
Add-Type -AssemblyName System.Drawing

$raiz = 'C:\Users\USUARIO\Downloads\aplicacionasa'
$origen = Join-Path $raiz 'lib\images\aura.png'
$res = Join-Path $raiz 'android\app\src\main\res'

$img = [System.Drawing.Image]::FromFile($origen)
$bmp = New-Object System.Drawing.Bitmap $img
$w = $bmp.Width
$h = $bmp.Height
Write-Host "Logo: $w x $h px"

# 1) Bounding box del circulo del logo (todo lo que no sea blanco) + color dominante.
$paso = [Math]::Max(1, [int]($w / 300))
$minX = $w; $maxX = 0; $minY = $h; $maxY = 0
$frecuencias = @{}
for ($y = 0; $y -lt $h; $y += $paso) {
    for ($x = 0; $x -lt $w; $x += $paso) {
        $p = $bmp.GetPixel($x, $y)
        if ($p.R -gt 238 -and $p.G -gt 238 -and $p.B -gt 238) { continue }
        if ($x -lt $minX) { $minX = $x }
        if ($x -gt $maxX) { $maxX = $x }
        if ($y -lt $minY) { $minY = $y }
        if ($y -gt $maxY) { $maxY = $y }
        # Cuantiza a pasos de 16 para buscar el color mas frecuente (el azul marino).
        $clave = '{0},{1},{2}' -f ([int]($p.R / 16) * 16), ([int]($p.G / 16) * 16), ([int]($p.B / 16) * 16)
        $frecuencias[$clave] = [int]$frecuencias[$clave] + 1
    }
}
$cx = ($minX + $maxX) / 2.0
$cy = ($minY + $maxY) / 2.0
$dm = [Math]::Max($maxX - $minX, $maxY - $minY)
Write-Host "Circulo: centro ($([int]$cx), $([int]$cy)) diametro $([int]$dm) px"

$mejor = $null; $mejorN = -1
foreach ($k in $frecuencias.Keys) {
    if ($frecuencias[$k] -gt $mejorN) { $mejorN = $frecuencias[$k]; $mejor = $k }
}
$rgb = $mejor -split ','
$fondo = '{0:X2}{1:X2}{2:X2}' -f [int]$rgb[0], [int]$rgb[1], [int]$rgb[2]
Write-Host "Color de fondo dominante: #$fondo (muestreado $mejorN veces)"

# Rectangulo fuente = caja del circulo (asi el circulo llena el destino).
$srcX = [float]$minX; $srcY = [float]$minY; $srcW = [float]$dm; $srcH = [float]$dm

function NuevaLienzo([int]$tam) {
    $b = [System.Drawing.Bitmap]::new($tam, $tam, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($b)
    $g.SmoothingMode = 'AntiAlias'
    $g.InterpolationMode = 'HighQualityBicubic'
    $g.PixelOffsetMode = 'HighQuality'
    $g.CompositingQuality = 'HighQuality'
    $g.CompositingMode = 'SourceOver'
    return @{ bmp = $b; g = $g }
}

function DibujaRecortado([System.Drawing.Graphics]$g, [int]$tam, [float]$fraccion) {
    # Recorta un circulo de diametro = $fraccion * $tam centrado en el lienzo
    # y dibuja dentro el circulo del logo (sin las esquinas blancas del PNG).
    $d = [float]($tam * $fraccion)
    $x = [float](($tam - $tam * $fraccion) / 2.0)
    $camino = [System.Drawing.Drawing2D.GraphicsPath]::new()
    $camino.AddEllipse($x, $x, $d, $d)
    $g.SetClip($camino)
    $dest = [System.Drawing.RectangleF]::new($x, $x, $d, $d)
    $src = [System.Drawing.RectangleF]::new($srcX, $srcY, $srcW, $srcH)
    $g.DrawImage($img, $dest, $src, [System.Drawing.GraphicsUnit]::Pixel)
}

function Guardar([System.Drawing.Bitmap]$b, [string]$ruta) {
    $dir = Split-Path $ruta -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    $b.Save($ruta, [System.Drawing.Imaging.ImageFormat]::Png)
    $b.Dispose()
    $peso = (Get-Item $ruta).Length
    Write-Host "  $ruta ($peso bytes)"
}

# 2) Iconos legacy: el circuro del logo llena el cuadro, esquinas transparentes.
$legacy = @{ 'mdpi' = 48; 'hdpi' = 72; 'xhdpi' = 96; 'xxhdpi' = 144; 'xxxhdpi' = 192 }
Write-Host 'Iconos legacy (ic_launcher.png):'
foreach ($den in $legacy.Keys) {
    $tam = [int]$legacy[$den]
    $lienzo = NuevaLienzo $tam
    DibujaRecortado $lienzo.g $tam 0.99
    Guardar $lienzo.bmp (Join-Path $res "mipmap-$den\ic_launcher.png")
    $lienzo.g.Dispose()
}

# 3) Icono adaptativo (Android 8+): circulo al 64% del lienzo de 108dp,
#    con el fondo del color dominante del logo.
$adaptativo = @{ 'mdpi' = 108; 'hdpi' = 162; 'xhdpi' = 216; 'xxhdpi' = 324; 'xxxhdpi' = 432 }
Write-Host 'Capa frontal del icono adaptativo (ic_launcher_foreground.png):'
foreach ($den in $adaptativo.Keys) {
    $tam = [int]$adaptativo[$den]
    $lienzo = NuevaLienzo $tam
    DibujaRecortado $lienzo.g $tam 0.64
    Guardar $lienzo.bmp (Join-Path $res "mipmap-$den\ic_launcher_foreground.png")
    $lienzo.g.Dispose()
}

# 4) Icono adaptativo XML + color de fondo.
$anydpi = Join-Path $res 'mipmap-anydpi-v26'
if (-not (Test-Path $anydpi)) { New-Item -ItemType Directory -Path $anydpi -Force | Out-Null }
@'
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_background" />
    <foreground android:drawable="@mipmap/ic_launcher_foreground" />
</adaptive-icon>
'@ | Set-Content -Path (Join-Path $anydpi 'ic_launcher.xml') -Encoding UTF8

$colors = '<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">#' + $fondo + '</color>
</resources>'
$colors | Set-Content -Path (Join-Path $res 'values\colors.xml') -Encoding UTF8

$img.Dispose()
$bmp.Dispose()
Write-Host 'Listo.'
