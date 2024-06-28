cmake_minimum_required(VERSION 3.16)

project(shvspym VERSION 0.1 LANGUAGES CXX)

#set(VERSION_NAME "1.0.1" CACHE STRING "App version name")
#set(VERSION_CODE 10001 CACHE INT "App version code")

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Network SerialPort WebSockets)

qt_standard_project_setup(REQUIRES 6.6)

if(CMAKE_BUILD_TYPE STREQUAL "Release")
    set(CMAKE_WIN32_EXECUTABLE ON) # Don't open a console window for Windows apps on Release mode.
endif()

add_subdirectory(3rdparty/necrolog)
set(WITH_BROKER OFF CACHE BOOL "")
set(WITH_VISU OFF CACHE BOOL "")
add_subdirectory(3rdparty/libshv)

set_source_files_properties(Style.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE )

qt_add_executable(appshvspym
	src/version.h
	src/main.cpp

	src/application.cpp
	src/rpcconnection.cpp
	src/brokerlistmodel.cpp
	src/subscriptionmodel.cpp
)

qt_add_qml_module(appshvspym
    URI shvspym
    VERSION 1.0
    QML_FILES
		Style.qml
		Main.qml
		MyButton.qml
		BrokerDelegate.qml
		BrokerProperties.qml
		BrokersPane.qml
		ShvPane.qml
		SessionPage.qml
		DeliveredSignalDelegate.qml
		SubscriptionDelegate.qml
		NodesRect.qml
		NodeDelegate.qml
		MethodsRect.qml
		MethodDelegate.qml
		TextViewPane.qml
		AboutDialog.qml

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
set_target_properties(appshvspym PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appshvspym
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
    QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android
	QT_ANDROID_TARGET_SDK_VERSION 33
	QT_ANDROID_VERSION_CODE 6
	QT_ANDROID_VERSION_NAME 0.0.6
)

#qt_finalize_executable(shvspym)

target_link_libraries(appshvspym
    PRIVATE Qt6::Quick libshviotqt
)

include(GNUInstallDirs)
install(TARGETS appshvspym
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
