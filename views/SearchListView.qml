import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem
import QtQuick.XmlListModel 2.0
import "../JSONListModel"


Rectangle {

    property int searchNum: settings.searchResultsNum;

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
            progression: false
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

            text: model.stop_name
            subText: "Code: " + model.stop_code + ", ID: " + model.stop_id

            Icon {
                id: favouriteIcon
                height: units.gu(3); width: units.gu(3);
                anchors.verticalCenter: parent.verticalCenter;
                anchors.right: parent.right;
                anchors.rightMargin: units.gu(1);
                name: "non-starred"
            }

            Component.onCompleted: setAt(false);
            Component.onDestruction: setAt(false);
        }
        cacheBuffer: 10000

        footer: ListItem.Empty {
            height: units.gu(6);
            visible: searchResultsView.count > searchNum

            Button {
                anchors.centerIn: parent;
                text: "Load More";
                //onClicked: {searchNum += settings.searchResultsNum; setAt(true)}
                onClicked: {
                    setAt(true); loadMoreTimer.running = true;
                    searchNum += settings.searchResultsNum; setAt(true);
                }
            }
        }

        Timer {
            id: loadMoreTimer
            interval: 100; running: false; repeat: false
            onTriggered: setAt(false);
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
