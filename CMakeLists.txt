cmake_minimum_required(VERSION 3.16)

project(swproject VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)

qt_standard_project_setup()

qt_add_executable(appswproject
    main.cpp
)

qt_add_qml_module(appswproject
    URI swproject
    VERSION 1.0
    QML_FILES Main.qml
    QML_FILES StartPage.qml
    QML_FILES SearchPage.qml
    QML_FILES game/GamePage.qml
    QML_FILES game/Tile.qml
    QML_FILES
    SOURCES game/tilecontrol.h game/tilecontrol.cpp
    QML_FILES game/Effect.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appswproject PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appswproject
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appswproject
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appswproject
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
