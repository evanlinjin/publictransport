import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem
import "../components"
import "../JSONListModel"
import "../"

Column {
    //color: "yellow"
    //anchors.horizontalCenter: parent.horizontalCenter
    width: parent.parent.width
    height: parent.parent.height

    //////////////////////////////////////// THIS WILL BE THE "GRID VIEW OBJECT"
    Rectangle {

        // Public attributes ---------------------------------------------------
        property ListModel model: favourites

        width: parent.width - units.gu(0.5);
        height: parent.height; x: units.gu(0.25);
        // ---------------------------------------------------------------------

        id: gridContainer

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

                Image {
                    width: grid.cellWidth - units.gu(0.5);
                    height: grid.cellHeight - units.gu(0.5);
                    anchors.centerIn: parent;

                    source: (settings.searchThumbNum === 0 ?
                                 "https://maps.googleapis.com/maps/api/staticmap?" +
                                 "center=" + lat + "," + lon +
                                 "&zoom=" + 16 +
                                 "&size=" + grid.imgWidth + "x" + grid.imgHeight +
                                 // "&markers=color:red%7Clabel:C%7C" + stop_lat + "," + stop_lon +
                                 "&key="
                               :
                                 "https://maps.googleapis.com/maps/api/streetview?size=" +
                                 grid.imgWidth + "x" + grid.imgHeight + "&location=" +
                                 lat + "," + lon +
                                 "&fov=60&heading=45&pitch=0&key="
                             ) +
                            (settings.searchThumbBool ? apiKey.google : "none")
                }
                //color: "white"; opacity: 0.6
            }
        }
    }
}


/*

UbuntuListView {
    id: favouritesView
    anchors.fill: parent;
    cacheBuffer: 1000;
    clip: true;
    model: favourites

    delegate: ListItem.Subtitled {
        id: listDelegate

        iconSource: (settings.searchThumbNum === 0 ?
                         "https://maps.googleapis.com/maps/api/staticmap?" +
                         "center=" + lat + "," + lon +
                         "&zoom=" + 16 +
                         "&size=" + units.gu(6) + "x" + units.gu(6) +
                         // "&markers=color:red%7Clabel:C%7C" + stop_lat + "," + stop_lon +
                         "&key="
                       :
                         "https://maps.googleapis.com/maps/api/streetview?size=" +
                         units.gu(6) + "x" + units.gu(6) + "&location=" +
                         lat + "," + lon +
                         "&fov=60&heading=45&pitch=0&key="
                     ) +
                    (settings.searchThumbBool ? apiKey.google : "none")

        fallbackIconName: "stock_image"
        iconFrame: false
    }
}

*/
