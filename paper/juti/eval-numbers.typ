// =====================================================================
// TathyaTest evaluation numbers (English / JUTI article)
// Values come from metrics/report.json (Blade, Inertia) and
// metrics-saucedemo/report.json (SauceDemo), all produced by `tt eval`.
// `evalTBD` marks a number awaiting the next evaluation run.
// This file is auto-generated:
//   node scripts/report-to-typst.mjs > paper/juti/eval-numbers.typ
// Sibling of paper/eval-numbers.tex (Indonesian/LaTeX) — keep both in sync.
// =====================================================================

#let evalTBD = [*---*]

// ---------- EQ1: model coverage (stacks[].coverage) ----------
#let evBladeElemCov = [95.5% (42/44)] // stacks[blade].coverage.element
#let evBladeRouteCov = [100.0% (6/6)] // stacks[blade].coverage.routes
#let evBladeFormCov = [100.0% (3/3)] // stacks[blade].coverage.forms
#let evBladeFieldCov = [100.0% (16/16)] // stacks[blade].coverage.fields
#let evBladeNavCov = [89.5% (17/19)] // stacks[blade].coverage.nav
#let evBladeRbacCov = [100.0% (12/12)] // stacks[blade].coverage.rbacMatrix
#let evBladeConstraintCov = [100.0%] // stacks[blade].coverage.constraintKinds.ratio
#let evBladeTiers = [46/24/34 (104)] // stacks[blade].coverage.tiers
#let evBladeTestCount = [104] // stacks[blade].quality.testCount

#let evInertiaElemCov = [95.5% (42/44)] // stacks[inertia].coverage.element
#let evInertiaRouteCov = [100.0% (6/6)] // stacks[inertia].coverage.routes
#let evInertiaFormCov = [100.0% (3/3)] // stacks[inertia].coverage.forms
#let evInertiaFieldCov = [100.0% (16/16)] // stacks[inertia].coverage.fields
#let evInertiaNavCov = [89.5% (17/19)] // stacks[inertia].coverage.nav
#let evInertiaRbacCov = [100.0% (12/12)] // stacks[inertia].coverage.rbacMatrix
#let evInertiaConstraintCov = [100.0%] // stacks[inertia].coverage.constraintKinds.ratio
#let evInertiaTiers = [46/24/34 (104)] // stacks[inertia].coverage.tiers
#let evInertiaTestCount = [104] // stacks[inertia].quality.testCount

#let evSauceElemCov = [100.0% (20/20)] // stacks[saucedemo].coverage.element
#let evSauceRouteCov = [100.0% (4/4)] // stacks[saucedemo].coverage.routes
#let evSauceFormCov = [100.0% (1/1)] // stacks[saucedemo].coverage.forms
#let evSauceFieldCov = [100.0% (3/3)] // stacks[saucedemo].coverage.fields
#let evSauceNavCov = [100.0% (12/12)] // stacks[saucedemo].coverage.nav
#let evSauceRbacCov = [100.0% (4/4)] // stacks[saucedemo].coverage.rbacMatrix
#let evSauceConstraintCov = [100.0%] // stacks[saucedemo].coverage.constraintKinds.ratio
#let evSauceTiers = [18/4/9 (31)] // stacks[saucedemo].coverage.tiers
#let evSauceTestCount = [31] // stacks[saucedemo].quality.testCount

// ---------- EQ2: SUT code coverage (stacks[].sutCoverage; PCOV, Laravel only) ----------
#let evBladeLineCov = [23.6% (104/441)] // stacks[blade].sutCoverage.lines
#let evBladeBranchCov = [34.1% (29/85)] // stacks[blade].sutCoverage.branches (proxy)
#let evBladeFuncCov = [71.9% (41/57)] // stacks[blade].sutCoverage.functions
#let evBladeRouteExecCov = [100.0% (8/8)] // stacks[blade].sutCoverage.routes

#let evInertiaLineCov = [23.6% (104/441)] // stacks[inertia].sutCoverage.lines
#let evInertiaBranchCov = [34.1% (29/85)] // stacks[inertia].sutCoverage.branches (proxy)
#let evInertiaFuncCov = [71.9% (41/57)] // stacks[inertia].sutCoverage.functions
#let evInertiaRouteExecCov = [100.0% (8/8)] // stacks[inertia].sutCoverage.routes

