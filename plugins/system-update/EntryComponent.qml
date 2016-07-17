/*
 * This file is part of system-settings
 *
 * Copyright (C) 2014-2016 Canonical Ltd.
 *
 * Contact: Diego Sarmentero <diego.sarmentero@canonical.com>
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
 */

import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem
// import Ubuntu.DownloadManager 1.2
import Ubuntu.SystemSettings.Update 1.0

ListItem.SingleValue {
    id: root

    height: updatesRep.count > 0 ? units.gu(6) : 0

    text: i18n.tr(model.displayName)
    objectName: "entryComponent-updates"
    iconSource: Qt.resolvedUrl(model.icon)
    iconFrame: false
    progression: true
    value: updatesRep.count

    onClicked: main.loadPluginByName("system-update");

    UpdateModelFilter {
        id: updates
        kindFilter: Update.KindClick
        installed: false
    }

    // DownloadManager {
    //     onDownloadFinished: {
    //         SystemUpdate.model.setInstalled(
    //             download.metadata.custom.identifier,
    //             download.metadata.custom.revision
    //         );
    //     }
    // }

    SystemImageHandler {
        updateModel: SystemUpdate.model
    }

    Repeater {
        width: 1
        height: 1
        id: updatesRep
        model: updates
        Item { width: 1; height: 1 }
    }

    Behavior on height { UbuntuNumberAnimation {} }
}
