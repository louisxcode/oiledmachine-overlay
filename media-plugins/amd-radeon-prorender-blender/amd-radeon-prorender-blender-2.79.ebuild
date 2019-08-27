# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_5,3_6} )

inherit unpacker python-single-r1

DESCRIPTION="An OpenCL accelerated scaleable raytracing rendering engine for Blender"
HOMEPAGE="https://www.amd.com/en/technologies/radeon-prorender-blender"
HOMEPAGE_DL="https://www.amd.com/en/technologies/radeon-prorender-downloads"

PLUGIN_NAME="rprblender"
FN="radeonprorenderforblender.run"
SRC_URI="https://www2.ati.com/other/${FN}"

RESTRICT="fetch strip"

IUSE="+materials +checker video_cards_radeonsi video_cards_nvidia video_cards_fglrx video_cards_amdgpu video_cards_intel video_cards_r600"

# if amdgpu-pro is installed libgl-mesa-dev containing development headers and libs were pulled and noted in the Packages file:
# amdgpu-pro 19.20.812932 -> libgl-mesa-dev 18.3.0-812932
# amdgpu-pro 19.30.838629 -> libgl-mesa-dev 19.2.0-838629
#
NV_DRIVER_VERSION="368.39"
RDEPEND="${PYTHON_DEPS}
	>=media-gfx/blender-2.79[${PYTHON_USEDEP}]
	video_cards_amdgpu? ( media-libs/mesa )
	|| (
		virtual/opencl
		video_cards_nvidia? ( >=x11-drivers/nvidia-drivers-${NV_DRIVER_VERSION} )
		video_cards_fglrx? ( || ( x11-drivers/ati-drivers ) )
		video_cards_amdgpu? ( || ( dev-util/amdapp x11-drivers/amdgpu-pro[opencl] ) )
	)
	>=media-libs/freeimage-3.0
	"
DEPEND="${RDEPEND}
	dev-libs/openssl"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

LICENSE="AMD-RADEON-PRORENDER-BLENDER-2.79-EULA"
KEYWORDS="~amd64"
SLOT="0"

PROPERTIES="interactive"

S="${WORKDIR}/${PN}-${PV}"

