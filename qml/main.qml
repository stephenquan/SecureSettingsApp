import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import StephenQuan.SecureSettingsApp 1.0

ApplicationWindow {
    id: window
    width: 640
    height: 480
    visible: true
    title: qsTr("Secured Settings App")

    QtObject {
        id: styles

        property int textPointSize: 12
    }

    Page {
        anchors.fill: parent

        Flickable {
            id: flickable

            anchors.fill: parent
            anchors.margins: 10

            contentWidth: columnLayout.width
            contentHeight: columnLayout.height
            clip: true

            ColumnLayout {
                id: columnLayout

                width: flickable.width

                TextField {
                    id: keyTextField

                    Layout.fillWidth: true

                    font.pointSize: styles.textPointSize
                    placeholderText: qsTr("Key")
                    selectByMouse: true
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                }

                TextField {
                    id: valueTextField

                    Layout.fillWidth: true

                    font.pointSize: styles.textPointSize
                    placeholderText: qsTr("Value")
                    selectByMouse: true
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                }

                Text {
                    Layout.fillWidth: true

                    visible: secureSettings.status != 0
                    text: secureSettings.statusText
                    font.pointSize: styles.textPointSize
                    color: "red"
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                }
            }
        }

        footer: Frame {
            RowLayout {
                width: parent.width

                Button {
                    text: qsTr("Set")

                    font.pointSize: styles.textPointSize

                    onClicked: doSet()
                }

                Button {
                    text: qsTr("Get")

                    font.pointSize: styles.textPointSize

                    onClicked: doGet()
                }

                Button {
                    text: qsTr("Delete")

                    font.pointSize: styles.textPointSize

                    onClicked: doDelete()
                }

                Item {
                    Layout.fillWidth: true
                }
            }
        }
    }

    SecureSettings {
        id: secureSettings
    }

    function doSet() {
        let key = keyTextField.text;
        let value = valueTextField.text;
        secureSettings.setValue(key, value);
    }

    function doGet() {
        let key = keyTextField.text;
        let value = secureSettings.value(key);
        valueTextField.text = value;
    }

    function doDelete() {
        let key = keyTextField.text;
        secureSettings.deleteValue(key);
        valueTextField.text = "";
    }
}
