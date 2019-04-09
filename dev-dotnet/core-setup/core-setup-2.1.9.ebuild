# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# BASED ON https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=dotnet-cli
#          https://git.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/dotnet-core

EAPI="6"

CORE_V=${PV}

DESCRIPTION="Installer packages for the .NET Core runtime and libraries"
HOMEPAGE="https://github.com/dotnet/core-setup"
LICENSE="MIT"

IUSE="tests debug"

SRC_URI="https://github.com/dotnet/core-setup/archive/v${CORE_V}.tar.gz -> coresetup-${CORE_V}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm64 ~arm"

RDEPEND="
	>=sys-devel/llvm-4.0:*
	>=dev-util/lldb-4.0
	>=sys-libs/libunwind-1.1-r1
	>=dev-libs/icu-57.1
	>=dev-util/lttng-ust-2.8.1
	>=dev-libs/openssl-1.0.2h-r2
	>=net-misc/curl-7.49.0
	>=sys-libs/zlib-1.2.8-r1"
DEPEND="${RDEPEND}
	dev-vcs/git
	>=dev-util/cmake-3.3.1-r1
	>=sys-devel/make-4.1-r1
	>=sys-devel/clang-3.7.1-r100
	>=sys-devel/gettext-0.19.7
	!dev-dotnet/dotnetcore-runtime-bin
	!dev-dotnet/dotnetcore-sdk-bin
	!dev-dotnet/dotnetcore-aspnet-bin"

S=${WORKDIR}
CORESETUP_S="${S}/core-setup-${CORE_V}"

# This currently isn't required but may be needed in later ebuilds
# running the dotnet cli inside a sandbox causes the dotnet cli command to hang.
# but this ebuild doesn't currently use that.

pkg_pretend() {
	# If FEATURES="-sandbox -usersandbox" are not set dotnet will hang while compiling.
	if has sandbox $FEATURES || has usersandbox $FEATURES ; then
		die ".NET core command-line (CLI) tools require sandbox and usersandbox to be disabled in FEATURES."
	fi
}

src_unpack() {
	unpack "coresetup-${CORE_V}.tar.gz"

	# gentoo or the sandbox doesn't allow downloads in compile phase so move here
	_src_prepare
	_src_compile
}

_src_prepare() {
#	default_src_prepare
	cd "${WORKDIR}"

	# allow verbose output
	local F=$(grep -l -r -e "__init_tools_log" $(find ${WORKDIR} -name "*.sh"))
	for f in $F ; do
		echo "Patching $f"
		sed -i -e 's|>> "$__init_tools_log" 2>&1|\|\& tee -a "$__init_tools_log"|g' -e 's|>> "$__init_tools_log"|\| tee -a "$__init_tools_log"|g' -e 's| > "$__init_tools_log"| \| tee "$__init_tools_log"|g' "$f" || die
	done

	# allow wget curl output
	local F=$(grep -l -r -e "-sSL" $(find ${WORKDIR} -name "*.sh"))
	for f in $F ; do
		echo "Patching $f"
		sed -i -e 's|-sSL|-L|g' -e 's|wget -q |wget |g' "$f" || die
	done
}

_src_compile() {
	local buildargs_coresetup=""
	local mydebug="release"
	local myarch=""

	# for smoother multitasking (default 50) and to prevent IO starvation
	export npm_config_maxsockets=5

	if use debug ; then
		mydebug="debug"
	fi

	if [[ ${ARCH} =~ (amd64) ]]; then
		myarch="x64"
	elif [[ ${ARCH} =~ (x86) ]] ; then
		myarch="x32"
	elif [[ ${ARCH} =~ (arm64) ]] ; then
		myarch="arm64"
	elif [[ ${ARCH} =~ (arm) ]] ; then
		myarch="arm"
	fi


	# prevent: InvalidOperationException: The terminfo database is invalid dotnet
	# cannot be xterm-256color
	export TERM=linux # pretend to be outside of X

	# force 1 since it slows down the pc
	local numproc="1"
	buildargs_coresetup+=" --numproc ${numproc}"

	if ! use tests ; then
		buildargs_coresetup+=" -SkipTests=true"
	else
		buildargs_coresetup+=" -SkipTests=false"
	fi

	einfo "Building Core-Setup"
	cd "${CORESETUP_S}"
	./build.sh --arch ${myarch} --configuration ${mydebug^} ${buildargs_coresetup} || die
}

src_install() {
	local dest="/opt/dotnet_cli"
	local ddest="${D}/${dest}"
	local ddest_core="${ddest}/shared/Microsoft.NETCore.App"
	local ddest_sdk="${D}/opt/dotnet_core/sdk/${PV}/"

	dodir "${dest}"
	# TODO
	cp -a "${CORESETUP_S}/"/* "${ddest_core}/${PV}/" || die
}