# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: dotnet.eclass
# @MAINTAINER: cynede@gentoo.org
# @BLURB: common settings and functions for mono and dotnet related packages
# @DESCRIPTION:
# The dotnet eclass contains common environment settings that are useful for
# dotnet packages.  Currently, it provides no functions, just exports
# MONO_SHARED_DIR and sets LC_ALL in order to prevent errors during compilation
# of dotnet packages.

case ${EAPI:-0} in
	0) die "this eclass doesn't support EAPI 0" ;;
	1|2|3) ;;
	*) ;; #if [[ ${USE_DOTNET} ]]; then REQUIRED_USE="|| (${USE_DOTNET})"; fi;;
esac

inherit eutils multibuild mono-env versionator

# @ECLASS-VARIABLE: USE_DOTNET
# @DESCRIPTION:
# Use flags added to IUSE

IUSE+=" debug developer"

DOTNET_ACTIVE_FRAMEWORK="" # can be netfx or netcoreapp or netstandard

_SET_DEPENDS_NETCORE=""

_NETCORE_TOOLS_DEPS="|| ( dev-dotnet/cli-tools dev-dotnet/dotnetcore-sdk-bin )"

# SET default use flags according on DOTNET_TARGETS
for x in ${USE_DOTNET}; do
	case ${x} in
		netstandard20)
			if [[ ${DOTNET_TARGETS} == *netstandard20* ]]; then
				IUSE+=" +netstandard20";
			else
				IUSE+=" netstandard20";
			fi
			_CDEPEND=" netstandard20? ( >=dev-lang/mono-5.2 )" ; DEPEND+=" ${_CDEPEND} netstandard20? ( ${_NETCORE_TOOLS_DEPS} )"; RDEPEND+=" ${_CDEPEND}";
			;;
		netstandard16)
			if [[ ${DOTNET_TARGETS} == *netstandard16* ]]; then
				IUSE+=" +netstandard16";
			else
				IUSE+=" netstandard16";
			fi
			_CDEPEND=" netstandard16? ( >=dev-lang/mono-4.6 )" ; DEPEND+=" ${_CDEPEND} netstandard16? ( ${_NETCORE_TOOLS_DEPS} )"; RDEPEND+=" ${_CDEPEND}";
			;;
		netstandard15)
			if [[ ${DOTNET_TARGETS} == *netstandard15* ]]; then
				IUSE+=" +netstandard15";
			else
				IUSE+=" netstandard15";
			fi
			_CDEPEND=" netstandard15? ( >=dev-lang/mono-4.6 )" ; DEPEND+=" ${_CDEPEND} netstandard15? ( ${_NETCORE_TOOLS_DEPS} )"; RDEPEND+=" ${_CDEPEND}";
			;;
		netstandard14)
			if [[ ${DOTNET_TARGETS} == *netstandard14* ]]; then
				IUSE+=" +netstandard14";
			else
				IUSE+=" netstandard14";
			fi
				_CDEPEND=" netstandard14? ( >=dev-lang/mono-4.6 )" ; DEPEND+=" ${_CDEPEND} netstandard14? ( ${_NETCORE_TOOLS_DEPS} )"; RDEPEND+=" ${_CDEPEND}";
			;;
		netstandard13)
			if [[ ${DOTNET_TARGETS} == *netstandard13* ]]; then
				IUSE+=" +netstandard13";
			else
				IUSE+=" netstandard13";
			fi
			_CDEPEND=" netstandard13? ( >=dev-lang/mono-4.6 )" ; DEPEND+=" ${_CDEPEND} netstandard13? ( ${_NETCORE_TOOLS_DEPS} )"; RDEPEND+=" ${_CDEPEND}";
			;;
		netstandard12)
			if [[ ${DOTNET_TARGETS} == *netstandard12* ]]; then
				IUSE+=" +netstandard12";
			else
				IUSE+=" netstandard12";
			fi
			_CDEPEND=" netstandard12? ( >=dev-lang/mono-4.6 )" ; DEPEND+=" ${_CDEPEND} netstandard12? ( ${_NETCORE_TOOLS_DEPS} )"; RDEPEND+=" ${_CDEPEND}";
			;;
		netstandard11)
			if [[ ${DOTNET_TARGETS} == *netstandard11* ]]; then
				IUSE+=" +netstandard11";
			else
				IUSE+=" netstandard11";
			fi
			_CDEPEND=" netstandard11? ( >=dev-lang/mono-4.6 )" ; DEPEND+=" ${_CDEPEND} netstandard11? ( ${_NETCORE_TOOLS_DEPS} )"; RDEPEND+=" ${_CDEPEND}";
			;;
		netstandard10)
			if [[ ${DOTNET_TARGETS} == *netstandard10* ]]; then
				IUSE+=" +netstandard10";
			else
				IUSE+=" netstandard10";
			fi
			_CDEPEND=" netstandard10? ( >=dev-lang/mono-4.6 )" ; DEPEND+=" ${_CDEPEND} netstandard10? ( ${_NETCORE_TOOLS_DEPS} )"; RDEPEND+=" ${_CDEPEND}";
			;;
		netcoreapp22)
			if [[ ${DOTNET_TARGETS} == *netcoreapp22* ]]; then
				IUSE+=" +netcoreapp22";
			else
				IUSE+=" netcoreapp22";
			fi
			_CDEPEND=" netcoreapp22? ( >=dev-lang/mono-5.4 )" ; DEPEND+=" ${_CDEPEND} netcoreapp22? ( ${_NETCORE_TOOLS_DEPS} )"; RDEPEND+=" ${_CDEPEND}";
			;;
		netcoreapp21)
			if [[ ${DOTNET_TARGETS} == *netcoreapp21* ]]; then
				IUSE+=" +netcoreapp21";
			else
				IUSE+=" netcoreapp21";
			fi
			_CDEPEND=" netcoreapp21? ( >=dev-lang/mono-5.4 )" ; DEPEND+=" ${_CDEPEND} netcoreapp21? ( ${_NETCORE_TOOLS_DEPS} )"; RDEPEND+=" ${_CDEPEND}";
			;;
		netcoreapp20)
			if [[ ${DOTNET_TARGETS} == *netcoreapp20* ]]; then
				IUSE+=" +netcoreapp20";
			else
				IUSE+=" netcoreapp20";
			fi
			_CDEPEND=" netcoreapp20? ( >=dev-lang/mono-5.4 )" ; DEPEND+=" ${_CDEPEND} netcoreapp20? ( ${_NETCORE_TOOLS_DEPS} )"; RDEPEND+=" ${_CDEPEND}";
			;;
		netcoreapp11)
			if [[ ${DOTNET_TARGETS} == *netcoreapp11* ]]; then
				IUSE+=" +netcoreapp11";
			else
				IUSE+=" netcoreapp11";
			fi
			_CDEPEND=" netcoreapp11? ( >=dev-lang/mono-5.4 )" ; DEPEND+=" ${_CDEPEND} netcoreapp11? ( ${_NETCORE_TOOLS_DEPS} )"; RDEPEND+=" ${_CDEPEND}";
			;;
		netcoreapp10)
			if [[ ${DOTNET_TARGETS} == *netcoreapp10* ]]; then
				IUSE+=" +netcoreapp10";
			else
				IUSE+=" netcoreapp10";
			fi
			_CDEPEND=" netcoreapp10? ( >=dev-lang/mono-5.4 )" ; DEPEND+=" ${_CDEPEND} netcoreapp10? ( ${_NETCORE_TOOLS_DEPS} )"; RDEPEND+=" ${_CDEPEND}";
			;;
		net472)
			if [[ ${DOTNET_TARGETS} == *net472* ]];	then
				IUSE+=" +net472";
			else
				IUSE+=" net472";
			fi
			_CDEPEND=" net472? ( >=dev-lang/mono-5.18 )"; DEPEND+="${_CDEPEND}"; RDEPEND+="${_CDEPEND}";
			;;
		net471)
			if [[ ${DOTNET_TARGETS} == *net471* ]]; then
				IUSE+=" +net471";
			else
				IUSE+=" net471";
			fi
			_CDEPEND=" net471? ( >=dev-lang/mono-5.10 )"; DEPEND+="${_CDEPEND}"; RDEPEND+="${_CDEPEND}";
			;;
		net47)
			if [[ ${DOTNET_TARGETS} == *net47* ]]; then
				IUSE+=" +net47";
			else
				IUSE+=" net47";
			fi
			_CDEPEND=" net47? ( >=dev-lang/mono-5.2 )"; DEPEND+="${_CDEPEND}"; RDEPEND+="${_CDEPEND}";
			;;
		net462)
			if [[ ${DOTNET_TARGETS} == *net462* ]];	then
				IUSE+=" +net462";
			else
				IUSE+=" net462";
			fi
			_CDEPEND=" net462? ( >=dev-lang/mono-4.6 )"; DEPEND+="${_CDEPEND}"; RDEPEND+="${_CDEPEND}";
			;;
		net461)
			if [[ ${DOTNET_TARGETS} == *net461* ]]; then
				IUSE+=" +net461";
			else
				IUSE+=" net461";
			fi
			_CDEPEND=" net461? ( >=dev-lang/mono-4.6 )"; DEPEND+="${_CDEPEND}"; RDEPEND+="${_CDEPEND}";
			;;
		net46)
			if [[ ${DOTNET_TARGETS} == *net46* ]]; then
				IUSE+=" +net46";
			else
				IUSE+=" net46";
			fi
			_CDEPEND=" net46? ( >=dev-lang/mono-4.6 )"; DEPEND+="${_CDEPEND}"; RDEPEND+="${_CDEPEND}";
			;;
		net452)
			if [[ ${DOTNET_TARGETS} == *net452* ]]; then
				IUSE+=" +net452";
			else
				IUSE+=" net452";
			fi
			_CDEPEND=" net452? ( >=dev-lang/mono-4.6 )"; DEPEND+="${_CDEPEND}"; RDEPEND+="${_CDEPEND}";
			;;
		net451)
			if [[ ${DOTNET_TARGETS} == *net451* ]];	then
				IUSE+=" +net451";
			else
				IUSE+=" net451";
			fi
			_CDEPEND=" net451? ( >=dev-lang/mono-4.6 )"; DEPEND+="${_CDEPEND}"; RDEPEND+="${_CDEPEND}";
			;;
		net45)
			if [[ ${DOTNET_TARGETS} == *net45* ]]; then
				IUSE+=" +net45";
			else
				IUSE+=" net45";
			fi
			_CDEPEND=" net45? ( >=dev-lang/mono-4.0 )"; DEPEND+="${_CDEPEND}"; RDEPEND+="${_CDEPEND}";
			;;
		net40)
			if [[ ${DOTNET_TARGETS} == *net40* ]]; then
				IUSE+=" +net40";
			else
				IUSE+=" net40";
			fi
			_CDEPEND=" net40? ( <dev-lang/mono-4.0 )"; DEPEND+="${_CDEPEND}"; RDEPEND+="${_CDEPEND}";
			;;
		net35)
			if [[ ${DOTNET_TARGETS} == *net35* ]]; then
				IUSE+=" +net35";
			else
				IUSE+=" net35";
			fi
			_CDEPEND=" net35? ( <dev-lang/mono-4.0 )"; DEPEND+="${_CDEPEND}"; RDEPEND+="${_CDEPEND}";
			;;
		net20)
			if [[ ${DOTNET_TARGETS} == *net20* ]]; then
				IUSE+=" +net20";
			else
				IUSE+=" net20";
			fi
			_CDEPEND=" net20? ( <dev-lang/mono-4.0 )"; DEPEND+="${_CDEPEND}"; RDEPEND+="${_CDEPEND}";
			;;
	esac
