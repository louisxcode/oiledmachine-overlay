#1234567890123456789012345678901234567890123456789012345678901234567890123456789
# Copyright 2019 Orson Teodoro
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ot-kernel-asdn.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 2 3 4 5 6
# @BLURB: Eclass for patching the kernel with the amd-staging-drm-next
# @DESCRIPTION:
# The ot-kernel-asdm eclass defines functions to merge amd-staging-drm-next
# into vanilla

# amd-staging-drm-next:
#   https://cgit.freedesktop.org/~agd5f/linux/log/?h=amd-staging-drm-next

HOMEPAGE+=\
" https://cgit.freedesktop.org/~agd5f/linux/log/?h=amd-staging-drm-next"

# @FUNCTION: amd_staging_drm_next_setup
# @DESCRIPTION:
# Does pre-emerge checks
function amd_staging_drm_next_setup() {
	if use amd-staging-drm-next ; then
		if [[ -z "${AMD_STAGING_DRM_NEXT_BUMP_REQUEST}" ]] ; then
			local m=\
"You must define a AMD_STAGING_DRM_NEXT_BUMP_REQUEST environmental variable\n\
in your make.conf or per-package env containing either: head, \n\
dc_ver, amdgpu_version"
			if [[ "${K_MAJOR_MINOR}" == "5.3" \
				|| "${K_MAJOR_MINOR}" == "5.4" ]] ; then
				m+=", snapshot"
			fi
			if ver_test ${K_MAJOR_MINOR} -ge 5.0 \
				&& ver_test ${K_MAJOR_MINOR} -le 5.3 ; then
				m+=", amdgpu_19_30"
			elif ver_test ${K_MAJOR_MINOR} -ge 4.18 \
				&& ver_test ${K_MAJOR_MINOR} -lt 5.0 ; then
				m+=", amdgpu_19_10"
			elif ver_test ${K_MAJOR_MINOR} -ge 4.15 \
				&& ver_test ${K_MAJOR_MINOR} -lt 4.18 ; then
				m+=", amdgpu_18_40"
			else
				ewarn \
	     "Your kernel version may not be supported by amd-staging-drm-next."
			fi
			die "${m}"
		fi
#1234567890123456789012345678901234567890123456789012345678901234567890123456789
		case ${AMD_STAGING_DRM_NEXT_BUMP_REQUEST} in
			head|snapshot|dc_ver|amdgpu_version|amdgpu_19_30|\
			amdgpu_19_10|amdgpu_18_40)
				;;
			*)
				die \
			       "Invalid AMD_STAGING_DRM_NEXT_BUMP_REQUEST value"
				;;
		esac
		cd_asdn
		git config diff.renamelimit 1704 # recommended by output
		chown portage:portage .git/config || die
	fi
}

#1234567890123456789012345678901234567890123456789012345678901234567890123456789
# @FUNCTION: fetch_amd_staging_drm_next
# @DESCRIPTION:
# Generalization of steps for fetching and generating commit list.
function fetch_amd_staging_drm_next() {
	if use amd-staging-drm-next ; then
		local suffix_asdn=$(ot-kernel-common_amdgpu_get_suffix_asdn)
		if ! amd_staging_drm_next_is_cache_usable ; then
			# ebuild maintainer only
			einfo \
"Dump amd-staging-drm-next .patch files to \
${ASDN_LOCAL_CACHE}"
			fetch_amd_staging_drm_next_local_copy
		fi
	fi
}

