find_package(Qt6 REQUIRED COMPONENTS Test QuickTest Quick)

# --- QML component tests (Qt Quick Test) ---
# Qt Quick Test uses a C++ runner entry point; the actual test cases live in tst_main_qml.qml
qt_add_executable(tst_main_qml
    qml_test_runner.cpp   # minimal runner that calls QUICK_TEST_MAIN
)

qt_add_qml_module(tst_main_qml
    URI SenseCapture       # must match the app's module URI so QML imports resolve
    VERSION 1.0
    QML_FILES
        tst_main_qml.qml
        # Also expose the main app QML so the test can import it
        ../main.qml
)

target_link_libraries(tst_main_qml PRIVATE
    Qt6::Test
    Qt6::QuickTest
    Qt6::Quick
)

add_test(NAME QmlBehaviorTests COMMAND tst_main_qml)

# --- C++ engine smoke test (QTest) ---
qt_add_executable(tst_engine
    tst_engine.cpp
)

qt_add_qml_module(tst_engine
    URI SenseCaptureEngine
    VERSION 1.0
    QML_FILES ../main.qml
)

target_link_libraries(tst_engine PRIVATE
    Qt6::Test
    Qt6::Quick
    Qt6::Gui
    Qt6::Core
)

add_test(NAME EngineSmokeTest COMMAND tst_engine)
