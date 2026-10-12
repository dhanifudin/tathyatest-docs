#heading(level: 1, numbering: none, outlined: true)[ABSTRAK]

Pengujian aplikasi akademik di Jurusan Teknologi Informasi Politeknik Negeri Malang, seperti Kompen, Jayanti, dan Whistleblower, masih bergantung pada pemantauan ketersediaan server yang tidak menjamin fungsi inti -- login, kontrol akses berbasis peran (RBAC), validasi input, dan operasi CRUD -- berjalan benar. Alat automation testing seperti Selenium, Cypress, dan Playwright pun tetap menuntut penulisan test case secara manual. TathyaTest menjawab masalah ini dengan melakukan crawling DOM ter-render menggunakan Playwright, membangun model elemen dan matriks akses per peran, lalu menghasilkan dan mengeksekusi test case fungsional secara otomatis. TathyaTest dikembangkan dengan metode Prototyping dan dievaluasi pada tiga aplikasi: Laravel Blade, Laravel Inertia-React, dan SauceDemo sebagai pembanding eksternal.

TathyaTest menghasilkan 104, 106, dan 31 test case untuk ketiga aplikasi tersebut. Cakupan model elemen mencapai 95,5% pada Blade dan 100,0% pada Inertia-React, dengan hasil identik di Chrome, Firefox, dan WebKit (Fleiss' kappa κ = 1,00). Dari 14 cacat yang diinjeksi, TathyaTest mendeteksi 100,0% pada Blade dan 85,7% pada Inertia-React. Pembuatan test case diperkirakan 30,0--32,7 kali lebih cepat dibanding penulisan manual (dengan asumsi 5 menit per test case), dan pengujian turut menemukan dua cacat nyata pada aplikasi studi kasus.

Luaran penelitian ini berupa prototipe TathyaTest TKT 4 dan naskah artikel ilmiah untuk Jurnal Teknologi Informasi dan Ilmu Komputer (JUTI), yang menjadi pondasi roadmap pengembangan TathyaTest berbasis AI.

#v(0.5cm)

*Kata Kunci:* automation testing, test case generation, web crawling, role-based access control, functional testing, Playwright
