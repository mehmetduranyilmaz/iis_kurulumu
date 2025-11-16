# ========================================
# IIS Kurulum ve Yonetim Scripti
# Windows Server & Windows 10/11 Uyumlu
# ========================================

Write-Host "`n================================================" -ForegroundColor Cyan
Write-Host "    IIS KURULUM VE YAPILANDIRMA SCRIPTI" -ForegroundColor Cyan
Write-Host "================================================`n" -ForegroundColor Cyan

# Isletim Sistemi Kontrolu
$osInfo = Get-CimInstance Win32_OperatingSystem
$isServer = $osInfo.Caption -like "*Server*"

Write-Host "[BILGI] Isletim Sistemi: $($osInfo.Caption)" -ForegroundColor Yellow
Write-Host "[BILGI] Script Yonetici Modunda Calisiyor..." -ForegroundColor Yellow
Write-Host ""

# ========================================
# ADIM 1: IIS KURULUMU
# ========================================

Write-Host "------------------------------------------------" -ForegroundColor Gray
Write-Host "[ADIM 1/5] IIS Kurulumu Kontrol Ediliyor..." -ForegroundColor Green
Write-Host "------------------------------------------------" -ForegroundColor Gray

$iisInstalled = Get-Service W3SVC -ErrorAction SilentlyContinue

