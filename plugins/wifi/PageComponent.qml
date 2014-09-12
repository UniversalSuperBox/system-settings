/*
 * Copyright 2013 Canonical Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import SystemSettings 1.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import Ubuntu.SystemSettings.Wifi 1.0
import QMenuModel 0.1

ItemPage {
    id: wifibase
    title: i18n.tr("Wi-Fi")

    UnityMenuModel {
        id: menuModel
        busName: "com.canonical.indicator.network"
        actions: { "indicator": "/com/canonical/indicator/network" }
        menuObjectPath: "/com/canonical/indicator/network/phone_wifi_settings"
        Component.onCompleted: {
            menuStack.head = menuModel;
        }
    }
    UnityMenuModelStack {
        id: menuStack
    }
    MenuItemFactory {
        id: menuFactory
        model: mainMenu.model
    }

    // workaround of getting the following error on startup:
    // WARNING - file:///usr/..../wifi/PageComponent.qml:24:1: QML Page: Binding loop detected for property "flickable"
    flickable: null
    Component.onCompleted: {
        flickable = pageFlickable
    }

    Flickable {
        id: pageFlickable
        anchors.fill: parent

        contentWidth: parent.width
        contentHeight: contentItem.childrenRect.height


        Column {
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }

            Repeater {
                id: mainMenu
                model: menuStack.tail ? menuStack.tail : null
                delegate: Item {
                    id: menuDelegate

                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                    height: loader.height
                    visible: height > 0

                    Loader {
                        id: loader
                        asynchronous: true

                        property int modelIndex: index

                        anchors {
                            left: parent.left
                            right: parent.right
                        }

                        sourceComponent: menuFactory.load(model)

                        onLoaded: {
                            if (model.type === "com.canonical.indicator.root") {
                                menuStack.push(mainMenu.model.submenu(index));
                            }

                            if (item.hasOwnProperty("menuActivated")) {
                                item.menuActivated = Qt.binding(function() { return ListView.isCurrentItem; });
                                item.selectMenu.connect(function() { ListView.view.currentIndex = index });
                                item.deselectMenu.connect(function() { ListView.view.currentIndex = -1 });
                            }
                            if (item.hasOwnProperty("menu")) {
                                item.menu = Qt.binding(function() { return model; });
                            }
                        }
                    }
                }
            }

            ListItem.Divider {}

            ListItem.SingleValue {
                text: i18n.tr("Previous networks")
                progression: true
                onClicked: pageStack.push(Qt.resolvedUrl("PreviousNetworks.qml"))
            }

            ListItem.SingleValue {
                text: i18n.tr("Other network")
                progression: true
                onClicked: {
                    otherNetwork.source = "OtherNetwork.qml";
                    PopupUtils.open(otherNetwork.item);
                }
            }
        }

        bottomMargin: Qt.inputMethod.visible ? (Qt.inputMethod.keyboardRectangle.height - main.anchors.bottomMargin) : 0

        Behavior on bottomMargin {
            NumberAnimation {
                duration: 175
                easing.type: Easing.OutQuad
            }
        }
        // TODO - does ever frame.
        onBottomMarginChanged: {
            mainMenu.positionViewAtIndex(mainMenu.currentIndex, ListView.End)
        }

        // Only allow flicking if the content doesn't fit on the page
        boundsBehavior: (contentHeight > wifibase.height) ?
                            Flickable.DragAndOvershootBounds :
                            Flickable.StopAtBounds
    }

    Loader {
        id: otherNetwork
        asynchronous: false
    }
}
