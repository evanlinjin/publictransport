import QtQuick 2.4
import Ubuntu.Components 1.3

/*
 Component which displays an empty state (approved by design). It offers an
 icon, title and subtitle to describe the empty state.
*/

Item {
    id: emptyState

    // Public APIs
    property alias iconName: emptyIcon.name
    property alias iconSource: emptyIcon.source
    property alias iconColor: emptyIcon.color
    property alias title: emptyLabel.text
    property alias subTitle: emptySublabel.text

    height: parent.height;
    width: parent.width;

    Icon {
        id: emptyIcon
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        //anchors.verticalCenterOffset: - 1.5 * header.height
        height: units.gu(10)
        width: height
        color: "#BBBBBB"
    }

    Label {
        id: emptyLabel
        anchors.top: emptyIcon.bottom
        anchors.topMargin: units.gu(4)
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter

        fontSize: "large"
        font.bold: true
        width: parent.width * 0.85;
        wrapMode: Text.WordWrap
    }

    Label {
        id: emptySublabel
        anchors.top: emptyLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        width: parent.width * 0.85;
        wrapMode: Text.WordWrap
    }
}
