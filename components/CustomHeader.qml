import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import "../icons"

Row {
    id: main
    spacing: root.margins
    width: mainPage.width

    Icon {
        height: units.gu(4)
        source: serviceProviders.get(0).icon
    }

    Label {
        anchors.verticalCenterOffset: -(subheading.height / 2)
        text: "Public Transport"
        fontSize: "medium"

        Label {
            id: subheading
            anchors.top: parent.bottom
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "<b>" + pageStack.currentPage.title + "</b>"
            fontSize: "x-small"
        }
    }
}
