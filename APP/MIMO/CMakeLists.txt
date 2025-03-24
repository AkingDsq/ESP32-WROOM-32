cmake_minimum_required(VERSION 3.16)

project(MIMO VERSION 0.1 LANGUAGES CXX)


set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)


qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appMIMO
    main.cpp
)

qt_add_qml_module(appMIMO
    URI MIMO
    VERSION 1.0
    QML_FILES
        Main.qml
        SOURCES call_ai.cpp call_ai.h
        QML_FILES components/BottonButtonChoose.qml
        QML_FILES components/Volume.qml
        QML_FILES components/LocalData.qml
        SOURCES cv_controller.h cv_controller.cpp
        RESOURCES android/AndroidManifest.xml android/build.gradle android/res/values/libs.xml android/res/xml/qtprovider_paths.xml android/gradle/wrapper/gradle-wrapper.jar android/gradle/wrapper/gradle-wrapper.properties android/gradle.properties android/gradlew android/gradlew.bat
        SOURCES imageprovider.h imageprovider.cpp
        QML_FILES components/camera.qml
        SOURCES speechrecognizer.h speechrecognizer.cpp
        SOURCES bluetoothcontroller.h bluetoothcontroller.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appMIMO PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appMIMO
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
    QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_SOURCE_DIR}/android"
)
#蓝牙相机麦克风
find_package(Qt6 REQUIRED COMPONENTS Core)

# 语音识别
find_package(Qt6 REQUIRED COMPONENTS TextToSpeech)

# opencv
#*set(OpenCV_DIR "D:/git/work/ESP32-WROOM-32/APP/MIMO/opencv4.10/build")
#find_package(OpenCV REQUIRED)
# 包含 OpenCV 头文件目录
#include_directories(${OpenCV_INCLUDE_DIRS} ${OpenCV_DIR}/include)

# 音视频
find_package(Qt6 REQUIRED COMPONENTS Multimedia)
# 蓝牙
find_package(Qt6 REQUIRED COMPONENTS Bluetooth)

target_link_libraries(appMIMO
    PRIVATE Qt6::Quick
    #${OpenCV_LIBS}  # 关联OpenCV库
    Qt6::TextToSpeech  # 语音识别
    PRIVATE Qt6::Core #添加蓝牙相机麦克风
    PRIVATE Qt6::Multimedia  # 音视频
    PRIVATE Qt6::Bluetooth #蓝牙
)

include(GNUInstallDirs)
install(TARGETS appMIMO
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)


