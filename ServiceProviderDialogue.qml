import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.ListItems 1.3

Component {
    Dialog {
        id: dialogue
        title: "Change Service Provider"

        Label {
            id: description
            text: i18n.tr("<b>Note:</b> Changing the service provider will present you with a different set of favourites, history and notifications. This will not delete your original data. Simply revert to your original service provider to go back.");
            //width: mainPage.width - root.margins;
            //height: mainPage.height / 2;
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            fontSize: "small"
        }

        //Label {text: i18n.tr("Service Provider");}

        OptionSelector {
            id: serviceProviderSelector
            model: serviceProviders
            delegate: OptionSelectorDelegate {text: name;}
            selectedIndex: rectangleColors.getIndex(c);
            onSelectedChanged: {update();}
            showDivider: false
            function update() {c = rectangleColors.get(colorSelector.selectedIndex).color;}
        }

        Row {
            spacing: units.gu(1)

            Button {
                width: (parent.width / 2) - units.gu(0.5)
                text: i18n.tr("Cancel")
                color: UbuntuColors.grey
                onClicked: {PopupUtils.close(dialogue);}
            }

            Button {
                width: (parent.width / 2) - units.gu(0.5)
                text: i18n.tr("Select")
                color: UbuntuColors.green
                onClicked: {PopupUtils.close(dialogue);}
            }
        }
    }
}

