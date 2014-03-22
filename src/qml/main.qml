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
import "pages"


ApplicationWindow
{
    initialPage: mediabularyMainComponent
    Component {
        id: mediabularyMainComponent
        Mediabulary { }
    }

    cover: Qt.resolvedUrl("cover/CoverPage.qml")
}