done

_dotnet_sandbox_disabled_check() {
	if has sandbox $FEATURES || has usersandbox $FEATURES ; then
		die "${PN} require sandbox and usersandbox to be disabled in FEATURES."
	fi
}

_dotnet_sandbox_network_disabled_check() {
	if has network-sandbox $FEATURES ; then
		die "${PN} require network-sandbox to be disabled in FEATURES."
	fi
}

# @FUNCTION: dotnet_pkg_pretend
# @DESCRIPTION:  This function will inspect sandbox readiness for dotnet build (which implies dotnet restore) or nuget restore
dotnet_pkg_pretend() {
	for x in ${USE_DOTNET} ; do
		case ${x} in
			netstandard20) if use netstandard20; then DOTNET_ACTIVE_FRAMEWORK="netstandard"; fi;;
			netstandard16) if use netstandard16; then DOTNET_ACTIVE_FRAMEWORK="netstandard"; fi;;
			netstandard15) if use netstandard15; then DOTNET_ACTIVE_FRAMEWORK="netstandard"; fi;;
			netstandard14) if use netstandard14; then DOTNET_ACTIVE_FRAMEWORK="netstandard"; fi;;
			netstandard13) if use netstandard13; then DOTNET_ACTIVE_FRAMEWORK="netstandard"; fi;;
			netstandard12) if use netstandard12; then DOTNET_ACTIVE_FRAMEWORK="netstandard"; fi;;
			netstandard11) if use netstandard11; then DOTNET_ACTIVE_FRAMEWORK="netstandard"; fi;;
			netstandard10) if use netstandard10; then DOTNET_ACTIVE_FRAMEWORK="netstandard"; fi;;
			netcoreapp22) if use netcoreapp22; then DOTNET_ACTIVE_FRAMEWORK="netcoreapp"; fi;;
			netcoreapp21) if use netcoreapp21; then DOTNET_ACTIVE_FRAMEWORK="netcoreapp"; fi;;
			netcoreapp20) if use netcoreapp20; then DOTNET_ACTIVE_FRAMEWORK="netcoreapp"; fi;;
			netcoreapp11) if use netcoreapp11; then DOTNET_ACTIVE_FRAMEWORK="netcoreapp"; fi;;
			netcoreapp10) if use netcoreapp10; then DOTNET_ACTIVE_FRAMEWORK="netcoreapp"; fi;;
			*) DOTNET_ACTIVE_FRAMEWORK="netfx" ;;
		esac

		if [[ "${DOTNET_ACTIVE_FRAMEWORK}" == "netstandard" || "${DOTNET_ACTIVE_FRAMEWORK}" == "netcoreapp" ]] ; then
			_dotnet_sandbox_disabled_check
		fi

		# applies to netfx or those that use nuget as well; almost always for netcore and netstandard packages
		if [[ -n "${USE_DOTNET_RESTORE}" || "${DOTNET_ACTIVE_FRAMEWORK}" == "netstandard" || "${DOTNET_ACTIVE_FRAMEWORK}" == "netcoreapp" ]] ; then
			_dotnet_sandbox_network_disabled_check
		fi
	done
}

