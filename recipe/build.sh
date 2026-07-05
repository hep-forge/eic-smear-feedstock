#! /usr/bin/bash
set -e

mkdir -p build
cd build

# find_package(HepMC3 QUIET ...) succeeds (genuine Config mode, no
# custom Find module here), but this project's HepMC3 integration
# predates HepMC3's modern targets and reads legacy HEPMC3_LIB/
# HEPMC3_LIBRARIES variables that HepMC3Config.cmake never sets -- force
# them directly (the include side is handled by
# patches/force-prefix-include.patch, same issue estarlight-feedstock hit).
cmake .. \
  -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
  -DCMAKE_BUILD_TYPE=Release \
  -DHepMC3_DIR="${PREFIX}/share/HepMC3/cmake" \
  -DHEPMC3_LIB="${PREFIX}/lib/libHepMC3.so" \
  -DHEPMC3_LIBRARIES="${PREFIX}/lib/libHepMC3.so"

NPROC=$(nproc 2>/dev/null || sysctl -n hw.ncpu)
make -j"$NPROC"
make install
