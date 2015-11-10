import QtQuick 2.4
import Ubuntu.Components 1.3
import "components"
import "pages"

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    id: root;
    objectName: "mainView"
    applicationName: "publictransport.evanlinjin"
    automaticOrientation: true
    anchorToKeyboard: true

    property real margins: units.gu(2)

    width: units.gu(100)
    height: units.gu(75)

    PageStack {id: pageStack; Component.onCompleted: {push(mainPage);}}

    HomePage {id: mainPage; visible: false;}
    SettingsPage {id: settingsPage; visible: false;}
    AboutPage {id: aboutPage; visible: false;}
}

