################################################################################
# Makefile
################################################################################

#===========================================================
# Check
#===========================================================
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
all: ${OUT_PATH}/program.elf

${TMP_PATH}:
	mkdir ${TMP_PATH}

${OUT_PATH}:
	mkdir ${OUT_PATH}

${OUT_PATH}/program.elf: ${TMP_PATH}/build/images/sel4test-driver-image-arm-maaxboard | ${OUT_PATH}
	cp $< $@

${TMP_PATH}/build/images/sel4test-driver-image-arm-maaxboard: | ${TMP_PATH}
        # Python.
	python -m venv ${TMP_PATH}/pyenv
	. ${TMP_PATH}/pyenv/bin/activate ; pip install sel4-deps
	. ${TMP_PATH}/pyenv/bin/activate ; pip install camkes-deps
	. ${TMP_PATH}/pyenv/bin/activate ; pip install "protobuf<=3.20.*"
        # Acquire.
	cd ${TMP_PATH} ; repo init --manifest-url "git@github.com:seL4/sel4test-manifest.git"
	cd ${TMP_PATH} ; repo sync
        # Build.
	mkdir ${TMP_PATH}/build
	. ${TMP_PATH}/pyenv/bin/activate ; cd ${TMP_PATH}/build ; ../init-build.sh -DPLATFORM=maaxboard -DAARCH64=TRUE
	. ${TMP_PATH}/pyenv/bin/activate ; cd ${TMP_PATH}/build ; ninja

.PHONY: clean
clean:
	rm -rf ${TMP_PATH}
	rm -rf ${OUT_PATH}

################################################################################
# End of file
################################################################################
