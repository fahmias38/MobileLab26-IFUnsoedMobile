2@@# Praktikum Pemrograman Mobile

## Pertemuan 4: *Recomposition* dan *UI Lifecycle*

**Disusun oleh:** Azis Amirulbahar, S.P.d., M.T.I.

**Program Studi Informatika**
**Fakultas Teknik**
**Universitas Jenderal Soedirman**
**2026**

---

## DAFTAR ISI

- PENDAHULUAN
  - A. Pengantar
  - B. Tujuan Praktikum
  - C. Alat dan Bahan
  - D. Dasar Teori
- TAHAPAN PRAKTIKUM
  - A. Modifikasi Permissions
  - B. Modifikasi Form Hubungi Kami
  - C. Modifikasi kode pada `DaftarProductScreen.kt`
  - D. Membuat Tampilan Detail Produk
  - E. Navigasi di HomeActivity untuk daftar produk ke detail produk
  - F. Menambahkan Menu Action di AppBar untuk navigasi ke Hubungi Kami

---

# PENDAHULUAN

## A. Pengantar

Pada pertemuan ke-4 ini, kita akan mempelajari konsep lanjutan dari Jetpack Compose yaitu pengelolaan State, Recomposition, State Hoisting, dan simulasi proses Asinkronus. Pada pertemuan sebelumnya, kita telah berhasil membuat layout dinamis menggunakan LazyList. Namun, antarmuka aplikasi yang baik tidak hanya menampilkan data statis, melainkan harus interaktif dan responsif terhadap aksi pengguna seperti mengetik pada form atau mencari sebuah data.

> "Modul pada pertemuan ke-4 dibuat lebih ringkas daripada pertemuan – pertemuan sebelumnya. Peserta diharapkan dapat secara mandiri untuk melakukan implementasi suatu tampilan dari kode yang dibuat dengan mengadopsi pertemuan sebelumnya, tanpa petunjuk/panduan baris kode seperti pada pertemuan sebelumnya. Terdapat pula implementasi komponen yang sama dengan pertemuan – pertemuan sebelumnya, sehingga penjelasan kode tidak perlu disertakan pada pertemuan ini dan peserta diharapkan secara mandiri untuk dapat mengimplementasikannya."

## B. Tujuan Praktikum

1. Memahami alur kerja Recomposition dan UI Lifecycle dalam antarmuka deklaratif.
2. Menerapkan State Hoisting untuk memisahkan Stateful Composable (pengelola data) dan Stateless Composable (penampil UI).
3. Menggunakan konsep Kotlin Lambda dan Higher-Order Functions sebagai jembatan event / aksi pengguna.
4. Membuat antarmuka form kompleks interaktif (Dropdown/Combobox, Checkbox, Image Upload) beserta validasinya.
5. Memahami dan menerapkan proses asinkronus (Coroutine) dasar menggunakan `LaunchedEffect` di Compose untuk memunculkan indikator Loading.

*[Gambar 1. Hasil Akhir Praktikum — tiga layar: (1) Daftar Produk UMKM dengan search bar "Cari produk...", kategori (Makanan, Minuman, Kerajinan) dan grid produk; (2) Detail Produk "Kripik Singkong" dengan tombol +/- jumlah beli dan tombol "Tambah ke Keranjang"; (3) form Hubungi Kami dengan Email, Tipe Pesan (dropdown), Pesan, tombol "Unggah Bukti (Screenshot / Foto)", checkbox "Saya menyetujui syarat & ketentuan", dan tombol "Kirim Pesan".]*

## C. Alat dan Bahan

1. Perangkat keras (PC/Laptop) dengan spesifikasi minimum sesuai standar Android Studio.
2. Android Studio (versi terbaru yang sudah mendukung Jetpack Compose secara bawaan).
3. Emulator Android (AVD) atau perangkat fisik Android yang terhubung melalui *debugging* (USB/Wi-Fi).

## D. Dasar Teori

1. **State dan Recomposition**: *State* adalah data yang dapat berubah seiring waktu dan menentukan apa yang dirender di layar (misal: teks yang sedang diketik user di kolom pencarian). *Recomposition* adalah proses otomatis di mana Compose memanggil ulang (menggambar ulang) bagian fungsi UI untuk memperbarui tampilan layar saat nilai *State* tersebut berubah.
2. ***Unidirectional Data Flow* (UDF)**: Pola desain standar di arsitektur modern di mana data (*State*) selalu mengalir turun dari fungsi induk (Parent) ke fungsi anak (Child), sedangkan aksi (*Event*) seperti klik selalu mengalir naik dari fungsi anak ke fungsi induk menggunakan fungsi *Lambda*.
3. **State Hoisting**: Teknik memindahkan pengelolaan variabel *State* ke fungsi induk (Stateful Composable) dan membiarkan fungsi UI di bawahnya murni hanya menerima data tanpa menyimpan data sendiri (Stateless Composable). Hal ini membuat fungsi UI lebih mudah diuji, tidak rawan bug, dan dapat digunakan kembali (*reusable*).
4. **LaunchedEffect & Coroutine**: Lingkungan khusus di dalam Compose yang memungkinkan eksekusi kode *Asynchronous* (berjalan di background thread). Fungsi ini sangat esensial untuk operasi yang memakan waktu, seperti mengunduh data dari API Server atau simulasi jeda sistem, tanpa menyebabkan UI utama macet atau berhenti merespons.

---

# TAHAPAN PRAKTIKUM

Pada bagian ini, peserta diminta untuk mengikuti tahapan – tahapan sehingga menghasilkan aplikasi sederhana seperti pada Gambar 1 di halaman sebelumnya.

> **Catatan:** Kode pada modul asli berupa tangkapan layar (gambar). Blok kode di bawah ini adalah hasil transkripsi dari gambar tersebut. Bagian yang tidak terlihat penuh pada gambar ditandai dengan komentar `// ...`. Silakan cek kembali terhadap PDF asli bila ada yang meragukan.

---

## A. Modifikasi Permissions

