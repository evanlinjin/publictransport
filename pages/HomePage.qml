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

//    onActiveChanged: {
//        page.head.sections.selectedIndex = 0;
//        tabView.currentIndex = 0;
//    }

    ////////////////////////////////////////////////////////////////////////////
    //-------------------------------------------------------- HEADER DEFINITION
    ////////////////////////////////////////////////////////////////////////////

    head {
        actions: [

            //---------------------------------------------------- RELOAD ACTION

            Action {
                iconName: "reload"
                text: i18n.tr("Reload")
                onTriggered: {root.reloadHome()}
            },

            //-------------------------------------------------- SETTINGS ACTION

            Action {
                iconName: "settings";
                text: i18n.tr("Settings");
                onTriggered: {pageStack.push(settingsPage);}
            }
        ]

        //------------------------------------------------------------- SECTIONS

        sections {
            model: [i18n.tr("Favourites"), i18n.tr("Nearby")];
            selectedIndex: 0
        }
    }  

    ////////////////////////////////////////////////////////////////////////////
    //---------------------------------------------------------- TABS DEFINITION
    ////////////////////////////////////////////////////////////////////////////

    ListView {
        id: tabView

        model: VisualItemModel {

            //------------------------------------------------------- FAVOURITES

            MainGridView {
                id: favouritesGridView;
                model: favourites

                EmptyState {
                    id: favouritesEmptyState
                    visible: favourites.count === 0
                    iconName: "non-starred"
                    title: i18n.tr("No favourites")
                    subTitle: "Swipe from the bottom to <i>search</i> or press <i>nearby</i> to see what's close"
                }
            }

            //----------------------------------------------------------- NEARBY

            MainGridView {
                id: nearbyGridView;
                model: locationSearch.model

                EmptyState {
                    id: nearbyEmptyState
                    visible: locationSearch.model.count === 0 && root.whetherLoadingNearby === false
                    iconName: "location"
                    title: i18n.tr("No results")
                    subTitle: "<i>Refresh</i> the page or check system network and location settings"
                }

                ActivityIndicator {
                    id: nearbyActivityIndicator;
                    anchors.centerIn: parent;
                    running: root.whetherLoadingNearby && locationSearch.model.count === 0;
                }

//                Button {
//                    //anchors.verticalCenter: parent.verticalCenter
//                    anchors.centerIn: parent
//                    text: "lat: " + settings.current_lat + ", lon: " + settings.current_lon
//                    opacity: 0.5; color: UbuntuColors.red
//                    onClicked: {root.locationSearch.reloadList()}
//                }
            }
        }

        interactive: false
        anchors.fill: parent
        orientation: Qt.Horizontal
        snapMode: ListView.SnapOneItem
        currentIndex: page.head.sections.selectedIndex
        highlightMoveDuration: UbuntuAnimation.FastDuration
    }

    ////////////////////////////////////////////////////////////////////////////
    //-------------------------------------------------------------- BOTTOM EDGE
    ////////////////////////////////////////////////////////////////////////////

    bottomEdgeTitle: i18n.tr("Search")
    bottomEdgePageComponent: Component {SimpleSearchPage {id: simpleSearchPage; visible: false;}}
}

