import QtQuick 2.4
import "../JSONListModel"

Component {
    id: aucklandTransportBackend

    property string apiKey: "key"

    property string searchQuery: ""

    JSONListModel {
        id: busStopsQuery // Actual list at ".model"
        source: url + searchQuery + url2 + apiKey;
        query: jsonQuery;

        property string url: "https://api.at.govt.nz/v1/gtfs/stops/search/"
        property string url2: "?api_key="
        property string jsonQuery: "$.response[*]"
        property string searchQuery: ""
    }

    function getBusStopsQueryRaw(query, n_results) {
        busStopsQuery.searchQuery = query;
        for (var i = 0; i < 10; i++) {
            if (busStopsQuery.model === [] || busStopsQuery.model.length === 0) {return busStopsQuery.model;}
            else {setTimeout(200);}
        }
        var output = busStopsQuery.model
        return output
    }
}
