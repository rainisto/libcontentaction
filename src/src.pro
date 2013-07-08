TEMPLATE = lib
equals(QT_MAJOR_VERSION, 4): TARGET = contentaction
equals(QT_MAJOR_VERSION, 5): TARGET = contentaction5

include(../common.pri)

# yes, 0.0.75. libcontentaction currently has a SONAME of 0, even though the
# version numbering is 0.1. god only knows why. fix this in the future, some
# day?
VERSION = 0.0.75

QT = core xml dbus
CONFIG += link_pkgconfig hide_symbols
PKGCONFIG += gio-2.0 gio-unix-2.0

equals(QT_MAJOR_VERSION, 4) {
    PKGCONFIG += mlite
    CONFIG += mobility
    MOBILITY += systeminfo
} else {
    PKGCONFIG += mlite5 Qt5SystemInfo
}

target.path = $$[QT_INSTALL_LIBS]
INSTALLS += target

DEFINES += DEFAULT_ACTIONS=\\\"\"$$CONTENTACTION_DATADIR\"\\\"
DEFINES += LCA_BUILD
DEFINES += QT_NO_KEYWORDS # make glib happy

HEADERS += \
    internal.h \
    contentaction.h \
    service.h \
    contentinfo.h

SOURCES += \
    contentaction.cpp \
    service.cpp \
    dbus.cpp \
    exec.cpp \
    mime.cpp \
    tracker.cpp \
    highlighter.cpp \
    highlight.cpp \
    config.cpp \
    contentinfo.cpp

include.path = $$CONTENTACTION_INCLUDEDIR
include.files = contentaction.h \
                contentinfo.h
INSTALLS += include

equals(QT_MAJOR_VERSION, 4): PCFILE=contentaction-0.1.pc
equals(QT_MAJOR_VERSION, 5): PCFILE=contentaction5.pc

# handle .pc file
system(cp $${PCFILE}.in $$PCFILE)
system(sed -i "s/\\@VERSION\\@/$$VERSION/g" $$PCFILE)

pcfiles.files = $$PCFILE
pcfiles.path = $$[QT_INSTALL_LIBS]/pkgconfig
INSTALLS += pcfiles
