# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/mtpfs/mtpfs-1.1-r1.ebuild,v 1.1 2015/05/30 22:33:27 slyfox Exp $

EAPI=5

inherit eutils git-r3 autotools

DESCRIPTION="A FUSE filesystem providing access to MTP devices"
HOMEPAGE="http://www.adebenham.com/mtpfs/"
#SRC_URI="http://www.adebenham.com/files/mtp/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug mad"

RDEPEND="dev-libs/glib:2
	>=media-libs/libmtp-1.1.2
	sys-fs/fuse
	mad? (
		media-libs/libid3tag
		media-libs/libmad
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=(AUTHORS NEWS README)

EGIT_REPO_URI="https://github.com/cjd/mtpfs.git"
EGIT_BRANCH="master"
EGIT_COMMIT="fd2a493ccd0f2c137a504bed5cff881e37451ca7"

src_prepare() {
	true
	#sed -e "/#include <string.h>/ a\
		#include <stdlib.h>" -i mtpfs.h id3read.c || die #implicit

	#epatch "${FILESDIR}"/${P}-fix-mutex-crash.patch
	eautoreconf
}

src_configure() {
	econf $(use_enable debug) \
		$(use_enable mad)
}

pkg_postinst() {
	einfo "To mount your MTP device, issue:"
	einfo "    /usr/bin/mtpfs <mountpoint>"
	echo
	einfo "To unmount your MTP device, issue:"
	einfo "    /usr/bin/fusermount -u <mountpoint>"

	if use debug; then
		echo
		einfo "You have enabled debugging output."
		einfo "Please make sure you run mtpfs with the -d flag."
	fi
}