Android Permission (Hak Akses) adalah mekanisme keamanan utama pada sistem operasi Android yang dirancang untuk melindungi privasi pengguna. Secara bawaan (default), sebuah aplikasi Android berjalan di dalam "kotak pasir" (*sandbox*) terisolasi dan sama sekali tidak memiliki akses untuk menggunakan sumber daya atau data sensitif pada perangkat pengguna (seperti kamera, daftar kontak, lokasi GPS, hingga memori penyimpanan file).

Agar aplikasi dapat mengakses sumber daya luar tersebut (dalam praktikum ini: fitur Unggah Gambar yang mengharuskan aplikasi masuk dan membaca galeri foto pengguna), aplikasi diwajibkan untuk mendeklarasikan permintaan izin secara eksplisit di dalam sebuah file konfigurasi utama yang bernama `AndroidManifest.xml`. Tanpa adanya deklarasi izin ini, sistem operasi Android akan memblokir paksa upaya aplikasi saat mencoba membuka memori HP, yang dapat menyebabkan aplikasi *crash* (*Force Close*).

**1.** Silakan buka file `AndroidManifest.xml` yang terletak di `app/src/main/AndroidManifest.xml`. Kemudian tambahkan kode berikut di atas TAG `<application>`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools">

    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="32" />
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />

    <application
    ...
