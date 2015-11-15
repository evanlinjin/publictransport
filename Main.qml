import QtQuick 2.4
import Ubuntu.Components 1.3
import U1db 1.0 as U1db
import Qt.labs.settings 1.0
import Ubuntu.Components.Themes 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem
import QtPositioning 5.2
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
    property JSONListModel locationSearch: aucklandTransportBackend.locationSearch

    property ListModel favourites: aucklandTransportBackend.favourites
    property ListModel notifications: aucklandTransportBackend.notifications


    width: units.gu(100)
    height: units.gu(75)

    PageStack {id: pageStack; Component.onCompleted: {push(mainPage);}}

    /* PAGES DEFINED HERE *****************************************************/

    HomePage {id: mainPage; visible: false; head.contents: CustomHeader{}}
    SettingsPage {visible: false; id: settingsPage; head.contents: CustomHeader{}}
    Component {id: settingsNotificationsPage; SettingsNotificationsPage { visible: false; head.contents: CustomHeader{}}}
    Component {id: aboutPage; AboutPage {visible: false; head.contents: CustomHeader{}}}

    /* DIALOGS DEFINED HERE ***************************************************/

    ServiceProviderDialog {id: serviceProviderDialogue;}
    SearchThumbnailDialogue {id: searchThumbnailDialogue;}

    /* HIDDEN STUFF DEFINED HERE **********************************************/

    APIKey {id: apiKey} // This file cannot be shared.

    /* DEFAULT SETTINGS DEFINED HERE ******************************************/

    property var settings: Settings {
        property int serviceProviderIndex: 0

        property int themeIndex: 0
        property string theme: "Ubuntu.Components.Themes.Ambiance"

        property bool show12hrTime: true
        property bool notificationsBool: false

        property string current_lat: "-36.879091"
        property string current_lon: "174.91127"

        property int searchResultsNum: 10
        property int searchThumbNum: 0
        property bool searchThumbBool: true
        property int searchRadius: 500
    }

    /* DATABASES AND MODELS DEFINED HERE **************************************/

    AucklandTransport {id: aucklandTransportBackend}


    /* LIST MODELS DEFINED HERE ***********************************************/

    ListModel {
        id: serviceProviders

        ListElement {
            name: "Auckland Transport";
            icon: "../icons/AucklandTransport.png";
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

    function getLocation() {
        positionSource.update();
        if (typeof positionSource.position.coordinate.latitude === 'number') {
            settings.current_lat = (positionSource.position.coordinate.latitude).toFixed(6)
        }
        if (typeof positionSource.position.coordinate.longitude === 'number') {
            settings.current_lon = (positionSource.position.coordinate.longitude).toFixed(5)
        }
        locationSearch.updateJSONModel(); return;
    }

    /* LOCATION DATA **********************************************************/
    PositionSource {id: positionSource}
}
