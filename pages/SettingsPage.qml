import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem2
import Ubuntu.Components.Popups 1.3

import "../components"

Page {
    title: i18n.tr("Settings");
    head.actions: [
        Action {
            iconName: "info";
            text: i18n.tr("Information");
            onTriggered: {pageStack.push(aboutPage);}
        }
    ]
    head.foregroundColor: "#1E3D51"

    onActiveChanged: update()

    function update() {
        searchThumbnailSelector.subText = i18n.tr(searchThumbnailTypes.get(settings.searchThumbNum).name);
        flickable.update();
    }

    Flickable {
        id: flickable

        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: settingsColumn.height

        Column {
            id: settingsColumn

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }

            ListItem2.Divider {} ListItem2.Header { text: "General:"}

            ListItem2.Subtitled {
                id: searchThumbnailSelector
                text: i18n.tr("Thumbnail Type")
                subText: i18n.tr(searchThumbnailTypes.get(settings.searchThumbNum).name)
                showDivider: false
                progression: true
                onClicked: {PopupUtils.open(searchThumbnailDialogue, searchThumbnailSelector)}
            }

            ListItem2.Divider {} ListItem2.Header { text: "Theme:"}

            ListItem2.Standard {
                id: tihemeSelector
                text: i18n.tr("Use Dark Theme")
                showDivider: false
                control : Switch {
                    id: themeSwitch
                    checked: settings.theme === "Ubuntu.Components.Themes.SuruDark"
//                    onClicked: {
//                        if (checked) {settings.theme = theme.name = "Ubuntu.Components.Themes.SuruDark"}
//                        else {settings.theme = theme.name = "Ubuntu.Components.Themes.Ambiance"}
//                    }
                    onCheckedChanged: {
                        if (checked) {settings.theme = theme.name = "Ubuntu.Components.Themes.SuruDark"}
                        else {settings.theme = theme.name = "Ubuntu.Components.Themes.Ambiance"}
                    }
                }
            }

            ListItem2.Divider {} ListItem2.Header { text: "Service Provider:"}

            ListItem2.Subtitled {
                id: serviceProviderSelector
                text: i18n.tr("Change Service Provider...")
                subText: i18n.tr("Auckland Transport")
                showDivider: false
                progression: true
                onClicked: {PopupUtils.open(serviceProviderDialogue, serviceProviderSelector)}
            }
        }
    }
}