if ($iisInstalled) {
    Write-Host "[OK] IIS zaten kurulu!" -ForegroundColor Green
} else {
    Write-Host "[!] IIS kurulu degil, kurulum baslatiliyor..." -ForegroundColor Yellow
    
    try {
        if ($isServer) {
            # Windows Server icin
            Write-Host "    -> Windows Server tespit edildi, Install-WindowsFeature kullaniliyor..." -ForegroundColor Cyan
            Install-WindowsFeature -name Web-Server -IncludeManagementTools
        } else {
            # Windows 10/11 icin
            Write-Host "    -> Windows 10/11 tespit edildi, Enable-WindowsOptionalFeature kullaniliyor..." -ForegroundColor Cyan
            Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole -All -NoRestart
            Enable-WindowsOptionalFeature -Online -FeatureName IIS-ManagementConsole -All -NoRestart
            Enable-WindowsOptionalFeature -Online -FeatureName IIS-ASPNET45 -All -NoRestart
        }
        
        Write-Host "[OK] IIS kurulumu tamamlandi!" -ForegroundColor Green
    }
    catch {
        Write-Host "[HATA] IIS kurulumu basarisiz!" -ForegroundColor Red
        Write-Host "    Detay: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

Start-Sleep -Seconds 2

# ========================================
# ADIM 2: IIS SERVISINI BASLATMA
# ========================================

Write-Host "`n------------------------------------------------" -ForegroundColor Gray
Write-Host "[ADIM 2/5] IIS Servisi Baslatiliyor..." -ForegroundColor Green
Write-Host "------------------------------------------------" -ForegroundColor Gray

try {
    $serviceStatus = (Get-Service W3SVC).Status
    
    if ($serviceStatus -eq "Running") {
        Write-Host "[OK] IIS zaten calisiyor!" -ForegroundColor Green
    } else {
        Write-Host "    -> IIS baslatiliyor..." -ForegroundColor Cyan
        Start-Service W3SVC -ErrorAction Stop
        Start-Sleep -Seconds 1
        Write-Host "[OK] IIS basariyla baslatildi!" -ForegroundColor Green
    }
}
catch {
    Write-Host "[HATA] IIS baslatilamadi!" -ForegroundColor Red
    Write-Host "    Detay: $($_.Exception.Message)" -ForegroundColor Red
}

Start-Sleep -Seconds 2

# ========================================
# ADIM 3: IIS SERVISINI DURDURMA (TEST)
# ========================================

Write-Host "`n------------------------------------------------" -ForegroundColor Gray
Write-Host "[ADIM 3/5] IIS Servisi Durduruluyor (Test)..." -ForegroundColor Green
Write-Host "------------------------------------------------" -ForegroundColor Gray

try {
    Write-Host "    -> IIS durduruluyor..." -ForegroundColor Cyan
    Stop-Service W3SVC -ErrorAction Stop
    Start-Sleep -Seconds 1
    Write-Host "[OK] IIS basariyla durduruldu!" -ForegroundColor Green
}
catch {
    Write-Host "[HATA] IIS durdurulamadi!" -ForegroundColor Red
    Write-Host "    Detay: $($_.Exception.Message)" -ForegroundColor Red
}

Start-Sleep -Seconds 2

# ========================================
# ADIM 4: IIS SERVISINI YENIDEN BASLATMA
# ========================================

Write-Host "`n------------------------------------------------" -ForegroundColor Gray
Write-Host "[ADIM 4/5] IIS Servisi Yeniden Baslatiliyor..." -ForegroundColor Green
Write-Host "------------------------------------------------" -ForegroundColor Gray

try {
    Write-Host "    -> IIS yeniden baslatiliyor..." -ForegroundColor Cyan
    Restart-Service W3SVC -ErrorAction Stop
    Start-Sleep -Seconds 2
    Write-Host "[OK] IIS basariyla yeniden baslatildi!" -ForegroundColor Green
}
catch {
    Write-Host "[HATA] IIS yeniden baslatilamadi!" -ForegroundColor Red
    Write-Host "    Detay: $($_.Exception.Message)" -ForegroundColor Red
}

Start-Sleep -Seconds 2

# ========================================
# ADIM 5: DURUM KONTROLU VE OZET
# ========================================

Write-Host "`n------------------------------------------------" -ForegroundColor Gray
Write-Host "[ADIM 5/5] IIS Durum Kontrolu" -ForegroundColor Green
Write-Host "------------------------------------------------" -ForegroundColor Gray

try {
    $service = Get-Service W3SVC
    
    Write-Host "`n[BILGI] IIS Servis Detaylari:" -ForegroundColor Yellow
    Write-Host "    • Servis Adi     : $($service.Name)" -ForegroundColor White
    Write-Host "    • Gorunen Ad     : $($service.DisplayName)" -ForegroundColor White
    Write-Host "    • Durum          : $($service.Status)" -ForegroundColor $(if($service.Status -eq "Running"){"Green"}else{"Red"})
    Write-Host "    • Baslangic Tipi : $($service.StartType)" -ForegroundColor White
    
    if ($service.Status -eq "Running") {
        Write-Host "`n[OK] IIS basariyla calisiyor!" -ForegroundColor Green
    } else {
        Write-Host "`n[UYARI] IIS calismiyor!" -ForegroundColor Red
    }
}
catch {
    Write-Host "[HATA] Durum kontrolu basarisiz!" -ForegroundColor Red
    Write-Host "    Detay: $($_.Exception.Message)" -ForegroundColor Red
}

# ========================================
# SONUC VE BILGILENDIRME
# ========================================

Write-Host "`n================================================" -ForegroundColor Cyan
Write-Host "              SCRIPT TAMAMLANDI!" -ForegroundColor Cyan
Write-Host "================================================`n" -ForegroundColor Cyan

Write-Host "[BILGI] Test icin asagidaki komutu kullanabilirsiniz:" -ForegroundColor Yellow
Write-Host "    -> Start-Process 'http://localhost'" -ForegroundColor White
Write-Host "`n[BILGI] IIS Manager'i acmak icin:" -ForegroundColor Yellow
Write-Host "    -> inetmgr" -ForegroundColor White
Write-Host ""

# Kullaniciya test secenegi sun
$openBrowser = Read-Host "Tarayicida test etmek ister misiniz? (E/H)"
if ($openBrowser -eq "E" -or $openBrowser -eq "e") {
    Write-Host "`n[OK] Tarayici aciliyor..." -ForegroundColor Green
    Start-Process "http://localhost"
}

Write-Host "`n[BILGI] Script sonlandi. Iyi calismalar!" -ForegroundColor Cyan