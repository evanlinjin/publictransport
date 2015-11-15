import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

import "../components"
import "../views"

PageWithBottomEdge {
    id: page
    title: i18n.tr("Home");
    state: "default"

    onActiveChanged: page.head.sections.selectedIndex = 0

    head {
        actions: [
            Action {
                iconName: "reload"
                text: page.head.sections.selectedIndex === 1 ?
                          i18n.tr("Get Current Location") : i18n.tr("Reload")

                onTriggered: {
                    if (page.head.sections.selectedIndex === 1) {root.getLocation()}
                    else {root.favourites.reloadList()}
                }
            },
            Action {
                iconName: "settings";
                text: i18n.tr("Settings");
                onTriggered: {pageStack.push(settingsPage);}
            }
        ]

        sections {
            model: [i18n.tr("Favourites"), i18n.tr("Nearby"), i18n.tr("History")];
            selectedIndex: 0
        }
    }  

    ListView {
        id: tabView

        model: VisualItemModel {

            MainGridView {
                id: favouritesGridView;
                model: favourites
            }

            MainGridView {
                id: nearbyGridView;
                model: locationSearch.model
                Component.onCompleted: locationSearch.updateJSONModel();

                Button {
                    //anchors.verticalCenter: parent.verticalCenter
                    anchors.centerIn: parent
                    text: "lat: " + settings.current_lat + ", lon: " + settings.current_lon
                    opacity: 0.5; color: UbuntuColors.red
                    onClicked: {root.getLocation()}
                }
            }

            HistoryView {
                id: historyView;
            }
        }

        interactive: false
        anchors.fill: parent
        orientation: Qt.Horizontal
        snapMode: ListView.SnapOneItem
        currentIndex: page.head.sections.selectedIndex
        highlightMoveDuration: UbuntuAnimation.FastDuration
    }

    bottomEdgeTitle: i18n.tr("Find a Bus Stop, Train Station or Ferry Pier")
    bottomEdgePageComponent: SimpleSearchPage {id: simpleSearchPage;}
}

