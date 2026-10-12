---
marp: true
theme: polinema
paginate: true
size: 16:9
---

<!-- _class: cover -->
<!-- _paginate: false -->

<img class="logo" src="../images/logo.png">

<div class="box skema">Penelitian Reguler Kompetisi</div>

<div class="box judul">Desain dan Implementasi TathyaTest: Test Case Generator Otomatis untuk Pengujian Fungsional Aplikasi Web</div>

<div class="box tim">
<strong>TIM PENELITI</strong><br>
Ketua: Dian Hanifudin Subhi, S.Kom., M.Kom.<br>
Anggota:<br>
1. Dika Rizky Yunianto, S.Kom., M.Kom.<br>
2. Ridwan Rismanto, S.ST., M.Kom., Ph.D.<br>
3. Usman Nurhasan, S.Kom., M.Kom.
</div>

---

<!-- _class: dense -->

# Rumusan Masalah & Tujuan

<div class="cols">
<div>

**Masalahnya**
- Aplikasi kampus (mis. Kompen, Jayanti, Whistleblower) dipakai setiap hari oleh mahasiswa, dosen, dan staf.
- Server yang "hidup" ibarat toko yang pintunya terbuka: belum tentu kasir, stok, dan penjaganya bekerja benar.
- Menguji semua fungsi secara manual lambat. Alat uji otomatis pun masih butuh **skenario uji** yang ditulis manusia.

</div>
<div>

**Rumusan masalah**
1. Seberapa lengkap pengujian yang dihasilkan TathyaTest?
2. Mampukah menemukan kesalahan yang sengaja disisipkan?
3. Seberapa andal dan hemat waktu dibanding menulis manual?

**Tujuan:** mengukur kelengkapan, kemampuan menemukan kesalahan, serta keandalan dan efisiensinya.

</div>
</div>

<div class="gloss"><b>Istilah:</b> <b>skenario uji</b> = satu butir daftar periksa, mis. "login dengan password salah, sistem harus menolak" · <b>RBAC</b> = hak akses berbeda tiap peran (admin, pengguna) · <b>CRUD</b> = tambah, lihat, ubah, hapus data</div>

<!--
Mulai dari masalah sehari-hari: aplikasi kampus dipakai terus, tetapi "server menyala" tidak sama dengan "aplikasi berfungsi benar". Pengujian manual butuh waktu, dan alat otomatis pun masih membutuhkan manusia menulis skenario ujinya. Tiga pertanyaan penelitian: seberapa lengkap, mampukah menemukan kesalahan, dan seberapa hemat waktu.
-->

---

<!-- _class: dense -->

# Metode Penelitian

<div class="center">
<img src="assets/pipeline-overview.png" style="width: 40%;">
</div>

<div class="flow">
<div><b>1. Masuk</b><br>robot login sebagai tiap peran pengguna</div>
<div><b>2. Menjelajah</b><br>membuka semua halaman (<i>crawling</i>), mencatat tombol, formulir, dan menu</div>
<div><b>3. Menyusun</b><br>skenario uji dibuat otomatis dari catatan itu</div>
<div><b>4. Menjalankan</b><br>diuji di tiga browser (Chrome, Firefox, WebKit)</div>
</div>

<div class="note">

**Dibangun bertahap (*Prototyping*)** dan dievaluasi pada **dua aplikasi studi kasus internal** (Laravel Blade dan Laravel Inertia-React) serta **SauceDemo**, toko online contoh sebagai pembanding.

</div>

<div class="gloss"><b>Istilah:</b> <b>DOM</b> = struktur halaman yang tampil di browser · <b>crawling</b> = menelusuri halaman satu per satu seperti pengunjung</div>

<!--
Cara kerja TathyaTest dalam empat langkah: robot masuk sebagai tiap jenis pengguna, menjelajahi halaman dan mencatat apa yang ada, menyusun skenario uji dari catatan itu, lalu menjalankannya di tiga browser. Alat dikembangkan bertahap lewat prototipe. Evaluasi hanya memakai dua aplikasi studi kasus internal dan SauceDemo; aplikasi Kompen, Jayanti, dan Whistleblower belum diuji dan menjadi tahap lanjutan.
-->

---

<!-- _class: dense -->

# Hasil Penelitian

<div class="grid4">
<div class="box">

**Seberapa lengkap?**
Skenario uji dibuat otomatis: **104** (Blade), **106** (Inertia-React), **31** (SauceDemo). Elemen halaman dikenali **95,5%** dan **100,0%**. Hasil sama di tiga browser (κ = **1,00**, sepakat sempurna).

</div>
<div class="box">

**Bisakah menemukan kesalahan?**
**14 kesalahan** sengaja disisipkan oleh tim (mis. tombol hapus dibuat tidak menghapus), lalu dihitung berapa yang tertangkap:

<div class="mini"><span>Blade</span><i style="width:100%"></i><b>100,0%</b></div>
<div class="mini"><span>Inertia-React</span><i style="width:85.7%"></i><b>85,7%</b></div>

</div>
<div class="box">

**Seberapa cepat?**
Perkiraan **30,0–32,7 kali lebih cepat** daripada menulis skenario uji secara manual, dengan asumsi 5 menit untuk menulis satu skenario uji.

</div>
<div class="box">

**Ada temuan nyata?**
Ya, **dua kesalahan nyata** pada aplikasi uji: tombol "halaman berikutnya" salah terbaca, dan satu alamat halaman menampilkan error server (500).

</div>
</div>

<!--
Empat pertanyaan, empat jawaban. Lengkap: ratusan skenario uji dibuat otomatis dan hampir seluruh elemen halaman dikenali. Kemampuan menemukan kesalahan diukur dengan menyisipkan 14 kesalahan yang dibuat tim: TathyaTest menangkap semuanya di aplikasi Blade dan 85,7% di Inertia-React; dua yang lolos dijelaskan di laporan. Kecepatan adalah perkiraan, dihitung dari asumsi 5 menit untuk menulis satu skenario uji secara manual. Dua kesalahan nyata juga ditemukan.
-->

---

<!-- _class: dense -->

# Luaran

<div class="cols">
<div class="box">

**Luaran wajib**
1. Artikel jurnal ilmiah **JUTI** (telah disubmit 13 Oktober 2026)
2. **Prototipe** TathyaTest tingkat kesiapan **TKT 4**

</div>
<div class="box">

**Luaran tambahan**
1. **Hak Cipta** prototipe TathyaTest (dalam proses pendaftaran)
2. **Buku panduan** penggunaan (manual book)

</div>
</div>

**Langkah berikutnya:** menerapkan TathyaTest pada aplikasi internal jurusan (Kompen, Jayanti, Whistleblower).

<div class="gloss"><b>Istilah:</b> <b>TKT</b> = Tingkat Kesiapterapan Teknologi, skala 1–9; <b>TKT 4</b> = komponen teknologi sudah teruji di laboratorium</div>

<!--
Luaran wajib: artikel untuk jurnal JUTI yang telah disubmit, dan prototipe pada tingkat kesiapan teknologi 4, artinya komponennya sudah teruji di laboratorium. Luaran tambahan: Hak Cipta yang sedang didaftarkan dan buku panduan penggunaan. Langkah berikutnya adalah mencoba pada aplikasi internal jurusan.
-->

---

<!-- _class: thanks -->

# Terima Kasih

<div class="big">TERIMA KASIH</div>

<br>

github.com/dhanifudin/tathyatest
