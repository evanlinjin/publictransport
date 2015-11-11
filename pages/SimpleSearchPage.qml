import QtQuick 2.4
import QtQuick.XmlListModel 2.0
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem2
import "../JSONListModel"
import "../components"

Page {
    id: page
    title: i18n.tr("Simple Search");
    head.actions: Action {
        iconName: "filters"; text: i18n.tr("Filter Results")
        onTriggered: {}
    }

    property string searchQuery: "";
    function update() {
        searchQuery = searchField.text
        busStops.updateJSONModel();
    }

    Rectangle {
        id: searchBarBackground
        anchors {top: parent.top; left: parent.left; right: parent.right;}
        height: header.height
        color: UbuntuColors.blue

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

                TextField {
                    id: searchField
                    placeholderText: "Search"
                    width: searchBarLayout.width - goButton.width - units.gu(1)
                    highlighted: true
                    text: searchQuery
                    onDisplayTextChanged: searchQuery = text;
                }

                Button {
                    id: goButton; text: "Refresh"; color: UbuntuColors.coolGrey;
                    onClicked: update()
                }
            }
        }
    }

    Rectangle {
        id: searchResultsBackground
        anchors {top: searchBarBackground.bottom; bottom: page.bottom
            left: parent.left; right: parent.right;
        }
        //color: "yellow"
        //z: searchBarBackground.z - 1

        ListView {
            clip: true
            id: searchResultsView
            anchors.fill: parent
            width: parent.width
            height: parent.height

            JSONListModel {
                id: busStops
                source: "https://api.at.govt.nz/v1/gtfs/stops/search/" + searchQuery + "?api_key=" + apiKey.at
                query: "$.response[*]"
            }
            model: busStops.model

            delegate: ListItem2.Subtitled {
                text: model.stop_name
                subText: 'Stop Id: ' + model.stop_id + ', Stop Code: ' + model.stop_code
                progression: true

            }
        }
    }

//    ListModel {
//        id: busStops
//        ListElement {
//            stop_id: 1057
//            stop_code: 6155
//            stop_name: "171 Bucklands Beach Rd"
//            stop_lat: -36.877112
//            stop_lon: 174.90851
//        }

//        function getId(idx) {
//            return (idx >= 0 && idx < count) ? get(idx).stop_id : 0
//        }

//        function getCode(idx) {
//            return (idx >= 0 && idx < count) ? get(idx).stop_code : 0
//        }

//        function getName(idx) {
//            return (idx >= 0 && idx < count) ? get(idx).stop_name : ""
//        }

//        function getLat(idx) {
//            return (idx >= 0 && idx < count) ? get(idx).stop_lat : 0.0
//        }

//        function getLon(idx) {
//            return (idx >= 0 && idx < count) ? get(idx).stop_lon : 0.0
//        }
//    }

//    XmlListModel {
//        id: stopsFetcher
//        source: ""
//    }
}




































