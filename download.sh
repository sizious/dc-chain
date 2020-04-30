#!/usr/bin/env bash

# Getting configuration from Makefile
source ./scripts/common.sh

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    case $PARAM in
        --config-guess-only)
            CONFIG_GUESS_ONLY=1
            ;;
        *)
            echo "error: unknown parameter \"$PARAM\""
            exit 1
            ;;
    esac
    shift
done

# Retrieve the web downloader program available in this system.
if command -v curl > /dev/null 2>&1; then
  WEB_DOWNLOADER=`get_make_var curl_cmd scripts/init.mk`
  IS_CURL=1
elif command -v wget > /dev/null 2>&1; then
  WEB_DOWNLOADER=`get_make_var wget_cmd scripts/init.mk`
else
  echo >&2 "You must have either Wget or cURL installed!"
  exit 1
fi

function download()
{
  local name=$1
  local ver=$2
  local url=$3
  local filename=$(basename $url)

  if [ -n "$ver" ]; then
    if [ ! -f $filename ]; then
      echo "Downloading ${name} ${ver}..."
      ${WEB_DOWNLOADER} "${DOWNLOAD_PROTOCOL}${url}" || exit 1
    else
      echo "$name $ver was already downloaded"
	fi
  fi
}

function download_dependencies()
{
  local arch=$1

  local gmp_ver=$SH_GMP_VER
  local mpfr_ver=$SH_MPFR_VER
  local mpc_ver=$SH_MPC_VER
  local isl_ver=$SH_ISL_VER
  local gmp_tarball_type=$SH_GMP_TARBALL_TYPE
  local mpfr_tarball_type=$SH_MPFR_TARBALL_TYPE
  local mpc_tarball_type=$SH_MPC_TARBALL_TYPE
  local isl_tarball_type=$SH_ISL_TARBALL_TYPE

  if [ "$arch" == "arm" ]; then
    gmp_ver=$ARM_GMP_VER
    mpfr_ver=$ARM_MPFR_VER
    mpc_ver=$ARM_MPC_VER
    isl_ver=$ARM_ISL_VER
    gmp_tarball_type=$ARM_GMP_TARBALL_TYPE
    mpfr_tarball_type=$ARM_MPFR_TARBALL_TYPE
    mpc_tarball_type=$ARM_MPC_TARBALL_TYPE
    isl_tarball_type=$ARM_ISL_TARBALL_TYPE
  fi

  if [ "$USE_CUSTOM_DEPENDENCIES" == "1" ]; then
    download "GMP"  "$gmp_ver"   "gcc.gnu.org/pub/gcc/infrastructure/gmp-$gmp_ver.tar.$gmp_tarball_type"
    download "MPFR" "$mpfr_ver"  "gcc.gnu.org/pub/gcc/infrastructure/mpfr-$mpfr_ver.tar.$mpfr_tarball_type"
    download "MPC"  "$mpc_ver"   "gcc.gnu.org/pub/gcc/infrastructure/mpc-$mpc_ver.tar.$mpc_tarball_type"
    download "ISL"  "$isl_ver"   "gcc.gnu.org/pub/gcc/infrastructure/isl-$isl_ver.tar.$isl_tarball_type"
  fi
}

# Download everything.
if [ -z "${CONFIG_GUESS_ONLY}" ]; then
  echo "*** Downloading SH components";

  download "Binutils" "$SH_BINUTILS_VER" "ftp.gnu.org/gnu/binutils/binutils-$SH_BINUTILS_VER.tar.$SH_BINUTILS_TARBALL_TYPE"
  download "GCC" "$SH_GCC_VER" "ftp.gnu.org/gnu/gcc/gcc-$SH_GCC_VER/gcc-$SH_GCC_VER.tar.$SH_GCC_TARBALL_TYPE"
  download_dependencies "sh"
  download "Newlib" "$NEWLIB_VER" "sourceware.org/pub/newlib/newlib-$NEWLIB_VER.tar.$NEWLIB_TARBALL_TYPE"

  echo "*** Downloading ARM components...";

  download "Binutils" $ARM_BINUTILS_VER"" "ftp.gnu.org/gnu/binutils/binutils-$ARM_BINUTILS_VER.tar.$ARM_BINUTILS_TARBALL_TYPE"
  download "GCC" "$ARM_GCC_VER" "ftp.gnu.org/gnu/gcc/gcc-$ARM_GCC_VER/gcc-$ARM_GCC_VER.tar.$ARM_GCC_TARBALL_TYPE"
  download_dependencies "arm"
fi

# Downloading config.guess.
if [ ! -f ${CONFIG_GUESS} ]; then
  WEB_DOWNLOAD_OUTPUT_SWITCH="-O"
  if [ ! -z "${IS_CURL}" ]; then
    WEB_DOWNLOADER="$(echo ${WEB_DOWNLOADER} | cut -c-9)"
    WEB_DOWNLOAD_OUTPUT_SWITCH="-o"
  fi

  echo "Downloading ${CONFIG_GUESS}..."
  ${WEB_DOWNLOADER} ${WEB_DOWNLOAD_OUTPUT_SWITCH} ${CONFIG_GUESS} "http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=${CONFIG_GUESS};hb=HEAD" || exit 1

  # This is needed for all systems except MinGW.
  chmod +x "./${CONFIG_GUESS}"
fi

echo "Done!"
