# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_DOTNET="net35 net40 net45 netstandard20 netcoreapp20 netcoreapp21 test"
IUSE="${USE_DOTNET} debug gac ${PACKAGE_FEATURES} doc"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( || ( net40 net45 ) ) test? ( || ( netcoreapp20 netcoreapp21 net35 net40 net45 ) )"
RDEPEND=""
DEPEND="${RDEPEND}
        doc? ( app-doc/doxygen )"

inherit dotnet eutils mono

DESCRIPTION="C# library for parsing and importing TMX and TSX files generated by Tiled, a tile map generation tool."
HOMEPAGE="https://github.com/marshallward/TiledSharp"
COMMIT="f29fb71591200093fa159f53094b8b8d7fab1d17"
PROJECT_NAME="TiledSharp"
SRC_URI="https://github.com/marshallward/TiledSharp/archive/${COMMIT}.zip -> ${P}.zip"

inherit gac

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${PROJECT_NAME}-${COMMIT}"
TOOLS_VERSION="Current"

src_unpack() {
	if use netcoreapp20 || use netcoreapp21 ; then
		ewarn "The netcoreapp20 or netcoreapp21 USE flags are only for unit testing.  They will not be creating the dlls for TiledSharp."
	fi
	unpack ${A}

	cd "${S}"
	erestore
}

src_prepare() {
	default

	dotnet_copy_sources
}

src_compile() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	compile_impl() {
		if [[ ! ( "${EDOTNET}" =~ netcoreapp ) ]] ; then
			exbuild TiledSharp/TiledSharp.csproj -p:Configuration=${mydebug} ${STRONG_ARGS_NETFX}${DISTDIR}/mono.snk || die
		fi
		if use test ; then
			exbuild TiledSharp.Test/TiledSharp.Test.csproj -p:Configuration=${mydebug} ${STRONG_ARGS_NETFX}${DISTDIR}/mono.snk || die
		fi
	}

	dotnet_foreach_impl compile_impl

	if use doc ; then
		cd docs
		doxygen Doxyfile
	fi
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	install_impl() {
		dotnet_install_loc
		if [[ "${EDOTNET}" =~ netstandard ]] ; then
			doins TiledSharp/bin/Release/$(dotnet_use_flag_moniker_to_ms_moniker ${EDOTNET})/{TiledSharp.dll,TiledSharp.deps.json}
			use developer && doins TiledSharp/bin/Release/$(dotnet_use_flag_moniker_to_ms_moniker ${EDOTNET})/TiledSharp.pdb
		elif dotnet_is_netfx "${EDOTNET}" ; then
			doins TiledSharp/bin/Release/$(dotnet_use_flag_moniker_to_ms_moniker ${EDOTNET})/TiledSharp.dll
			use developer && doins TiledSharp/bin/Release/$(dotnet_use_flag_moniker_to_ms_moniker ${EDOTNET})/TiledSharp.pdb
			estrong_resign "TiledSharp/bin/Release/$(dotnet_use_flag_moniker_to_ms_moniker ${EDOTNET})/TiledSharp.dll" "${DISTDIR}/mono.snk" || die
	                egacinstall "TiledSharp/bin/Release/$(dotnet_use_flag_moniker_to_ms_moniker ${EDOTNET})/TiledSharp.dll"
		fi
	}

	dotnet_foreach_impl install_impl

	use doc && dodoc -r docs/html

	dotnet_multilib_comply
}

src_test() {
	test_impl() {
		#todo
		true
	}

	dotnet_foreach_impl test_impl
}
