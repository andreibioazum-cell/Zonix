import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.quick 2.0 as PlasmaQuick
import org.kde.plasma.plasmoid 2.0 as Plasmoid

PlasmaQuick.Panel {
    id: panel
    width: Plasmoid.formFactor === PlasmaCore.Types.Horizontal ? Plasmoid.configuration.read("panelWidth", 1920) : 300
    height: Plasmoid.formFactor === PlasmaCore.Types.Horizontal ? Plasmoid.configuration.read("panelHeight", 48) : 1080

    property bool showFirefox: true

    Rectangle {
        id: panelBackground
        anchors.fill: parent
        color: "#1a1a2e"
        border.color: "#2a2a3a"
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 16

            // Start menu button
            PlasmaComponents.ToolButton {
                id: startButton
                text: "🍎 Zonix"
                icon.name: "start-here-kde"
                highlighted: true
                onClicked: startMenu.popup()
            }

            PlasmaComponents.Separator {
                orientation: Qt.Vertical
                height: 24
            }

            // Window title
            Text {
                id: windowTitle
                text: "Рабочий стол Zonix"
                color: "#e0e0e0"
                font.family: "Noto Sans"
                font.pointSize: 12
                elide: Text.ElideRight
                Layout.fillWidth: true
                verticalAlignment: Text.AlignVCenter
            }

            // Firefox quick launch
            PlasmaComponents.ToolButton {
                id: firefoxLaunch
                text: "🦊 Firefox"
                icon.name: "firefox"
                highlighted: root.showFirefox
                onClicked: Qt.openUrlExternally("firefox")
                visible: root.showFirefox
            }

            PlasmaComponents.Separator {
                orientation: Qt.Vertical
                height: 24
                visible: root.showFirefox
            }

            // System indicators
            RowLayout {
                spacing: 12

                PlasmaComponents.ToolButton {
                    id: wifiBtn
                    icon.name: "network-wireless-signal-excellent"
                    highlighted: true
                    tooltip: "Wi-Fi: Подключено"
                }

                PlasmaComponents.ToolButton {
                    id: volumeBtn
                    icon.name: "audio-volume-high"
                    highlighted: true
                    tooltip: "Звук: 75%"
                }

                PlasmaComponents.ToolButton {
                    id: batteryBtn
                    icon.name: "battery-full-charged"
                    highlighted: true
                    tooltip: "Батарея: 100%"
                }

                PlasmaComponents.ToolButton {
                    id: powerBtn
                    icon.name: "system-shutdown"
                    highlighted: true
                    tooltip: "Завершение работы"
                    onClicked: powerMenu.popup()
                }
            }
        }
    }

    // Start menu popup
    PlasmaQuick.Dialog {
        id: startMenu
        x: startButton.x
        y: startButton.y + startButton.height
        width: 350
        height: 500
        modal: true
        closeOnEscape: true

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            // User profile section
            Rectangle {
                Layout.fillWidth: true
                height: 80
                color: "#2a2a3a"
                radius: 8

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 12

                    Rectangle {
                        width: 56
                        height: 56
                        color: "#3daee9"
                        radius: 28
                        Image {
                            anchors.fill: parent
                            source: "image://theme/user-avatar"
                            fillMode: Image.PreserveAspectCrop
                        }
                    }

                    ColumnLayout {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 4

                        Text {
                            text: "Пользователь Zonix"
                            color: "#e0e0e0"
                            font.family: "Noto Sans"
                            font.bold: true
                            font.pointSize: 13
                        }

                        Text {
                            text: "zonix@zonix-os"
                            color: "#a0a0a0"
                            font.family: "Noto Sans"
                            font.pointSize: 10
                        }
                    }
                }
            }

            PlasmaComponents.Separator {
                Layout.fillWidth: true
            }

            Text {
                text: "Быстрый запуск"
                color: "#3daee9"
                font.family: "Noto Sans"
                font.bold: true
                font.pointSize: 14
            }

            PlasmaComponents.ToolButton {
                text: "🦊 Firefox"
                textAlign: Text.AlignLeft
                Layout.fillWidth: true
                icon.name: "firefox"
                onClicked: {
                    Qt.openUrlExternally("firefox")
                    startMenu.close()
                }
            }

            PlasmaComponents.ToolButton {
                text: "📁 Dolphin"
                textAlign: Text.AlignLeft
                Layout.fillWidth: true
                icon.name: "folder"
                onClicked: {
                    Qt.openUrlExternally("dolphin")
                    startMenu.close()
                }
            }

            PlasmaComponents.ToolButton {
                text: "💬 Сообщения"
                textAlign: Text.AlignLeft
                Layout.fillWidth: true
                icon.name: "im-user"
            }

            PlasmaComponents.ToolButton {
                text: "📷 Изображения"
                textAlign: Text.AlignLeft
                Layout.fillWidth: true
                icon.name: "image"
            }

            PlasmaComponents.Separator {
                Layout.fillWidth: true
            }

            Text {
                text: "Система"
                color: "#3daee9"
                font.family: "Noto Sans"
                font.bold: true
                font.pointSize: 14
            }

            PlasmaComponents.ToolButton {
                text: "⚙️ Параметры системы"
                textAlign: Text.AlignLeft
                Layout.fillWidth: true
                icon.name: "preferences-system"
                onClicked: {
                    Qt.openUrlExternally("systemsettings")
                    startMenu.close()
                }
            }

            PlasmaComponents.ToolButton {
                text: "📊 Монитор системы"
                textAlign: Text.AlignLeft
                Layout.fillWidth: true
                icon.name: "utilities-system-monitor"
            }

            PlasmaComponents.Separator {
                Layout.fillWidth: true
            }

            PlasmaComponents.ToolButton {
                text: "⏻ Выключить"
                textAlign: Text.AlignLeft
                Layout.fillWidth: true
                icon.name: "system-shutdown"
                onClicked: {
                    Qt.openUrlExternally("systemctl poweroff")
                    startMenu.close()
                }
            }

            PlasmaComponents.ToolButton {
                text: "🔄 Перезагрузить"
                textAlign: Text.AlignLeft
                Layout.fillWidth: true
                icon.name: "system-reboot"
                onClicked: {
                    Qt.openUrlExternally("systemctl reboot")
                    startMenu.close()
                }
            }
        }
    }

    // Power dialog
    PlasmaQuick.Dialog {
        id: powerDialog
        width: 250
        height: 180
        modal: true
        closeOnEscape: true

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 16

            Text {
                text: "Завершение работы"
                color: "#e0e0e0"
                font.family: "Noto Sans"
                font.bold: true
                font.pointSize: 16
                anchors.horizontalCenter: parent.horizontalCenter
            }

            PlasmaComponents.ToolButton {
                text: "🔴 Выключить компьютер"
                textAlign: Text.AlignCenter
                Layout.fillWidth: true
                onClicked: {
                    Qt.openUrlExternally("systemctl poweroff")
                    powerDialog.close()
                }
            }

            PlasmaComponents.ToolButton {
                text: "🔄 Перезагрузить компьютер"
                textAlign: Text.AlignCenter
                Layout.fillWidth: true
                onClicked: {
                    Qt.openUrlExternally("systemctl reboot")
                    powerDialog.close()
                }
            }

            PlasmaComponents.ToolButton {
                text: "⏹ Отмена"
                textAlign: Text.AlignCenter
                Layout.fillWidth: true
                onClicked: powerDialog.close()
            }
        }
    }

    Component {
        id: desktopIconComponent
        PlasmaComponents.ToolButton {
            icon.name: iconName
            text: label
            textAlign: Text.AlignCenter
            iconSize: 48
            tooltip: label
            onClicked: onActivated()
        }
    }
}
