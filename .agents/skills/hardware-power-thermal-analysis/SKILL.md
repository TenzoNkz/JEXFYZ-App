---
name: hardware-power-thermal-analysis
description: Use for JE Cooler electrical/power design, USB-C PD sources, buck converters, Peltier loads, MOSFET PWM, ripple/EMI, thermal design, component sizing, or datasheet-based hardware comparisons.
---

# Hardware, Power and Thermal Analysis

## Objective
Produce engineering-grade comparisons and calculations grounded in primary datasheets and clearly stated measurement conditions.

## Procedure
1. Draw the complete power path: source/USB-C PD negotiation → trigger/decoy → converter → protection/switching → load → return path. Identify each voltage/current/power boundary.
2. Separate continuous ratings, peak ratings, thermal derating, switching limits and marketing claims. Never assume a module's advertised current is continuous without thermal data.
3. Retrieve the exact component datasheet/revision and vendor documentation. Prefer manufacturer datasheets, reference designs and measured test reports over marketplace listing copy.
4. Calculate input/output power and current with efficiency assumptions stated explicitly: Pout = Vout × Iout; Pin ≈ Pout / efficiency; Iin ≈ Pin / Vin. Check connector, wire, PCB copper, inductor, diode/MOSFET and thermal limits.
5. For converters, inspect input range, output range, continuous current at real airflow/temperature, switching frequency, compensation, inductor saturation, current limit, over-temperature protection and ripple measurement bandwidth/load conditions.
6. For MOSFET PWM, verify gate-drive voltage, RDS(on) at that gate voltage, SOA, switching loss, conduction loss, thermal resistance, gate charge, frequency and transient protection. Do not equate current rating at ideal case temperature with board-level capability.
7. For ripple/EMI/ghost-touch concerns, distinguish differential ripple, common-mode noise, ground bounce, cable radiation and capacitive coupling. Explain which measurement (scope probe method, bandwidth, load and grounding) can test each hypothesis.
8. For Peltier cooling, consider hot-side heat rejection, thermal interface, heatsink/fan capacity, clamping pressure, condensation, insulation and sensor location. Electrical power alone does not guarantee cooling performance.
9. Provide uncertainty ranges when efficiency or real module behavior is unknown. State assumptions and ask for exact markings/photos only when identification materially changes the conclusion.
10. Include conservative thermal derating and fault behavior; identify fuse/current-limit, reverse-polarity and thermal protection needs without implying the prototype is certified.

## Required output
- Block diagram and assumptions.
- Equations with units and worked numbers.
- Datasheet-backed comparison table with source citations.
- Thermal/current/ripple risk and what must be measured.
- Recommendation with confidence and explicit unknowns.

## Guardrails
Never invent datasheet values from a product title/photo. Do not guide unsafe mains-side modifications. Treat marketplace ratings as unverified until corroborated.
