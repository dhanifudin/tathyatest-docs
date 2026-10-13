# Peer review (simulated, strict), second round

**Manuscript:** TathyaTest: a generator for functional, regression, and functional-availability testing of web applications
**Venue:** JUTI: Jurnal Ilmiah Teknologi Informasi (ITS), single-blind, 2 reviewers, ~7% acceptance
**Version reviewed:** `paper/juti/main.typ` at commit `f2c7473` (compiled PDF, 18 pp.)
**Reviewer style calibration:** `.claude/skills/juti/references/house-style.md`; this round follows `review-strict-2026-10-11.md`.

**Recommendation: Major revision (light).**

---

## Summary of the submission

TathyaTest crawls a running web application once per user role with Playwright, stores the observation as a per-role crawl contract, derives an RBAC access matrix and tiered test data, and emits Playwright specifications in five categories. The revised evaluation has three research questions mapped to five evaluation questions: model coverage (EQ1), SUT code coverage (EQ2), seeded-fault detection with negative controls (EQ3), suite quality (EQ4), and reliability and efficiency against manual and public baselines (EQ5). It runs on two instrumented Laravel todo applications (Blade, Inertia React) and the public SauceDemo site.

## Overall assessment

The revision resolves the central problems of the first round. A fault-detection experiment is now reported, with an 18-fault catalogue of which four are negative controls; the baseline-execution contradiction is gone; the Blade/Inertia pair now genuinely differs and the differences are explained; the manual-cost assumption (300 s per test, ±50%) is stated; and the undiagnosed gaps are diagnosed. The statistics section is more honest (unit-of-analysis caveat, effect sizes). The paper now meets the required five-section structure and reads well.

What remains is a smaller set of problems, but several of them are about whether a claim is backed by what a reader can actually obtain or verify. I count three that I would not accept in a camera-ready version: the data-availability statement is not currently true (M1), the fault-localization result is true by construction (M2), and the "oracle-visibility" explanation for the Inertia misses mixes up a generation gap with an oracle weakness (M3). Two further points concern scope: the subjects are very small (M4), and the title's "functional-availability" construct rests on a mode that is never evaluated (M5). All are addressable in one revision cycle.

---

## Major comments

**M1. The Data availability statement is not currently true.**
*Location:* "Data availability"; "Reproducibility and artifact availability".
The paper states that the structured evaluation reports are in the project repository and that the table of values is rebuilt from those reports. In the declared repository, `metrics/` is excluded by `.gitignore`; `metrics/report.json` and `metrics-saucedemo/report.json` are not tracked, so a reader following the link cannot obtain the files from which every number in Section 4 is generated. The Reproducibility section also says the runs were made "one stack at a time", but not that the per-stack reports were merged into the single file the manuscript scripts read.
*Required:* track (or archive with a DOI, e.g. Zenodo) the three evaluation reports and the exact configuration used, pin a release tag, document the per-stack merge step, and cite the tag/DOI in the paper.

**M2. Fault localization accuracy of 100% is true by construction, and collateral failures are never observed.**
*Location:* "Metric groups and fault injection"; EQ3 results and Table 9.
Each fault is run only against "the tests the manifest flags as relevant to it", and a fault is detected when one of those tests fails. Localization accuracy then asks whether the detecting test targets the fault's class; since only class-relevant tests were run, this is 100% unless a relevant test is mis-tagged. It therefore says nothing about the generator. The same design means failures in non-relevant tests are never seen, so the only evidence about false alarms and over-sensitivity is the four negative controls.
*Required:* run the full suite per fault (or a documented random sample of tests outside the relevant set) and report (a) detection by any test and (b) detection by a targeted test separately; either drop localization accuracy or redefine it on the full-suite run.