# @FUNCTION: fetch_amd_staging_drm_next_local_copy
# @DESCRIPTION:
# Clones or updates the amd-staging-drm-next patchset for recent fixes or GPU
# compatibility updates.
function fetch_amd_staging_drm_next_local_copy() {
	einfo "Fetching the amd-staging-drm-next project please wait."
	einfo "It may take hours."
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	cd "${DISTDIR}" || die
	d="${distdir}/ot-sources-src/linux-${AMD_STAGING_DRM_NEXT_DIR}"
	b="${distdir}/ot-sources-src"
	addwrite "${b}"
	cd "${b}" || die
	if [[ ! -d "${d}" ]] ; then
		mkdir -p "${d}" || die
		einfo "Cloning the amd-staging-drm-next project"
		git clone "${AMDREPO_URL}" "${d}"
		cd "${d}" || die
		git checkout master
		git checkout -b amd-staging-drm-next \
			remotes/origin/amd-staging-drm-next
	else
		local G=$(find "${d}" -group "root")
		if (( ${#G} > 0 )) ; then
			die \
"You must manually: \`chown -R portage:portage ${d}\`.  Re-emerge again."
		fi
		einfo "Updating the amd-staging-drm-next project"
		cd "${d}" || die
		git clean -fdx
		git reset --hard master
		git reset --hard origin/master
		git checkout master
		git pull
		git branch -D amd-staging-drm-next
		git checkout -b amd-staging-drm-next \
			remotes/origin/amd-staging-drm-next
		git pull
	fi
	cd "${d}" || die
}

# @FUNCTION: asdn_rm_list
# @DESCRIPTION:
# Removes a list of commits
function asdn_rm_list() {
	# hundreds of files so limit to just cores if we are forking
	local n_processed=0
	local N_C=$(echo -e ${1} | tr " " "\n" | uniq | wc -l)
	for c in ${1} ; do
		sed -i -e "s|.*${c}.*||g" "${BPS}/ot-sources/aliases/asdn_filenames" || die
		n_processed=$((${n_processed}+1))
		progress_bar_ex ${n_processed} ${N_C}
	done
	echo ""
}

# @FUNCTION: amd_staging_drm_next_set_target
# @DESCRIPTION:
# Obtains the commit hash based on AMD_STAGING_DRM_NEXT_BUMP_REQUEST.
function amd_staging_drm_next_set_target() {
	local target
	if [[ "${AMD_STAGING_DRM_NEXT_BUMP_REQUEST}" =~ amdgpu_version ]] ; then
		target="${AMD_STAGING_DRM_NEXT_AMDGPU_VERSION_C}"
	elif [[ "${AMD_STAGING_DRM_NEXT_BUMP_REQUEST}" =~ dc_ver ]] ; then
		target="${AMD_STAGING_DRM_NEXT_DC_VER_C}"
	elif [[ "${AMD_STAGING_DRM_NEXT_BUMP_REQUEST}" =~ head ]] ; then
		target="${AMD_STAGING_DRM_NEXT_HEAD_C}"
	elif [[ "${AMD_STAGING_DRM_NEXT_BUMP_REQUEST}" =~ snapshot ]] ; then
		if [[ "${K_MAJOR_MINOR}" == "5.3" \
			|| "${K_MAJOR_MINOR}" == "5.4" ]] ; then
			target="${AMD_STAGING_DRM_NEXT_SNAPSHOT_C}"
		else
			die \
"snapshot is not supported for AMD_STAGING_DRM_NEXT_BUMP_REQUEST your kernel \
version."
		fi
	elif [[ "${AMD_STAGING_DRM_NEXT_BUMP_REQUEST}" =~ amdgpu_19_30 ]] ; then
		target="${AMD_STAGING_DRM_NEXT_AMDGPU_19_30_C}"
	elif [[ "${AMD_STAGING_DRM_NEXT_BUMP_REQUEST}" =~ amdgpu_19_10 ]] ; then
		target="${AMD_STAGING_DRM_NEXT_AMDGPU_19_10_C}"
	elif [[ "${AMD_STAGING_DRM_NEXT_BUMP_REQUEST}" =~ amdgpu_18_40 ]] ; then
		target="${AMD_STAGING_DRM_NEXT_AMDGPU_18_40_C}"
	fi
	echo "${target}"
}

# @FUNCTION: amd_staging_drm_next_use_and_alias_commits
# @DESCRIPTION:
# This will generate or reuse pre-generate patch files from commit hash
function amd_staging_drm_next_use_and_alias_commits() {
	local src_dir=""
	if amd_staging_drm_next_is_cache_usable ; then
		einfo "Using cached copy in ${ASDN_LOCAL_CACHE}"
		# we don't distribute this because it is 1G+
		src_dir="${ASDN_LOCAL_CACHE}"
	else
		amd_staging_drm_next_save_all_commits
		amd_staging_drm_next_prepend_licenses_in_patches
		if [[ -n "${OT_KERNEL_MAINTAINER}" \
			&& "${OT_KERNEL_MAINTAINER}" == "1" ]] ; then
			einfo \
"ASDN patches can be found at ${ASDN_T_CACHE}\n\
They should be placed in ${ASDN_LOCAL_CACHE} ."
		fi
		src_dir="${ASDN_T_CACHE}"
	fi

	# split per core, process, merge

	trap cleanup_shared EXIT

	mkdir -p "${BPS}/ot-sources/aliases"
	ls "${src_dir}" > "${T}/asdn_patches"
	local N_C=$(wc -l "${T}/asdn_patches" | cut -f 1 -d $' ')
	local sublist_size=$(awk "BEGIN{ printf(\"%1.0f\n\",${N_C}/${N_CPU_CORES}+1.00000001); }")
	split -d -l ${sublist_size} "${T}/asdn_patches" \
		"${BPS}/ot-sources/aliases/asdn_patches_" || die

	gen_filename_on_core() {
		local i="${1}"
		local padded_i=$(printf "%02d" ${i})
		local data=$(cat "${BPS}/ot-sources/aliases/asdn_patches_${padded_i}")
		local data2=""
		for f in ${data} ; do
			message_progress "."
			[[ -z "${f}" ]] && continue
			local c=$(echo "${f}" | cut -f 1 -d ".")
			local DC_VER="${asdn_dc_ver[${c}]}"
			local ct=${asdn_commit_time[${c}]}
			local pn=${asdn_pn[${c}]}
			data2+="${DC_VER}-${ct}-${pn}-${c}-asdn.patch\n"
		done
		echo -e "${data2}" > "${BPS}/ot-sources/aliases/asdn_filenames_${padded_i}" || die
	}

	echo ""
	P=()

	report_progress "${N_C}" &
	local Pr=$!

	for i in $(seq 0 $((${N_CPU_CORES}-1))) ; do
		gen_filename_on_core "${i}" &
		P+=($!)
	done

	wait ${P[@]}
	message_progress "D"
	wait ${Pr}
	echo ""

	echo ""
}

# @FUNCTION: cd_asdn
# @DESCRIPTION:
# Change directory to ASDN's local repo.
cd_asdn() {
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	local d="${distdir}/ot-sources-src/linux-${AMD_STAGING_DRM_NEXT_DIR}"
	cd "${d}" || die
}

# @FUNCTION: amd_staging_drm_next_save_all_commits
# @DESCRIPTION:
# Saves all amd-staging-drm-next commits as patch files
function amd_staging_drm_next_save_all_commits() {
	einfo "Saving all amd-staging-drm-next commits as patches from scratch"
	cd_asdn

	asdn_save_single_commit() {
		local n="${1}"
		local c="${2}"
		local fn="${c}.patch"
		if git -P diff $c^..$c \
			> "${ASDN_T_CACHE}"/${fn} ; then
		        #einfo "Added ${fn}"
			# attach missing commit subject for possible patch tarball
			git -P show -s --pretty=email ${c} \
			  > "${ASDN_T_CACHE}/${fn}.t" || die
			cat "${ASDN_T_CACHE}/${fn}" \
			  >> "${ASDN_T_CACHE}/${fn}.t" || die
			mv "${ASDN_T_CACHE}"/${fn}{.t,} \
			  || die
		fi
		rm -rf "${BPS}/ot-sources/locks/sem${n}"
	}

	rm -rf "${BPS}/ot-sources/locks" 2>/dev/null
	mkdir -p "${BPS}/ot-sources/locks"
	trap cleanup_shared EXIT

	readarray -t A <<< "${C}"
	local N_A="${#A[@]}"

	echo ""
	local n_processed=0
	etf_init ${N_A} 42 1
	while (( ${n_processed} < ${N_A} )) ; do
		for n in $(seq 0 $((${N_CPU_CORES}-1))) ; do
			if (( ${n_processed} >= ${N_A} )) ; then
				break
			fi
			if mkdir "${BPS}/ot-sources/locks/sem${n}" 2>/dev/null ; then
				asdn_save_single_commit "${n}" "${A[${n_processed}]}" &
				n_processed=$((${n_processed}+1))
				progress_bar_ex ${n_processed} ${N_A}
			fi
		done
	done

	local remaining=1
	while (( ${remaining} > 0 )) ; do
		remaining=0
		for n in $(seq 0 $((${N_CPU_CORES}-1))) ; do
			if [[ -d "${BPS}/ot-sources/locks/sem${n}" ]] ; then
				remaining=$((remaining+1))
			fi
		done
	done
	echo ""

	for c in $C ; do
		if [[ -f "${ASDN_T_CACHE}"/*${c}* ]] ; then
			echo -e "\e[42m\e[30m Accepted \e[0m ${c}"
		else
			die "Failed to add ${c}.patch"
		fi
	done
}

# @FUNCTION: amd_staging_drm_next_prepend_licenses_in_patches
# @DESCRIPTION:
# Adds licenses to top of patches.
amd_staging_drm_next_prepend_licenses_in_patches() {
	if [[ -n "${USE_PATACHIE}" && "${USE_PATACHIE}" == "1" ]] ; then
		einfo "Attaching licenses to amd-staging-drm-next patches"
		"${HOME}/patachie" -p "${ASDN_T_CACHE}" \
			-s "${S}" \
			-of "${T}/asdn-licenses" \
			-od "${T}/asdn-processed"
		mv "$(pwd)/attachied" "$(pwd)/asdn-attachied" || die
		einfo \
"Maintainer:  $(pwd)/asdn-processed contains patches with attached licenses\n\
and ${T}/asdn-licenses contains all the licenses in one file."
	fi
}

# @FUNCTION: __remove_asdn_patch
# @DESCRIPTION:
# (PRIVATE) Removes an amd-staging-drm-next .patch file
function __remove_asdn_patch() {
	message_progress "R ${c}"
	data2=$(echo -e "${data2}" | sed -r -e "s|.*${c}.*||g")
}

function __accept_asdn_patch() {
	message_progress "A ${c}"
}

# @FUNCTION: amd_staging_drm_next_filter_by_git_commit_metadata
# @DESCRIPTION:
# Removes commits before merging
function amd_staging_drm_next_filter_by_git_commit_metadata() {
	cd_asdn

	asdn_commit_metadata_filter() {
		local i="${1}"
		local padded_i=$(printf "%02d" ${i})
		local finished=0
		local data=$(cat "${BPS}/ot-sources/aliases/asdn_filenames_${padded_i}")
		local data2=$(cat "${BPS}/ot-sources/aliases/asdn_filenames_${padded_i}")
		for f in ${data} ; do
			[[ -z "${f}" ]] && continue
			local c=$(echo "${f}" | cut -f 4 -d "-")

			#einfo "Processing ${c}"

			if [[ -n "${vk_commits[${c}]}" ]] ; then
				#einfo \
#"Skipping old commit ${c} :  Already added via vanilla kernel sources."
				__remove_asdn_patch
				continue
			fi

			local s="${asdn_summary_raw[${c}]}"
			local h_summary="${asdn_summary_hash[${c}]}"

			if [[ \
			( "${K_MAJOR_MINOR}" == "5.3" && \
			 ( "${c}" =~ 0dbd555a011c2d096a7b7e40c83c5776a7df367c || \
			"${c}" =~ 1e053b10ba60eae6a3f9de64cbc74bdf6cb0e715 || \
			"${c}" =~ e532a135d7044b5477c1c56169fa131d77c57f75 || \
			"${c}" =~ 52791eeec1d9f4a7e7fe08aaba0b1553149d93bc || \
			"${c}" =~ bd630a86be381992fac99f9ab82c5c5b43a5ee3b || \
			"${c}" =~ 67c97fb79a7f8621d4514275691d75f5ff158c46 || \
			"${c}" =~ 4c2488cfaa997e396aeb9d6496db94c25b97c671 || \
			"${c}" =~ dd7a7d1ff2f199a8a80ee233480922d4f17adc6d || \
			"${c}" =~ 31070a871fdcb16dd209e6bc0e6ca16be7cfb938 || \
			"${c}" =~ 96e95496b02dbf1b19a2d4ce238810572e149606 || \
			"${c}" =~ 94eb1e10a34d3c7fc42208faaa4954fe482ac091 || \
			"${c}" =~ 8735f16803f00f5efca7738afe3b9a304b539181 || \
			"${c}" =~ 5d344f58da760b226562e7d5199fb73294eb93fa || \
			"${c}" =~ 93505ee7d05e836fd18894019e93c3875198fcc5 || \
			"${c}" =~ 0e1d8083bddb38b7169f6240905422f95d3c31b9 || \
			"${c}" =~ 4f5368b5541a902f6596558b05f5c21a9770dd32 || \
			"${c}" =~ b016cd6ed4b772759804e0d6082bd1f5ca63b8ee || \
			"${c}" =~ 51c98747113e93b6229f12d1a744a51fd59eff3a || \
			"${c}" =~ 8eb8833e7ed362977c021116d2f34451a7009ca3 || \
			"${c}" =~ 100163df420305b78153e6f5ec10c90d755acee3 || \
			"${c}" =~ e1a29c6c59553d80a8e17d63494c65a13fb8e241 || \
			"${c}" =~ d8f4981e2e8a968411105db568f3d48256b2ebbc || \
			"${c}" =~ 274840e544225657fbca4f12efa1ee55474bb800 || \
			"${c}" =~ c01b6a1d38675652199d12b898c1c23b96b5055f || \
			"${c}" =~ 354e6e14ef947f07055d3570b4bd7a33196b57f6 || \
			"${c}" =~ 562836a269e363cdb74b551e3be7021c9d228378 || \
			"${c}" =~ e7f0141a217fa28049d7a3bbc09bee9642c47687 || \
			"${c}" =~ 2e3c9ec4d151c04d75546dfdc2f85a84ad546eb0 || \
			"${c}" =~ c74dbe44eacf00a5ccc229b5cc340a9b7f6851a0 || \
			"${c}" =~ 2a1e00c3c0d37f65241236d7731ef6bb92f0d07f || \
			"${c}" =~ 97797a93ffb905304df11dc42e1daab9aa7faa9b ) ) || \
			( "${K_MAJOR_MINOR}" == "5.4" && \
			 ( "${c}" =~ 9d6f4484e81c0005f019c8e9b43629ead0d0d355 || \
			   "${c}" =~ 64f55e629237e4752db18df4d6969a69e3f4835a || \
	                   "${c}" =~ 38750f03030a40976524295b8a8facfda2a5f393 ) ) ]]
			then
				# 97797a9 2019-08-30 drm/amdgpu: Add RAS EEPROM table.
				#  is DC_VER 3.2.48 in amd-staging-drm-next repo
				# 64f55e6 2019-08-27 drm/amdgpu: Add RAS EEPROM table.
				#  is DC_VER 3.2.48 in amd-staging-drm-next repo

				# whitelist specific commits which includes \
				# 5.4-rc* commits
				__accept_asdn_patch
				continue
			elif echo "${s}" | grep -q -P \
-e "(drm/amd|amdgpu|amd/powerplay|amdkfd|gpu: amdgpu:|amdgpu_dm)" ; then
				# whitelist all amd drm driver updates for
				# evaluation
				:; # still filter it though
			elif echo "${s}" | grep -q -P \
-e "(bo->resv to bo->base.resv|use embedded gem object|Fill out gem_object->resv)" ; then
				# whitelist by subject keywords
				__accept_asdn_patch
				continue
			else
				# don't filter ASDN by timestamp because upstream may
				# not accept all commits
				local ct="${asdn_commit_time[${c}]}"
				if (( ${ct} <= ${LINUX_TIMESTAMP} )) ; then
					#einfo "Skipping old commit ${c} :  Old timestamp"
					__remove_asdn_patch
					continue
				fi
			fi

			if [[ -n "${vk_summaries[${h_summary}]}" ]] ; then
				#einfo \
#"Already added ${c} via vanilla kernel sources (with same subject match). \
#Skipping..."
				__remove_asdn_patch
				continue
			fi

			# deferred to the end to check whitelist
			if [[ "${finished}" == "1" ]] ; then
				#einfo \
#"Deleting the rest of commits."
				__remove_asdn_patch
				continue
			elif [[ "${c}" == "${target}" ]] ; then
				finished=1
			fi
			#echo -e "\e[42m\e[30m Accepted \e[0m ${c}"

			__accept_asdn_patch
		done
		echo -e "${data2}" > "${BPS}/ot-sources/aliases/asdn_filenames_${padded_i}" || die
	}

	# split per core, process, merge

	trap cleanup_shared EXIT

	echo ""
	local data=""
	for i in $(seq 0 $((${N_CPU_CORES}-1))) ; do
		local padded_i=$(printf "%02d" ${i})
		data+=$(cat "${BPS}/ot-sources/aliases/asdn_filenames_${padded_i}")
	done
	local total=$(echo -e "${data}" | wc -l)

	P=()

#	if [[ -n "${OT_KERNEL_MAINTAINER}" && "${OT_KERNEL_MAINTAINER}" == "1" ]] ; then
#		report_progress_by_git_commit_metadata &
#	else
		report_progress "${total}" &
#	fi
	local Pr=$!

	for i in $(seq 0 $((${N_CPU_CORES}-1))) ; do
		asdn_commit_metadata_filter "${i}" &
		P+=($!)
	done

	wait ${P[@]}
	message_progress "D"
	wait ${Pr}
	echo ""

	cat /dev/null > "${BPS}/ot-sources/aliases/asdn_filenames"
	for i in $(seq 0 $((${N_CPU_CORES}-1))) ; do
		local padded_i=$(printf "%02d" ${i})
		cat "${BPS}/ot-sources/aliases/asdn_filenames_${padded_i}" \
			>> "${BPS}/ot-sources/aliases/asdn_filenames" || die
	done

	echo ""
}

# @FUNCTION: generate_amd_staging_drm_next_commit_list
# @DESCRIPTION:
# Fills a variable named C with list of commits
#
# The commit list, C, is used by:
# amd_staging_drm_next_filter_by_git_commit_metadata
# amd_staging_drm_next_generate_database
# amd_staging_drm_next_save_all_commits
function generate_amd_staging_drm_next_commit_list() {
	cd_asdn
	einfo \
"Saving only the amd-staging-drm-next commits for commit-by-commit evaluation.\n\
Doing commit -> .patch conversion for amd-staging-drm-next-patches set"
	C=$(git -P log ${base}..${target} --oneline \
		--pretty=format:"%H" -- \
		drivers/gpu/drm include/drm drivers/dma-buf \
		include/linux include/uapi/drm \
		| echo -e "\n$(cat -)" | tac)
	pickle_string "C" "${T}/asdn_commit_list.${K_MAJOR_MINOR}${suffix_asdn}"
}

# @FUNCTION: amd_staging_drm_next_use_commit_list
# @DESCRIPTION:
# Generates or uses a amd-staging-drm-next commit list
function amd_staging_drm_next_use_commit_list() {
	if has_amd_staging_drm_next_database ; then
		local suffix_asdn=$(ot-kernel-common_amdgpu_get_suffix_asdn)
		einfo "Using the amd-staging-drm-next commit list"
		source "${FILESDIR}/asdn_commit_list.${K_MAJOR_MINOR}${suffix_asdn}"
	else
		einfo "Generating amd-staging-drm-next commit list"
		generate_amd_staging_drm_next_commit_list
	fi
}

# @FUNCTION: amd_staging_drm_next_generate_database
# @DESCRIPTION:
# Generates database files so that dependence on git will
# be removed.
#
# Preconditions: asdn_summary_raw, asdn_summary_hash,
# asdn_commit_time must be declared associative
# arrays first
function amd_staging_drm_next_generate_database() {
	cd_asdn
	asdn_add_database_entry() {
		local n="${1}"
		local n_patch="${2}"
		local c="${3}"
		# multicore this code especially the sha1sum
		local s=$(git -P show -s --format="%s" ${c})
		local ct=$(git -P show -s --format="%ct" ${c})
		local h_summary=$(echo "${s}" | sha1sum | cut -f1 -d ' ')

		if (( ${ct} >= 1506464219 )) ; then
			DC_VER=$(git -P show \
				${c}:drivers/gpu/drm/amd/display/dc/dc.h 2>/dev/null \
				| grep -F -e "#define DC_VER" \
				| grep -o -P -e "\"[0-9.]+\"" \
				| sed -e "s|\"||g")

			# repad DC_VER
			DC_VER_MAJOR=$(printf "%02d" $(echo "$DC_VER" | cut -f1 -d '.'))
			DC_VER_MINOR=$(printf "%02d" $(echo "$DC_VER" | cut -f2 -d '.'))
			DC_VER_PATCH=$(printf "%03d" $(echo "$DC_VER" | cut -f3 -d '.' | sed -e "s|^0*||"))
			DC_VER="${DC_VER_MAJOR}.${DC_VER_MINOR}.${DC_VER_PATCH}"
		else
			DC_VER="00.00.000"
		fi

		printf -v pn "%06d" ${n_patch}
		echo -e "${s}" > "${BPS}/ot-sources/data/${c}-asdn_summary_raw"
		echo "${h_summary}" > "${BPS}/ot-sources/data/${c}-asdn_summary_hash"
		echo "${ct}" > "${BPS}/ot-sources/data/${c}-asdn_commit_time"
		echo "${DC_VER}" > "${BPS}/ot-sources/data/${c}-asdn_dc_ver"
		echo "${pn}" > "${BPS}/ot-sources/data/${c}-asdn_pn"
		rm -rf "${BPS}/ot-sources/locks/sem${n}"
	}

	rm -rf "${BPS}/ot-sources"/{data,locks} 2>/dev/null
	mkdir -p "${BPS}/ot-sources"/{data,locks}
	trap cleanup_shared EXIT

	readarray -t A <<< "${C}"
	local N_A="${#A[@]}"

	einfo "Transfering and fingerprinting ASDN metadata from git local repo to intermediate objects"

	echo ""
	local n_processed=0
	etf_init ${N_A} 42 1
	while (( ${n_processed} < ${N_A} )) ; do
		for n in $(seq 0 $((${N_CPU_CORES}-1))) ; do
			if (( ${n_processed} >= ${N_A} )) ; then
				break
			fi
			if mkdir "${BPS}/ot-sources/locks/sem${n}" 2>/dev/null ; then
				asdn_add_database_entry "${n}" "${n_processed}" "${A[${n_processed}]}" &
				n_processed=$((${n_processed}+1))
				progress_bar_ex ${n_processed} ${N_A}
			fi
		done
	done

	local remaining=1
	while (( ${remaining} > 0 )) ; do
		remaining=0
		for n in $(seq 0 $((${N_CPU_CORES}-1))) ; do
			if [[ -d "${BPS}/ot-sources/locks/sem${n}" ]] ; then
				remaining=$((remaining+1))
			fi
		done
	done
	echo ""

	einfo "Dumping ASDN intermediate objects to hash tables"

	n_processed=0
	echo ""
	etf_init ${N_A} 42 1
	for c in ${C} ; do
		asdn_summary_raw[${c}]=$(cat "${BPS}/ot-sources/data/${c}-asdn_summary_raw")
		asdn_summary_hash[${c}]=$(cat "${BPS}/ot-sources/data/${c}-asdn_summary_hash")
		asdn_commit_time[${c}]=$(cat "${BPS}/ot-sources/data/${c}-asdn_commit_time")
		asdn_dc_ver[${c}]=$(cat "${BPS}/ot-sources/data/${c}-asdn_dc_ver")
		asdn_pn[${c}]=$(cat "${BPS}/ot-sources/data/${c}-asdn_pn")
		n_processed=$((${n_processed}+1))
		progress_bar_ex ${n_processed} ${N_A}
	done
	echo ""

	pickle_associative_array "asdn_summary_raw" \
		"${T}/${ASDN_DB_SUMMARY_RAW_FN}"
	pickle_associative_array "asdn_summary_hash" \
		"${T}/${ASDN_DB_SUMMARY_HASH_FN}"
	pickle_associative_array "asdn_commit_time" \
		"${T}/${ASDN_DB_COMMIT_TIME_FN}"
	pickle_associative_array "asdn_dc_ver" \
		"${T}/${ASDN_DB_DC_VER_FN}"
	pickle_associative_array "asdn_pn" \
		"${T}/${ASDN_DB_PN_FN}"
}

# @FUNCTION: has_amd_staging_drm_next_database
# @DESCRIPTION:
# Checks for the existance of the amd-staging-drm-next databases
function has_amd_staging_drm_next_database() {
	if [[ -e "${FILESDIR}/${ASDN_DB_SUMMARY_RAW_FN}" \
		&& -e "${FILESDIR}/${ASDN_DB_SUMMARY_HASH_FN}" \
		&& -e "${FILESDIR}/${ASDN_DB_COMMIT_TIME_FN}" \
		&& -e "${FILESDIR}/${ASDN_DB_DC_VER_FN}" \
		&& -e "${FILESDIR}/${ASDN_DB_PN_FN}" ]]
	then
		return 0
	else
		return 1
	fi
}

# @FUNCTION: amd_staging_drm_next_use_database
# @DESCRIPTION:
# Loads the amd-staging-drm-next databases
function amd_staging_drm_next_use_database() {
	if has_amd_staging_drm_next_database ; then
		einfo "Using the amd-staging-drm-next database"
		cp -a "${FILESDIR}/${ASDN_DB_SUMMARY_RAW_FN}" \
			"${T}" || die
		cp -a "${FILESDIR}/${ASDN_DB_SUMMARY_HASH_FN}" \
			"${T}" || die
		cp -a "${FILESDIR}/${ASDN_DB_COMMIT_TIME_FN}" \
			"${T}" || die
		cp -a "${FILESDIR}/${ASDN_DB_DC_VER_FN}" \
			"${T}" || die
		cp -a "${FILESDIR}/${ASDN_DB_PN_FN}" \
			"${T}" || die
	else
		einfo "Generating the amd-staging-drm-next database"
		amd_staging_drm_next_generate_database
	fi
	source "${T}/${ASDN_DB_SUMMARY_RAW_FN}"
	source "${T}/${ASDN_DB_SUMMARY_HASH_FN}"
	source "${T}/${ASDN_DB_COMMIT_TIME_FN}"
	source "${T}/${ASDN_DB_DC_VER_FN}"
	source "${T}/${ASDN_DB_PN_FN}"
}


# @FUNCTION: generate_amd_staging_drm_next_patches
# @DESCRIPTION:
# Produces all the commits as .patch files to be individually evaluated.  It
# also pulls required missing commits to smooth out the patching process.
#
# ot-kernel-asdn-generate_amd_staging_drm_next_patches_post - callback to apply
#   additonal patches for fixes to patches before the patching proces
#
function generate_amd_staging_drm_next_patches() {
	cd_asdn

	local suffix_asdn
	local target=$(amd_staging_drm_next_set_target)
	suffix_asdn=$(ot-kernel-common_amdgpu_get_suffix_asdn)
	local base="${AMD_STAGING_INTERSECTS_KV}"

	mkdir -p "${ASDN_T_CACHE}"

	unset asdn_summary_raw
	unset asdn_summary_hash
	unset asdn_commit_time
	unset asdn_dc_ver
	unset asdn_pn

	# If you see:

	# environment: line 7788: 90489ce18c3a504c781c8cfcec013258c3459328:
	# value too great for base (error token is
	# "90489ce18c3a504c781c8cfcec013258c3459328"),

	# it may be caused by associative array not being declared like below.

	declare -Ax asdn_summary_raw
	declare -Ax asdn_summary_hash
	declare -Ax asdn_commit_time
	declare -Ax asdn_dc_ver
	declare -Ax asdn_pn

	local C
	einfo "Finding the amd-staging-drm-next commit list"
	amd_staging_drm_next_use_commit_list
	einfo "Finding the amd-staging-drm-next database"
	amd_staging_drm_next_use_database
	einfo "Finding and aliasing all amd-staging-drm-next commits"
	amd_staging_drm_next_use_and_alias_commits
	einfo "Filtering amd-staging-drm-next commits by git commit metadata"
	amd_staging_drm_next_filter_by_git_commit_metadata

	if declare \
		-f ot-kernel-asdn-generate_amd_staging_drm_next_patches_post \
		> /dev/null ; then
		ot-kernel-asdn-generate_amd_staging_drm_next_patches_post
	fi

	if declare -f ot-kernel-asdn_rm > /dev/null ; then
		# per version removal
		ot-kernel-asdn_rm
	fi
}

# @FUNCTION: generate_amd_staging_drm_next_hash_tables
# @DESCRIPTION:
# Generates amd-staging-drm-next hash tables for
# deduping.
function generate_amd_staging_drm_next_hash_tables() {
	cd_asdn
	einfo "Generating hash tables for amd-staging-drm-next"
	add_asdn_hash_table_entry() {
		local n="${1}"
		local f="${2}"
		local c=$(basename "$f" | cut -f4 -d '-')
		if [[ -n "${c}" && "${c}" != " " ]] ; then
			# multicore this, especially the sha1sum
			local s=$(git -P show -s --format=%s ${c})
			local h=$(echo "${s}" | sha1sum \
				| cut -f1 -d ' ')

			touch "${BPS}/ot-sources/data/c/${c}"
			if [[ -n "${h}" && "${h}" != " " ]] ; then
				touch "${BPS}/ot-sources/data/h/${h}"
			fi
		fi
		rm -rf "${BPS}/ot-sources/locks/sem${n}"
	}

	rm -rf "${BPS}/ot-sources"/{data,locks} 2>/dev/null
	mkdir -p "${BPS}/ot-sources/data"/{c,h}
	mkdir -p "${BPS}/ot-sources/locks"
	trap cleanup_shared EXIT

	readarray -t F <<< $(cat "${BPS}/ot-sources/aliases/asdn_filenames")
	local N_F="${#F[@]}"

	einfo "Extracting data from git local repo to intermediate objects"

	echo ""
	local n_processed=0
	etf_init ${N_F} 42 1
	while (( ${n_processed} < ${N_F} )) ; do
		for n in $(seq 0 $((${N_CPU_CORES}-1))) ; do
			if (( ${n_processed} >= ${N_F} )) ; then
				break
			fi
			if mkdir "${BPS}/ot-sources/locks/sem${n}" 2>/dev/null ; then
				add_asdn_hash_table_entry "${n}" "${F[${n_processed}]}" &
				n_processed=$((${n_processed}+1))
				progress_bar_ex ${n_processed} ${N_F}
			fi
		done
	done

	local remaining=1
	while (( ${remaining} > 0 )) ; do
		remaining=0
		for n in $(seq 0 $((${N_CPU_CORES}-1))) ; do
			if [[ -d "${BPS}/ot-sources/locks/sem${n}" ]] ; then
				remaining=$((remaining+1))
			fi
		done
	done
	echo ""

	n_processed=0
	einfo "Merging intermediate objects into commit hash tables"
	echo ""
	etf_init ${N_F} 42 1
	for c in $(ls "${BPS}/ot-sources/data/c") ; do
		asdn_commits[${c}]="1"
		n_processed=$((${n_processed}+1))
		progress_bar_ex ${n_processed} ${N_F}
	done
	echo ""

	n_processed=0
	einfo "Merging intermediate summaries into summary hash tables"
	echo ""
	etf_init ${N_F} 42 1
	for h in $(ls "${BPS}/ot-sources/data/h") ; do
		asdn_summaries[${h}]="1"
		n_processed=$((${n_processed}+1))
		progress_bar_ex ${n_processed} ${N_F}
	done
	echo ""

	pickle_associative_array "asdn_commits" "${T}/${HT_ASDN_FN}"
	pickle_associative_array "asdn_summaries" "${T}/${HT_ASDNS_FN}"
}

# @FUNCTION: amd_staging_drm_next_hash_use_hash_tables
# @DESCRIPTION:
# Loads amd-staging-drm-next hash tables for deduping
#
# Preconditions: the caller function must declare associative
# arrays named asdn_commits and asdn_summaries
function amd_staging_drm_next_hash_use_hash_tables() {
	if [[   ! -e "${FILESDIR}/${HT_ASDN_FN}" && \
		! -e "${FILESDIR}/${HT_ASDNS_FN}" ]] ; \
	then
		generate_amd_staging_drm_next_hash_tables
	else
		cp -a "${FILESDIR}/${HT_ASDN_FN}" "${T}"
		cp -a "${FILESDIR}/${HT_ASDNS_FN}" "${T}"
		einfo \
		  "Using cached hash tables for amd-staging-drm-next"
		source "${T}/${HT_ASDN_FN}"
		source "${T}/${HT_ASDNS_FN}"
	fi
}

# @FUNCTION: amd_staging_drm_next_is_cache_usable
# @DESCRIPTION:
# Checks if we can use the cache
# @RETURNS: 0 - yes we can, 1 - no we can't
function amd_staging_drm_next_is_cache_usable() {
	if [[ ! -d "${ASDN_LOCAL_CACHE}" ]] ; then
		return 1
	fi
	case ${AMD_STAGING_DRM_NEXT_BUMP_REQUEST} in
		head)
			return 1
			;;
		snapshot)
			local target=$(amd_staging_drm_next_set_target)
			if [[ ! -e "${ASDN_LOCAL_CACHE}/${target}.patch" ]] ; then
				einfo "Could not find ${ASDN_LOCAL_CACHE}/${target}.patch"
				return 1
			fi
			;;
		*)
			;;
	esac
	return 0
}
