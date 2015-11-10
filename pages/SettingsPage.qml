import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem2
import "../components"

Page {
    title: i18n.tr("Settings");

    property bool notificationsUpdating: false

    head.contents: CustomHeader {}
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
                showDivider: false
                text: i18n.tr("<b>Notifications</b>")
                control: Switch {
                    checked: root.settings.notificationsBool
                    onClicked: root.settings.notificationsBool = checked
                }
            }

            ListItem2.Divider {}

            UbuntuListView {
                id: notificationsListView
                width: flickable.width
                height: notificationsListView.count * units.gu(8)
                model: notifications
                interactive: false

                /* SINGLE NOTIFICATION ITEM DEFINED HERE*/
                delegate: ListItem {
                    id: notificationsDelegate
                    height: units.gu(8)
                    width: parent.width
                    visible: notifications.get(index).service === root.settings.service

                    leadingActions: ListItemActions {
                        actions: [
                            Action {
                                iconName: "delete"
                                text: i18n.tr("Delete")
                                onTriggered: {notifications.remove(index, 1); notificationsListView.update();}
                            }
                        ]
                    }

                    GridLayout {
                        id: listLayout
                        anchors {
                            top: parent.top; left: parent.left; right: parent.right;
                            leftMargin: units.gu(2); topMargin: label.height / 2; rightMargin: units.gu(2);
                        }
                        rowSpacing: units.gu(1); columnSpacing: units.gu(0);

                        Column {
                            Label {
                                //Layout.fillWidth: true
                                //Layout.fillHeight: true
                                text: "<b>" + "[bus/train/ferry name]" + "</b>"
                                elide: Text.ElideRight
                                verticalAlignment: Text.AlignVCenter
                                maximumLineCount: 1
                                width: flickable.width - units.gu(8)
                            }

                            Label {
                                //Layout.fillWidth: true
                                //Layout.fillHeight: true
                                text: "When due at " + "[stop/station/pier name]" + " in " + "[XX time]"
                                fontSize: "x-small"
                                elide: Text.ElideRight
                                verticalAlignment: Text.AlignVCenter
                                maximumLineCount: 2
                                width: flickable.width - units.gu(8)
                            }

                            Label { id: label
                                //Layout.fillWidth: true
                                //Layout.fillHeight: true
                                text: "Between " + notifications.getTimeRange(index)
                                fontSize: "x-small"
                                elide: Text.ElideRight
                                verticalAlignment: Text.AlignVCenter
                                maximumLineCount: 2
                                width: flickable.width - units.gu(8)
                            }

                        }
                        Column {
                            Rectangle {
                                width: units.gu(3); height: units.gu(3); radius: 5;
                                CheckBox {
                                    checked: notifications.get(index).on
                                    onClicked: notifications.get(index).on = checked
                                }
                            }
                        }
                    }
                }

                footer:Column {
                    width: flickable.width
                }
            }
        }
    }
}
