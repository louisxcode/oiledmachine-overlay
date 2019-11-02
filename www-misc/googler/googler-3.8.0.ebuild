# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Google from the terminal"
HOMEPAGE="https://github.com/jarun/googler"
SRC_URI="https://github.com/jarun/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
PYTHON_COMPAT=( python{3_4,3_5,3_6} )
inherit eutils
MY_PV="3.8"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"
RDEPEND="${DEPEND}"
RESTRICT="mirror"
S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	default
	export PREFIX="/usr"
	export DOCDIR="/usr/share/${P}"
	sed -i -e "s|/share/doc/googler|/share/doc/googler-${PVR}|" \
		Makefile || die
	sed -i -e "s|gzip|#gzip|" \
		-e "s|googler.1.gz|googler.1|g" Makefile || die
}