// ---------- EQ3: fault detection (stacks[].faults; Laravel only) ----------
#let evBladeMutScore = [77.8% (14/18)] // stacks[blade].faults.mutationScore (killed/total)
#let evBladeMutValidation = [66.7% (6/9)] // stacks[blade].faults.byClass.validation
#let evBladeMutAuthz = [100.0% (2/2)] // stacks[blade].faults.byClass.authz
#let evBladeMutCrud = [75.0% (3/4)] // stacks[blade].faults.byClass.crud
#let evBladeMutPagination = [100.0% (1/1)] // stacks[blade].faults.byClass.pagination
#let evBladeMutAuth = [100.0% (2/2)] // stacks[blade].faults.byClass.auth
#let evBladeFaultLoc = [100.0%] // stacks[blade].faults.localizationAccuracy
#let evBladeFaultTotal = [18] // stacks[blade].faults.total
#let evBladeDetectable = [100.0% (14/14)] // stacks[blade].faults.detectable (killed/total of faults expected to be detected)
#let evBladeControls = [4/4] // stacks[blade].faults.controls (negative controls that survived / total)
#let evBladeMissed = [none] // stacks[blade].faults.perFault (detectable faults that survived)
#let evBladeControlHit = [none] // stacks[blade].faults.perFault (negative controls that were detected)
#let evBladeBaseDetectable = [21.4% (3/14)] // stacks[blade].baseline.baselineMutation.detectable (hand-written baseline, detectable faults)

#let evInertiaMutScore = [77.8% (14/18)] // stacks[inertia].faults.mutationScore (killed/total)
#let evInertiaMutValidation = [66.7% (6/9)] // stacks[inertia].faults.byClass.validation
#let evInertiaMutAuthz = [100.0% (2/2)] // stacks[inertia].faults.byClass.authz
#let evInertiaMutCrud = [75.0% (3/4)] // stacks[inertia].faults.byClass.crud
#let evInertiaMutPagination = [100.0% (1/1)] // stacks[inertia].faults.byClass.pagination
#let evInertiaMutAuth = [100.0% (2/2)] // stacks[inertia].faults.byClass.auth
#let evInertiaFaultLoc = [100.0%] // stacks[inertia].faults.localizationAccuracy
#let evInertiaFaultTotal = [18] // stacks[inertia].faults.total
#let evInertiaDetectable = [100.0% (14/14)] // stacks[inertia].faults.detectable (killed/total of faults expected to be detected)
#let evInertiaControls = [4/4] // stacks[inertia].faults.controls (negative controls that survived / total)
#let evInertiaMissed = [none] // stacks[inertia].faults.perFault (detectable faults that survived)
#let evInertiaControlHit = [none] // stacks[inertia].faults.perFault (negative controls that were detected)
#let evInertiaBaseDetectable = [21.4% (3/14)] // stacks[inertia].baseline.baselineMutation.detectable (hand-written baseline, detectable faults)

// ---------- EQ4: suite quality (stacks[].quality + baseline.quality.baseline) ----------
#let evBladeAssertDensity = [1.20] // stacks[blade].quality.assertionDensity
#let evBladeBrittle = [4.7%] // stacks[blade].quality.brittleLocatorRatio
#let evBladeRobustness = [72.4%] // stacks[blade].quality.locatorRobustness
#let evBladeLocMix = [label: 59, role: 22, css: 4] // stacks[blade].quality.locatorDistribution (top-3)
#let evBladeBaseTestCount = [5] // stacks[blade].baseline.quality.baseline.testCount
#let evBladeBaseAssertDensity = [1.00] // stacks[blade].baseline.quality.baseline.assertionDensity
#let evBladeBaseBrittle = [0.0%] // stacks[blade].baseline.quality.baseline.brittleLocatorRatio
#let evBladeBaseLocMix = [name: 10] // stacks[blade].baseline.quality.baseline.locatorDistribution (top-3)

#let evInertiaAssertDensity = [1.20] // stacks[inertia].quality.assertionDensity
#let evInertiaBrittle = [4.7%] // stacks[inertia].quality.brittleLocatorRatio
#let evInertiaRobustness = [72.4%] // stacks[inertia].quality.locatorRobustness
#let evInertiaLocMix = [label: 59, role: 22, css: 4] // stacks[inertia].quality.locatorDistribution (top-3)
#let evInertiaBaseTestCount = [5] // stacks[inertia].baseline.quality.baseline.testCount
#let evInertiaBaseAssertDensity = [1.00] // stacks[inertia].baseline.quality.baseline.assertionDensity
#let evInertiaBaseBrittle = [0.0%] // stacks[inertia].baseline.quality.baseline.brittleLocatorRatio
#let evInertiaBaseLocMix = [name: 10, role: 4] // stacks[inertia].baseline.quality.baseline.locatorDistribution (top-3)

