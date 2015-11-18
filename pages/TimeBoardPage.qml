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
        anchors.fill: page
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

            LinearGradient {
                anchors.fill: parent
                start: Qt.point(150, 0)
                end: Qt.point(150,300)
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: Theme.palette.normal.background
                    }
                    GradientStop {
                        position: 0.1
                        color: "#00000000"
                    }
                }
            }
            LinearGradient {
                anchors.fill: parent
                start: Qt.point(150, 300)
                end: Qt.point(150,0)
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: Theme.palette.normal.background
                    }
                    GradientStop {
                        position: 0.1
                        color: "#00000000"
                    }
                }
            }
        }

        /********************************************************* TIME BOARD */

        UbuntuListView {
            id: timeBoard
            width: parent.width
            height: units.gu(4) * count + units.gu(3)
            anchors.top: topImage.bottom
            clip: true;
            interactive: false;

            /* HEADER */
            headerPositioning: ListView.OverlayHeader
            header: ListItems.Header {
                height: units.gu(3)
                Row {
                    anchors.fill: parent
                    spacing: units.gu(0.5)
                    Rectangle {height: parent.height - units.gu(0.25); width: units.gu(0.5); color: "transparent";}

                    Rectangle {
                        height: parent.height; width: units.gu(7);
                        color: "transparent";
                        Label {
                            anchors.fill: parent
                            text: "ROUTE"
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                            fontSize: "small"
                            font.bold: true
                        }
                    }
                    Rectangle {
                        height: parent.height; width: parent.width - units.gu(22);
                        color: "transparent";
                        Label {
                            anchors.fill: parent
                            text: "DESTINATION"
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                            fontSize: "small"
                            font.bold: true
                        }
                    }
                    Rectangle {
                        height: parent.height; width: units.gu(7);
                        color: "transparent";
                        Label {
                            anchors.fill: parent
                            text: "SCHED."
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                            fontSize: "small"
                            font.bold: true
                        }
                    }
                    Rectangle {
                        height: parent.height; width: units.gu(4);
                        color: "transparent";
                        Label {
                            anchors.fill: parent
                            text: "DUE"
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignRight
                            elide: Text.ElideRight
                            fontSize: "small"
                            font.bold: true
                        }
                    }
                    //Rectangle {height: parent.height; width: units.gu(1);}
                }
            }

            /* BODY */
            model: root.stopTimeBoard
            delegate: ListItems.Standard {
                height: units.gu(4)
                Row {
                    anchors.fill: parent
                    spacing: units.gu(0.5)
                    Rectangle {height: parent.height - units.gu(0.25); width: units.gu(0.5); color: "#" + model.route_color;}

                    Rectangle {
                        height: parent.height; width: units.gu(7);
                        color: "transparent";
                        Label {
                            anchors.fill: parent
                            text: model.route_short_name
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                        }
                    }
                    Rectangle {
                        height: parent.height; width: parent.width - units.gu(22);
                        color: "transparent";
                        Label {
                            anchors.fill: parent
                            text: model.trip_headsign
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                        }
                    }
                    Rectangle {
                        height: parent.height; width: units.gu(7);
                        color: "transparent";
                        Label {
                            anchors.fill: parent
                            text: model.departure_time.substring(0, 5);
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                        }
                    }
                    Rectangle {
                        height: parent.height; width: units.gu(4);
                        color: "transparent";
                        Label {
                            anchors.fill: parent
                            text: "~"
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignRight
                            elide: Text.ElideRight
                        }
                    }
                    //Rectangle {height: parent.height; width: units.gu(1);}
                }
            }
        }
        /* LOAD INDICATOR*/
        ActivityIndicator {
            id: activityIndicator;
            anchors.centerIn: parent;
            running: root.whetherLoadingStopTimeBoard;
        }
    }

    //------------------------------------------------------------------- TIMERS
    Timer {
        id: favouriteTimer
        interval: 1000;
        running: false;
        repeat: true;
        onTriggered: {
            favouritesAction.iconName =
                    favourites.isFavourite(stop_id) ?
                        "starred" : "non-starred";
            console.log("ICON REFRESHED!")

        }
    }

    Timer {
        id: updateTimer
        interval: 3000;
        running: true;
        repeat: true;
        onTriggered: {
            timeBoard.model = 0
            timeBoard.model = root.stopTimeBoard
        }
    }
}





























