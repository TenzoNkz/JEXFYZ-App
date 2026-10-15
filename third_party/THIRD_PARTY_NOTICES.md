# JE Cooler Android third-party notices

This release uses the following Android runtime components relevant to Wireless Debugging pairing:

## Kadb 1.3.0

- Upstream: https://github.com/flyfishxu/Kadb/tree/1.3.0
- Maven coordinate: `com.flyfishxu:kadb:1.3.0`
- License: Apache License 2.0. The copy is retained at `third_party/Kadb-1.3.0-LICENSE.txt`.

## SPAKE2-Java 1.0.5

- Upstream: https://github.com/Flyfish233/spake2-java/tree/1.0.5
- Maven coordinate (transitive): `com.github.Flyfish233:spake2-java:1.0.5`
- License: GNU General Public License v3.0 (GPL-3.0). A full license copy is retained at `third_party/spake2-java-1.0.5-GPL-3.0.txt` and is included in the APK assets at `assets/licenses/spake2-java-GPL-3.0.txt`.
- The automated release packages a corresponding-source ZIP for the same App commit, plus upstream Kadb 1.3.0 and SPAKE2-Java 1.0.5 source trees. The source asset is delivered alongside the APK through the same private GitHub Release; it does not make this repository public.

The source bundle records the exact App commit used for the APK. This inventory is a technical notice and is not a substitute for independent legal review of distribution terms.
