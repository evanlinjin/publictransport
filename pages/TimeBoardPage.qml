import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem2
import "../components"
import "../"

Page {
    id: page
    title: stop_name

    //--------------------------------------------------------- GLOBAL VARIABLES
    property string stop_id: ""
    property string stop_name: ""
    property string stop_code: ""
    property string stop_lat: ""
    property string stop_lon: ""
    property string routes: ""

    //----------------------------------------------------- COMPONENT PROPERTIES
    Component.objectName: stop_id
    Component.onObjectNameChanged:
        favouritesAction.iconName = favourites.isFavourite(stop_id) ?
            "starred" : "non-starred";

    //---------------------------------------------------------------- FUNCTIONS
    function reload() {
        page.update()
    }

    //-------------------------------------------------------- HEADER DEFINITION
    head {
        actions: [
            Action {
                iconName: "reload"
                text: i18n.tr("Reload")
                onTriggered: {reload()}
            },
            Action {
                id: favouritesAction
                iconName: favourites.isFavourite(stop_id) ? "starred" : "non-starred";
                text: i18n.tr("Favourite");
                onTriggered: {
                    root.toggleFavourites(stop_id,
                                          [
                                              stop_name,
                                              stop_code,
                                              stop_lat,
                                              stop_lon,
                                              routes
                                          ],
                                          page)
                    favouriteTimer.running = true;
                }

            }
        ]
        contents: CustomHeader{mainTitle: stop_id}
    }

    //------------------------------------------------------------------- TIMERS
    Timer {
        id: favouriteTimer
        interval: 1000;
        running: false;
        repeat: true;
        onTriggered: {
            favouritesAction.iconName =
                    favourites.isFavourite(stop_id) ?
                        "starred" : "non-starred";
            console.log("ICON REFRESHED!")
        }
    }
}
