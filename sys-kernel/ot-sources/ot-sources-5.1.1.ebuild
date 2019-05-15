# Copyright 2019 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

# UKSM:                         https://github.com/dolohow/uksm
# zen-tune:                     https://github.com/torvalds/linux/compare/v5.1...zen-kernel:5.1/zen-tune
# O3 (Optimize Harder):         https://github.com/torvalds/linux/commit/a56a17374772a48a60057447dc4f1b4ec62697fb
#                               https://github.com/torvalds/linux/commit/93d7ee1036fc9ae0f868d59aec6eabd5bdb4a2c9
# GraySky2 GCC Patches:         https://github.com/graysky2/kernel_gcc_patch
# MUQSS CPU Scheduler:          http://ck.kolivas.org/patches/5.0/5.0/5.0-ck1/
# PDS CPU Scheduler:            http://cchalpha.blogspot.com/search/label/PDS
# BMQ CPU Scheduler:		https://cchalpha.blogspot.com/search/label/BMQ
# genpatches:                   https://dev.gentoo.org/~mpagano/genpatches/tarballs/
# BFQ updates:                  https://github.com/torvalds/linux/compare/v5.0...zen-kernel:5.0/bfq-backports
# AMD kernel updates:           https://cgit.freedesktop.org/~agd5f/linux/
# TRESOR:			http://www1.informatik.uni-erlangen.de/tresor

EAPI="6"
ETYPE="sources"
KEYWORDS="~amd64 ~x86"

HOMEPAGE="https://github.com/dolohow/uksm
          https://liquorix.net/
          https://github.com/graysky2/kernel_gcc_dpatch
          http://users.on.net/~ckolivas/kernel/
          https://dev.gentoo.org/~mpagano/genpatches/
          http://algo.ing.unimo.it/people/paolo/disk_sched/
	  http://cchalpha.blogspot.com/search/label/PDS
	  https://cchalpha.blogspot.com/search/label/BMQ
	  http://www1.informatik.uni-erlangen.de/tresor
          "

EXTRAVERSION="-ot"
PATCH_UKSM_VER="5.0"
PATCH_UKSM_MVER="5"
PATCH_ZENTUNE_VER="5.1"
PATCH_O3_CO_COMMIT="a56a17374772a48a60057447dc4f1b4ec62697fb"
PATCH_O3_RO_COMMIT="93d7ee1036fc9ae0f868d59aec6eabd5bdb4a2c9"
PATCH_CK_MAJOR="5.0"
PATCH_CK_MAJOR_MINOR="5.0"
PATCH_CK_REVISION="1"
K_GENPATCHES_VER="15"
PATCH_GP_MAJOR_MINOR_REVISION="5.0-${K_GENPATCHES_VER}"
PATCH_GRAYSKY_COMMIT="87168bfa27b782e1c9435ba28ebe3987ddea8d30"
PATCH_PDS_MAJOR_MINOR="5.0"
PATCH_PDS_VER="099o"
PATCH_BFQ_VER="5.0"
PATCH_TRESOR_VER="3.18.5"
PATCH_BMQ_VER="094"
PATCH_BMQ_MAJOR_MINOR="5.1"
DISABLE_DEBUG_V="1.1"

# KERNEL_COMMIT is not inclusive, but it pulls the next commit afterwards
KERNEL_COMMIT="bf71edb16c6fc40b12b2f748d2b907a85d10ca0a"
# 2019-02-19 Revert "drm/amdgpu: Delete user queue doorbell variables"

# included in 5.1.1:
# DC_VER 3.2.17 in drivers/gpu/drm/amd/display/dc/dc.h 2019-02-06
# KMS_DRIVER 3.30.0 in drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c 2019-02-21
# incomplete roc-2.3.0 up to Feb 15, 2019 of RadeonOpenCompute/ROCK-Kernel-Driver
# amd-staging-drm-next has all the drm/amdkfd from the RadeonOpenCompute/ROCK-Kernel-Driver plus more

# The missing freesync ioctl was not included in 5.1 release.
# 2019-01-25 drm/amdgpu: Bring back support for non-upstream FreeSync
# This was dated around drm/amd/display: 3.2.15.
# It will be manually added back.

# Generally, the base commit selection was based on the oldest relative dating between DC_VER and KSM_DRIVER.

# The decision to select the base commit was...
# before #define DC_VER "3.2.18" in drivers/gpu/drm/amd/display/dc/dc.h
# before #define KMS_DRIVER_MINOR 31 in drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c

# The difference between the amd-xx.xx branch and the amd-staging-drm-next are:
# amd-xx.xx looks feature complete but has slow updates.
# amd-staging-drm-next is missing parts of amd-xx.xx but more bleeding edge but doesn't include hybrid commits from ROCK-Kernel-Driver.
# The kernel will not have all of either amd-staging-drm-next or amd-xx.xx.

