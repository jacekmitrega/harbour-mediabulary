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
import QtQuick.XmlListModel 2.0


Page {
    id: learnPage

    property string text

    XmlListModel {
        id: watchmiChannelModel
        source: "http://mediabulary.herokuapp.com/flashcards/" + learnPage.text
        query: "/root/flashcards/item"

        XmlRole { name: "word"; query: 'word/string()' }
        XmlRole { name: "translation"; query: 'translation/string()' }

        onStatusChanged: {
            console.log("query: " + learnPage.text);
            if (status === XmlListModel.Ready) {
                console.log('count: ' + count);
                for (var i = 0; i < count; i++) {
                    console.log(i);
                    var item = get(i);
                    console.log(item.word);
                }
            }
        }
    }

    SilicaListView {
        id: vocabularyListView

        header: PageHeader {
            title: qsTr("Vocabulary")
        }

        model: watchmiChannelModel
        delegate: ListItem {

            width: vocabularyListView.width - Theme.paddingMedium * 2
            x: Theme.paddingMedium
            contentHeight: Theme.itemSizeSmall

            Label {
                id: wordLabel
                text: word
                elide: Text.ElideRight
                maximumLineCount: 1

                anchors.left: parent.left
                anchors.right: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            Label {
                id: translationLabel
                text: translation
                visible: false

                elide: Text.ElideRight
                maximumLineCount: 1

                anchors.right: parent.right
                anchors.left: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            onClicked: translationLabel.visible = !translationLabel.visible
        }

        anchors.fill: parent

        ScrollDecorator { }
    }
}
