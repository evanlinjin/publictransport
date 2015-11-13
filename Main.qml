import QtQuick 2.4
import Ubuntu.Components 1.3
import U1db 1.0 as U1db
import Qt.labs.settings 1.0
import Ubuntu.Components.Themes 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem


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
    HomePage {id: mainPage; visible: false;}
    SettingsPage {id: settingsPage; visible: false;}
    SettingsNotificationsPage {id: settingsNotificationsPage; visible: false;}
    AboutPage {id: aboutPage; visible: false;}
    //SimpleSearchPage {id: simpleSearchPage; visible: false; head.contents: customHeader}

    /* HEADERS DEFINED HERE ***************************************************/
    CustomHeader {id: customHeader; visible: false;}
    //SearchHeader {id: searchHeader; visible: false;}

    /* COMPONENTS DEFINED HERE ************************************************/
    Component { id: pager

        Dialog {
            id: popover
            edgeMargins: units.gu(10)

            Column {
                id: containerLayout

                ListItem.Standard {
                    text: mainPage.title; //icon: "settings"; iconFrame: false;
                    onTriggered: {pageStack.push(mainPage); PopupUtils.close(popover);}
                    //showDivider: false;
                    progression: true;
                }
                ListItem.Standard {
                    text: "Journey Planner"; //icon: "settings"; iconFrame: false;
                    onTriggered: {pageStack.push(mainPage); PopupUtils.close(popover);}
                    //showDivider: false;
                    progression: true;
                }
            }
        }
    }

    /* DIALOGS DEFINED HERE ***************************************************/
    ServiceProviderDialog {id: serviceProviderDialogue;}
    SearchThumbnailDialogue {id: searchThumbnailDialogue;}

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
        property int searchThumbNum: 0
        property bool searchThumbBool: true
    }

    property var stored: Settings {
        property int n_favourites: 2
        property var favourites: ["1057", "6891", "1025"]
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

            bus_stop_name_search_code: "api.at.govt.nz/v1/gtfs/stops/stopCode/";
            bus_stop_name_search_code_2: "?api_key=";
            bus_stop_name_search_code_query: "$.response[*]";

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

    ListModel {
        id: searchThumbnailTypes
        ListElement { name: "Map View"; description: "Shows map view thumbs"; image: "../icons/mapview.png" }
        ListElement { name: "Street View"; description: "Shows street view thumbs"; image: "../icons/streetview.jpg" }
    }

    /* GLOBAL FUNCTIONS DEFINED HERE ******************************************/

    function time(hh, mm) {
        var end = ""
        if (root.settings.show12hrTime === true) {
            if (hh > 12) {hh -= 1; end = " pm"} else {end = " am"}
        }
        return hh + ":" + mm + end
    }

    /* FAVOURITES FUNCTIONS ***************************************************/

    function isFavourite(stop_id) {
        for (var i = 0; i < stored.n_favourites; i++) {
            if (stop_id === stored.favourites[i]) {return true;}
        } return false;
    }

    function addFavourite(stop_id) {
        if (isFavourite(stop_id)) {return;}
        else {stored.favourites.push(stop_id); stored.n_favourites += 1;}
        return;
    }

    function removeFavourite(stop_id) {
        for (var i = 0; i < stored.n_favourites; i++) {
            if (stop_id === stored.favourites[i]) {
                delete stored.favourites[i];
                stored.n_favourites -= 1;
                return;
            }
        } return;
    }
}

