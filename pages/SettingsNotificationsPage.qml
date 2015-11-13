import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem2
import Ubuntu.Components.Popups 1.3

import "../components"

Page {
    id: page
    title: i18n.tr("Notifications");
    head.actions: Action {
        iconName: "add"; text: i18n.tr("Add Notification")
        onTriggered: {
            notifications.add("00", "03", "01", "40");
            page.update();
        }
    }

    onActiveChanged: update()

    function update() {
        notificationSwitch.checked = settings.notificationsBool;
        notificationsListView.update();
        notificationsHeader.text = i18n.tr("Notifications") + " (" + notifications.getCountShown() + ")";
    }

    Column {
        id: topColumn

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        ListItem2.Standard {
            id: notificationsHeader
            showDivider: false
            text: i18n.tr("Notifications") + " (" + notifications.getCountShown() + ")";
            //iconName: "alarm-clock"
            iconFrame: false
            control: Switch {
                id: notificationSwitch
                checked: settings.notificationsBool
                onClicked: {settings.notificationsBool = checked;}
                onCheckedChanged: {settings.notificationsBool = checked;}
            }
        }

        ListItem2.Divider {}

    }

    UbuntuListView {
        id: notificationsListView
        anchors {
            top: topColumn.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        //displayMarginBeginning: -topColumn.height/2
        //snapMode: ListView.SnapToItem
        clip: true
        model: notifications

        /* SINGLE NOTIFICATION ITEM DEFINED HERE*/
        delegate: ListItem {
            id: notificationsDelegate
            height: units.gu(8)
            width: parent.width
            //visible: notifications.get(index).service === settings.service
            opacity: settings.notificationsBool ? 1 : 0.3

            leadingActions: ListItemActions {
                actions: [
                    Action {
                        iconName: "delete"
                        text: i18n.tr("Delete")
                        onTriggered: {notifications.remove(index, 1); page.update();}
                    }
                ]
            }

            GridLayout {
                id: listLayout
                anchors {
                    top: parent.top; left: parent.left; right: parent.right;
                    leftMargin: units.gu(2); topMargin: label1.height / 2; rightMargin: units.gu(2);
                }
                rowSpacing: units.gu(1); columnSpacing: units.gu(0);

                Column {
                    Label { id: label1
                        text: "<b>" + "[bus/train/ferry name]" + "</b>"
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        maximumLineCount: 1
                        width: notificationsListView.width - units.gu(8)
                    }

                    Label { id: label2
                        text: "When due at " + "[stop/station/pier name]" + " in " + "[XX time]"
                        fontSize: "x-small"
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        maximumLineCount: 2
                        width: notificationsListView.width - units.gu(8)
                    }

                    Label { id: label3
                        text: "Between " + notifications.getTimeRange(index)
                        fontSize: "x-small"
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        maximumLineCount: 2
                        width: notificationsListView.width - units.gu(8)
                    }

                }

                Column {
                    Rectangle {
                        width: units.gu(3); height: units.gu(3);
                        color: "transparent"
                        CheckBox {
                            checked: notifications.get(index).on
                            onClicked: notifications.get(index).on = checked
                        }
                    }
                }
            }
        }
    }
}
