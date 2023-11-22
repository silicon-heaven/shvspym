cmake_minimum_required(VERSION 3.16)

project(shvspym VERSION 0.1 LANGUAGES CXX)

#set(VERSION_NAME "1.0.1" CACHE STRING "App version name")
#set(VERSION_CODE 10001 CACHE INT "App version code")

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Network SerialPort WebSockets)

qt_standard_project_setup(REQUIRES 6.5)

if(CMAKE_BUILD_TYPE STREQUAL "Release")
    set(CMAKE_WIN32_EXECUTABLE ON) # Don't open a console window for Windows apps on Release mode.
endif()

add_subdirectory(3rdparty/necrolog)
set(WITH_BROKER OFF CACHE BOOL "")
set(WITH_VISU OFF CACHE BOOL "")
add_subdirectory(3rdparty/libshv)

qt_add_executable(shvspym
	shvspym.qrc
	src/version.h
	src/main.cpp
	src/settings.cpp
	src/application.cpp
	src/rpcconnection.cpp
	src/brokerlistmodel.cpp
	src/subscriptionmodel.cpp
)

qt_add_qml_module(shvspym
    URI shvspymqml
    VERSION 1.0
    QML_FILES
		qml/Main.qml
		qml/MyButton.qml
		qml/BrokerDelegate.qml
		qml/BrokerProperties.qml
		qml/BrokersPane.qml
		qml/ShvPane.qml
		qml/SessionPage.qml
		qml/DeliveredSignalDelegate.qml
		qml/SubscriptionDelegate.qml
		qml/NodesRect.qml
		qml/NodeDelegate.qml
		qml/MethodsRect.qml
		qml/MethodDelegate.qml
		qml/TextViewPane.qml
		qml/AboutDialog.qml

	RESOURCES
		images/shvspy.svg
		images/pencil.svg
		images/back.svg
		images/ok.svg
		images/goto-root.svg
		images/connect.svg
		images/plus.svg
		images/eye.svg
		images/menu.svg
		images/copy.svg
		images/play.svg
		images/params.svg
		images/params-some.svg
		images/methods.svg
		images/nodes.svg
		images/subscription.svg
		images/subscription-active.svg
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(shvspym PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.shvspym
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
    QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android
    QT_ANDROID_TARGET_SDK_VERSION 33
)

#qt_finalize_executable(shvspym)

target_link_libraries(shvspym
    PRIVATE Qt6::Quick libshviotqt
)

include(GNUInstallDirs)
install(TARGETS shvspym
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
