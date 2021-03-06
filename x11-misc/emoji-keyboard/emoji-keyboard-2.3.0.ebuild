# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_5 python3_6 python3_7 )
DISTUTILS_SINGLE_IMPL=1
# gobject-introspection complains about multiple implementations

inherit distutils-r1 eutils python-single-r1 linux-info user

DESCRIPTION="Virtual keyboard-like emoji picker for Linux. "
HOMEPAGE="https://github.com/OzymandiasTheGreat/emoji-keyboard"

EMOJITWO_COMMIT="b851e2070faf5c707d2e74988d425d4956c17187"
NOTOEMOJI_COMMIT="09d8fd121a6d35081fdc31a540735c4a2f924356"
TWEMOJI_COMMIT="2f786b03d0bc0944eb3b66850a805dcadd5f853d"

SRC_URI="https://github.com/OzymandiasTheGreat/emoji-keyboard/archive/${PV}.tar.gz -> ${P}.tar.gz
	 https://github.com/EmojiTwo/emojitwo/archive/${EMOJITWO_COMMIT}.zip -> emoji-keyboard-deps-emojitwo-9999.20171213.zip
         https://github.com/googlei18n/noto-emoji/archive/${NOTOEMOJI_COMMIT}.zip -> emoji-keyboard-deps-noto-emoji-9999.20171216.zip
	 https://github.com/twitter/twemoji/archive/${TWEMOJI_COMMIT}.zip -> emoji-keyboard-deps-twemoji-9999.20171208.zip"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="wayland X"
REQUIRED_USE="|| ( X wayland )"

RDEPEND="dev-python/python-evdev[${PYTHON_USEDEP}]
         dev-python/pygobject[${PYTHON_USEDEP}]
         dev-libs/gobject-introspection[${PYTHON_USEDEP}]
	 x11-libs/gtk+:3[introspection]
	 dev-libs/libappindicator[introspection]
	 X? ( >=dev-python/python-xlib-0.19[${PYTHON_USEDEP}] )
	 wayland? ( sys-apps/systemd )"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

pkg_setup() {
	ewarn "You may need to \`xhost +\` if it complains about No protocol specified."
	linux-info_pkg_setup
	if ! linux_config_exists ; then
		eerror "You are missing a .config file in your kernel source."
		die
	fi

	if ! linux_chkconfig_present INPUT_EVDEV ; then
		eerror "You need CONFIG_INPUT_EVDEV=y or CONFIG_INPUT_EVDEV=m for this to work."
		die
	fi

	if use wayland ; then
		if ! linux_chkconfig_present INPUT_UINPUT ; then
			eerror "You need CONFIG_INPUT_UINPUT=y or CONFIG_INPUT_UINPUT=m for this to work."
			die
		fi
	fi
	python_setup
}

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}/emojitwo-${EMOJITWO_COMMIT}"/* "${S}"/emojitwo/ || die
	mv "${WORKDIR}/noto-emoji-${NOTOEMOJI_COMMIT}"/* "${S}"/noto-emoji/ || die
	mv "${WORKDIR}/twemoji-${TWEMOJI_COMMIT}"/* "${S}"/twemoji/ || die
}

python_prepare_all() {
	if ! use wayland ; then
		epatch "${FILESDIR}/emoji-keyboard-2.3.0-no-wayland.patch"
	fi

	einfo "Updating emojis please wait..."
	./update-resources.py

	distutils-r1_python_prepare_all
}

python_compile() {
	distutils-r1_python_compile
}

pkg_preinst() {
	if use wayland ; then
		enewgroup uinput
		mkdir -p "${D}"/etc/udev/rules.d/
		echo 'KERNEL=="uinput", GROUP="uinput", MODE="0660"' > "${D}"/etc/udev/rules.d/uinput.rules
	fi
}

pkg_postinst() {
	if ! use X ; then
		ewarn "You are not installing X support and is highly recommended.  Settings > On selecting emoji > Type will not work without X USE flag if you are using X11 instead of Wayland."
	fi
	if use wayland ; then
		ewarn "You need to add yourself to the uinput group for Type mode pasting on Wayland to work."
	fi
}
