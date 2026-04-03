# SenseCapture

A Qt/QML data acquisition app targeting iPhone. Uses Qt Multimedia, Sensors, and Positioning to capture audio, motion, and GPS data.

> **Current status:** scaffold. The UI shell is in place (fullscreen window, Record button). Sensor and recording logic is not yet wired up.

---

## Requirements

| Tool | Version |
|---|---|
| Qt | 6.7+ (Core, Gui, Quick, Multimedia, Sensors, Positioning) |
| CMake | 3.21+ |
| Xcode | 14+ (iOS builds only) |
| iOS deployment target | 16.0 |
| Apple Developer Team ID | Required for device deployment |

---

## Building

### Desktop (macOS) — for development and testing

```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build --parallel
```

Run the app:
```bash
./build/bin/SenseCapture
```

### iOS (Xcode)

Pass your Apple Team ID at configure time:

```bash
cmake -S . -B build-ios \
  -DCMAKE_SYSTEM_NAME=iOS \
  -DCMAKE_PREFIX_PATH=/path/to/Qt/6.x.x/ios \
  -DCMAKE_XCODE_ATTRIBUTE_DEVELOPMENT_TEAM=XXXXXXXXXX
cmake --build build-ios --parallel
```

This produces a `SenseCapture.app` bundle. Open the generated Xcode project to deploy to a device or simulator.

---

## Running tests

Tests cover compilation and QML structure. They run headless using Qt's offscreen platform.

```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build --parallel
QT_QPA_PLATFORM=offscreen ctest --test-dir build --output-on-failure
```

### What is tested

| Test | What it checks |
|---|---|
| `EngineSmokeTest` | QML loads without error; root object is created |
| `QmlBehaviorTests` | Window visible, title text, Record button exists, button press color |

### What is not tested in CI

- Microphone / audio recording (hardware)
- GPS / location data (hardware)
- Accelerometer / motion sensors (hardware)
- iOS-specific build and deployment

These must be validated manually on a physical device.

---

## CI

GitHub Actions runs on every push and pull request targeting `main`.

**Pipeline:** Install Qt → build (CMake/GCC) → run tests (offscreen)

Merging to `main` requires CI to pass. See `.github/workflows/ci.yml` for details.

---

## Project structure

```
SenseCapture/
├── main.cpp              # App entry point
├── main.qml              # Root UI (fullscreen window, Record button)
├── CMakeLists.txt        # Build configuration
├── ios/
│   └── Info.plist        # iOS permissions and bundle metadata
├── tests/
│   ├── CMakeLists.txt
│   ├── tst_engine.cpp    # C++ smoke test (QML load)
│   ├── tst_main_qml.qml  # Qt Quick Test (UI behavior)
│   └── qml_test_runner.cpp
└── .github/
    └── workflows/
        └── ci.yml
```

---

## iOS permissions

The following permissions are declared in `ios/Info.plist` and will be requested at runtime:

- **Microphone** — audio recording via Qt Multimedia
- **Location** — GPS data via Qt Positioning
- **Motion** — accelerometer/gyroscope via Qt Sensors
