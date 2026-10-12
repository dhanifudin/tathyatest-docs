#import "../template.typ": todo

= SIMPULAN DAN SARAN <bab-v-simpulan-dan-saran>

== Simpulan <simpulan>

Berdasarkan hasil penelitian dan pembahasan pada BAB IV, dapat disimpulkan sebagai berikut, mengacu pada rumusan masalah di @rumusan-masalah:

+ TathyaTest mampu mencakup permukaan fungsional aplikasi berbasis web secara luas, dengan cakupan model elemen mencapai 95,5% pada Blade dan 100,0% pada Inertia-React, serta cakupan rute, form, field, dan matriks RBAC mencapai 100,0% pada ketiga aplikasi studi kasus, melampaui target cakupan minimal 80% yang ditetapkan pada BAB III; pada tingkat kode sumber aplikasi (SUT), cakupan rute tercatat 100,0% (8/8) pada Blade dan 87,5% (7/8) pada Inertia-React, selisih yang dijelaskan oleh rute logout berbasis skrip pada Inertia-React yang tidak terjangkau crawler.
+ TathyaTest memenuhi target tingkat akurasi deteksi cacat minimal 85% yang ditetapkan pada BAB III: dari katalog 14 cacat dapat-dideteksi yang disuntikkan secara terkendali, 100,0% (14/14) berhasil terdeteksi pada Blade dan 85,7% (12/14) pada Inertia-React, jauh melampaui baseline manual yang hanya mendeteksi 21,4% (3/14); seluruh 4 cacat kendali negatif pada katalog selamat tanpa terdeteksi pada kedua aplikasi, mengonfirmasi validitas katalog cacat terhadap risiko efek plafon dan bias. Dua cacat yang luput dari deteksi pada Inertia-React bersumber dari satu akar masalah yang sama: keterbatasan oracle berbasis DOM terhadap kontrol berbasis skrip pada aplikasi SPA.
+ Selain hasil pengujian sistematis di atas, pelaksanaan pengujian turut menyingkap dua cacat nyata pada aplikasi studi kasus -- escaping label pada komponen paginator bawaan Laravel dan rute `show` yang tidak memiliki aksi controller -- yang menjadi bukti konkret tambahan bahwa test case yang dihasilkan TathyaTest mampu menemukan masalah fungsional yang sungguh-sungguh ada, bukan sekadar lulus terhadap skenario atau katalog cacat yang telah diketahui sebelumnya.
+ Test suite yang dihasilkan TathyaTest menunjukkan kualitas intrinsik dan keandalan yang baik dibandingkan baseline, dengan densitas asersi yang lebih tinggi dan rasio locator rapuh yang jauh lebih rendah dibandingkan test suite publik pembanding pada SauceDemo (0,0% berbanding 62,5%), kesepakatan hasil pengujian lintas-browser (Fleiss' kappa) κ = 1,00 pada ketiga aplikasi, serta estimasi penghematan waktu 30,0--32,7 kali dibandingkan penulisan test case secara manual (Mann-Whitney U, p < 0,001).

Secara keseluruhan, penelitian ini berhasil mencapai TKT 4 (validasi komponen dalam lingkungan laboratorium) dan memberikan bukti awal yang kuat bahwa pendekatan crawling DOM ter-render dan pemetaan elemen-ke-test-case dapat menghasilkan test suite fungsional yang efektif, efisien, dan lebih tahan terhadap perubahan antarmuka dibandingkan sebagian test suite tulisan manual.

== Saran <saran>

Berdasarkan temuan dan keterbatasan penelitian ini, beberapa saran untuk pengembangan selanjutnya adalah:

+ Perluasan evaluasi pada aplikasi internal Jurusan Teknologi Informasi (Kompen, Jayanti, Whistleblower) yang menjadi motivasi awal penelitian ini, untuk memvalidasi TathyaTest pada lingkungan operasional yang sesungguhnya dan bukan hanya aplikasi studi kasus.
+ Penggunaan perangkat mutation testing otomatis untuk menghasilkan katalog cacat yang lebih representatif dan beragam dibandingkan katalog cacat buatan tim peneliti yang digunakan pada evaluasi ini; penguatan oracle TathyaTest agar mampu mengamati perubahan status pada kontrol berbasis skrip di aplikasi SPA, mengatasi keterbatasan yang teramati pada dua cacat yang luput terdeteksi di Inertia-React; serta instrumentasi cakupan cabang (branch coverage) penuh sebagai pengganti proksi cabang yang digunakan pada evaluasi ini.
+ Penelitian lanjutan dapat mengarah pada pengujian non-fungsional (performance, security, load testing) sesuai roadmap 2027, sebagaimana dijelaskan pada @roadmap-penelitian.
+ Integrasi kecerdasan buatan (AI) untuk test case prioritization dan risk analysis dapat dieksplorasi pada tahap pengembangan 2028--2029 untuk meningkatkan efisiensi pengujian pada skala yang lebih besar.
