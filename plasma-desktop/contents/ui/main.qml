import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.quick 2.0 as PlasmaQuick
import org.kde.plasma.plasmoid 2.0 as Plasmoid

PlasmaQuick.View {
    id: root
    width: Plasmoid.formFactor === PlasmaCore.Types.Horizontal ? Plasmoid.configuration.read("panelWidth", 1920) : 1080
    height: Plasmoid.formFactor === PlasmaCore.Types.Horizontal ? Plasmoid.configuration.read("panelHeight", 30) : Plasmoid.configuration.read("panelHeight", 1920)

    property bool showFirefox: true

    // Desktop background
    Item {
        id: desktopBackground
        anchors.fill: parent

        Image {
            id: wallpaper
            source: "file://" + Plasmoid.configuration.read("wallpaperPath", "/usr/share/zonix/assets/wallpaper-zonix-purple.png")
            fillMode: Image.PreserveAspectCrop
            anchors.fill: parent
            sourceSize.width: root.width
            sourceSize.height: root.height
        }

        // Dark overlay for better text readability
        Rectangle {
            color: "#0a0a0a"
            opacity: 0.3
            anchors.fill: parent
        }

        // Zonix logo in center
        Item {
            anchors.centerIn: parent
            opacity: 0.4

            Rectangle {
                width: 120
                height: 120
                color: "#3daee9"
                radius: 20
                rotation: 45
                layer.enabled: true
                layer.effect: Reflection {
                    samples: 8
                    margin: 12
                    opacity: 0.5
                    color: "#3daee9"
                }
            }

            Text {
                text: "ZONIX"
                color: "#ffffff"
                font.family: "Noto Sans"
                font.bold: true
                font.pointSize: 32
                anchors.centerIn: parent
            }
        }
    }

    // Top panel
    Rectangle {
        id: topPanel
        width: parent.width
        height: 48
        color: "#1a1a2e"
        border.color: "#2a2a3a"
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 16

            // Application launcher (start menu)
            PlasmaComponents.ToolButton {
                id: appLauncher
                text: "🍎 Zonix"
                icon.name: "start-here-kde"
                highlighted: true
                onClicked: appMenu.popup()
            }

            PlasmaComponents.Separator {
                orientation: Qt.Vertical
                height: 24
            }

            // Window title
            Text {
                id: windowTitle
                text: "Рабочий стол"
                color: "#e0e0e0"
                font.family: "Noto Sans"
                font.pointSize: 12
                elide: Text.ElideRight
                Layout.fillWidth: true
                verticalAlignment: Text.AlignVCenter
            }

            // Firefox button
            PlasmaComponents.ToolButton {
                id: firefoxBtn
                text: "🦊 Firefox"
                icon.name: "firefox"
                highlighted: root.showFirefox
                onClicked: {
                    if (root.showFirefox) {
                        Qt.openUrlExternally("firefox")
                    }
                }
                visible: root.showFirefox
            }

            PlasmaComponents.Separator {
                orientation: Qt.Vertical
                height: 24
                visible: root.showFirefox
            }

            // System tray area
            RowLayout {
                spacing: 8

                PlasmaComponents.ToolButton {
                    id: networkBtn
                    icon.name: "network-wireless-signal-excellent"
                    highlighted: true
                    toolTip: "Сеть"
                }

                PlasmaComponents.ToolButton {
                    id: soundBtn
                    icon.name: "audio-volume-high"
                    highlighted: true
                    toolTip: "Звук"
                }

                PlasmaComponents.ToolButton {
                    id: powerBtn
                    icon.name: "system-shutdown"
                    highlighted: true
                    toolTip: "Выключение"
                    onClicked: powerDialog.popup()
                }
            }
        }
    }

    // Application menu popup
    PlasmaQuick.Dialog {
        id: appMenu
        x: appLauncher.x
        y: appLauncher.y + appLauncher.height
        width: 300
        height: 400
        modal: true
        closeOnEscape: true

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            Text {
                text: "Приложения"
                color: "#3daee9"
                font.family: "Noto Sans"
                font.bold: true
                font.pointSize: 16
            }

            PlasmaComponents.ToolButton {
                text: "🦊 Firefox"
                textAlign: Text.AlignLeft
                Layout.fillWidth: true
                onClicked: {
                    Qt.openUrlExternally("firefox")
                    appMenu.close()
                }
            }

            PlasmaComponents.ToolButton {
                text: "📁 Файлы (Dolphin)"
                textAlign: Text.AlignLeft
                Layout.fillWidth: true
                onClicked: {
                    Qt.openUrlExternally("dolphin")
                    appMenu.close()
                }
            }

            PlasmaComponents.ToolButton {
                text: "💬 Сообщения"
                textAlign: Text.AlignLeft
                Layout.fillWidth: true
            }

            PlasmaComponents.ToolButton {
                text: "📷 Камера"
                textAlign: Text.AlignLeft
                Layout.fillWidth: true
            }

            PlasmaComponents.ToolButton {
                text: "📷 Изображения"
                textAlign: Text.AlignLeft
                Layout.fillWidth: true
            }

            PlasmaComponents.Separator {
                Layout.fillWidth: true
            }

            PlasmaComponents.ToolButton {
                text: "⚙️ Параметры системы"
                textAlign: Text.AlignLeft
                Layout.fillWidth: true
                onClicked: Qt.openUrlExternally("systemsettings")
            }

            PlasmaComponents.ToolButton {
                text: "⏻ Выключение"
                textAlign: Text.AlignLeft
                Layout.fillWidth: true
                onClicked: powerDialog.popup()
            }
        }
    }

    // Power dialog
    PlasmaQuick.Dialog {
        id: powerDialog
        width: 250
        height: 200
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
                text: "🔴 Выключить"
                textAlign: Text.AlignCenter
                Layout.fillWidth: true
                onClicked: {
                    Qt.openUrlExternally("systemctl poweroff")
                    powerDialog.close()
                }
            }

            PlasmaComponents.ToolButton {
                text: "🔄 Перезагрузить"
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

    // Desktop icons area (right side)
    Item {
        id: desktopIcons
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 20
        width: 100
        height: parent.height - 40

        ColumnLayout {
            anchors.fill: parent
            spacing: 30

            DesktopIcon {
                iconName: "firefox"
                label: "Firefox"
                onActivated: Qt.openUrlExternally("firefox")
            }

            DesktopIcon {
                iconName: "folder"
                label: "Домашняя папка"
                onActivated: Qt.openUrlExternally("dolphin")
            }

            DesktopIcon {
                iconName: "computer"
                label: "Компьютер"
                onActivated: Qt.openUrlExternally("dolphin /")
            }

            DesktopIcon {
                iconName: "document"
                label: "Документы"
                onActivated: Qt.openUrlExternally("dolphin ~/Documents")
            }

            DesktopIcon {
                iconName: "preferences-system"
                label: "Параметры"
                onActivated: Qt.openUrlExternally("systemsettings")
            }
        }
    }
}

// Desktop icon component
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
