import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3

import "../components"
import "../views"

PageWithBottomEdge {
    title: i18n.tr("Home");
    state: "default"

    head {
        actions: [
            Action {
                iconName: "search";
                text: i18n.tr("Search Home");
                onTriggered: {pageStack.push(simpleSearchPage);}
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

        sections {model: [i18n.tr("Favourites"), i18n.tr("History")]}
    }

    VisualItemModel {
        id: homeViewTabs

        FavouritesView {id: favouritesView}
        HistoryView {id: historyView}
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

    bottomEdgeTitle: i18n.tr("Find Stop/Station/Pier")
}

