import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem

Component {
    Dialog {
        id: dialogue
        title: "Search Thumbnail Settings"
        width: mainPage.width

        ListItem.ItemSelector {
            id: selector
            expanded: true;
            selectedIndex: settings.searchThumbNum
            model: searchThumbnailTypes
            delegate: selectorDelegate
        }

        Component {
            id: selectorDelegate
            OptionSelectorDelegate {
                text: name;
                //subText: description;
                height: units.gu(6);
                constrainImage: true;
                //colourImage: true;
                iconSource: image;
            }
        }

        Row {
            spacing: units.gu(1)

            Button {
                width: (parent.width / 2) - units.gu(0.5)
                text: i18n.tr("Cancel")
                //color: UbuntuColors.grey
                onClicked: {PopupUtils.close(dialogue);}
            }

            Button {
                width: (parent.width / 2) - units.gu(0.5)
                text: i18n.tr("Select")
                color: UbuntuColors.green
                onClicked: {
                    settings.searchThumbNum = selector.selectedIndex
                    PopupUtils.close(dialogue);
                    settingsPage.update();
                }
            }
        }
        onActiveFocusChanged: {
            selector.selectedIndex = settings.searchThumbNum;
            settingsPage.update();
        }
    }
}
