# CampusFlow Sistem Anlatisi

CampusFlow, Ataturk Universitesi kampusu icin hazirlanmis bir kampus rehberi ve etkinlik takip sistemidir.

Bu sistemde ogrenciler kampuste nerede calisabileceklerini, hangi mekanin daha sessiz oldugunu, hangi alanda WiFi'nin daha iyi oldugunu, yaklasan etkinlikleri ve etkinliklerin hava durumuna gore riskli olup olmadigini tek ekranda gorebilir.

## Sistem Ne Ise Yarar?

CampusFlow'un amaci, kampus icindeki daginik bilgileri tek bir uygulamada toplamaktir.

Ornegin bir ogrenci:

- Sessiz bir calisma yeri arayabilir.
- WiFi puani yuksek mekanlari karsilastirabilir.
- Kampus haritasinda mekanin nerede oldugunu gorebilir.
- Yaklasan konser, soylesi veya kulup etkinliklerini takip edebilir.
- Biletli etkinlikler icin bilet alabilir.
- Etkinlik gunu hava kotuyse sistemden uyari alabilir.

## Kullanici Rolleri

Sistemde iki kullanici turu vardir.

### Normal Kullanici

Normal kullanici uygulamayi kullanan ogrencidir.

Yapabilecekleri:

- Mekanlari gorur.
- Etkinlikleri gorur.
- Haritayi kullanir.
- Bildirimleri takip eder.
- Bilet alir.

Normal kullanici veri ekleme veya silme islemi yapamaz.

### Admin

Admin, sistemi yoneten kisidir.

Yapabilecekleri:

- Mekan ekler.
- Mekan duzenler.
- Mekan siler.
- Etkinlik ekler.
- Etkinlik duzenler.
- Etkinlik siler.
- Admin panelinden sistem ozetini takip eder.

Bu ayrim sayesinde herkesin her seyi degistirmesi engellenir.

## Mekan Sistemi

Mekan sistemi kampusteki onemli yerleri listeler.

Her mekan icin:

- Mekan adi
- Kategori
- Aciklama
- WiFi puani
- Sessizlik puani
- Konum bilgisi
- Harita koordinati

tutulur.

Bu sayede ogrenci kendi ihtiyacina gore mekan secebilir.

## Etkinlik Sistemi

Etkinlik sistemi kampuste olacak konser, soylesi, kulup bulusmasi veya diger duyurulari listeler.

Her etkinlik icin:

- Etkinlik adi
- Etkinlik turu
- Aciklama
- Tarih ve saat
- Konum
- Bagli mekan
- Bilet gerekli mi
- Bilet ucreti

bilgileri tutulur.

## Bilet Sistemi

Biletli etkinliklerde kullanici `Bilet Al` butonuna basar.

Sonra:

1. Bilet adedini secer.
2. Kart bilgilerini girer.
3. IBAN bilgisini girer.
4. Sistem bilgileri kontrol eder.
5. Uygunsa bilet kaydi olusur.

IBAN `TR` ile baslamazsa veya 26 karakter degilse bilet alinmaz.

Kart numarasinin tamami veritabaninda tutulmaz. Sadece son 4 hane saklanir.

## Hava Durumu ve Bildirimler

CampusFlow hava durumu bilgisini Open-Meteo servisinden alir.

Sistem etkinlik gunundeki hava durumunu kontrol eder.

Eger:

- Yagmur ihtimali yuksekse,
- Ruzgar cok siddetliyse,
- Etkinlik acik alandaysa,

kullaniciya uyari gosterilir.

Bu ozellikle biletli etkinliklerde onemlidir. Kullanici bilet almadan once hava riskini gorebilir.

## Harita Sistemi

Harita sayfasinda kampus mekanlari ve etkinlikler pin olarak gosterilir.

Kullanici:

- Mekanin nerede oldugunu gorebilir.
- Etkinlik konumunu gorebilir.
- Kendi konumundan rota alabilir.

Harita icin Leaflet ve OpenStreetMap kullanilmistir.

## Admin Paneli

Admin paneli sistemin yonetim ekranidir.

Burada:

- Toplam kullanici sayisi
- Toplam mekan sayisi
- Toplam etkinlik sayisi
- Bilet geliri
- Son etkinlikler
- Son kayit olan kullanicilar
- Son eklenen mekanlar

gorulur.

Admin buradan hizlica yeni etkinlik veya mekan ekleyebilir.

## Kisa Ozet

CampusFlow, kampus icinde:

- Mekan bulma,
- Etkinlik takip etme,
- Harita kullanma,
- Hava durumuna gore karar verme,
- Bilet alma,
- Admin tarafindan icerik yonetme

islerini tek uygulamada birlestirir.

Bu nedenle proje sadece basit bir CRUD uygulamasi degildir; kampus yasamindaki gercek bir problemi cozmeye odaklanir.

