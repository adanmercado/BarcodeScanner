QT += quick
CONFIG += c++11 qzxing_multimedia

DEFINES += QT_DEPRECATED_WARNINGS
SOURCES += \
        main.cpp

RESOURCES += qml.qrc

qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

#Se incluye el módulo QZXing, descargarlo previamente en la carpeta 3rdparty
include($$PWD/3rdparty/QZXing/src/QZXing.pri)

android {
    DISTFILES += \
        android/AndroidManifest.xml \
        android/gradle/wrapper/gradle-wrapper.jar \
        android/gradlew \
        android/res/values/libs.xml \
        android/build.gradle \
        android/gradle/wrapper/gradle-wrapper.properties \
        android/gradlew.bat

    contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
        ANDROID_PACKAGE_SOURCE_DIR = \
            $$PWD/android
    }
}
