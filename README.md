# Kantin Digital - Flutter Mobile App

Aplikasi mobile Kantin Digital menggunakan Flutter yang terintegrasi penuh dengan API kantin untuk UKK (Uji Kompetensi Keahlian). Aplikasi ini mendukung 3 role: Admin, Stan, dan Siswa.

## 🎯 Fitur Utama

### 🔐 Authentication (Semua Role)
- Login dengan username & password
- Register untuk role Stan dan Siswa
- Logout dengan konfirmasi
- Token management dengan SharedPreferences

### 👨‍💼 Fitur Admin
- Dashboard dengan menu manajemen
- CRUD Stan (Create, Read, Update, Delete)
- CRUD Menu
- CRUD Siswa
- CRUD Diskon
- Lihat dan kelola semua transaksi
- Kelola status transaksi

### 🏪 Fitur Stan (Pemilik Stan)
- Dashboard stan
- Kelola menu stan sendiri (CRUD)
- Lihat transaksi untuk stan sendiri
- Update status transaksi (belum dikonfirm → dimasak → diantar → sampai)
- Filter transaksi berdasarkan status

### 👨‍🎓 Fitur Siswa
- Dashboard siswa
- Browse menu dari semua stan
- Filter menu berdasarkan jenis (makanan/minuman)
- Lihat detail menu dengan foto dan deskripsi
- Shopping cart untuk pesan multiple items
- Kelola jumlah item dalam cart
- Checkout transaksi
- Lihat riwayat transaksi dengan status tracking real-time

## 📋 Struktur Project

```
lib/
├── main.dart                          # Entry point aplikasi
├── config/
│   └── api_config.dart               # Konfigurasi API endpoints
├── models/
│   ├── user_model.dart               # Model untuk User
│   ├── stan_model.dart               # Model untuk Stan
│   ├── menu_model.dart               # Model untuk Menu
│   ├── diskon_model.dart             # Model untuk Diskon
│   ├── siswa_model.dart              # Model untuk Siswa
│   └── transaksi_model.dart          # Model untuk Transaksi & Cart
├── services/
│   ├── auth_service.dart             # Service untuk authentication
│   ├── stan_service.dart             # Service untuk CRUD Stan
│   ├── menu_service.dart             # Service untuk CRUD Menu
│   ├── diskon_service.dart           # Service untuk CRUD Diskon
│   ├── siswa_service.dart            # Service untuk CRUD Siswa
│   └── transaksi_service.dart        # Service untuk CRUD Transaksi
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart         # Halaman login
│   │   └── register_screen.dart      # Halaman registrasi
│   ├── admin/
│   │   ├── admin_dashboard.dart      # Dashboard admin
│   │   ├── stan_management_screen.dart       # Kelola Stan
│   │   ├── menu_management_screen.dart       # Kelola Menu
│   │   ├── siswa_management_screen.dart      # Kelola Siswa
│   │   ├── diskon_management_screen.dart     # Kelola Diskon
│   │   └── transaksi_admin_screen.dart       # Kelola Transaksi
│   ├── stan/
│   │   ├── stan_dashboard.dart       # Dashboard stan
│   │   ├── stan_menu_screen.dart     # Kelola menu stan
│   │   └── stan_transaksi_screen.dart # Kelola transaksi stan
│   └── siswa/
│       ├── siswa_dashboard.dart      # Dashboard siswa
│       ├── menu_list_screen.dart     # Daftar menu
│       ├── menu_detail_screen.dart   # Detail menu
│       ├── cart_screen.dart          # Keranjang belanja
│       └── transaksi_siswa_screen.dart # Riwayat transaksi
└── widgets/
    ├── custom_button.dart            # Custom button widget
    ├── custom_textfield.dart         # Custom text field widget
    ├── menu_card.dart                # Card untuk menampilkan menu
    └── loading_indicator.dart        # Loading indicator widget
```

## 🎨 Design System

