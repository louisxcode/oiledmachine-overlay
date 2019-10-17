# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info unpacker

DESCRIPTION="ROCk DKMS kernel module"
HOMEPAGE="https://rocm-documentation.readthedocs.io/en/latest/Installation_Guide/ROCk-kernel.html"
LICENSE="GPL-2 MIT"
KEYWORDS="amd64"
MY_RPR="${PV//_p/-}" # Remote PR
FN="rock-dkms_${MY_RPR}_all.deb"
BASE_URL="http://repo.radeon.com/rocm/apt/debian"
FOLDER="pool/main/r/rock-dkms"
SRC_URI="http://repo.radeon.com/rocm/apt/debian/pool/main/r/rock-dkms/${FN}"
SLOT="0/${PV}"
IUSE="+build +check-mmu-notifier +check-pcie +check-gpu firmware"
RDEPEND="firmware? ( sys-firmware/rock-firmware )
	 sys-kernel/dkms
	 || ( <sys-kernel/ck-sources-5.3
	      <sys-kernel/gentoo-sources-5.3
	      <sys-kernel/git-sources-5.3
	      <sys-kernel/ot-sources-5.3
	      <sys-kernel/pf-sources-5.3
	      <sys-kernel/vanilla-sources-5.3
	      <sys-kernel/zen-sources-5.3 )"
DEPEND="${RDEPEND}
	check-pcie? ( sys-apps/dmidecode )
	check-gpu? ( sys-apps/pciutils )"
S="${WORKDIR}/usr/src/amdgpu-${MY_RPR}"
RESTRICT="fetch"
DKMS_PKG_NAME="amdgpu"
DKMS_PKG_VER="${MY_RPR}"
DC_VER="3.2.46"
AMDGPU_VERSION="5.0.79"
KV_NOT_SUPPORTED="5.3"

# patches based on https://aur.archlinux.org/cgit/aur.git/tree/?h=amdgpu-dkms
# patches try to make it linux kernel 5.1+ compatible but still missing 5.3 compatibility.

# the use-drm_need_swiotlb and use-drm_helper_force_disable_all patches do not flag errors.  i don't know how these are sourced.

PATCHES=( "${FILESDIR}/rock-dkms-2.8_p13-makefile-recognize-gentoo.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-fix-ac_kernel_compile_ifelse.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_probe_helper-for-5_1-part-1.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_probe_helper-for-5_1-part-2.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_probe_helper-for-5_1-part-3.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_probe_helper-for-5_1-part-4.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_probe_helper-for-5_1-part-5.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_probe_helper-for-5_1-part-6.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_probe_helper-for-5_1-part-7.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_probe_helper-for-5_1-part-8.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_probe_helper-for-5_1-part-9.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_probe_helper-for-5_1-part-10.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_probe_helper-for-5_1-part-11.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-add-signal_h-for-signal_pending.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-add-drm_probe_helper_h-for-drm_helper_probe_single_connector_modes.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-either-drm_fb_helper_fill_var-or-drm_fb_helper_fill_info.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-ditched-driver_irq_shared.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_fb_helper_fill_fix-doesnt-apply-for-kernel-ver-5_2-and-above.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_helper_force_disable_all-only-for-before-kernel-ver-5_1.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_hdmi_avi_infoframe_from_display_mode-for-5_1-part-1.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_hdmi_avi_infoframe_from_display_mode-for-5_1-part-2.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_hdmi_avi_infoframe_from_display_mode-for-5_1-part-3.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_hdmi_avi_infoframe_from_display_mode-for-5_1-part-4.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_format_plane_cpp-ditched-in-5_3.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-use-ktime_get_boottime_ns-for-5_3.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-enable-mmu_notifier.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-fix-configure-test-invalidate_range_start-wants-2-args-requires-config-mmu-notifier.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-mmu_notifier_range_blockable-for-5_2.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-vm_fault_t-is-__bitwise-unsigned-int-for-5_1.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-drm_atomic_private_obj_init-adev-ddev-arg-for-5_1.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-no-firmware-install.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-no-update-initramfs.patch"

	  # drm_crtc_force_disable_all was not marked error
	  "${FILESDIR}/rock-dkms-2.8_p13-use-drm_helper_force_disable_all-for-5_1.patch"

	  # adev->need_swiotlb = drm_get_max_iomem() > ((u64)1 << dma_bits); was not marked error
	  "${FILESDIR}/rock-dkms-2.8_p13-use-drm_need_swiotlb-for-5_2-part-1.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-use-drm_need_swiotlb-for-5_2-part-2.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-use-drm_need_swiotlb-for-5_2-part-3.patch"
	  "${FILESDIR}/rock-dkms-2.8_p13-use-drm_need_swiotlb-for-5_2-part-4.patch" )

