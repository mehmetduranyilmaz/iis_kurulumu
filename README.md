# 🚀 IIS Kurulum ve Yönetim Scripti

Windows Server ve Windows 10/11 için otomatik IIS kurulum ve yapılandırma aracı.

![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue?style=flat-square&logo=powershell)
![Windows](https://img.shields.io/badge/Windows-Server%20%7C%2010%20%7C%2011-0078D6?style=flat-square&logo=windows)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

---

## 📋 İçindekiler

- [Özellikler](#-özellikler)
- [Gereksinimler](#-gereksinimler)
- [Kurulum](#-kurulum)
- [Kullanım](#-kullanım)
- [Script Ne Yapar?](#-script-ne-yapar)
- [Çıktı Örneği](#-çıktı-örneği)
- [Sorun Giderme](#-sorun-giderme)
- [Sık Sorulan Sorular](#-sık-sorulan-sorular)
- [Lisans](#-lisans)

---

## ✨ Özellikler

✅ **Otomatik Platform Tespiti** - Windows Server ve Windows 10/11'i otomatik algılar  
✅ **Akıllı Kurulum** - Platforma göre doğru komutu kullanır  
✅ **Renkli Çıktı** - Kullanıcı dostu görsel geri bildirim  
✅ **Hata Yönetimi** - Detaylı hata mesajları ve güvenli sonlandırma  
✅ **Durum Kontrolü** - IIS servis durumunu anlık gösterir  
✅ **Test Modu** - Servis başlatma/durdurma testleri  
✅ **Interaktif** - Tarayıcıda otomatik test seçeneği  

---

## 🔧 Gereksinimler

| Gereksinim | Açıklama |
|-----------|----------|
| **İşletim Sistemi** | Windows Server 2016+ veya Windows 10/11 |
| **PowerShell** | 5.1 veya üzeri |
| **Yönetici Yetkisi** | Script yönetici olarak çalıştırılmalıdır |
| **İnternet** | IIS paketleri için (ilk kurulumda) |

---

## 📥 Kurulum

### Adım 1: Script'i İndirin
```powershell
# Git ile
git clone https://github.com/kullanici-adi/iis-kurulum-scripti.git
cd iis-kurulum-scripti
```

veya manuel olarak `iis_kurulumu.ps1` dosyasını indirin.

### Adım 2: PowerShell'i Yönetici Olarak Açın

**Yöntem 1:**
```
Win + X → Windows PowerShell (Admin)
```

**Yöntem 2:**
```
Win + S → "powershell" → Sağ tık → Run as Administrator
```

### Adım 3: Execution Policy Ayarlayın (İlk Kez)
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Sorulduğunda **Y** yazıp Enter'a basın.

---

## 🎯 Kullanım

### Basit Kullanım
```powershell
# Script'in bulunduğu dizine gidin
cd C:\Path\To\Script

# Script'i çalıştırın
.\iis_kurulumu.ps1
```

### Uzak Sunucuda Çalıştırma
```powershell
# Uzak sunucuya bağlanın
Enter-PSSession -ComputerName SUNUCU_ADI -Credential (Get-Credential)

# Script'i çalıştırın
.\iis_kurulumu.ps1
```

### Sessiz Mod (Kullanıcı Girişi Olmadan)

Script'in son satırlarındaki interaktif kısmı kaldırın veya şöyle düzenleyin:
```powershell
# Bu satırları yorum satırı yapın
# $openBrowser = Read-Host "Tarayicida test etmek ister misiniz? (E/H)"
# if ($openBrowser -eq "E" -or $openBrowser -eq "e") {
#     Write-Host "`n[OK] Tarayici aciliyor..." -ForegroundColor Green
#     Start-Process "http://localhost"
# }
```

---

## 🔍 Script Ne Yapar?

### Adım 1: Platform Tespiti
- İşletim sistemini otomatik algılar
- Windows Server veya Windows 10/11 ayırt eder

### Adım 2: IIS Kurulum Kontrolü
- IIS'in kurulu olup olmadığını kontrol eder
- Kurulu değilse otomatik kurar:
  - **Windows Server:** `Install-WindowsFeature`
  - **Windows 10/11:** `Enable-WindowsOptionalFeature`

### Adım 3: IIS Başlatma
- W3SVC servisini başlatır
- Çalışma durumunu doğrular

### Adım 4: Test İşlemleri
- Servisi durdurur (test)
- Servisi yeniden başlatır
- Tüm işlemlerin başarılı olduğunu doğrular

### Adım 5: Durum Raporu
- Servis detaylarını gösterir
- Son durumu raporlar
- Tarayıcıda test seçeneği sunar

---

## 📊 Çıktı Örneği
```
================================================
    IIS KURULUM VE YAPILANDIRMA SCRIPTI
================================================

[BILGI] Isletim Sistemi: Microsoft Windows 11 Pro
[BILGI] Script Yonetici Modunda Calisiyor...

------------------------------------------------
[ADIM 1/5] IIS Kurulumu Kontrol Ediliyor...
------------------------------------------------
[OK] IIS zaten kurulu!

------------------------------------------------
[ADIM 2/5] IIS Servisi Baslatiliyor...
------------------------------------------------
    -> IIS baslatiliyor...
[OK] IIS basariyla baslatildi!

------------------------------------------------
[ADIM 3/5] IIS Servisi Durduruluyor (Test)...
------------------------------------------------
    -> IIS durduruluyor...
[OK] IIS basariyla durduruldu!

------------------------------------------------
[ADIM 4/5] IIS Servisi Yeniden Baslatiliyor...
------------------------------------------------
    -> IIS yeniden baslatiliyor...
[OK] IIS basariyla yeniden baslatildi!

------------------------------------------------
[ADIM 5/5] IIS Durum Kontrolu
------------------------------------------------

[BILGI] IIS Servis Detaylari:
    • Servis Adi     : W3SVC
    • Gorunen Ad     : World Wide Web Publishing Service
    • Durum          : Running
    • Baslangic Tipi : Automatic

[OK] IIS basariyla calisiyor!

================================================
              SCRIPT TAMAMLANDI!
================================================

[BILGI] Test icin asagidaki komutu kullanabilirsiniz:
    -> Start-Process 'http://localhost'

[BILGI] IIS Manager'i acmak icin:
    -> inetmgr

Tarayicida test etmek ister misiniz? (E/H): E

[OK] Tarayici aciliyor...

[BILGI] Script sonlandi. Iyi calismalar!
```

---

## 🛠️ Sorun Giderme

### Script Çalışmıyor

**Hata:** `File cannot be loaded because running scripts is disabled`

**Çözüm:**
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

### Yönetici Yetkisi Hatası

**Hata:** `Access is denied`

**Çözüm:**
- PowerShell'i **Yönetici olarak** yeniden açın
- Script'i tekrar çalıştırın

---

### IIS Kurulumu Başarısız

**Windows 10/11'de:**

Manuel kurulum deneyin:
```powershell
DISM /Online /Enable-Feature /FeatureName:IIS-WebServerRole /All
```

**Windows Server'da:**

Manuel kurulum deneyin:
```powershell
Install-WindowsFeature -name Web-Server -IncludeManagementTools -Restart
```

---

### Localhost Açılmıyor

1. **Güvenlik Duvarı Kontrolü:**
```powershell
New-NetFirewallRule -DisplayName "IIS HTTP" -Direction Inbound -Protocol TCP -LocalPort 80 -Action Allow
```

2. **IIS Durumunu Kontrol Edin:**
```powershell
Get-Service W3SVC
iisreset
```

3. **Tarayıcı Cache'ini Temizleyin:**
- `Ctrl + Shift + Delete` → Cache temizle

---

## ❓ Sık Sorulan Sorular

### IIS zaten kuruluysa ne olur?
Script mevcut kurulumu tespit eder ve kurulum adımını atlar. Sadece servisleri kontrol eder.

### Script Windows 10 Home'da çalışır mı?
Hayır, IIS sadece Windows 10/11 **Pro, Enterprise, Education** sürümlerinde mevcuttur.

### Kurulum ne kadar sürer?
- IIS zaten kuruluysa: **~10 saniye**
- Yeni kurulumda: **2-5 dakika** (internet hızına bağlı)

### Script hangi IIS özelliklerini kurar?
- Web Server Role (temel)
- IIS Management Console (yönetim arayüzü)
- ASP.NET 4.5+ (uygulama desteği)
- Statik içerik sunumu
- Varsayılan belge desteği

### Kaldırma nasıl yapılır?

**Windows Server:**
```powershell
Uninstall-WindowsFeature Web-Server -Remove
```

**Windows 10/11:**
```powershell
Disable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole
```

---

## 📝 Ek Kaynaklar

- [IIS Resmi Dokümantasyonu](https://docs.microsoft.com/en-us/iis/)
- [PowerShell Dokümantasyonu](https://docs.microsoft.com/en-us/powershell/)
- [Windows Server IIS Kurulumu](https://docs.microsoft.com/en-us/iis/install/installing-iis-85/installing-iis-85-on-windows-server-2012-r2)

---

## 🤝 Katkıda Bulunma

Katkılarınızı bekliyoruz! Lütfen şu adımları izleyin:

1. Bu repo'yu fork edin
2. Feature branch oluşturun (`git checkout -b feature/YeniOzellik`)
3. Değişikliklerinizi commit edin (`git commit -m 'Yeni özellik eklendi'`)
4. Branch'inizi push edin (`git push origin feature/YeniOzellik`)
5. Pull Request oluşturun

---

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasına bakın.

---

## 👨‍💻 Yazar

**Sizin Adınız**
- GitHub: [@kullanici-adi](https://github.com/kullanici-adi)
- Email: email@example.com

---

## 🌟 Destek

Bu projeyi faydalı buldunuz mu? ⭐ vererek destek olabilirsiniz!

---

## 📌 Notlar

- Script her zaman **yedekleme** ile kullanılmalıdır
- Üretim ortamlarında önce test ortamında deneyin
- Güvenlik güncellemelerini takip edin
- IIS yapılandırmasını gereksinimlerinize göre özelleştirin

---

<div align="center">

**[⬆ Başa Dön](#-iis-kurulum-ve-yönetim-scripti)**

Made with ❤️ using PowerShell

</div>
