import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem
import "../components"
Rectangle {
    id: gridContainer

    // Public attributes -------------------------------------------------------

    property ListModel model: favourites

    width: parent.parent.width
    height: parent.parent.height
    color: "transparent"

    // -------------------------------------------------------------------------

    function refresh() {
        locationSearch.updateJSONModel();
        grid.update();
    }

    Rectangle {
        width: parent.width - units.gu(1);
        height: parent.height; x: units.gu(0.5);

        color: "transparent"

        GridView {
            id: grid

            model: gridContainer.model
            property bool portrait: parent.height > parent.width
            property int imgWidth: 0; property int imgHeight: 0;

            width: parent.width;  height: parent.height
            cacheBuffer: 1000; clip: true;
            cellWidth: portrait? parent.width/2 : parent.width/4
            cellHeight:  cellWidth - units.gu(3)

            Component.onCompleted: {imgWidth = cellWidth - units.gu(2); imgHeight = cellHeight - units.gu(8);}

            delegate: Rectangle {

                width: grid.cellWidth; height: grid.cellHeight;
                color: "transparent"

                Rectangle {
                    id: thumbnail
                    width: grid.cellWidth - units.gu(1);
                    height: grid.cellHeight - units.gu(1);
                    anchors.centerIn: parent;

                    Image {
                        anchors {
                            top: parent.top;
                            left: parent.left;
                            right: parent.right;
                            //bottom: parent.bottom;
                            bottomMargin: labelbackground.height
                        }
                        fillMode: Image.PreserveAspectCrop

                        source: (settings.searchThumbNum === 0 ?
                                     "https://maps.googleapis.com/maps/api/staticmap?" +
                                     "center=" + stop_lat + "," + stop_lon +
                                     "&zoom=" + 16 + "&scale=2" +
                                     "&size=" + Math.round(grid.imgWidth/2) + "x" + Math.round(grid.imgHeight/2) +
                                     "&markers=color:red%7C" + stop_lat + "," + stop_lon +
                                     "&key="
                                   :
                                     "https://maps.googleapis.com/maps/api/streetview?size=" +
                                     Math.round(grid.imgWidth) + "x" + Math.round(grid.imgHeight) + "&location=" +
                                     stop_lat + "," + stop_lon +
                                     "&fov=60&heading=" + "45" + "&pitch=0&key="
                                 ) +
                                (settings.searchThumbBool ? apiKey.google : "none")
                    }

                    Rectangle {
                        id: labelbackground
                        anchors.bottom: parent.bottom
                        width: thumbnail.width; height: thumbnail.height/3
                        color: settings.theme === "Ubuntu.Components.Themes.SuruDark" ? "white" : "black"
                    }

                    Rectangle {
                        id: label
                        anchors.centerIn: labelbackground
                        height: labelbackground.height; width: labelbackground.width
                        color: Theme.palette.normal.background; opacity: 0.9

                        Column {
                            anchors.centerIn: parent
                            height: parent.height - units.gu(1.5)
                            width: parent.width - units.gu(2)

                            Label {
                                text: stop_code;
                                font.bold: true
                                width: parent.width// * 0.85;
                                elide: Text.ElideRight
                            }
                            Label {
                                fontSize: "x-small";
                                text: stop_name;
                                width: parent.width// * 0.85;
                                elide: Text.ElideRight
                            }
                        }
                    }
                }
                //color: "white"; opacity: 0.6
            }
        }
    }
}
