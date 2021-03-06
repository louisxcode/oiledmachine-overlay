#1234567890123456789012345678901234567890123456789012345678901234567890123456789
# Copyright 2019 Orson Teodoro
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-v4.14.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 2 3 4 5 6
# @BLURB: Eclass for patching the 4.14.x kernel
# @DESCRIPTION:
# The ot-kernel-v4.14 eclass defines specific applicable patching for the
# 4.14.x linux kernel.

# UKSM:
#   https://github.com/dolohow/uksm
# zen-tune:
#   https://github.com/torvalds/linux/compare/v4.20...zen-kernel:4.20/zen-tune
# O3 (Optimize Harder):
#   https://github.com/torvalds/linux/commit/7d0295dc49233d9ddff5d63d5bdc24f1e80da722
#   https://github.com/torvalds/linux/commit/562a14babcd56efc2f51c772cb2327973d8f90ad
# GraySky2 GCC Patches:
#   https://github.com/graysky2/kernel_gcc_patch
# MUQSS CPU Scheduler:
#   http://ck.kolivas.org/patches/4.0/4.14/4.14-ck1/
# genpatches:
#   https://dev.gentoo.org/~mpagano/genpatches/tarballs/
# BFQ updates:
#   https://github.com/torvalds/linux/compare/v4.20...zen-kernel:4.20/bfq-backports
# TRESOR:
#   http://www1.informatik.uni-erlangen.de/tresor

# TRESOR is broken >= 4.17.  It requires additional coding for skcipher with cbc/ecb.

# Compare these commit list and find the ones with convert to skcipher
# interface to hint how to fix.  TRESOR with 4.16.18 works. TRESOR with 4.17
# fails to run cryptsetup benchmark.
# https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/arch/x86/crypto?h=v4.16.18
# https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/arch/x86/crypto?h=v4.17

# tresor passes cipher but not skcipher in self test (/proc/crypto); there is
# a error in dmesg

# [    4.036411] alg: skcipher: setkey failed on test 2 for ecb(tresor-driver): flags=200000
# [    4.038166] alg: skcipher: Failed to load transform for ecb(tresor): -2
# [    4.042266] alg: skcipher: setkey failed on test 3 for cbc(tresor-driver): flags=200000
# [    4.043783] alg: skcipher: Failed to load transform for cbc(tresor): -2

# errors from dmesg in 4.9

# [    3.355692] alg: skcipher: setkey failed on test 2 for ecb(tresor-driver): flags=200000
# [    3.357297] alg: skcipher: Failed to load transform for ecb(tresor): -2
# [    3.361164] alg: skcipher: setkey failed on test 3 for cbc(tresor-driver): flags=200000



# some of these wont appear unless you use them in userspace with crypsetup
# benchmark results for /proc/crypto in 4.9

# name         : cbc(tresor)
# driver       : cbc(tresor-driver)
# module       : kernel
# priority     : 100
# refcnt       : 1
# selftest     : passed
# internal     : no
# type         : blkcipher
# blocksize    : 16
# min keysize  : 16
# max keysize  : 16
# ivsize       : 16
# geniv        : <default>

# name         : tresor
# driver       : tresor-driver
# module       : kernel
# priority     : 100
# refcnt       : 1
# selftest     : passed
# internal     : no
# type         : cipher
# blocksize    : 16
# min keysize  : 16
# max keysize  : 16

# name         : xts(tresor)
# driver       : xts(tresor-driver)
# module       : kernel
# priority     : 100
# refcnt       : 1
# selftest     : passed
# internal     : no
# type         : blkcipher
# blocksize    : 16
# min keysize  : 32
# max keysize  : 32
# ivsize       : 16
# geniv        : <default>

# name         : ecb(tresor)
# driver       : ecb(tresor-driver)
# module       : kernel
# priority     : 100
# refcnt       : 1
# selftest     : passed
# internal     : no
# type         : blkcipher
# blocksize    : 16
# min keysize  : 16
# max keysize  : 16
# ivsize       : 0
# geniv        : <default>

# results from cryptsetup

# Results for 4.9.182
# cryptsetup benchmark -c tresor-ecb -s 128
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
# tresor-ecb        128b        15.1 MiB/s        10.0 MiB/s

