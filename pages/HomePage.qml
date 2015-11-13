import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

import "../components"
import "../views"

PageWithBottomEdge {
    id: page
    title: i18n.tr("Public Transport");
    state: "default"

    head {
        actions: [
            Action {
                iconName: "settings";
                text: i18n.tr("Settings");
                onTriggered: {pageStack.push(settingsPage);}
            }
        ]

//        backAction: Action {
//            iconName: "navigation-menu";
//            text: i18n.tr("Navigation Menu");
//            onTriggered: {PopupUtils.open(pager)}
//        }

        sections {
            model: [i18n.tr("Favourites"), i18n.tr("Nearby"), i18n.tr("History")];
            selectedIndex: 0
        }
    }

//    onActiveChanged: update()

//    function update() {
//        tabView.currentIndex = parent.head.sections.selectedIndex;
//    }

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
        currentIndex: page.head.sections.selectedIndex
        highlightMoveDuration: UbuntuAnimation.FastDuration
    }

    bottomEdgeTitle: i18n.tr("Find a Bus Stop, Train Station or Ferry Pier")
    bottomEdgePageComponent: SimpleSearchPage {id: simpleSearchPage; visible: false;}
}

