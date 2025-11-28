
TERMUX_APP_PACKAGE=${TERMUX_APP_PACKAGE:-com.termux.nix}
TERMUX_BASE_DIR="/data/data/${TERMUX_APP_PACKAGE}/files"
TERMUX_CACHE_DIR="/data/data/${TERMUX_APP_PACKAGE}/cache"
TERMUX_ANDROID_HOME="${TERMUX_BASE_DIR}/home"
TERMUX_PREFIX_CLASSICAL="${TERMUX_BASE_DIR}/usr"
TERMUX_PREFIX="${TERMUX_PREFIX_CLASSICAL}"

termux_step_patch_package() {
	for patch in $termuxPatches; do
		echo "Applying patch: $(basename $patch)"
		test -f "$patch" && sed \
			-e "s%\@TERMUX_APP_PACKAGE\@%${TERMUX_APP_PACKAGE}%g" \
			-e "s%\@TERMUX_BASE_DIR\@%${TERMUX_BASE_DIR}%g" \
			-e "s%\@TERMUX_CACHE_DIR\@%${TERMUX_CACHE_DIR}%g" \
			-e "s%\@TERMUX_HOME\@%${TERMUX_ANDROID_HOME}%g" \
			-e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" \
			-e "s%\@TERMUX_PREFIX_CLASSICAL\@%${TERMUX_PREFIX_CLASSICAL}%g" \
			"$patch" | patch --silent -p1
	done
}

preConfigurePhases+=(termux_step_patch_package)

appendToVar NIX_CFLAGS_COMPILE "-D__ANDROID__"
appendToVar NIX_CFLAGS_COMPILE "-D__TERMUX__" # should probably be part of termux-auth?
appendToVar NIX_CFLAGS_COMPILE "-DTERMUX_APP_PACKAGE=\"${TERMUX_APP_PACKAGE}\""
appendToVar NIX_CFLAGS_COMPILE "-DTERMUX_BASE_DIR=\"${TERMUX_BASE_DIR}\""
appendToVar NIX_CFLAGS_COMPILE "-DTERMUX_CACHE_DIR=\"${TERMUX_CACHE_DIR}\""
appendToVar NIX_CFLAGS_COMPILE "-DTERMUX_HOME=\"${TERMUX_ANDROID_HOME}\""
appendToVar NIX_CFLAGS_COMPILE "-DTERMUX_PREFIX=\"${TERMUX_PREFIX}\""
appendToVar NIX_CFLAGS_COMPILE "-DTERMUX_PREFIX_CLASSICAL=\"${TERMUX_PREFIX_CLASSICAL}\""