pkg_nofetch() {
        local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
        einfo "Please download"
        einfo "  - ${FN}"
        einfo "from ${BASE_URL} in the ${FOLDER} folder and place them in ${distdir}"
}

pkg_pretend() {
	if use check-pcie ; then
		if has sandbox $FEATURES ; then
			die "${PN} require sandbox to be disabled in FEATURES when testing hardware with check-pcie USE flag."
		fi
	fi
}

pkg_setup_warn() {
	ewarn "Disabling build is not recommended.  It is intended for unattended installs.  You are responsible for the following .config flags:"

	if ! linux_config_exists ; then
		ewarn "You are missing a .config file in your linux sources."
	fi

	if ! linux_chkconfig_builtin "MODULES" ; then
		ewarn "You need loadable modules support in your .config."
	fi

	CONFIG_CHECK=" !TRIM_UNUSED_KSYMS"
	WARNING_TRIM_UNUSED_KSYMS="CONFIG_TRIM_UNUSED_KSYMS should not be set and the kernel recompiled without it."
	check_extra_config

	if use check-mmu-notifier ; then
		CONFIG_CHECK=" ~HSA_AMD"
		WARNING_CONFIG_HSA_AMD=" CONFIG_HSA_AMD must be set to =y in the kernel .config."
	fi

	check_extra_config

	CONFIG_CHECK=" ~MMU_NOTIFIER"
	WARNING_MMU_NOTIFIER=" CONFIG_MMU_NOTIFIER must be set to =y in the kernel or it will fail in the link stage."

	check_extra_config

	CONFIG_CHECK=" ~DRM_AMD_ACP"
	WARNING_DRM_AMD_ACP=" CONFIG_DRM_AMD_ACP (Enable ACP IP support) must be set to =y in the kernel or it will fail in the link stage."

	check_extra_config

	CONFIG_CHECK=" ~MFD_CORE"
	WARNING_MFD_CORE=" CONFIG_MFD_CORE must be set to =y or =m in the kernel or it will fail in the link stage."

	check_extra_config

	if ! linux_chkconfig_module "DRM_AMDGPU" ; then
		ewarn "CONFIG_DRM_AMDGPU (Graphics support > AMD GPU) must be compiled as a module (=m)."
	fi

	if [ ! -e "${ROOT}/usr/src/linux-${kv}/Module.symvers" ] ; then
		ewarn "Your kernel sources must have a Module.symvers in the root of the linux sources folder produced from a successful kernel compile beforehand in order to build this driver."
	fi
}

pkg_setup_error() {
	if ! linux_config_exists ; then
		die "You must have a .config file in your linux sources"
	fi

	check_modules_supported

	CONFIG_CHECK=" !TRIM_UNUSED_KSYMS"
	ERROR_TRIM_UNUSED_KSYMS="CONFIG_TRIM_UNUSED_KSYMS should not be set and the kernel recompiled without it."
	check_extra_config

	unset CONFIG_CHECK

	if use check-mmu-notifier ; then
		CONFIG_CHECK+=" HSA_AMD"
		ERROR_CONFIG_HSA_AMD=" CONFIG_HSA_AMD must be set to =y in the kernel .config."
	fi

	check_extra_config

	CONFIG_CHECK=" MMU_NOTIFIER"
	ERROR_MMU_NOTIFIER=" CONFIG_MMU_NOTIFIER must be set to =y in the kernel or it will fail in the link stage."

	check_extra_config

	CONFIG_CHECK=" DRM_AMD_ACP"
	ERROR_DRM_AMD_ACP=" CONFIG_DRM_AMD_ACP (Enable ACP IP support) must be set to =y in the kernel or it will fail in the link stage."

	check_extra_config

	CONFIG_CHECK=" MFD_CORE"
	ERROR_MFD_CORE=" CONFIG_MFD_CORE must be set to =y or =m in the kernel or it will fail in the link stage."

	check_extra_config

	if ! linux_chkconfig_module DRM_AMDGPU ; then
		die "CONFIG_DRM_AMDGPU (Graphics support > AMD GPU) must be compiled as a module (=m)."
	fi

	if [ ! -e "${ROOT}/usr/src/linux-${kv}/Module.symvers" ] ; then
		die "Your kernel sources must have a Module.symvers in the root folder produced from a successful kernel compile beforehand in order to build this driver."
	fi

}