# cryptsetup benchmark -c tresor-cbc -s 128
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
# tresor-cbc        128b        14.8 MiB/s        10.0 MiB/s

# cryptsetup benchmark -c aes-cbc -s 128
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
#    aes-cbc        128b        75.3 MiB/s        83.6 MiB/s

# cryptsetup benchmark -c aes-ecb -s 128
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
#    aes-ecb        128b        90.5 MiB/s        90.5 MiB/s


# Results for 4.9.199
# cryptsetup benchmark -c tresor-ecb -s 128
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
# tresor-ecb        128b        26.0 MiB/s        19.0 MiB/s

# cryptsetup benchmark -c tresor-cbc -s 128
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
# tresor-cbc        128b        25.4 MiB/s        18.8 MiB/s

# cryptsetup benchmark -c aes-cbc -s 128
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
#    aes-cbc        128b       130.6 MiB/s       157.8 MiB/s

# cryptsetup benchmark -c aes-ecb -s 128
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
#    aes-ecb        128b       158.5 MiB/s       177.5 MiB/s


ETYPE="sources"

K_MAJOR_MINOR="4.14"
K_PATCH_XV="4.x"
EXTRAVERSION="-ot"
PATCH_UKSM_VER="4.14"
PATCH_UKSM_MVER="4"
PATCH_ZENTUNE_VER="4.19"
PATCH_O3_CO_COMMIT="7d0295dc49233d9ddff5d63d5bdc24f1e80da722" # 4.19 # O3 config option
PATCH_O3_RO_COMMIT="562a14babcd56efc2f51c772cb2327973d8f90ad" # O3 read overflow fix
PATCH_GRAYSKY2_GCC_COMMIT="c53ae690ee282d129fae7e6e10a4c00e5030d588" # zen gcc graysky2
PATCH_PDS_MAJOR_MINOR="4.14"
PATCH_PDS_VER="${PATCH_PDS_VER:=098i}"
PATCH_CK_MAJOR="4.0"
PATCH_CK_MAJOR_MINOR="4.14"
PATCH_CK_REVISION="1"
K_GENPATCHES_VER="${K_GENPATCHES_VER:?135}"
PATCH_GP_MAJOR_MINOR_REVISION="4.14-${K_GENPATCHES_VER}"
PATCH_BFQ_VER="4.19"
PATCH_TRESOR_VER="3.18.5"
DISABLE_DEBUG_V="1.1"
BFQ_BRANCH="bfq"

# Obtained from:  date -d "2017-11-12 10:46:13 -0800" +%s
LINUX_TIMESTAMP=1510512373

IUSE="+cfs disable_debug +graysky2 muqss pds +o3 uksm \
	tresor tresor_aesni tresor_i686 tresor_x86_64 tresor_sysfs"
REQUIRED_USE="^^ ( muqss pds cfs )
	      tresor_sysfs? ( || ( tresor_i686 tresor_x86_64 tresor_aesni ) )
	      tresor? ( ^^ ( tresor_i686 tresor_x86_64 tresor_aesni ) )
	      tresor_i686? ( tresor )
	      tresor_x86_64? ( tresor )
	      tresor_aesni? ( tresor )"

#K_WANT_GENPATCHES="base extras experimental"
K_SECURITY_UNSUPPORTED=${K_SECURITY_UNSUPPORTED:="1"}

inherit kernel-2 toolchain-funcs
detect_version
detect_arch

DEPEND="
	dev-util/patchutils
	<sys-devel/gcc-8.0
	"

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Orson Teodoro's patchset containing UKSM, GraySky's GCC \
Patches, MUQSS CPU Scheduler, PDS CPU Scheduler, Genpatches, TRESOR"

CK_URL_BASE=\
"http://ck.kolivas.org/patches/${PATCH_CK_MAJOR}/${PATCH_CK_MAJOR_MINOR}/${PATCH_CK_MAJOR_MINOR}-ck${PATCH_CK_REVISION}/"
CK_FN="${PATCH_CK_MAJOR_MINOR}-ck${PATCH_CK_REVISION}-broken-out.tar.xz"
CK_SRC_URL="${CK_URL_BASE}${CK_FN}"

inherit ot-kernel-common

