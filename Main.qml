import QtQuick 2.4
import Ubuntu.Components 1.3
import U1db 1.0 as U1db
import Qt.labs.settings 1.0

import "components"
import "pages"
import "views"

MainView {
    id: root;
    objectName: "mainView"
    applicationName: "publictransport.evanlinjin"
    automaticOrientation: true
    anchorToKeyboard: true

    property real margins: units.gu(2)

    width: units.gu(100)
    height: units.gu(75)

    PageStack {id: pageStack; Component.onCompleted: {push(mainPage);}}

    HomePage {id: mainPage; visible: false;}
    SettingsPage {id: settingsPage; visible: false;}
    AboutPage {id: aboutPage; visible: false;}

    property var settings: Settings {
        property string service: "Auckland Transport"
        property bool notificationsBool: false
        property bool show12hrTime: true
    }


    ListModel {
        id: favourites
    }

    ListModel {
        id: history
    }

    ListModel {
        id: notifications

        ListElement {
            service: "Auckland Transport";
            on: true;
            start_h: "06"; start_m: "00";
            end_h: "08"; end_m: "30";
        }

        ListElement {
            service: "Auckland Transport";
            on: true;
            start_h: "12"; start_m: "15";
            end_h: "14"; end_m: "45";
        }

        ListElement {
            service: "Auckland Transport";
            on: false;
            start_h: "19"; start_m: "00";
            end_h: "21"; end_m: "30";
        }

        ListElement {
            service: "Taipei Transport";
            on: false;
            start_h: "19"; start_m: "00";
            end_h: "21"; end_m: "30";
        }

        function getTimeRange(index) {
            return root.time(get(index).start_h, get(index).start_m) + " - " + root.time(get(index).end_h, get(index).end_m)
        }

    }

    /* GLOBAL FUNCTIONS */
    function time(hh, mm) {
        var end = ""
        if (root.settings.show12hrTime === true) {
            if (hh > 12) {hh -= 1; end = " pm"} else {end = " am"}
        }
        return hh + ":" + mm + end
    }
}

