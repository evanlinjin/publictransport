import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import "../components"

PageWithBottomEdge {
    title: i18n.tr("Home");
    state: "default"

    head {
        actions: [
            Action {
                iconName: "search";
                text: i18n.tr("Search Home");
                onTriggered: {}
            },
            Action {
                iconName: "settings";
                text: i18n.tr("Settings");
                onTriggered: {pageStack.push(settingsPage);}
            }
        ]

        backAction: Action {
            iconName: "navigation-menu";
            text: i18n.tr("Navigation Menu");
            onTriggered: {}
        }

        contents: CustomHeader {}
        sections {model: [i18n.tr("Favourites"), i18n.tr("History")]}
    }

    VisualItemModel {
        id: homeViewTabs

        Item {
            width: parent.parent.width
            height: parent.parent.height

            Rectangle {
                anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; margins: units.gu(2) }
                color: "red"
                width: parent.width
                height: parent.height
            }
        }

        Item {
            width: parent.parent.width
            height: parent.parent.height

            Rectangle {
                anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; margins: units.gu(2) }
                color: "blue"
                width: parent.width
                height: parent.height
            }
        }
    }

    ListView {
            id: tabView

            model: homeViewTabs
            interactive: false
            anchors.fill: parent
            orientation: Qt.Horizontal
            snapMode: ListView.SnapOneItem
            currentIndex: parent.head.sections.selectedIndex
            highlightMoveDuration: UbuntuAnimation.FastDuration
        }
}