# The sandbox/ebuild doesn't allow to check in setup phase
check_hardware() {
	local is_pci_slots_supported=1
	if use check-pcie ; then
		if ! ( dmidecode -t slot | grep "PCI Express 3" > /dev/null ); then
			ewarn "Your PCIe slots are not supported."
			is_pci_slots_supported=0
		fi
	fi

	# sandbox or emerge won't allow reading FILESDIR in setup phase
	local atomic_f=0
	local atomic_not_required=0
	local device_ids
	if use check-gpu ; then
		device_ids=$(lspci -nn | grep VGA | grep -P -o -e "[0-9a-f]{4}:[0-9a-f]{4}" | cut -f2 -d ":" | tr "[:lower:]" "[:upper:]")
		for device_id in ${device_ids} ; do
			if [[ -z "${device_id}" ]] ; then
				ewarn "Your APU/GPU is not supported for device_id=${device_id}"
				continue
			fi
			# the format is asicname_needspciatomics
			local asics="kaveri_0 carrizo_0 raven_1 hawaii_1 tonga_1 fiji_1 fijivf_0 polaris10_1 polaris10vf_0 polaris11_1 polaris12_1 vegam_1 vega10_0 vega10vf_0 vega12_0 vega20_0 arcturus_0 navi10_0"
			local found_asic=$(grep -i "${device_id}" "${FILESDIR}/kfd_device.c_v$(ver_cut 1-2)" | grep -P -o -e "/\* [ a-zA-Z0-9]+\*/" | sed -e "s|[ /*]||g" | tr "[:upper:]" "[:lower:]")
			x_atomic_f=$(echo "${asics}" | grep -P -o -e "${found_asic}_[01]" | sed -e "s|${found_asic}_||g")
			atomic_f=$(( ${atomic_f} | ${x_atomic_f} ))
			if [[ "${x_atomic_f}" == "1" ]] ; then
				ewarn "Your APU/GPU requires PCIe atomics support for device_id=${device_id}"
			else
				atomic_not_required=1
				einfo "Your APU/GPU is supported for device_id=${device_id}"
			fi
		done
	fi

	if use check-pcie && use check-gpu ; then
		if (( ${#device_ids} == 1 )) && [[ "${atomic_f}" == "1" && "${is_pci_slots_supported}" != "1" ]] ; then
			die "Your APU/GPU and PCIe combo is not supported.  You may disable check-pcie or check-gpu to continue."
		elif (( ${#device_ids} > 1 )) && [[ "${atomic_f}" == "1" && "${is_pci_slots_supported}" != "1" && "${atomic_not_required}" == "0" ]] ; then
			die "You APU/GPU and PCIe combo is not supported for your multiple GPU setup.  You may disable check-pcie or check-gpu to continue."
		elif (( ${#device_ids} > 1 )) && [[ "${atomic_f}" == "1" && "${is_pci_slots_supported}" != "1" && "${atomic_not_required}" == "1" ]] ; then
			ewarn "You APU/GPU and PCIe combo may not supported for some of your GPUs."
		fi
	fi
}

check_kernel() {
	local k="$1"
	local kv=$(echo "${k}" | cut -f1 -d'-')
		if ver_test ${kv} -ge ${KV_NOT_SUPPORTED} ; then
		die "Kernel version ${kv} is not supported."
	fi
	KERNEL_DIR="/usr/src/linux-${k}"
	get_version || die
	if use build || [[ "${EBUILD_PHASE_FUNC}" == "pkg_config" ]]; then
		pkg_setup_error
	else
		pkg_setup_warn
	fi
}

pkg_setup() {
	if [[ -z "${ROCK_DKMS_KERNELS}" ]] ; then
		eerror "You must define a per-package env or add to /etc/portage/make.conf an environmental variable named ROCK_DKMS_KERNELS"
		eerror "containing a space delimited <kernvel_ver>-<extra_version>."
		eerror
		eerror "It should look like ROCK_DKMS_KERNELS=\"5.2.17-pf 5.2.17-gentoo\""
		die
	fi

	for k in ${ROCK_DKMS_KERNELS} ; do
		check_kernel "${k}"
	done
}

src_unpack() {
	unpack_deb ${A}
	rm -rf "${S}/firmware" || die
}

src_prepare() {
	default
	einfo "DC_VER=${DC_VER}"
	einfo "AMDGPU_VERSION=${AMDGPU_VERSION}"
	einfo "ROCK_VER=$(ver_cut 1-2)"
	check_hardware
	chmod 0770 autogen.sh || die
	./autogen.sh || die
	pushd amd/dkms || die
	chmod 0770 autogen.sh || die
	./autogen.sh || die
	popd
}

src_configure() {
	set_arch_to_kernel
}

src_compile() {
	:;
}

src_install() {
	dodir usr/src/${DKMS_PKG_NAME}-${DKMS_PKG_VER}
	insinto usr/src/${DKMS_PKG_NAME}-${DKMS_PKG_VER}
	doins -r "${S}"/*
	fperms 0770 /usr/src/${DKMS_PKG_NAME}-${DKMS_PKG_VER}/{post-install.sh,post-remove.sh,pre-build.sh,config/install-sh,configure,amd/dkms/pre-build.sh,autogen.sh,amd/dkms/autogen.sh}
	insinto /etc/modprobe.d
	doins "${WORKDIR}/etc/modprobe.d/blacklist-radeon.conf"
}

pkg_postinst() {
	dkms add ${DKMS_PKG_NAME}/${DKMS_PKG_VER}
	if use build ; then
		for k in ${ROCK_DKMS_KERNELS} ; do
			einfo "Running: \`dkms build ${DKMS_PKG_NAME}/${DKMS_PKG_VER} -k ${k}/${ARCH}\`"
			dkms build ${DKMS_PKG_NAME}/${DKMS_PKG_VER} -k ${k}/${ARCH} || die
			einfo "Running: \`dkms install ${DKMS_PKG_NAME}/${DKMS_PKG_VER} -k ${k}/${ARCH}\`"
			dkms install ${DKMS_PKG_NAME}/${DKMS_PKG_VER} -k ${k}/${ARCH} || die
			einfo "The modules where installed in /lib/modules/${kernel_ver}-${kernel_extraversion}/updates"
		done
	else
		einfo
		einfo "The ${PN} source code has been installed but not compiled."
		einfo "You may do \`emerge ${PN} --config\` to compile them"
		einfo " or "
		einfo "Run something like \`dkms build ${DKMS_PKG_NAME}/${DKMS_PKG_VER} -k 5.2.17-gentoo/x86_64\`"
		einfo
	fi
	einfo
	einfo "For fully utilizing ROCmRDMA, it is recommend to set iommu off or in passthough mode."
	einfo "Do `dmesg | grep -i iommu` to see if Intel or AMD."
	einfo "If AMD IOMMU, add to kernel parameters either amd_iommu=off or iommu=pt"
	einfo "If Intel IOMMU, add to kernel parameters either intel_iommu=off or iommu=pt"
	einfo "For more information, See https://rocm-documentation.readthedocs.io/en/latest/Remote_Device_Programming/Remote-Device-Programming.html#rocmrdma ."
	einfo
	einfo "Only <${KV_NOT_SUPPORTED} kernels are supported for these kernel modules."
	einfo
}

pkg_prerm() {
	dkms remove ${DKMS_PKG_NAME}/${DKMS_PKG_VER} --all
}

pkg_config() {
	einfo "What is your kernel version? (5.2.17)"
	read kernel_ver
	einfo "What is your kernel extraversion? (gentoo, pf, git, ...)"
	read kernel_extraversion
	check_kernel "${kernel_ver}-${kernel_extraversion}"
	einfo "Running: \`dkms build ${DKMS_PKG_NAME}/${DKMS_PKG_VER} -k ${kernel_ver}-${kernel_extraversion}/${ARCH}\`"
	dkms build ${DKMS_PKG_NAME}/${DKMS_PKG_VER} -k ${kernel_ver}-${kernel_extraversion}/${ARCH} || die "Your module build failed."
	einfo "Running: \`dkms install ${DKMS_PKG_NAME}/${DKMS_PKG_VER} -k ${kernel_ver}-${kernel_extraversion}/${ARCH}\`"
	dkms install ${DKMS_PKG_NAME}/${DKMS_PKG_VER} -k ${kernel_ver}-${kernel_extraversion}/${ARCH} || die "Your module install failed."
	einfo "The modules where installed in /lib/modules/${kernel_ver}-${kernel_extraversion}/updates"
}
