import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem
import Ubuntu.Components.Themes 1.3
import QtLocation 5.3 as Location
import QtPositioning 5.2
import "../JSONListModel"
import "../components"
import "../views"

Page {
    id: page; title: i18n.tr("");
    anchors.fill: parent

    //onActiveChanged: {
        //searchBarBackground.currentIndex = tabView.currentIndex = head.sections.selectedIndex;
    //}

    property string searchQuery: root.searchQuery;
    //property string searchQuery2: "";
    property int searchNum: settings.searchResultsNum;

    //head.onSectionsChanged: {searchBarBackground.currentIndex = tabView.currentIndex = head.sections.selectedIndex;}
    //head.foregroundColor: UbuntuColors.darkGrey

    head.actions: [

        /************************************************ SEARCH CLEAR ACTION */
        /* Clears the search bar, removes the load indicator & stops all      */
        /* data fetches. TODO: Find a way to implement "Stop Data Fetches".   */
        /**********************************************************************/
        Action { iconName: "clear-search"; text: i18n.tr("Clear")
            onTriggered: {
//                if (head.sections.selectedIndex === 0) {
                    searchField.text = root.searchQuery = "";
//                }
//                else {
//                    searchField2.text = searchQuery2 = "";
//                }
                setAt(false);
            }
        },

        /*************************************************** SEARCH GO ACTION */
        /* Hides the keyboard and reloads the page.                           */
        /**********************************************************************/
        Action { iconName: "go-next"; text: i18n.tr("Go")
            onTriggered: { Qt.inputMethod.hide(); page.reload(); }
        },

        /**************************************************** SETTINGS ACTION */
        /* Opens settings page.                                               */
        /**********************************************************************/
        Action { iconName: "settings"; text: i18n.tr("Settings")
            onTriggered: {pageStack.push(settingsPage);}
        }
    ]

    /************************************************************ BACK ACTION */
    head.backAction: Action { iconName: "down"; text: i18n.tr("Close");
        onTriggered: {pageStack.pop();}
    }

    /******************************************************** TABS DEFINITION */
//    head.sections {
//        model: [i18n.tr("Name/Code"), i18n.tr("Location")]; selectedIndex: 0
//        onSelectedIndexChanged: {searchBarBackground.currentIndex = tabView.currentIndex = head.sections.selectedIndex;}
//        onEnabledChanged: {searchBarBackground.currentIndex = tabView.currentIndex = head.sections.selectedIndex;}
//    }

    /**************************************************************************/
    /* SEARCH BAR DEFINITION:                                                 */
    /**************************************************************************/

    VisualItemModel {
        id: searchViewHeaders

        Rectangle {
            id: searchBarLayout
            width: parent.parent.width; height: parent.parent.height;
            color: "transparent"

            TextField {
                id: searchField
                anchors.verticalCenter: parent.verticalCenter; x: units.gu(7);
                width: searchBarLayout.width - units.gu(18)
                placeholderText: "Enter a name or code"
                highlighted: true
                hasClearButton: false
                text: root.searchQuery
                inputMethodHints: Qt.ImhNoPredictiveText
                onAccepted: {page.reload()}
            }

        }

//        Rectangle {
//            id: searchBarLayout2
//            width: parent.parent.width; height: parent.parent.height;
//            color: "transparent"

//            TextField {
//                id: searchField2
//                anchors.verticalCenter: parent.verticalCenter; x: units.gu(7);
//                width: searchBarLayout.width - units.gu(18)
//                placeholderText: "Type a name..."
//                highlighted: true
//                hasClearButton: false
//                text: searchQuery2
//                inputMethodHints: Qt.ImhNoPredictiveText
//                onAccepted: {page.reload()}
//            }
//        }
    }

    ListView {
        id: searchBarBackground

        model: searchViewHeaders
        interactive: false
        anchors {top: parent.top; left: parent.left; right: parent.right;}
        height: units.gu(6)
        orientation: Qt.Horizontal
        snapMode: ListView.SnapOneItem
        currentIndex: parent.head.sections.selectedIndex
        highlightMoveDuration: UbuntuAnimation.FastDuration
    }

    /**************************************************************************/
    /* BODY DEFINITION:                                                       */
    /**************************************************************************/

    VisualItemModel {
        id: searchViewTabs

        /******************************************************************** */
        /********************************************* SEARCH: LIST VIEW MODE */
        Rectangle {

            id: searchListView
            width: parent.parent.width; height: parent.parent.height;
            color: "transparent" //Theme.palette.normal.background

            UbuntuListView {
                id: searchResultsView
                anchors.fill: parent;
                cacheBuffer: 10000;
                clip: true;
                model: nameSearch.model

                delegate: ListItem.Subtitled {
                    id: listDelegate
                    progression: true
                    visible: index <= searchNum
                    height: visible ? units.gu(7) : 0

                    property string iconThumb: (settings.searchThumbNum === 0 ?
                                                    "https://maps.googleapis.com/maps/api/staticmap?" +
                                                    "center=" + stop_lat + "," + stop_lon +
                                                    "&zoom=" + 16 +
                                                    "&size=" + units.gu(5) + "x" + units.gu(5) +
                                                    // "&markers=color:red%7Clabel:C%7C" + stop_lat + "," + stop_lon +
                                                    "&key="
                                                  :
                                                    "https://maps.googleapis.com/maps/api/streetview?size=" +
                                                    units.gu(5) + "x" + units.gu(5) + "&location=" +
                                                    stop_lat + "," + stop_lon +
                                                    "&fov=60&heading=45&pitch=0&key="
                                                ) +
                                               (settings.searchThumbBool ? apiKey.google : "none")

                    fallbackIconName: "stock_image"
                    iconSource: visible ? iconThumb : ""

                    text: model.stop_name //model.stop_code
                    subText: "Code: " + model.stop_code

//                    Icon {
//                        id: favouriteIcon
//                        height: units.gu(4); width: units.gu(4);
//                        anchors.verticalCenter: parent.verticalCenter;
//                        anchors.right: parent.right;
//                        anchors.rightMargin: units.gu(0);
//                        name: favourites.isFavourite(model.stop_id) ? "starred" : "non-starred"

//                        MouseArea {
//                            anchors.fill: parent

//                            onClicked: {
//                                Haptics.play({duration: 25, attackIntensity: 0.7});
//                                favourites.toggleFavourite(stop_id, [stop_name, stop_code, stop_lat, stop_lon])
//                                favouriteIcon.name = favourites.isFavourite(model.stop_id) ? "starred" : "non-starred"
//                                favourites.reloadList();
//                            }
//                        }
//                    }

                    Component.onCompleted: setAt(false);
                    Component.onDestruction: setAt(false);

                    onClicked: {
                        // TO BE DEFINED.
                    }
                }

                /* FOOTER - Load more component */
                footer: ListItem.Empty {
                    height: units.gu(6);
                    visible: searchResultsView.count > searchNum

                    Button {
                        anchors.centerIn: parent;
                        text: "Load More";
                        onClicked: {
                            setAt(true); loadMoreTimer.running = true;
                            searchNum += settings.searchResultsNum; setAt(true);
                        }
                    }
                }
                Item {
                    //iconName: "find"
                    visible: (searchResultsView.count === 0 && !activityIndicator.running)
                    anchors.centerIn: parent

                    Icon {
                        id: emptyIcon; name: "find"
                        anchors.centerIn: parent
                        height: units.gu(10); width: height; color: "#BBBBBB";
                    }
                }
            }
        }

        /******************************************************************** */
        /********************************************** SEARCH: MAP VIEW MODE */
//        Rectangle {
//            id: searchMapView
//            width: parent.parent.width; height: parent.parent.height;
//            color: "red"

//            Button {
//                anchors.centerIn: parent
//                text: "Click me!"
//                onClicked: console.log(position.coordinate)
//            }
//        }
    }

    /**************************************************************************/
    ListView {
        id: tabView

        model: searchViewTabs
        interactive: false
        anchors {top: searchBarBackground.bottom; bottom: page.bottom
            left: parent.left; right: parent.right;
            topMargin: units.gu(0)
        }
        orientation: Qt.Horizontal
        snapMode: ListView.SnapOneItem
        currentIndex: parent.head.sections.selectedIndex
        highlightMoveDuration: UbuntuAnimation.FastDuration
        onActiveFocusChanged: setAt(false)
    }

    /**************************************************************************/
    /* TIMER/LOADER DEFINITIONS:                                              */
    /**************************************************************************/

    Timer {
        id: loadMoreTimer
        interval: 100;
        running: false;
        repeat: false
        onTriggered: setAt(false);
    }

    Timer {
        id: timeOut
        interval: 2000;
        running: false;
        repeat: false
        onTriggered: setAt(false);
    }

    ActivityIndicator {id: activityIndicator; anchors.centerIn: parent;}

    /************************************************************** FUNCTIONS */

    function setAt(value) {
        activityIndicator.running = value; return;
    }

    function reload() {

        // Reset Timeout & show load indicator.
        timeOut.running = false; setAt(true);

        // Reset number of results.
        searchNum = settings.searchResultsNum;

        // Set a timeout (until the next update)
        timeOut.running = true;

        // Change the (appropriate) search query.
//        if (head.sections.selectedIndex === 0) {
            root.searchQuery = searchField.text;
//        }
//        else {searchQuery2 = searchField2.text;}

        return
    }
}



































