
# Market Engineering Model — Introduction Document

## Purpose of this document

This document defines the **Market Engineering Model** that will serve as the technical specification baseline for representing the electricity-market environment in which the BESS operates.

Its purpose is not to implement market software or to calculate the project's final financial metrics, but to **technically represent the market mechanisms, products, signals, rules, participation conditions, commitments, delivery requirements, and settlement mechanisms** that determine how a BESS can interact with the market.

The model must establish sufficient rigor that:

* Market opportunities can be represented consistently over the simulation horizon.
* The eligibility and operational requirements of each market product can be evaluated against the physical capabilities of the BESS.
* Market signals can be consumed by forecasting and dispatch models without redefining their meaning.
* Market commitments can be translated into explicit operational requirements.
* Delivered services can be mapped to the corresponding settlement mechanism.
* Results are traceable, verifiable, and comparable against historical data, market rules, or appropriate benchmarks.
* The later software implements **a market model that has already been defined**, rather than inventing market semantics during implementation.
* The financial layer receives well-defined market settlement outputs rather than attempting to reconstruct market rules internally.

The scope of this document is **strictly market engineering**: market structure, products, signals, eligibility, participation rules, commitments, delivery requirements, settlement logic, market constraints, and market-facing technical outputs.

BESS physics, degradation, software architecture, data pipelines, forecasting algorithms, and financial valuation are addressed in separate engineering domains.

---

# Organization principle: dependency layers

The Market Engineering Model is organized into **five parts**, defined by dependency layers.

Each part consumes only concepts established in earlier parts, while interfaces with BESS Engineering, Data/Input Engineering, Forecasting Engineering, Operational & Optimization Engineering, and Financial Engineering are explicitly declared.

This structure allows:

* independent development and validation of market components;
* controlled modification of market rules without redefining BESS physics;
* separation between market semantics and computational implementation;
* preservation of a single source of truth for market symbols, units, and conventions;
* explicit separation between market opportunity, market commitment, physical delivery, and settlement;
* traceability from an external market requirement or rule to its engineering representation.

The preliminary structure is:

| Part                                                         | Content                                                                                                                                                                                                       | Status              |
| ------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| **1. Market Fundamentals and Conventions**                   | Market system definition, market entities, temporal structure, market intervals, nodes, units, price and quantity conventions, master symbol table, scenarios, interfaces, traceability, open-items register  | **To be developed** |
| **2. Market Products and Participation**                     | Energy products, ancillary services, capacity mechanisms, demand response, tariffs where applicable, product definitions, eligibility, qualification, participation conditions, product-specific requirements | **To be developed** |
| **3. Market Signals and Uncertainty**                        | Energy prices, reserve/regulation signals, demand/tariff signals, market availability, forecasts interface, historical signals, scenarios, uncertainty representation                                         | **To be developed** |
| **4. Market Rules, Commitments and Operational Constraints** | Bidding/nomination, commitments, reserve requirements, response requirements, duration, availability, coexistence restrictions, non-performance conditions, market-to-BESS constraints                        | **To be developed** |
| **5. Delivery, Settlement and Market Outputs**               | Actual delivery, performance measurement, settlement logic, deviations, penalties where applicable, market settlement outputs, interfaces with Dispatch and Financial Engineering                             | **To be developed** |

The exact contents of each part remain subject to refinement during conceptual engineering and external market/RFP verification.

---

# Structural rules of the document

The following rules govern the Market Engineering Model.

### 1. Part 1 is the only authorized source of market symbols

All market quantities, states, parameters, signals, and derived quantities must be registered in the Part 1 master symbol table before use elsewhere.

No later part may silently introduce notation.

A symbol audit should verify:

* symbol registration;
* uniqueness;
* units;
* semantic definition;
* dimensional consistency;
* cross-part usage.

---

### 2. Market products use a common engineering template

Every market product must be described using a common structure:

1. Definition
2. Market purpose
3. Eligibility
4. Required BESS capability
5. Market signal
6. Participation mechanism
7. Commitment
8. Delivery requirement
9. Temporal requirements
10. Operational constraints
11. Interaction with other products
12. Settlement mechanism
13. Technical outputs
14. Risks and uncertainties

This prevents different market products from being modeled at inconsistent levels of abstraction.

---

### 3. Market feasibility is distinct from physical feasibility

The model shall explicitly distinguish:

$$
\text{Physical Capability}
$$

from:

$$
\text{Market Eligibility}
$$

and therefore:

$$
\boxed{
\text{Market-Available Capability}
=
f(
\text{Physical Capability},
\text{Market Rules}
)
}
$$

A BESS capability that is physically possible shall not automatically be considered commercially or operationally available in a market.

---

### 4. Market opportunity, commitment, delivery, and settlement are distinct concepts