AMD_TAG="amd-staging-drm-next"
AMD_COMMIT_LAST_STABLE="f7fa4d8745fce7db056ee9fa040c6e31b50f2389" # amd-19.10 branch latest commit equivalent
# 2019-04-17 drm/amdgpu: amdgpu_device_recover_vram got NULL of shadow->parent

AMD_COMMIT_SNAPSHOT="ca925147df370b66e3db7ae0cb3f90ffd5e16429" # latest commit i tested
# 2019-05-07 drm/radeon: prefer lower reference dividers


# the 19.10 is behind ROCK-Kernel-Driver in AMDGPU_VERSION defined in drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
ROCK_DIR="ROCK-Kernel-Driver"
# we are only interested in commits marked hybrid, some amdkfd
ROCK_BASE="c741e0d93a49ff1d12f4426407031c1c0bdef804" # 2018-08-15 drm/amdgpu: Add kfd2kgd.set_compute_idle interface
# before 2019-01-22 drm/amdkfd: Copy in KFD-related files
ROCK_SNAPSHOT="b639e86df2f3456976ccbc089778245a705ff9ef"
ROCK_MILESTONE="roc-2.4.0"
ROCK_LATEST="master"

IUSE="bfq +bmq bmq-quick-fix +amd amd-staging-drm-next-latest amd-staging-drm-next-snapshot cfs disable_debug +graysky2 muqss +o3 pds rock rock-latest rock-snapshot uksm tresor tresor_aesni tresor_i686 tresor_x86_64 tresor_sysfs -zentune"
#REQUIRED_USE="^^ ( muqss pds cfs bmq ) tresor_sysfs? ( || ( tresor_i686 tresor_x86_64 tresor_aesni ) ) tresor? ( ^^ ( tresor_i686 tresor_x86_64 tresor_aesni ) ) tresor_i686? ( tresor ) tresor_x86_64? ( tresor ) tresor_aesni? ( tresor ) amd-staging-drm-next-latest? ( amd ) amd-staging-drm-next-snapshot? ( amd ) amd-staging-drm-next-snapshot? ( !amd-staging-drm-next-latest ) amd-staging-drm-next-latest? ( !amd-staging-drm-next-snapshot )"
REQUIRED_USE="^^ ( muqss pds cfs bmq ) tresor_sysfs? ( || ( tresor_i686 tresor_x86_64 tresor_aesni ) ) tresor? ( ^^ ( tresor_i686 tresor_x86_64 tresor_aesni ) ) tresor_i686? ( tresor ) tresor_x86_64? ( tresor ) tresor_aesni? ( tresor ) amd-staging-drm-next-latest? ( amd ) amd-staging-drm-next-snapshot? ( amd ) amd-staging-drm-next-snapshot? ( !amd-staging-drm-next-latest ) amd-staging-drm-next-latest? ( !amd-staging-drm-next-snapshot ) rock-latest? ( rock ) rock-snapshot? ( rock ) !rock !rock-latest !rock-snapshot"

# no released patch for 5.1 yet
REQUIRED_USE+=" !muqss !pds !bfq !amd !amd-staging-drm-next-latest !amd-staging-drm-next-snapshot"

#K_WANT_GENPATCHES="base extras experimental"
K_SECURITY_UNSUPPORTED="1"
K_DEBLOB_AVAILABLE="0"

PYTHON_COMPAT=( python2_7 )
inherit python-any-r1 kernel-2 toolchain-funcs versionator
detect_version
detect_arch

#DEPEND="deblob? ( ${PYTHON_DEPS} )"
DEPEND="amd? ( dev-vcs/git )
	dev-util/patchutils
	"

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Orson Teodoro's patchset containing UKSM, zen-tune, GraySky's GCC Patches, MUQSS CPU Scheduler, PDS CPU Scheduler, BMQ CPU Scheduler, Genpatches, BFQ updates, AMD kernel updates, TRESOR"

BMQ_FN="v${PATCH_BMQ_MAJOR_MINOR}_bmq${PATCH_BMQ_VER}.patch"
BMQ_BASE_URL="https://gitlab.com/alfredchen/bmq/raw/master/${PATCH_BMQ_MAJOR_MINOR}/"
BMQ_SRC_URL="${BMQ_BASE_URL}${BMQ_FN}
	     https://gitlab.com/alfredchen/linux-bmq/commit/c98f44724fac5c2b42d831f0ad986008420d13c2.diff
            "

ROCKREPO_URL="https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver.git"
AMDREPO_URL="git://people.freedesktop.org/~agd5f/linux"
AMD_PATCH_FN="${AMD_TAG}.patch"

UKSM_BASE="https://raw.githubusercontent.com/dolohow/uksm/master/v${PATCH_UKSM_MVER}.x/"
UKSM_FN="uksm-${PATCH_UKSM_VER}.patch"
UKSM_SRC_URL="${UKSM_BASE}${UKSM_FN}"

