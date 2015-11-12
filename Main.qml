import QtQuick 2.4
import Ubuntu.Components 1.3
import U1db 1.0 as U1db
import Qt.labs.settings 1.0
import Ubuntu.Components.Themes 1.3

import "components"
import "pages"
import "views"
import "dialogs"
import "api"

MainView {
    id: root;
    objectName: "mainView"
    applicationName: "publictransport.evanlinjin"
    automaticOrientation: true
    anchorToKeyboard: true
    theme.name : settings.theme// "Ubuntu.Components.Themes.SuruDark" // "Ubuntu.Components.Themes.Ambiance"


    property real margins: units.gu(2)

    width: units.gu(100)
    height: units.gu(75)

    PageStack {id: pageStack; Component.onCompleted: {push(mainPage);}}

    /* PAGES DEFINED HERE *****************************************************/
    HomePage {id: mainPage; visible: false; head.contents: customHeader}
    SettingsPage {id: settingsPage; visible: false; head.contents: customHeader}
    SettingsNotificationsPage {id: settingsNotificationsPage; visible: false; head.contents: customHeader}
    AboutPage {id: aboutPage; visible: false;}
    //SimpleSearchPage {id: simpleSearchPage; visible: false; head.contents: customHeader}

    /* HEADERS DEFINED HERE ***************************************************/
    CustomHeader {id: customHeader; visible: false;}
    SearchHeader {id: searchHeader; visible: false;}

    /* DIALOGS DEFINED HERE ***************************************************/
    ServiceProviderDialog {id: serviceProviderDialogue;}

    /* HIDDEN STUFF DEFINED HERE **********************************************/
    APIKey {id: apiKey} // This file cannot be shared.

    /* DEFAULT SETTINGS DEFINED HERE ******************************************/
    property var settings: Settings {
        property string service: "Auckland Transport" // This value needs to be deprecated.
        property int serviceProviderIndex: 0

        property int themeIndex: 0
        property string theme: "Ubuntu.Components.Themes.Ambiance"

        property bool show12hrTime: true
        property bool notificationsBool: false

        property int searchViewIndex: 0
        property int searchResultsNum: 10
    }

    /* PERMANENT LIST MODELS DEFINED HERE *************************************/

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

            append({
                       "start_h": start_h, "start_m": start_m,
                       "end_h": end_h, "end_m": end_m, "on": true,
                       "service": serviceProviders.get(settings.serviceProviderIndex).name //settings.service
                   })
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

            bus_stop_name_search_url: "https://api.at.govt.nz/v1/gtfs/stops/search/";
            bus_stop_name_search_url_2: "?api_key=";
            bus_stop_name_search_url_query: "$.response[*]";

            routes_search_id: "api.at.govt.nz/v1/gtfs/routes/stopid/";
            routes_search_id_2: "?api_key=";
            routes_search_id_query: "$.response[*]";

        }
    }

    ListModel {
        id: themes

        ListElement {
            name: "Default"
            searchBackground: "#12a3d8"
            searchBackground2: "white"
            searchButtonBackground: "#333333"
            bottomEdgeBackground: "#12a3d8"
            bottomEdgeFont: "white"
        }
    }

    /* GLOBAL FUNCTIONS DEFINED HERE ******************************************/
    function time(hh, mm) {
        var end = ""
        if (root.settings.show12hrTime === true) {
            if (hh > 12) {hh -= 1; end = " pm"} else {end = " am"}
        }
        return hh + ":" + mm + end
    }
}

