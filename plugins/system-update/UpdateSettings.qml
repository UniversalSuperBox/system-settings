/*
 * This file is part of system-settings
 *
 * Copyright (C) 2017 The UBports project
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 3, as published
 * by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranties of
 * MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR
 * PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authors: Marius Gripsgard <marius@ubports.com>
 */

import QtQuick 2.4
import SystemSettings 1.0
import Ubuntu.Components 1.3
import SystemSettings.ListItems 1.0 as SettingsListItems
import Ubuntu.Connectivity 1.0
import Ubuntu.SystemSettings.Update 1.0


ItemPage {
    id: root
    objectName: "updateSettingsPage"
    title: i18n.tr("Update settings")
    flickable: pageFlickable

    Flickable {
        id: pageFlickable
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: contentItem.childrenRect.height

        // Only allow flicking if the content doesn't fit on the page
        boundsBehavior: (contentHeight > root.height) ?
                         Flickable.DragAndOvershootBounds : Flickable.StopAtBounds


        Column {
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }

            SettingsListItems.SingleValueProgression {
                objectName: "configuration"
                text: i18n.tr("Auto download")
                value: {
                    if (SystemImage.downloadMode === 0)
                        return i18n.tr("Never")
                    else if (SystemImage.downloadMode === 1)
                        return i18n.tr("On WiFi")
                    else if (SystemImage.downloadMode === 2)
                        return i18n.tr("Always")
                    else
                        return i18n.tr("Unknown")
                }
                onClicked: pageStack.addPageToNextColumn(root, Qt.resolvedUrl("Configuration.qml"))
            }

            SettingsListItems.SingleValueProgression {
                objectName: "channel"
                text: i18n.tr("Channels")
                value: {
                  var prettyChannels = {"stable": i18n.tr("Stable"), "rc": i18n.tr("Release candidate"), "devel": i18n.tr("Development")}
                  var channel = SystemImage.getSwitchChannel().split("/");
                  return prettyChannels[channel[channel.length-1]] ? prettyChannels[channel[channel.length-1]] : channel[channel.length-1]
                }
                onClicked: pageStack.addPageToNextColumn(root, Qt.resolvedUrl("ChannelSettings.qml"))
            }
        }
    }
}
