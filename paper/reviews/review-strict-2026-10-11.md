# Peer review (simulated, strict)

**Manuscript:** TathyaTest: a generator for functional, regression, and functional-availability testing of web applications
**Venue:** JUTI: Jurnal Ilmiah Teknologi Informasi (ITS) — single-blind, 2 reviewers, ~7% acceptance
**Version reviewed:** repository state at commit `81c2bf1` (`paper/juti/main.typ`, compiled PDF 15 pp.)
**Reviewer style calibration:** current JUTI issue conventions and submission guidelines as captured in `.claude/skills/juti/references/house-style.md`; artifact link followed per the manuscript's own Data availability section.

**Recommendation: Major revision.**

---

## Summary of the submission

The manuscript presents TathyaTest, a pipeline that crawls a running web application per user role through Playwright, records the observed pages/forms/constraints as a per-role "crawl contract," and generates executable Playwright test suites across five categories (auth, forms, interactions, pagination, RBAC). It is evaluated on two instrumented Laravel case studies and the public SauceDemo site through four metric groups (model coverage, SUT code coverage, suite quality, reliability/efficiency), with Mann–Whitney U comparisons against a manual baseline and three third-party public suites.

## Overall assessment

The topic fits JUTI's scope, and the venue has published in exactly this sub-area before. The engineering contribution is genuine and unusually well packaged: the crawl-contract boundary is a clean idea, the evaluation is automated and replicable from a single command, the artifact repository is public, baselines are pinned, and the threats-to-validity section is more disciplined than most submissions. The writing is clear and the structure complies with the journal's required five-section format.

The manuscript is held back by one central problem and several supporting ones. The central problem: for a paper whose title promises *functional, regression, and functional-availability testing*, the evaluation never measures whether the generated tests can detect a fault. Coverage and stability are necessary but not sufficient — the manuscript's own citation [15] (Hossain et al., structural testing gaps) makes exactly this point. This gap is compounded by the fact that the declared artifact repository contains a complete, executed fault-detection experiment that the manuscript does not mention (Major comment 1). The remaining majors are an internal contradiction about whether the public baselines were executed, an unexplained cell-for-cell identity between the two Laravel subjects, an unverifiable headline number, and undiagnosed gaps in the authors' own metrics. All are fixable within one revision cycle, which is why I recommend major revision rather than rejection.

---

## Major comments

**M1. No fault-detection evidence, while the declared artifact contains an unreported fault-detection experiment.**
*Location:* title; abstract; §3.4 (Table 4); §4 throughout; Data availability.
The evaluation establishes that the generated suite is broad (EQ1), reaches the server (EQ2), is well-constructed (EQ3), and is stable (EQ4). None of these shows that the suite would *fail* when the application is broken, which is the defining property of a regression suite. The conclusion's claim of "a viable foundation for regression testing" therefore rests entirely on coverage and stability proxies. More seriously: following the repository link that the Data availability section provides, the structured evaluation reports (`metrics/report.json`) contain a completed seeded-fault experiment — an 18-fault catalogue with 4 negative controls, a 77.8% (14/18) detection rate, 100% (14/14) on faults the generator is expected to detect, all 4 controls surviving as expected, and a hand-written-baseline detection rate of 21.4% (3/14) on the same catalogue — and the submitted Typst source (`eval-numbers.typ`) still carries all of these values as defined-but-unused variables under a comment header that contradicts the paper's own EQ numbering. Omitting a conducted experiment whose outputs ship with the declared artifact invites a selective-reporting objection, and in this case the omission is puzzling because the result (near-perfect detection on detectable faults, honest controls, a 3.6× margin over the baseline) *supports* the paper's thesis. **Required:** either (a) restore a fault-detection evaluation question reporting the seeded-fault experiment with its limitations plainly stated (author-constructed catalogue, ceiling risk on detectable faults, controls as the mitigation), or (b) remove the fault data from the public artifact snapshot that accompanies the paper and add an explicit statement in Limitations that fault-detection effectiveness was not evaluated and why. Option (a) is strongly preferred; option (b) weakens the title claim to the point where "regression" should be reconsidered in the title.

