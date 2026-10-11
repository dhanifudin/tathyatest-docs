#import "@preview/juti:0.1.1"
#import "setup.typ": *
#import "eval-numbers.typ": *

/**
 * Contribution References
 * 0. Conceptualization
 * 1. Methodology
 * 2. Software
 * 3. Validation
 * 4. Formal analysis
 * 5. Investigation
 * 6. Resources
 * 7. Data Curation
 * 8. Writing -- Original Draft
 * 9. Writing -- Review & Editing
 * 10. Visualization
 * 11. Supervision
 * 12. Project Administration
 * 13. Funding Acquisition
 **/

// juti 0.1.1's running head (page-header, even pages) joins exactly-two-author `short`
// names via its internal inline-enum with no separator space before "and" -- e.g.
// "F. A. Nameand S. A. Name" -- because inline-enum's join-sym branch (which normally
// supplies that space) is skipped specifically when there are 2 entries. There is no
// public template option to fix this in 0.1.1. Workaround: pad the first author's
// `short` with a trailing space so the header concatenation reads correctly; this is
// undone (via .trim()) at the one other call site that reads `.short` (the CRediT
// statement below), so it doesn't leak a stray space before that colon. Re-check this
// workaround if the juti package version changes or the author count changes from 2.
#let pad-first-author-short-for-header(authors) = if authors.len() == 2 {
  (
    (..authors.at(0), short: authors.at(0).short + " "),
    authors.at(1),
  )
} else {
  authors
}

// Authors, roles, and task assignments come from the funded research proposal
// (docs/proposal.pdf, "Tim Peneliti" table, p. iii) -- contribution-refs below are this
// port's interpretation of each person's stated tasks, mapped onto the CRediT taxonomy
// above; the authors should adjust if that mapping doesn't match their own account.
// Emails and ORCID were not in the proposal (its own biodata appendix is all bracketed
// placeholders) or discoverable via SINTA/Scholar/ResearchGate/IEEE Xplore/the official
// JTI Polinema faculty directory -- confirmed directly by the corresponding author.
#let authors = pad-first-author-short-for-header(juti.init-authors((
  (
    // Ketua (lead): coordination, system design, crawler development, results
    // analysis, writing the publication.
    name: "Dian Hanifudin Subhi",
    institution-ref: 0,
    contribution-refs: (0, 1, 2, 4, 5, 8, 9, 11, 12),
    email: "dhanifudin@polinema.ac.id",
    orcid: "0009-0009-6219-7092",
  ),
  (
    // Anggota: HTML-extraction feature development, Playwright integration, system
    // testing.
    name: "Dika Rizki Yunianto",
    institution-ref: 0,
    contribution-refs: (2, 3),
    email: "dikarizkyyunianto@polinema.ac.id",
    orcid: "0009-0000-1226-1150",
  ),
  (
    // Anggota: test-case-generation algorithm development, results validation,
    // metric evaluation.
    name: "Ridwan Rismanto",
    institution-ref: 0,
    contribution-refs: (1, 2, 3, 4),
    email: "rismanto@polinema.ac.id",
    orcid: "0009-0007-5973-1552",
  ),
  (
    // Anggota: dataset preparation, system documentation, case-study application
    // testing.
    name: "Usman Nurhasan",
    institution-ref: 0,
    contribution-refs: (5, 7),
    email: "usmannurhasan@polinema.ac.id",
    orcid: "0009-0008-4842-7421",
  ),
)))

#let institutions = (
  (
    name: "Department of Information Technology, Politeknik Negeri Malang",
    address: "Malang, Indonesia",
  ),
)

#show: juti.template.with(
  title: "TathyaTest: a generator for functional, regression, and functional-availability testing of web applications",
  authors: authors,
  corresponding-ref: 0,
  corresponding-email: none, // falls back to authors.at(corresponding-ref).email, i.e. Dian's address above -- single source of truth
  institutions: institutions,
  abstract: [
    This study proposes TathyaTest, a pipeline that turns a running web application into executable Playwright tests without hand-written test scripts. It addresses two practical problems: uptime monitoring cannot show that login, role authorization, form validation, and data entry actually work, while hand-written end-to-end suites are costly to write and break when page structure changes. The prototype logs in as each user role, records the pages, forms, and constraints it finds as an auditable crawl contract, derives valid, invalid, and boundary test data from that record, and generates five categories of specifications (authentication, forms, interactions, pagination, and role-based access control). The evaluation uses five groups of measurements, namely coverage of what the crawler observed, coverage of the application's own server code, detection of seeded faults, suite quality, and reliability and efficiency, each reported with 95% confidence intervals and compared with hand-written suites through the Mann--Whitney $U$ test. On two instrumented Laravel applications (Blade and Inertia React) and one external site (SauceDemo), the suite reached full route, form, and field coverage of the observed model and #evBladeRouteExecCov of application routes at the code level, detected #evBladeDetectable of the seeded faults it is designed to detect while all #evBladeControls negative controls survived as expected, ran with a flake rate of no more than #evBladeFlake, and reached a time-savings ratio of #evBladeSavings on the Blade subject against an assumed manual cost. These results show that the pipeline is a viable foundation for regression testing and functional-availability checking of web applications.
  ],
  keywords: (
    "software testing",
    "web application",
    "test generation",
    "regression testing",
    "functional availability",
    "Playwright",
    "RBAC",
  ),
  bib: bibliography("../tathyatest-references.bib"),
  ..setup,
)

= Introduction

Modern web applications need availability checks that go beyond endpoint status, because users judge quality by whether login succeeds, pages are reachable, forms can be filled in, and data can be changed. Software quality standards treat functional suitability, reliability, usability, security, and maintainability as interrelated characteristics @iso25010, so uptime monitoring remains necessary but cannot show whether an application's functions are genuinely available. An application can return HTTP 200 while login fails after a session configuration change, a form submission fails after a validation change, a regular user reaches an admin page through an authorization bug, or a pagination control stops working after a DOM change. Testing standards therefore ask that functional tests examine external behavior through an observable oracle, the mechanism that decides whether a test passes or fails, rather than internal state or surface responses @iso29119. Functional availability is accordingly read here as the ability to execute the main user flows in a real browser.

End-to-end (E2E) testing provides this evidence because the tests run through a real browser, and recent work shows that web fragments, usage information, and recorded scenarios can be used to construct such tests from a running application @garcia2021webusage @sunman2022automated @yandrapally2023fragment. Browser automation nevertheless still needs manual decisions about scenarios, locators, test data, and oracles, and UI tests are known to be sensitive to DOM changes, asynchronous synchronization, and flakiness @romano2021uiflaky @hashemi2022jsflaky @pei2023traf. Unit tests and test-driven development keep code design and internal logic sound, but interface integration failures, browser-level login failures, and cross-role access errors surface only at the system layer, and the practical value of automation depends on strategy, script quality, environment, and CI integration and not on the number of tests written @wang2022maturity @wang2022quality. An E2E generator therefore has to produce tests that are both executable and auditable as artifacts, with auditable locators, oracles, and maintainability metrics.

Based on this gap, this study proposes TathyaTest, a prototype that generates a baseline test suite directly from a running web application. TathyaTest logs into the target application as each configured user role, records everything it finds on every page it can reach, and turns that record into runnable browser tests without a human writing test scripts. The record-to-test path is an auditable chain of artifacts, namely a per-role crawl contract, an RBAC access matrix, tiered test-data variants, and executable Playwright specifications, which @tab-terms defines before they are used in detail. Unlike approaches that rely on recorded scripts or natural-language descriptions, TathyaTest places the crawl contract as an explicit boundary between browser observation and test generation @sunman2022automated @alian2024autoe2e @junior2025genia. The pipeline design is presented as the artifact contribution, and its effectiveness is measured through a metric-based empirical evaluation on three subjects.

