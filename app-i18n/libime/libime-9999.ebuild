# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

EGIT_REPO_URI="https://github.com/fcitx/libime.git"
EGIT_SUBMODULES=( 'src/libime/kenlm' )
SRC_URI="
	https://download.fcitx-im.org/data/lm_sc.arpa-20241001.tar.zst -> ${PN}-lm_sc.arpa-20241001.tar.zst
	https://download.fcitx-im.org/data/dict-20241001.tar.zst -> ${PN}-dict-20241001.tar.zst
	https://download.fcitx-im.org/data/table-20240108.tar.zst -> ${PN}-table-20240108.tar.zst
"
DESCRIPTION="Fcitx5 Next generation of fcitx "
HOMEPAGE="https://fcitx-im.org/"
LICENSE="LGPL-2+"
SLOT="5"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=app-i18n/fcitx-5.1.5:5
	app-arch/zstd:=
	dev-libs/boost:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	kde-frameworks/extra-cmake-modules:0
	virtual/pkgconfig
	doc? (
		app-text/doxygen
		media-gfx/graphviz[svg]
	)
"

src_prepare() {
	ln -sv "${DISTDIR}/${PN}-lm_sc.arpa-20241001.tar.zst" "${S}/data/lm_sc.arpa-20241001.tar.zst" || die
	ln -sv "${DISTDIR}/${PN}-dict-20241001.tar.zst" "${S}/data/dict-20241001.tar.zst" || die
	ln -sv "${DISTDIR}/${PN}-table-20240108.tar.zst" "${S}/data/table-20240108.tar.zst" || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_DOC=$(usex doc)
		-DENABLE_TEST=$(usex test)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_src_compile doc
}

src_install() {
	cmake_src_install
	use doc && dodoc -r "${BUILD_DIR}"/doc/*
}