The model shall maintain the following semantic sequence:

$$
\boxed{
Opportunity
\rightarrow
Commitment
\rightarrow
Dispatch
\rightarrow
Delivery
\rightarrow
Settlement
}
$$

These concepts must not be collapsed into a single "revenue" variable.

This distinction is essential for correct interaction with Operational/Optimization Engineering and Financial Engineering.

---

### 5. Every part declares its interface

Each part must explicitly state:

**Consumes**

What information it receives.

**Produces**

What information it provides.

For example:

```text
Market Engineering
        │
        ├──→ Forecasting Engineering
        │       Market variables requiring prediction
        │
        ├──→ Operational Engineering
        │       Market opportunities and constraints
        │
        ├──→ Dispatch Engineering
        │       Prices, signals, commitments, requirements
        │
        └──→ Financial Engineering
                Settlement quantities and market values
```

---

### 6. Market rules must be traceable to authoritative evidence

Where market participation depends on external rules, regulations, tariff structures, market manuals, RFP requirements, or other authoritative sources, the corresponding engineering representation must maintain a traceability reference.

Unverified assumptions must be explicitly marked as assumptions.

The model shall distinguish:

* verified market rule;
* engineering interpretation;
* modeling assumption;
* unresolved requirement.

---

### 7. Market Engineering does not select forecasting or optimization techniques

Market Engineering defines:

> **What market information exists and what information the downstream system requires.**

Forecasting Engineering determines:

> **How uncertain market variables are predicted.**

Operational & Optimization Engineering determines:

> **How available market opportunities are allocated against physical BESS constraints.**

This preserves the methodological separation between domain meaning and implementation technique.

---

### 8. Settlement logic does not become financial modeling

Market Engineering defines how market participation and delivery are recognized by the market.

Financial Engineering subsequently transforms those settlement outputs into:

* revenues;
* savings;
* costs;
* cash flows;
* NPV;
* IRR;
* payback.

Therefore:

$$
\boxed{
Market\ Settlement
\neq
Financial\ Model
}
$$

---

# Recommended engineering order

The recommended development order is:

### 1. Part 1 — Market Fundamentals and Conventions

Define the market domain, temporal structure, entities, conventions, symbols, scenarios, and interfaces.

### 2. Part 2 — Market Products and Participation

Define exactly which products/services are relevant and how participation works.

### 3. Part 3 — Market Signals and Uncertainty

Define the signals required by the operational model and their uncertainty representation.

### 4. Part 4 — Market Rules, Commitments and Operational Constraints

Translate participation rules into explicit engineering constraints and commitments.

### 5. Part 5 — Delivery, Settlement and Market Outputs

Define how actual operation becomes market-recognized delivery and settlement outputs.

The dependency chain is therefore:

$$
\boxed{
Fundamentals
\rightarrow
Products
\rightarrow
Signals
\rightarrow
Rules/Commitments
\rightarrow
Settlement
}
$$

---

# What this document does NOT cover

To avoid scope ambiguity, the following are explicitly outside the scope of Market Engineering:

* Python implementation;
* Databricks;
* PySpark;
* SQL;
* ETL architecture;
* data ingestion implementation;
* forecasting algorithms;
* optimization algorithms;
* solver selection;
* BESS physical equations;
* battery degradation;
* financial valuation;
* NPV;
* IRR;
* payback;
* software architecture;
* dashboard/UI design.

Market Engineering may **define requirements and interfaces** for these domains, but does not implement them.

---

# Interfaces with other engineering domains

Market Engineering has five principal interfaces.

## BESS Engineering → Market Engineering

BESS Engineering provides the physical capabilities against which market requirements are evaluated.

Examples include:

* available power;
* available energy;
* SOC;
* SOH;
* ramp capability;
* efficiency;
* thermal limitations;
* operating constraints.

The Market Model must not redefine these quantities.

---

## Market Engineering → Forecasting Engineering

Market Engineering identifies which external market variables require forecasts.

Examples:

* energy prices;
* reserve prices;
* regulation requirements;
* market availability;
* demand signals.

Forecasting Engineering determines how those variables are predicted.

---

## Market Engineering → Operational & Optimization Engineering

Market Engineering provides:

* market opportunities;
* prices/signals;
* eligibility;
* commitments;
* delivery requirements;
* market constraints;
* temporal requirements.

Operational Engineering combines these with BESS physical constraints.

---

## Operational & Optimization Engineering → Market Engineering

Operational Engineering provides:

* committed quantities;
* actual dispatch;
* delivered energy;
* reserve deployment;
* availability;
* performance.

Market Engineering maps these outputs to market delivery and settlement.

---

## Market Engineering → Financial Engineering

Market Engineering produces market-facing settlement outputs.

