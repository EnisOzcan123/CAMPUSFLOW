# Web Programlama Dersi Donem Projesi Raporu

## Proje Adi

CampusFlow

## 1. Proje Konusu ve Amaci

CampusFlow, Ataturk Universitesi kampusu icin gelistirilmis bir kampus bilgi ve etkinlik takip sistemidir. Projenin amaci, ogrencilerin kampus icindeki mekanlara, etkinliklere, harita bilgilerine, hava durumu uyarilarina ve bilet islemlerine tek bir web uygulamasi uzerinden ulasabilmesini saglamaktir.

Kampus icinde ogrenciler genellikle sessiz calisma alani, WiFi kalitesi iyi mekan, yaklasan etkinlik, etkinlik konumu veya etkinligin hava durumundan etkilenip etkilenmeyecegi gibi bilgilere farkli kaynaklardan ulasmak zorunda kalir. CampusFlow bu bilgileri tek sistemde toplayarak bu problemi cozmeyi hedefler.

## 2. Hedef Kullanici

Projenin hedef kullanicilari:

- Ataturk Universitesi ogrencileri,
- kampus etkinliklerini takip etmek isteyen kullanicilar,
- kampuste calisma alani veya sosyal mekan arayan ogrenciler,
- etkinlik ve mekan bilgilerini yonetecek admin kullanicilaridir.

Sistemde iki farkli kullanici rolu bulunur:

- Normal kullanici
- Admin

Normal kullanici kampus bilgilerini gorur ve bilet alabilir. Admin ise mekan ve etkinlik ekleme, duzenleme, silme ve admin panelini kullanma yetkisine sahiptir.

## 3. Temel Ozellikler

CampusFlow uygulamasinda bulunan temel ozellikler sunlardir:

- Kullanici kayit sistemi
- Kullanici giris/cikis sistemi
- Admin ve normal kullanici rolleri
- Mekan listeleme
- Mekan ekleme, duzenleme ve silme
- Etkinlik listeleme
- Etkinlik ekleme, duzenleme ve silme
- Mekan ve etkinlik arama/filtreleme
- Kampus haritasi
- Mekan ve etkinlik pinleri
- Hava durumu paneli
- Yaklasan etkinlik bildirimleri
- Biletli etkinlik sistemi
- Odeme formu
- IBAN format kontrolu
- Admin paneli

## 4. Kullanilan Teknolojiler

Projede kullanilan baslica teknolojiler:

- Ruby on Rails 7.1.6
- Ruby
- PostgreSQL
- ERB template sistemi
- Bootstrap 5
- Bootstrap Icons
- Sass
- Bcrypt
- Leaflet
- OpenStreetMap
- Open-Meteo API
- OSRM rota servisi

Rails, projenin ana web catısını olusturur. PostgreSQL veritabani olarak kullanilir. Bootstrap ve Sass arayuz tasarimi icin kullanilmistir. Bcrypt sifrelerin guvenli sekilde saklanmasini saglar. Leaflet ve OpenStreetMap harita ozellikleri icin kullanilmistir. Open-Meteo, hava durumu verisini almak icin kullanilmistir.

## 5. Veritabani Yapisi

Projede temel olarak dort ana tablo bulunur.

### users

Kullanici bilgilerini saklar.

Alanlar:

- ad soyad,
- e-posta,
- sifre ozeti,
- kullanici rolu.

Kullanici rolu `user` veya `admin` olabilir.

### places

Kampus mekanlarini saklar.

Alanlar:

- mekan adi,
- kategori,
- aciklama,
- WiFi puani,
- sessizlik puani,
- konum etiketi,
- enlem,
- boylam.

### events

Kampus etkinliklerini saklar.

Alanlar:

- etkinlik adi,
- etkinlik turu,
- aciklama,
- baslangic zamani,
- konum,
- bagli mekan,
- bilet gerekli mi,
- bilet ucreti.

### tickets

Kullanicilarin aldigi biletleri saklar.

Alanlar:

- etkinlik,
- kullanici,
- bilet adedi,
- toplam tutar,
- durum,
- kart sahibinin adi,
- kartin son 4 hanesi,
- IBAN.

Guvenlik icin kart numarasinin tamami veritabanina kaydedilmez.

## 6. CRUD Islemleri

Projede temel veri ekleme, listeleme, guncelleme ve silme islemleri bulunur.

Mekanlar icin:

- mekan ekleme,
- mekan listeleme,
- mekan duzenleme,
- mekan silme.

Etkinlikler icin:

- etkinlik ekleme,
- etkinlik listeleme,
- etkinlik duzenleme,
- etkinlik silme.

Bu islemler admin kullanicilar tarafindan yapilir. Normal kullanicilar listeleme ve detay goruntuleme islemlerini yapabilir.

## 7. Arama ve Filtreleme

Projede arama ve filtreleme ozelligi vardir.

Mekanlar sayfasinda:

- mekan adi veya aciklamaya gore arama,
- kategoriye gore filtreleme

yapilabilir.

Etkinlikler sayfasinda:

- etkinlik adi, aciklamasi veya konumuna gore arama,
- etkinlik turune gore filtreleme

yapilabilir.

## 8. Ozgun Ozellikler

Projede klasik CRUD yapisinin disinda birden fazla ozgun ozellik vardir.

