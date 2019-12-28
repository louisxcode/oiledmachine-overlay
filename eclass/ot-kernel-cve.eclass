#1234567890123456789012345678901234567890123456789012345678901234567890123456789
# Copyright 2019 Orson Teodoro
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-cve.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 2 3 4 5 6
# @BLURB: Eclass for CVE patching the kernel
# @DESCRIPTION:
# The ot-kernel-cve eclass resolves CVE vulnerabilities for any linux kernel
# version, preferably latest stable.

# WARNING: The patch tests assume the whole commit or patch is used.  Do not
# try to manually apply a custom patch to attempt to rig the result as pass.

# These are not enabled by default because of licensing, government interest,
# no crypto applied (as in PGP/GPG signed emails) to messages to authenticate
# or verify them.
IUSE+=" cve_hotfix"
LICENSE+=" cve_hotfix? ( GPL-2 )"

DEPEND+=" dev-libs/libpcre"

# _PM = patch message from person who fixed it, _FN = patch file name

inherit ot-kernel-cve-en

# These contants deal with levels of trust with patches.
# Low values imply official fix, higher quality, less buggy.
# High values imply unofficial fix, lower quality, more buggy.
CVE_ALLOW_KERNEL_DOT_ORG_REPO=0x00000001
CVE_ALLOW_GITHUB_TORVALDS=0x00000002
CVE_ALLOW_RESERVED=0x00000004
CVE_ALLOW_MODULE_MAINTAINER=0x00000008 # as in submitted by maintainer

# as in code reviewed by module maintainer
CVE_ALLOW_MODULE_MAINTAINER_REVIEWED=0x00000008

CVE_ALLOW_NVD_IMMEDIATE_LINKED_PATCH=0x00010000 # immediate links only

# Same patch fix author but newer version v2->v3 where v3 is chosen
CVE_ALLOW_NVD_INDIRECT_LINKED_PATCH=0x00020000

CVE_ALLOW_CORPORATE_REVIEWED=0x00040000
CVE_ALLOW_MAJOR_DISTRO_REVIEWED=0x00080000
CVE_ALLOW_MAJOR_DISTRO_TEAM_SUGGESTION=0x04000000

# Used typically for backports which may be sourced from *any* source that seem
# like credible fixes
CVE_ALLOW_EBUILD_MAINTAINER_FILESDIR=0x01000000

# Additional commits not mentioned in NVD CVE report but added by vendor
# of the same type.  NVD DB will report 1 memory leak then not mention several ones
# following applied by driver maintainer.  Associated commits should likely
# be added to CVE/NVD report but are not.
CVE_ALLOW_EBUILD_MAINTAINER_ADDENDUM_CLASS_A=0x01000000

CVE_ALLOW_FOSS_CONTRIBUTOR=0x01000000 # has authored a project and released under a FOSS license
CVE_ALLOW_OPEN_SOURCE_CONTRIBUTOR=0x10000000 # has authored a project but not explicitly under a FOSS license
CVE_ALLOW_PATRON=0x80000000 # non oss contributor but may use product

# todo, you as a user, maybe xml encoded savedconfig.  it is intended to apply
# patches that the ebuild maintainer missed or wants to apply ahead of time.
CVE_ALLOW_ME=0x80000000

CVE_DISALLOW_UNTRUSTED=0x00000000
CVE_DISALLOW_INCOMPLETE=0x00000000

CVE_FIX_TRUST_DEFAULT=$(( \
	${CVE_ALLOW_KERNEL_DOT_ORG_REPO} \
	| ${CVE_ALLOW_GITHUB_TORVALDS} \
	| ${CVE_ALLOW_NVD_IMMEDIATE_LINKED_PATCH} \
	| ${CVE_ALLOW_NVD_INDIRECT_LINKED_PATCH} \
	| ${CVE_ALLOW_CORPORATE_REVIEWED} \
	| ${CVE_ALLOW_MAJOR_DISTRO_REVIEWED} \
	| ${CVE_ALLOW_MAJOR_DISTRO_TEAM_SUGGESTION} \
	| ${CVE_ALLOW_EBUILD_MAINTAINER_FILESDIR} \
	| ${CVE_ALLOW_EBUILD_MAINTAINER_ADDENDUM_CLASS_A} \
	| ${CVE_ALLOW_FOSS_CONTRIBUTOR} ))

CVE_FIX_TRUST_LEVEL=${CVE_FIX_TRUST_LEVEL:=${CVE_FIX_TRUST_DEFAULT}}

# rejects applying cve fixes for all CVEs marked with disputed flag
CVE_FIX_REJECT_DISPUTED=${CVE_FIX_REJECT_DISPUTED:=0}

# only applies to dangerous non trivial backports which might result
# in data loss or data corruption, non functioning driver/device, or
# irreversible damage.
CVE_ALLOW_RISKY_BACKPORTS=${CVE_ALLOW_RISKY_BACKPORTS:=0}

# based on my last edit in unix timestamp (date -u +%Y%m%d_%I%M_%p_%Z)
LATEST_CVE_KERNEL_INDEX="20191212_1126_PM_UTC"
LATEST_CVE_KERNEL_INDEX="${LATEST_CVE_KERNEL_INDEX,,}"

# this will trigger a kernel re-install based on use flag timestamp
# there is no need to set this flag but tricks the emerge system to re-emerge.
if [[ -n "${CVE_SUBSCRIBE_KERNEL_HOTFIXES}" \
	&& "${CVE_SUBSCRIBE_KERNEL_HOTFIXES}" == "1" ]] ; \
then
	IUSE+=" cve_update_${LATEST_CVE_KERNEL_INDEX}"
fi

CVE_DELAY="${CVE_DELAY:=1}"

CVE_LANG="${CVE_LANG:=en}" # You can define this in your make.conf.  Currently en is only supported.

EGIT_COMMIT_TUXPARONI="00478ff7b717cf69bd3b9e42790e86a0f9baae6f"
SRC_URI+=" cve_hotfix? ( https://github.com/orsonteodoro/tuxparoni/archive/${EGIT_COMMIT_TUXPARONI}.tar.gz )"

ot-kernel-cve-src_unpack() {
	unpack "${EGIT_COMMIT_TUXPARONI}.tar.gz"
}
