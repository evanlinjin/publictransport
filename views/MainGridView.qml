import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem
import "../components"
Rectangle {
    id: gridContainer

    // Public attributes ---------------------------------------------------
    property ListModel model: favourites
    width: parent.parent.width
    height: parent.parent.height
    // ---------------------------------------------------------------------

    Rectangle {
        width: parent.width - units.gu(0.5);
        height: parent.height; x: units.gu(0.25);

        color: "transparent"

        GridView {
            id: grid

            model: gridContainer.model
            property bool portrait: parent.height > parent.width
            property int imgWidth: 0; property int imgHeight: 0;

            width: parent.width;  height: parent.height
            cacheBuffer: 1000; clip: true;
            cellWidth: portrait? parent.width/2 : parent.width/4
            cellHeight:  cellWidth + units.gu(3)

            Component.onCompleted: {imgWidth = cellWidth; imgHeight = cellHeight;}

            delegate: Rectangle {

                width: grid.cellWidth; height: grid.cellHeight;
                color: "transparent"

                Image {
                    id: thumbnail
                    width: grid.cellWidth - units.gu(0.5);
                    height: grid.cellHeight - units.gu(0.5);
                    anchors.centerIn: parent;

                    source: (settings.searchThumbNum === 0 ?
                                 "https://maps.googleapis.com/maps/api/staticmap?" +
                                 "center=" + lat + "," + lon +
                                 "&zoom=" + 16 + "&scale=2" +
                                 "&size=" + Math.round(grid.imgWidth/2) + "x" + Math.round(grid.imgHeight/2) +
                                 "&markers=color:red%7C" + lat + "," + lon +
                                 "&key="
                               :
                                 "https://maps.googleapis.com/maps/api/streetview?size=" +
                                 grid.imgWidth + "x" + grid.imgHeight + "&location=" +
                                 lat + "," + lon +
                                 "&fov=60&heading=" + "45" + "&pitch=0&key="
                             ) +
                            (settings.searchThumbBool ? apiKey.google : "none")

                    Rectangle {
                        id: labelbackground
                        anchors.bottom: parent.bottom
                        width: thumbnail.width; height: thumbnail.height/4
                        color: settings.theme === "Ubuntu.Components.Themes.SuruDark" ? "white" : "black"
                    }

                    Rectangle {
                        anchors.fill: labelbackground;
                        color: Theme.palette.normal.background; opacity: 0.9

                        Column {
                            anchors.centerIn: parent
                            height: parent.height - units.gu(1)
                            width: parent.width - units.gu(1)

                            Label {text: name;}
                            Label {fontSize: "x-small"; text: "Code: " + code;}
                        }
                    }
                }
                //color: "white"; opacity: 0.6
            }
        }
    }
}
