# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Java based plugin allowing LateralGM to compile games using \
ENIGMA."
HOMEPAGE="https://github.com/enigma-dev/lgmplugin"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
SLOT="0/${PV}"
ECJ_V="4.4"
JAVA_V="1.7"
RDEPEND="games-util/lateralgm
	 virtual/jre"
DEPEND="|| ( dev-java/icedtea
	     dev-java/icedtea-bin )
	dev-java/jna[nio-buffers]
	games-util/lateralgm"
BDEPEND="dev-java/eclipse-ecj:${ECJ_V}
	 virtual/jdk"
EGIT_COMMIT="2bd2060f19114f81d3f808ed7ce2661986cadb75"
SRC_URI=\
"https://github.com/enigma-dev/lgmplugin/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
inherit eutils
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

src_prepare() {
	default
	which /usr/bin/ecj-4.4 || die
	sed -i -e \
"s|\
JC = ecj -1.6 -nowarn -cp .|\
JC = /usr/bin/ecj-${ECJ_V} -${JAVA_V} -nowarn -cp .|" \
		Makefile || die
	sed -i -e \
"s|\
../plugins/shared/jna.jar:\
../lgm16b4.jar:\
/usr/share/java/eclipse-ecj.jar:\
/usr/share/java/ecj.jar\
|\
/usr/share/jna/lib/jna.jar:\
/usr/$(get_libdir)/enigma/lateralgm.jar:\
/usr/share/eclipse-ecj-${ECJ_V}/lib/ecj.jar|" \
		Makefile || die
	sed -i -e "s|../plugins/enigma.jar|enigma.jar|" Makefile || die
	sed -i -e "s|        |\t|" Makefile || die
	sed -i -e \
"s|\
../lateralgm.jar \
shared/svnkit.jar \
shared/jna.jar\
|\
../lateralgm.jar \
/usr/$(get_libdir)/enigma/swinglayout-lgm.jar \
/usr/share/jna/lib/jna.jar|" \
		META-INF/MANIFEST.MF || die
}

src_compile() {
	#icedtea is required because of missing classes
	MAKEOPTS="-j1" \
	emake
}

src_install() {
	insinto "/usr/$(get_libdir)/enigma/plugins"
	doins enigma.jar
}