**M2. Internal contradiction: were the SauceDemo public baselines executed or not?**
*Location:* §3.4.1 ("…backed by a static quality analysis of the specification source so the comparison still holds even though those public suites are never executed"), with §3.4.4 reinforcing the static-analysis framing; vs. Table 9, which reports a SauceDemo Mann–Whitney U on execution durations (U = 22,556; p < 0.001; r = 0.64).
A duration-based U statistic cannot exist without executed baseline durations, and the underlying evaluation report records executed baseline runs for SauceDemo (with their own flake and pass rates). Either the "never executed" sentences are stale, or the Table 9 SauceDemo comparison is computed against something other than what the text describes. **Required:** state exactly which baselines were executed (and how many of the 74 statically counted tests actually ran), and make §3.4.1, §3.4.4, and Table 9 tell the same story.

**M3. The two Laravel subjects report identical values on every EQ1–EQ3 metric, and the manuscript never remarks on it.**
*Location:* Tables 6–8; §3.3 ("when results differ between them, the difference can be pinned on the rendering mechanism…").
Element coverage, navigation coverage, tiers, line coverage (23.6%, 104/441), branch proxy (34.1%, 29/85), function coverage (71.9%, 41/57), assertion density, brittle ratio, robustness, and even the locator mix (label: 59, role: 22, css: 4) are identical cell-for-cell between Blade and Inertia React. Identical *percentages* on parallel apps would be plausible; identical raw numerators and denominators on two different codebases — including 441 identical executable PHP lines — will make any careful reader suspect a copy-paste or data-handling error. If the two backends are deliberately line-identical PHP with only the view layer swapped, say so explicitly (it is a methodological strength: a controlled variable), and then draw the conclusion the design begs for: the rendering mechanism made *no difference* to EQ1–EQ3, and only EQ4 timing/reliability separates the stacks. If they are not line-identical, audit the pipeline for a report mix-up before resubmission. **Required** either way.

**M4. The headline time-savings ratio depends on an assumption the paper never states.**
*Location:* abstract ("a time-savings ratio of 25.5× (12.7–38.2) against an assumed manual cost"); §3.4.4 ("an explicitly assumed manual per-case cost… reported with its sensitivity range"); §4.5; Table 9.
The manuscript twice says the assumed manual authoring cost is "explicitly stated," but the number itself appears nowhere — not the assumed minutes-per-test, not the sensitivity bounds that generate the 12.7–38.2 range. As submitted, the single most quotable number in the abstract cannot be checked or re-derived by a reader. **Required:** state the assumed per-case authoring cost, the sensitivity interval around it, and the formula; one sentence in §3.4.4 suffices.

**M5. The authors' own metrics contain unexplained gaps that are reported but not investigated.**
*Location:* §4.2 ("two of the 19 navigation scenarios produced no test, a gap that has not been diagnosed further"); Table 6 (element coverage 95.5%, i.e. 2/44 elements untested, not discussed at all); §4.5/Table 9 (pass rate 99.8%/99.9% on a clean build — so some tests fail on a healthy application — with no identification of which or why); SauceDemo pass rate 96.2% with flake 0.0% (≈4% of tests failing *deterministically* against the live site, which is not flakiness and is never discussed).
"Not diagnosed further" is below the bar for a venue at this acceptance rate when the undiagnosed quantity is the paper's own primary metric. The deterministic SauceDemo failures matter most: a generator that emits consistently failing tests on a healthy application has an oracle-precision problem, which goes to the heart of the paper's "auditable oracle" pitch. **Required:** identify the 2 missed elements, the 2 missed navigation scenarios, and the consistently failing tests per subject (the evaluation report format appears to already record failing/flaky tests on the clean build); classify each as generator defect, oracle imprecision, or application property.

**M6. The capability comparison (Table 1) benchmarks against 2012/2015 tools only.**
*Location:* §2, Table 1 (Crawljax, TESTAR).
The related-work prose cites 2021–2025 generation approaches, including LLM-based E2E generation [11], [12], yet the structured comparison skips a decade of work and compares TathyaTest only against Crawljax (2012) and TESTAR (2015), where it naturally dominates. Add at least one modern row (e.g. the feature-driven E2E generation of [11] or GenIA-E2ETest [12]) with honest cells, or state explicitly why a structured comparison with LLM-based generators is not meaningful (e.g. non-determinism, no maintained artifact), which would itself be a useful positioning claim.

---

## Minor comments

