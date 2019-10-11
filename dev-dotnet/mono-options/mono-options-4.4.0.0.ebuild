# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A Getopt.Long-inspired option parsing library for CSharp"
HOMEPAGE="http://tirania.org/blog/archive/2008/Oct-14.html"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"
USE_DOTNET="net45"
IUSE="+${USE_DOTNET} nupkg"
REQUIRED_USE="|| ( ${USE_DOTNET} ) nupkg"
DEPEND="dev-lang/mono[external-mono-options]"
RDEPEND="${DEPEND}"
inherit nupkg pc-file
SHORT_HASH="3abbe5b" # obtained from string cmd
COMMIT="3abbe5b7e6cb6fed2cd1f85598ccd5d5f63a3bda"
SRC_URI="https://github.com/mono/mono/archive/${COMMIT}.zip -> ${P}.zip"
inherit gac
S="${WORKDIR}/mono-${COMMIT}"
SLOT="0"
NUSPEC_VERSION=${PV}
ASSEMBLY_VERSION=${PV}

get_dlldir() {
	if use abi_x86_64 ; then
		echo /usr/lib32/mono/mono-options
	elif use abi_x86_32 ; then
		echo /usr/lib64/mono/mono-options
	else
		die "Unsupported arch.  Contact ebuild maintainer."
	fi
}

src_configure() {
	# dont' call default configure for the whole mono package, because it is slow
	cat <<-METADATA >AssemblyInfo.cs || die
			[assembly: System.Reflection.AssemblyVersion("${ASSEMBLY_VERSION}")]
		METADATA
}

src_compile() {
	mcs $(usex gac "-keyfile:mcs/class/mono.snk" "") -sdk:${EBF} -r:System.Core mcs/class/Mono.Options/Mono.Options/Options.cs AssemblyInfo.cs -t:library -out:"Mono.Options.dll" || die "compilation failed"
	enuspec "${FILESDIR}/Mono.Options.nuspec"
}

src_install() {
	insinto "$(get_dlldir)/slot-${SLOT}"
	doins "Mono.Options.dll"

	dosym "slot-${SLOT}/Mono.Options.dll" "$(get_dlldir)/Mono.Options.dll"

	einstall_pc_file ${PN} ${ASSEMBLY_VERSION} Mono.Options

	enupkg "${WORKDIR}/Mono.Options.${NUSPEC_VERSION}.nupkg"

	dotnet_multilib_comply
}

pkg_postinst() {
	if use gac; then
		einfo "adding to GAC"
		gacutil -i "$(get_dlldir)/slot-${SLOT}/Mono.Options.dll" || die
	fi
}

pkg_prerm() {
	if use gac; then
		# TODO determine version for uninstall from slot-N dir
		einfo "removing from GAC"
		gacutil -u Mono.Options
		# don't die, it there is no such assembly in GAC
	fi
}