#let evSauceAssertDensity = [1.16] // stacks[saucedemo].quality.assertionDensity
#let evSauceBrittle = [0.0%] // stacks[saucedemo].quality.brittleLocatorRatio
#let evSauceRobustness = [85.7%] // stacks[saucedemo].quality.locatorRobustness
#let evSauceLocMix = [role: 25] // stacks[saucedemo].quality.locatorDistribution (top-3)
#let evSauceBaseTestCount = [74] // stacks[saucedemo].baseline.quality.baseline.testCount
#let evSauceBaseAssertDensity = [1.34] // stacks[saucedemo].baseline.quality.baseline.assertionDensity
#let evSauceBaseBrittle = [62.5%] // stacks[saucedemo].baseline.quality.baseline.brittleLocatorRatio
#let evSauceBaseLocMix = [css: 10, testid: 3, role: 3] // stacks[saucedemo].baseline.quality.baseline.locatorDistribution (top-3)

// ---------- EQ5: reliability, efficiency, baseline (stacks[].reliability/efficiency/baseline) ----------
#let evBladeFlake = [0.5%] // stacks[blade].reliability.flakeRate
#let evBladeKappa = [1.00] // stacks[blade].reliability.crossBrowserKappa
#let evBladePassRate = [99.8%] // stacks[blade].reliability.passRate
#let evBladeCrawlSec = [36.5 s] // stacks[blade].efficiency.crawlMs
#let evBladeGenMs = [38 ms] // stacks[blade].efficiency.generateMs
#let evBladeExecSec = [1188 s $plus.minus$ 206 s] // stacks[blade].efficiency.executeMs (mean plus/minus CI95)
#let evBladePerTestSec = [11.4 s] // stacks[blade].efficiency.perTestMs
#let evBladeSavings = [25.5$times$ (12.7--38.2)] // stacks[blade].efficiency.timeSavingsRatio (+range)
#let evBladeMannWhitney = [$U$ = 57,734; $p$ < 0.001; $r$ = 0.50] // stacks[blade].baseline.durationMannWhitney (U, p, r)
#let evBladeVerdict = [3:4 (baseline)] // stacks[blade].baseline.verdict (wins gen:base, overall)

#let evInertiaFlake = [0.2%] // stacks[inertia].reliability.flakeRate
#let evInertiaKappa = [-0.00] // stacks[inertia].reliability.crossBrowserKappa
#let evInertiaPassRate = [99.9%] // stacks[inertia].reliability.passRate
#let evInertiaCrawlSec = [36.0 s] // stacks[inertia].efficiency.crawlMs
#let evInertiaGenMs = [35 ms] // stacks[inertia].efficiency.generateMs
#let evInertiaExecSec = [1272 s $plus.minus$ 60 s] // stacks[inertia].efficiency.executeMs (mean plus/minus CI95)
#let evInertiaPerTestSec = [12.2 s] // stacks[inertia].efficiency.perTestMs
#let evInertiaSavings = [23.9$times$ (11.9--35.8)] // stacks[inertia].efficiency.timeSavingsRatio (+range)
#let evInertiaMannWhitney = [$U$ = 61,529; $p$ < 0.001; $r$ = 0.46] // stacks[inertia].baseline.durationMannWhitney (U, p, r)
#let evInertiaVerdict = [3:3 (tied)] // stacks[inertia].baseline.verdict (wins gen:base, overall)

#let evSauceFlake = [0.0%] // stacks[saucedemo].reliability.flakeRate
#let evSauceKappa = [1.00] // stacks[saucedemo].reliability.crossBrowserKappa
#let evSaucePassRate = [96.2%] // stacks[saucedemo].reliability.passRate
#let evSauceCrawlSec = [4.9 s] // stacks[saucedemo].efficiency.crawlMs
#let evSauceGenMs = [12 ms] // stacks[saucedemo].efficiency.generateMs
#let evSauceExecSec = [213 s $plus.minus$ 10 s] // stacks[saucedemo].efficiency.executeMs (mean plus/minus CI95)
#let evSaucePerTestSec = [6.9 s] // stacks[saucedemo].efficiency.perTestMs
#let evSauceSavings = [42.6$times$ (21.3--64.0)] // stacks[saucedemo].efficiency.timeSavingsRatio (+range)
#let evSauceMannWhitney = [$U$ = 22,556; $p$ < 0.001; $r$ = 0.64] // stacks[saucedemo].baseline.durationMannWhitney (U, p, r)
#let evSauceVerdict = [4:2 (generated)] // stacks[saucedemo].baseline.verdict (wins gen:base, overall)