The evaluation is organized around three research questions, because a generator is useful only if it reaches the behavior that matters, if its tests actually fail when that behavior breaks, and if what it produces is maintainable and reliable. All three are answered by measured data in @sec-results, and the section on evaluation design maps them onto concrete evaluation questions and metric groups.

- *RQ1 (coverage):* To what extent does a test suite generated from authenticated DOM observation cover an application's functional surface (the set of functions exposed through the interface) at both the element-model level and the target application (system under test, SUT) code level?
- *RQ2 (fault detection):* How effective is that suite, including the RBAC tests derived from the per-role access matrix, at detecting seeded functional regressions?
- *RQ3 (comparison):* How do the intrinsic quality, reliability, and efficiency of the generated suite compare with a manual baseline and independent public suites?

The contributions of this study are as follows.

- A pipeline of authenticated DOM observation, element modeling, test-target mapping, and Playwright specification writing for a functional regression baseline, with a per-role crawl contract as the auditable interface between crawler and generator.
- A test-generation design covering auth, form, interaction, pagination, and RBAC with a positive/negative/edge spectrum derived from HTML constraints, using framework-neutral classification rules, scenario-style test titles, per-family state oracles, and a read-only mode for scheduled functional monitoring.
- A five-metric-group evaluation framework (model coverage, SUT code coverage, seeded-fault detection with negative controls, suite quality, and reliability and efficiency), applied to three cross-stack subjects with statistical tests against independent baselines.

The remainder of this paper reviews related work (Section 2), describes the method (Section 3), presents the results with their implications, limitations, and threats to validity (Section 4), and concludes (Section 5).

= Related work

Automated test generation for web applications shows that test scenarios can be built from observable artifacts rather than manual scripts alone. Recent studies exploit usage information, recorded test cases, fragment-based generation, combinatorial strategies, and large-model-based approaches to produce more systematic scenarios @garcia2021webusage @sunman2022automated @yandrapally2023fragment @letraon2023combinatorial @alian2024autoe2e. This literature supports the assumption that interface observation can be a source of test cases, and it also shows the need for a clear contract between observation results and the tests that are executed.

A test generator also has to be judged as part of the dynamic testing process, and the evaluation must go beyond counting test cases. ISO/IEC/IEEE 29119 defines testing processes and specification-based techniques for testing functional behavior from a user's point of view @iso29119, and ISO/IEC 25010 lists the software product quality characteristics that such tests should protect @iso25010. The oracle problem explains that generated tests are valuable only if they carry a trustworthy result-judging mechanism @barr2015oracle, and structural testing studies reaffirm that coverage percentages alone do not guarantee adequate testing @hossain2023structuralgaps. Work on web regression adds that automation must stay maintainable, since script quality, test stability, execution environment, and CI integration decide its success @abadeh2021webregression @wang2022maturity @wang2022quality, and locator abstraction remains an open issue in modern web testing @karagoz2026pageobject. TathyaTest therefore reports artifact-quality indicators such as assertion density, brittle-locator ratio, and locator-strategy distribution next to coverage.

RBAC requires a testing strategy that separates user perspectives. The classic RBAC model places roles between users and permissions so that access rights are not attached directly to individuals @ferraiolo1992rbac @sandhu1996rbac, and the literature on authentication and authorization separates identity verification from access decisions and positions RBAC as a commonly used authorization model @margam2026auth. A test generator should consequently observe an application from several roles and compare what each role can reach, which is the principle behind TathyaTest's per-role crawling.

Among established GUI test-generation tools, TathyaTest is closest to the crawler-based category. Crawljax explores Ajax applications through dynamic analysis of interface state changes and builds a state-flow graph @mesbah2012crawljax, while TESTAR generates scriptless test actions from the GUI at execution time without maintained test artifacts @vos2015testar. @tab-tools compares the capabilities: unlike either tool, TathyaTest derives an RBAC access matrix from per-role crawling, maps field constraints into tiered positive, negative, and edge variants, and produces maintainable Playwright artifacts with a validation-state-based oracle instead of mere exploration or crash detection. The more recent LLM-based generators cited above @alian2024autoe2e @junior2025genia are deliberately absent from this table: their generated test sets vary across runs and prompts, so fixed capability cells would misrepresent them, and the comparison TathyaTest invites against that line of work is determinism and artifact auditability rather than a feature checklist. Its position is therefore pipeline integration of known components, a foundation for a regression baseline and functional-availability check, and not a claim that a single new technique solves test generation, so broader generalization still requires replication.

#figure(
  caption: [Capability comparison with GUI test-generation tools.],
  table(
    columns: (1.4fr, 1fr, 1fr, 1.3fr),
    table.header(
      table.hline(),
      [*Capability*], [*Crawljax* @mesbah2012crawljax], [*TESTAR* @vos2015testar], [*TathyaTest*],
      table.hline(),
    ),
    [Model source], [UI state-transition graph], [GUI exploration at execution time], [authenticated per-role DOM],
    [Multi-role / RBAC], [no], [no], [yes (access matrix)],
    [Negative/edge tiers from constraints], [no], [no], [yes],
    [Oracle], [generic page invariants], [application crash or hang only], [form validation state and DOM error indicators],
    [Maintained artifact], [crawl-result model], [none], [Playwright specifications + manifest],
    [Test data], [manual or plugin], [random actions], [seedable runtime faker],
    table.hline(),
  ),
) <tab-tools>

= Methodology

This section describes the research method in four subsections: research approach, pipeline design, prototype implementation, and evaluation design. @tab-terms defines the recurring terms used throughout, since several of them (crawl contract, element model, access matrix, tier, oracle) name specific artifacts inside the pipeline rather than generic testing concepts. The research approach states the type of study and its stages, the pipeline design follows a single test from crawl to specification, the prototype implementation records the engineering choices behind it, and the evaluation design defines the subjects, metrics, and statistics. Each term in the table is introduced again, with a concrete example, at the point where it first matters operationally.

#figure(
  caption: [Key terminology used throughout this paper.],
  table(
    columns: (auto, 2.6fr),
    table.header(
      table.hline(),
      [*Term*], [*Meaning*],
      table.hline(),
    ),
    [Crawl contract], [the JSON record, written per role, of everything the crawler observed on a page: forms, fields, constraints, links, buttons, tables, and locators],
    [Element model], [the structured representation of one crawled page's UI elements inside the crawl contract (see the worked example later in this section)],
    [Access matrix], [the role$times$route table derived by comparing what each role's crawl contract can reach, used to generate RBAC allowed-route and blocked-route tests],
    [Tier], [one of three data-variant categories generated per field: positive (valid input), negative (invalid or blocked input), or edge (boundary, very long, or unusual input)],
    [Oracle], [the assertion mechanism that decides whether a generated test passes or fails, e.g. a DOM error indicator or an HTML5 validity check],
    table.hline(),
  ),
) <tab-terms>


== Research approach

This study uses a prototype-engineering approach with a design-science orientation, because its main goal is to design and assess a software artifact, the TathyaTest pipeline from target configuration and authenticated crawling to test-case mapping and Playwright specification writing. This approach aligns with recent test-generation research that assesses artifacts by their ability to produce tests, oracles, coverage, and execution evidence @sunman2022automated @yandrapally2023fragment @hossain2023structuralgaps @erni2024sbft. The work followed four stages so that every design decision has a checkable, artifact-based foundation: requirements for functional web-application testing (login, roles, CRUD forms, validation, navigation, search, pagination, monitoring), an architecture separating crawling, the element-model contract, test-case mapping, and specification writing, a TypeScript CLI prototype containing a Playwright crawler, a generator, and a test runner, and a metric-based empirical evaluation on three subjects that answers RQ1 through model and code coverage, RQ2 through seeded-fault detection, and RQ3 through quality, reliability, and efficiency relative to a baseline, as detailed in @subsec-eval-design

== Pipeline design

=== Crawl and generate flow

The TathyaTest pipeline is a layered transformation from a running application into executable test artifacts, shown end to end in @fig-tt-flow. Configuration and an authenticated per-role crawl produce a crawl contract; the generator turns that contract into Playwright specifications through target selection and oracle mapping; and the resulting execution evidence feeds into the next evaluation run. Within that outline, the crawl stage works as follows. The user supplies the target application, role configuration, credentials, coverage setting, and data hints. The crawl stage opens a Playwright session for each role, logs in, verifies that the login form is no longer active on the login page, and then treats the post-login landing page as the first seed. The crawler expands its queue with same-origin URLs discovered from `a[href]`, `form[action]`, `formaction`, and data attributes such as `data-href`, `data-url`, `data-route`, and `data-to`. Explicit seeds in the configuration remain supported, but are treated as tester input rather than a hidden default. The loop runs once per role and ends when the queue is empty or the page limit is reached.

#figure(
  image("/diagrams/pipeline-overview.svg", width: 100%),
  caption: [The TathyaTest pipeline, from configuration to executed test evidence.],
) <fig-tt-flow>

