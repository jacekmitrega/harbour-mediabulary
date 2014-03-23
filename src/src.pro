TEMPLATE=app
# The name of your app binary (and it's better if you think it is the whole app name as it's referred to many times)
# Must start with "harbour-"
TARGET = harbour-mediabulary

# In the bright future this config line will do a lot of stuff to you
CONFIG += sailfishapp

SOURCES += main.cpp

OTHER_FILES = \
# You DO NOT want .yaml be listed here as Qt Creator's editor is completely not ready for multi package .yaml's
#
# Also Qt Creator as of Nov 2013 will anyway try to rewrite your .yaml whenever you change your .pro
# Well, you will just have to restore .yaml from version control again and again unless you figure out
# how to kill this particular Creator's plugin
#    ../rpm/harbour-mediabulary.yaml \
    ../rpm/harbour-mediabulary.spec \
    qml/main.qml \
    qml/pages/Mediabulary.qml \
    qml/cover/CoverPage.qml \
    qml/pages/SearchDialog.qml \
    qml/pages/ShowDetails.qml \
    qml/pages/WebViewPage.qml

INCLUDEPATH += $$PWD
