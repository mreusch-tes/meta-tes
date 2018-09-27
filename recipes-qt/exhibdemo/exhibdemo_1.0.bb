inherit qmake5

SUMMARY = "TES ExhibDemo"
DESCRIPTION = "The TES exhibition demo that can be used as an initial application for your own Qt evaluation and development."
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=17726452d08c75d63fde4c6045f2d0d1"

PV_tesintern = "1.0+svnr${SRCPV}"

FILESEXTRAPATHS_prepend := "${TES_SRC}:"
SRC_URI = "\
	file://ExhibDemo \
"

SRCREV = "${AUTOREV}"
SRC_URI_tesintern = "\
        ${TES_SVN_PATH}/demos/qt;module=ExhibDemo;protocol=https;user=${TES_SVN_USER};pswd=${TES_SVN_PASSWORD}; \
        "

S = "${WORKDIR}/ExhibDemo"
srcdir = "${prefix}/src"

DEPENDS = "qtdeclarative"
RDEPENDS_${PN} = "qtdeclarative-qmlplugins"

# require recipes-qt/qt5/qt5.inc

do_install() {
    install -d ${D}${datadir}/${PN}
    install -m 0755 ${B}/ExhibDemo ${D}${datadir}/${PN}
    install -d ${D}${datadir}/${PN}/textures
    install -m 0644 ${S}/textures/*.* ${D}${datadir}/${PN}/textures

    install -d ${D}${srcdir}/${PN}
    install -d ${D}${srcdir}/${PN}/textures
    install -d ${D}${srcdir}/${PN}/images
    install -m 0644 ${S}/textures/*.* ${D}${srcdir}/${PN}/textures
    install -m 0644 ${S}/images/*.* ${D}${srcdir}/${PN}/images
    install -m 0644 ${S}/*.cpp ${D}${srcdir}/${PN}/
    install -m 0644 ${S}/*.h ${D}${srcdir}/${PN}/
    install -m 0644 ${S}/*.pro ${D}${srcdir}/${PN}/
    install -m 0644 ${S}/*.qml ${D}${srcdir}/${PN}/
    install -m 0644 ${S}/*.qrc ${D}${srcdir}/${PN}/
}

#
# Add a src package for the project, enabling the user to modify and build
# the project as a start for evaluation.
# Sources, resources and project file have to be added to the package.
#
PACKAGES += "${PN}-src"
FILES_${PN}-src += "\
	${srcdir}/${PN} \
"
RDEPENDS_${PN}-src += "${PN}"

FILES_${PN}-dbg += "${datadir}/${PN}/.debug"
FILES_${PN} += "${datadir}"
