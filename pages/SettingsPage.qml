import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem2
import Ubuntu.Components.Popups 1.3

import "../components"

Page {
    title: i18n.tr("Settings");
    head.actions: [
        Action {
            iconName: "edit-clear"
            text: i18n.tr("Reset Settings");
            onTriggered: {}
        },

        Action {
            iconName: "info";
            text: i18n.tr("Information");
            onTriggered: {pageStack.push(aboutPage);}
        }
    ]

    onActiveChanged: update()

    function update() {
        notificationSwitch.checked = settings.notificationsBool;
        timeFormatSwitch.checked = settings.show12hrTime;

        flickable.update();
        notificationsHeader.text = i18n.tr("Notifications") + " (" + notifications.getCountShown() + ")";
    }

    Flickable {
        id: flickable

        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: settingsColumn.height

        Column {
            id: settingsColumn

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }

            ListItem2.Standard {
                id: notificationsHeader
                text: i18n.tr("Notifications") + " (" + notifications.getTimeRange() + ")"
                showDivider: false
                progression: true
                //iconName: "alarm-clock"
                iconFrame: false
                control: Switch {
                    id: notificationSwitch
                    checked: settings.notificationsBool
                    onClicked: {settings.notificationsBool = checked;}
                    onCheckedChanged: {settings.notificationsBool = checked;}
                }
                onClicked: {pageStack.push(settingsNotificationsPage)}
            }

            ListItem2.Divider {} ListItem2.Header { text: "Time Format:"}

            ListItem2.Standard {
                id: timeFormatSelector
                text: i18n.tr("Use 12-Hour Time")
                showDivider: false
                control : Switch {
                    id: timeFormatSwitch
                    checked: settings.show12hrTime
                    onClicked: {settings.show12hrTime = checked;}
                    onCheckedChanged: {settings.show12hrTime = checked;}
                }
            }

            ListItem2.Divider {} ListItem2.Header { text: "Theme:"}

            ListItem2.Standard {
                id: tihemeSelector
                text: i18n.tr("Use Dark Theme")
                showDivider: false
                control : Switch {
                    id: themeSwitch
                    checked: settings.theme === "Ubuntu.Components.Themes.SuruDark"
//                    onClicked: {
//                        if (checked) {settings.theme = theme.name = "Ubuntu.Components.Themes.SuruDark"}
//                        else {settings.theme = theme.name = "Ubuntu.Components.Themes.Ambiance"}
//                    }
                    onCheckedChanged: {
                        if (checked) {settings.theme = theme.name = "Ubuntu.Components.Themes.SuruDark"}
                        else {settings.theme = theme.name = "Ubuntu.Components.Themes.Ambiance"}
                    }
                }
            }

            ListItem2.Divider {} ListItem2.Header { text: "Service Provider:"}

            ListItem2.Subtitled {
                id: serviceProviderSelector
                text: i18n.tr("Change Service Provider...")
                subText: i18n.tr(settings.service)
                showDivider: false
                progression: true
                onClicked: {PopupUtils.open(serviceProviderDialogue, serviceProviderSelector)}
            }
        }
    }
}
