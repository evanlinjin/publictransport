import QtQuick 2.4
import Ubuntu.Components 1.3

import U1db 1.0 as U1db
import "../JSONListModel"
import "../api"

Item {

    property JSONListModel nameSearch: nameSearch

    property ListModel favourites: favourites
    property ListModel notifications: notifications


    /**************************************************************************/
    /*                                                         SEARCH SECTION */
    /**************************************************************************/

    // -------------------------------------------------------- JSON LIST MODELS

    JSONListModel {
        id: nameSearch
        source: "https://api.at.govt.nz/v1/gtfs/stops/search/" + root.searchQuery + "?api_key=" + apiKey.at
        query: "$.response[*]"
        Component.onCompleted: root.whetherLoading = false;
    }

    /**************************************************************************/
    /*                                                     FAVOURITES SECTION */
    /**************************************************************************/


    // ----------------------------------------- FAVOURITES DATABASE & LISTMODEL

    U1db.Database {
        id: favouritesDatabase;
        path: "favouritesDatabase";
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
                if (favouritesDatabase.getDoc(stop_ids[i]).name !== "") {
                    append({
                               "index" : index,
                               "id" : stop_ids[i],
                               "code" : favouritesDatabase.getDoc(stop_ids[i]).code,
                               "name" : favouritesDatabase.getDoc(stop_ids[i]).name,
                               "lat" : favouritesDatabase.getDoc(stop_ids[i]).lat,
                               "lon" : favouritesDatabase.getDoc(stop_ids[i]).lon,
                               "routes" : favouritesDatabase.getDoc(stop_ids[i]).routes,
                           })
                    index++;
                }
            }
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

        function toggleFavourite(stop_id, info) {
            if (isFavourite(stop_id)) {removeFavourite(stop_id); return;}
            else {addFavourite(stop_id, info)}
            return
        }
    }

    /**************************************************************************/
    /*                                                  NOTIFICATIONS SECTION */
    /**************************************************************************/

    // -------------------------------------------------- NOTIFICATIOS LISTMODEL

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

}
