#import "../template.typ": todo

= SIMPULAN DAN SARAN <bab-v-simpulan-dan-saran>

== Simpulan <simpulan>

Berdasarkan hasil penelitian dan pembahasan pada BAB IV, dapat disimpulkan sebagai berikut, mengacu pada rumusan masalah di @rumusan-masalah:

+ TathyaTest mampu mencakup permukaan fungsional aplikasi berbasis web secara luas, dengan cakupan model elemen mencapai 95,5% (elemen) hingga 100,0% (rute, form, field, matriks RBAC) pada ketiga aplikasi studi kasus, melampaui target cakupan minimal 80% yang ditetapkan pada BAB III; pada tingkat kode sumber aplikasi (SUT), cakupan rute tercatat 100,0% (8/8) pada kedua aplikasi Laravel.
+ Di luar kedua rumusan masalah utama, pelaksanaan pengujian turut menyingkap dua cacat nyata pada aplikasi studi kasus -- escaping label pada komponen paginator bawaan Laravel dan rute `show` yang tidak memiliki aksi controller -- yang menjadi bukti konkret bahwa test case yang dihasilkan TathyaTest mampu menemukan masalah fungsional yang sungguh-sungguh ada, bukan sekadar lulus terhadap skenario yang telah diketahui sebelumnya.
+ Test suite yang dihasilkan TathyaTest menunjukkan kualitas intrinsik dan keandalan yang baik dibandingkan baseline, dengan densitas asersi yang lebih tinggi dan rasio locator rapuh yang jauh lebih rendah dibandingkan test suite publik pembanding pada SauceDemo (0,0% berbanding 62,5%), kesepakatan hasil pengujian lintas-browser (Fleiss' kappa) κ = 1,00 pada Blade dan SauceDemo, serta estimasi penghematan waktu 23,9--42,6 kali dibandingkan penulisan test case secara manual (Mann-Whitney U, p < 0,001).

Secara keseluruhan, penelitian ini berhasil mencapai TKT 4 (validasi komponen dalam lingkungan laboratorium) dan memberikan bukti awal yang kuat bahwa pendekatan crawling DOM ter-render dan pemetaan elemen-ke-test-case dapat menghasilkan test suite fungsional yang efektif, efisien, dan lebih tahan terhadap perubahan antarmuka dibandingkan sebagian test suite tulisan manual.

== Saran <saran>

Berdasarkan temuan dan keterbatasan penelitian ini, beberapa saran untuk pengembangan selanjutnya adalah:

+ Perluasan evaluasi pada aplikasi internal Jurusan Teknologi Informasi (Kompen, Jayanti, Whistleblower) yang menjadi motivasi awal penelitian ini, untuk memvalidasi TathyaTest pada lingkungan operasional yang sesungguhnya dan bukan hanya aplikasi studi kasus.
+ Pengukuran kemampuan deteksi cacat secara sistematis melalui injeksi cacat (mutation testing) yang representatif, mengingat evaluasi pada penelitian ini belum mencakup pengukuran deteksi cacat secara sistematis, serta instrumentasi cakupan cabang (branch coverage) penuh sebagai pengganti proksi cabang yang digunakan pada evaluasi ini.
+ Penelitian lanjutan dapat mengarah pada pengujian non-fungsional (performance, security, load testing) sesuai roadmap 2027, sebagaimana dijelaskan pada @roadmap-penelitian.
+ Integrasi kecerdasan buatan (AI) untuk test case prioritization dan risk analysis dapat dieksplorasi pada tahap pengembangan 2028--2029 untuk meningkatkan efisiensi pengujian pada skala yang lebih besar.
