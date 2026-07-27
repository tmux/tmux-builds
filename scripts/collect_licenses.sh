#!/usr/bin/env bash
set -euo pipefail

PREFIX="${PREFIX:-/tmp/build}"

SCRIPTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPTDIR}/../versions.env"

mkdir -p "$PREFIX/licenses"

# libevent
echo "Collecting libevent license..."
wget -q "https://raw.githubusercontent.com/libevent/libevent/release-${LIBEVENT_VERSION}-stable/LICENSE" -O "$PREFIX/licenses/LICENSE.libevent"

# musl
echo "Collecting musl license..."
wget -q "https://musl.libc.org/releases/musl-${MUSL_VERSION}.tar.gz"
tar xzf "musl-${MUSL_VERSION}.tar.gz"
cp "musl-${MUSL_VERSION}/COPYRIGHT" "$PREFIX/licenses/COPYRIGHT.musl"
rm -rf "musl-${MUSL_VERSION}" "musl-${MUSL_VERSION}.tar.gz"

# ncurses
echo "Collecting ncurses license..."
wget -q "https://invisible-island.net/archives/ncurses/ncurses-${NCURSES_VERSION}.tar.gz"
tar xzf "ncurses-${NCURSES_VERSION}.tar.gz"
cp "ncurses-${NCURSES_VERSION}/COPYING" "$PREFIX/licenses/COPYING.ncurses"
rm -rf "ncurses-${NCURSES_VERSION}" "ncurses-${NCURSES_VERSION}.tar.gz"

# utf8proc
echo "Collecting utf8proc license..."
wget -q "https://raw.githubusercontent.com/JuliaStrings/utf8proc/v${UTF8PROC_VERSION}/LICENSE.md" -O "$PREFIX/licenses/LICENSE.utf8proc"

# jemalloc
echo "Collecting jemalloc license..."
wget -q "https://raw.githubusercontent.com/jemalloc/jemalloc/${JEMALLOC_VERSION}/COPYING" -O "$PREFIX/licenses/COPYING.jemalloc"

# tmux
echo "Collecting tmux license..."
if [[ "${TMUX_VERSION}" == "preview" ]]; then
    wget -q "https://raw.githubusercontent.com/tmux/tmux/master/COPYING" -O "$PREFIX/licenses/COPYING.tmux"
else
    wget -q "https://raw.githubusercontent.com/tmux/tmux/${TMUX_VERSION}/COPYING" -O "$PREFIX/licenses/COPYING.tmux"
fi

# Create archive
echo "Creating archive..."
tar czf "${PREFIX}/LICENSES.tar.gz" -C "$PREFIX/licenses" .
rm -rf "$PREFIX/licenses"

echo "Licenses collected in ${PREFIX}/LICENSES.tar.gz"
