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

    property string searchQuery: "politik"

    XmlListModel {
        id: watchmiChannelModel
        source: "http://hackathon.lab.watchmi.tv/api/example.com/channels/format/xml-ptv/limit/1000"
        namespaceDeclarations: "declare default element namespace 'http://www.as-guides.com/schema/channel';"
        query: "/Lineup/Ch"

        XmlRole { name: "chid"; query: 'xs:integer(@id)' }
        XmlRole { name: "longName"; query: 'DName/Long/string()' }
        XmlRole { name: "shortName"; query: 'DName/Short/string()' }
        XmlRole { name: "image"; query: "media/url/string()" }
    }

    function getChannel(chid) {
        for (var i = 0; i < watchmiChannelModel.count; i++) {
            var item = watchmiChannelModel.get(i)
            if (item.chid === chid)
            {
                return {
                    chid: item.chid,
                    longName: item.longName,
                    shortName: item.shortName,
                    image: item.image
                }
            }
        }
        return {
            chid: null,
            longName: "",
            shortName: "",
            image: ""
        }
    }


    XmlListModel {
        id: watchmiBroadcastModel
        source: !page.searchQuery ? ""
                                  : ("http://hackathon.lab.watchmi.tv/api/example.com"
                                     + "/broadcasts/format/xml-ptv/limit/64"
                                     + "/query/" + page.searchQuery
                                     + "/day/tomorrow")
        namespaceDeclarations: "declare default element namespace 'http://www.as-guides.com/schema/epg';"
        query: "/pack/data"

        XmlRole { name: "bid"; query: 'xs:integer(@bid)' }
        XmlRole { name: "pid"; query: 'xs:integer(@pid)' }
        XmlRole { name: "chid"; query: 'xs:integer(@chid)' }
        XmlRole { name: "titleDeu"; query: 'tit[@lang="deu"]/string()' }
        XmlRole { name: "titleUnd"; query: 'tit[@lang="und"]/string()' }
        XmlRole { name: "extraInfo"; query: "exinf/string()" }
        XmlRole { name: "description"; query: "losyn/string()" }
        XmlRole { name: "image"; query: "brdcst/media/url/string()" }
        XmlRole { name: "timeFrom"; query: "xs:dateTime(time/@strt)" }
        XmlRole { name: "timeTo"; query: "xs:dateTime(time/@strt)" }
        XmlRole { name: "duration"; query: "xs:integer(time/@dur)" }
        XmlRole { name: "dateFrom"; query: "xs:date(substring(time/@strt,1,10))" }
    }

    function getTexts(titleDeu, titleUnd, extraInfo, description) {
        var title = titleDeu || titleUnd || extraInfo || description;
        var subtitle = extraInfo;
        if (!subtitle.length || subtitle === title) {
            subtitle = description || "";
        }
        var descr = description || ((title !== extraInfo) ? extraInfo : "");
        return [title, subtitle, descr]
    }

    function getSectionHeader(dateStr) {
        var date = new Date(dateStr);
        var now = new Date();
        if (date.getMonth() === now.getMonth() && date.getDate() === now.getDate()) {
            return qsTr("TODAY");
        }
        now = new Date(now.getTime() + 86400000);
        if (date.getMonth() === now.getMonth() && date.getDate() === now.getDate()) {
            return qsTr("TOMORROW");
        }
        else {
            return date.toLocaleDateString();
        }
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
                text: qsTr('Vocabulary')
                onClicked: pageStack.push(Qt.resolvedUrl("Learn.qml"),
                                             { text: searchQuery });
            }
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

        model: watchmiBroadcastModel

        section {
            property: "dateFrom"
            delegate: BackgroundItem {
                width: itemListView.width - Theme.paddingMedium * 2
                height: 3 * Theme.paddingLarge
                Label {
                    text: getSectionHeader(section)
                    color: Theme.secondaryColor
                    width: parent.width
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.margins: Theme.paddingMedium
                    font.pixelSize: Theme.fontSizeMedium
                    font.bold: true
                }
            }
        }

        delegate: ListItem {

            property string deepLink: "http://m.tvdigital.de/tv-sendung/media/bulary/" + bid + "/" + pid
            property string title: getTexts(titleDeu, titleUnd, extraInfo, description)[0]
            property string subtitle: getTexts(titleDeu, titleUnd, extraInfo, description)[1]
            property string channelName: getChannel(chid).longName
            property variant channel: getChannel(chid)

            width: itemListView.width - Theme.paddingMedium * 2
            x: Theme.paddingMedium
            contentHeight: Theme.itemSizeExtraLarge

            onClicked: {
                pageStack.push(Qt.resolvedUrl("ShowDetails.qml"), {
                                   deepLink: deepLink,
                                   image: image,
                                   title: title,
                                   subtitle: subtitle,
                                   description: description,
                                   channelName: channelName,
                                   channelShortName: channel.shortName,
                                   timeFrom: getLocaleTime(timeFrom),
                                   duration: getDuration(duration)
                               });
            }

            Row {
                width: parent.width

                Item {
                    id: imageItem
                    width: 120
                    height: 90
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
                        text: title

                        width: parent.width
                        color: Theme.primaryColor
                        elide: Text.ElideRight
                        font.pixelSize: Theme.fontSizeSmall
                    }

                    Label {
                        text: "  »  " + channel.shortName
                              + "   " + getLocaleTime(timeFrom)
                              + "   " + getDuration(duration)

                        width: parent.width
                        color: Theme.secondaryColor
                        font.pixelSize: Theme.fontSizeExtraSmall
                    }

                    Label {
                        text: subtitle

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
