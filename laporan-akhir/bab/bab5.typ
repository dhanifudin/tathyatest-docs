#import "../template.typ": todo

= SIMPULAN DAN SARAN <bab-v-simpulan-dan-saran>

== Simpulan <simpulan>

Berdasarkan hasil penelitian dan pembahasan pada BAB IV, dapat disimpulkan sebagai berikut, mengacu pada rumusan masalah di @rumusan-masalah:

+ TathyaTest terbukti efektif dalam menghasilkan test case otomatis untuk pengujian aplikasi berbasis web, dengan menghasilkan 103 test case pada masing-masing aplikasi studi kasus Laravel (Blade dan Inertia-React) dan 31 test case pada SauceDemo, serta mencapai skor mutasi (deteksi cacat) 100,0% (9 dari 9 cacat terdeteksi) pada kedua aplikasi Laravel yang terinstrumentasi.
+ TathyaTest mampu meningkatkan cakupan pengujian fungsional aplikasi berbasis web secara signifikan, dengan cakupan model elemen (form, field, navigasi, dan matriks RBAC) mencapai 100,0% pada ketiga aplikasi studi kasus serta cakupan rute (route coverage) sebesar 87,5% pada kedua aplikasi Laravel, melampaui target cakupan minimal 80% yang ditetapkan pada BAB III.
+ TathyaTest mampu memvalidasi ekspektasi fungsional aplikasi berbasis web dengan baik, dibuktikan oleh akurasi lokalisasi cacat sebesar 100,0% serta kesepakatan hasil pengujian lintas-browser (Fleiss' kappa) sebesar κ = 1,00 pada kedua aplikasi Laravel -- menunjukkan bahwa validasi login, penyimpanan data, dan kontrol akses modul berbasis peran dapat dilakukan secara konsisten dan andal.

Secara keseluruhan, penelitian ini berhasil mencapai TKT 4 (validasi komponen dalam lingkungan laboratorium) dan memberikan bukti awal yang kuat bahwa pendekatan crawling DOM ter-render dan pemetaan elemen-ke-test-case dapat menghasilkan test suite fungsional yang efektif, efisien (estimasi penghematan waktu 29--31 kali dibandingkan penulisan manual), dan lebih tahan terhadap perubahan antarmuka dibandingkan sebagian test suite tulisan manual.

== Saran <saran>

Berdasarkan temuan dan keterbatasan penelitian ini, beberapa saran untuk pengembangan selanjutnya adalah:

+ Perluasan evaluasi pada aplikasi internal Jurusan Teknologi Informasi (Kompen, Jayanti, Whistleblower) yang menjadi motivasi awal penelitian ini, untuk memvalidasi TathyaTest pada lingkungan operasional yang sesungguhnya dan bukan hanya aplikasi studi kasus.
+ Penambahan katalog cacat (fault catalogue) yang lebih luas di luar sembilan cacat terkendali yang diujikan, serta instrumentasi cakupan cabang (branch coverage) penuh sebagai pengganti proksi cabang yang digunakan pada evaluasi ini.
+ Penelitian lanjutan dapat mengarah pada pengujian non-fungsional (performance, security, load testing) sesuai roadmap 2027, sebagaimana dijelaskan pada @roadmap-penelitian.
+ Integrasi kecerdasan buatan (AI) untuk test case prioritization dan risk analysis dapat dieksplorasi pada tahap pengembangan 2028--2029 untuk meningkatkan efisiensi pengujian pada skala yang lebih besar.