ZENTUNE_URL_BASE="https://github.com/torvalds/linux/compare/v${PATCH_ZENTUNE_VER}...zen-kernel:${PATCH_ZENTUNE_VER}/"
ZENTUNE_REPO="zen-tune"
ZENTUNE_FN="${ZENTUNE_REPO}-${PATCH_ZENTUNE_VER}.diff"
ZENTUNE_DL_URL="${ZENTUNE_URL_BASE}${ZENTUNE_REPO}.diff"
ZENTUNE_SRC_URL="${ZENTUNE_DL_URL} -> ${ZENTUNE_FN}"

O3_SRC_URL="https://github.com/torvalds/linux/commit/"
O3_CO_FN="O3-config-option-${PATCH_O3_CO_COMMIT}.diff"
O3_RO_FN="O3-fix-readoverflow-${PATCH_O3_RO_COMMIT}.diff"
O3_CO_DL_FN="${PATCH_O3_CO_COMMIT}.diff"
O3_RO_DL_FN="${PATCH_O3_RO_COMMIT}.diff"
O3_CO_SRC_URL="${O3_SRC_URL}${O3_CO_DL_FN} -> ${O3_CO_FN}"
O3_RO_SRC_URL="${O3_SRC_URL}${O3_RO_DL_FN} -> ${O3_RO_FN}"

GRAYSKY_DL_4_9_FN="enable_additional_cpu_optimizations_for_gcc_v4.9%2B_kernel_v4.13%2B.patch"
GRAYSKY_DL_8_1_FN="enable_additional_cpu_optimizations_for_gcc_v8.1%2B_kernel_v4.13%2B.patch"
GRAYSKY_URL_BASE="https://raw.githubusercontent.com/graysky2/kernel_gcc_patch/master/"
GRAYSKY_SRC_4_9_URL="${GRAYSKY_URL_BASE}${GRAYSKY_DL_4_9_FN}"
GRAYSKY_SRC_8_1_URL="${GRAYSKY_URL_BASE}${GRAYSKY_DL_8_1_FN}"

CK_URL_BASE="http://ck.kolivas.org/patches/${PATCH_CK_MAJOR}/${PATCH_CK_MAJOR_MINOR}/${PATCH_CK_MAJOR_MINOR}-ck${PATCH_CK_REVISION}/"
CK_FN="${PATCH_CK_MAJOR_MINOR}-ck${PATCH_CK_REVISION}-broken-out.tar.xz"
CK_SRC_URL="${CK_URL_BASE}${CK_FN}"

PDS_URL_BASE="https://gitlab.com/alfredchen/PDS-mq/raw/master/${PATCH_PDS_MAJOR_MINOR}/"
PDS_FN="v${PATCH_PDS_MAJOR_MINOR}_pds${PATCH_PDS_VER}.patch"
PDS_SRC_URL="${PDS_URL_BASE}${PDS_FN}"

GENPATCHES_URL_BASE="https://dev.gentoo.org/~mpagano/genpatches/tarballs/"
GENPATCHES_BASE_FN="genpatches-${PATCH_GP_MAJOR_MINOR_REVISION}.base.tar.xz"
GENPATCHES_EXPERIMENTAL_FN="genpatches-${PATCH_GP_MAJOR_MINOR_REVISION}.experimental.tar.xz"
GENPATCHES_EXTRAS_FN="genpatches-${PATCH_GP_MAJOR_MINOR_REVISION}.extras.tar.xz"
GENPATCHES_BASE_SRC_URL="${GENPATCHES_URL_BASE}${GENPATCHES_BASE_FN}"
GENPATCHES_EXPERIMENTAL_SRC_URL="${GENPATCHES_URL_BASE}${GENPATCHES_EXPERIMENTAL_FN}"
GENPATCHES_EXTRAS_SRC_URL="${GENPATCHES_URL_BASE}${GENPATCHES_EXTRAS_FN}"

BFQ_FN="bfq-${PATCH_BFQ_VER}.diff"
BFQ_REPO="bfq-backports"
BFQ_DL_URL="https://github.com/torvalds/linux/compare/v${PATCH_BFQ_VER}...zen-kernel:${PATCH_BFQ_VER}/${BFQ_REPO}.diff"
BFQ_SRC_URL="${BFQ_DL_URL} -> ${BFQ_FN}"

TRESOR_AESNI_FN="tresor-patch-${PATCH_TRESOR_VER}_aesni"
TRESOR_I686_FN="tresor-patch-${PATCH_TRESOR_VER}_i686"
TRESOR_SYSFS_FN="tresor_sysfs.c"
TRESOR_README_FN="tresor-readme.html"
TRESOR_AESNI_DL_URL="http://www1.informatik.uni-erlangen.de/filepool/projects/tresor/${TRESOR_AESNI_FN}"
TRESOR_I686_DL_URL="http://www1.informatik.uni-erlangen.de/filepool/projects/tresor/${TRESOR_I686_FN}"
TRESOR_SYSFS_DL_URL="http://www1.informatik.uni-erlangen.de/filepool/projects/tresor/${TRESOR_SYSFS_FN}"
TRESOR_README_DL_URL="https://www1.informatik.uni-erlangen.de/tresor?q=content/readme"
TRESOR_SRC_URL="${TRESOR_README_DL_URL} -> ${TRESOR_README_FN}"

