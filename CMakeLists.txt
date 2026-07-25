cmake_minimum_required(VERSION 3.14)

project(Flightgear_Delta VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 REQUIRED COMPONENTS Core Quick LinguistTools QuickControls2 Quick3D)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Quick LinguistTools QuickControls2 Quick3D)

set(TS_FILES Flightgear_Delta_en_US.ts
    Flightgear_Delta_ru_RU.ts)

set(PROJECT_SOURCES
    main.cpp
    qml.qrc
    ${TS_FILES}
)

set(QML_IMPORT_PATH "/usr/lib/x86_64-linux-gnu/qt6/qml" CACHE STRING "" FORCE)

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(Flightgear_Delta
        MANUAL_FINALIZATION
        ${PROJECT_SOURCES}
        core/launchmanager.cpp core/launchmanager.h
        images.qrc
    )
# Define target properties for Android with Qt 6 as:
#    set_property(TARGET Flightgear_Delta APPEND PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR
#                 ${CMAKE_CURRENT_SOURCE_DIR}/android)
# For more information, see https://doc.qt.io/qt-6/qt-add-executable.html#target-creation

    qt_create_translation(QM_FILES ${CMAKE_SOURCE_DIR} ${TS_FILES})
    add_custom_target(translations ALL DEPENDS ${QM_FILES})
else()
    if(ANDROID)
        add_library(Flightgear_Delta SHARED
            ${PROJECT_SOURCES}
        )
# Define properties for Android with Qt 5 after find_package() calls as:
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
    else()
        add_executable(Flightgear_Delta
          ${PROJECT_SOURCES}
          core/launchmanager.h core/launchmanager.cpp
          images.qrc
        )
    endif()

    qt5_create_translation(QM_FILES ${CMAKE_SOURCE_DIR} ${TS_FILES})
    add_custom_target(translations ALL DEPENDS ${QM_FILES})
endif()

target_link_libraries(Flightgear_Delta
  PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Quick Qt${QT_VERSION_MAJOR}::Quick3D)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
if(${QT_VERSION} VERSION_LESS 6.1.0)
  set(BUNDLE_ID_OPTION MACOSX_BUNDLE_GUI_IDENTIFIER com.example.Flightgear_Delta)
endif()
set_target_properties(Flightgear_Delta PROPERTIES
    ${BUNDLE_ID_OPTION}
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

include(GNUInstallDirs)
install(TARGETS Flightgear_Delta
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})

if(QT_VERSION_MAJOR EQUAL 6)
    qt_import_qml_plugins(Flightgear_Delta)
    qt_finalize_executable(Flightgear_Delta)
endif()