# @FUNCTION: dotnet_pkg_setup
# @DESCRIPTION:  This function set FRAMEWORK to the highest requested framework
dotnet_pkg_setup() {
	EBUILD_FRAMEWORK=""
	mono-env_pkg_setup
	for x in ${USE_DOTNET} ; do
		case ${x} in
			netstandard20) EBF="200.0"; if use netstandard20; then F="${EBF}";fi;;
			netstandard16) EBF="100.6"; if use netstandard16; then F="${EBF}";fi;;
			netstandard15) EBF="100.5"; if use netstandard15; then F="${EBF}";fi;;
			netstandard14) EBF="100.4"; if use netstandard14; then F="${EBF}";fi;;
			netstandard13) EBF="100.3"; if use netstandard13; then F="${EBF}";fi;;
			netstandard12) EBF="100.2"; if use netstandard12; then F="${EBF}";fi;;
			netstandard11) EBF="100.1"; if use netstandard11; then F="${EBF}";fi;;
			netstandard10) EBF="100.0"; if use netstandard10; then F="${EBF}";fi;;
			netcoreapp22) EBF="20.2"; if use netcoreapp22; then F="${EBF}";fi;;
			netcoreapp21) EBF="20.1"; if use netcoreapp21; then F="${EBF}";fi;;
			netcoreapp20) EBF="20.0"; if use netcoreapp20; then F="${EBF}";fi;;
			netcoreapp11) EBF="10.1"; if use netcoreapp11; then F="${EBF}";fi;;
			netcoreapp10) EBF="10.0"; if use netcoreapp10; then F="${EBF}";fi;;
			net472) EBF="4.72"; if use net472; then F="${EBF}";fi;;
			net471) EBF="4.71"; if use net471; then F="${EBF}";fi;;
			net47) EBF="4.7"; if use net47; then F="${EBF}";fi;;
			net462) EBF="4.62"; if use net462; then F="${EBF}";fi;;
			net461) EBF="4.61"; if use net461; then F="${EBF}";fi;;
			net46) EBF="4.6"; if use net46; then F="${EBF}";fi;;
			net45) EBF="4.5"; if use net45; then F="${EBF}";fi;;
			net40) EBF="4.0"; if use net40; then F="${EBF}";fi;;
			net35) EBF="3.5"; if use net35; then F="${EBF}";fi;;
			net20) EBF="2.0"; if use net20; then F="${EBF}";fi;;
		esac
		if [[ -z ${FRAMEWORK} ]]; then
			if [[ -n ${F} ]]; then
				FRAMEWORK="${F}";
			fi
		else
			version_is_at_least "${F}" "${FRAMEWORK}" || FRAMEWORK="${F}"
		fi
		if [[ -z ${EBUILD_FRAMEWORK} ]]; then
			if [[ -n ${EBF} ]]; then
				EBUILD_FRAMEWORK="${EBF}";
			fi
		else
			version_is_at_least "${EBF}" "${EBUILD_FRAMEWORK}" || EBUILD_FRAMEWORK="${EBF}"
		fi
	done
	if [[ -z ${FRAMEWORK} ]]; then
		if [[ -z ${EBUILD_FRAMEWORK} ]]; then
			FRAMEWORK="4.5"
			elog "Ebuild doesn't contain USE_DOTNET="
		else
			FRAMEWORK="${EBUILD_FRAMEWORK}"
			elog "User did not set any netNN use-flags in make.conf or profile, .ebuild demands USE_DOTNET=""${USE_DOTNET}"""
		fi
	fi

	# FRAMEWORK is the highest wanted by the user?
	version_compare "${FRAMEWORK}" "100"
	R1="$?"
	version_compare "${FRAMEWORK}" "10"
	R2="$?"
	if [[ "${R1}" == "3" ]] ; then
		DOTNET_ACTIVE_FRAMEWORK="netstandard"
		FRAMEWORK=$(echo "scale=1 ; ${FRAMEWORK}/100" | bc)
		einfo " -- USING .NET STANDARD ${FRAMEWORK} -- "
	elif [[ "${R2}" == "3" ]] ; then
		DOTNET_ACTIVE_FRAMEWORK="netcoreapp"
		FRAMEWORK=$(echo "scale=1 ; ${FRAMEWORK}/10" | bc)
		einfo " -- USING .NET CORE ${FRAMEWORK} -- "
	else
		DOTNET_ACTIVE_FRAMEWORK="netfx"
		einfo " -- USING .NET FRAMEWORK ${FRAMEWORK} -- "
	fi
	export EBF="${FRAMEWORK}"

	# EBUILD_FRAMEWORK is the highest suppored by ebuild?
	version_compare "${EBUILD_FRAMEWORK}" "100"
	R1="$?"
	version_compare "${EBUILD_FRAMEWORK}" "10"
	R2="$?"
	if [[ "${R1}" == "3" ]] ; then
		DOTNET_ACTIVE_FRAMEWORK_EF="netstandard"
		EBUILD_FRAMEWORK=$(echo "scale=1 ; ${EBUILD_FRAMEWORK}/100" | bc)
	elif [[ "${R2}" == "3" ]] ; then
		DOTNET_ACTIVE_FRAMEWORK_EF="netcoreapp"
		EBUILD_FRAMEWORK=$(echo "scale=1 ; ${EBUILD_FRAMEWORK}/10" | bc)
	else
		DOTNET_ACTIVE_FRAMEWORK_EF="netfx"
	fi
}

