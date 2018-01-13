# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="0.10.0"
NODE_MODULE_DEPEND="ansi-regex:1.1.0 get-stdin:4.0.1"
NODE_MODULE_EXTRA_FILES="cli.js"

inherit node-module

DESCRIPTION="Check if a string has ANSI escape codes"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( readme.md )

src_install() {
        node-module_src_install
	install_node_module_binary "cli.js" "/usr/local/bin/${PN}-${SLOT}"
}