pkg_pretend() {
	if use checker ; then
		for DEVICE in $(ls /dev/*/card* /dev/dri/renderD128)
		do
		        cat /etc/sandbox.conf | grep -e "${DEVICE}"
		        if [ $? == 1 ] ; then
		                die "SANDBOX_WRITE=\"${DEVICE}\" needs to be added to /etc/sandbox.conf"
		        fi
		done
	fi
}

pkg_nofetch() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	einfo "Please download"
	einfo "  - ${FN}"
	einfo "from ${HOMEPAGE_DL} and place them in ${distdir}"
}

_registration_link_nochecker() {
	einfo ""
	einfo "You need a registration key.  Obtain one at:"
	einfo ""
	einfo "https://feedback.amd.com/se/${UNK_ID}?registrationid=${REGISTRATION_ID}&appname=${APPNAME}&appversion=${APPVERSION}&frversion=${FR_VER}&os=${MY_OS}&gfxcard=${GFXCARD_MFG}&driverversion=${DRIVER_VERSION}"
	einfo ""
	einfo "If it fails, enable checker USE flag to generate a proper registration link."
	einfo ""
}

_registration_link_checker() {
	einfo ""
	einfo "You need a registration key.  Obtain one at:"
	einfo ""
	einfo "${URL}"
	einfo ""
}

_pkg_setup() {
	ewarn "Package still in testing/development"

	cd "${S}"
	BLENDER_VER=$(/usr/bin/blender --version | grep -e "Blender [0-9.]*" | tr "(" "_" | tr ")" "_" | tr " " "_" | sed "s|Blender||" | cut -c 2-)
	BLENDER_VER_NO_SUB=$(/usr/bin/blender --version | grep -e "Blender [0-9.]*" | sed -r -e "s|Blender ([0-9.]*).*|\1|g")
	KERNEL_VER=$(uname -r)
	MY_OS="Linux${KERNEL_VER}"
	GFXCARD_MFG="AMD_"
	BLENDER_BUILD_HASH="unknown" # from --version inspection but none found
	FR_VER="1.205057" # unknown source
	APPNAME="blender"
	APPVERSION="${BLENDER_VER}__${BLENDER_BUILD_HASH}"
	REGISTRATION_ID="5A1E27D259A3291C" # unknown source
	UNK_ID="5A1E27D23E8EC664" # unknown source
	DRIVER_VERSION=""

	if use video_cards_amdgpu || use video_cards_radeonsi || use video_cards_r600 || use video_cards_fglrx ; then
		GFXCARD_MFG="AMD_"
	elif use video_cards_nvidia ; then
		GFXCARD_MFG="NVIDIA_" # guess

		NV_DRIVER_VERSION=$(/proc/driver/nvidia/version | grep NVRM | cut -f8)
		DRIVER_VERSION="${NV_DRIVER_VERSION}" # guess
	else
		ewarn "Your card may not be supported but may be limited to CPU rendering."
	fi

	if use checker ; then
		# Checker needs OpenCL or it will crash
		# The checker will check your hardware for compatibility and generate a registration url based on BLENDER_VER and KERNEL_VER
		yes | BLENDER_VERSION=${BLENDER_VER_NO_SUB} ./addon/checker || die
		URL=$(yes | BLENDER_VERSION=${BLENDER_VER_NO_SUB} ./addon/checker | grep -o https.*)
	else
		ewarn "Disabling checker is experimental."
		_registration_link_nochecker
	fi

	if [[ -z "${PRORENDER_REG_KEY}" ]] ; then
		if use checker ; then
			_registration_link_checker
		else
			_registration_link_nochecker
		fi
		eerror "You need to set the environmental variable PRORENDER_REG_KEY in make.conf or in your package.env."
		die
	fi

	export REGISTRATION_HASH_SHA1=$(echo "${PRORENDER_REG_KEY}" | sha1sum | cut -c 1-40)
	export REGISTRATION_HASH_MD5=$(echo "${PRORENDER_REG_KEY}" | md5sum | cut -c 1-32)
}

src_unpack() {
	default

	mkdir -p ${S}

	cd "${S}"

	unpack_makeself ${A}

	cd "${WORKDIR}"
	unpack_zip "${S}"/addon/addon.zip

	_pkg_setup
}

_decode_error_message() {
	eerror "Your registration key is incorrect."
	die
}

src_install() {
	local d
	local d_materals
	d_materials="/usr/share/${PN}/Radeon_ProRender/Blender/Material_Library"
	DIRS=$(find /usr/share/blender/ -maxdepth 1 | tail -n +2)
	for d in ${DIRS} ; do
		d="${D}/${d}/scripts/addons_contrib/${PLUGIN_NAME}"
		mkdir -p "${d}" || die
		chmod 775 "${d}" || die
		chown root:users "${d}" || die
		cp -a "${WORKDIR}/${PLUGIN_NAME}"/* "${d}" || die
		if use materials ; then
			echo "${d_materials}" > "${d}/.matlib_installed" || die
		fi
		K=$(echo "${REGISTRATION_HASH_SHA1}:${REGISTRATION_HASH_MD5}" | sha1sum | cut -c 1-40)
		einfo "Attempting to mark installation as registered..."
		CT="U2FsdGVkX180DSQe3s+CgxQ70JR1XS18HW9r2z+fo9tCUwSeZ7+cEKd1UH9Tkv8S"
		eval $(echo "${CT}" | openssl enc -aes-128-cbc -a -salt -k ${K}) || _decode_error_message
	done
	if use materials ; then
		einfo "Copying materials..."
		mkdir -p "${D}/${d_materials}" || die
		cp -a "${S}"/matlib/feature_MaterialLibrary/* "${D}/${d_materials}" || die
	fi
}

pkg_postinst() {
	einfo "You must enable the addon manually."
	einfo "It is listed under: File > User Preferences > Add-ons > Testing > All > Render: Radeon ProRender"

	local d_materals
	if use materials ; then
		einfo "The material library have been installed in:"
		einfo "/usr/share/${PN}/Radeon_ProRender/Blender/Material_Library"
	fi
}
