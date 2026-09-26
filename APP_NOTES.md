# JE X FYZ APP — PROJECT MEMORY / ENGINEERING NOTES

> **Purpose:** Persistent project memory for the **JE X FYZ / JE Cooler Flutter application only**.
>
> This document is intentionally detailed. It exists so future work can continue from the verified project history without repeatedly asking the user to explain the same architecture, UI rules, BLE behavior, CI history, known bugs, and design decisions.
>
> **IMPORTANT:** This document is an app-only note. Firmware implementation details are intentionally kept out of this file. Only app-side BLE/API contracts that the app must consume are recorded where necessary.

---

> Current firmware handoff (2026-09-26): The firmware source is V4.1 and the firmware CI baseline is stable Arduino-ESP32 Core 3.3.12. The App BLE P1 contract remains unchanged; no Flutter protocol rewrite is required for the firmware OTA version-bump test. Firmware Build Run #25 completed successfully and published V4.1 to the public firmware repository. This V4.1 package is intended as the online OTA test target.

## 0. HOW THIS FILE MUST BE USED

This file is part of the project and should be treated as a **living engineering memory**.

### Mandatory rule

### Cross-sub-chat continuity rule