# >=mono-0.92 versions using mcs -pkg:foo-sharp require shared memory, so we set the
# shared dir to ${T} so that ${T}/.wapi can be used during the install process.
export MONO_SHARED_DIR="${T}"

# Building mono, nant and many other dotnet packages is known to fail if LC_ALL
# variable is not set to C. To prevent this all mono related packages will be
# build with LC_ALL=C (see bugs #146424, #149817)
export LC_ALL=C

# Monodevelop-using applications need this to be set or they will try to create config
# files in the user's ~ dir.

export XDG_CONFIG_HOME="${T}"

# Fix bug 83020:
# "Access Violations Arise When Emerging Mono-Related Packages with MONO_AOT_CACHE"

unset MONO_AOT_CACHE

# @FUNCTION: output_relpath
# @DESCRIPTION:  returns default relative directory for Debug or Release configuration depending from USE="debug"
function output_relpath ( ) {
	local DIR=""
	if use debug; then
		DIR="Debug"
	else
		DIR="Release"
	fi
	echo "bin/${DIR}"
}

# @FUNCTION: exbuild_netfx_raw
# @DESCRIPTION: run xbuild with given parameters
_exbuild_netfx_raw() {
	elog """$@"""
	xbuild "$@" || die
}


# @FUNCTION: _exbuild_netstandard_raw
# @DESCRIPTION: alias for _exbuild_netcore_raw
_exbuild_netstandard_raw() {
	_exbuild_netcore_raw $@
}

