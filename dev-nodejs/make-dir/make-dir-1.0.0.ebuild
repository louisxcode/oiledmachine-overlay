# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NODEJS_MIN_VERSION="4.0.0"
NODE_MODULE_DEPEND="pify:2.3.0"

inherit node-module

DESCRIPTION="Make a directory and its parents if needed - Think mkdir -p"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

DOCS=( readme.md )