SRC_URI+=" ${KERNEL_URI}
	   ${GENPATCHES_URI}
	   ${ARCH_URI}
	   ${UKSM_SRC_URL}
	   ${O3_CO_SRC_URL}
	   ${O3_RO_SRC_URL}
	   ${GRAYSKY_SRC_4_9_URL}
	   ${GRAYSKY_SRC_8_1_URL}
	   ${CK_SRC_URL}
	   ${GENPATCHES_BASE_SRC_URL}
	   ${GENPATCHES_EXPERIMENTAL_SRC_URL}
	   ${GENPATCHES_EXTRAS_SRC_URL}
	   ${TRESOR_AESNI_DL_URL}
	   ${TRESOR_I686_DL_URL}
	   ${TRESOR_SYSFS_DL_URL}
	   ${TRESOR_README_DL_URL}
	   ${TRESOR_SRC_URL}
	   ${KERNEL_PATCH_URLS[@]}
	   ${PDS_SRC_URL}"

# @FUNCTION: ot-kernel-common_pkg_setup_cb
# @DESCRIPTION:
# Does pre-emerge checks and warnings
function ot-kernel-common_pkg_setup_cb() {
	# tresor for x86_64 generic was known to pass crypto testmgr on this
	# version.
	ewarn \
"This ot-sources ${PV} release is only for research purposes or to access \n\
tresor devices.  This 4.14.x series is EOL for this repo but not for\n\
upstream.  It will be removed immediately once tresor has been fixed for\n\
mainline / stable for >=5.x ."

	if has zentune ${IUSE_EFFECTIVE} ; then
		if use zentune ; then
		ewarn \
"The zen-tune patch might cause lock up or slow io under heavy load\n\
like npm.  These use flags are not recommended."
		fi
	fi

	if use muqss ; then
		ewarn \
"muqss might cause lock up or slow io under heavy load\n\
like npm.  These use flags are not recommended."
	fi

	GCC_V=$(gcc-version)
	if ver_test ${GCC_V} -ge 8.0; then
		ewarn \
	"You must switch your gcc to <8.0 to compile this version of ot-sources"
	fi

	if use tresor ; then
		if ver_test ${PV} -ge 4.17 ; then
			ewarn \
	"TRESOR is broken for ${PV}.  Use 4.14.x series.  For ebuild devs only."
		fi
	fi
}

# @FUNCTION: ot-kernel-common_apply_tresor_fixes
# @DESCRIPTION:
# Applies specific TRESOR fixes for this kernel major version
function ot-kernel-common_apply_tresor_fixes() {
	# for 4.20 series and 5.x use tresor-testmgr-ciphers-update.patch instead
	_dpatch "${PATCH_OPS}" \
		"${FILESDIR}/tresor-testmgr-ciphers-update-for-linux-4.14.patch"

	if use tresor_x86_64 ; then
		_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-tresor_asm_64.patch"
		_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-tresor_key_64.patch"
		_dpatch "${PATCH_OPS}" \
		  "${FILESDIR}/tresor-fix-addressing-mode-64-bit-index.patch"
	fi

	#if ! use tresor_sysfs ; then
		_dpatch "${PATCH_OPS}" "${FILESDIR}/wait.patch"
	#fi

	# for 5.x series uncomment below
	#_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-ksys-renamed-funcs-${platform}.patch"

	# for 5.x series and 4.20 use tresor-testmgr-linux-x.y.patch
        _dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-testmgr-linux-4.14.127.patch"

        #_dpatch "${PATCH_OPS}" "${FILESDIR}/tresor-get_ds-to-kernel_ds.patch"
}

# @FUNCTION: ot-kernel-common_pkg_postinst_cb
# @DESCRIPTION:
# Show messages and avoid collision triggering
function ot-kernel-common_pkg_postinst_cb() {
	if use muqss ; then
		ewarn \
"Using MuQSS with Full dynticks system (tickless) CONFIG_NO_HZ_FULL will\n\
  cause a kernel panic on boot.\n\
The MuQSS scheduler may have random system hard pauses for few seconds to\n\
  around a minute when resource usage is high."
	fi

	if use tresor ; then
		einfo \
"It's recommented to disable many early printk driver messsages in the kernel\n\
config to see the tresor prompt on boot, or it will scroll off the screen."
	fi
}