Every successfully visited page is extracted into an element model. Forms store `action`, `method`, a CRUD-operation indicator, `novalidate` status, fields, HTML constraints, input options, name hints, and the submit-control locator. The CRUD indicator is derived from raw form signals by framework-neutral keyword rules applied in a fixed precedence: a session-ending form is classified as logout, then an explicit verb (a hidden `_method` input, `data-turbo-method`, or `hx-put`, `hx-patch`, and `hx-delete` attributes), then a `GET` form is treated as a search or filter, then keywords in the action path (`delete`, `update`, `create`, and their common synonyms), then keywords in the submit text, and finally any other `POST` form counts as a create. Links and buttons are stored with their locators, while tables store headers and row counts. Locators are selected using a semantic priority order in which the first matching strategy wins: `data-testid`, accessible role and name, label, placeholder, a stable id, the `name` attribute, and CSS as a last resort. This ordering makes generated tests traceable back to the observed DOM and also underlies the locator-strategy-distribution and brittle-locator-ratio metrics in the suite-quality evaluation.

A worked example shows how the chain of artifacts turns into a concrete test. The example is the login form on the Blade case study, a `POST` form to `/login` with two required fields, `email` and `password`, each carrying a `<label>` and no `novalidate` attribute. Because the form is small and uses only the most common constraints, it exercises the crawl contract, the mapper, and the emitter without hiding any step. The crawler records this page as one element-model entry in the crawl contract, holding the action `/login`, the method `POST`, `noValidate` set to false, two fields of type `email` and `password` with a `required` constraint and a label locator each, and the submit button located by its role and name.

The mapper reads this entry and produces a positive login test with valid credentials from the role configuration, plus two kinds of negative test: an auth-specific wrong-password test (from the Login-target rule in @tab-target-selection), and a required-empty variant for each field (from the generic field-variant rule in the same table). Because the form carries no `novalidate` attribute, the required-empty assertion checks the password field's `validity.valid` property rather than a specific error message. The emitted test carries a scenario-style title, tags that mirror the manifest classification (tier, category, role, and whether the test can change data), and `test.step` phases that make the report read as a scenario:

#block(fill: rgb(245, 245, 245), inset: 8pt, radius: 2pt, width: 100%, text(size: 8.5pt)[```ts
test("admin · /login · \"Log in\" form → POST /login · password rejects an empty value",
  { tag: ["@negative", "@crud", "@role:admin", "@write"] },
  async ({ page, app }) => {
    await test.step("Open /login", () => page.goto("/login"));
    await page.getByLabel("Email").fill("admin@example.com");
    await page.getByLabel("Password").fill("");
    await test.step("Submit", () => page.getByRole("button", { name: "Log in" }).click());
    await expect(page.getByLabel("Password"))
      .toHaveJSProperty("validity.valid", false);
  });