gen_kernel_seq()
{
	# 1-2 2-3 3-4
	local s=""
	for ((to=2 ; to <= $1 ; to+=1)) ; do
		s=" $s $((${to}-1))-${to}"
	done
	echo $s
}

#KERNEL_PATCH_TO_FROM=($(gen_kernel_seq $(get_version_component_range 3 ${PV})))
KERNEL_PATCH_TO_FROM=()
KERNEL_INC_BASEURL="https://cdn.kernel.org/pub/linux/kernel/v5.x/incr/"
KERNEL_PATCH_0_TO_1_URL="https://cdn.kernel.org/pub/linux/kernel/v5.x/patch-5.1.1.xz"

KERNEL_PATCH_FNS_EXT=(${KERNEL_PATCH_TO_FROM[@]/%/.xz})
KERNEL_PATCH_FNS_EXT=(${KERNEL_PATCH_FNS_EXT[@]/#/patch-5.0.})
KERNEL_PATCH_FNS_NOEXT=(${KERNEL_PATCH_TO_FROM[@]/#/patch-5.0.})
KERNEL_PATCH_URLS=(${KERNEL_PATCH_0_TO_1_URL} ${KERNEL_PATCH_FNS_EXT[@]/#/${KERNEL_INC_BASEURL}})
KERNEL_PATCH_FNS_EXT=(patch-5.1.1.xz ${KERNEL_PATCH_FNS_EXT[@]/#/patch-5.0.})
KERNEL_PATCH_FNS_NOEXT=(patch-5.1.1 ${KERNEL_PATCH_TO_FROM[@]/#/patch-5.0.})

#	 ${CK_SRC_URL}
#	 ${PDS_SRC_URL}
SRC_URI="
	 ${KERNEL_URI}
	 ${GENPATCHES_URI}
	 ${ARCH_URI}
	 ${O3_CO_SRC_URL}
	 ${O3_RO_SRC_URL}
	 ${GRAYSKY_SRC_4_9_URL}
	 ${GRAYSKY_SRC_8_1_URL}
	 ${BMQ_SRC_URL}
	 ${GENPATCHES_BASE_SRC_URL}
	 ${GENPATCHES_EXPERIMENTAL_SRC_URL}
	 ${GENPATCHES_EXTRAS_SRC_URL}
	 ${TRESOR_AESNI_DL_URL}
	 ${TRESOR_I686_DL_URL}
	 ${TRESOR_SYSFS_DL_URL}
	 ${TRESOR_README_DL_URL}
	 ${TRESOR_SRC_URL}
	 ${UKSM_SRC_URL}
	 ${KERNEL_PATCH_URLS[@]}
	 "

UNIPATCH_LIST=""

UNIPATCH_STRICTORDER="yes"

PATCH_OPS="-p1 -F 100"

pkg_setup() {
	if use zentune || use muqss ; then
		ewarn "The zen-tune patch or muqss might cause lock up or slow io under heavy load like npm.  These use flags are not recommended."
	fi

	#use deblob && python-any-r1_pkg_setup
        kernel-2_pkg_setup
}

function _dpatch() {
	local patchops="$1"
	local path="$2"
	einfo "Applying ${path}"
	patch ${patchops} -i ${path} || die
}

function _tpatch() {
	local patchops="$1"
	local path="$2"
	einfo "Applying ${path}..."
	patch ${patchops} -i ${path} || true
}

function remove_amd_fixes() {
	local d="$1"
}

function apply_uksm() {
	_tpatch "${PATCH_OPS} -N" "${DISTDIR}/${UKSM_FN}"
	# the header patches fine with patch -N
	_dpatch "${PATCH_OPS}" "${FILESDIR}/uksm-5.1-fixes.patch" # for reuse_ksm_page
}

function apply_bfq() {
	_dpatch "${PATCH_OPS} -N" "${T}/${BFQ_FN}"
}

function apply_zentune() {
	_dpatch "${PATCH_OPS} -N" "${T}/${ZENTUNE_FN}"
}

function apply_genpatch_base() {
	einfo "Applying genpatch base"
	ewarn "Some patches have hunk(s) failed but still good or may be fixed ASAP."
	local d
	d="${T}/${GENPATCHES_BASE_FN%.tar.xz}"
	mkdir "$d"
	cd "$d"
	unpack "${DISTDIR}/${GENPATCHES_BASE_FN}"

	sed -r -i -e "s|EXTRAVERSION = ${EXTRAVERSION}|EXTRAVERSION =|" "${S}"/Makefile || die

	# genpatches places kernel incremental patches starting at 1000
	for a in ${KERNEL_PATCH_FNS_NOEXT[@]} ; do
		local f="${T}/${a}"
		cd "${T}"
		unpack "${DISTDIR}/$a.xz"
		cd "${S}"
		patch --dry-run ${PATCH_OPS} -N "${f}" | grep "FAILED at"
		if [[ "$?" == "1" ]] ; then
			# already patched or good
			_tpatch "${PATCH_OPS} -N" "${f}"
		else
			eerror "Failed ${l}"
			die
		fi
	done

	sed -r -i -e "s|EXTRAVERSION =|EXTRAVERSION = ${EXTRAVERSION}|" "${S}"/Makefile || die

	cd "${S}"

	_tpatch "${PATCH_OPS} -N" "$d/1500_XATTR_USER_PREFIX.patch"
	_tpatch "${PATCH_OPS} -N" "$d/1510_fs-enable-link-security-restrictions-by-default.patch"
	_tpatch "${PATCH_OPS} -N" "$d/2500_usb-storage-Disable-UAS-on-JMicron-SATA-enclosure.patch"
	_tpatch "${PATCH_OPS} -N" "$d/2600_enable-key-swapping-for-apple-mac.patch"
}

function apply_genpatch_experimental() {
	einfo "Applying genpatch experimental"

	local d
	d="${T}/${GENPATCHES_EXPERIMENTAL_FN%.tar.xz}"
	mkdir "$d"
	cd "$d"
	unpack "${DISTDIR}/${GENPATCHES_EXPERIMENTAL_FN}"

	cd "${S}"

	# don't need since we apply upstream
}

function apply_genpatch_extras() {
	einfo "Applying genpatch extras"

	local d
	d="${T}/${GENPATCHES_EXTRAS_FN%.tar.xz}"
	mkdir "$d"
	cd "$d"
	unpack "${DISTDIR}/${GENPATCHES_EXTRAS_FN}"

	cd "${S}"

	_tpatch "${PATCH_OPS} -N" "$d/4567_distro-Gentoo-Kconfig.patch"
}

function apply_o3() {
	cd "${S}"

	# fix patch
	sed -r -e "s|-1028,6 +1028,13|-1076,6 +1076,13|" ${DISTDIR}/${O3_CO_FN} > ${T}/${O3_CO_FN} || die

	einfo "Applying O3"
	ewarn "Some patches have hunk(s) failed but still good or may be fixed ASAP."
	einfo "Applying ${O3_CO_FN}"
	_tpatch "${PATCH_OPS}" "${T}/${O3_CO_FN}"
	einfo "Applying fix for ${O3_CO_FN}"
	_dpatch "${PATCH_OPS}" "${FILESDIR}/O3-config-option-a56a17374772a48a60057447dc4f1b4ec62697fb-fix-for-5.1.patch"
	einfo "Applying ${O3_RO_FN}"
	touch drivers/gpu/drm/amd/display/dc/basics/logger.c # trick patch for unattended patching
	_tpatch "-p1 -N" "${DISTDIR}/${O3_RO_FN}"
}

function apply_pds() {
	cd "${S}"
	einfo "Applying pds"
	_dpatch "${PATCH_OPS}" "${DISTDIR}/${PDS_FN}"
}

function apply_bmq() {
	cd "${S}"
	einfo "Applying bmq"
	_dpatch "${PATCH_OPS}" "${DISTDIR}/${BMQ_FN}"
	if use bmq-quick-fix ; then
		# Upstream tends to add quick fixes immediately after releases, so this use flag exists.
		# See https://gitlab.com/alfredchen/bmq/issues/5 .
		# This issue wasn't an issue for me so it is optional.
		_dpatch "${PATCH_OPS}" "${DISTDIR}/c98f44724fac5c2b42d831f0ad986008420d13c2.diff"
	fi
}

function apply_tresor() {
	cd "${S}"
	einfo "Applying tresor"
	ewarn "Some patches have hunk(s) failed but still good or may be fixed ASAP."
	local platform
	if use tresor_aesni ; then
		platform="aesni"
	fi
	if use tresor_i686 || use tresor_x86_64 ; then
		platform="i686"
	fi

	_tpatch "${PATCH_OPS}" "${DISTDIR}/tresor-patch-${PATCH_TRESOR_VER}_${platform}"
	_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-testmgr-ciphers-update.patch"

	if use tresor_x86_64 ; then
		_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-tresor_asm_64.patch"
		_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-tresor_key_64.patch"
		_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-fix-addressing-mode-64-bit-index.patch"
	fi

	#if ! use tresor_sysfs ; then
		_dpatch "${PATCH_OPS}" "${FILESDIR}/wait.patch"
	#fi

	_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-ksys-renamed-funcs-${platform}.patch"
	_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-testmgr-linux-5.1.patch"
}

function fetch_bfq() {
	einfo "Fetching bfq patch from live source..."
	wget -O "${T}/${BFQ_FN}" "${BFQ_DL_URL}" || die
}

function fetch_zentune() {
	einfo "Fetching zentune patch from live source..."
	wget -O "${T}/${ZENTUNE_FN}" "${ZENTUNE_DL_URL}" || die
}

function fetch_amd() {
	einfo "Fetching patch please wait.  It may take hours."
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	cd "${DISTDIR}"
	d="${distdir}/ot-sources-src/linux-${AMD_TAG}"
	b="${distdir}/ot-sources-src"
	addwrite "${b}"
	cd "${b}"
	if [[ ! -d "${d}" ]] ; then
		mkdir -p "${d}"
		einfo "Cloning AMD project"
		git clone -b ${AMD_TAG} ${AMDREPO_URL} "${d}"
	else
		einfo "Updating AMD project"
		cd "${d}"
		git pull
	fi
	cd "${d}"

	local target
	if use amd-staging-drm-next-snapshot ; then
		target="${AMD_COMMIT_SNAPSHOT}"
	elif use amd-staging-drm-next-latest ; then
		target="${AMD_TAG}"
	else
		target="${AMD_COMMIT_LAST_STABLE}"
	fi

	einfo "Saving only the AMD commits for commit-by-commit evaluation."
	L=$(git log ${KERNEL_COMMIT}..${target} --oneline --pretty=format:"%H %s %ce" | grep -e "@amd.com" | grep -v -e "uapi:" -e "drm/v3d" | cut -c 1-40 | tac)
	n="1"
	mkdir "${T}/amd-patches"
	for l in $L ; do
	        echo "Getting patch for $l"
	        git format-patch --stdout -1 $l > "${T}"/amd-patches/$(printf "%05d" $n)-$l.patch
	        n=$((n+1))
	done
	git format-patch --stdout -1 bf96e47b4474f992095d9fae9ccfc46633bf4343 > "${T}/bf96e47b4474f992095d9fae9ccfc46633bf4343.patch" # 2019-01-25 drm/amdgpu: Bring back support for non-upstream FreeSync
}

function fetch_rock() {
	einfo "Fetching patch please wait.  It may take hours."
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	cd "${DISTDIR}"
	d="${distdir}/ot-sources-src/linux-${ROCK_DIR}"
	b="${distdir}/ot-sources-src"
	addwrite "${b}"
	cd "${b}"
	if [[ ! -d "${d}" ]] ; then
		mkdir -p "${d}"
		einfo "Cloning ROCK project"
		git clone ${ROCKREPO_URL} "${d}"
	else
		einfo "Updating ROCK project"
		cd "${d}"
		git checkout master
		git reset --hard
		git pull
	fi
	cd "${d}"

	local target
	if use rock-snapshot ; then
		target="${ROCK_SNAPSHOT}"
	elif use rock-latest ; then
		target="${ROCK_LATEST}"
	else
		target="${ROCK_MILESTONE}"
	fi

	git checkout ${target} . || die

	# I will rewrite this. Actually about 300 patches need to be evalutated from amd-19.10 which is like a snapshot of ROCK-Kernel-Driver and amd-staging-drm-next combined
	# amd-staging-drm-next is more like for compatibility but without the multi gpu
	# ROCK-Kernel-Driver is more the experimental multi gpu kernel

	# Keep only commits marked with summary hybrid.
	# Add RDMA support, IPC, PeerDirect, ...
	# See README.md https://cgit.freedesktop.org/~agd5f/linux/diff/README.md?h=amd-19.10&id=de4ffd426b13b6c623898da2896dd710db861a91
	# See https://github.com/RadeonOpenCompute/ROCm
	einfo "Saving only the AMD ROCK commits for commit-by-commit evaluation."
	L=$(git log ${ROCK_BASE}..${target} --oneline --pretty=format:"%H %s %ce" | grep -e "@amd.com" | \
		grep -e "\[hybrid\]" \
			-e "Hybrid Version" \
			-e "1254b5fe6aaabb58300a5929b6bb290bf1c49f63" \
			-e "1c0e722ee1bf41681a8cc7101b7721e52f503da9" \
			-e "b443022b2d29850a42169e807923308c7d3df925" \
			-e "d732ef0efc3beed8b8c30433aa11d5b6895cb457" \
			-e "509649b8d929b5981e57c6f1b8d50756af56e033" \
			-e "4b8121817eb5ed90109fc753520eed2b5607d869" \
			| cut -c 1-40 | tac)
	# 1254 drm/amdkfd: Copy in KFD-related files
	# 1c0e drm/amdkcl: [KFD] ALL in One KFD KCL Fix for 4.18 rebase
	# b443 drm/amdkfd: Switch to compute profile for RDMA
	# d732 drm/amdkcl: add dkms support
	# 5096 drm/amdttm: [4.5] fix pfn_t.h
	# 4b81 drm/amdgpu: Raise KFD system memory limits to 29/32
	n="1"
	mkdir "${T}/rock-patches"
	for l in $L ; do
	        echo "Getting patch for $l"
	        git format-patch --stdout -1 $l > "${T}"/rock-patches/$(printf "%05d" $n)-$l.patch
	        n=$((n+1))
	done
	git format-patch --stdout -1 bf96e47b4474f992095d9fae9ccfc46633bf4343 > "${T}/bf96e47b4474f992095d9fae9ccfc46633bf4343.patch" # 2019-01-25 drm/amdgpu: Bring back support for non-upstream FreeSync
}

src_unpack() {
	#if use zentune ; then
	#	UNIPATCH_LIST+=" ${DISTDIR}/${ZENTUNE_FN}"
	#fi
	#if use uksm ; then
	#	UNIPATCH_LIST+=" ${DISTDIR}/${UKSM_FN}"
	#fi
	if use muqss ; then
		UNIPATCH_LIST+=" ${DISTDIR}/${CK_FN}"
	fi
	if use graysky2 ; then
		if $(version_is_at_least 8.1 $(gcc-version)) ; then
			einfo "gcc patch is 8.1"
			UNIPATCH_LIST+=" ${DISTDIR}/${GRAYSKY_DL_8_1_FN}"
		else
			einfo "gcc patch is 4.9"
			UNIPATCH_LIST+=" ${DISTDIR}/${GRAYSKY_DL_4_9_FN}"
		fi
	fi
	#if use bfq ; then
	#	UNIPATCH_LIST+=" ${DISTDIR}/${BFQ_FN}"
	#fi

	kernel-2_src_unpack

	cd "${S}"

	if use zentune ; then
		fetch_zentune
		apply_zentune
	fi

	if use uksm ; then
		apply_uksm
	fi

	if use bfq ; then
		fetch_bfq
		apply_bfq
	fi

	if use muqss ; then
		#_dpatch "${PATCH_OPS}" "${FILESDIR}/MuQSS-4.18-missing-se-member.patch"
		_dpatch "${PATCH_OPS}" "${FILESDIR}/muqss-dont-attach-ckversion.patch"
	fi

	if use pds ; then
		apply_pds
	fi

	if use bmq ; then
		apply_bmq
	fi

	apply_genpatch_base
	#apply_genpatch_experimental
	apply_genpatch_extras

	local freesync_back=0

	if use rock ; then
		fetch_rock
		cd "${S}"
		L=$(ls -1 "${T}"/rock-patches)
		for l in $L ; do
			echo $(patch --dry-run -p1 -F 100 -i "${T}/rock-patches/${l}") | grep "FAILED at"
			if [[ "$?" == "1" ]] ; then
				case "${l}" in
					*)
						_tpatch "${PATCH_OPS} --forward" "${T}/rock-patches/${l}"
						# already has been applied or partially patched already or success
						;;
				esac
			else
				case "${l}" in
					*1254b5fe6aaabb58300a5929b6bb290bf1c49f63*|\
					*1c0e722ee1bf41681a8cc7101b7721e52f503da9*)
						# 2
						# 4
						_tpatch "${PATCH_OPS} -N" "${T}/rock-patches/${l}"
						# some parts already patched or not needed
						;;
					*f331d74dad4358369a6dfb182ff0a5607a8e7b04*)
						# 14
						# need freesync ioctls first
						_dpatch "${PATCH_OPS}" "${T}/bf96e47b4474f992095d9fae9ccfc46633bf4343.patch" || die
						freesync_back=1
						_tpatch "${PATCH_OPS} -N" "${T}/rock-patches/${l}"
						;;
					*)
						eerror "Patch failure ${l}.  Did not find the intervention patch."
						die
						;;
				esac
			fi

		done
	fi

	if use amd ; then
		fetch_amd
		cd "${S}"
		if [[ "${freesync_back}" != "1" ]] ; then
			_dpatch "${PATCH_OPS}" "${T}/bf96e47b4474f992095d9fae9ccfc46633bf4343.patch" || die
		fi
		L=$(ls -1 "${T}"/amd-patches)
		for l in $L ; do
			echo $(patch --dry-run -p1 -F 100 -i "${T}/amd-patches/${l}") | grep "FAILED at"
			if [[ "$?" == "1" ]] ; then
				case "${l}" in
					*)
						_tpatch "${PATCH_OPS} -N" "${T}/amd-patches/${l}"
						# already has been applied or partially patched already or success
						;;
				esac
			else
				case "${l}" in
					#*1c033d9f9bcb7019fb8d2c57e57c4c0c09188c4b*) # 3 in linux 5.1
					#	if use rock ; then
					#		# skip patch.  ROCK-Kernel-Driver reverts it
					#		true
					#	else
					#		_tpatch "${PATCH_OPS} -N" "${T}/amd-patches/${l}"
					#	fi
					#	;;
					*7bd1d22945d8927c882b7dcbca5cc503d0d7f007*) # 21
						_tpatch "${PATCH_OPS} -N" "${T}/amd-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-7bd1d22945d8927c882b7dcbca5cc503d0d7f007-fix-for-linux-5.1.patch"
						;;
					*4bcbb9e3ec0467e36f1f4b8f9b6eca2b6501a6b8*) # 25
						_tpatch "${PATCH_OPS} -N" "${T}/amd-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-4bcbb9e3ec0467e36f1f4b8f9b6eca2b6501a6b8-fix-for-linux-5.1.patch"
						;;
					*d4731305a287b4aa890dff42e819b494443eef09*) # 42
						# already added upstream in 5.1 kernel
						;;
					#*9032ea09e2d2ef0d10e5cd793713bf2eb21643c5*) # 286
					#	if use rock ; then
					#		_tpatch "${PATCH_OPS} -N" "${T}/amd-patches/${l}"
					#		_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-9032ea09e2d2ef0d10e5cd793713bf2eb21643c5-fix-rock.patch"
					#	else
					#		_tpatch "${PATCH_OPS} -N" "${T}/amd-patches/${l}"
					#	fi
					#	;;
					*c6fcd3a65b9873e250aba0f5ab40838633145b10*) # 452
						_tpatch "${PATCH_OPS} -N" "${T}/amd-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-c6fcd3a65b9873e250aba0f5ab40838633145b10-fix-for-linux-5.1.patch"
						;;
					*3cdc2f9ca0cd9d3d0143bfce07d7ceacf0a86a58*) # 605
						_tpatch "${PATCH_OPS} -N" "${T}/amd-patches/${l}"
						_dpatch "${PATCH_OPS}" "${FILESDIR}/amd-staging-drm-next-3cdc2f9ca0cd9d3d0143bfce07d7ceacf0a86a58-fix-for-linux-5.1.patch"
						;;
					#*288b883a67126a7c251fb1222e1b9d7a6485d46c*) # 620
					#	if use rock ; then
					#		# not needed eventually both in ROCK-Kernel-Driver and amd-staging-drm-next heads
					#		true
					#	else
					#		_tpatch "${PATCH_OPS} -N" "${T}/amd-patches/${l}"
					#	fi
					#	;;
					#*86e62fe3d7b7edb949b44200607a12645da494f7*|\
					#*7fb91961f073edb64bc9ac1dfa55916931fa4e3d*)
					#	# 621
					#	# 626
					#	if use rock ; then
					#		# already applied
					#		true
					#	else
					#		_tpatch "${PATCH_OPS} -N" "${T}/amd-patches/${l}"
					#	fi
					#	;;
					*)
						eerror "Patch failure ${l}.  Did not find the intervention patch."
						die
						;;
				esac
			fi

		done
	fi

	if use o3 ; then
		apply_o3
	fi

	if use tresor ; then
		apply_tresor
	fi

	#_dpatch "${PATCH_OPS}" "${FILESDIR}/linux-4.20-kconfig-ioscheds.patch"
}

