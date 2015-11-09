import QtQuick 2.4
import Ubuntu.Components 1.3
import "../components"

Page {
    title: i18n.tr("Settings");

    head.contents: CustomHeader {}
    head.actions:
        Action {
                iconName: "info";
        text: i18n.tr("Information");
        onTriggered: {pageStack.push(aboutPage);}
    }
}