### Warna Utama
- **Primary**: Orange (#FF9800)
- **Secondary**: Deep Orange (#FF5722)
- **Background**: White (#FFFFFF)
- **Text**: Dark Grey (#333333)

### Komponen UI
- Material Design 3
- Rounded corners (8-12px radius)
- Card elevation untuk depth
- Responsive layout dengan GridView dan ListView
- Bottom navigation untuk cart badge
- Expansion tiles untuk detail transaksi

## 🔧 Teknologi

### Dependencies
```yaml
dependencies:
  flutter: sdk: flutter
  http: ^1.1.0                    # HTTP client untuk API calls
  shared_preferences: ^2.2.2      # Local storage untuk token
  intl: ^0.18.1                   # Format currency (Rp)
  cached_network_image: ^3.3.0    # Cache gambar menu
  provider: ^6.1.1                # State management (optional)
```

## 🚀 Cara Menjalankan

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code
- Android Emulator atau iOS Simulator

### Instalasi

1. Clone repository
```bash
git clone https://github.com/EzraPatrikha123/kantin-ukk-flutter.git
cd kantin-ukk-flutter
```

2. Install dependencies
```bash
flutter pub get
```

3. Jalankan aplikasi
```bash
flutter run
```

## 🌐 API Configuration

**Base URL**: `https://ukk-p2.smktelkom-mlg.sch.id/api/`

**Dokumentasi API**: [Postman Documentation](https://documenter.getpostman.com/view/31319845/2sAYQZGrs6)

### Endpoints Utama
- `POST /login` - Login user
- `POST /register` - Registrasi user baru
- `POST /logout` - Logout user
- `GET /stan` - Get semua stan
- `GET /menu` - Get semua menu
- `GET /siswa` - Get semua siswa
- `GET /diskon` - Get semua diskon
- `GET /transaksi` - Get semua transaksi
- `PUT /transaksi/{id}` - Update status transaksi

## 📱 Fitur Khusus

### Shopping Cart
- Global cart menggunakan list state
- Add to cart dari menu list atau detail
- Update quantity (increase/decrease)
- Remove item dari cart
- Calculate total harga otomatis
- Checkout dengan konfirmasi

### Status Transaksi Real-time
Transaksi memiliki 4 status:
1. **Belum Dikonfirm** (Orange) - Pesanan baru masuk
2. **Dimasak** (Blue) - Stan sedang memproses
3. **Diantar** (Purple) - Pesanan dalam perjalanan
4. **Sampai** (Green) - Pesanan selesai

Status dapat diupdate oleh Stan secara sequential.

### Filter & Search
- Filter menu berdasarkan jenis (makanan/minuman)
- Filter transaksi berdasarkan status
- Pull to refresh untuk update data

## 🔒 Security

- Token-based authentication dengan Bearer token
- Token disimpan di SharedPreferences
- Auto logout jika token expired
- Input validation di semua form
- Konfirmasi untuk aksi destructive (delete, logout)

## 📝 Best Practices

✅ **Implemented:**
- Clean architecture dengan separation of concerns
- Model-Service-Screen pattern
- Reusable widgets
- Error handling di semua API calls
- Loading indicators untuk async operations
- Responsive UI dengan SafeArea
- Material Design guidelines
- Currency formatting dengan Intl package
- Image caching dengan cached_network_image

## 🎓 Catatan Pengembangan

### Known Limitations
- Cart menggunakan global variable (untuk simplicity)
- Filter by current user's id belum fully implemented (TODO comments added)
- Image upload belum diimplementasikan
- Refresh token handling belum ada

### Future Enhancements
- Provider/Bloc untuk state management
- Image picker untuk upload foto
- Push notifications untuk status update
- Search functionality
- Order history export
- Payment integration
- Rating & review system

## 📄 License

This project is created for educational purposes (UKK - Uji Kompetensi Keahlian).

## 👥 Author

Created by [EzraPatrikha123](https://github.com/EzraPatrikha123)

---

**Happy Coding! 🚀**