src_compile() {
	kernel-2_src_compile
	if use tresor_sysfs ; then
		cp -a "${DISTDIR}/tresor_sysfs.c" "${T}"
		cd "${T}"
		einfo "$(tc-getCC) ${CFLAGS}"
		$(tc-getCC) ${CFLAGS} tresor_sysfs.c -o tresor_sysfs || die
	fi
}

src_install() {
	# cleanup patch cruft
	find "${S}" -name "*.orig" -print0 -o -name "*.rej" -print0 | xargs -0 rm

	kernel-2_src_install
	if use disable_debug ; then
		cp "${FILESDIR}/_disable_debug_v${DISABLE_DEBUG_V}" "${T}/_disable_debug" || die
		cp "${FILESDIR}/disable_debug_v${DISABLE_DEBUG_V}" "${T}/disable_debug" || die
	fi
}

pkg_postinst() {
	kernel-2_pkg_postinst
	if use disable_debug ; then
		einfo "The disable debug scripts have been placed in your /usr/src folder."
		einfo "They disable debug paths, logging, output for a performance gain."
		einfo "You should run it like \`/usr/src/disable_debug x86_64 /usr/src/.config\`"
		cp "${FILESDIR}/_disable_debug_v${DISABLE_DEBUG_V}" "${EROOT}/usr/src/_disable_debug" || die
		cp "${FILESDIR}/disable_debug_v${DISABLE_DEBUG_V}" "${EROOT}/usr/src/disable_debug" || die
		chmod 700 "${EROOT}"/usr/src/_disable_debug || die
		chmod 700 "${EROOT}"/usr/src/disable_debug || die
	fi

	if use tresor_sysfs ; then
		# prevent merge conflicts
		cd "${T}"
		chmod 700 "${EROOT}"/usr/bin/tresor_sysfs || die
		mv tresor_sysfs "${EROOT}/usr/bin" || die
		# same hash for 5.1 and 5.0.13 for tresor_sysfs
		einfo "/usr/bin/tresor_sysfs is provided to set your TRESOR key"
	fi

	if use muqss ; then
		ewarn "Using MuQSS with Full dynticks system (tickless) CONFIG_NO_HZ_FULL will cause a kernel panic on boot."
		ewarn "The MuQSS scheduler may have random system hard pauses for few seconds to around a minute when resource usage is high."
	fi
}
