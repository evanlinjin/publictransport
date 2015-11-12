import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem2

import QtLocation 5.3
import QtPositioning 5.2


import "../JSONListModel"


Rectangle {
    id: redRec
//    id: searchResultsBackground
//            anchors {top: searchBarBackground.bottom; bottom: page.bottom
//                left: parent.left; right: parent.right;
//            }
    width: parent.parent.width
    height: parent.parent.height
    color: "red"//themes.get(settings.themeIndex).searchBackground2


    Map {
        id: map
        anchors.top: redRec.top
        anchors.bottom: redRec.bottom
        anchors.left: redRec.left
        anchors.right: redRec.right
        height: redRec.height
        width: redRec.width

        zoomLevel: 13
        plugin: Plugin {
            name: "nokia"
            //specify plugin parameters as necessary
            PluginParameter { name: "app_id"; value: "Z9DuParFuVtRPhjmlwF8" }
            PluginParameter { name: "app_code"; value: "l621RnHi9RMraL7trEvMsQ" }
        }

        center {
            latitude: -27.5796
            longitude: 153.1003
        }
        // Enable pinch gestures to zoom in and out
        gesture.flickDeceleration: 3000
        gesture.enabled: true
    }


}
