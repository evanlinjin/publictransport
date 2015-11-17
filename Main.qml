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

    property bool whetherLoadingNearby: false
    property bool whetherLoadingStopTimeBoard: false

    property string searchQuery: ""

    property JSONListModel nameSearch: aucklandTransportBackend.nameSearch
    property JSONListModel locationSearch: aucklandTransportBackend.locationSearch

    property ListModel favourites: aucklandTransportBackend.favourites
    property ListModel notifications: aucklandTransportBackend.notifications

    // Usage: root.stopTimeBoard.getRoutes(stop_id)
    //        model    : root.stopTimeBoard
    //        variables: ROUTE       - route_short_name
    //                   DESTINATION - trip_headsign
    //                   SCHED.      - departure_time_seconds (Needs format)
    //                   DUE         - "UNAVALIABE" (Need to figure this feature out...)
    property ListModel stopTimeBoard: aucklandTransportBackend.stopTimeBoard


    width: units.gu(100)
    height: units.gu(75)

    PageStack {id: pageStack; Component.onCompleted: {push(mainPage);}}

    /* PAGES DEFINED HERE *****************************************************/

    HomePage {id: mainPage; visible: false; head.contents: CustomHeader{iconName: "home"}}
    Component{id: timeBoardPage; TimeBoardPage{visible: false;}}
    SettingsPage {visible: false; id: settingsPage; head.contents: CustomHeader{iconName: "settings"}}
    Component {id: settingsNotificationsPage; SettingsNotificationsPage { visible: false; head.contents: CustomHeader{iconName: "alarm-clock"}}}
    Component {id: aboutPage; AboutPage {visible: false; head.contents: CustomHeader{iconName: "info"}}}

    /* DIALOGS DEFINED HERE ***************************************************/

    ServiceProviderDialog {id: serviceProviderDialogue;}
    SearchThumbnailDialog {id: searchThumbnailDialogue;}
    RemoveFavouriteDialog {id: removeFavouriteDialogue;}

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
        if (typeof positionSource.position.coordinate.latitude === 'number' &&
                positionSource.position.coordinate.latitude >= -90 &&
                positionSource.position.coordinate.latitude <= 90) {
            settings.current_lat = (positionSource.position.coordinate.latitude).toFixed(6)
        }
        if (typeof positionSource.position.coordinate.longitude === 'number' &&
                positionSource.position.coordinate.longitude >= -180 &&
                positionSource.position.coordinate.longitude <= 180) {
            settings.current_lon = (positionSource.position.coordinate.longitude).toFixed(5)
        }
    }

    // FUNCTION:    toggleFavourites(stop_id, info, fromAlias)
    // DESCRIPTION: If not a favourite, adds the favourite. If is a favourite,
    //              presents a dialog asking if you are sure you want to remove
    //              the favourite.
    // USAGE:       toggleFavourites(stop_id, [stop_name, stop_code, stop_lat, stop_lon, routes], favouriteIcon)

    function toggleFavourites(stop_id, info, fromAlias) {

        if (!favourites.isFavourite(stop_id)) {
            favourites.addFavourite(stop_id, info);
            reloadHome()
        } else {
            PopupUtils.open(removeFavouriteDialogue, fromAlias, {
                                    'stop_id': stop_id,
                                    'stop_name': info[0],
                                    'stop_code': info[1]
                                })
        } return
    }

    function reloadHome() {
        //root.getLocation()
        root.favourites.reloadList()
        root.locationSearch.reloadList()
    }

    /* LOCATION DATA **********************************************************/
    PositionSource {id: positionSource}
}
