FILESEXTRAPATHS_prepend := "${THISDIR}:"

KERNEL_PROT = "file"
KERNEL_REPO = "git://github.com/tes-gfx/linux-socfpga.git"
KERNEL_REPO_tesintern = "git:///home/christian/yocto/linux-socfpga"

SRCREV = "78cbce0ccbde7be002b398037659538a4fd0a3e3"

#KBUILD_DEFCONFIG_stratix10 = "s10_devkit_defconfig"

DTB_OUTPUT ?= "arch/${ARCH}/boot/dts"
DTB_OUTPUT_stratix10 ?= "arch/${ARCH}/boot/dts/altera"

#
# Add base device tree and overlay for our design (enable FPGA2SDRAM bridge)
#
SRC_URI_append_cyclone5 = " \
	file://${PN}/4.14/dts/socfpga_cyclone5_de0_sockit_tes.dts \
	file://${PN}/4.14/dts/socfpga_cyclone5_de0_sockit_tes_lcd.dts \
"

SRC_URI_append_arria10 = " file://${PN}/4.14/dts/socfpga_arria10_socdk_tes.dts"
SRC_URI_append_arria10 = " file://${PN}/4.14/dts/dreamchip_arria10som.dtsi"
SRC_URI_append_arria10 = " file://${PN}/4.14/dts/dreamchip_arria10som_tes.dts"

SRC_URI_append_stratix10 = " file://${PN}/4.14/dts/socfpga_stratix10_socdk_tes.dts"

#
# Add kernel configuration (e.g. DRM/KMS support, I2C encoder slaves, CMA, ...)
#
SRC_URI_append = " file://${PN}/4.14/config/tes_dnx_cdc.cfg"

#
# Add DNX register headers and DRM UAPI definitions for kernel side
#
FILESEXTRAPATHS_prepend := "${TES_SRC}:${TES_SRC}/driver/kernel/linux:"
ADDSOURCES = ""
ADDSOURCES_tesdavenx = " \
	file://interface \
	file://drm-dnx/dnx_drm.h \
"

SRCREV_interface = "${AUTOREV}"
#SRCREV_FORMAT = "default_dnx-rinterface"
ADDSOURCES_tesdavenx_tesintern = "\
	${TES_SVN_PATH};module=interface;name=interface;protocol=https;user=${TES_SVN_USER};pswd=${TES_SVN_PASSWORD}; \
	${TES_SVN_PATH}/driver/kernel/linux;module=drm-dnx;name=interface;protocol=https;user=${TES_SVN_USER};pswd=${TES_SVN_PASSWORD}; \
"

SRC_URI_append = " ${ADDSOURCES}"

#
# Copy base device tree into kernel source
#
python do_copy() {
    if "tesdavenx" in d.getVar("OVERRIDES"):
        bb.note("copying DaveNX specific files")
        bb.build.exec_func("do_copy_dnx", d)

    if "cyclone5" in d.getVar("OVERRIDES"):
        bb.note("copying Cyclone5 specific files")
        bb.build.exec_func("do_copy_c5", d)

    if "arria10" in d.getVar("OVERRIDES"):
        bb.note("copying Arria10 specific files")
        bb.build.exec_func("do_copy_a10", d)

    if "stratix10" in d.getVar("OVERRIDES"):
        bb.note("copying Stratix10 specific files")
        bb.build.exec_func("do_copy_s10", d)
}
addtask copy after do_configure before do_compile

do_copy_dnx() {
	cp ${WORKDIR}/${PN}/4.14/dts/*.dts ${STAGING_KERNEL_DIR}/arch/${ARCH}/boot/dts/
	cp ${WORKDIR}/drm-dnx/dnx_drm.h ${STAGING_KERNEL_DIR}/include/uapi/drm/
	cp ${WORKDIR}/interface/src/*.h ${STAGING_KERNEL_DIR}/include/
}

do_copy_c5() {
	cp ${WORKDIR}/${PN}/4.14/dts/*.dts ${STAGING_KERNEL_DIR}/arch/${ARCH}/boot/dts/
}

do_copy_a10() {
	cp ${WORKDIR}/${PN}/4.14/dts/*.dtsi ${STAGING_KERNEL_DIR}/arch/${ARCH}/boot/dts/
}

do_copy_s10() {
	cp ${WORKDIR}/${PN}/4.14/dts/*.dts ${STAGING_KERNEL_DIR}/arch/${ARCH}/boot/dts/altera/
}

#
# Copy required header files into kernel staging directory (required for building module)
#
do_install_append_davenx() {
	install -m 0644 ${WORKDIR}/interface/src/*.h ${STAGING_KERNEL_DIR}/include/
	install -m 0644 ${WORKDIR}/drm-dnx/dnx_drm.h ${STAGING_KERNEL_DIR}/include/uapi/drm/
}