```

*Gambar 2. Modifikasi AndroidManifest.xml*

---

## B. Modifikasi Form Hubungi Kami

Pada bagian ini, kita akan melakukan modifikasi form hubungi kami dengan menerapkan *lambda expression*, *state management*, serta implementasi permissions untuk membuka gambar dari galeri.

### 1. Deklarasi variabel di `HubungiKamiScreen`

Tambahkan deklarasi variabel di dalam function `HubungiKamiScreen` sesuai dengan gambar berikut dan lakukan import (atau tekan tombol `Control+Space`) jika kode terdapat error yang ditandai dengan warna merah.

```kotlin
fun HubungiKamiScreen(navController: NavController?) {
    var emailText by remember { mutableStateOf("") }
    var messageText by remember { mutableStateOf("") }
    var problemType by rememberSaveable { mutableStateOf("Pilih Tipe Pesan") }
    var isAgreed by rememberSaveable { mutableStateOf(false) }
    var imageUri by remember { mutableStateOf<Uri?>(null) }
```

*Gambar 3. Deklarasi Variabel*

**Penjelasan kode:**

Kode pada Gambar 3 merupakan penerapan tiga konsep pada ekosistem Jetpack Compose dan Kotlin yaitu: konsep **State & Recomposition**, penggunaan fungsi `remember` dan `rememberSaveable`, serta fitur pada Kotlin bernama **Property Delegation**.

Fungsi `mutableStateOf(...)`: dalam paradigma UI deklaratif Jetpack Compose, akan membuat tampilan layar bersifat reaktif terhadap perubahan data. Tipe data primitif biasa seperti `String` atau `Boolean` tidak mampu memberi sinyal ke Compose jika nilainya berubah. Oleh karena itu, perlu "membungkus" data tersebut ke dalam `mutableStateOf`. Sehingga, setiap kali nilai di dalam objek tersebut diperbarui, maka Jetpack Compose akan mendeteksi perubahan tersebut secara otomatis dan memicu proses *recomposition*, yaitu proses menggambar ulang bagian-bagian layar yang bergantung pada variabel tersebut agar selalu menampilkan data yang ter-update.

Namun, jika hanya menuliskan `mutableStateOf("")` tanpa pembungkus, nilai variabel akan selalu kembali ke nilai awal saat deklarasi setiap kali layar "digambar ulang". Sehingga diperlukan fungsi `remember`, yang akan memerintahkan Jetpack Compose untuk menyimpan dan "mengingat" nilai variabel tersebut di dalam *composition tree* selama siklus hidup komponen berlangsung. Namun, `remember` memiliki batasan yaitu data akan hilang jika terjadi perubahan konfigurasi perangkat (*configuration change*), seperti saat layar ponsel diputar dari mode portrait ke landscape atau sebaliknya. Untuk mengatasi hal itu, diperlukan `rememberSaveable`, seperti yang telah dideklarasikan pada variabel `problemType` dan `isAgreed`. Fungsi `rememberSaveable` akan menyimpan data ke dalam mekanisme *SavedInstanceState* Android, sehingga data pilihan dan centang pengguna tetap aman dan tidak tereset meskipun orientasi layar berubah atau proses aplikasi sempat dihentikan sementara oleh sistem operasi.

*Property Delegation* (delegasi properti) dengan kata kunci `by` akan "menyamarkan" kompleksitas pembungkus tersebut. Sehingga, kita bisa melakukan set nilai dalam variabel tanpa perlu berulang kali mengetik `.value`. Hal serupa juga diterapkan pada `imageUri` dengan anotasi tipe generik `mutableStateOf<Uri?>(null)`, yang secara eksplisit memberitahu Kotlin bahwa variabel tersebut memegang rujukan lokasi berkas gambar yang boleh bernilai kosong (*nullable*).

### 2. Variabel status validasi

Setelah mendeklarasikan variabel sesuai dengan Gambar 3, tambahkan variabel untuk menyimpan status validasi:

```kotlin
val isEmailValid = emailText.contains("@") && emailText.isNotBlank()
val isMessageValid = messageText.length >= 10
val isFormValid = isEmailValid && isMessageValid && isAgreed && problemType != "Pilih Tipe Pesan"

val scope = rememberCoroutineScope()
val snackbarHostState = remember { SnackbarHostState() }
```

*Gambar 4. Deklarasi Variabel*

**Penjelasan Kode:**

Variabel `isEmailValid` dievaluasi menggunakan operator logika `&&` (*AND*) dan fungsi bawaan (*standard library*) Kotlin, yaitu `contains("@")` serta `isNotBlank()`. Fungsi `isNotBlank()` memastikan bahwa teks email tidak sekadar berupa deretan spasi kosong, sekaligus melengkapi pengecekan keberadaan karakter `"@"`. Pada baris berikutnya, `isMessageValid` menggunakan properti bawaan `length` pada String untuk memastikan panjang karakter pesan bernilai minimal 10 karakter (`>= 10`). Kedua ekspresi ini menghasilkan tipe data primitif `Boolean` (`true` atau `false`) secara ringkas tanpa memerlukan blok percabangan if-else yang panjang seperti pada bahasa pemrograman lain.

`isFormValid` merupakan kombinasi dari seluruh aturan validasi formulir. Variabel tersebut menggabungkan hasil validasi sebelumnya (`isEmailValid` dan `isMessageValid`) dengan status persetujuan syarat ketentuan (`isAgreed`) serta memastikan pengguna telah memilih kategori masalah yang sah, yaitu nilainya tidak lagi sama dengan teks awal `"Pilih Tipe Pesan"` (`!=`). Jika dan hanya jika seluruh kondisi ini terpenuhi, `isFormValid` akan bernilai `true`.

### 3. Function `StatelessFormHubungiKami()`

Masih dalam file `HubungiKamiScreen.kt`, buatlah deklarasi function `StatelessFormHubungiKami()` seperti pada gambar berikut:

```kotlin
@Composable
fun StatelessFormHubungiKami(
    modifier: Modifier = Modifier,
    email: String, onEmailChange: (String) -> Unit, isEmailValid: Boolean,
    message: String, onMessageChange: (String) -> Unit, isMessageValid: Boolean,
    problemType: String, onProblemTypeChange: (String) -> Unit,
    isAgreed: Boolean, onAgreedChange: (Boolean) -> Unit,
    imageUri: Uri?, onImagePicked: (Uri?) -> Unit,
    isFormValid: Boolean, onSubmit: () -> Unit
) {

}
```

*Gambar 5. Deklarasi Function StatelessFormHubungiKami()*

**Penjelasan kode:**

Kode di atas mendefinisikan sebuah fungsi antarmuka (UI) bernama `StatelessFormHubungiKami`. Dalam paradigma Jetpack Compose, komponen UI idealnya dipisahkan antara yang memegang status (*stateful*) dan yang murni hanya bertugas menggambar tanpa menyimpan data internal (*stateless*). Konsep ini berakar pada teori **State Hoisting**, yaitu pola desain untuk menaikkan kepemilikan data ke komponen induk (*parent*) atau ke lapisan arsitektur yang lebih tinggi seperti `ViewModel` (yang akan dibahas pada pertemuan berikutnya). Manfaatnya, komponen `StatelessFormHubungiKami` menjadi sangat modular, mudah diuji (*testable*), dan bisa digunakan ulang (*reusable*) di berbagai layar tanpa terikat pada sumber data tertentu.

Penerapan *State Hoisting* pada parameter disusun menggunakan pola **Unidirectional Data Flow (UDF)**. Pada sistem deklaratif, **aliran data bergerak satu arah: data mengalir ke bawah menuju komponen UI, sedangkan aksi pengguna mengalir ke atas sebagai *event***. Parameter `email` (tipe String) dan `onEmailChange: (String) -> Unit` adalah contoh penerapannya. Komponen tersebut menerima teks email untuk ditampilkan ke layar, dan ketika pengguna mengetik karakter baru di papan ketik, fungsi ini tidak mengubah nilai variabel secara langsung. Fungsi tersebut justru memanggil *lambda expression* atau fungsi tingkat tinggi (*higher-order function*) di Kotlin bernama `onEmailChange` untuk memberitahu ke komponen induk bahwa ada perubahan data. Pola yang sama berulang pada penanganan pesan, tipe kendala, kotak centang persetujuan (`isAgreed`), hingga pemilihan berkas gambar (`imageUri` yang bertipe *nullable* `Uri?`).

### 4. Variabel PhotoPicker

Deklarasikan variabel untuk PhotoPicker di dalam function `StatelessFormHubungiKami()` tersebut seperti pada gambar berikut dan lakukan *import* terhadap *dependency/package* yang dibutuhkan:

```kotlin
val photoPickerLauncher = rememberLauncherForActivityResult(
    contract = ActivityResultContracts.PickVisualMedia(),
    onResult = { uri -> onImagePicked(uri) }
)
```

*Gambar 6. Deklarasi variabel PhotoPicker*

**Penjelasan kode:**

Fungsi `rememberLauncherForActivityResult` bertindak sebagai "jembatan" yang mendaftarkan *launcher* ke sistem Android dan "mengingatnya" agar tidak terbuat ulang saat layar di-refresh (*recomposition*). Kode `contract = ActivityResultContracts.PickVisualMedia()` berfungsi mengakses foto tanpa perlu meminta izin akses memori (*storage permission*). Blok `onResult = { uri -> onImagePicked(uri) }` menerima alamat lokasi foto (`Uri`) yang dipilih oleh pengguna, lalu langsung meneruskannya ke fungsi `onImagePicked` untuk memperbarui tampilan layar.

### 5. Pindahkan `Column` ke `StatelessFormHubungiKami()`

Pindahkan seluruh kode `Column` beserta *child*-nya di function `HubungiKamiScreen` ke dalam function `StatelessFormHubungiKami()`.

```kotlin
Column(
    modifier = Modifier
        .fillMaxSize()
        .padding(paddingValues)
        .padding(16.dp),
    horizontalAlignment = Alignment.CenterHorizontally
) {

    Text(
        text = "Hubungi Kami",
        style = MaterialTheme.typography.titleLarge,
        modifier = Modifier.align(Alignment.Start)
    )

    Spacer(modifier = Modifier.height(16.dp))

    OutlinedTextField(
        value = emailText,
        onValueChange = { emailText = it },
        label = { Text("Email Anda") },
        leadingIcon = {
            Icon(
                painter = painterResource(id = R.drawable.mail_icon),
                contentDescription = "Email"
            )
        },
        modifier = Modifier.fillMaxWidth(),
        shape = MaterialTheme.shapes.medium
        // ... (kode berikutnya ikut dipindahkan)
```

*Gambar 7. Blok kode yang perlu dipindah ke function StatelessFormHubungiKami()*

### 6. Hapus modifier padding `PaddingValues`

Hapus modifier padding yang memiliki parameter `PaddingValues` pada komponen `Column`:

```kotlin
Column(
    modifier = Modifier
        .fillMaxSize()
        .padding(paddingValues)   // <- HAPUS baris ini
        .padding(16.dp),
    horizontalAlignment = Alignment.CenterHorizontally
) {
```

*Gambar 8. Penghapusan baris kode pada komponen Column*

### 7. Ganti `Modifier` dengan parameter function

Ganti variabel *modifier* seperti gambar di bawah ini yang mengacu pada parameter *function* (huruf **m** kecil):

```kotlin
Column(
    modifier = modifier
        .fillMaxSize()
        .padding(16.dp),
    horizontalAlignment = Alignment.CenterHorizontally
) {
```

*Gambar 9. Penggantian parameter*

### 8. `OutlinedTextField` email: `onEmailChange`, `isError`, `supportingText`

Ganti nilai komponen `OutlinedTextField` pada parameter `onValueChange` dengan parameter `onEmailChange` serta tambahkan properti `isError` & `supportingText` pada `OutlinedTextField` seperti gambar berikut:

```kotlin
OutlinedTextField(
    value = emailText,   // (pada gambar masih terlihat emailText; sesuaikan menjadi email sesuai parameter function)
    onValueChange = onEmailChange,
    label = { Text("Email Anda") },
    leadingIcon = {
        Icon(
            painter = painterResource(id = R.drawable.mail_icon),
            contentDescription = "Email"
        )
    },
    isError = email.isNotEmpty() && !isEmailValid,
    supportingText = { if (email.isNotEmpty() && !isEmailValid) Text("Format Email Salah") },
    modifier = Modifier.fillMaxWidth(),
    shape = MaterialTheme.shapes.medium
)
```

*Gambar 9 (lanjutan). Perubahan `onValueChange`, `isError`, dan `supportingText` pada OutlinedTextField*

### 9. Komponen Dropdown (`ExposedDropdownMenuBox`)

Di bawah `OutlinedTextField` untuk email dan spacer, tambahkan Component `DropdownMenuBox` beserta deklarasi variabel pendukung seperti gambar berikut:

```kotlin
var expanded by remember { mutableStateOf(false) }
val options = listOf("Pertanyaan", "Keluhan", "Saran")

ExposedDropdownMenuBox(
    expanded = expanded,
    onExpandedChange = { expanded = !expanded }
) {
    OutlinedTextField(
        readOnly = true,
        value = problemType,
        onValueChange = { },
        label = { Text("Tipe Pesan") },
        trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = expanded) },
        colors = ExposedDropdownMenuDefaults.outlinedTextFieldColors(),
        modifier = Modifier.menuAnchor().fillMaxWidth()
    )
    ExposedDropdownMenu(
        expanded = expanded,
        onDismissRequest = { expanded = false }
    ) {
        options.forEach { selectionOption ->
            DropdownMenuItem(
                text = { Text(text = selectionOption) },
                onClick = {
                    onProblemTypeChange(selectionOption)
                    expanded = false
                }
            )
        }
    }
}
```

*Gambar 10. Pembuatan Components berbentuk DropDown*

**Penjelasan kode:**

Secara ringkas, kode pada Gambar 10 berfungsi untuk membangun komponen *dropdown menu*, dengan rincian sebagai berikut:

- **Penyimpan status dan opsi data:** Variabel `expanded` berfungsi sebagai penentu apakah daftar menu sedang terbuka atau tertutup (`true/false`), sedangkan `options` menyimpan daftar pilihan yang bisa diklik.
- **Kolom `OutlinedTextField`:** Dibungkus oleh `ExposedDropdownMenuBox` dan bernilai `readOnly = true` agar pengguna tidak mengetik manual, melainkan hanya melihat nilai yang terpilih (`problemType`). Modifier `.menuAnchor()` berfungsi mengaitkan posisi kolom teks sebagai dasar tempat munculnya daftar opsi.
- **Daftar opsi (`ExposedDropdownMenu`):** Menampilkan daftar pilihan melalui perulangan `options.forEach`. Ketika salah satu opsi diklik, aplikasi memicu fungsi *callback* `onProblemTypeChange` untuk mengirim data opsi yang dipilih ke komponen induk, lalu otomatis menutup kembali menunya lewat perintah `expanded = false`.

### 10. Tampilan Uri gambar dan Checkbox

Tambahkan pula komponen untuk menampilkan `Uri` gambar yang dipilih serta `checkbox` seperti pada gambar berikut:

```kotlin
if (imageUri != null) {
    Spacer(modifier = Modifier.height(8.dp))
    Card(colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant)) {
        Row(modifier = Modifier.padding(all = 12.dp), verticalAlignment = Alignment.CenterVertically) {
            Icon(painterResource(id = R.drawable.icon_check), contentDescription = "File")
            Spacer(modifier = Modifier.width(8.dp))
            Text("File terpilih: ${imageUri.lastPathSegment}")
        }
    }
}
Spacer(modifier = Modifier.height(12.dp))

Row(modifier = Modifier.fillMaxWidth(), verticalAlignment = Alignment.CenterVertically) {
    Checkbox(checked = isAgreed, onCheckedChange = onAgreedChange)
    Text("Saya menyetujui syarat & ketentuan")
}
Spacer(modifier = Modifier.height(16.dp))
```

*Gambar 11. Implementasi Kode untuk menampilkan Uri gambar serta Checkbox*

**Penjelasan kode:**

- **Tampilan konfirmasi gambar secara kondisional (`if (imageUri != null)`):** Blok tersebut mengimplementasikan logika percabangan kondisional secara deklaratif yaitu komponen `Card` hanya akan dirender ke layar jika variabel `imageUri` memiliki nilai (tidak `null`). Di dalamnya, sebuah `Row` yang berfungsi untuk menyusun `Icon` berdampingan secara horizontal dengan teks nama file yang diambil dari `imageUri.lastPathSegment`.
- **Persetujuan (`Checkbox`):** Disusun sejajar secara horizontal bersama label teks menggunakan `Row`. Komponen `Checkbox` ini menerapkan pola *stateless*: status centang dibaca langsung dari variabel `isAgreed`, dan setiap kali kotak disentuh oleh pengguna, perubahan statusnya diteruskan ke komponen induk melalui fungsi *callback* `onAgreedChange`.

### 11. Modifikasi tombol submit

Lakukan modifikasi button submit dengan mengganti nilai `onClick` seperti gambar berikut:

```kotlin
Button(
    onClick = onSubmit,
    enabled = isFormValid,
    modifier = Modifier.fillMaxWidth(),
    shape = MaterialTheme.shapes.large
) {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.Center
    ) {
        Icon(
            painter = painterResource(id = R.drawable.send_icon),
            contentDescription = "Send"
        )
        Spacer(modifier = Modifier.padding(horizontal = 4.dp))
        Text("Kirim Pesan", style = MaterialTheme.typography.labelLarge)
    }
}
```

*Gambar 12. Modifikasi Tombol Submit*

### 12. Panggil `StatelessFormHubungiKami()` di `HubungiKamiScreen()`

Lakukan pemanggilan function `StatelessFormHubungiKami()` pada function `HubungiKamiScreen()`:

```kotlin
) { paddingValues ->
    StatelessFormHubungiKami(
        modifier = Modifier.padding(paddingValues),
        email = emailText,
        onEmailChange = { emailText = it },
        isEmailValid = isEmailValid,
        message = messageText,
        onMessageChange = { messageText = it },
        isMessageValid = isMessageValid,
        problemType = problemType,
        onProblemTypeChange = { problemType = it },
        isAgreed = isAgreed,
        onAgreedChange = { isAgreed = it },
        imageUri = imageUri,
        onImagePicked = { imageUri = it },
        isFormValid = isFormValid,
        onSubmit = {
            scope.launch {
                snackbarHostState.showSnackbar(message = "Pesan Terkirim!")
            }
        }
    )
}
```

*Gambar 13. Pemanggilan Function StatelessFormHubungiKami*

**Penjelasan kode:**

Proses tersebut merupakan implementasi/penerapan dari konsep ***State Hoisting*** dan ***Unidirectional Data Flow (UDF)*** pada Jetpack Compose, yaitu komponen *parent* mengendalikan atas seluruh status data (seperti `emailText`, `messageText`, dan `isAgreed`) lalu meneruskannya ke bawah (*downward*) ke dalam parameter `StatelessFormHubungiKami`, sekaligus menyalurkan hasil validasi (`isEmailValid`, `isFormValid`) agar tampilan layar selalu sinkron dengan kondisi data terkini.

Ketika pengguna berinteraksi dengan tampilan tersebut, misalnya mengetik email atau memilih gambar, fungsi *callback* seperti `onEmailChange = { emailText = it }` dan `onImagePicked = { imageUri = it }` akan dipicu untuk memperbarui variabel penampung status lokal, yang secara otomatis memicu proses *recomposition*. Bagian akhir pada parameter `onSubmit` mengaitkan konsep **Kotlin Coroutines** melalui fungsi pembangun `scope.launch`; blok asinkron tersebut memastikan operasi penundaan (*suspending function*) seperti pemanggilan `snackbarHostState.showSnackbar` dapat berjalan di latar belakang tanpa memblokir alur utama antarmuka pengguna (*main UI thread*).

Lakukan pratinjau (*preview*) sehingga hasilnya seperti gambar di bawah ini:

*[Gambar 14. Hasil Implementasi Form Hubungi Kami — tampilan dark mode: Email Anda, Tipe Pesan "Keluhan", kolom Pesan berwarna merah dengan teks error "Pesan minimal 10 karakter", tombol "Unggah Bukti (Screenshot / Foto)", checkbox "Saya menyetujui syarat & ketentuan", dan tombol "Kirim Pesan" dalam keadaan nonaktif.]*

---

## C. Modifikasi kode pada `DaftarProductScreen.kt`

Pada halaman daftar produk, kita akan menambahkan fitur *Search Bar* (kolom pencarian) yang diintegrasikan dengan filter kategori, serta melakukan simulasi proses asinkronus seolah-olah aplikasi sedang mengambil data dari internet. Pada bagian ini, penjelasan akan lebih sedikit dibandingkan dengan bagian sebelumnya, dikarenakan pola dan konsep kode yang memiliki kesamaan. Silakan ikuti langkah – langkah berikut.

### 1. Tambahkan parameter pada function `DaftarProdukScreen`

```kotlin
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DaftarProdukScreen(navController: androidx.navigation.NavController? = null) {
```

*Gambar 15. Penambahan Parameter pada function DaftarProdukScreen*

**`NavController`** adalah objek pengendali utama dalam pustaka Jetpack Navigation di Android. Ibarat nahkoda sebuah kapal, `NavController` bertanggung jawab atas seluruh pergerakan antarlayar di dalam aplikasi. Objek ini bertugas:

- **Mengatur perpindahan layar:** mengeksekusi perintah navigasi halaman.
- **Mengelola tumpukan riwayat halaman (*back stack*):** mencatat urutan layar yang pernah dibuka sehingga saat pengguna menekan tombol kembali (*back button*), aplikasi akan harus kembali ke layar yang mana.
- **Mengirim dan membaca argument/data:** membawa data saat berpindah dari satu layar ke layar lainnya.

### 2. Deklarasi Variabel

Lakukan modifikasi variabel pada function `DaftarProdukScreen` sehingga diperoleh hasil akhir sebagai berikut:

```kotlin
fun DaftarProdukScreen(/* navController */) {
    val context = LocalContext.current
    var selectedCategoryId by rememberSaveable { mutableStateOf(DummyData.categories.firstOrNull()?.id) }
    var searchQuery by rememberSaveable { mutableStateOf("") }
    var isLoading by remember { mutableStateOf(false) }
    var filteredProducts by remember { mutableStateOf(emptyList<Product>()) }

    LaunchedEffect(selectedCategoryId, searchQuery) {
        isLoading = true

        delay(1000)

        val filteredByCategory = if (selectedCategoryId != null) {
            DummyData.products.filter { it.category_id == selectedCategoryId }
        } else DummyData.products

        filteredProducts = if (searchQuery.isBlank()) {
            filteredByCategory
        } else {
            filteredByCategory.filter { it.name.contains(searchQuery, ignoreCase = true) }
        }

        isLoading = false
    }
```

*Gambar 16. Implementasi LaunchedEffect untuk proses asinkron*

Konsep **asinkron (*asynchronous*)** dalam pemrograman aplikasi adalah metode eksekusi di mana suatu tugas yang membutuhkan waktu, misalnya: mengunduh data, membaca penyimpanan, atau menunggu waktu karena terdapat proses di latar belakang tanpa menghentikan alur kerja utama program.

Pada sistem operasi Android, alur utama (*main thread*) memiliki tanggung jawab krusial untuk menggambar visual antarmuka dan merespons interaksi sentuhan pengguna, jika tugas berat dijalankan secara sinkron (menunggu hingga selesai), layar ponsel berpotensi membeku (*freeze*). Melalui pendekatan asinkron, aplikasi tetap dapat bergerak mulus dan interaktif selagi proses yang memakan waktu tersebut berjalan mandiri di belakang layar.

`LaunchedEffect` berfungsi pengendali proses asinkron di dalam komponen Jetpack Compose. Sedangkan perintah `delay(1000)` adalah sebuah fungsi penunda waktu asinkron (*suspending function*) milik Kotlin Coroutines yang menangguhkan eksekusi kode selama 1.000 milidetik (satu detik). Sehingga fungsi secara keseluruhan kode tersebut adalah selama durasi satu detik, alur kerja di dalam `LaunchedEffect` berhenti sejenak untuk memberi waktu animasi *loading* berputar atau menunggu pengguna selesai mengetik tanpa menggunakan seluruh sumber daya komputasi dan tanpa membuat antarmuka ponsel mengalami *freeze*.

### 3. Membuat Function `StatelessDaftarProduct()`

```kotlin
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun StatelessDaftarProduct(
    categories: List<Category>,
    selectedCategoryId: Int?,
    onCategorySelected: (Int) -> Unit,
    searchQuery: String,
    onSearchQueryChange: (String) -> Unit,
    isLoading: Boolean,
    products: List<Product>,
    onProductClick: (Product) -> Unit
) {

}
```

*Gambar 17. Membuat Function StatelessDaftarProduct()*

### 4. Pindahkan `Scaffold` ke `StatelessDaftarProduct()`

Pindahkan `Scaffold` beserta seluruh *child*-nya dari function `DaftarProdukScreen` ke `StatelessDaftarProduct()`.

```kotlin
Scaffold(...) { paddingValues ->
    Column(...) {

        OutlinedTextField(...)

        Text(...)

        LazyRow(...) {
            items(categories) {...}
        }

        Spacer(modifier = Modifier.height(16.dp))
        Text(...)
        // ... (LazyVerticalGrid dst. ikut dipindahkan)
```

*Gambar 18. Memindahkan Scaffold dan seluruh child-nya*

### 5. Tambahkan `OutlinedTextField` pencarian

Tambahkan komponen `OutlinedTextField` di atas Text "Kategori Produk" seperti pada gambar berikut:

```kotlin
Column(
    modifier = Modifier
        .fillMaxSize()
        .padding(paddingValues)
) {

    OutlinedTextField(
        value = searchQuery,
        onValueChange = onSearchQueryChange,
        label = { Text("Cari produk...") },
        modifier = Modifier.fillMaxWidth().padding(horizontal = 16.dp, vertical = 8.dp),
        singleLine = true
    )


    Text(
        text = "Kategori Produk",
        style = MaterialTheme.typography.titleLarge,
        modifier = Modifier.padding(all = 16.dp)
    )
```

*Gambar 19. Implementasi OutlinedTextField*

### 6. Ganti parameter `items` pada `LazyRow`

```kotlin
LazyRow(
    contentPadding = PaddingValues(horizontal = 16.dp),
    horizontalArrangement = Arrangement.spacedBy(8.dp)
) {
    items(DummyData.categories) { category ->
        CategoryItem(
            category = category,
            isSelected = category.id == selectedCategoryId,
            onClick = { onCategorySelected(category.id) }
        )
    }
}
```

*Gambar 20. Penggantian Parameter*

### 7. Blok pengkondisian tampilan item

Di bawah text "Daftar Produk" tambahkan kode seperti gambar di bawah ini:

```kotlin
if (isLoading) {
    Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
        Column(horizontalAlignment = Alignment.CenterHorizontally) {
            CircularProgressIndicator()
            Spacer(modifier = Modifier.height(8.dp))
            Text("Mencari data...")
        }
    }
} else {
    if (products.isEmpty()) {
        Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
            Text("Produk tidak ditemukan.")
        }
    } else {

    }
}
```

*Gambar 21. Implementasi blok pengkondisian tampilan item*

### 8. Pindahkan `LazyVerticalGrid` ke blok `else`

```kotlin
} else {
    LazyVerticalGrid(
        columns = GridCells.Fixed(2),
        contentPadding = PaddingValues(16.dp),
        horizontalArrangement = Arrangement.spacedBy(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp),
        modifier = Modifier.fillMaxSize()
    ) {

        items(filteredProducts) { product ->
            ProductItemCard(product = product) {
                Toast.makeText(
                    context,
                    "Clicked: ${product.name}",
                    Toast.LENGTH_SHORT
                ).show()
            }
        }
    }
}
```

*Gambar 22. Memindahkan Komponen LazyVerticalGrid*

### 9. Ganti `Toast` serta parameter `items`

```kotlin
items(products) { product ->
    ProductItemCard(product = product) {
        onProductClick(product)
    }
}
```

*Gambar 23. Penyesuaian Kode pada blok Items*

### 10. Panggil function dari `DaftarProdukScreen()`

```kotlin
StatelessDaftarProduct(
    categories = DummyData.categories,
    selectedCategoryId = selectedCategoryId,
    onCategorySelected = { selectedCategoryId = it },
    searchQuery = searchQuery,
    onSearchQueryChange = { searchQuery = it },
    isLoading = isLoading,
    products = filteredProducts,
    onProductClick = { product ->
        navController?.navigate("detail/${product.id}")
    },
    onContactUsClick = {
        navController?.navigate("hubungi_kami")
    }
)
```

*Gambar 24. Pemanggilan Function DaftarProdukScreen()*

> **Catatan:** Pada Gambar 24, parameter `onContactUsClick` sudah tampil, padahal baru ditambahkan pada bagian **F** (Gambar 36–37). Abaikan/tambahkan parameter tersebut nanti pada tahap F.

### 11. Cek di preview

Cek di preview, dan jalankan masing-masing fiturnya, sehingga diperoleh hasil sebagai berikut:

*[Gambar 25. Hasil Tampilan Modifikasi Daftar Produk — tampilan dark mode: app bar "Daftar Produk UMKM" dengan ikon keranjang, kolom "Cari produk...", kategori (Makanan terpilih, Minuman, Kerajinan), dan grid produk (Kripik Singkong, Mendoan, Sale Pisang, Getuk Goreng).]*

---

## D. Membuat Tampilan Detail Produk

### 1. File `DetailProductScreen.kt`

Buatlah Kotlin file baru dengan nama `DetailProductScreen.kt` kemudian deklarasikan function dan variabel seperti gambar di bawah ini:

```kotlin
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DetailProductScreen(productId: Int, navController: NavController?) {
    val context = LocalContext.current
    var isLoading by remember { mutableStateOf(true) }
    var product by remember { mutableStateOf<Product?>(null) }
    var quantity by rememberSaveable { mutableStateOf(1) }

    LaunchedEffect(productId) {
        isLoading = true
        delay(1000) // Simulasi loading server lambat
        product = DummyData.products.find { it.id == productId }
        isLoading = false
    }
}
```

*Gambar 26. Deklarasi Function DetailProductScreen dan Variabel*

### 2. Function `StatelessDetailProduct`

Buat function baru bernama `StatelessDetailProduct` dengan detail parameter seperti pada gambar berikut:

```kotlin
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun StatelessDetailProduct(
    product: Product?, isLoading: Boolean, quantity: Int,
    onQuantityChange: (Int) -> Unit, onBackClick: () -> Unit, onAddToCartClick: () -> Unit
) {
}
```

*Gambar 27. Deklarasi Function StatelessDetailProduct*

### 3. `Scaffold` dengan logika IF

Di dalam function `StatelessDetailProduct`, tambahkan `Scaffold` yang berisi logika IF.

```kotlin
Scaffold(
    topBar = {
        TopAppBar(
            title = { Text("Detail Produk") },
            navigationIcon = {
                IconButton(onClick = onBackClick) {
                    Icon(painterResource(id = R.drawable.back_icon), contentDescription = "Back")
                }
            }
        )
    }
) { paddingValues ->
    if (isLoading) {
        Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
            CircularProgressIndicator()
        }
    } else if (product != null) {

    }
}
```

*Gambar 28. Implementasi Scaffold dan Logika IF*

### 4. Kolom dan komponen `Image` pada blok `else-if`

Di blok `else-if` tambahkan kolom serta deklarasi komponen `Image` seperti gambar berikut:

```kotlin
} else if (product != null) {
    Column(modifier = Modifier.fillMaxSize().padding(paddingValues).verticalScroll(state = rememberScrollState())) {
        val imageRes = if (product.img == "dummy_product") R.drawable.dummy_product else R.drawable.dummy_product
        Image(painterResource(id = imageRes), contentDescription = null, modifier = Modifier.fillMaxWidth().height(280.dp))
    }
}
```

*Gambar 29. Implementasi Kode pada Blok Else-IF*

### 5. Kolom tambahan dan komponen `Text`

Masih di dalam `Column`, tambahkan lagi komponen *column* seperti gambar berikut dan isikan beberapa komponen text:

```kotlin
else if (product != null) {
    Column(modifier = Modifier.fillMaxSize().padding(paddingValues).verticalScroll(state = rememberScrollState())) {
        val imageRes = if (product.img == "dummy_product") R.drawable.dummy_product else R.drawable.dummy_product
        Image(painterResource(id = imageRes), contentDescription = null, modifier = Modifier.fillMaxWidth().height(280.dp))
        Column(modifier = Modifier.padding(all = 16.dp)) {
            Text(product.name, style = MaterialTheme.typography.headlineSmall, fontWeight = FontWeight.Bold)
            Text("Rp ${product.price}", style = MaterialTheme.typography.titleLarge)
            Spacer(modifier = Modifier.height(16.dp))
            Text("Deskripsi", fontWeight = FontWeight.Bold)
            Text(product.description ?: "")
            Text("Stok: ${product.stock}")
        }
    }
}
```

*Gambar 30. Implementasi Kode pada Blok Else-If*

### 6. Komponen jumlah beli dan tombol keranjang

Di bawah komponen text tambahkan lagi komponen berikut:

```kotlin
    Spacer(modifier = Modifier.height(24.dp))
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text("Jumlah Beli")
        Row(verticalAlignment = Alignment.CenterVertically) {
            FilledTonalIconButton(
                onClick = { if (quantity > 1) onQuantityChange(quantity - 1) },
                enabled = quantity > 1
            ) { Text("-") }

            Text(quantity.toString(), modifier = Modifier.padding(horizontal = 16.dp))

            FilledTonalIconButton(
                onClick = { if (quantity < product.stock) onQuantityChange(quantity + 1) },
                enabled = quantity < product.stock
            ) { Text("+") }
        }
    }
    Spacer(modifier = Modifier.height(16.dp))
    Button(
        onClick = onAddToCartClick,
        modifier = Modifier.fillMaxWidth().height(50.dp),
        enabled = product.stock > 0 && quantity > 0
    ) {
        Text("Tambah ke Keranjang")
    }
}
```

*Gambar 31. Lanjutan Implementasi Kode pada Blok Else-If*

### 7. Panggil `StatelessDetailProduct` di `DetailProductScreen`

Di dalam function `DetailProductScreen`, panggil function `StatelessDetailProduct`:

```kotlin
fun DetailProductScreen(productId: Int, navController: NavController?) {
    val context = LocalContext.current
    var isLoading by remember { mutableStateOf(true) }
    var product by remember { mutableStateOf<Product?>(null) }
    var quantity by rememberSaveable { mutableStateOf(1) }

    LaunchedEffect(productId) {
        isLoading = true
        delay(1000) // Simulasi loading server lambat
        product = DummyData.products.find { it.id == productId }
        isLoading = false
    }

    StatelessDetailProduct(
        product = product,
        isLoading = isLoading,
        quantity = quantity,
        onQuantityChange = { quantity = it },
        onBackClick = { navController?.popBackStack() },
        onAddToCartClick = { Toast.makeText(context, "Dimasukkan: $quantity", Toast.LENGTH_SHORT).show() }
    )
}
```

*Gambar 32. Pemanggilan Function*

### 8. Jalankan preview

Jalankan previewnya dan diperoleh hasil sebagai berikut:

*[Gambar 33. Hasil Preview Detail Produk — app bar "Detail Produk" dengan tombol kembali, gambar placeholder, nama "Kripik Singkong", "Rp 15000.0", Deskripsi "Kripik gurih", "Stok: 50", "Jumlah Beli" dengan tombol -/+ (nilai 5), dan tombol "Tambah ke Keranjang".]*

---

## E. Navigasi di HomeActivity untuk daftar produk ke detail produk

Pada bagian ini, kita akan mempraktikkan untuk proses navigasi antar halaman.

### 1. Buka `HomeActivity.kt` dan tuliskan kode berikut

```kotlin
class HomeActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            JualanTheme {
                val navController = rememberNavController()
                NavHost(navController = navController, startDestination = "daftar_produk") {
                    composable(route = "daftar_produk") {
                        DaftarProdukScreen(navController = navController)
                    }
                    composable(
                        route = "detail/{productId}",
                        arguments = listOf(navArgument(name = "productId") {
                            type = NavType.IntType
                        })
                    ) { backStackEntry ->
                        val productId = backStackEntry.arguments?.getInt(key = "productId") ?: 0
                        DetailProductScreen(
                            productId = productId,
                            navController = navController
                        )
                    }
                }
            }
        }
    }
}
```

*Gambar 34. Modifikasi Kode pada HomeActivity*

> **Catatan:** Teks modul menyebut tiga rute (termasuk `HubungiKamiScreen`), tetapi Gambar 34 hanya menampilkan dua `composable` (`daftar_produk` dan `detail/{productId}`). Karena `onContactUsClick` melakukan `navigate("hubungi_kami")`, pastikan rute `"hubungi_kami"` yang memanggil `HubungiKamiScreen(navController)` juga terdaftar di `NavHost` (kemungkinan sudah ada dari pertemuan sebelumnya).

Potongan kode ini berfungsi sebagai **peta rute navigasi** untuk mengatur perpindahan antarlayar di dalam aplikasi Android menggunakan Jetpack Compose. Baris pertama menyiapkan variabel `navController` melalui fungsi `rememberNavController()` sebagai pengendali utama yang bertugas mengarahkan pengguna berpindah layar dan mencatat riwayat halaman yang telah dibuka. Komponen `NavHost` kemudian bertindak sebagai wadah atau terminal utamanya, dengan mendeklarasikan `startDestination = "daftar_produk"`, yang berarti layar pertama yang langsung muncul saat aplikasi dibuka adalah halaman daftar produk.

Di dalam `NavHost`, didefinisikan tiga tujuan rute menggunakan fungsi `composable`. Rute pertama menampilkan halaman utama `DaftarProdukScreen`, sedangkan rute ketiga menampilkan halaman `HubungiKamiScreen`. Berbeda pada rute kedua, yaitu `"detail/{productId}"`, yang dirancang khusus untuk menerima kiriman data angka berupa ID produk (`NavType.IntType`). Ketika pengguna memilih produk tertentu, sistem membaca ID tersebut lewat `backStackEntry`, mengambil angkanya (atau memberi nilai bawaan 0 jika kosong), lalu meneruskannya ke layar `DetailProductScreen` agar halaman detail dapat menampilkan data produk yang sesuai secara dinamis.

---

## F. Menambahkan Menu Action di AppBar untuk navigasi ke Hubungi Kami

Silakan buka kembali file: `DaftarProdukScreen.kt`. Pada bagian ini kita akan mempraktikkan untuk menambahkan MenuAction seperti pada gambar di bawah ini:

*[Gambar 35. Menampilkan Menu Action — app bar "Daftar Produk UMKM" dengan ikon keranjang dan ikon titik tiga; menu dropdown berisi item "Hubungi Kami" dengan ikon email.]*

### 1. Tambahkan parameter `onContactUsClick()`

Tambahkan 1 parameter yang bernama `onContactUsClick()`:

```kotlin
fun StatelessDaftarProduct(
    categories: List<Category>,
    selectedCategoryId: Int?,
    onCategorySelected: (Int) -> Unit,
    searchQuery: String,
    onSearchQueryChange: (String) -> Unit,
    isLoading: Boolean,
    products: List<Product>,
    onProductClick: (Product) -> Unit,
    onContactUsClick: () -> Unit
) {
```

*Gambar 36. Penambahan Parameter onContactUsClick()*

### 2. Tambahkan parameter pada pemanggilan function

```kotlin
StatelessDaftarProduct(
    categories = DummyData.categories,
    selectedCategoryId = selectedCategoryId,
    onCategorySelected = { selectedCategoryId = it },
    searchQuery = searchQuery,
    onSearchQueryChange = { searchQuery = it },
    isLoading = isLoading,
    products = filteredProducts,
    onProductClick = { product ->
        navController?.navigate("detail/${product.id}")
    },
    onContactUsClick = {
        navController?.navigate("hubungi_kami")
    }
)
```

*Gambar 37. Penambahan Parameter onContactUsClick()*

### 3. Tambahkan `IconButton` dan dropdown

Tambahkan kode `IconButton` di bawah kode ikon keranjang serta tambahkan pula dropdown seperti pada gambar berikut:

```kotlin
var expanded by remember { mutableStateOf(false) }

IconButton(onClick = { expanded = true }) {
    Icon(
        imageVector = Icons.Default.MoreVert,
        contentDescription = "Menu",
        tint = MaterialTheme.colorScheme.onPrimary
    )
}

DropdownMenu(
    expanded = expanded,
    onDismissRequest = { expanded = false }
) {
    DropdownMenuItem(
        text = { Text("Hubungi Kami") },
        onClick = {
            expanded = false
            onContactUsClick()
        },
        leadingIcon = {
            Icon(
                imageVector = Icons.Default.Email,
                contentDescription = "Email"
            )
        }
    )
}
```

*Gambar 38. Penambahan IconButton*

---

**JALANKAN APLIKASI TERSEBUT DI *EMULATOR*/PERANGKAT ANDA**
