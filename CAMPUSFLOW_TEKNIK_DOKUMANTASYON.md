# CampusFlow Teknik Dokumantasyon

Bu dokuman, CampusFlow projesinin kod yapisini, temel akislarini ve hangi dosyanin ne icin kullanildigini anlamak icin hazirlanmistir.

## 1. Proje Ozeti

CampusFlow, Ataturk Universitesi kampusu icin gelistirilmis bir web uygulamasidir. Uygulama; kampus mekanlarini, etkinlikleri, haritayi, hava durumu uyarisini, bilet alma surecini ve admin yonetimini tek sistemde toplar.

Temel hedef, ogrencilerin kampus icindeki mekanlara, etkinliklere ve duyurulara daha hizli ulasmasini saglamaktir.

## 2. Kullanilan Teknolojiler

- Ruby on Rails 7.1.6
- Ruby
- PostgreSQL
- ERB view yapisi
- Bootstrap 5
- Bootstrap Icons
- Sass / CSS Bundling
- Leaflet ve OpenStreetMap
- Open-Meteo hava durumu API'si
- OSRM rota servisi
- Bcrypt ile sifreleme

## 3. Projeyi Calistirma

Terminalde proje klasorune gir:

```bash
cd /Users/enis/CampusFlow
```

Veritabani hazir degilse:

```bash
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
```

CSS derlemek icin:

```bash
yarn build:css
```

Server baslatmak icin:

```bash
bin/rails server
```

Tarayici adresi:

```text
http://localhost:3000
```

## 4. Ana Klasor Yapisi

```text
app/
  controllers/       Istekleri karsilayan controller dosyalari
  models/            Veritabani tablolarina karsilik gelen modeller
  views/             ERB arayuz dosyalari
  services/          Harici servis ve is mantigi siniflari
  assets/            Stil dosyalari

config/
  routes.rb          URL ve controller eslestirmeleri
  locales/tr.yml     Turkce alan adlari ve tarih formatlari

db/
  migrate/           Veritabani degisiklikleri
  seeds.rb           Ornek mekan ve etkinlik verileri
  schema.rb          Guncel veritabani semasi

public/
  auth-campus.jpg    Giris/kayit ekraninda kullanilan kampus gorseli
  favicon.svg        CampusFlow sekme ikonu
```

## 5. Route Yapisi

Onemli route'lar:

```text
/                         Mekan listesi ana sayfa
/places                   Mekan listeleme
/places/new               Mekan ekleme, sadece admin
/events                   Etkinlik listeleme
/events/new               Etkinlik ekleme, sadece admin
/events/:id/tickets/new   Bilet alma ekrani
/harita                   Kampus haritasi
/bildirimler              Kampus akisi, hava durumu ve bildirimler
/giris                    Giris ekrani
/kayit-ol                 Kayit ekrani
/admin                    Admin paneli
```

Route tanimlari [config/routes.rb](/Users/enis/CampusFlow/config/routes.rb) dosyasindadir.

## 6. Modeller

### User

Dosya: [app/models/user.rb](/Users/enis/CampusFlow/app/models/user.rb)

Kullanici modelidir.

Alanlar:

- `name`
- `email`
- `password_digest`
- `role`

Roller:

- `user`: Normal kullanici
- `admin`: Admin kullanici

Onemli metodlar:

- `admin?`: Kullanici admin mi kontrol eder.
- `role_name`: Ekranda gosterilecek rol adini dondurur.

Sifreler `has_secure_password` ile sifrelenir. Bunun icin `bcrypt` kullanilir.

### Place

Dosya: [app/models/place.rb](/Users/enis/CampusFlow/app/models/place.rb)

Kampus mekanlarini temsil eder.

Alanlar:

- `name`
- `category`
- `description`
- `wifi_score`
- `quiet_score`
- `location_label`
- `latitude`
- `longitude`

Kullanim amaci:

- Kutuphane, kafe, yemekhane, calisma alani gibi yerleri listelemek.
- Haritada mekan pinleri gostermek.
- WiFi ve sessizlik puanlarini gostermek.

### Event

Dosya: [app/models/event.rb](/Users/enis/CampusFlow/app/models/event.rb)

Kampus etkinliklerini temsil eder.

Alanlar:

- `title`
- `event_type`
- `description`
- `starts_at`
- `location`
- `place_id`
- `ticket_required`
- `ticket_price`

Onemli metodlar:

- `outdoor?`: Etkinligin acik alanda olup olmadigini anlamaya calisir.
- `free?`: Etkinligin ucretsiz olup olmadigini dondurur.

### Ticket

Dosya: [app/models/ticket.rb](/Users/enis/CampusFlow/app/models/ticket.rb)

Bilet alma islemini temsil eder.

Alanlar:

- `event_id`
- `user_id`
- `quantity`
- `total_price`
- `status`
- `card_holder_name`
- `card_last_four`
- `payer_iban`

Guvenlik notu:

Kart numarasinin tamami veritabanina kaydedilmez. Sadece son 4 hane `card_last_four` olarak saklanir.

IBAN kurali:

- `TR` ile baslamali.
- Toplam 26 karakter olmali.
- `TR` sonrasinda 24 rakam bulunmali.

## 7. Controller Yapisi

### ApplicationController

Dosya: [app/controllers/application_controller.rb](/Users/enis/CampusFlow/app/controllers/application_controller.rb)

Genel oturum ve yetki metodlarini icerir:

- `current_user`
- `user_signed_in?`
- `admin_signed_in?`
- `require_login`
- `require_admin`

Admin olmayan kullanicilar admin islemlerine giremez.

