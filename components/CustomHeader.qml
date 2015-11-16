import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import "../icons"

Row {
    id: main
    width: mainPage.width

    property string mainTitle: i18n.tr("Public Transport")
    property string iconName: "stock_website"
    //property bool tickerTrigger: false

    Rectangle {width: units.gu(0.5); height: width; color: "transparent"}

    Icon {
        id: icon
        height: units.gu(4)
        //source: serviceProviders.get(settings.serviceProviderIndex).icon
        name: iconName
        color: UbuntuColors.orange
    }

    Rectangle {width: units.gu(2); height: width; color: "transparent"}

    Label {
        anchors.verticalCenterOffset: -(subheading.height / 2)
        text: main.mainTitle
        fontSize: "medium"
        width: parent.width - units.gu(23)
        elide: Text.ElideRight

        Label {
            id: subheading
            anchors.top: parent.bottom
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "<b>" + pageStack.currentPage.title + "</b>"
            fontSize: "x-small"
            width: parent.width
            elide: Text.ElideRight

            MouseArea {
                id: textMouseArea
                z: subheading.z + 1
                anchors.fill: parent
                onClicked: {
                    switch(subheading.elide) {
                    case Text.ElideRight:
                        subheading.elide = Text.ElideLeft;
                        break;
                    case Text.ElideLeft:
                        subheading.elide = Text.ElideRight;
                        break;
                    }
                }
            }

            MouseArea {
                id: textMouseArea2
                z: subheading.z + 1
                anchors.fill: parent
                onClicked: {
                    switch(subheading.elide) {
                    case Text.ElideRight:
                        subheading.elide = Text.ElideLeft;
                        break;
                    case Text.ElideLeft:
                        subheading.elide = Text.ElideRight;
                        break;
                    }
                }
            }
        }
    }



    //    Component.onCompleted: {
    //        if (subheading.truncated === true) {
    //            textTicker.running = true
    //            console.log("TIMER STARTED")
    //        }
    //    }

    //    Timer {
    //        id: textTicker
    //        interval: 3000
    //        running: tickerTrigger
    //        repeat: true
    //        onTriggered: {
    //            console.log("TIMER TRIGGERED")
    //            switch(subheading.elide) {
    //            case Text.ElideRight:
    //                subheading.elide = Text.ElideLeft;
    //                break;
    //            case Text.ElideLeft:
    //                subheading.elide = Text.ElideRight;
    //                break;
    //            }
    //        }
    //    }
}




