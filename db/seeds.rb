Event.destroy_all
Place.destroy_all

library = Place.create!(
  name: "Merkez Kütüphane",
  category: "Kütüphane",
  description: "Uzun çalışma seansları için sessiz katlar, rahat masalar ve güçlü WiFi sunar.",
  wifi_score: 9,
  quiet_score: 10,
  location_label: "Atatürk Üniversitesi merkez kampüs",
  map_x: 68,
  map_y: 34,
  latitude: 39.901177,
  longitude: 41.2455405
)

student_center = Place.create!(
  name: "Öğrenci Yaşam Merkezi",
  category: "Kafe",
  description: "Kulüp buluşmaları, kahve molaları ve ders arası kısa çalışmalar için canlı bir merkez.",
  wifi_score: 7,
  quiet_score: 5,
  location_label: "Merkez kampüs öğrenci alanı",
  map_x: 38,
  map_y: 48,
  latitude: 39.902850,
  longitude: 41.251800
)

engineering_lounge = Place.create!(
  name: "Mühendislik Fakültesi Çalışma Alanı",
  category: "Çalışma Alanı",
  description: "Proje grupları ve mühendislik öğrencileri arasında popüler, pratik bir ortak çalışma alanı.",
  wifi_score: 8,
  quiet_score: 6,
  location_label: "Mühendislik fakültesi B blok",
  map_x: 24,
  map_y: 66,
  latitude: 39.9007769,
  longitude: 41.2435827
)

yemekhane = Place.create!(
  name: "Merkezi Yemekhane",
  category: "Yemekhane",
  description: "Öğle saatlerinde yoğunlaşan, kampüs içi günlük ihtiyaçlar için temel durak.",
  wifi_score: 6,
  quiet_score: 3,
  location_label: "Merkez kampüs yemekhane çevresi",
  map_x: 48,
  map_y: 54,
  latitude: 39.904100,
  longitude: 41.249900
)

culture_center = Place.create!(
  name: "Kültür Merkezi",
  category: "Etkinlik Alanı",
  description: "Söyleşi, seminer ve kampüs etkinliklerinin düzenlendiği kapalı etkinlik noktası.",
  wifi_score: 7,
  quiet_score: 6,
  location_label: "Merkez kampüs kültür alanı",
  map_x: 61,
  map_y: 44,
  latitude: 39.903650,
  longitude: 41.253650
)

garden = Place.create!(
  name: "Açık Etkinlik ve Bahçe Alanı",
  category: "Açık Alan",
  description: "Hava güzelken açık hava etkinlikleri, kısa dinlenmeler ve kampüs buluşmaları için ferah alan.",
  wifi_score: 5,
  quiet_score: 7,
  location_label: "Merkez kampüs açık alan",
  map_x: 57,
  map_y: 72,
  latitude: 39.904583,
  longitude: 41.255474
)

Event.create!(
  title: "Bahar Konseri",
  event_type: "Konser",
  description: "Kampüs açık sahnesinde öğrenci grupları ve davetli sanatçılarla bahar konseri.",
  starts_at: 3.days.from_now.change(hour: 19, min: 30),
  location: "Kuzey Bahçe Sahnesi",
  place: garden,
  ticket_required: true,
  ticket_price: 180
)

Event.create!(
  title: "Girişimcilik Söyleşisi",
  event_type: "Söyleşi",
  description: "Mezun girişimciler kampüste ürün geliştirme ve ekip kurma deneyimlerini anlatıyor.",
  starts_at: 5.days.from_now.change(hour: 14, min: 0),
  location: "Kültür Merkezi Konferans Salonu",
  place: culture_center,
  ticket_required: false
)

Event.create!(
  title: "Yazılım Kulübü Tanışma Buluşması",
  event_type: "Kulüp",
  description: "Yeni üyeler için proje ekipleri, atölyeler ve dönem planının konuşulacağı tanışma buluşması.",
  starts_at: 7.days.from_now.change(hour: 17, min: 0),
  location: "Mühendislik Dinlenme Alanı",
  place: engineering_lounge,
  ticket_required: false
)

Event.create!(
  title: "Kahve Arası Quiz Gecesi",
  event_type: "Diğer",
  description: "Takımlar halinde kısa quiz, küçük ödüller ve kampüs kafe özel menüsü.",
  starts_at: 10.days.from_now.change(hour: 18, min: 0),
  location: "Öğrenci Yaşam Merkezi",
  place: student_center,
  ticket_required: true,
  ticket_price: 60
)
