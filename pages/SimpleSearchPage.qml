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

    property int searchNum: settings.searchResultsNum;

    head.actions: [

        /************************************************ SEARCH CLEAR ACTION */
        /* Clears the search bar, removes the load indicator & stops all      */
        /* data fetches. TODO: Find a way to implement "Stop Data Fetches".   */
        /**********************************************************************/
        Action { iconName: "clear-search"; text: i18n.tr("Clear")
            onTriggered: {searchField.text = root.searchQuery = ""; setAt(false);}
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

    /**************************************************************************/
    /* SEARCH BAR DEFINITION:                                                 */
    /**************************************************************************/

    Rectangle {
        id: searchBarLayout
        anchors {top: parent.top; left: parent.left; right: parent.right;}
        height: units.gu(6)
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

    /**************************************************************************/
    /* BODY DEFINITION:                                                       */
    /**************************************************************************/
    Rectangle {

        id: searchListView
        anchors {top: searchBarLayout.bottom; bottom: page.bottom
            left: parent.left; right: parent.right;
        }
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

                text: model.stop_name //model.stop_code
                subText: "Code: " + model.stop_code

                Icon {
                    id: favouriteIcon
                    height: units.gu(3.5); width: units.gu(3.5);
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.right: parent.right;
                    name: favourites.isFavourite(model.stop_id) ? "starred" : "non-starred"

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            Haptics.play({duration: 25, attackIntensity: 0.7});
                            favourites.toggleFavourite(stop_id, [stop_name, stop_code, stop_lat, stop_lon])
                            favouriteIcon.name = favourites.isFavourite(model.stop_id) ? "starred" : "non-starred"
                            favourites.reloadList();
                        }
                    }
                }

                Component.onCompleted: setAt(false);
                Component.onDestruction: setAt(false);

                onClicked: {
                    pageStack.push(timeBoardPage, {
                                       'stop_id': stop_id,
                                       'stop_name': stop_name,
                                       'stop_code': stop_code,
                                       'stop_lat': stop_lat,
                                       'stop_lon': stop_lon,
                                   })
                }
            }

            Item {
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

    /**************************************************************************/
    /* TIMER/LOADER DEFINITIONS:                                              */
    /**************************************************************************/

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



































