import QtQuick 2.4
import Ubuntu.Components 1.3

import U1db 1.0 as U1db
import "../JSONListModel"
import "../api"

Item {

    property JSONListModel nameSearch: nameSearch
    property JSONListModel locationSearch: locationSearch

    property ListModel favourites: favourites
    property ListModel notifications: notifications


    /**************************************************************************/
    /*                                                         SEARCH SECTION */
    /**************************************************************************/

    // ----------------------------------------------------------- JSONLISTMODEL

    JSONListModel {
        id: nameSearch
        source: "https://api.at.govt.nz/v1/gtfs/stops/search/" + root.searchQuery +
                "?api_key=" + apiKey.at

        query: "$.response[*]"
        Component.onCompleted: console.log("NAME SEARCH ADDRESS:" + nameSearch.source)
    }

    /**************************************************************************/
    /*                                                     FAVOURITES SECTION */
    /**************************************************************************/


    // ----------------------------------------- FAVOURITES DATABASE & LISTMODEL

    U1db.Database {
        id: favouritesDatabase;
        path: "favouritesDatabase3";
        Component.onCompleted: favourites.reloadList();
    }

    ListModel {
        id: favourites

        // APPEND FUNCTION: Reloads "favourites" listmodel.
        // TODO: This needs to be more efficient.
        function reloadList() {
            clear()
            var stop_ids = favouritesDatabase.listDocs()
            var index = 0;
            for (var i = 0; i < stop_ids.length; i++) {
                if (favouritesDatabase.getDoc(stop_ids[i]).stop_name !== "") {
                    append({
                               "index" : index,
                               "stop_id" : stop_ids[i],
                               "stop_code" : favouritesDatabase.getDoc(stop_ids[i]).stop_code,
                               "stop_name" : favouritesDatabase.getDoc(stop_ids[i]).stop_name,
                               "stop_lat" : favouritesDatabase.getDoc(stop_ids[i]).stop_lat,
                               "stop_lon" : favouritesDatabase.getDoc(stop_ids[i]).stop_lon,
                               "stop_routes" : favouritesDatabase.getDoc(stop_ids[i]).stop_routes,
                           })
                    index++;
                }
            }
        }

        function isFavourite(stop_id) {
            var stop_ids = favouritesDatabase.listDocs()

            for (var i = 0; i < stop_ids.length; i++) {
                if (stop_ids[i] === stop_id) {
                    if (favouritesDatabase.getDoc(stop_id).stop_name === "") {return false;}
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
            id: '" + "stop_id" + stop_id + "';
            database: favouritesDatabase;
            docId: '" + stop_id + "';
            contents: {'stop_name'   : '" + info[0] + "',
                       'stop_code'   : '" + info[1] + "',
                       'stop_lat'    : '" + info[2] + "',
                       'stop_lon'    : '" + info[3] + "',
                       'routes' : ''
            }
        }"

            Qt.createQmlObject(qmlString, favouritesDatabase);

            return
        }

        // TODO: This needs to be implemented properly.
        function removeFavourite(stop_id) {
            addFavourite(stop_id, ["", "", "", ""])
            return
        }

        function toggleFavourite(stop_id, info) {
            if (isFavourite(stop_id)) {removeFavourite(stop_id); return;}
            else {addFavourite(stop_id, info)}
            return
        }
    }

    /**************************************************************************/
    /*                                                         NEARBY SECTION */
    /**************************************************************************/

    // ---------------------------------------------------- NEARBY JSONLISTMODEL

    JSONListModel {
        id: locationSearch
        source: "https://api.at.govt.nz/v1/gtfs/stops/geosearch?lat=" + settings.current_lat +
                "&lng=" + settings.current_lon +
                "&distance=" + settings.searchRadius +
                "&api_key=" + apiKey.at

        query: "$.response[*]"

        Component.onCompleted: {
            console.log("LOCATION SEARCH ADDRESS:" + locationSearch.source)
        }

        function reloadList() {
            root.whetherLoadingNearby = true;
            root.getLocation()
            locationSearch.source = "";
            locationSearch.query = "";
            locationSearch.model.clear();
            timer.running = true;
        }

        Timer {
            id: timer
            interval: 1;
            running: false;
            repeat: false;
            onTriggered: {
                locationSearch.source = "https://api.at.govt.nz/v1/gtfs/stops/geosearch?lat=" + settings.current_lat +
                        "&lng=" + settings.current_lon +
                        "&distance=" + settings.searchRadius +
                        "&api_key=" + apiKey.at
                locationSearch.query = "$.response[*]"
                root.whetherLoadingNearby = false;
            }
        }
    }


    /**************************************************************************/
    /*                                                  REALTIMEBOARD SECTION */
    /**************************************************************************/

    // --------------------------------------------- REALTIMEBOARD JSONLISTMODEL

    JSONListModel {
        id: jsonTimeBoard
        source: "api.at.govt.nz/v1/gtfs/stopTimes/stopId/" + "0000" +
                "?api_key=" + apiKey.at

        query: "$.response[*]"
    }

    // ------------------------------------------------- REALTIMEBOARD LISTMODEL

    ListModel {
        id: stopTimeBoard

        function getRoutes(stop_id) {

            // Change JSON to get "Stop Times by stop_id"
            jsonTimeBoard.source = "api.at.govt.nz/v1/gtfs/stopTimes/stopId/" +
                    stop_id + "?api_key=" + apiKey.at

            // Determine the current time in seconds and "appropriate times".
            var timeInSeconds = Date.prototype.getHours() * 3600 +
                    Date.prototype.getMinutes() * 60 +
                    Date.prototype.getSeconds()

            var listStartTime = timeInSeconds - 120; // This probably needs to be changed later, considering how unreliable Auckland Transport is.
            var listEndTime = timeInSeconds + 10800; // + 3hrs

            // Continue only if JSONListModel is properly populated.
            for (var i = 0; i < 5; i++) {
                if (jsonTimeBoard.model.count > 0) {

                    // Append appropriate elements of "Stop Times by stop_id" to
                    // listModel. (i.e. between the appropriate time zones.)
                    var tempDepartureTime
                    for (var j = 0; j < jsonTimeBoard.model.count; j++) {
                        tempDepartureTime = jsonTimeBoard.model.get(i).departure_time_seconds;
                        if (tempDepartureTime >= listStartTime && tempDepartureTime <= listEndTime) {
                            stopTimeBoard.append(jsonTimeBoard.model.get(i));
                        }
                    }
                    break;
                }
            }

            // Sort list by departure_time_seconds (nearest to furthest)
            for (i = 0; i < jsonTimeBoard.model.count; i++) {
            }
        }
    }

    /**************************************************************************/
    /*                                                  NOTIFICATIONS SECTION */
    /**************************************************************************/

    // ------------------------------------------------- NOTIFICATIONS LISTMODEL

    ListModel {
        id: notifications

        ListElement {
            service: "Auckland Transport";
            on: true;
            start_h: "06"; start_m: "00";
            end_h: "08"; end_m: "30";
        }

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

}