**M3. The "oracle-visibility limit" explanation conflates a generation gap with an oracle weakness.**
*Location:* EQ1 (Blade navigation gap), EQ2 (unreached logout route), EQ3 (two Inertia misses), Summary of findings, Conclusion.
EQ2 reports that the Inertia logout route is never reached because logout is a script-driven control, i.e. no logout test is generated. EQ3 then attributes the misses `auth-logout-noop` and `crud-delete-noop` to "oracles [that] do not see enough server-side state". If no test exercises the control, the fault is missed because of a generator gap, not because an oracle looked and failed to see it; the paper shows no trace of a test that ran and passed. The two explanations call for different fixes and support different claims in the Conclusion ("a real oracle-visibility limit").
The Blade navigation gap has a related problem. The two missed scenarios are explained by pagination tests being emitted only from the first-page context. That explanation would equally apply to Inertia React, which reaches 21/21 navigation scenarios, so the account is incomplete; and a limitation that the authors can identify at this precision is a generator defect that could be fixed and re-run before submission.
*Required:* for every miss (2 Blade navigation scenarios, 2 Inertia faults, the unreached logout route) state whether a relevant test existed and passed (oracle) or did not exist (generation), and reconcile the Blade/Inertia navigation difference. Fix and re-run, or label these plainly as generation gaps in the abstract's limitations.

**M4. The two instrumented subjects are toy applications written by the authors, alongside the generator and fault registry.**
*Location:* Table 8 (EQ2), §3.3, External validity, Abstract.
The backends have 249 and 269 executable PHP lines and 8 routes around a single `todos` resource. "Route reach 87.5%" is 7 of 8 routes; the faults live in a registry the authors added to their own code. The paper's own introduction is motivated by real internal university applications, none of which is evaluated. SauceDemo is the only external subject and contributes only EQ1, EQ4 and EQ5. The paper reads "a viable foundation for regression testing" from this evidence.
*Required:* evaluate at least one non-trivial third-party application with real roles and a meaningful code base (an open-source Laravel or other framework application, or the internal applications that motivate the work), or state the toy scale in the abstract and soften the "viable foundation" claim.

**M5. The functional-availability part of the title and the read-only mode contribution are never evaluated.**
*Location:* title; Contribution 2; "RBAC and functional availability"; "Prototype implementation"; Implications.
Read-only mode (tests tagged `@read`/`@write`, stored session, no reset hook, page-is-up assertions) is presented as the synthetic functional check that the introduction motivates, but no result concerns it: no read-only run, no outage-style fault, no detection latency or run time of the read-only subset. A 100% pass rate on a clean build is a baseline, not evidence of availability checking, and the Implications section extrapolates from the execution time of the full three-browser suite.
*Required:* evaluate the read-only subset (e.g. inject outage-type faults: 500 on a route, broken login, missing control, and report detection and run time), or remove the mode from the contributions and "functional-availability" from the title.

**M6. Statistical reporting.**
*Location:* Abstract ("95% confidence intervals"), Tables 7-11, "Statistical method and baseline".
(a) The abstract says each measurement carries a 95% confidence interval, but detection rates, coverage proportions and pass rates have none. With 14 detectable faults the Wilson 95% intervals are 78.5-100% for 14/14 and 60.1-96.0% for 12/14, so the Blade/Inertia contrast (100.0% vs 85.7%) is not statistically distinguishable; the 21.4% (3/14) baseline interval is 7.6-47.6%. Report proportion intervals and word the Blade-versus-Inertia comparison accordingly.
(b) Fleiss' kappa is 1.00 on Blade and Inertia React where every test passes in every browser and in every repetition. With no variation in the ratings the chance-agreement term is 1 and kappa is undefined; reporting 1.00 conveys nothing. Report raw percent agreement for those subjects (kappa is only meaningful for SauceDemo, where verdicts vary across tests).
(c) The time-savings ratio is defined in prose by an assumption (300 s per test) but not by a formula. The reported values are reproducible as (tests x 300 s) / (crawl + generate + one execution), and that should be written down. It also compares authoring time for the same number of tests against one machine run, and ignores setup effort (configuration, reset and coverage hooks, fault registry, oracle tuning). State the formula and discuss the missing setup cost as a threat.

**M7. Table 1 characterizes competing tools in terms the tools' own documentation contradicts.**
*Location:* §2, Table 1.
TESTAR is listed with oracle "application crash or hang only", and Crawljax with "generic page invariants" and "Multi-role / RBAC: no". Both tools allow user-defined oracles (e.g. regular-expression checks on titles and messages in TESTAR; plugin-defined invariants in Crawljax), and login can be scripted through plugins. The cells should be supported by citations to the tools' documentation or reworded to what the default configuration does.