# @FUNCTION: _exbuild_netcore_raw
# @DESCRIPTION: run dotnet with given parameters
_exbuild_netcore_raw() {
	elog """$@"""
	dotnet "$@" || die
}

# @FUNCTION: exbuild_raw
# @DESCRIPTION: run xbuild or dotnet with given parameters
exbuild_raw() {
	if [[ "${TOOLS_VERSION}" == "15.0" || "${DOTNET_ACTIVE_FRAMEWORK}" == "netcoreapp" || "${DOTNET_ACTIVE_FRAMEWORK}" == "netstandard" ]] ; then
		_exbuild_netcore_raw $@
	elif [[ "${DOTNET_ACTIVE_FRAMEWORK}" == "netfx" ]] ; then
		_exbuild_netfx_raw $@
	fi
}

# @FUNCTION: _exbuild_netfx
# @DESCRIPTION: run xbuild with Release configuration and configurated FRAMEWORK, for .NET Framework.
_exbuild_netfx() {
	if use debug; then
		CARGS=/p:Configuration=Debug
	else
		CARGS=/p:Configuration=Release
	fi

	if use developer; then
		SARGS=/p:DebugSymbols=True
	else
		SARGS=/p:DebugSymbols=False
	fi

	if [[ -z ${TOOLS_VERSION} ]]; then
		TOOLS_VERSION=4.0
	fi

	_exbuild_netfx_raw "/v:detailed" "/tv:${TOOLS_VERSION}" "/p:TargetFrameworkVersion=v${EBF}" "${CARGS}" "${SARGS}" "$@"
}

# @FUNCTION: _exbuild_netstandard
# @DESCRIPTION: alias for _exbuild_netcore
_exbuild_netstandard() {
	_exbuild_netcore $@
}

