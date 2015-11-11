import QtQuick 2.4
import Ubuntu.Components 1.3
import U1db 1.0 as U1db
import Qt.labs.settings 1.0

import "components"
import "pages"
import "views"
import "api"

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

    HomePage {id: mainPage; visible: false; head.contents: customHeader}
    SettingsPage {id: settingsPage; visible: false; head.contents: customHeader}
    SettingsNotificationsPage {id: settingsNotificationsPage; visible: false; head.contents: customHeader}
    AboutPage {id: aboutPage; visible: false; head.contents: customHeader}
    SimpleSearchPage {id: simpleSearchPage; visible: false; head.contents: customHeader}

    CustomHeader {id: customHeader; visible: false;}

    ServiceProviderDialogue {id: serviceProviderDialogue;}

    APIKey {id: apiKey} // This file cannot be shared.

    property var settings: Settings {
        property string service: "Auckland Transport"
        property bool show12hrTime: true
        property bool notificationsBool: false
    }

    ListModel {
        id: notifications

        //            ListElement {
        //                service: "Auckland Transport";
        //                on: true;
        //                start_h: "06"; start_m: "00";
        //                end_h: "08"; end_m: "30";
        //            }

        function getTimeRange(index) {
            return root.time(get(index).start_h, get(index).start_m) + " - " + root.time(get(index).end_h, get(index).end_m)
        }

        function getCountShown() {
            var countShown = 0
            for (var i = 0; i < count; i++) {
                if (get(i).service === settings.service) {countShown += 1}
            } return countShown
        }

        function add(start_h, start_m , end_h, end_m) {
            append({"start_h": start_h, "start_m": start_m, "end_h": end_h, "end_m": end_m,
                       "on": true, "service": settings.service})
        }

    }

    ListModel {
        id: favourites
    }

    ListModel {
        id: history
    }

    ListModel {
        id: serviceProviders
        ListElement {
            name: "Auckland Transport";
            icon: "../icons/AucklandTransport.png";
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