**m1.** §4.5, Table 9: Fleiss κ printed as "−0.00" is confusing (a signed zero), and the prevalence-paradox explanation, while correct, concedes that κ is uninformative exactly where it is being reported. Report raw percent agreement (or an alternative such as Gwet's AC1) alongside κ for all three subjects, and print the Inertia value as "0.00" or with more precision.

**m2.** Conclusion: "line coverage from 23.6% (104/441) up to 23.6% (104/441)" is a degenerate range (both endpoints identical). Rewrite as a single value — or resolve M3 first, since the fix depends on whether the identity survives the audit.

**m3.** Abstract: "a time-savings ratio of 25.5× (12.7–38.2)" quotes the Blade value without attribution while the three subjects span 23.9×–42.6×. Either attribute it ("on the Blade subject") or quote the cross-subject range. (The "flake rate of no more than 0.5%" phrasing, by contrast, is correctly a maximum.)

**m4.** §3.4.4/Table 9: the Mann–Whitney U on per-test durations pools ~1,500 duration observations that include 5 repetitions of the same tests across 3 browsers; these are not independent samples, which inflates the effective n. State the unit of analysis, and either cluster (e.g. compare per-test mean durations, n = test count) or justify the pooling. The conclusion will not change — the effect is large — but the current setup overstates precision.

**m5.** Table 9: crawl time and generate time carry no ± interval while execution time does. State whether crawl/generate are single measurements or means over the R repetitions.

**m6.** The submitted Typst source includes `eval-numbers.typ` with ~30 defined-but-unreferenced variables (the entire fault block, verdict rows) under section comments reading "EQ3: fault detection" and "EQ5: reliability" that contradict the paper's EQ3/EQ4 numbering. Since JUTI requires the Typst source alongside the PDF, regenerate this file to match the reported metric set (this also interacts with M1).

**m7.** §3.2.1 worked example: the emitted login-form validation test is tagged `@crud` although the narrative introduces five categories in which login belongs to `auth`. If field-level validation variants are deliberately classified under the form/CRUD category even on the login form, one clause saying so would prevent the reader from stumbling where the example and the category list appear to disagree.

**m8.** References [27]–[29] (the three GitHub baseline suites) should carry `[Online]` availability and access dates per IEEE practice for web resources; the pinned commit hashes in Table 5 are good, but the reference entries themselves are bare.

**m9.** §4.6: "a pass rate between 99.8% and 99.9% on a normal build shows that the suite reports a healthy application as healthy" quietly excludes SauceDemo (96.2%). Scope the sentence to the Laravel subjects or address the SauceDemo figure (see M5).

## Presentation and typos

- §3.1, last sentence: "as detailed in Section 3.4.." — double period (the cross-reference supplement already carries the period; drop the manual one). Audit all `@ref.`-pattern sentences for the same artifact.
- Table 5 footnote b: repository name "pageObjetModel" is the upstream author's own spelling; add "[sic]" or leave it, but confirm it is intentional.
- Fig. 1 is clean and legible; the legend convention (green = stored artifact) is helpful. No action needed — noted as resolved relative to typical auto-layout diagrams.
- Abstract length (~210 words), one paragraph, no citations: compliant.

## Template-compliance check (per the journal's pre-submission checklist)

| Item | Status |
| --- | --- |
| Five numbered sections with exact required headings | Pass ("Result and discussion" singular/lowercase correct) |
| Introduction: objectives + paper-organization closing paragraph | Pass (compressed one-sentence form; acceptable) |
| Back matter: 7 sections, exact titles, fixed order | Pass |
| Abstract recipe and length, no citations | Pass |
| Table captions above / figure captions below, booktabs look | Pass |
| IEEE numeric citations in first-appearance order | Pass |
| English throughout | Pass |
| Figures vector/≥300 dpi | Pass (SVG-native) |
| Similarity / AI screening | Re-run required: the archived screens in `paper/reviews/` predate the current revision (the manuscript has since been restructured twice) |

## Decision rationale

Scope fit is strong, the artifact is real and public, and the writing and compliance are above average for this venue. However, M1 (claims–evidence alignment on fault detection, aggravated by the unreported experiment sitting in the declared artifact), M2 (an internal contradiction in the comparison methodology), and M3 (an unexplained exact identity between the two subjects) each independently block acceptance in the current form; M4 blocks the abstract's headline number from being checkable. All are addressable without new large-scale experiments — M1's data already exists, M2 and M4 are textual repairs plus one clarification, M3 is one paragraph if the identity is by construction. **Major revision**, with an expectation that a revised version can be assessed in one further round.