### RegistrationsController

Dosya: [app/controllers/registrations_controller.rb](/Users/enis/CampusFlow/app/controllers/registrations_controller.rb)

Kayit olma islemini yapar. Kayit sirasinda kullanici `Normal kullanici` veya `Admin` rolunu secebilir.

### SessionsController

Dosya: [app/controllers/sessions_controller.rb](/Users/enis/CampusFlow/app/controllers/sessions_controller.rb)

Giris ve cikis islemlerini yapar.

### PlacesController

Dosya: [app/controllers/places_controller.rb](/Users/enis/CampusFlow/app/controllers/places_controller.rb)

Mekan listeleme herkese aciktir. Mekan ekleme, duzenleme ve silme sadece adminlere aciktir.

### EventsController

Dosya: [app/controllers/events_controller.rb](/Users/enis/CampusFlow/app/controllers/events_controller.rb)

Etkinlik listeleme ve detay herkese aciktir. Etkinlik ekleme, duzenleme ve silme sadece adminlere aciktir.

Etkinlik detayinda hava durumu kontrolu de yapilir. Biletli bir etkinlikte hava kotuyse kullanici uyarilir.

### TicketsController

Dosya: [app/controllers/tickets_controller.rb](/Users/enis/CampusFlow/app/controllers/tickets_controller.rb)

Bilet alma islemini yonetir.

Akis:

1. Kullanici etkinlik detayinda `Bilet Al` butonuna basar.
2. Bilet adedi secilir.
3. Kart bilgileri ve IBAN girilir.
4. IBAN dogru formatta degilse bilet kaydedilmez.
5. Dogruysa `Ticket` kaydi olusur.

### Admin::DashboardController

Dosya: [app/controllers/admin/dashboard_controller.rb](/Users/enis/CampusFlow/app/controllers/admin/dashboard_controller.rb)

Admin panelini hazirlar.

Admin panelinde:

- Kullanici sayisi
- Mekan sayisi
- Etkinlik sayisi
- Bilet geliri
- Son etkinlikler
- Son kullanicilar
- Son mekanlar

gosterilir.

## 8. Servis Sinifi

### WeatherForecast

Dosya: [app/services/weather_forecast.rb](/Users/enis/CampusFlow/app/services/weather_forecast.rb)

Open-Meteo API'sinden hava durumu verisi alir.

Kullanim alanlari:

- Bildirimler sayfasi
- Hava durumu kartlari
- Etkinlik detayindaki hava uyarisi
- Bilet alma ekranindaki hava uyarisi

Onemli metodlar:

- `current`: Anlik hava durumu
- `daily`: 10 gunluk tahmin
- `event_forecast(event)`: Etkinlik saatine en yakin hava tahmini
- `bad_weather?(forecast)`: Hava riskli mi kontrolu
- `weather_icon(code)`: Hava durumuna uygun ikon
- `weather_tone(code)`: Hava durumuna uygun tema

## 9. Yetki Sistemi

CampusFlow iki rol icerir:

### Normal Kullanici

Yapabilir:

- Mekanlari gorur.
- Etkinlikleri gorur.
- Haritayi kullanir.
- Bildirimleri gorur.
- Bilet alir.

Yapamaz:

- Mekan ekleyemez.
- Mekan duzenleyemez.
- Mekan silemez.
- Etkinlik ekleyemez.
- Etkinlik duzenleyemez.
- Etkinlik silemez.
- Admin panelini goremez.

### Admin

Yapabilir:

- Normal kullanicinin yapabildigi her seyi yapar.
- Mekan ekler.
- Mekan duzenler.
- Mekan siler.
- Etkinlik ekler.
- Etkinlik duzenler.
- Etkinlik siler.
- Admin panelini kullanir.

## 10. Arayuz Dosyalari

Onemli view dosyalari:

```text
app/views/layouts/application.html.erb
app/views/places/index.html.erb
app/views/places/show.html.erb
app/views/events/index.html.erb
app/views/events/show.html.erb
app/views/tickets/new.html.erb
app/views/notifications/index.html.erb
app/views/maps/show.html.erb
app/views/admin/dashboard/show.html.erb
app/views/sessions/new.html.erb
app/views/registrations/new.html.erb
```

Stil dosyasi:

```text
app/assets/stylesheets/application.bootstrap.scss
```

## 11. Ozgun Ozellikler

CampusFlow sadece CRUD uygulamasi degildir. Projede su ozgun ozellikler vardir:

- Kampus mekanlarini WiFi ve sessizlik puanina gore karsilastirma
- Leaflet tabanli kampus haritasi
- Kullanici konumundan rota alma
- Etkinlik pinlerini haritada gosterme
- Open-Meteo ile hava durumu entegrasyonu
- Hava durumuna gore etkinlik riski uyarisi
- Biletli etkinlik sistemi
- IBAN format kontrolu
- Admin paneli
- Rol bazli yetkilendirme

## 12. Veritabani Tablolari

### users

Kullanicilari saklar.

### places

Mekanlari saklar.

### events

Etkinlikleri saklar.

### tickets

Alinan biletleri saklar.

## 13. Dikkat Edilmesi Gerekenler

- `db:seed` calistirilirsa mevcut ornek etkinlik ve mekanlar yeniden olusturulur.
- Admin olmayan kullanici URL yazarak admin islemlerine girmeye calissa bile engellenir.
- Kart numarasi tam olarak saklanmaz.
- Hava durumu API'si dis servise baglidir; internet yoksa hava verisi bos gelebilir.
- Harita OpenStreetMap tile verisine baglidir.

