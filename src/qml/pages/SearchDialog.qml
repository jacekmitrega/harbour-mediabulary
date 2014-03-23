/*
    Mediabulary - To understand the media you need vocabulary.
    Copyright (C) 2014 Jacek Mitręga <jacek.mitrega@gmail.com>.

    This file is part of Mediabulary.

    Mediabulary is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Mediabulary is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mediabulary.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: dialog

    property alias text: textInput.text

    DialogHeader { id: header }

    SearchField {
        id: textInput
        placeholderText: qsTr("Search query")

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: header.bottom
        width: parent.width - Theme.paddingMedium

        focus: true

        EnterKey.enabled: text.length > 0
        EnterKey.iconSource: "image://theme/icon-m-enter-accept"
        EnterKey.onClicked: dialog.accept()
    }
}
