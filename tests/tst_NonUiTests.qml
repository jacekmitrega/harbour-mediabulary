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

/**
 * Tests that operate with instantiated QML components, yet don't really need Application Window to be created
 * That will produce a lot of warnings, UI utilities such as mouseClick won't work, but the test code becomes simpler
 * and runs faster
 * And if you do want to operate on the muse level, you can get almost there via e.g. triggering clicked(null) signal handler
 *
 */

import QtQuick 2.0
import QtTest 1.0

// At runtime proper folder to import is "../harbour-mediabulary/qml/pages"
// You can check the main app deployment folder from it's DEPLOYMENT_PATH qmake var in .pro
// Faster to check from .spec file, however

// At design-time I uncomment import "../src/qml/pages" so that QtCreator auto-completion would work

//import "../src/qml/pages"
import "../harbour-mediabulary/qml/pages"


TestCase {
    name: "MediabularyTest"

    Mediabulary {
        id: mediabulary
    }

    function test_getTexts() {
        compare(mediabulary.getTexts("A", "B", "C", "D"),
                ["A", "C", "D"],
                "Deu title for title, extra info for subtitle and description for description should be selected");
        compare(mediabulary.getTexts("A", "", "C", ""),
                ["A", "C", "C"],
                "Deu title for title and description for subtitle and description should be selected");
        compare(mediabulary.getTexts("", "B", "", "D"),
                ["B", "D", "D"],
                "Und title for title and description for subtitle and description should be selected");
        compare(mediabulary.getTexts("A", "B", "", ""),
                ["A", "", ""],
                "Deu title only for title should be selected");
        compare(mediabulary.getTexts("", "", "C", "D"),
                ["C", "D", "D"],
                "Extra info for title and description for subtitle and description should be selected");
        compare(mediabulary.getTexts("", "B", "", ""),
                ["B", "", ""],
                "Und title only for title should be selected");
        compare(mediabulary.getTexts("", "", "C", ""),
                ["C", "", ""],
                "Extra info title only for subtitle should be selected");
        compare(mediabulary.getTexts("", "", "", "D"),
                ["D", "D", "D"],
                "Description for title, subtitle and description should be selected");
    }

    function test_getSectionHeader() {
        var beforeToday = new Date(new Date().getTime() - 86400000);
        compare(mediabulary.getSectionHeader(beforeToday.toUTCString()),
                beforeToday.toLocaleDateString(),
                "Date should be Locale Date String");
        var date = new Date();
        compare(mediabulary.getSectionHeader(date.toUTCString()),
                qsTr("TODAY"),
                "Date should be TODAY");
        var tomorrow = new Date(new Date().getTime() + 86400000);
        compare(mediabulary.getSectionHeader(tomorrow.toUTCString()),
                qsTr("TOMORROW"),
                "Date should be TOMORROW");
        var afterTomorrow = new Date(new Date().getTime() + 2 * 86400000);
        compare(mediabulary.getSectionHeader(afterTomorrow.toUTCString()),
                afterTomorrow.toLocaleDateString(),
                "Date should be Locale Date String");
    }

    function test_getLocaleDate() {
        var date = new Date();
        compare(typeof mediabulary.getLocaleDate(date), "string",
                "should return a string");
    }

    function test_getLocaleTime() {
        var date = new Date();
        var localeTime = mediabulary.getLocaleTime(date);
        compare(typeof localeTime, "string", "should return a string");
        compare(date.toLocaleTimeString().indexOf(localeTime), 0,
                "should return a substring of Date().toLocaleTimeString()");
    }

    function test_getDuration() {
        compare(mediabulary.getDuration(3600), "60 " + qsTr("minutes"),
                '3600 seconds should be "60 minutes"');
    }

}