```])

This same path, one crawl-contract entry producing one or more generated assertions, repeats unchanged across all five specification categories (auth, forms, interactions, pagination, RBAC); only the target-selection rule and the oracle differ per category, as summarized next. The generator writes one specification file per category and route shape, and every file imports one generated support module that holds the login helpers, the `role` and `app` fixtures, and the shared oracle helpers, so a specification reads as a short scenario rather than as repeated boilerplate. This separation keeps the cost of a new check low, because a new target-selection rule or oracle adds one branch without changing the crawl contract or the emitted layout.

=== Selecting test targets from the DOM

The generator does not synthesize pages or actions beyond what was observed. It only reads the per-role crawl contract, forms an access matrix from the differences between roles' crawl results, and then selects test targets from elements actually recorded in the contract. Route targets come from unique paths found by the crawler. Form targets come from forms containing fields for a valid submission and validation variants, or from field-less action forms such as delete and state-toggle. Interaction targets come from links and buttons that are not form submissions and are not logically duplicated. Pagination targets are chosen from common labels such as next, previous, first, last, page numbers, or query keys such as `page`, `cursor`, and `offset`; labels are matched after HTML entities are decoded, because the stock Laravel paginator escapes its arrow into the control's accessible name. To reduce duplication, URLs are canonicalized, query strings that only vary data do not become new tests, and forms are grouped by action, method, CRUD operation, submit text, and field shape.

#figure(
  caption: [Determining test targets from the crawl contract.],
  table(
    columns: (0.8fr, 1.1fr, 2.2fr),
    table.header(
      table.hline(),
      [*Target*], [*Source in crawl*], [*Selection rule and generated test*],
      table.hline(),
    ),
    [Login], [auth configuration and login-page DOM], [valid login per role; wrong password for negative coverage],
    [Route/RBAC], [crawl-result page URLs and per-role links], [a reachable unique path becomes an allowed-route test; its absence per role becomes a blocked-route test; a link one role sees and another does not becomes an absent-link test],
    [Form], [form model], [a form with fields gets a valid submit plus validation variants; a field-less action form becomes an action test],
    [Field variant], [field constraints and data hints], [required, format (email, URL, and telephone fields only), pattern, length, range in the field's own format (one unit beyond a number, day, minute, month, or week), step, option, accepted file type, confirmation, unique, and edge values become targeted cases],
    [Interaction], [links and buttons], [non-submit controls are deduplicated by canonical target or label, then checked for navigation],
    [Pagination], [link/button labels or query keys], [next, previous, first, last, and page-number controls become pagination-behavior tests],
    [Inferred route], [edit pages and delete forms], [a crawled `/r/:id/edit` page or a `DELETE /r/:id` form implies a `/r/:id` page; it becomes an allowed-route test that skips itself when the application answers 404 or 405],
    table.hline(),
  ),
) <tab-target-selection>

The field-variant rule in @tab-target-selection expands a single constrained field into positive, negative, and edge variants, one per trigger such as a required flag, a length or range bound, a step, an accepted file type, or a confirmation field. Oracle assertions are designed to check state, not brittle message text. For forms with `novalidate`, the system checks a DOM error indicator and confirms the page returns to the form context. For native HTML5 validation, the system checks the validity state or the `:invalid` selector. Beyond validation, each scenario family has its own state-based oracle. A link click must land on the link's target path; a pagination control must land on its target URL; a valid search or filter form must carry its submitted values back in the URL query; a field-less state-change form such as a done toggle must change the label of its own control; a logout must make a previously reachable protected page require a login again; and every remaining test asserts at least that the page shows no server error. None of these is proof of business correctness, since the generator still cannot know what the application is supposed to display. TathyaTest's test targets are therefore the function surface exposed by the authenticated DOM, not the application's entire hidden functionality.

=== RBAC and functional availability

For RBAC, a route is considered reachable by a given role if it appears in that role's crawl result. Differences between roles' crawl contracts form candidate positive and negative authorization tests: a route visible to admin but not to user becomes a blocked-route target for user. The same diff is applied to the interface itself: on a page that several roles reach, a link that one role receives and another does not (for example an admin-only navigation entry) becomes an absent-link test for the role without it. This approach reduces the need to manually declare every permission, but remains limited to routes visible through the DOM or through the tester's explicit seeds.

In the context of functional availability, generated tests become synthetic-check candidates that are closer to the user experience than HTTP uptime. Login flows, role access, CRUD, form validation, search/filter, pagination, and state changes can all be checked through a real browser. This claim remains bounded: TathyaTest provides a baseline from the part of the application that was successfully crawled, not a guarantee of complete coverage or superior fault detection.

== Prototype implementation

TypeScript ties the whole prototype together as one integrated component, so crawling and test writing never leave a single toolchain. Inside it sit a Playwright crawler handling per-role authentication and same-origin DOM crawling, a configuration validator, a cross-role access comparator, a field-variant generator, an oracle, a target mapper, and a specification writer. Keeping everything on one Playwright engine matters for a practical reason: server-rendered and JavaScript-rendered targets then see identical browser behavior, and the crawl contract carries only a schema version. The generator itself assumes no framework. The only application endpoint a generated test may call is an optional, configurable data-reset hook, the evaluation control endpoints are configurable, and the CRUD classification above uses conventions shared by several frameworks, so the Laravel applications are case studies rather than the target. A single command-line interface operates the whole pipeline, exposing commands for configuration initialization, crawling, specification generation, suite execution, and evaluation. That one entry point is what lets the pipeline double as a repeatable QA workflow rather than a one-off script.

The same suite can also be generated in a read-only mode. Every generated test is tagged as either reading or writing, where a test counts as writing when running it can change application data (a `POST`, `PUT`, `PATCH`, or `DELETE` form with all of its validation variants, a button click, a wrong-password login, or a logout). The read-only mode keeps only the reading tests, reuses a stored session instead of logging in for every test, never calls the reset hook, and asserts that each page it opens is up before exercising it. The result is a status sweep over every crawled route, link, pager, and search form for every role that is safe to point at a staging or production system and can run on a schedule, which is the synthetic functional check the introduction motivates.

Three subject applications were chosen specifically to vary rendering mechanism and access control. Laravel Breeze's Blade Todo App stands in for a server-rendered application; its Inertia React counterpart plays the JavaScript-rendered role. The two share essentially the same feature list, login, admin/user roles, Todo CRUD, done/undone toggling, search, filter, pagination, form validation, and an admin-only page, which is deliberate: when results differ between them, the difference can be pinned on the rendering mechanism or the pipeline itself, not on some unrelated quirk of application domain.

The third subject sits outside that pair entirely. *SauceDemo* (`https://www.saucedemo.com`) is a public React-SPA e-commerce demo maintained by Sauce Labs, selected precisely because the researchers do not control it. That lack of control has a direct consequence: PCOV instrumentation and fault-injection endpoints are simply not available, so SUT code coverage (EQ2) and fault detection (EQ3) cannot be measured on this subject. Its contribution is narrower by design, limited to model coverage (EQ1), suite quality (EQ4), and reliability/efficiency/baseline comparison (EQ5). What that external subject buys the study is a stronger generalizability claim. If every pipeline stage, from crawling and element modeling through to test generation and Playwright emission, works unmodified on a completely different stack (React SPA, client-side routing, public credentials), that is evidence the pipeline is not quietly tailored to Laravel's particular conventions.

== Evaluation design <subsec-eval-design>

=== Evaluation questions and subjects

Answering three broad research questions directly would leave too much room for hand-waving, so each one is broken down into evaluation questions (EQ) that map to a single, checkable metric group; @tab-metrics gives the full mapping. RQ1 splits into EQ1 and EQ2, RQ2 maps onto EQ3 alone, and RQ3 is answered jointly by EQ4 and EQ5. Concretely, EQ1 asks how broadly the pipeline tests the application's element model, EQ2 how much SUT code the generated suite actually reaches, EQ3 how effectively the suite detects seeded faults, EQ4 how good the generated tests' intrinsic quality is, and EQ5 how reliable and efficient the pipeline is next to a manual baseline. The evaluation module computes every one of these and writes the result as a structured JSON and Markdown report, so nothing here depends on a human reading a log file.

