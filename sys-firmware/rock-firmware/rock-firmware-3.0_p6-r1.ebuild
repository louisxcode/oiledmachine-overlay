# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Radeon Open Compute (ROCk) firmware"
HOMEPAGE="https://rocm.github.io/"
LICENSE="LICENSE.amdgpu LICENSE.radeon"
# LICENSE.ucode mentioned at
#   https://rocm-documentation.readthedocs.io/en/latest/Installation_Guide/ROCK-Kernel-Driver_readme.html
# License found at:
#   https://github.com/HSAFoundation/HSA-Drivers-Linux-AMD/blob/master/LICENSE.ucode
# Same as:
#   https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/LICENSE.amdgpu
# The documentation may be outdated and the following license may apply:
#   https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/LICENSE.radeon
# See also mentioning the difference in firmware
#   https://github.com/RadeonOpenCompute/ROCm#rocm-support-in-upstream-linux-kernels
KEYWORDS="~amd64"
MY_RPR="${PV//_p/-}" # Remote PR
FN="rock-dkms_${MY_RPR}_all.deb"
BASE_URL="http://repo.radeon.com/rocm/apt/debian"
FOLDER="pool/main/r/rock-dkms"
RDEPEND="!sys-firmware/amdgpu-firmware"
RESTRICT="fetch"
SLOT="0/${PV}"
inherit unpacker
SRC_URI="http://repo.radeon.com/rocm/apt/debian/pool/main/r/rock-dkms/${FN}"
S="${WORKDIR}"

pkg_nofetch() {
        local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
        einfo "Please download"
        einfo "  - ${FN}"
        einfo "from ${BASE_URL} in the ${FOLDER} folder and place them in"
	einfo "${distdir}"
}

pkg_setup() {
	if [[ -d /lib/firmware/amdgpu || -d /lib/firmware/radeon ]] ; then
		die \
"/lib/firmware/{amdgpu,radeon} folders must not be present.  Make sure that\n\
the savedconfig USE flag is set in the linux-firmware package and you\n\
removed the firmware there.  Do something like\n\
  \`sed -i -e \"s|^amdgpu|#amdgpu|g\" -e \"s|^radeon|#radeon|g\" \
/etc/portage/savedconfig/sys-kernel/linux-firmware-20191108\`\n\
For futher details, see\n\
  https://wiki.gentoo.org/wiki/Linux_firmware#Savedconfig"
	fi
}

src_unpack() {
	unpack_deb ${A}
}

src_configure() {
	:;
}

src_compile() {
	:;
}

src_install() {
	insinto /lib/firmware
	doins -r usr/src/amdgpu-${MY_RPR}/firmware/{radeon,amdgpu}
	docinto licenses
	dodoc "${FILESDIR}"/{LICENSE.amdgpu,LICENSE.radeon}
	# The archives should contain license files but don't.
}