---

## Minor comments

**m1. Author name and e-mail differ from the institutional records.** The manuscript gives "Dika Rizki Yunianto" with `dikarizkyyunianto@polinema.ac.id`; the project's report configuration (and identity documents) use "Dika Rizky Yunianto" with `dika.rizky@polinema.ac.id`. Make author names and affiliations consistent with ORCID and the university records before submission.

**m2. CRediT mapping.** No author holds *Funding acquisition* (13) or *Visualization* (10) although the work is DIPA-funded and contains figures, and only the first author holds a writing role. Confirm each co-author's contribution; the source comment already notes the mapping is provisional.

**m3. Abstract reports Blade-only headline values.** Code-level route reach (100.0%) and time savings (32.7x) are given for Blade only, while Inertia React shows 87.5% and 32.3x. Give both, e.g. "100.0% (Blade) and 87.5% (Inertia React)".

**m4. Development findings buried in Reproducibility.** The paginator-label entity and the `show` route returning HTTP 500 were found by the generator's own checks and then fixed in the case studies "before these runs". This is evidence of real bug-finding and also explains the 87.5% to 100.0% route-coverage movement on Blade; report it in Results with its effect on the numbers, not as a reproducibility footnote.

**m5. SauceDemo role/RBAC cell.** Table 7 reports an RBAC matrix of 4/4 for SauceDemo, which exposes a single account, and the paper says tests are "skipped because of role restrictions" without giving the number skipped on any subject. State the number of roles, the number of skipped tests, and what the four matrix cells are.

**m6. Generative-AI declaration.** It says an AI assistant was used to "draft and format" the manuscript. Say explicitly whether the same assistant was used to write code or experiment tooling, since that is the more consequential use for a software-engineering paper.

**m7. Acknowledgement.** Add the funding contract number (SP DIPA-139.03.2.693474/2026) as funders typically require.

**m8. Introduction.** "Based on this gap" in the third paragraph refers to a gap that is never stated as a sentence; one explicit gap statement before the contribution would help. The terminology table (Table 2) precedes the sections that use it and spends scarce page budget.

**m9. Overall claims from a catalogue the authors designed.** Even with controls, "detectable" is the authors' prior expectation (Table 5, column "Expected"). State that the expectation column was fixed before the evaluation run (a commit hash or date suffices).

---

## Presentation and typos

- §3.1 ends "…as detailed in @subsec-eval-design" without a closing period.
- The paper-organization paragraph hard-codes "Section 2/3/4/5"; use cross-references.
- Table 5 (18 rows) and Table 9 make the Methodology/Results the densest parts; consider merging them into one fault table.
- Abstract length (~235 words) and absence of citations: compliant.

## Template-compliance check

| Item | Status |
|------|--------|
| Five numbered sections with the exact required headings | OK |
| Introduction with objectives (RQs) and paper-organization paragraph | OK (gap sentence missing, m8) |
| Abstract: one paragraph, 150-300 words, no citations | OK |
| Table captions above, figure caption below, `Supplement N.` handled by template | OK |
| Seven back-matter sections in the fixed order | OK |
| References in IEEE numeric style, first-appearance order | OK |
| Length (18 pp; observed 18-22) | OK |
| ORCIDs and e-mails present | present, verify (m1) |
| Funding / data / AI statements | present, M1 and m6, m7 need work |

## Decision rationale

The paper is a competent, honestly written systems-evaluation study that has fixed the earlier structural defects. I recommend major revision (light) because three results in the current text cannot be accepted as stated: the data-availability claim (M1) is checkably false, the localization metric (M2) is tautological, and the explanation of the Inertia misses (M3) is not supported by the evidence shown. The scope points (M4, M5) determine how strongly the title and abstract may be worded, and the statistical points (M6) are quick to address. If the authors provide the artifact, a full-suite fault run, a read-only evaluation (or remove the claim), and a non-toy subject, the paper would be in range for acceptance at this venue.
