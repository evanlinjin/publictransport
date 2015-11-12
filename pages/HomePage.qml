import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

import "../components"
import "../views"

PageWithBottomEdge {
    title: i18n.tr("Real Time Boards");
    state: "default"

    head {
        actions: [
            Action {
                iconName: "search";
                text: i18n.tr("Search Home");
                //onTriggered: {pageStack.push(simpleSearchPage);}
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
            onTriggered: {PopupUtils.open(pager)}
        }

        sections {
            model: [i18n.tr("Favourites"), i18n.tr("Nearby"), i18n.tr("History")];
            selectedIndex: 0
        }
    }

    onActiveChanged: update()

    function update() {
        tabView.currentIndex = parent.head.sections.selectedIndex;
    }

    VisualItemModel {
        id: homeViewTabs

        FavouritesView {id: favouritesView}
        NearbyView {id: nearbyView}
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

    bottomEdgeTitle: i18n.tr("Find a Bus Stop, Train Station or Ferry Pier")
    bottomEdgePageComponent: SimpleSearchPage {id: simpleSearchPage; visible: false; head.contents: searchHeader}
}

