import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import "../icons"

Row {
    id: main
    width: mainPage.width

    property int tab_h: header.height + units.gu(0.5);
    property int tab_w: header.height;
    property int icon_size: units.gu(2)

    property string highlight_color: themes.get(settings.themesIndex).searchBackground
    property string unhighlight_color: "transparent"

    function update() {
        tab1.color = (settings.searchViewIndex === tab1.index) ?
                    highlight_color : unhighlight_color;

        tab2.color = (settings.searchViewIndex === tab2.index) ?
                    highlight_color : unhighlight_color;

        icon1.color = (settings.searchViewIndex === tab1.index) ?
                    "white" : "#808080";

        icon2.color = (settings.searchViewIndex === tab2.index) ?
                    "white" : "#808080";
    }

    Rectangle {width: units.gu(1); height: width; color: "transparent"}

    /* TAB 1: *****************************************************************/
    Rectangle { id: tab1; property int index: 0;

        height: tab_h; width: tab_w;
        color: (settings.searchViewIndex === index) ? highlight_color : unhighlight_color

        Icon { id: icon1;
            height: icon_size; anchors.centerIn: parent;
            color: (settings.searchViewIndex === parent.index) ? "white" : "#808080"
            name: "view-list-symbolic"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                settings.searchViewIndex = parent.index
                Haptics.play({duration: 25, attackIntensity: 0.7})
            }
        }
    }

    /* TAB 2: *****************************************************************/
    Rectangle { id: tab2; property int index: 1;

        height: tab_h; width: tab_w;
        color: (settings.searchViewIndex === index) ? highlight_color : unhighlight_color

        Icon { id: icon2;
            height: icon_size; anchors.centerIn: parent;
            color: (settings.searchViewIndex === parent.index) ? "white" : "#808080"
            name: "camera-grid"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                settings.searchViewIndex = parent.index
                Haptics.play({duration: 25, attackIntensity: 0.7})
            }
        }
    }
}
