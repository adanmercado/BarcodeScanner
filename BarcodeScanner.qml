import QtQuick 2.12
import QtQuick.Controls 2.5
import QtMultimedia 5.12

import QZXing 2.3

Rectangle {
    id: rect
    anchors.fill: parent
    color: "black"

    property bool flashEnabled: false

    SoundEffect {
        id: scannerSound
        source: "sounds/Beep.wav"
    }

    Camera {
        id: camera
        focus {
            focusMode: CameraFocus.FocusContinuous
            focusPointMode: CameraFocus.FocusPointAuto
        }

        flash {
            onSupportedModesChanged: {
                if(flash.supportedModes.length <= 1) {
                    flashRect.visible = false;
                    console.log("El dispositivo no cuenta con soporte para flash");
                }
            }
        }
    }

    VideoOutput {
        id: videoOutput
        source: camera
        anchors.fill: parent
        autoOrientation: true
        fillMode: VideoOutput.Stretch
        filters: [zxingFilter]

        Image {
            id: captureRect
            source: "imgs/capture-rect.png"
            height: Math.round(Math.min(rect.width, rect.height) / 6 * 3.5)
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
        }

        Rectangle {
            id: topRect
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: captureRect.top
            anchors.right: parent.right
            color: "black"
            opacity: 0.6

            Label {
                text: qsTr("Alinea el código de barras dentro de la zona del escáner.")
                wrapMode: Label.WrapAtWordBoundaryOrAnywhere
                anchors.fill: parent
                anchors.topMargin: 10
                anchors.bottomMargin: 10
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "white"
            }
        }

        Rectangle {
            id: bottomRect
            anchors.top: captureRect.bottom
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            color: "black"
            opacity: 0.6

            Rectangle {
                id: flashRect
                width: 200
                height: 30
                anchors.centerIn: parent
                radius: 10
                border.width: 2
                border.color: "white"
                color: "transparent"

                Label {
                    text: qsTr("Activar iluminación")
                    color: "white"
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        if(flashEnabled) {
                            camera.flash.mode = Camera.FlashOff
                            parent.color = "transparent"
                        } else {
                            camera.flash.mode = Camera.FlashVideoLight
                            parent.color = "white"
                        }
                        flashEnabled = !flashEnabled
                    }
                }
            }
        }

        Rectangle {
            id: leftRect
            anchors.top: topRect.bottom
            anchors.left: parent.left
            anchors.right: captureRect.left
            anchors.bottom: bottomRect.top
            color: "black"
            opacity: 0.6
        }

        Rectangle {
            id: rightRect
            anchors.top: topRect.bottom
            anchors.left: captureRect.right
            anchors.right: parent.right
            anchors.bottom: bottomRect.top
            color: "black"
            opacity: 0.6
        }
    }

    QZXingFilter {
        id: zxingFilter
        captureRect: {
            videoOutput.contentRect;
            videoOutput.sourceRect;
            return videoOutput.mapRectToSource(captureRect)
        }

        decoder {
            enabledDecoders: QZXing.DecoderFormat_EAN_13 | QZXing.DecoderFormat_CODE_39 | QZXing.DecoderFormat_QR_CODE

            onTagFound: {
                scannerSound.play()
                barcodeDialog.barcodeText = tag
                barcodeDialog.open()
            }

            tryHarder: false
        }
    }

    Dialog {
        id: barcodeDialog
        anchors.centerIn: parent
        width: Math.round(Math.min(parent.width, parent.height) / 3 * 2)
        title: qsTr("Código detectado")
        property alias barcodeText: barcodeLabel.text
        modal: true
        standardButtons: Dialog.Close

        Label {
            id: barcodeLabel
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }
    }
}
