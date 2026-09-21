# Identitas
Nama            : Fahmi Arif Setiawan <br>
NIM             : H1D024014 <br>
Shift Awal & Baru : A & I <br>

# Screenshot
## Display Pertemuan 2

<p>
  <img src="Hasil%20Praktikum/pert2-1.jpg" width="200"/>
  <img src="Hasil%20Praktikum/pert2-2.jpg" width="200"/>
</p>

Di pertemuan 2, dilakukan konfigurasi seperti pembuatan skema warna, modifikasi tipografi, pembuatan shape, serta penambahan fitur NavController. Kemudian ada 2 layar utama yaitu `BasicInfoScreen` dan `HubungiKamiScreen`. Jadi hasilnya adalah aplikasi dengan dua halaman yang terhubung oleh navigasi NavController. Halaman 1 menampilkan info aplikasi dengan Card dan tombol navigasi, sedangkan halaman kedua berisi form kontak dengan OutlinedTextField, Button berikon, dan Snackbar konfirmasi.

## Display Pertemuan 3

<p>
  <img src="Hasil%20Praktikum/pert3-1.jpg" width="200"/>
  <img src="Hasil%20Praktikum/pert3-2.jpg" width="200"/>
</p>

Di pertemuan 3, diterapkan konsep Dynamic Lists menggunakan Lazy Layouts pada Jetpack Compose. Dibuat data class `Category` dan `Product` di package `data.model`, serta `DummyData` (singleton object) berisi 3 kategori dan 15 produk lokal khas Purbalingga. Hasilnya adalah layar `DaftarProdukScreen` yang menampilkan TopAppBar hijau "Daftar Produk UMKM" dengan ikon keranjang belanja, `LazyRow` untuk filter kategori (Makanan, Minuman, Kerajinan) yang berubah warna saat dipilih, serta `LazyVerticalGrid` 2 kolom yang menampilkan kartu produk secara efisien. Klik pada kartu produk menampilkan Toast konfirmasi. Dibuat pula `HomeActivity` sebagai Launcher Activity baru, menggantikan `MainActivity` sebagai pintu masuk utama aplikasi. Layar mendukung Light & Dark theme.