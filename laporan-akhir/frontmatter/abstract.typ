#heading(level: 1, numbering: none, outlined: true)[ABSTRACT]

Testing of academic applications at the Department of Information Technology, Politeknik Negeri Malang, such as Kompen, Jayanti, and Whistleblower, still relies on server-uptime monitoring, which cannot guarantee that core functions -- login, role-based access control (RBAC), input validation, and CRUD operations -- work correctly. Automation testing tools such as Selenium, Cypress, and Playwright still require test cases to be written manually. TathyaTest addresses this by crawling the rendered DOM with Playwright, building an element model and a per-role access matrix, and then generating and executing functional test cases automatically. TathyaTest was developed with the Prototyping method and evaluated on three subjects: a Laravel Blade application, a Laravel Inertia-React application, and SauceDemo as an external baseline.

TathyaTest generated 104, 106, and 31 test cases for the three subjects. Element-model coverage reached 95.5% on Blade and 100.0% on Inertia-React, with identical results on Chrome, Firefox, and WebKit (Fleiss' kappa κ = 1.00). Of 14 injected faults, TathyaTest detected 100.0% on Blade and 85.7% on Inertia-React, far above the manual baseline (21.4%). Test case creation was 30.0--32.7× faster than manual authoring (p < 0.001), and testing also exposed two real defects in the case-study applications.

The outputs of this research are a TathyaTest prototype at TRL 4 and a manuscript for the Jurnal Teknologi Informasi dan Ilmu Komputer (JUTI), forming the foundation for an AI-based TathyaTest development roadmap.

#v(0.5cm)

*Keywords:* automation testing, test case generation, web crawling, role-based access control, functional testing, Playwright
