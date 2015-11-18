import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItems
import "../components"
import "../"

Page {
    id: page
    title: stop_name
    //--------------------------------------------------------- GLOBAL VARIABLES
    property string stop_id: ""
    property string stop_name: ""
    property string stop_code: ""
    property string stop_lat: ""
    property string stop_lon: ""
    property string routes: ""

    //----------------------------------------------------- COMPONENT PROPERTIES
    Component.objectName: stop_id
    Component.onObjectNameChanged: {
        favouritesAction.iconName = favourites.isFavourite(stop_id) ?
            "starred" : "non-starred";
        root.stopTimeBoard.getRoutes(stop_id)
    }

    //---------------------------------------------------------------- FUNCTIONS
    function reload() {
        root.stopTimeBoard.getRoutes(stop_id)
    }

    //-------------------------------------------------------- HEADER DEFINITION
    head {
        actions: [
            Action {
                iconName: "reload"
                text: i18n.tr("Reload")
                onTriggered: {reload()}
            },
            Action {
                id: favouritesAction
                iconName: favourites.isFavourite(stop_id) ? "starred" : "non-starred";
                text: i18n.tr("Favourite");
                onTriggered: {
                    root.toggleFavourites(stop_id,
                                          [
                                              stop_name,
                                              stop_code,
                                              stop_lat,
                                              stop_lon,
                                              routes
                                          ],
                                          page)
                    favouriteTimer.running = true;
                }

            }
        ]
        contents: CustomHeader{mainTitle: stop_code; iconName: "location";}
    }

    //---------------------------------------------------------- BODY DEFINITION

    Flickable {
        id: flickable
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        width: parent.width
        height: parent.height
        contentWidth: parent.width
        contentHeight: topImage.height + timeBoard.height
        clip: true

        /********************************************************** TOP IMAGE */

        Image {
            id: topImage
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            height: width/3
            fillMode: Image.PreserveAspectCrop
            cache: true

            source: (settings.searchThumbNum === 0 ?
                         "https://maps.googleapis.com/maps/api/staticmap?" +
                         "center=" + stop_lat + "," + stop_lon +
                         "&zoom=" + 16 + "&scale=2" +
                         "&size=" + Math.round(width/2) + "x" + Math.round(height/2) +
                         "&markers=color:red%7C" + stop_lat + "," + stop_lon +
                         "&key="
                       :
                         "https://maps.googleapis.com/maps/api/streetview?size=" +
                         Math.round(width) + "x" + Math.round(height) + "&location=" +
                         stop_lat + "," + stop_lon +
                         "&fov=60&heading=" + "45" + "&pitch=0&key="
                     ) +
                    (settings.searchThumbBool ? apiKey.google : "none")
        }

        /********************************************************* TIME BOARD */

        UbuntuListView {
            id: timeBoard
            width: parent.width
            height: units.gu(4) * count
            anchors.top: topImage.bottom

            model: root.stopTimeBoard
            delegate: ListItems.Standard {
                height: units.gu(4)
                Row {
                    anchors.fill: parent
                    spacing: units.gu(1)
                    Rectangle {height: parent.height; width: units.gu(1); color: "#" + model.route_color;}

                    Rectangle {
                        height: parent.height; width: units.gu(6);
                        color: "transparent";
                        Label {
                            anchors.fill: parent
                            text: model.route_short_name
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    Rectangle {
                        height: parent.height; width: parent.width - units.gu(23);
                        color: "transparent";
                        Label {
                            anchors.fill: parent
                            text: model.trip_headsign
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    Rectangle {
                        height: parent.height; width: units.gu(7);
                        color: "transparent";
                        Label {
                            anchors.fill: parent
                            text: model.departure_time_seconds
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    Rectangle {
                        height: parent.height; width: units.gu(4);
                        color: "transparent";
                        Label {
                            anchors.fill: parent
                            text: "~"
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    //Rectangle {height: parent.height; width: units.gu(1);}
                }
            }
        }
    }

    //------------------------------------------------------------------- TIMERS
    Timer {
        id: favouriteTimer
        interval: 1000;
        running: true;
        repeat: true;
        onTriggered: {
            favouritesAction.iconName =
                    favourites.isFavourite(stop_id) ?
                        "starred" : "non-starred";
            console.log("ICON REFRESHED!")
            timeBoard.model = 0
            //timeBoard.update()
            timeBoard.model = root.stopTimeBoard
        }
    }
}
