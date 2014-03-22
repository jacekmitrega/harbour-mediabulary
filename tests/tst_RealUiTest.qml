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
 * Tests that operate on the UI level. They expect window to be shown. All the mouseClick-like test utilities can be used then
 */
import QtQuick 2.0
import QtTest 1.0
import Sailfish.Silica 1.0

//import "../src/qml/pages"
import "../harbour-mediabulary/qml/pages"


// Putting TestCase into the full app structure to test UI interactions and probably page transitions too
ApplicationWindow {
    id: wholeApp
    initialPage: Mediabulary {
        id: mediabulary
    }

    TestCase {
        name: "test on the very UI level"

        // You want see anything yet at this moment, but UI is actually constructed already and e.g. mouseClick will work
        // Painting happens later, you can set up timer to wait for it (painting happens some 50-100ms after ApplicationWindow's
        // applicationActive becomes true), then you might be able to
        // see graphics update when test is clicking through buttons, though you might need to yield control from time to time then
        when: windowShown

        function test_nothing() {
        }
    }

}
