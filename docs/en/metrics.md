# Metrics — from estimation to evidence

Closed stories and requirements can carry an `## Estimation` table. The installed metrics utility turns those tables into lead time, execution time, estimate/actual totals, and deviation. Automatic routing does not depend on metrics; this is optional delivery evidence.

## Estimation table

```markdown
## Estimation

| Milestone | Est. hours | Started | Finished | Actual hours | Notes |
|---|---:|---|---|---:|---|
| API contract | 2 | 2026-07-14 09:12 -03:00 | 2026-07-14 11:05 -03:00 | 1.8 | |
| Implementation | 4 | 2026-07-14 11:20 -03:00 | 2026-07-15 10:40 -03:00 | 4.5 | interrupted session |
```

The executor adds milestones and estimates before implementation. `Started`, `Finished`, and `Actual hours` are recorded during execution. Timestamps require a timezone offset.

With `"metrics": true`, Kiro hooks validate new timestamps in real time and prevent closing a measured item with an incomplete table. See [enforcement](enforcement.md).

## Run the report

From a workspace-installed project root:

```powershell
node .kiro/crew/bin/metrics.js
node .kiro/crew/bin/metrics.js 2026-07
node .kiro/crew/bin/metrics.js --csv
```

With only a global installation:

```powershell
node "$HOME/.kiro/crew/bin/metrics.js"
```

The script has no package dependencies. It scans `docs/stories/**` and `docs/requirements/**` for Closed items with parseable estimation data. A `YYYY-MM` argument filters by completion month; `--csv` writes `docs/work/metrics.csv`.

## Output

Per item:

| Measure | Meaning |
|---|---|
| Lead days | File creation to last `Finished`. |
| Execution hours | First `Started` to last `Finished`. |
| Estimated hours | Sum of milestone estimates. |
| Actual hours | Sum of reported work hours. |
| Deviation | `(actual - estimate) / estimate`. |

Aggregates include median and p90 execution time, average estimate deviation, and breakdowns by folder and month.

## Interpretation

- A large lead/execution gap indicates queue time, not slow execution.
- One deviation is noise; persistent average deviation is a calibration signal.
- A high p90 relative to the median suggests oversized or unpredictable milestones.
- Wall-clock execution includes pauses and review delays. `Actual hours` represents reported effort; do not compare people using wall-clock figures.

The report runs even when `metrics` is false, but only `metrics: true` provides hook-enforced timestamp discipline.
