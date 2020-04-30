#!/usr/bin/env bash

# Getting configuration from Makefile
source ./scripts/common.sh

print_banner "Unpacker"

function unpack()
{
  local name="$1"
  local ver="$2"
  local ext="$3"

  local dirname=$(tolower $name)-$ver
  local filename=$dirname.tar.$ext

  if [ ! -f "$filename" ]; then
    echo "Required file not found: $filename"
    exit 1
  fi

  if [ ! -d "$dirname" ]; then
    echo "Unpacking $name $ver..."
    tar xf "$filename" || exit 1
  fi
}

function unpack_dependency()
{
  local gcc_ver="$1"
  local dep_name="$2"  
  local dep_ver="$3"
  local dep_type="$4"

  local path=$(tolower "$dep_name")

  if [ -n "$dep_ver" ]; then
    echo "  Unpacking $dep_name $dep_ver..."
    tar xf $path-$dep_ver.tar.$dep_type || exit 1
    mv $path-$dep_ver gcc-$gcc_ver/$path
  fi
}

function unpack_dependencies()
{
  local arch=$1

  local gcc_ver=$SH_GCC_VER
  local gmp_ver=$SH_GMP_VER
  local mpfr_ver=$SH_MPFR_VER
  local mpc_ver=$SH_MPC_VER
  local isl_ver=$SH_ISL_VER
  local gmp_tarball_type=$SH_GMP_TARBALL_TYPE
  local mpfr_tarball_type=$SH_MPFR_TARBALL_TYPE
  local mpc_tarball_type=$SH_MPC_TARBALL_TYPE
  local isl_tarball_type=$SH_ISL_TARBALL_TYPE

  if [ "$arch" == "arm" ]; then
    gcc_ver=$ARM_GCC_VER
    gmp_ver=$ARM_GMP_VER
    mpfr_ver=$ARM_MPFR_VER
    mpc_ver=$ARM_MPC_VER
    isl_ver=$ARM_ISL_VER
    gmp_tarball_type=$ARM_GMP_TARBALL_TYPE
    mpfr_tarball_type=$ARM_MPFR_TARBALL_TYPE
    mpc_tarball_type=$ARM_MPC_TARBALL_TYPE
    isl_tarball_type=$ARM_ISL_TARBALL_TYPE
  fi
  
  echo "Unpacking prerequisites for GCC ${gcc_ver}..."

  if [ "$USE_CUSTOM_DEPENDENCIES" == "1" ]; then
    unpack_dependency "$gcc_ver" "GMP"  "$gmp_ver"  "$gmp_tarball_type"
    unpack_dependency "$gcc_ver" "MPFR" "$mpfr_ver" "$mpfr_tarball_type"
    unpack_dependency "$gcc_ver" "MPC"  "$mpc_ver"  "$mpc_tarball_type"
    unpack_dependency "$gcc_ver" "ISL"  "$isl_ver"  "$isl_tarball_type"
  else
    cd ./gcc-$gcc_ver && ./contrib/download_prerequisites && cd ..
  fi
}

# Clean up from any old builds.
echo "Preparing unpacking..."
rm -rf binutils-$SH_BINUTILS_VER binutils-$ARM_BINUTILS_VER \
       gcc-$SH_GCC_VER gcc-$ARM_GCC_VER \
       newlib-$NEWLIB_VER

# Unpack SH components
unpack "Binutils" $SH_BINUTILS_VER $SH_BINUTILS_TARBALL_TYPE
unpack "GCC" $SH_GCC_VER $SH_GCC_TARBALL_TYPE
unpack_dependencies "sh"
unpack "Newlib" $NEWLIB_VER $NEWLIB_TARBALL_TYPE

# Unpack ARM components
unpack "Binutils" $ARM_BINUTILS_VER $ARM_BINUTILS_TARBALL_TYPE
unpack "GCC" $ARM_GCC_VER $ARM_GCC_TARBALL_TYPE
unpack_dependencies "arm"

echo "Done!"
