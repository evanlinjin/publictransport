import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem
import "../JSONListModel"
import "../components"
import "../views"

Page {
    id: page
    title: i18n.tr("Search");
    head.actions: Action {
        iconName: "filters"; text: i18n.tr("Filter Results")
        onTriggered: {}
    }

    //onActiveChanged: {update();}

    property string searchQuery: "";
    // *** This property is moved to: settings.searchViewIndex ***
    //property int viewIndex: 0;

    function update() {
        searchQuery = searchField.text;
    }

    /**************************************************************************/
    /* SEARCH BAR DEFINITION:                                                 */
    /**************************************************************************/

    Rectangle {
        id: searchBarBackground
        anchors {top: parent.top; left: parent.left; right: parent.right;}
        height: units.gu(6)//header.height
        color: themes.get(settings.themeIndex).searchBackground

        Column {
            id: searchBarLayout

            anchors { fill: parent;
                leftMargin: root.margins; rightMargin: root.margins;
                topMargin: units.gu(1); bottomMargin: units.gu(1);
            }
            spacing: units.gu(1);

            Row {
                id: searchBar
                spacing: units.gu(1)
                visible: settings.searchViewIndex === 0

                TextField {
                    id: searchField
                    placeholderText: "Search..."
                    width: searchBarLayout.width - units.gu(1) - searchButton.width
                    highlighted: true
                    hasClearButton: true
                    text: searchQuery
                    inputMethodHints: Qt.ImhNoPredictiveText //, Qt.ImhNoAutoUppercase
                    onAccepted: {searchQuery = text; searchListView.setAt(true);}
                }

                Button {
                    id: searchButton;
                    text: "Go";
                    color: themes.get(settings.themeIndex).searchButtonBackground;
                    onPressedChanged: {
                        searchQuery = searchField.text;
                        searchListView.setAt(true);
                        searchListView.resetList();
                    }
                }
            }
        }
    }

    /**************************************************************************/
    /* VIEW MODE DEFINITION:                                                  */
    /**************************************************************************/

    VisualItemModel {
        id: searchViewTabs

        SearchListView {id: searchListView}
        SearchMapView {id: searchMapView}
    }

    ListView {
        id: tabView

        model: searchViewTabs
        interactive: false
        anchors {top: searchBarBackground.bottom; bottom: page.bottom
            left: parent.left; right: parent.right;
        }
        orientation: Qt.Horizontal
        snapMode: ListView.SnapOneItem
        currentIndex: settings.searchViewIndex
        highlightMoveDuration: UbuntuAnimation.FastDuration
    }
}



































