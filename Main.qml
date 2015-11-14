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
    property var searchHistory: []

    width: units.gu(100)
    height: units.gu(75)

    PageStack {id: pageStack; Component.onCompleted: {push(mainPage);}}

    /* PAGES DEFINED HERE *****************************************************/
    HomePage {id: mainPage; visible: false;}
    SettingsPage {visible: false; id: settingsPage;}
    Component {id: settingsNotificationsPage; SettingsNotificationsPage { visible: false;}}
    Component {id: aboutPage; AboutPage {visible: false;}}

    /* HEADERS DEFINED HERE ***************************************************/

    /* COMPONENTS DEFINED HERE ************************************************/
    //    Component { id: pager

    //        Dialog {
    //            id: popover
    //            edgeMargins: units.gu(10)

    //            Column {
    //                id: containerLayout

    //                ListItem.Standard {
    //                    text: mainPage.title; //icon: "settings"; iconFrame: false;
    //                    onTriggered: {pageStack.push(mainPage); PopupUtils.close(popover);}
    //                    //showDivider: false;
    //                    progression: true;
    //                }
    //                ListItem.Standard {
    //                    text: "Journey Planner"; //icon: "settings"; iconFrame: false;
    //                    onTriggered: {pageStack.push(mainPage); PopupUtils.close(popover);}
    //                    //showDivider: false;
    //                    progression: true;
    //                }
    //            }
    //        }
    //    }

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

        property int searchResultsNum: 10
        property int searchThumbNum: 0
        property bool searchThumbBool: true
    }

    /* DATABASES, DOCUMENTS, INDEX AND QUERIES DEFINED HERE *******************/
    U1db.Database {
        id: favouritesDatabase;
        path: "favouritesDatabase";

        function append() {
            var stop_ids = favouritesDatabase.listDocs()
            var index = 0;
            for (var i = 0; i < stop_ids.length; i++) {
                if (getDoc(stop_ids[i]).name !== "") {
                    favourites.append({
                                          "index" : index,
                                          "id" : stop_ids[i],
                                          "code" : getDoc(stop_ids[i]).code,
                                          "name" : getDoc(stop_ids[i]).name,
                                          "lat" : getDoc(stop_ids[i]).lat,
                                          "lon" : getDoc(stop_ids[i]).lon,
                                          "routes" : getDoc(stop_ids[i]).routes,
                                      })
                    index++;
                }
            }
        }
        Component.onCompleted: append();
    }

    function isFavourite(stop_id) {
        var stop_ids = favouritesDatabase.listDocs()

        for (var i = 0; i < stop_ids.length; i++) {
            if (stop_ids[i] === stop_id) {
                if (favouritesDatabase.getDoc(stop_id).name === "") {return false;}
                else {return true;}
            }
        }
        return false;
    }

    // addFavourite(stop_id, [stop_name, stop_code, stop_lat, stop_lon, routes])
    function addFavourite(stop_id, info) {

        var qmlString = "

import QtQuick 2.4;
import U1db 1.0 as U1db;
    U1db.Document {
        id: '" + "id" + stop_id + "';
        database: favouritesDatabase;
        docId: '" + stop_id + "';
        contents: {'name'   : '" + info[0] + "',
                   'code'   : '" + info[1] + "',
                   'lat'    : '" + info[2] + "',
                   'lon'    : '" + info[3] + "',
                   'routes' : ''
        }
    }"

        Qt.createQmlObject(qmlString, favouritesDatabase);

        return
    }

    function removeFavourite(stop_id) {
        console.log("Attempting to delete bus stop " + stop_id + " from favourites.")
        console.log(JSON.stringify(favouritesDatabase.getDoc(stop_id)))
        addFavourite(stop_id, ["", "", "", ""])
        console.log("FAVOURITES NOW: " + favouritesDatabase.listDocs())
        return
    }

    // toggleFavourite(stop_id, [stop_name, stop_code, stop_lat, stop_lon, routes])
    // toggleFavourite(stop_id)
    function toggleFavourite(stop_id, info) {
        if (isFavourite(stop_id)) {removeFavourite(stop_id); return;}
        else {addFavourite(stop_id, info)}
        return
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
}