Financial Engineering transforms them into economic consequences.

The boundary is:

$$
\boxed{
Market\ Rules
\rightarrow
Settlement
\rightarrow
Financial\ Consequence
}
$$

---

# Success criteria

The Market Engineering Model will be considered complete when:

* The applicable market environment is explicitly defined.
* Every modeled market product has a complete and consistent engineering definition.
* Eligibility and participation requirements are explicit.
* Market signals and their temporal resolutions are defined.
* Market commitments are distinguishable from actual physical dispatch.
* Delivery requirements are explicit.
* Settlement mechanisms are defined sufficiently for downstream financial modeling.
* Market constraints can be translated into operational constraints.
* Interfaces with BESS, Forecasting, Operational/Optimization, and Financial Engineering are explicit.
* External market rules are traceable to authoritative sources.
* Assumptions and unresolved market requirements are explicitly identified.
* No market symbol is used without registration in Part 1.
* The model can be validated through appropriate historical, rule-based, or benchmark evidence.

---

# Validation principles

Market Engineering requires several forms of validation.

### Rule validation

Does the model correctly represent the applicable market rules?

### Semantic validation

Do the model's concepts correspond to actual market concepts?

### Temporal validation

Are market intervals, commitment periods, delivery periods, and settlement periods represented correctly?

### Eligibility validation

Does the model correctly determine whether the BESS can participate in a product?

### Settlement validation

Does simulated delivery produce the expected settlement result under reference cases?

### Historical validation

Where appropriate data are available, does the market model reproduce relevant historical market behavior and settlement outcomes?

---

# Uncertainty management

Market Engineering shall explicitly classify uncertainty.

### Requirement uncertainty

Uncertainty regarding what market behavior ENGIE requires the system to represent.

### Market-rule uncertainty

Uncertainty regarding applicable rules, eligibility, settlement, or participation mechanisms.

### Market-data uncertainty

Uncertainty regarding prices, demand, ancillary-service requirements, and other external signals.

### Model uncertainty

Uncertainty regarding whether the selected market representation adequately captures the real market mechanism.

These must not be conflated.

For example:

> An uncertain price forecast does not imply that the market settlement rule is uncertain.

Similarly:

> An ambiguous market rule should not be hidden inside a forecasting assumption.

---

# Current integration status

At the beginning of Market Engineering, the domain should be considered:

**Conceptually initiated — Engineering baseline not yet frozen.**

The BESS Engineering Model is treated as an upstream engineering dependency and should be consumed as the physical reference model.

The principal downstream dependencies are:

```text
BESS Engineering
       │
       ▼
Market Engineering
       │
       ├──────────────► Forecasting Engineering
       │
       ├──────────────► Operational Engineering
       │
       └──────────────► Financial Engineering
```

No market product, rule, settlement mechanism, or market-specific assumption should be considered frozen until its applicability and evidence have been established.

---

# Freeze principle

Market Engineering should not be frozen merely because the document has been written.

A market component becomes stable when:

$$
\boxed{
Semantic\ Definition
+
External\ Evidence
+
Engineering\ Validation
}
$$

are sufficient for the intended use.

The final baseline should therefore distinguish between:

* **Conceptually defined**
* **Internally consistent**
* **Externally verified**
* **Validated**
* **Frozen v1.0**

This distinction is particularly important because market rules and participation conditions are external to the BESS itself.

---

## Final conceptual boundary

The complete engineering relationship can be summarized as:

```text
                 BESS ENGINEERING
              "What can the asset do?"
                         │
                         ▼
                 PHYSICAL CAPABILITY
                         │
                         │
                         ▼
                 MARKET ENGINEERING
             "Under what conditions
              can it participate?"
                         │
          ┌──────────────┼──────────────┐
          ▼              ▼              ▼
       PRODUCTS        SIGNALS        RULES
          │              │              │
          └──────────────┼──────────────┘
                         ▼
                    COMMITMENT
                         │
                         ▼
                 OPERATIONAL DISPATCH
                         │
                         ▼
                      DELIVERY
                         │
                         ▼
                     SETTLEMENT
                         │
                         ▼
               FINANCIAL ENGINEERING
```

### Guiding principle

> **Market Engineering is the controlled transformation of an external electricity-market environment into a validated engineering representation of products, signals, eligibility, commitments, delivery requirements, and settlement mechanisms that can be consumed by operational and financial models without ambiguity.**

Así, **BESS Engineering queda como el modelo del “asset” y Market Engineering como el modelo del “environment”**. El siguiente paso metodológicamente correcto no sería escribir todavía `ME-1`, sino construir **Market Engineering — Level 1: Intent + Domain Model + Semantic Model**, y desde ahí derivar las cinco Parts.