### 8.1 Kampus Haritasi

Mekanlar ve etkinlikler harita uzerinde pin olarak gosterilir. Kullanici secili mekanin kampuste nerede oldugunu gorebilir.

### 8.2 Hava Durumu Entegrasyonu

Open-Meteo API kullanilarak kampus icin hava durumu bilgisi alinir. Bu bilgi bildirimler ve etkinlik detaylarinda kullanilir.

### 8.3 Etkinlik Hava Riski

Etkinlik gunu hava kotu gorunuyorsa sistem kullaniciya uyari verir. Ozellikle acik alan etkinliklerinde iptal veya yer degisikligi riski belirtilir.

### 8.4 Bilet Sistemi

Biletli etkinliklerde kullanici bilet adedi secebilir, odeme bilgilerini girebilir ve bilet kaydi olusturabilir.

### 8.5 IBAN Dogrulama

Odeme ekraninda girilen IBAN'in Turkiye IBAN formatina uygun olup olmadigi kontrol edilir. IBAN `TR` ile baslamazsa veya toplam 26 karakter degilse bilet alinmaz.

### 8.6 Admin Paneli

Admin kullanicilar icin ozel bir yonetim paneli vardir. Bu panelde sistemdeki kullanici, mekan, etkinlik ve bilet bilgileri ozetlenir.

## 9. Kullanici Rolleri

### Normal Kullanici

Normal kullanici:

- mekanlari gorur,
- etkinlikleri gorur,
- haritayi kullanir,
- bildirimleri takip eder,
- bilet alir.

Normal kullanici:

- mekan ekleyemez,
- etkinlik ekleyemez,
- veri silemez,
- admin panelini goremez.

### Admin

Admin:

- mekan ekler,
- mekan duzenler,
- mekan siler,
- etkinlik ekler,
- etkinlik duzenler,
- etkinlik siler,
- admin panelini kullanir.

Bu rol ayrimi, projenin guvenlik ve yetkilendirme gereksinimini karsilar.

## 10. Responsive Arayuz

Projede Bootstrap ve ozel CSS kullanilarak responsive bir arayuz hazirlanmistir. Mekan kartlari, etkinlik kartlari, admin paneli, bilet alma ekrani ve bildirim/hava durumu sayfasi farkli ekran boyutlarina uyum saglayacak sekilde tasarlanmistir.

## 11. Yapay Zeka Kullanimi Aciklamasi

Projede yapay zekadan yardim alinmistir. Ancak proje mantigi, konu secimi, temel akislar, ekran kontrolleri ve son kararlar ekip tarafindan belirlenmistir.

Yaklasik katkı orani:

- Ekip tarafindan gelistirilen ve yonlendirilen kisim: %60
- Yapay zekadan destek alinan kisim: %40

Yapay zekadan yardim alinan konular:

- Rails dosya yapisinda hangi dosyanin nerede duzenlenecegini belirleme,
- Bootstrap ile arayuz tasarimi onerileri,
- admin paneli tasarimi icin kod iskeleti,
- bilet ve IBAN dogrulama akisi icin teknik oneriler,
- hava durumu entegrasyonu icin servis sinifi yapisi,
- dokumantasyon ve rapor metinlerinin duzenlenmesi.

Dogrudan kullanilan yapay zeka ciktilari:

- Bazi ERB view yapisi taslaklari,
- CSS tasarim bloklari,
- controller ve model duzenlemeleri icin ornek kod parcalari,
- teknik dokumantasyon taslaklari.

Ekip tarafindan yapilan kisimlar:

- Proje fikrinin belirlenmesi,
- CampusFlow konseptinin olusturulmasi,
- hangi ozelliklerin eklenecegine karar verilmesi,
- arayuzlerin test edilmesi,
- hatalarin ekran goruntuleriyle tespit edilmesi,
- Bootstrap, Rails ve veritabani akislarinin projeye uyarlanmasi,
- admin/normal kullanici ayriminin proje ihtiyacina gore sekillendirilmesi,
- bilet ve hava durumu ozelliklerinin uygulama senaryosuna baglanmasi.

Yapay zeka ciktisi anlasilmadan kullanilmamistir. Kodlar proje icinde test edilmis, hata alinan kisimlar duzeltilmis ve sistemin mantigi incelenmistir.

## 12. Grup Uyelerinin Katkilari

> Teslimden once grup uyelerinin isimleri bu tabloya yazilmalidir.

| Grup Uyesi | Katki |
|---|---|
| Uye 1 | Proje fikri, Rails kurulumu, temel CRUD yapisi, arayuz kontrolu |
| Uye 2 | Etkinlik sistemi, harita ve hava durumu ozellikleri |
| Uye 3 | Admin paneli, bilet sistemi, test ve rapor hazirligi |

## 13. Sonuc

CampusFlow, kampus yasaminda karsilasilan bilgi daginikligi problemine cozum ureten bir web uygulamasidir. Proje; veritabani kullanimi, CRUD islemleri, rol bazli yetkilendirme, arama/filtreleme, responsive arayuz, harita, hava durumu, bilet sistemi ve admin paneli gibi ozellikleri icerir.

Bu yonleriyle proje, Web Programlama dersi kapsaminda istenen teknik ve islevsel beklentileri karsilamayi hedeflemektedir.

