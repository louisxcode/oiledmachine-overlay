# Copyright 1999-2019 Gentoo Authors
# Copyright 2019 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: npm-secaudit.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 4 5
# @BLURB: Eclass for Electron packages
# @DESCRIPTION:
# The npm-secaudit eclass defines phase functions and utility for npm packages.
# It depends on the app-portage/npm-secaudit package to maintain a
# secure environment.
#
# It was intended to replace the insecure npm.eclass implementations and
# reduce packaging time.

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

inherit eutils

EXPORT_FUNCTIONS pkg_setup src_unpack pkg_postrm pkg_postinst

DEPEND+=" app-portage/npm-secaudit"
IUSE+=" debug"

NPM_PACKAGE_DB="/var/lib/portage/npm-packages"
NPM_SECAUDIT_REG_PATH=""
NPM_SECAUDIT_PRUNE=${NPM_SECAUDIT_PRUNE:="1"}
NPM_SECAUDIT_INSTALL_AUDIT=${NPM_SECAUDIT_INSTALL_AUDIT:="1"}
NPM_MAXSOCKETS=${NPM_MAXSOCKETS:="1"} # Set this in your make.conf to control number of HTTP requests.  50 is npm default but it is too high.

# @FUNCTION: _npm-secaudit_fix_locks
# @DESCRIPTION:
# Restores ownership change caused by yarn
_npm-secaudit_fix_locks() {
	local d="${NPM_STORE_DIR}"
	local f="_locks"
	local dt="${d}/${f}"
	if [ -d "${dt}" ] ; then
		local u=$(ls -l "${d}" | grep "${f}" | column -t | cut -f 5 -d ' ')
		local g=$(ls -l "${d}" | grep "${f}" | column -t | cut -f 7 -d ' ')
		if [[ "$u" == "root" && "$g" == "root" ]] ; then
			einfo "Restoring portage ownership on ${dt}"
			chown portage:portage -R "${dt}"
		fi
	fi
}

# @FUNCTION: _npm-secaudit_fix_logs
# @DESCRIPTION:
# Restores ownership change to logs
_npm-secaudit_fix_logs() {
	local d="${NPM_STORE_DIR}"
	local f="_logs"
	local dt="${d}/${f}"
	if [ -d "${dt}" ] ; then
		local u=$(ls -l "${d}" | grep "${f}" | column -t | cut -f 5 -d ' ')
		local g=$(ls -l "${d}" | grep "${f}" | column -t | cut -f 7 -d ' ')
		if [[ "$u" == "root" && "$g" == "root" ]] ; then
			einfo "Restoring portage ownership on ${dt}"
			chown portage:portage -R "${dt}"
		fi
	fi
}

# @FUNCTION: _npm-secaudit_yarn_access
# @DESCRIPTION:
# Restores ownership change caused by yarn
_npm-secaudit_yarn_access() {
	local d="${HOME}"
	local f=".config"
	local dt="${d}/${f}"
	if [ -d "${dt}" ] ; then
		local u=$(ls -l "${d}" | grep "${f}" | column -t | cut -f 5 -d ' ')
		local g=$(ls -l "${d}" | grep "${f}" | column -t | cut -f 7 -d ' ')
		if [[ "$u" == "root" && "$g" == "root" ]] ; then
			einfo "Restoring portage ownership on ${dt}"
			chown portage:portage -R "${dt}"
		fi
	fi
}

# @FUNCTION: _npm-secaudit_fix_cacache_access
# @DESCRIPTION:
# Restores ownership change on cacache
_npm-secaudit_fix_cacache_access() {
	local d="${NPM_STORE_DIR}"
	local f="_cacache"
	local dt="${d}/${f}"
	if [ -d "${dt}" ] ; then
		local u=$(ls -l "${d}" | grep "${f}" | column -t | cut -f 5 -d ' ')
		local g=$(ls -l "${d}" | grep "${f}" | column -t | cut -f 7 -d ' ')
		# too slow to reset
		einfo "Removing ${dt}"
		rm -rf "${dt}"
	fi
	einfo "Restoring portage ownership on ${dt}"
	addwrite "${d}"
	mkdir -p "${dt}"
	chown portage:portage -R "${dt}"
}

# @FUNCTION: npm_pkg_setup
# @DESCRIPTION:
# Initializes globals
npm-secaudit_pkg_setup() {
        debug-print-function ${FUNCNAME} "${@}"

	export NPM_STORE_DIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}/npm"
	export npm_config_cache="${NPM_STORE_DIR}"
	mkdir -p "${NPM_STORE_DIR}/offline"

	addwrite "${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"

	_npm-secaudit_fix_locks
	_npm-secaudit_fix_logs
	_npm-secaudit_fix_cacache_access
}

# @FUNCTION: npm-secaudit_fetch_deps
# @DESCRIPTION:
# Builds an electron app with security checks
# MUST be called after default unpack AND patching.
npm-secaudit_fetch_deps() {
	pushd "${S}"

	_npm-secaudit_fix_locks
	_npm-secaudit_yarn_access

	npm install --maxsockets=${NPM_MAXSOCKETS} || die
	_npm-secaudit_audit_fix
	popd
}

