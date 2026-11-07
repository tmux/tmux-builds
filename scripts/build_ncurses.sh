#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${PREFIX:-}" ]]; then
    echo "Error: PREFIX must be set" >&2
    exit 1
fi

if [[ -z "${NCURSES_VERSION:-}" ]]; then
    echo "Error: NCURSES_VERSION must be set" >&2
    exit 1
fi

mkdir -p "$PREFIX/src"
cd "$PREFIX/src"

# invisible-island.net can be unreliable at times, so we try multiple mirrors for downloading ncurses
NCURSES_TARBALL="ncurses-${NCURSES_VERSION}.tar.gz"
NCURSES_DOWNLOAD_URLS=(
    "https://invisible-island.net/archives/ncurses/${NCURSES_TARBALL}"
    "https://ftp.gnu.org/gnu/ncurses/${NCURSES_TARBALL}"
)
download_succeeded=false
for download_url in "${NCURSES_DOWNLOAD_URLS[@]}"; do
    if wget --tries=3 "$download_url"; then
        download_succeeded=true
        break
    fi
    echo "Download from $download_url failed, trying next mirror" >&2
done
if [[ "$download_succeeded" != true ]]; then
    echo "Error: could not download $NCURSES_TARBALL from any mirror" >&2
    exit 1
fi

tar xzf "ncurses-${NCURSES_VERSION}.tar.gz"
cd "ncurses-${NCURSES_VERSION}"

./configure \
    --prefix=${PREFIX} \
    --includedir=${PREFIX}/include \
    --libdir=${PREFIX}/lib \
    --without-ada \
    --without-cxx \
    --without-cxx-binding \
    --without-tests \
    --without-manpages \
    --without-debug \
    --disable-lib-suffixes \
    --disable-db-install \
    --with-termlib \
    --with-default-terminfo-dir=/usr/share/terminfo \
    --with-terminfo-dirs=/etc/terminfo:/lib/terminfo:/usr/share/terminfo

make -j$(nproc)
make install

rm -rf "$PREFIX/src"