Three subjects carry this evaluation. Blade and Inertia React are the core pair: crawled with the same Playwright engine, built with parallel features, and fully instrumented down to PCOV and fault endpoints, their shared feature set is what makes a cross-rendering comparison possible without application domain quietly becoming a confound. The two backends are parallel implementations of the same feature list rather than copies of one codebase, so their coverage denominators differ slightly and are reported per subject. SauceDemo plays a different role, testing generalizability on a stack the researchers do not control. Being external costs it two metric groups, since EQ2 and EQ3 do not apply, but it still contributes to EQ1, EQ4, and EQ5. For the EQ5 comparison specifically, SauceDemo trades a self-authored manual baseline for three independent MIT-licensed Playwright suites pulled from GitHub. These suites are executed against the live site for the duration, flake-rate, and pass-rate comparison (the handful of their tests that cannot run in this study's environment are counted only statically), while a static quality analysis of their specification source carries the locator and assertion comparison.

=== Evaluation flow

One module orchestrates the evaluation so that every number in a results table can be traced to a concrete artifact. For each stack it times the crawl and generate stages, runs the generated suite $R$ times to obtain confidence intervals and a flake rate, runs the case study's manual suite for comparison, collects SUT code coverage, and finally activates each catalogue fault one at a time, running the tests the manifest flags as relevant to it. The generate stage writes a manifest with one entry per test, so coverage and quality metrics never need to parse specification source code, and the metrics and statistics run in a pure module kept apart from execution.

=== Metric groups and fault injection

@tab-metrics summarizes how the five metric groups line up with the five EQs, but they do not all work the same way under the hood. The model-coverage group for EQ1 and the suite-quality group for EQ4 are both static: everything they need comes straight from the generation manifest and the crawl contract, no instrumentation required. The SUT-code-coverage group for EQ2 is the one that needs PHP-side help, a PCOV-based middleware accumulates executed lines while the suite runs, and that gets reconciled against a token-based static analysis to produce line, function, branch-proxy, and exact-route coverage. The reliability/efficiency/baseline group for EQ5 relies on controlled repetition with a fixed faker seed, specifically so data variation cannot masquerade as flakiness.

#figure(
  caption: [TathyaTest's five evaluation metric groups.],
  table(
    columns: (auto, auto, 0.9fr, 2.2fr),
    table.header(
      table.hline(),
      [*EQ*], [*RQ*], [*Metric group*], [*Operational meaning*],
      table.hline(),
    ),
    [EQ1], [RQ1], [Model coverage], [element, route, CRUD-operation, RBAC-matrix-cell, constraint-kind, and tier-distribution coverage],
    [EQ2], [RQ1], [SUT code coverage], [line, function, branch-proxy (PCOV), and reached-route coverage],
    [EQ3], [RQ2], [Fault detection], [detection rate of seeded faults per class, negative controls, and fault-localization accuracy],
    [EQ4], [RQ3], [Test-suite quality], [assertion density, locator-strategy distribution, brittle-locator ratio, robustness score],
    [EQ5], [RQ3], [Reliability/efficiency], [flake rate, cross-browser agreement (Fleiss $kappa$), phase time, throughput, savings ratio, baseline comparison],
    table.hline(),
  ),
) <tab-metrics>

Fault detection (EQ3) is measured by fault seeding, in the spirit of mutation testing @jia2011mutation @papadakis2019mutation but without claiming its operator-based mutant generation. The fault catalogue in @tab-faults lists faults that a server-side registry switches on and off deterministically, with no code patching involved. The evaluator works through the catalogue fault by fault: activate it via a dedicated control endpoint, run whichever tests the manifest flags as relevant, and call it *detected* the moment one of those tests fails. The *detection rate* is the share of detectable faults that were detected, computed overall and per class, and localization accuracy asks the sharper question of how many detected faults were caught by a test actually aimed at that fault class rather than by an unrelated failure.

A catalogue built only from faults the generator targets would score 100% by construction, so the catalogue was assembled differently. Fourteen faults were derived from the case-study code itself, one for each validation rule, middleware check, controller outcome, and authentication path the code contains, rather than from the generator's variant list. Four further faults are *negative controls*: regressions the generator is deliberately not expected to catch, because its oracles assert state and never message copy, because browsers sanitize malformed dates before submission, because a free-text field has no observable constraint, and because the search oracle checks the URL rather than the result rows. A control that survives confirms that the metric can fail; a control that is detected would reveal an oracle stronger than designed. The catalogue size is therefore always stated next to the rate.

#figure(
  caption: [Catalogue of 18 seeded faults: fourteen derived from the case-study code and four negative controls that are expected to survive.],
  table(
    columns: (0.55fr, 2.6fr, 0.7fr),
    inset: (y: 2pt, x: 4pt),
    table.header(
      table.hline(),
      [*Class*], [*Fault activated*], [*Expected*],
      table.hline(),
    ),
    [validation], [drop the `required` rule on the title], [detected],
    [validation], [drop the email-format rule on the contact email], [detected],
    [validation], [drop the `unique` rule on the contact email], [detected],
    [validation], [drop the `confirmed` rule on the contact email], [detected],
    [validation], [drop the `max` rule on title and contact email], [detected],
    [validation], [drop the `in:` rule on status], [detected],
    [authz], [disable the role middleware so an admin route opens up], [detected],
    [authz], [drop the ownership check so a user can open another user's todo], [detected],
    [crud], [skip create/update persistence], [detected],
    [crud], [report a successful delete without deleting], [detected],
    [crud], [make the done/undone toggle do nothing], [detected],
    [pagination], [fail requests beyond the first page], [detected],
    [auth], [accept any password at login], [detected],
    [auth], [leave the session alive after logout], [detected],
    [validation], [drop the `date` rule on the due date (control)], [survives],
    [validation], [drop the `string` rule on the free-text body (control)], [survives],
    [validation], [reword every validation message (control)], [survives],
    [crud], [ignore the search filter in the list (control)], [survives],
    table.hline(),
  ),
) <tab-faults>

=== Statistical method and baseline

Every execution-time and flakiness measurement is repeated $R$ times and reported as a mean with a 95% confidence interval drawn from Student's $t$ distribution; crawl and generate times are single measurements per evaluation run. Flakiness, how often the same test's pass/fail status changes across those $R$ repetitions in the same browser, is reported as a flake rate. Cross-browser agreement, how often Chromium, Firefox, and WebKit agree on pass or fail for the same test, is measured with Fleiss $kappa$ @fleiss1971kappa, where 1 means identical verdicts in all three browsers. The generated suite is compared with a baseline through the non-parametric Mann--Whitney $U$ test @mann1947whitney and the rank-biserial effect size, following guidance on testing randomized algorithms in software engineering @arcuri2014statistical. The unit of analysis in that test is one test execution, pooled across the $R$ repetitions and three browsers; repeated executions of the same test are not independent samples, so the result is read as descriptive evidence of a large effect, with the rank-biserial effect size carrying the interpretive weight, rather than as an exact significance claim. The time-savings ratio is measured against an explicitly assumed manual authoring cost of 300 seconds (five minutes) per generated test case, and the sensitivity range reported next to every ratio varies that assumption by $plus.minus$50%, from 150 to 450 seconds per case, so that an assumption is not mistaken for an empirical finding.

Numbers alone do not tell the whole quality story, so a *static quality analysis* of the specification source backs up the baseline comparison: test count, assertion density, brittle-locator ratio, and locator-strategy distribution, computed from the generation manifest for TathyaTest's own suite and from the source directly for whatever it is being compared against. The two Laravel case studies get compared against the manual Playwright suite already sitting in the repository. SauceDemo is different again, its baseline is three independent GitHub suites (detailed in @tab-baseline-public), each MIT-licensed and pinned to a specific commit so the comparison stays replicable. None of those three suites were written by anyone involved in designing TathyaTest, which is exactly what makes them useful: an independent third-party baseline is what gives the EQ5 comparison real external validity.

#figure(
  caption: [SauceDemo public baseline suites.],
  [
    #table(
      columns: (1.5fr, 1.2fr, auto, auto),
      table.header(
        table.hline(),
        [*Suite*], [*Author*], [*License*], [*Commit*],
        table.hline(),
      ),
      [playwright-saucedemo#super[a] @baseline2026ashutoshfolane], [Ashutosh Folane], [MIT], [`0925c3c`],
      [portfolio-playwright saucedemo (POM)#super[b] @baseline2026aferminboada], [Alejandro Fermin Boada], [MIT], [`5b72fe5`],
      [automation sauceDemo playwright#super[c] @baseline2025renanpacheco], [Renan Pacheco], [MIT], [`51764d4`],
      table.hline(),
    )
    #align(left)[#{
      set par(first-line-indent: 0pt)
      text(size: 7pt)[
        #super[a] #link("https://github.com/ashutoshfolane/playwright-saucedemo") \
        #super[b] #link("https://github.com/aferminboada/portfolio-playwright-typescript-e2e-tests-pageObjetModel-saucedemo") \
        #super[c] #link("https://github.com/renanpacheco21/automation_sauceDemo_playwright")
      ]
    }]
  ],
) <tab-baseline-public>

= Result and discussion <sec-results>

This section reports evaluation results on all three subjects with $R = 5$ repetitions across three browsers (Chromium, Firefox, WebKit) and a fixed faker seed. All numeric values in @sec-results come directly from running the evaluation module on the three subjects and can be traced to the structured evaluation reports. For the two Laravel case studies, the server ran with coverage instrumentation and the fault registry active; for SauceDemo, the evaluation used the public `https://www.saucedemo.com` service with no server-side instrumentation. The generated suite is unique per scenario: shape-based deduplication (route shape with numeric segments normalized, form shape, value-less query keys, and cross-role validation-variant deduplication) guarantees that no two tests represent the same scenario with different data. Consequently, all EQ1 coverage metrics are computed against the number of unique scenario shapes in the crawl model, not the number of DOM element instances. For both Laravel case studies, the generator produced #evBladeTestCount tests per stack with a tier distribution of #evBladeTiers across the five specification categories (auth, forms, interactions, pagination, RBAC). In the tables, a percentage is followed by the covered and total counts as (covered/total), $plus.minus$ gives the half-width of a 95% confidence interval, and $kappa$, $U$, $r$, and $p$ are the agreement and test statistics defined in the method section.

== Overview of results

Taken together, the results support one conclusion for RQ1: the generated suite covers the observed application broadly and reaches most of its routes at the code level. It reaches full route, form, field, and access-matrix coverage of the observed model on all three subjects, with element coverage of #evBladeElemCov on the Laravel subjects, and #evBladeRouteExecCov of application routes at the code level (@sec-eq1, @sec-eq2). These two figures answer different questions, because model coverage is a completeness check against the tool's own crawl model and is largely guaranteed by construction, whereas code coverage measures how much of the application's real logic was exercised and is therefore the more informative evidence of depth.

