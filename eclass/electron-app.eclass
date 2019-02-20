# Copyright 1999-2019 Gentoo Foundation
# Copyright 2019 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: electron-app.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 4 5
# @BLURB: Eclass for Electron packages
# @DESCRIPTION:
# The electron-app eclass defines phase functions and utility functions for
# Electron app packages. It depends on the app-portage/npm-secaudit package to
# maintain a secure environment.

case "${EAPI:-0}" in
        0|1|2|3)
                die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
                ;;
        4|5|6)
                ;;
        *)
                die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
                ;;
esac

inherit desktop eutils

EXPORT_FUNCTIONS pkg_setup src_unpack src_compile pkg_postrm

DEPEND+=" app-portage/npm-secaudit"
IUSE+=" debug"

NPM_PACKAGE_DB="/var/lib/portage/npm-packages"

ELECTRON_APP_MODE="npm" # can be npm, yarn (not implemented yet)

# @FUNCTION: electron-app_pkg_setup
# @DESCRIPTION:
# Initializes globals
electron-app_pkg_setup() {
        debug-print-function ${FUNCNAME} "${@}"

	case "$ELECTRON_APP_MODE" in
		npm)
			export ELECTRON_VER=$(electron --version | sed -e "s|v||g")
			export ELECTRON_STORE_DIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}/npm"
			export npm_config_cache="${ELECTRON_STORE_DIR}"
			;;
		*)
			die "Unsupported package system"
			;;
	esac
}

# @FUNCTION: electron-app-fetch-deps-npm
# @DESCRIPTION:
# Fetches an Electron npm app with security checks
# MUST be called after default unpack AND patching.
electron-app-fetch-deps-npm()
{
	local install_args="--production"

	if use debug ; then
		install_args=""
	fi

	pushd "${S}"
	npm install ${install_args} || die
	if [[ ! -e package-lock.js ]] ; then
		einfo "Running \`npm i --package-lock\`"
		npm i --package-lock # prereq for command below
	fi
	einfo "Running \`npm audit fix --force\`"
	npm audit fix --force || die
	einfo "Auditing security done"
	if ! use debug ; then
		npm prune --production
	fi
	popd
}

# @FUNCTION: electron-app-fetch-deps
# @DESCRIPTION:
# Fetches an electron app with security checks
# MUST be called after default unpack AND patching.
electron-app-fetch-deps() {
	# todo handle yarn
	case "$ELECTRON_APP_MODE" in
		npm)
			electron-app-fetch-deps-npm
			;;
		*)
			die "Unsupported package system"
			;;
	esac
}

# @FUNCTION: electron-app_src_unpack
# @DESCRIPTION:
# Initializes cache folder and gets the archive
# without dependencies.  You MUST call
# npm-secaudit-fetch-deps manually.
electron-app_src_unpack() {
        debug-print-function ${FUNCNAME} "${@}"

	addwrite "${ELECTRON_STORE_DIR}"
	mkdir -p "${ELECTRON_STORE_DIR}"

	default_src_unpack
}

# @FUNCTION: electron-app-build-npm
# @DESCRIPTION:
# Builds an electron app with npm
electron-app-build-npm() {
	npm run build || die
}

# @FUNCTION: electron-app_src_compile
# @DESCRIPTION:
# Builds an electron app
electron-app_src_compile() {
        debug-print-function ${FUNCNAME} "${@}"

	case "$ELECTRON_APP_MODE" in
		npm)
			electron-app-build-npm
			;;
		*)
			die "Unsupported package system"
			;;
	esac
}

# @FUNCTION: electron-app-register
# @DESCRIPTION:
# Adds the package to the electron database
# This function MUST be called in pkg_postinst.
electron-app-register() {
	local rel_path=${1:-""}
	local check_path="/usr/$(get_libdir)/node/${PN}/${SLOT}/${rel_path}"
	# format:
	# ${CATEGORY}/${P}	path_to_package
	addwrite "${NPM_PACKAGE_DB}"

	# remove existing entry
	touch "${NPM_PACKAGE_DB}"
	sed -i -e "s|${CATEGORY}/${PN}:${SLOT}\t.*||g" "${NPM_PACKAGE_DB}"

	echo -e "${CATEGORY}/${PN}:${SLOT}\t${check_path}" >> "${NPM_PACKAGE_DB}"

	# remove blank lines
	sed -i '/^$/d' "${NPM_PACKAGE_DB}"
}

# @FUNCTION: electron-desktop-app-install
# @DESCRIPTION:
# Installs a desktop app.
electron-desktop-app-install() {
	local rel_src_path="$1"
	local rel_main_app_path="$2"
	local rel_icon_path="$3"
	local pkg_name="$4"
	local category="$5"

	shopt -s dotglob # copy hidden files

	mkdir -p "${D}/usr/$(get_libdir)/node/${PN}/${SLOT}"
	cp -a ${rel_src_path} "${D}/usr/$(get_libdir)/node/${PN}/${SLOT}"

	#create wrapper
	mkdir -p "${D}/usr/bin"
	echo "#!/bin/bash" > "${D}/usr/bin/${PN}"
	echo "/usr/bin/electron /usr/$(get_libdir)/node/${PN}/${SLOT}/${rel_main_app_path}" >> "${D}/usr/bin/${PN}"
	chmod +x "${D}"/usr/bin/${PN}

	newicon "${rel_icon_path}" "${PN}.png"
	make_desktop_entry ${PN} "${pkg_name}" ${PN} "${category}"
}

# @FUNCTION: electron-app_pkg_postrm
# @DESCRIPTION:
# Post-removal hook for Electron apps. Removes information required for security checks.
electron-app_pkg_postrm() {
        debug-print-function ${FUNCNAME} "${@}"

	case "$ELECTRON_APP_MODE" in
		npm)
			sed -i -e "s|${CATEGORY}/${PN}:${SLOT}\t.*||g" "${NPM_PACKAGE_DB}"
			;;
		*)
			die "Unsupported package system"
			;;
	esac
}
