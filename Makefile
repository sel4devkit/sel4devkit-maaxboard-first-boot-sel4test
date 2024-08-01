################################################################################
# Makefile
################################################################################

#===========================================================
# Check
#===========================================================
ifndef FORCE
    EXP_INFO := sel4devkit-maaxboard-camkes-docker-dev-env 1 *
    CHK_PATH_FILE := /check.mk
    ifeq ($(wildcard ${CHK_PATH_FILE}),)
        HALT := TRUE
    else
        include ${CHK_PATH_FILE}
    endif
    ifdef HALT
        $(error Expected Environment Not Found: ${EXP_INFO})
    endif
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
	@echo "usage: make <target> [FORCE=TRUE]"
	@echo ""
	@echo "<target> is one off:"
	@echo "get"
	@echo "all"
	@echo "clean"

#===========================================================
# Target
#===========================================================
.PHONY: get
get: | ${TMP_PATH}
	mkdir ${TMP_PATH}/sel4test-manifest
	cd ${TMP_PATH}/sel4test-manifest ; repo init --manifest-url "git@github.com:seL4/sel4test-manifest.git"
	cd ${TMP_PATH}/sel4test-manifest ; repo sync

.PHONY: all
all: ${OUT_PATH}/program.elf

${TMP_PATH}:
	mkdir ${TMP_PATH}

${OUT_PATH}:
	mkdir ${OUT_PATH}

${OUT_PATH}/program.elf: ${TMP_PATH}/build/images/sel4test-driver-image-arm-maaxboard | ${OUT_PATH}
	cp $< $@

${TMP_PATH}/build/images/sel4test-driver-image-arm-maaxboard: ${TMP_PATH}/sel4test-manifest/init-build.sh | ${TMP_PATH}
	python -m venv ${TMP_PATH}/pyenv
	. ${TMP_PATH}/pyenv/bin/activate ; pip install sel4-deps
	. ${TMP_PATH}/pyenv/bin/activate ; pip install camkes-deps
	. ${TMP_PATH}/pyenv/bin/activate ; pip install "protobuf<=3.20.*"
	mkdir ${TMP_PATH}/build
	. ${TMP_PATH}/pyenv/bin/activate ; cd ${TMP_PATH}/build ; ../sel4test-manifest/init-build.sh -DPLATFORM=maaxboard -DAARCH64=TRUE
	. ${TMP_PATH}/pyenv/bin/activate ; cd ${TMP_PATH}/build ; ninja

.PHONY: clean
clean:
	rm -rf ${TMP_PATH}
	rm -rf ${OUT_PATH}

################################################################################
# End of file
################################################################################