For RQ2, #evBladeDetectable of the detectable seeded faults are detected on both Laravel subjects, and all #evBladeControls negative controls survive, as designed (@sec-eq3); this result is bounded to the 18-fault catalogue used in this study rather than a claim about arbitrary regressions. For RQ3, the generated suite is stronger on test quality than the baselines but slower per test. It leads on assertion density and locator robustness, trails the manual baseline on duration per test, and runs with a flake rate of no more than #evBladeFlake (@sec-eq4, @sec-eq5). The following subsections present the evidence behind each number, followed by the implications, limitations, and threats to validity.

== EQ1: model coverage <sec-eq1>

The generated suite covers nearly the entire observed model surface, with element coverage of #evBladeElemCov on Blade, #evInertiaElemCov on Inertia React, and #evSauceElemCov on SauceDemo (@tab-results-eq1). Route, form, field, access-matrix, and constraint-kind coverage are all at 100% on the three subjects, which means that every unique path the crawler found is tested, every role$times$route cell has either a positive test (route reachable) or a negative test (route blocked), and every constraint kind in the crawl contract is exercised by at least one variant. Navigation coverage is #evBladeNavCov on both Laravel subjects. The two missed scenarios are the previous-page pagination controls, one per role: the crawler observes a previous-page control on the second list page, but the generator emits pagination tests only from the first-page context, where that control is inactive, so no previous-page test is produced. Because element coverage is the composite of the route, form, field, and navigation counts, these two navigation scenarios are also the entire element-coverage gap.

These figures are completeness figures against the crawl model that TathyaTest itself builds, not against the application's entire functionality. Full CRUD operations are tested on the `todos` resource in both Laravel case studies, while SauceDemo only exposes read operations on its catalogue and checkout pages. The external measure of how much of the application this actually reaches is the code-coverage result in EQ2, presented next.

