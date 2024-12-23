# Proje Adı: Online Alışveriş Sistemi

## 1. Giriş

Bu belge, Online Alışveriş Sistemi projesinin gereksinimlerini ve işlevselliklerini tanımlamaktadır. Bu belge, proje ekibi ve paydaşlar arasında ortak bir anlayış oluşturmak amacıyla hazırlanmıştır.

## 2. Proje Tanımı

Online Alışveriş Sistemi, kullanıcıların ürünleri çevrimiçi olarak satın alabilecekleri bir platformdur. Sistem, ürün arama, sepet yönetimi, ödeme işlemleri ve sipariş takibi gibi işlevleri içermektedir.

## 3. Paydaşlar

- Proje Yöneticisi: Ahmet Yılmaz
- Yazılım Geliştirici: Ayşe Demir
- Test Mühendisi: Mehmet Kaya
- Müşteri Temsilcisi: Elif Öz

## 4. Gereksinimler

### 4.1 İşlevsel Gereksinimler

- Kullanıcılar ürünleri arayabilmeli ve filtreleyebilmelidir.
- Kullanıcılar ürünleri sepete ekleyebilmeli ve sepeti yönetebilmelidir.
- Kullanıcılar ödeme işlemlerini gerçekleştirebilmelidir.
- Kullanıcılar siparişlerini takip edebilmelidir.

### 4.2 İşlevsel Olmayan Gereksinimler

- Sistem, 1000 eşzamanlı kullanıcıyı desteklemelidir.
- Sistem, %99.9 çalışma süresi sağlamalıdır.
- Kullanıcı verileri şifrelenmiş olarak saklanmalıdır.

## 5. Kullanıcı Senaryoları ve Kullanım Durumları

### Senaryo 1: Ürün Arama

1. Kullanıcı, ana sayfada arama çubuğuna ürün adını yazar.
2. Sistem, arama sonuçlarını listeler.
3. Kullanıcı, sonuçlardan bir ürünü seçer ve ürün detaylarını görüntüler.

## 6. Sistem Mimarisi

- Web sunucusu: Apache
- Veritabanı: MySQL
- Programlama Dili: Python (Django Framework)

## 7. Veri Gereksinimleri

- Kullanıcı Tablosu: Kullanıcı bilgileri (ad, soyad, e-posta, şifre)
- Ürün Tablosu: Ürün bilgileri (ad, fiyat, stok durumu)

## 8. Arayüz Gereksinimleri

- Kullanıcı dostu ve mobil uyumlu bir arayüz tasarımı.
- Ürün arama, sepet yönetimi ve ödeme işlemleri için kullanıcı arayüzleri.

## 9. Güvenlik Gereksinimleri

- Kullanıcı şifreleri SHA-256 algoritması ile şifrelenmelidir.
- Ödeme işlemleri SSL üzerinden gerçekleştirilmelidir.

## 10. Test ve Kabul Kriterleri

- Tüm işlevsel gereksinimler test edilmelidir.
- Sistem, 1000 eşzamanlı kullanıcıyı desteklemelidir.
- Kullanıcı verileri şifrelenmiş olarak saklanmalıdır.

## 11. Bakım ve Destek

- Sistem, haftalık yedekleme yapılmalıdır.
- Yazılım güncellemeleri düzenli olarak yapılmalıdır.

## 12. Ekler

- Kullanıcı Kılavuzu
- Teknik Dokümantasyon
