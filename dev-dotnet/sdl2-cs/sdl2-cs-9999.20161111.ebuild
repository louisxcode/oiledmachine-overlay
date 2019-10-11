# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="SDL2-CS is a C# wrapper for SDL2"
HOMEPAGE="https://github.com/flibitijibibo/SDL2-CS"
LICENSE="zlib"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net40"
RDEPEND=">=media-libs/libsdl2-2.0.5
         media-libs/sdl2-ttf
         media-libs/sdl2-mixer"
DEPEND="${RDEPEND}"
IUSE="${USE_DOTNET} debug gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( net40 )"
inherit dotnet eutils mono
PROJECT_NAME="SDL2-CS"
COMMIT="4ec65bc5a00049f7211b506ed85033f1c72c60af"
SRC_URI="https://github.com/flibitijibibo/${PROJECT_NAME}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
inherit gac
SLOT="0"
S="${WORKDIR}/${PROJECT_NAME}-${COMMIT}"

src_prepare() {
	default
	dotnet_copy_sources
}

src_compile() {
	mydebug="release"
	if use debug; then
		mydebug="debug"
	fi

	compile_impl() {
	        exbuild ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" /p:Configuration=${mydebug} SDL2-CS.csproj || die

		dotnet_copy_dllmap_config "${FILESDIR}/SDL2-CS.dll.config"
	}

	dotnet_foreach_impl compile_impl
}

src_install() {
	install_impl() {
		mydebug="Release"
		if use debug; then
			mydebug="Debug"
		fi

		if [[ "${EDOTNET}" =~ netstandard ]] ; then
			mydebug="${mydebug,,}"
		fi

		dotnet_install_loc

		estrong_resign "bin/${mydebug}/${PROJECT_NAME}.dll" "${DISTDIR}/mono.snk"
		doins bin/${mydebug}/SDL2-CS.dll
		doins SDL2-CS.dll.config
		egacinstall "bin/${mydebug}/${PROJECT_NAME}.dll"
		dotnet_distribute_dllmap_config "${PROJECT_NAME}.dll"
	}

	dotnet_foreach_impl install_impl

	dotnet_multilib_comply
}
