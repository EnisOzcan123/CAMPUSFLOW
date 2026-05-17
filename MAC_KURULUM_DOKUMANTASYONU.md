# CampusFlow Mac Kurulum Dokumantasyonu

Bu dokuman, CampusFlow projesini baska bir Mac cihazinda sifirdan calistirmak icin gerekli kurulum adimlarini anlatir.

## 1. Proje Icin Gerekli Surumler

CampusFlow projesinde kullanilan temel surumler:

| Arac | Surum |
| --- | --- |
| Ruby | 3.2.2 |
| Rails | 7.1.6 |
| Bundler | 2.4.10 |
| PostgreSQL | 14.x |
| Node.js | 16.x |
| Yarn | 1.22.x |
| Bootstrap | 5.3.8 |
| Leaflet | 1.9.4 |

Projede PostgreSQL veritabani kullanilir. Arayuz tarafi icin Bootstrap, Sass ve PostCSS kullanilir.

## 2. Homebrew Kurulumu

Mac cihazda Homebrew kurulu degilse once Homebrew kurulmalidir.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Kurulumdan sonra terminali kapatip yeniden acmak faydali olur.

Homebrew kontrolu:

```bash
brew -v
```

## 3. Gerekli Sistem Paketlerini Kurma

Asagidaki araclar kurulmalidir:

```bash
brew install rbenv ruby-build postgresql@14 node@16 yarn
```

Bu komut su araclari kurar:

- `rbenv`: Ruby surumlerini yonetmek icin kullanilir.
- `ruby-build`: rbenv ile Ruby kurabilmek icin gereklidir.
- `postgresql@14`: Projenin veritabani sistemidir.
- `node@16`: JavaScript paketleri ve CSS derleme islemleri icin gereklidir.
- `yarn`: Frontend paketlerini kurmak icin kullanilir.

## 4. PATH Ayarlari

Mac cihaz Apple Silicon ise, yani M1, M2, M3 veya daha yeni bir islemci kullaniyorsa:

```bash
echo 'export PATH="/opt/homebrew/opt/postgresql@14/bin:$PATH"' >> ~/.zshrc
echo 'export PATH="/opt/homebrew/opt/node@16/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc
source ~/.zshrc
```

Mac cihaz Intel islemciliyse:

```bash
echo 'export PATH="/usr/local/opt/postgresql@14/bin:$PATH"' >> ~/.zshrc
echo 'export PATH="/usr/local/opt/node@16/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc
source ~/.zshrc
```

Bu ayarlar terminalin Ruby, PostgreSQL ve Node komutlarini dogru yerden bulmasini saglar.

## 5. Ruby 3.2.2 Kurulumu

Proje Ruby `3.2.2` ile calisir.

```bash
rbenv install 3.2.2
rbenv global 3.2.2
ruby -v
```

Beklenen cikti buna benzer olmalidir:

```bash
ruby 3.2.2
```

## 6. Bundler Kurulumu

Projede Bundler `2.4.10` kullanilir.

```bash
gem install bundler -v 2.4.10
bundle -v
```

Beklenen cikti:

```bash
Bundler version 2.4.10
```

## 7. PostgreSQL Baslatma

PostgreSQL servisi baslatilmalidir.

```bash
brew services start postgresql@14
psql --version
```

Beklenen cikti buna benzer olabilir:

```bash
psql (PostgreSQL) 14.x
```

Eger veritabani olustururken kullanici hatasi alinirsa asagidaki komut calistirilabilir:

```bash
createuser -s $(whoami)
```

Bu komut mevcut Mac kullanicisini PostgreSQL icin yetkili kullanici yapar.

## 8. Proje Klasorune Girme

Proje klasoru cihaza tasindiktan veya GitHub'dan indirildikten sonra klasore girilir:

```bash
cd CampusFlow
```

## 9. Ruby Gem Paketlerini Kurma

Projedeki Ruby paketleri `Gemfile` ve `Gemfile.lock` dosyalarina gore kurulur.

