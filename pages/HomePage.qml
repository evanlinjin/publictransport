import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import "../components"

PageWithBottomEdge {
    title: i18n.tr("Home");

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

        sections {
            model: ["Favourites", "Recent"]
        }
    }
}