#figure(
  caption: [EQ1 results: model coverage per subject.],
  table(
    columns: (1.1fr, 1fr, 1fr, 1fr),
    table.header(
      table.hline(),
      [*Metric*], [*Blade*], [*Inertia*], [*SauceDemo*],
      table.hline(),
    ),
    [Element coverage], [#evBladeElemCov], [#evInertiaElemCov], [#evSauceElemCov],
    [Route coverage], [#evBladeRouteCov], [#evInertiaRouteCov], [#evSauceRouteCov],
    [Form coverage], [#evBladeFormCov], [#evInertiaFormCov], [#evSauceFormCov],
    [Field coverage], [#evBladeFieldCov], [#evInertiaFieldCov], [#evSauceFieldCov],
    [Navigation coverage], [#evBladeNavCov], [#evInertiaNavCov], [#evSauceNavCov],
    [RBAC matrix], [#evBladeRbacCov], [#evInertiaRbacCov], [#evSauceRbacCov],
    [Constraint kinds], [#evBladeConstraintCov], [#evInertiaConstraintCov], [#evSauceConstraintCov],
    [Pos/neg/edge tiers], [#evBladeTiers], [#evInertiaTiers], [#evSauceTiers],
    table.hline(),
  ),
) <tab-results-eq1>

== EQ2: SUT code coverage <sec-eq2>

Code coverage measures how much of the target application's own server code runs while the generated suite executes, and each cell of @tab-results-eq2 reads as a share followed by executed over total units in parentheses, for example lines executed over executable lines. The units are counted over the application's PHP code only, so the evaluation harness itself (the coverage collector, the fault registry, and the coverage middleware) is excluded from both numerator and denominator, and scaffolding such as the layout components and the login request class remains in the denominator. The suite reaches #evBladeRouteExecCov of application routes on both Blade and Inertia React, with function coverage of #evBladeFuncCov and #evInertiaFuncCov and line coverage of #evBladeLineCov and #evInertiaLineCov, and branch coverage is reported as a control-flow-line-based proxy, per the limitation noted under threats to validity.

Route and function coverage are the clearest indicators, because they say whether each endpoint and each routine was reached at all, while line coverage is lower by nature of interface-driven E2E testing. Every controller, form request, and main validation path is exercised, whereas condition-handling lines that no DOM interaction can trigger, such as rarely taken error branches and framework glue, stay untouched. SauceDemo is excluded because its external server cannot be instrumented. Together with EQ1, this finding completes the answer to RQ1: full surface coverage translates into substantial, though not exhaustive, server-side code reach.

#figure(
  caption: [EQ2 results: SUT code coverage (PCOV), share and executed over total units in the application's own code.],
  table(
    columns: (1.3fr, 1fr, 1fr),
    table.header(
      table.hline(),
      [*Metric*], [*Blade*], [*Inertia*],
      table.hline(),
    ),
    [Reached-route coverage], [#evBladeRouteExecCov], [#evInertiaRouteExecCov],
    [Function coverage], [#evBladeFuncCov], [#evInertiaFuncCov],
    [Line coverage], [#evBladeLineCov], [#evInertiaLineCov],
    [Branch coverage (proxy)], [#evBladeBranchCov], [#evInertiaBranchCov],
    table.hline(),
  ),
) <tab-results-eq2>

== EQ3: fault-detection effectiveness <sec-eq3>

Of the #evBladeFaultTotal catalogue faults, #evBladeDetectable of the detectable ones were detected on both Blade and Inertia React (missed detectable faults: #evBladeMissed), with a localization accuracy of #evBladeFaultLoc (@tab-results-eq3, from the catalogue in @tab-faults). The #evBladeControls negative controls, which the generator is deliberately not designed to find (a date rule, a body-string rule, a changed message text, and an ignored search filter), all survived, and none was detected unexpectedly (detected controls: #evBladeControlHit). The rate over the whole catalogue is therefore #evBladeMutScore, and the detection rate of the detectable faults is the figure that measures regression-detection ability. The hand-written baseline detected #evBladeBaseDetectable of the detectable faults under the same configuration, consistent with its limited scenario coverage.

The localization accuracy shows that every detected fault was caught by a test that actually targets that fault class, not by an incidental failure, including the authorization faults, which were caught by RBAC tests derived from the per-role access matrix on both stacks. Within the bounds of this 18-fault catalogue, RQ2 is answered affirmatively for all five classes of functional regression, and the surviving controls delimit what the suite cannot see: server-only rules and the exact wording of messages.

#figure(
  caption: [EQ3 results: seeded-fault detection per fault class, controls included.],
  table(
    columns: (1.5fr, 1fr, 1fr),
    table.header(
      table.hline(),
      [*Metric*], [*Blade*], [*Inertia*],
      table.hline(),
    ),
    [Validation faults detected], [#evBladeMutValidation], [#evInertiaMutValidation],
    [Authorization faults detected], [#evBladeMutAuthz], [#evInertiaMutAuthz],
    [CRUD faults detected], [#evBladeMutCrud], [#evInertiaMutCrud],
    [Pagination faults detected], [#evBladeMutPagination], [#evInertiaMutPagination],
    [Authentication faults detected], [#evBladeMutAuth], [#evInertiaMutAuth],
    [*Overall rate, all faults*], [*#evBladeMutScore*], [*#evInertiaMutScore*],
    [Detectable faults detected], [#evBladeDetectable], [#evInertiaDetectable],
    [Negative controls survived], [#evBladeControls], [#evInertiaControls],
    [Localization accuracy], [#evBladeFaultLoc], [#evInertiaFaultLoc],
    [Baseline, detectable faults], [#evBladeBaseDetectable], [#evInertiaBaseDetectable],
    table.hline(),
  ),
) <tab-results-eq3>

== EQ4: suite quality <sec-eq4>

The generated suite is less brittle than the public suites and stronger than the manual baseline on assertion density, so its intrinsic quality is competitive with hand-written code. On Blade, assertion density is #evBladeAssertDensity against #evBladeBaseAssertDensity for the manual baseline, and on SauceDemo the brittle-locator ratio is #evSauceBrittle against #evSauceBaseBrittle for the combined three public suites (@tab-results-eq4; a "/" separates the generated suite's value from the baseline's). The difference in brittle-locator ratio comes directly from the semantic locator priority chain, because the generator picks role, label, and placeholder before falling back to CSS, while most public suites rely on CSS selectors. Brittle-locator ratio is the proportion of fallback CSS locators, and the robustness score summarizes where the chosen locators sit on the priority chain. The Blade and Inertia React baseline is the manual suite included in the repository, and the SauceDemo baseline is the three MIT-licensed public suites. This quality dimension is the first component of the RQ3 answer.

#figure(
  caption: [EQ4 results: suite quality, generated / baseline.],
  table(
    columns: (1.1fr, 1fr, 1fr, 1fr),
    table.header(
      table.hline(),
      [*Metric*], [*Blade*], [*Inertia*], [*SauceDemo*],
      table.hline(),
    ),
    [Test count], [#evBladeTestCount / #evBladeBaseTestCount], [#evInertiaTestCount / #evInertiaBaseTestCount], [#evSauceTestCount / #evSauceBaseTestCount],
    [Assertion density], [#evBladeAssertDensity / #evBladeBaseAssertDensity], [#evInertiaAssertDensity / #evInertiaBaseAssertDensity], [#evSauceAssertDensity / #evSauceBaseAssertDensity],
    [Brittle-locator ratio], [#evBladeBrittle / #evBladeBaseBrittle], [#evInertiaBrittle / #evInertiaBaseBrittle], [#evSauceBrittle / #evSauceBaseBrittle],
    [Locator robustness (gen.)], [#evBladeRobustness], [#evInertiaRobustness], [#evSauceRobustness],
    [Locator mix (gen.)], [#evBladeLocMix], [#evInertiaLocMix], [#evSauceLocMix],
    [Locator mix (baseline)], [#evBladeBaseLocMix], [#evInertiaBaseLocMix], [#evSauceBaseLocMix],
    table.hline(),
  ),
) <tab-results-eq4>

== EQ5: reliability, efficiency, and baseline comparison <sec-eq5>

The generated suite is reliable across repetitions and browsers on both controlled subjects (@tab-results-eq5). Two metrics capture this. *Flake rate* is the proportion of tests whose pass/fail status is inconsistent across the $R = 5$ repetitions of the same browser -- a low flake rate means a test gives the same verdict every time it runs, which is what a regression suite needs to be trustworthy. *Fleiss $kappa$* is the degree to which Chromium, Firefox, and WebKit agree on the same pass/fail verdict for the same test, where 1 means all three browsers always agree and 0 means their agreement is no better than chance. Tests skipped because of role restrictions are excluded from both calculations. On Blade, the flake rate is #evBladeFlake and $kappa =$ #evBladeKappa. On Inertia React, the flake rate is #evInertiaFlake, but $kappa$ is close to zero. This near-zero value does not mean the browsers disagree with each other -- it is an artifact of Fleiss' prevalence paradox, where almost every test passes in every browser and a single disagreeing run depresses $kappa$ disproportionately despite near-perfect practical agreement. On the external subject, a flake rate of #evSauceFlake is acceptable given public-server variability.

The generated suite trades a higher per-test execution cost for far broader scenario coverage and far shorter authoring time. Its execution duration is higher than that of the concise baseline, and the difference is statistically significant (Blade: #evBladeMannWhitney). In exchange, the authoring time-savings ratio reaches #evBladeSavings against the assumed manual cost stated in the method section. The small hand-written baseline is faster and rarely fails because it exercises only a few scenarios, so the comparison is one of breadth against speed. Together with EQ4, this result completes the RQ3 answer.

#figure(
  caption: [EQ5 results: reliability, efficiency, and baseline comparison.],
  table(
    columns: (1.6fr, 1fr, 1fr, 1fr),
    table.header(
      table.hline(),
      [*Metric*], [*Blade*], [*Inertia*], [*SauceDemo*],
      table.hline(),
    ),
    [Flake rate (repetition inconsistency)], [#evBladeFlake], [#evInertiaFlake], [#evSauceFlake],
    [Cross-browser agreement (Fleiss $kappa$)], [#evBladeKappa], [#evInertiaKappa], [#evSauceKappa],
    [Pass rate], [#evBladePassRate], [#evInertiaPassRate], [#evSaucePassRate],
    [Crawl time], [#evBladeCrawlSec], [#evInertiaCrawlSec], [#evSauceCrawlSec],
    [Generate time], [#evBladeGenMs], [#evInertiaGenMs], [#evSauceGenMs],
    [Execution time (CI95)], [#evBladeExecSec], [#evInertiaExecSec], [#evSauceExecSec],
    [Duration per test], [#evBladePerTestSec], [#evInertiaPerTestSec], [#evSaucePerTestSec],
    [Savings ratio], [#evBladeSavings], [#evInertiaSavings], [#evSauceSavings],
    [Mann--Whitney $U$], [#evBladeMannWhitney], [#evInertiaMannWhitney], [#evSauceMannWhitney],
    table.hline(),
  ),
) <tab-results-eq5>

== Summary of findings

*RQ1 (coverage).* The generated suite covers 100% of the observed routes, forms, fields, access-matrix cells, and constraint kinds on all three subjects, with element coverage of #evBladeElemCov and navigation coverage of #evBladeNavCov on the Laravel subjects (@tab-results-eq1). At the code level, the suite reaches #evBladeRouteExecCov of application routes with line coverage of #evBladeLineCov on Blade and #evInertiaLineCov on Inertia React (@tab-results-eq2). The limitation is clear: the coverage figures refer to the surface the crawler observed, so functions that never appear in the DOM are not generated.

*RQ2 (fault detection).* The suite detected #evBladeDetectable of the detectable seeded faults on both Laravel subjects, with a localization accuracy of #evBladeFaultLoc, and all #evBladeControls negative controls survived as designed (@tab-results-eq3). Authorization faults were caught by RBAC tests derived from the per-role access matrix. This result applies to this study's 18-fault catalogue and is not generalized to arbitrary regressions.

*RQ3 (comparison).* The generated suite leads on assertion density and locator robustness against every baseline, and on brittle-locator ratio against the public suites (#evSauceBrittle versus #evSauceBaseBrittle), with $kappa =$ #evBladeKappa on Blade and #evInertiaKappa on Inertia React. The manual baseline leads on duration per test, flake rate, and pass rate on the Laravel subjects (@tab-results-eq4 and @tab-results-eq5). These advantages follow from its small size, since a handful of scenarios runs quickly and fails rarely, whereas the generated suite exercises far more of the application. The authoring time-savings ratio of #evBladeSavings against the assumed manual cost is the counterweight to the longer execution time.

== Implications of the results

These results place TathyaTest's main value in constructing a regression-testing baseline directly from a running application. The coverage figures show how much of the observed application that baseline reaches, the seeded-fault detection rate and localization accuracy shift the effectiveness claim from artifact-based potential to a measured quantity, and the comparison with hand-written suites shows what it costs: more tests and longer runs in exchange for broader scenarios and far shorter authoring time. This pattern is consistent with TathyaTest's position as a provider of a broad regression baseline, not a replacement for manual tests selectively written by a QA engineer.

The constructs named in the title connect directly to the measured quantities. For regression testing, each seeded fault simulates a functional regression, so the EQ3 detection rate of detectable faults reads as a regression-detection rate, and a low flake rate with high cross-browser agreement across $R = 5$ repetitions shows the stability that a repeatedly run suite requires. For functional availability, a pass rate between #evBladePassRate and #evInertiaPassRate on a normal build of the Laravel subjects, combined with precisely targeted failures whenever a fault is active, shows that the suite distinguishes available functions from broken ones. Execution time of #evBladeExecSec for one full cycle (three browsers, two roles) sets a realistic upper bound on check frequency if the suite is used as a post-deployment synthetic functional check.

== Limitations

Every limitation here traces back to one root cause: TathyaTest only knows what the DOM and the configuration tell it. If a server-side validation rule lives inside a closure or some bespoke business logic that never surfaces in the markup, the crawler simply has no way to see it. Locator quality inherits the same dependency, it is only ever as good as the target application's own markup.

The evaluation side has its own caveats, and together with the crawl-model limit they set the boundary for what this study can claim. Branch coverage is a control-flow-line-based proxy rather than the real thing, the manual baseline is still modest in size, and the fault catalogue was built to be representative rather than exhaustive, with its four negative controls making the known blind spots explicit: server-only rules and the exact wording of messages. There is enough evidence here to judge coverage, fault detection, quality, and efficiency across two rendering mechanisms, but stretching that to every kind of web application would need replication on a wider set of applications and a richer fault catalogue than this study used. TathyaTest is best read, for now, as a prototype with a replicable empirical evaluation behind it, one meant to be built on rather than treated as a final answer.

== Threats to validity

=== Internal validity
The main internal threats are leakage between tests and random data variation, and both are controlled. A server-side fault registry switches seeded faults on and off deterministically, with no code patching involved, and every test calls the configured state-reset hook before it runs, so results cannot bleed between tests (the read-only monitoring mode deliberately calls no reset hook and is not part of this measurement). Restricting each fault run to the manifest's relevant tests does not change what the detection rate means, since a fault still counts as detected only when one of those tests fails. A real browser is still a real browser, so environmental flakiness remains possible, which is why $R$ repetitions, flake-rate reporting, and a fixed faker seed are used together to rule out data variation as a confound.

=== External validity
Both internal subjects run on the same framework, Laravel, so the generalization this study can honestly claim is bounded to MVC applications built in a similar style. The generator's classification rules are framework-neutral by design, which lowers that bound without removing it, because no non-Laravel application with server-side instrumentation or a fault endpoint was evaluated. SauceDemo widens that picture as an external React SPA, at the cost that EQ2 and EQ3 fall away because its server cannot be instrumented and that the public site is not guaranteed to be up on any given run. Its EQ5 baseline comes from three independent third-party suites of varying quality, which strengthens the comparison's external validity even though none of them was built to cover the same scenarios as the generated suite.

=== Construct validity
Several measured quantities are proxies or rest on assumptions, so each needs careful reading. What this study calls branch coverage is really a control-flow-line-based proxy, not the genuine article, so every EQ2 claim should be read with that substitution in mind. The model coverage reported for EQ1 is measured against the crawl model that TathyaTest itself constructed, so it certifies internal completeness and not coverage of the application's full functionality. The seeded-fault detection rate is only as good as the catalogue behind it, and that catalogue was built by the same people who built the generator. Three safeguards limit the resulting bias: fourteen faults were derived from the case-study code (one per validation rule, access check, and controller outcome) rather than from the generator's variant classes, four negative controls the generator is not designed to find are included and reported as expected survivors, and two defects found during development lay outside the catalogue entirely. Even so, the detection rate reads correctly only as performance against this specific catalogue, not as a general claim about arbitrary regressions, and it is not operator-based mutation analysis. The time-savings ratio bakes in the assumed manual per-case cost stated in the method section, reported alongside a sensitivity analysis so that it is not mistaken for something empirically measured.

=== Conclusion validity
Comparing the generated suite against the baseline leans on the non-parametric Mann--Whitney $U$ test, rank-biserial effect size included, at a significance level of $alpha = 0.05$, with every mean carrying a 95% confidence interval (Student's $t$, $n = R$). The manual baseline being small does cap how much statistical power that test can have, which is exactly why effect size is reported right alongside exact $p$-values, so a reader can weigh magnitude and not just whether a result cleared a significance threshold. Only one test is run per subject, on execution duration, so no correction for multiple comparisons was applied.

== Reproducibility and artifact availability

The entire evaluation can be replicated with a single evaluation command per subject, using the example configurations in the repository, a fixed faker seed (42), and the three SauceDemo public baselines pinned as git submodules with recorded provenance. Both Laravel case studies, the metrics module, and the structured evaluation reports are in the same repository, and the table of values used in this paper is rebuilt from those reports by scripts kept with the manuscript, so every number can be traced back to a run. The numbers were produced with $R = 5$ repetitions, one stack at a time. Two issues found while developing the generator, an action-less show route and a paginator label that carried an HTML entity, were fixed in the case studies before these runs, and a route-audit test in each application now guards against declared routes without controller actions.

= Conclusion

This study presents TathyaTest, a crawling-based functional test-case generator for web applications. The pipeline performs authenticated per-role crawling, extracts an element model, forms an RBAC access matrix, and then produces Playwright specifications together with their manifest, using seedable runtime faker data. Its effectiveness is measured through an evaluation module with five metric groups and statistical tests on three subjects: two fully instrumented Laravel case studies and SauceDemo as an external subject.

All three research questions are answered by the data. First, the generated suite covers every observed route, form, field, and access-matrix cell on all three subjects and reaches #evBladeRouteExecCov of application routes, with line coverage of #evBladeLineCov on Blade and #evInertiaLineCov on Inertia React. Second, #evBladeDetectable of the detectable seeded faults were detected with a localization accuracy of #evBladeFaultLoc, and all #evBladeControls negative controls survived as designed. Third, the generated suite exceeds the baseline on assertion density and locator robustness, and on brittle-locator ratio against the public SauceDemo suites, with a trade-off of higher per-test duration and slightly higher flake than the concise manual baseline on the Laravel subjects.

These results hold within their stated bounds. The coverage figures refer to the surface observed by the crawler, and the detection rate refers to this study's 18-fault catalogue. Within those bounds, this study's contribution is the design of a test-generation pipeline and a replicable evaluation framework, with generalizability strengthened by cross-stack subjects and an independent third-party baseline.

Future work is directed at three areas. External validity needs to be extended through replication on production applications and non-Laravel frameworks, together with a richer manual baseline. Technical directions include extending the seeded-fault catalogue toward operator-based mutation analysis, full branch coverage in place of the current proxy, support for complex server-side validation rules, and improved locator robustness. Read-only mode already supports status-style monitoring of whole applications; measuring it over time on a production service is left for future work.

#set heading(numbering: none)

= CRediT authorship contribution statement

// .trim() undoes the header-spacing workaround's trailing space on author 0's `short`
// (see pad-first-author-short-for-header above) so it doesn't leave a stray space
// before this line's colon.
#juti.credits(authors.map(a => (..a, short: a.short.trim())))

= Declaration of competing interest

The authors declare that they have no known competing financial interests or personal relationships that could have appeared to influence the work reported in this paper.

= Acknowledgement

This research was funded by the DIPA (Daftar Isian Pelaksanaan Anggaran) internal research grant of Politeknik Negeri Malang.

= Data availability

Both Laravel case studies, the metrics module, and the structured evaluation reports referenced throughout this paper are openly available in the project repository at #link("https://github.com/dhanifudin/tathyatest")[github.com/dhanifudin/tathyatest]. The three SauceDemo baseline suites are included as pinned git submodules with recorded provenance (@tab-baseline-public).

= Declaration of generative AI and AI-assisted technologies in the writing process

The authors used an AI coding assistant (Claude Code, Anthropic) to help draft and format this manuscript. All AI-assisted content was reviewed and edited by the authors, who take full responsibility for the accuracy and integrity of the final publication.

= ORCID

#juti.orcid(authors)