```bash
bundle install
```

Bu komut Rails, PostgreSQL adapteri, bcrypt, importmap, turbo, stimulus ve diger Ruby bagimliliklarini kurar.

## 10. Node ve Yarn Paketlerini Kurma

Frontend paketleri `package.json` ve `yarn.lock` dosyalarina gore kurulur.

```bash
yarn install
```

Bu komut Bootstrap, Bootstrap Icons, Leaflet, Sass, PostCSS ve Nodemon paketlerini kurar.

## 11. CSS Dosyasini Derleme

Arayuzun dogru gorunmesi icin CSS dosyasi derlenmelidir.

```bash
yarn build:css
```

Eger bu adim yapilmazsa sayfa acilabilir ama tasarim bozuk veya eksik gorunebilir.

## 12. Veritabani Kurulumu

Veritabani olusturulur:

```bash
rails db:create
```

Tablolar olusturulur:

```bash
rails db:migrate
```

Ornek veriler yuklenir:

```bash
rails db:seed
```

Bu adimlardan sonra mekanlar, etkinlikler ve baslangic verileri sisteme eklenmis olur.

## 13. Uygulamayi Calistirma

Projeyi calistirmanin onerilen yolu:

```bash
bin/dev
```

Bu komut hem Rails server'i hem de CSS izleme sistemini birlikte calistirir.

Alternatif olarak sadece Rails server calistirilabilir:

```bash
rails s
```

Tarayicida su adres acilir:

```text
http://localhost:3000
```

## 14. Kurulum Kontrol Komutlari

Kurulumdan sonra asagidaki komutlarla surumler kontrol edilebilir:

```bash
ruby -v
rails -v
bundle -v
psql --version
node -v
yarn -v
```

Beklenen temel surumler:

```text
Ruby: 3.2.2
Rails: 7.1.6
Bundler: 2.4.10
PostgreSQL: 14.x
Node.js: 16.x
Yarn: 1.22.x
```

## 15. Sik Karsilasilan Sorunlar

### Rails komutu bulunamiyor

Ruby ve Bundler kurulmus olsa bile gemler yuklenmemis olabilir.

```bash
bundle install
bundle exec rails -v
```

### PostgreSQL baglanti hatasi

PostgreSQL servisi calismiyor olabilir.

```bash
brew services start postgresql@14
```

Kullanici yetkisi yoksa:

```bash
createuser -s $(whoami)
```

### Tasarim bozuk gorunuyor

CSS derlenmemis olabilir.

```bash
yarn install
yarn build:css
```

Gelistirme sirasinda en dogru calistirma komutu:

```bash
bin/dev
```

### `pg` gem kurulumu hata veriyor

PostgreSQL yolu terminal tarafindan bulunamiyor olabilir.

Apple Silicon Mac icin:

```bash
export PATH="/opt/homebrew/opt/postgresql@14/bin:$PATH"
bundle install
```

Intel Mac icin:

```bash
export PATH="/usr/local/opt/postgresql@14/bin:$PATH"
bundle install
```

## 16. Kisa Kurulum Ozeti

Tum kurulumun ozet hali:

```bash
brew install rbenv ruby-build postgresql@14 node@16 yarn
echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc
source ~/.zshrc
rbenv install 3.2.2
rbenv global 3.2.2
gem install bundler -v 2.4.10
brew services start postgresql@14
cd CampusFlow
bundle install
yarn install
yarn build:css
rails db:create
rails db:migrate
rails db:seed
bin/dev
```

Tarayici adresi:

```text
http://localhost:3000
```

## 17. Not

CampusFlow, PostgreSQL veritabani ile calisan Ruby on Rails tabanli bir web uygulamasidir. Bu nedenle sadece proje dosyasini acmak yeterli degildir; Ruby, Rails, PostgreSQL, Node ve Yarn bagimliliklari kurulmalidir.

Arayuzun dogru calismasi icin `yarn build:css`, gelistirme sirasinda otomatik takip icin ise `bin/dev` kullanilmalidir.
