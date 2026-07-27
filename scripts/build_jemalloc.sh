#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${PREFIX:-}" ]]; then
    echo "Error: PREFIX must be set" >&2
    exit 1
fi

if [[ -z "${JEMALLOC_VERSION:-}" ]]; then
    echo "Error: JEMALLOC_VERSION must be set" >&2
    exit 1
fi

mkdir -p "$PREFIX/src"
cd "$PREFIX/src"
wget "https://github.com/jemalloc/jemalloc/releases/download/${JEMALLOC_VERSION}/jemalloc-${JEMALLOC_VERSION}.tar.bz2"
tar xjf "jemalloc-${JEMALLOC_VERSION}.tar.bz2"
cd "jemalloc-${JEMALLOC_VERSION}"

./configure \
    --prefix="$PREFIX" \
    --includedir="${PREFIX}/include" \
    --libdir="${PREFIX}/lib" \
    --disable-shared

make -j$(sysctl -n hw.ncpu)
make install_bin install_include install_lib

rm -rf "$PREFIX/src"
