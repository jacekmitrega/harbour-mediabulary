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
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0


Page {
    id: page

    property string searchQuery: "Fußball"

    XmlListModel {
        id: watchmiModel
        source: !page.searchQuery ? ""
                                  : "http://hackathon.lab.watchmi.tv/api/example.com/broadcasts/limit/12/format/xml-ptv/query/"
                                    + page.searchQuery
        namespaceDeclarations: "declare default element namespace 'http://www.as-guides.com/schema/epg';"
        query: "/pack/data"

        XmlRole { name: "title"; query: "tit/string()" }
        XmlRole { name: "description"; query: "losyn/string()" }
    }

    SilicaListView {
        id: itemListView

        anchors.fill: parent

        ScrollDecorator { }

        PullDownMenu {
            MenuItem {
                text: qsTr('Search')
                onClicked: {
                    var dlg = pageStack.push(Qt.resolvedUrl("SearchDialog.qml"),
                                             { text: searchQuery });
                    dlg.accepted.connect(function () {
                        searchQuery = dlg.text;
                    });
                }
            }
        }

        header: PageHeader {
            title: qsTr("Mediabulary")
        }

        model: watchmiModel

        delegate: ListItem {
            width: itemListView.width - Theme.paddingMedium * 2
            x: Theme.paddingMedium
            contentHeight: Theme.itemSizeExtraLarge

            Column {
                width: parent.width

                Label {
                    width: parent.width
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    text: title
                }
                Label {
                    width: parent.width
                    color: Theme.secondaryColor
                    elide: Text.ElideRight
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    maximumLineCount: 3
                    font.pixelSize: Theme.fontSizeExtraSmall
                    text: description
                }
            }
        }
    }

}
