################################################################################
# Makefile
################################################################################

#===========================================================
# Check
#===========================================================
ENV_DEP := "hello 1"

ABT_PATH_FILE := /about.txt
ABT_PATH_FILE := ./about.txt

ifneq ($(wildcard ${ABT_PATH_FILE}),)
ABOUT := $(file < ${ABT_PATH_FILE})
LABEL := $(word 1,${ABOUT})
MAJOR := $(word 2,${ABOUT})
MINOR := $(word 3,${ABOUT})
endif
ifneq ("${LABEL} ${VER_MAJOR}", "hello 1")
$(error Not Found Compatiable Environment: ${ABT_PATH_FILE})
endif

#===========================================================
# Layout
#===========================================================

TMP_PATH := tmp
OUT_PATH := out

#===========================================================
# Usage
#===========================================================

.PHONY: usage
usage: 
	@echo "usage: make <target>"
	@echo ""
	@echo "<target> is one off:"
	@echo "all"
	@echo "clean"

#===========================================================
# Target
#===========================================================

.PHONY: all
all: ${OUT_PATH}/libvmm

${OUT_PATH}:
	mkdir ${OUT_PATH}

${OUT_PATH}/program.elf: ${OUT_PATH}/out/imx-mkimage/iMX8M/flash.bin | ${OUT_PATH}
	cp $< $@




repo init -u https://github.com/seL4/sel4test-manifest.git

repo sync




        # Acquire.
        #
        git -C ${OUT_PATH} clone --branch "develop_imx_4.14.78_1.0.0_ga" "git@github.com:Avnet/imx-mkimage.git"
        git -C ${OUT_PATH}/imx-mkimage reset --hard "9a299d31a2045db3eafb7ee61ec3c7ee87225d53"
        # Patch for relative target.
        sed -i -e 's/MKIMG = .*mkimage_imx8/MKIMG = mkimage_imx8/g' ${OUT_PATH}/imx-mkimage/Makefile
        # Populate.
        cp ${DEP_FIR_TARGET_PATH_FILES} ${DEP_UBO_TARGET_PATH_FILES} ${DEP_ATF_TARGET_PATH_FILES} ${OUT_PATH}/imx-mkimage/iMX8M
        mv ${OUT_PATH}/imx-mkimage/iMX8M/ddr4_dmem_1d_202006.bin ${OUT_PATH}/imx-mkimage/iMX8M/ddr4_dmem_1d.bin
        mv ${OUT_PATH}/imx-mkimage/iMX8M/ddr4_dmem_2d_202006.bin ${OUT_PATH}/imx-mkimage/iMX8M/ddr4_dmem_2d.bin
        mv ${OUT_PATH}/imx-mkimage/iMX8M/ddr4_imem_1d_202006.bin ${OUT_PATH}/imx-mkimage/iMX8M/ddr4_imem_1d.bin
        mv ${OUT_PATH}/imx-mkimage/iMX8M/ddr4_imem_2d_202006.bin ${OUT_PATH}/imx-mkimage/iMX8M/ddr4_imem_2d.bin
        mv ${OUT_PATH}/imx-mkimage/iMX8M/maaxboard.dtb ${OUT_PATH}/imx-mkimage/iMX8M/fsl-imx8mq-ddr4-arm2.dtb
        mv ${OUT_PATH}/imx-mkimage/iMX8M/mkimage ${OUT_PATH}/imx-mkimage/iMX8M/mkimage_uboot
        # Build for MaaXBoard.




repo init -u https://github.com/seL4/sel4test-manifest.git


#
#
#
#
#
#${OUT_PATH}/libvmm: | ${OUT_PATH}
#        cd ${OUT_PATH} ; git clone "git@github.com:au-ts/libvmm.git" libvmm
#        cd ${OUT_PATH} ; git -C libvmm reset --hard "dcfa24a2e5dbee7e90ab5a0e3a1432813d0e2a5a"
#        cd ${OUT_PATH} ; git -C libvmm submodule update --init
#        cp ${SRC_PATH}/imx_sip.h ${OUT_PATH}/libvmm/src/arch/aarch64/imx_sip.h
#        cp ${SRC_PATH}/imx_sip.c ${OUT_PATH}/libvmm/src/arch/aarch64/imx_sip.c
#        sed -i ${OUT_PATH}/libvmm/src/arch/aarch64/smc.c -e '/#include "psci.h"/i#include "imx_sip.h"'
#        sed -i ${OUT_PATH}/libvmm/src/arch/aarch64/smc.c -e '/case SMC_CALL_STD_SERVICE:/icase SMC_CALL_SIP_SERVICE: return handle_imx_sip(vcpu_id, \&regs, fn_number, hsr); break;'
#
#.PHONY: clean
#clean:
#        rm -rf ${TMP_PATH}
#
#.PHONY: reset
#reset: clean
#        rm -rf ${OUT_PATH}
#
#
#















################################################################################
# End of file
################################################################################



