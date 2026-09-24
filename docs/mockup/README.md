# Concept Prototype — BESS Operational & Financial Model

Interactive concept prototype demonstrating the causal chain of the BESS Operational & Financial Modeling System.

## Access

Open `index.html` in any modern browser, or visit:

https://danacioDS.github.io/EngieBess/mockup/

## What this demonstrates

- Scenario configuration
- Data ingestion and validation
- Market / value-stream representation
- Dispatch optimization (priority heuristic)
- Degradation feedback loop
- Tariff engine and market settlement
- Financial valuation (NPV, IRR, payback)
- Traceability from RFP to results

## What this does not demonstrate

- LP co-optimization (the delivered engine uses LP, per PH-034)
- 15-minute time resolution (this prototype uses hourly, per PH-054)
- Market-specific adapter depth (this prototype uses PJM as illustrative)
- Production-scale execution (this prototype runs in the browser)

## Reference market

PJM / BGE zone, behind-the-meter configuration, with synthetic data.

## Engineering baseline

The prototype is derived from the engineering baseline:

- Stage A — Engineering Definition
- Stage B — System Architecture (HLD)
- Stage C — Product Specification

See `/docs/Stage-A-engineering-definition/`, `/docs/Stage-B-system-architecture/`, and `/docs/Stage-C-product-specification/`.

## Version

v1 — Concept prototype for the ENGIE proposal (RFP-264144-1).