# @FUNCTION: _exbuild_netcore
# @DESCRIPTION: run dotnet build with Release configuration and configurated FRAMEWORK, for .NET Core and .NET Standard
_exbuild_netcore() {
	local project="$1"
	shift

	if use debug; then
		CARGS=-p:Configuration=Debug
	else
		CARGS=-p:Configuration=Release
	fi

	if use developer; then
		SARGS=-p:DebugSymbols=True
	else
		SARGS=-p:DebugSymbols=False
	fi

	local framework
	if [[ -n ${TOOLS_VERSION} && "${TOOLS_VERSION}" == "15.0" && "${DOTNET_ACTIVE_FRAMEWORK}" == "netfx" ]] ; then
		framework=${DOTNET_ACTIVE_FRAMEWORK//fx/}${EBF//./}
	else
		framework=${DOTNET_ACTIVE_FRAMEWORK}${EBF}
	fi

	_exbuild_netcore_raw build "${project}" "-verbosity:detailed" "-f" "${framework}" "${CARGS}" "${SARGS}" "$@"
}

# @FUNCTION: exbuild
# @DESCRIPTION: frontend for xbuild and dotnet
exbuild() {
	if [[ "${TOOLS_VERSION}" == "15.0" ||  "${DOTNET_ACTIVE_FRAMEWORK}" == "netcoreapp" || "${DOTNET_ACTIVE_FRAMEWORK}" == "netstandard" ]] ; then
		_exbuild_netcore $@
	elif [[ "${DOTNET_ACTIVE_FRAMEWORK}" == "netfx" ]] ; then
		_exbuild_netfx $@
	fi
}

# @FUNCTION: embuild
# @DESCRIPTION: frontend for dotnet msbuild
embuild() {
	if use debug; then
		CARGS=-p:Configuration=Debug
	else
		CARGS=-p:Configuration=Release
	fi

	if use developer; then
		SARGS=-p:DebugSymbols=True
	else
		SARGS=-p:DebugSymbols=False
	fi

	if [[ -z ${TOOLS_VERSION} ]]; then
		TOOLS_VERSION="Current"
	fi

	_exbuild_netcore_raw msbuild "-verbosity:detailed" "-toolsversion:${TOOLS_VERSION}" "${CARGS}" "${SARGS}" "$@"
}

# @FUNCTION: dotnet_multilib_comply
# @DESCRIPTION:  multilib comply
dotnet_multilib_comply() {
	use !prefix && has "${EAPI:-0}" 0 1 2 && ED="${D}"
	local dir finddirs=() mv_command=${mv_command:-mv}
	if [[ -d "${ED}/usr/lib" && "$(get_libdir)" != "lib" ]]
	then
		if ! [[ -d "${ED}"/usr/"$(get_libdir)" ]]
		then
			mkdir "${ED}"/usr/"$(get_libdir)" || die "Couldn't mkdir ${ED}/usr/$(get_libdir)"
		fi
		${mv_command} "${ED}"/usr/lib/* "${ED}"/usr/"$(get_libdir)"/ || die "Moving files into correct libdir failed"
		rm -rf "${ED}"/usr/lib
		for dir in "${ED}"/usr/"$(get_libdir)"/pkgconfig "${ED}"/usr/share/pkgconfig
		do

			if [[ -d "${dir}" && "$(find "${dir}" -name '*.pc')" != "" ]]
			then
				pushd "${dir}" &> /dev/null
				sed  -i -r -e 's:/(lib)([^a-zA-Z0-9]|$):/'"$(get_libdir)"'\2:g' \
					*.pc \
					|| die "Sedding some sense into pkgconfig files failed."
				popd "${dir}" &> /dev/null
			fi
		done
		if [[ -d "${ED}/usr/bin" ]]
		then
			for exe in "${ED}/usr/bin"/*
			do
				if [[ "$(file "${exe}")" == *"shell script text"* ]]
				then
					sed -r -i -e ":/lib(/|$): s:/lib(/|$):/$(get_libdir)\1:" \
						"${exe}" || die "Sedding some sense into ${exe} failed"
				fi
			done
		fi

	fi
}

# @FUNCTION: estrong_assembly_info
# @DESCRIPTION:  This will inject the key in AssemblyInfo.cs
# @CODE
# Parameters:
# $1 - injection line usually "using System.Runtime.InteropServices;"
# $2 - path to the private key
# $3 - the path to the AssemblyInfo.cs file to inject the key into
# $4 - patch with using System.Reflection; (optional) -- set to 1
# @CODE
estrong_assembly_info() {
	sed -i -r -e "s|$1|$1\n[assembly:AssemblyKeyFileAttribute(\"$2\")]|" "$3" || die

	if [[ -n "$4" ]] ; then
		if [[ "${4,,}" == "true" || "$4" == "1" || "${4,,}" == "yes" || "${4,,}" == "y" ]] ; then
			# required if it complains about AssemblyKeyFileAttribute
			sed -i -e "s|$1|using System.Reflection;\n$1\n|g" "$3" || die
		fi
	fi
}

# @FUNCTION: estrong_resign
# @DESCRIPTION:  This will re-sign the dll with the key
# @CODE
# Parameters:
# $1 - the path to the dll
# $2 - the private key
# @CODE
estrong_resign() {
	sn -R "$1" "$2" || die
}

# @FUNCTION: erestore
# @DESCRIPTION:  This will explicitly pull the dependencies for the package.
erestore() {
	dotnet restore || die
}

_NETFX_VERS=( 20 35 40 45 46 461 462 47 471 472 48 )
_NETCORE_VERS=( 10 11 20 21 22 )
_NETSTANDARD_VERS=( 10 11 12 13 14 15 16 20 )
_IMPLS="${_NETFX_VERS[@]/#/net} ${_NETCORE_VERS[@]/#/netcoreapp} ${_NETSTANDARD_VERS[@]/#/netstandard}"

# @FUNCTION: _python_multibuild_wrapper
# @DESCRIPTION: Initialize the environment for this implementation
# EDOTNET contains the implementination of dotnet to process like EPYTHON
# BUILD_DIR contains the path to the instance of the copied sources
_dotnet_multibuild_wrapper() {
	debug-print-function ${FUNCNAME} "${@}"

	EDOTNET="${MULTIBUILD_VARIANT}"
	if [[ "${MULTIBUILD_VARIANT}" =~ net[0-9][0-9][0-9]? ]] ; then
		DOTNET_ACTIVE_FRAMEWORK="${EDOTNET//net/netfx}"
	else
		DOTNET_ACTIVE_FRAMEWORK="${EDOTNET}"
	fi
	DOTNET_ACTIVE_FRAMEWORK="${DOTNET_ACTIVE_FRAMEWORK//[0-9\.]/}"
	EBF=$(dotnet_dotted_moniker "${MULTIBUILD_VARIANT}")
	EBF="${EBF//netstandard/}"
	EBF="${EBF//netcoreapp/}"
	EBF="${EBF//net/}"

	mkdir -p "${PORTAGE_BUILDDIR}/homedir-${MULTIBUILD_VARIANT}"
	HOME="${PORTAGE_BUILDDIR}/homedir-${MULTIBUILD_VARIANT}"

	# run it
	"${@}"
}

# @FUNCTION: dotnet_foreach_impl
# @DESCRIPTION:  This will execute a callback for each dotnet implementation
dotnet_foreach_impl() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	_dotnet_obtain_impls

	multibuild_foreach_variant _dotnet_multibuild_wrapper "${@}"
}

# @FUNCTION: dotnet_copy_sources
# @DESCRIPTION:  This will copy the source code in another folder per implementation
dotnet_copy_sources() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	_dotnet_obtain_impls

	multibuild_copy_sources
}

# @FUNCTION: _dotnet_obtain_impls
# @DESCRIPTION:  This will fill up MULTIBUILD_VARIANTS if user chosen implementation
_dotnet_obtain_impls() {
	MULTIBUILD_VARIANTS=()
	for impl in ${_IMPLS} ; do
		local A_USE_DOTNET=($(echo "${USE_DOTNET}" | tr ' ' '\n'))
		has "${impl}" ${A_USE_DOTNET[@]} && use "${impl}" && MULTIBUILD_VARIANTS+=( "${impl}" )
	done
}

# @FUNCTION: dotnet_netcore_install_loc
# @DESCRIPTION:  This will generate the recommended location to install the package for netcore and netstandard.
# @CODE
# Parameters:
# $1 - the framework moniker e.g. net46 netstandard2.0 (optional)
# @CODE
dotnet_netcore_install_loc() {
	local moniker="${1}"
	local _dotnet
	if [ -d /opt/dotnet ] ; then
		# built from source code: dev-dotnet/cli-tools
		_dotnet="dotnet"
	else
		# precompiled: dev-dotnet/dotnetcore-sdk-bin
		_dotnet="dotnet_core"
	fi

	local framework

	if [[ -n "${moniker}" ]]; then
		framework="${moniker}"
	else
		if [[ -n ${TOOLS_VERSION} && "${TOOLS_VERSION}" == "15.0" && "${DOTNET_ACTIVE_FRAMEWORK}" == "netfx" ]] ; then
			framework=${DOTNET_ACTIVE_FRAMEWORK//fx/}${EBF//./}
		else
			framework=${DOTNET_ACTIVE_FRAMEWORK}${EBF}
		fi
	fi

	echo "/opt/${_dotnet}/sdk/NuGetFallbackFolder/${PN,,}/${PV,,}/lib/${framework}"
}

# @FUNCTION: dotnet_netfx_install_loc
# @DESCRIPTION:  This will generate the recommended location to install the package for netfx.
# @CODE
# Parameters:
# $1 - the framework moniker e.g. net46 (optional)
# @CODE
dotnet_netfx_install_loc() {
	local moniker="${1}"
	if [[ -z "${moniker}" ]] ; then
		moniker=${DOTNET_ACTIVE_FRAMEWORK//fx/}${EBF//./}
	fi

	if [[ "${moniker}" == "net472" ]] ; then
		echo "/usr/lib/mono/4.7.2-api"
	elif [[ "${moniker}" == "net471" ]] ; then
		echo "/usr/lib/mono/4.7.1-api"
	elif [[ "${moniker}" == "net47" ]] ; then
		echo "/usr/lib/mono/4.7-api"
	elif [[ "${moniker}" == "net462" ]] ; then
		echo "/usr/lib/mono/4.6.2-api"
	elif [[ "${moniker}" == "net461" ]] ; then
		echo "/usr/lib/mono/4.6.1-api"
	elif [[ "${moniker}" == "net46" ]] ; then
		echo "/usr/lib/mono/4.6-api"
	elif [[ "${moniker}" == "net452" ]] ; then
		echo "/usr/lib/mono/4.5.2-api"
	elif [[ "${moniker}" == "net451" ]] ; then
		echo "/usr/lib/mono/4.5.1-api"
	elif [[ "${moniker}" == "net45" ]] ; then
		echo "/usr/lib/mono/4.5"
	elif [[ "${moniker}" == "net40" ]] ; then
		echo "/usr/lib/mono/4.0-api"
	elif [[ "${moniker}" == "net35" ]] ; then
		echo "/usr/lib/mono/3.5-api"
	elif [[ "${moniker}" == "net20" ]] ; then
		echo "/usr/lib/mono/2.0-api"
	fi
}

# @FUNCTION: dotnet_dotted_moniker
# @DESCRIPTION:  This will restore the periods for the moniker.  netstandard20 will report netstandard2.0 .
# @RETURN: A dotted version string e.g. netstandard2.0
# @CODE
# Parameters:
# $1 - the framework moniker e.g. net46 (optional)
# @CODE
dotnet_dotted_moniker() {
	local moniker="${1}"
	if [[ -z "${moniker}" ]] ; then
		moniker=${DOTNET_ACTIVE_FRAMEWORK//fx/}${EBF//./}
	fi

	if [[ "${moniker}" == "netstandard20" ]] ; then
		echo "netstandard2.0"
	elif [[ "${moniker}" == "netstandard16" ]] ; then
		echo "netstandard1.6"
	elif [[ "${moniker}" == "netstandard15" ]] ; then
		echo "netstandard1.5"
	elif [[ "${moniker}" == "netstandard14" ]] ; then
		echo "netstandard1.4"
	elif [[ "${moniker}" == "netstandard13" ]] ; then
		echo "netstandard1.3"
	elif [[ "${moniker}" == "netstandard12" ]] ; then
		echo "netstandard1.2"
	elif [[ "${moniker}" == "netstandard11" ]] ; then
		echo "netstandard1.1"
	elif [[ "${moniker}" == "netstandard10" ]] ; then
		echo "netstandard1.0"
	elif [[ "${moniker}" == "netcoreapp22" ]] ; then
		echo "netcoreapp2.2"
	elif [[ "${moniker}" == "netcoreapp21" ]] ; then
		echo "netcoreapp2.1"
	elif [[ "${moniker}" == "netcoreapp20" ]] ; then
		echo "netcoreapp2.0"
	elif [[ "${moniker}" == "netcoreapp11" ]] ; then
		echo "netcoreapp1.1"
	elif [[ "${moniker}" == "netcoreapp10" ]] ; then
		echo "netcoreapp1.0"
	elif [[ "${moniker}" == "net472" ]] ; then
		echo "net4.7.2"
	elif [[ "${moniker}" == "net471" ]] ; then
		echo "net4.7.1"
	elif [[ "${moniker}" == "net47" ]] ; then
		echo "net4.7"
	elif [[ "${moniker}" == "net462" ]] ; then
		echo "net4.6.2"
	elif [[ "${moniker}" == "net461" ]] ; then
		echo "net4.6.1"
	elif [[ "${moniker}" == "net46" ]] ; then
		echo "net4.6"
	elif [[ "${moniker}" == "net452" ]] ; then
		echo "net4.5.2"
	elif [[ "${moniker}" == "net451" ]] ; then
		echo "net4.5.1"
	elif [[ "${moniker}" == "net45" ]] ; then
		echo "net4.5"
	elif [[ "${moniker}" == "net40" ]] ; then
		echo "net4.0"
	elif [[ "${moniker}" == "net35" ]] ; then
		echo "net3.5"
	elif [[ "${moniker}" == "net20" ]] ; then
		echo "net2.0"
	fi
}

# @FUNCTION: dotnet_use_flag_moniker_to_ms_moniker
# @DESCRIPTION:  This will conver the use flag moniker to ms format
# @RETURN: A dotted version string for netcore and netstandard, except netfx
# @CODE
# Parameters:
# $1 - the framework moniker e.g. net46 (optional)
# @CODE
dotnet_use_flag_moniker_to_ms_moniker() {
	local moniker="${1}"
	if [[ -z "${moniker}" ]] ; then
		moniker=${DOTNET_ACTIVE_FRAMEWORK//fx/}${EBF//./}
	fi

	if [[ "${moniker}" == "netstandard20" ]] ; then
		echo "netstandard2.0"
	elif [[ "${moniker}" == "netstandard16" ]] ; then
		echo "netstandard1.6"
	elif [[ "${moniker}" == "netstandard15" ]] ; then
		echo "netstandard1.5"
	elif [[ "${moniker}" == "netstandard14" ]] ; then
		echo "netstandard1.4"
	elif [[ "${moniker}" == "netstandard13" ]] ; then
		echo "netstandard1.3"
	elif [[ "${moniker}" == "netstandard12" ]] ; then
		echo "netstandard1.2"
	elif [[ "${moniker}" == "netstandard11" ]] ; then
		echo "netstandard1.1"
	elif [[ "${moniker}" == "netstandard10" ]] ; then
		echo "netstandard1.0"
	elif [[ "${moniker}" == "netcoreapp22" ]] ; then
		echo "netcoreapp2.2"
	elif [[ "${moniker}" == "netcoreapp21" ]] ; then
		echo "netcoreapp2.1"
	elif [[ "${moniker}" == "netcoreapp20" ]] ; then
		echo "netcoreapp2.0"
	elif [[ "${moniker}" == "netcoreapp11" ]] ; then
		echo "netcoreapp1.1"
	elif [[ "${moniker}" == "netcoreapp10" ]] ; then
		echo "netcoreapp1.0"
	elif [[ "${moniker}" == "net472" ]] ; then
		echo "net472"
	elif [[ "${moniker}" == "net471" ]] ; then
		echo "net471"
	elif [[ "${moniker}" == "net47" ]] ; then
		echo "net47"
	elif [[ "${moniker}" == "net462" ]] ; then
		echo "net462"
	elif [[ "${moniker}" == "net461" ]] ; then
		echo "net461"
	elif [[ "${moniker}" == "net46" ]] ; then
		echo "net46"
	elif [[ "${moniker}" == "net452" ]] ; then
		echo "net452"
	elif [[ "${moniker}" == "net451" ]] ; then
		echo "net451"
	elif [[ "${moniker}" == "net45" ]] ; then
		echo "net45"
	elif [[ "${moniker}" == "net40" ]] ; then
		echo "net40"
	elif [[ "${moniker}" == "net35" ]] ; then
		echo "net35"
	elif [[ "${moniker}" == "net20" ]] ; then
		echo "net20"
	fi
}

# @FUNCTION: dotnet_is_netfx
# @DESCRIPTION:  This will inspect the moniker to see if it is dotnet
# @RETURN: 0 (OK) is netfx/.NET Framework, 1 (NO) is not netfx/.NET Framework moniker
# @CODE
# Parameters:
# $1 - the framework moniker e.g. net46 (optional)
# @CODE
dotnet_is_netfx() {
	local moniker="${1}"
	if [[ -z "${moniker}" ]] ; then
		moniker=${DOTNET_ACTIVE_FRAMEWORK//fx/}${EBF//./}
	fi

	if [[ "${moniker}" =~ net[0-9][0-9][0-9]? ]]; then
		return 0
	fi
	return 1
}

EXPORT_FUNCTIONS pkg_setup pkg_pretend

