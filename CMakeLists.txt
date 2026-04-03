cmake_minimum_required(VERSION 3.21)

project(SenseCapture VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Qt6 is required; find the modules we need
find_package(Qt6 REQUIRED COMPONENTS
    Core
    Gui
    Quick
    Multimedia
    Sensors
    Positioning
)

qt_standard_project_setup()

# Define the executable as a GUI/bundle app (required for iOS)
qt_add_executable(SenseCapture
    MACOSX_BUNDLE
    main.cpp
)

# Embed QML files into the binary via Qt's resource system
qt_add_qml_module(SenseCapture
    URI SenseCapture
    VERSION 1.0
    QML_FILES main.qml
)

# Link Qt modules
target_link_libraries(SenseCapture PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Quick
    Qt6::Multimedia
    Qt6::Sensors
    Qt6::Positioning
)

# Enable CTest and include the tests subdirectory
enable_testing()
add_subdirectory(tests)

# --- iOS-specific settings ---
if(CMAKE_SYSTEM_NAME STREQUAL "iOS")
    # Point to custom Info.plist with permission usage descriptions
    set_target_properties(SenseCapture PROPERTIES
        MACOSX_BUNDLE_INFO_PLIST "${CMAKE_SOURCE_DIR}/ios/Info.plist"

        # Fill in your Apple Team ID here or pass via -DCMAKE_XCODE_ATTRIBUTE_DEVELOPMENT_TEAM=XXXXXXXXXX
        XCODE_ATTRIBUTE_DEVELOPMENT_TEAM ""

        # Require a real device or simulator deployment target
        XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "16.0"
    )
endif()
