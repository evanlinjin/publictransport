import QtQuick 2.4
import Ubuntu.Components 1.3
import U1db 1.0 as U1db
import Qt.labs.settings 1.0
import Ubuntu.Components.Themes 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem
import "JSONListModel"
import "components"
import "pages"
import "views"
import "dialogs"
import "api"
import "backends"

MainView {
    id: root;
    objectName: "mainView"
    applicationName: "publictransport.evanlinjin"
    automaticOrientation: true
    anchorToKeyboard: true
    theme.name : settings.theme// "Ubuntu.Components.Themes.SuruDark" // "Ubuntu.Components.Themes.Ambiance"


    property real margins: units.gu(2)
    property var searchHistory: []

    property bool whetherLoading: false

    property string searchQuery: ""
    property JSONListModel nameSearch: aucklandTransportBackend.nameSearch

    property ListModel favourites: aucklandTransportBackend.favourites
    property ListModel notifications: aucklandTransportBackend.notifications


    width: units.gu(100)
    height: units.gu(75)

    PageStack {id: pageStack; Component.onCompleted: {push(mainPage);}}

    /* PAGES DEFINED HERE *****************************************************/
    HomePage {id: mainPage; visible: false;}
    SettingsPage {visible: false; id: settingsPage;}
    Component {id: settingsNotificationsPage; SettingsNotificationsPage { visible: false;}}
    Component {id: aboutPage; AboutPage {visible: false;}}

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

    /* DATABASES AND MODELS DEFINED HERE **************************************/
    AucklandTransport {id: aucklandTransportBackend}


    /* LIST MODELS DEFINED HERE ***********************************************/

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
