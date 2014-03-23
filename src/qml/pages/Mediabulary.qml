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

    property string searchQuery: "bank"

    XmlListModel {
        id: watchmiModel
        source: !page.searchQuery ? ""
                                  : "http://hackathon.lab.watchmi.tv/api/example.com/broadcasts/limit/12/format/xml-ptv/query/"
                                    + page.searchQuery
        namespaceDeclarations: "declare default element namespace 'http://www.as-guides.com/schema/epg';"
        query: "/pack/data"

        XmlRole { name: "titleDeu"; query: 'tit[@lang="deu"]/string()' }
        XmlRole { name: "titleUnd"; query: 'tit[@lang="und"]/string()' }
        XmlRole { name: "extraInfo"; query: "exinf/string()" }
        XmlRole { name: "description"; query: "losyn/string()" }
        XmlRole { name: "image"; query: "brdcst/media/url/string()" }
        XmlRole { name: "timeFrom"; query: "xs:dateTime(time/@strt)" }
        XmlRole { name: "timeTo"; query: "xs:dateTime(time/@strt)" }
        XmlRole { name: "duration"; query: "xs:integer(time/@dur)" }
    }

    function getTitles(titleDeu, titleUnd, extraInfo, description) {
        var title = titleDeu || titleUnd || extraInfo || description;
        var subtitle = extraInfo;
        if (!subtitle.length || subtitle === title) {
            subtitle = description || "";
        }
        return [title, subtitle]
    }

    function getLocaleDate(datetime) {
        return datetime.toLocaleDateString();
    }

    function getLocaleTime(datetime) {
        return datetime.toLocaleTimeString().split(' ')[0];
    }

    function getDuration(duration) {
        return (duration / 60) + " " + qsTr("minutes");
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

            Row {
                width: parent.width

                Item {
                    id: imageItem
                    width: 120
                    height: 100
                    Image {
                        source: image
                        width: 110
                        height: 70
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Column {
                    width: parent.width - imageItem.width;

                    Label {
                        text: getTitles(titleDeu, titleUnd, extraInfo, description)[0]

                        width: parent.width
                        color: Theme.primaryColor
                        elide: Text.ElideRight
                        font.pixelSize: Theme.fontSizeSmall
                    }

                    Label {
                        text: getLocaleTime(timeFrom) + " | " + getDuration(duration)

                        width: parent.width
                        color: Theme.primaryColor
                        font.pixelSize: Theme.fontSizeExtraSmall
                    }

                    Label {
                        text: getTitles(titleDeu, titleUnd, extraInfo, description)[1]

                        width: parent.width
                        color: Theme.secondaryColor
                        elide: Text.ElideRight
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        maximumLineCount: 2
                        font.pixelSize: Theme.fontSizeExtraSmall
                    }
                }
            }
        }
    }

}