# @FUNCTION: npm_unpack
# @DESCRIPTION:
# Unpack sources
npm-secaudit_src_unpack() {
        debug-print-function ${FUNCNAME} "${@}"

	cd "${WORKDIR}"

	default_src_unpack

	cd "${S}"

	npm-secaudit_fetch_deps

	cd "${S}"

	# all the phase hooks get run in unpack because of download restrictions

	cd "${S}"
	if declare -f npm-secaudit_src_prepare > /dev/null ; then
		npm-secaudit_src_prepare
	else
		npm-secaudit_src_prepare_default
	fi

	cd "${S}"
	if declare -f npm-secaudit_src_compile > /dev/null ; then
		npm-secaudit_src_compile
	else
		npm-secaudit_src_compile_default
	fi

	cd "${S}"
	if declare -f npm-secaudit_src_preinst > /dev/null ; then
		npm-secaudit_src_preinst
	else
		npm-secaudit_src_preinst_default
	fi
}

# @FUNCTION: npm-secaudit_src_prepare_default
# @DESCRIPTION:
# Fetches dependencies.  Currently a stub.  TODO patching.
npm-secaudit_src_prepare_default() {
        debug-print-function ${FUNCNAME} "${@}"

	cd "${S}"

	#default_src_prepare
}

# @FUNCTION: npm-secaudit_src_install_default
# @DESCRIPTION:
# Installs the program.  Currently a stub.
npm-secaudit_src_install_default() {
        debug-print-function ${FUNCNAME} "${@}"

	cd "${S}"

	die "currently uninplemented.  must override"
# todo npm-secaudit_src_install_default
}

# @FUNCTION: npm-secaudit-build
# @DESCRIPTION:
# Builds an electron app
npm-secaudit-build() {
	# electron-builder can still pull packages at the build step.
	npm run build --maxsockets=${NPM_MAXSOCKETS} || die
}

# @FUNCTION: npm-secaudit_src_compile_default
# @DESCRIPTION:
# Builds an electron app
npm-secaudit_src_compile_default() {
        debug-print-function ${FUNCNAME} "${@}"

	cd "${S}"

	npm-secaudit-build
}

# @FUNCTION: npm-secaudit-register
# @DESCRIPTION:
# Adds the package to the electron database
# This function MUST be called in post_inst.
npm-secaudit-register() {
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

_npm-secuaudit_fix_recursive_lock_check() {
		einfo "Performing recursive package-lock.json audit"
		L=$(find . -name "package-lock.json")
		for l in $L; do
			pushd $(dirname $l)
			einfo "Running \`npm i --package-lock-only\`"
			npm i --package-lock-only || die
			einfo "Running \`npm audit fix --force\`"
			npm audit fix --force --maxsockets=${NPM_MAXSOCKETS} || die
			npm audit || die
			popd
		done
}

_npm-secaudit_audit_fix() {
	if [[ "${NPM_SECAUDIT_INSTALL_AUDIT}" == "1" ||
		"${NPM_SECAUDIT_INSTALL_AUDIT}" == "true" ||
		"${NPM_SECAUDIT_INSTALL_AUDIT}" == "TRUE" ]] ; then
		einfo "Running \`npm i --package-lock\`"
		npm i --package-lock

		einfo "Running \`npm audit fix --force\`"
		npm audit fix --force --maxsockets=${NPM_MAXSOCKETS} || die
		einfo "Running \`npm audit\`"
		npm audit || die

		_npm-secuaudit_fix_recursive_lock_check

		einfo "Auditing security done"
	fi
}

# @FUNCTION: npm-secaudit_src_preinst_default
# @DESCRIPTION:
# Preforms audits and fixes
# A user can define npm-secaudit_fix_prune to reinstall dependencies
# caused by breakage by pruning or auditing.
npm-secaudit_src_preinst_default() {
	local rel_src_path="$1"

	cd "${S}"

	_npm-secaudit_audit_fix

	cd "${S}"

	if ! use debug ; then
		if [[ "${NPM_SECAUDIT_PRUNE}" == "1" &&
			"${NPM_SECAUDIT_PRUNE}" == "true" &&
			"${NPM_SECAUDIT_PRUNE}" == "TRUE" ]] ; then
			einfo "Running \`npm prune --production\`"
			npm prune --production
		fi
	fi

	if declare -f npm-secaudit_fix_prune > /dev/null ; then
		npm-secaudit_fix_prune
	fi
}

# @FUNCTION: npm-secaudit_install
# @DESCRIPTION:
# Installs an app to image area before going live.
npm-secaudit_install() {
	local rel_src_path="$1"

	local old_dotglob=$(shopt dotglob | cut -f 2)
	shopt -s dotglob # copy hidden files

	mkdir -p "${D}/usr/$(get_libdir)/node/${PN}/${SLOT}"
	cp -a ${rel_src_path} "${D}/usr/$(get_libdir)/node/${PN}/${SLOT}"

	if [[ "${old_dotglob}" == "on" ]] ; then
		shopt -s dotglob
	else
		shopt -u dotglob
	fi
}

# @FUNCTION: npm-secaudit_pkg_postinst
# @DESCRIPTION:
# Automatically registers an npm package.
# Set NPM_SECAUDIT_REG_PATH global to relative path to
# scan for vulnerabilities containing node_modules.
# scan for vulnerabilities.
npm-secaudit_pkg_postinst() {
        debug-print-function ${FUNCNAME} "${@}"
	npm-secaudit-register "${NPM_SECAUDIT_REG_PATH}"
}

# @FUNCTION: npm-secaudit_pkg_postrm
# @DESCRIPTION:
# Post-removal hook for Electron apps. Removes information required for security checks.
npm-secaudit_pkg_postrm() {
        debug-print-function ${FUNCNAME} "${@}"

	sed -i -e "s|${CATEGORY}/${PN}:${SLOT}\t.*||g" "${NPM_PACKAGE_DB}"
	sed -i '/^$/d' "${NPM_PACKAGE_DB}"
}
