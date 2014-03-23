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


Page {
    id: showDetails

    property string deepLink
    property string title
    property string description
    property string image
    property string channelName
    property string channelShortName
    property string timeFrom
    property string duration


    Component.onCompleted: initTimer.start()

    Timer {
        id: initTimer
        interval: 100
        onTriggered: {
            pageStack.pushAttached(Qt.resolvedUrl("WebViewPage.qml"),
                                   {
                                       title: showDetails.title,
                                       url: showDetails.deepLink
                                   });
        }
    }


    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width;
        contentHeight: mainColumn.height

        ScrollDecorator { }

        PullDownMenu {
            MenuItem {
                text: qsTr('Open in the browser')
                onClicked: {
                    console.log("Open external link: " + deepLink);
                    Qt.openUrlExternally(deepLink);
                }
            }
        }

        Column {
            id: mainColumn
            width: showDetails.width - Theme.paddingMedium * 2
            x: Theme.paddingMedium
            spacing: Theme.paddingLarge

            Column {
                width: parent.width
                spacing: Theme.paddingMedium

                PageHeader {
                    title: showDetails.channelShortName
                }

                Label {
                    width: parent.width
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeLarge
                    elide: Text.ElideRight
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    maximumLineCount: 1
                    text: title
                }
            }

            Separator {
                width: parent.width
                height: Theme.paddingSmall
                color: Theme.primaryColor
            }

            Item {
                id: infoItem
                width: parent.width
                height: 120

                Item {
                    id: imageItem
                    width: 120
                    height: 90
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left

                    Image {
                        source: image
                        width: 110
                        height: 70
                        anchors.left: parent.left
                        anchors.top: parent.top
                    }
                }

                Label {
                    id: channelNameLabel
                    text: showDetails.channelName
                    elide: Text.ElideRight
                    maximumLineCount: 1

                    anchors.top: parent.top
                    anchors.left: imageItem.right
                    anchors.right: parent.right
                    anchors.margins: Theme.paddingSmall
                }

                Label {
                    text: showDetails.timeFrom + "   " + showDetails.duration

                    anchors.top: channelNameLabel.bottom
                    anchors.left: imageItem.right
                    anchors.right: parent.right
                    anchors.margins: Theme.paddingSmall
                }
            }


            Label {
                width: parent.width
                color: Theme.primaryColor
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: description
            }
        }
    }
}
