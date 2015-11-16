import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.ListItems 1.3

Component {
    Dialog {
        id: dialogue

        property string stop_id: ""
        property string stop_name: ""
        property string stop_code: ""
        //        property string stop_lat: ""
        //        property string stop_lon: ""
        //        property string routes: ""

        title: "Confirmation"

        Icon {
            id: favouriteIcon
            height: units.gu(5); width: units.gu(5);
            name: "non-starred";
        }

        Label {
            id: description
            text: i18n.tr("Remove <i><b>" + stop_code + "</b> " + stop_name + "</i>, from your favourites?");
            //width: dialogue.width/4 - favouriteIcon.width;
            //height: mainPage.height / 2;
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            color: UbuntuColors.darkGrey
            //fontSize: "small"
        }

        Row {
            spacing: units.gu(1)

            Button {
                width: (parent.width / 2) - units.gu(0.5)
                text: i18n.tr("Cancel")
                //color: UbuntuColors.grey
                onClicked: {
                    PopupUtils.close(dialogue);
                }
            }

            Button {
                width: (parent.width / 2) - units.gu(0.5)
                text: i18n.tr("Remove")
                color: UbuntuColors.red
                onClicked: {
                    favourites.removeFavourite(stop_id);
                    root.reloadHome();
                    PopupUtils.close(dialogue);
                }
            }
        }
    }
}
