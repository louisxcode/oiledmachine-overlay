# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}
	 dev-util/electron"

DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"

inherit eutils desktop electron-app

DESCRIPTION="Preserver is desktop notes organiser built on electron, angular2, pouchDB"
HOMEPAGE="http://www.hiteshbalar.com/preserver"
SRC_URI="https://github.com/hsbalar/preserver/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}/${PN}-${PV}"

src_install() {
	electron-app_desktop_install "*" "public/images/preserver_icon.png" "${PN^}" "Utility" "cd /usr/$(get_libdir)/node/${PN}/${SLOT}/ && /usr/bin/node start-electron.js"
}
