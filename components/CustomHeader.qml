import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import "../icons"


Row {
    spacing: root.margins

    Icon {
        height: units.gu(4)
        source: "../PublicTransport.png"
    }

    Label {
        id: heading
        Layout.fillWidth: true
        Layout.fillHeight: true
        anchors.verticalCenterOffset: -(subheading.height / 2)
        text: "Public Transport"
        fontSize: "medium"

        Label {
            id: subheading
            anchors.top: parent.bottom
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: pageStack.currentPage.title
            fontSize: "x-small"
        }
    }
}
