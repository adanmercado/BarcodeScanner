import QtQuick 2.12
import QtQuick.Controls 2.5

ApplicationWindow {
    visible: true
    width: 400
    height: 600
    title: qsTr("BarcodeScanner Example")
    visibility: "Maximized"

    header: ToolBar {
        id: appToolbar
        visible: true
        height: 60

        Label {
            id: titleLabel
            anchors.fill: parent
            anchors.leftMargin: 10
            text: qsTr("BarcodeScanner Example")
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 18
            font.bold: true
        }

        ToolButton {
            id: menuButton
            //text: qsTr("\u205D")
            text: qsTr("\u2D57")
            font.pointSize: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            onClicked: optionsMenu.open()

            Menu {
                id: optionsMenu
                x: parent.width - width
                transformOrigin: Menu.TopRight

                MenuItem {
                    text: qsTr("Acerca de")
                    onTriggered: aboutDialog.open()
                }
            }
        }
    }

    BarcodeScanner {
    }

    Dialog {
        id: aboutDialog
        modal: true
        focus: true
        title: qsTr("Acerca de")
        anchors.centerIn: parent
        standardButtons: Dialog.Ok
        width: Math.min(parent.width, parent.height) / 3 * 2
        contentHeight: aboutLabel.height

        Label {
            id: aboutLabel
            width: aboutDialog.availableWidth
            text: "BarcodeScanner Example\n" +
                  "Autor: Adán Eliel Mercado Peralta\n" +
                  "https://github.com/adanmercado/BarcodeScanner\n\n" +
                  "Bibliotecas de terceros\n" +
                  "QZXing\n" +
                  "https://github.com/ftylitak/qzxing"
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pointSize: 14
        }
    }
}
