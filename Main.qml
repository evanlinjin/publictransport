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

    property string app_version: "0.1"
    property string app_description: i18n.tr("Search and find bus stops, train stations and ferry piers. View real time boards, and favourite them.")

    width: units.gu(100)
    height: units.gu(75)

    PageStack {id: pageStack; Component.onCompleted: {push(mainPage);}}
    HomePage {id: mainPage; visible: false;}
    SettingsPage {id: settingsPage; visible: false;}
    AboutPage {id: aboutPage; visible: false;}
}

