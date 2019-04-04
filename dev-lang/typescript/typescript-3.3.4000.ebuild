# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}
	 app-eselect/eselect-typescript"

DEPEND="${RDEPEND}
	media-libs/vips
        net-libs/nodejs[npm]"

inherit eutils npm-secaudit versionator

MY_PN="TypeScript"

DESCRIPTION="TypeScript is a superset of JavaScript that compiles to clean JavaScript output"
HOMEPAGE="https://www.typescriptlang.org/"
SRC_URI="https://github.com/Microsoft/TypeScript/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="$(get_version_component_range 1-2 ${PV})"
KEYWORDS="~amd64 ~x86 ~arm ~arm64 ~ppc ~ppc64"
IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"

UNDERSCORE_STRING_VER="3.3.5"
DEBUG_VER="<3.0.0"
BRACES_VER="^2.3.1"
JS_YAML_VER="^3.13.0"

_fix_vulnerbilities() {
	# We need 4.X for gulp-help.  The audit fix updates it to 4.X and breaks it.
	npm uninstall gulp
	npm install gulp@"<5.0.0" --save-dev || die

	# fix vulnerbilities top level
	rm package-lock.js
	npm i --package-lock || die
	npm audit fix --force || die

	# fix vulnerbility mocha
	pushd node_modules/mocha
	npm i --package-lock || die
	npm audit fix --force || die
	npm uninstall js-yaml
	npm install js-yaml@"^3.13.0" --save-prod || die
	rm package-lock.json
	popd

	sed -i -e "s|\"underscore.string\": \"~3.3.4\"|\"underscore.string\": \"${UNDERSCORE_STRING_VER}\"|g" node_modules/mocha/node_modules/upath/package.json || die
	sed -i -e "s|\"underscore.string\": \"^3.3.4\"|\"underscore.string\": \"${UNDERSCORE_STRING_VER}\"|g" node_modules/mocha/node_modules/wd/package.json || die
	sed -i -e "s|\"underscore.string\": \"~3.3.4\"|\"underscore.string\": \"${UNDERSCORE_STRING_VER}\"|g" node_modules/upath/package.json || die
	sed -i -e "s|\"underscore.string\": \"~2.4.0\"|\"underscore.string\": \"${UNDERSCORE_STRING_VER}\"|g" node_modules/mocha/node_modules/remarkable/node_modules/argparse/package.json || die
	sed -i -e "s|\"underscore.string\": \"2.4.0\"|\"underscore.string\": \"${UNDERSCORE_STRING_VER}\"|g" node_modules/mocha/node_modules/remarkable/package.json || die
	rm -rf node_modules/mocha/node_modules/underscore.string
	pushd node_modules/mocha
	npm install "underscore.string"@"${UNDERSCORE_STRING_VER}" --save-dev || die
	popd


	sed -i -e "s|\"braces\": \"^1.8.2\"|\"braces\": \"${BRACES_VER}\"|g" node_modules/mocha/node_modules/browser-sync/node_modules/micromatch/package.json || die
	sed -i -e "s|\"braces\": \"^2.0.3\"|\"braces\": \"${BRACES_VER}\"|g" node_modules/arr-map/package.json || die
	rm -rf node_modules/braces
	rm -rf node_modules/mocha/node_modules/browser-sync/node_modules/braces
	rm -rf node_modules/mocha/node_modules/braces
	pushd node_modules/mocha/node_modules/browser-sync
	npm install "braces"@"${BRACES_VER}" || die
	popd
	pushd node_modules/mocha
	npm install "braces"@"${BRACES_VER}" || die
	popd
	npm install "braces"@"${BRACES_VER}" || die

	sed -i -e "s|\"debug\": \"~2.2.0\"|\"debug\": \"${DEBUG_VER}\"|g" node_modules/mocha/node_modules/gm-papandreou/package.json || die
	sed -i -e "s|\"debug\": \"^2.2.0\"|\"debug\": \"${DEBUG_VER}\"|g" node_modules/mocha/node_modules/snapdragon/package.json || die
	sed -i -e "s|\"debug\": \"^2.1.2\"|\"debug\": \"${DEBUG_VER}\"|g" node_modules/mocha/node_modules/needle/package.json || die
	sed -i -e "s|\"debug\": \"^2.2.0\"|\"debug\": \"${DEBUG_VER}\"|g" node_modules/mocha/node_modules/resp-modifier/package.json || die
	sed -i -e "s|\"debug\": \"^2.3.3\"|\"debug\": \"${DEBUG_VER}\"|g" node_modules/mocha/node_modules/expand-brackets/package.json || die
	sed -i -e "s|\"debug\": \"^2.6.8\"|\"debug\": \"${DEBUG_VER}\"|g" node_modules/mocha/node_modules/eslint-module-utils/package.json || die
	sed -i -e "s|\"debug\": \"^2.1.2\"|\"debug\": \"${DEBUG_VER}\"|g" node_modules/mocha/node_modules/fsevents/node_modules/needle/package.json || die
	sed -i -e "s|\"debug\": \"2.6.9\"|\"debug\": \"${DEBUG_VER}\"|g" node_modules/mocha/node_modules/finalhandler/package.json || die
	sed -i -e "s|\"debug\": \"^2.3.3\"|\"debug\": \"${DEBUG_VER}\"|g" node_modules/expand-brackets/package.json || die
	sed -i -e "s|\"debug\": \"^2.2.0\"|\"debug\": \"${DEBUG_VER}\"|g" node_modules/snapdragon/package.json || die
	sed -i -e "s|\"debug\": \"^2.1.2\"|\"debug\": \"${DEBUG_VER}\"|g" node_modules/fsevents/node_modules/needle/package.json || die
	rm -rf node_modules/mocha/node_modules/gm-papandreou/node_modules/debug
	rm -rf node_modules/fsevents/node_modules/debug
	rm -rf node_modules/mocha/node_modules/debug
	rm -rf node_modules/debug
	pushd node_modules/mocha
	npm install "debug"@"${DEBUG_VER}" --save-prod || die
	popd
	pushd node_modules/fsevents
	npm install "debug"@"${DEBUG_VER}" || die
	popd
	pushd node_modules/mocha/node_modules/gm-papandreou
	npm install "debug"@"${DEBUG_VER}" --save-prod || die
	popd
	npm install "debug"@"${DEBUG_VER}" || die

	sed -i -e "s|\"js-yaml\": \"3.12.0\"|\"js-yaml\": \"${JS_YAML_VER}\"|g" node_modules/mocha/package.json || die
	sed -i -e "s|\"js-yaml\": \"^3.7.0\"|\"js-yaml\": \"${JS_YAML_VER}\"|g" node_modules/tslint/package.json || die
	sed -i -e "s|\"js-yaml\": \"^3.12.0\"|\"js-yaml\": \"${JS_YAML_VER}\"|g" node_modules/mocha/node_modules/jsdom/package.json || die
	sed -i -e "s|\"js-yaml\": \"^3.9.0\"|\"js-yaml\": \"${JS_YAML_VER}\"|g" node_modules/mocha/node_modules/nps/package.json || die
	sed -i -e "s|\"js-yaml\": \"^3.12.0\"|\"js-yaml\": \"${JS_YAML_VER}\"|g" node_modules/mocha/node_modules/svgo/package.json || die
	sed -i -e "s|\"js-yaml\": \"^3.11.0\"|\"js-yaml\": \"${JS_YAML_VER}\"|g" node_modules/mocha/node_modules/gray-matter/package.json || die
	sed -i -e "s|\"js-yaml\": \"^3.8.1\"|\"js-yaml\": \"${JS_YAML_VER}\"|g" node_modules/mocha/node_modules/markdown-toc/node_modules/gray-matter/package.json || die
	sed -i -e "s|\"js-yaml\": \"^3.11.0\"|\"js-yaml\": \"${JS_YAML_VER}\"|g" node_modules/mocha/node_modules/coveralls/package.json || die
	sed -i -e "s|\"js-yaml\": \"~3.12.1\"|\"js-yaml\": \"${JS_YAML_VER}\"|g" node_modules/mocha/node_modules/markdownlint/package.json || die
	sed -i -e "s|\"js-yaml\": \"^3.10.0\"|\"js-yaml\": \"${JS_YAML_VER}\"|g" node_modules/mocha/node_modules/section-matter/package.json || die
	sed -i -e "s|\"js-yaml\": \"^3.12.0\"|\"js-yaml\": \"${JS_YAML_VER}\"|g" node_modules/mocha/node_modules/eslint/package.json || die
	rm -rf node_modules/js-yaml
	rm -rf node_modules/mocha/node_modules/js-yaml
	pushd node_modules/mocha
	npm install "js-yaml"@"${JS_YAML_VER}" --save-prod || die
	popd
	npm install "js-yaml"@"${JS_YAML_VER}" || die

	pushd node_modules/mocha/
	rm package-lock.json
	npm i --package-lock-only
	popd
	rm package-lock.json
	npm i --package-lock
}

src_unpack() {
	default_src_unpack

	npm-secaudit_src_prepare_default
	npm-secaudit_fetch_deps

	cd "${S}"

	_fix_vulnerbilities

	npm-secaudit_src_compile_default

	npm uninstall gulp -D

	npm-secaudit_src_preinst_default

	pushd node_modules/mocha
	rm package-lock.json
	npm i --package-lock-only || die
	popd

	rm package-lock.json
	npm i --package-lock || die
	npm audit fix --force || die
	npm audit || die
}

src_install() {
	npm-secaudit_install "*"
}

pkg_postinst() {
	npm-secaudit_pkg_postinst
	eselect typescript list | grep ${SLOT} >/dev/null
	if [[ "$?" == "0" ]] ; then
		eselect typescript set ${SLOT}
	fi
}