# JE X FYZ — BUILD NOTES

## APP BUILD POLICY
- App Build is explicit and separate from Firmware build/flash.
- Manual issue trigger only.
- Issue title: JE X FYZ — BUILD APP TRIGGER
- Required token: JEXFYZ_BUILD_TRIGGER_V1
- One normal APK, not a Play Store bundle.
- Java 17 / Flutter 3.47.2 stable / Gradle 9.3.1 / ubuntu-24.04.
- Production signing certificate SHA256:
  dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0

## LATEST VERIFIED APP BUILD — #50
- Run: 36996987220
- Source commit: bf01595253eb5a1912471c4aee57c4eed4421f0f
- Result: SUCCESS
- APK artifact ID: 11222007634
- APK size: 54,245,456 bytes
- APK SHA256: 82a2320d8e3663800d6884f4cb0d009ff1b31b5b19cc64420f9ee5c6b01d01b0
- Symbols artifact ID: 11222132522
- Symbols SHA256: a87a3181bada92e229da3c1f79d9a59339d7669c11b32ac1d8c219ae435c9062
- Security audit: PASS
- Dependency checks: PASS
- Architecture/static analysis: PASS
- Tests: PASS
- Packaging: PASS
- Signing/certificate verification: PASS

## WORKFLOWS
- App workflow: .github/workflows/app-build.yml
- App workflow blob: 731f4a7a43bf58d01a382053457d1f67a4742c8a
- Trigger workflow: .github/workflows/app-build-trigger.yml
- Trigger blob: 89598aff0b006bb3db6819080a13965fc5a6247d

## CURRENT BUILD BOUNDARY
- Build #50 validates only its exact App source commit.
- It does not validate later App commits, Firmware, Firebase state, or hardware.
- V4.4 is Firmware-only; no new App Build is required.
