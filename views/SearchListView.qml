import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem
import QtQuick.XmlListModel 2.0
import "../JSONListModel"


Rectangle {
    id: main
    width: parent.parent.width; height: parent.parent.height;
    color: Theme.palette.normal.background

    JSONListModel {
        id: busStops
        source: serviceProviders.get(settings.serviceProviderIndex).bus_stop_name_search_url +
                searchQuery +
                serviceProviders.get(settings.serviceProviderIndex).bus_stop_name_search_url_2 +
                apiKey.at
        query: serviceProviders.get(settings.serviceProviderIndex).bus_stop_name_search_url_query
    }

    UbuntuListView {
        clip: true
        id: searchResultsView
        anchors.fill: parent
        width: parent.width
        height: parent.height

        model: busStops.model

        delegate: ListItem.Subtitled {
            id: listDelegate
            progression: true
            visible: index <= settings.searchResultsNum
            height: index <= settings.searchResultsNum ? units.gu(6) : 0

            iconSource: index <= settings.searchResultsNum ? "https://maps.googleapis.com/maps/api/streetview?size=" +
                        units.gu(4) + "x" + units.gu(4) + "&location=" +
                        stop_lat + "," + stop_lon +
                        "&fov=60&heading=45&pitch=0&key=" +
                        apiKey.google : ""

            text: model.stop_name
            subText: "Code: " + model.stop_code

            Component.onCompleted: setAt(false);
            //Component.onDestruction: setAt(false);
        }
    }

    Scrollbar {
        flickableItem: searchResultsView
        align: Qt.AlignTrailing
    }

    ActivityIndicator {id: activityIndicator; anchors.centerIn: parent}
    function setAt(value) {activityIndicator.running = value; return;}
    function resetList() {busStops.updateJSONModel();}
}
