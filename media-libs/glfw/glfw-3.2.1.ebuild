# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake-multilib

DESCRIPTION="The Portable OpenGL FrameWork"
HOMEPAGE="https://www.glfw.org/"
SRC_URI="mirror://sourceforge/glfw/${P}.tar.bz2"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~hppa x86"
IUSE="examples wayland"

RDEPEND="
	x11-libs/libxkbcommon[${MULTILIB_USEDEP}]
	media-libs/vulkan-loader[${MULTILIB_USEDEP}]
	!wayland? (
		virtual/opengl[${MULTILIB_USEDEP}]
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXcursor[${MULTILIB_USEDEP}]
		x11-libs/libXinerama[${MULTILIB_USEDEP}]
		x11-libs/libXrandr[${MULTILIB_USEDEP}]
		x11-libs/libXxf86vm[${MULTILIB_USEDEP}]
	)
	wayland? (
		dev-libs/wayland[${MULTILIB_USEDEP}]
		media-libs/mesa[egl,wayland,${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
	wayland? (
		dev-libs/wayland-protocols[${MULTILIB_USEDEP}]
		kde-frameworks/extra-cmake-modules
	)
"

src_configure() {
	configure_abi() {
		local mycmakeargs=(
			-DGLFW_BUILD_EXAMPLES="$(usex examples)"
			-DGLFW_USE_WAYLAND="$(usex wayland)"
			-DBUILD_SHARED_LIBS=1
		)
		cmake-utils_src_configure
	}
	multilib_foreach_abi configure_abi
}
