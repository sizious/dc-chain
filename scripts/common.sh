#!/usr/bin/env bash

# This shell script extract versions from Makefile
# It's used in ./download.sh, ./unpack.sh and ./cleanup.sh

# See: https://stackoverflow.com/a/3352015/3726096
function trim()
{
  local var="$*"
  var="${var#"${var%%[![:space:]]*}"}"
  var="${var%"${var##*[![:space:]]}"}"
  printf '%s' "$var"
}

# Thanks to fedorqui 'SO stop harming'
# See: https://stackoverflow.com/a/39384347/3726096
function get_make_var()
{
  local token="$1"
  local file="${2:-config.mk}"
  local result=$(cat ${file} | grep "^[^#;]" | awk -v token="${token}" -F "=" '$0 ~ token {print $2}')
  echo "$(trim ${result})"
}

function tolower()
{
  echo "$1" | awk '{print tolower($0)}'
}

function print_banner()
{
  local var="$1"
  local banner_text=`get_make_var banner_text scripts/banner-variables.mk`
  printf "*** ${var} Utility for ${banner_text} ***\n\n" 
}

export CONFIG_GUESS="config.guess"

export SH_BINUTILS_VER=`get_make_var sh_binutils_ver`
export SH_GCC_VER=`get_make_var sh_gcc_ver`
export NEWLIB_VER=`get_make_var newlib_ver`
export GDB_VER=`get_make_var gdb_ver`
export INSIGHT_VER=`get_make_var insight_ver`
export ARM_BINUTILS_VER=`get_make_var arm_binutils_ver`
export ARM_GCC_VER=`get_make_var arm_gcc_ver`

export SH_BINUTILS_TARBALL_TYPE=`get_make_var sh_binutils_tarball_type`
export SH_GCC_TARBALL_TYPE=`get_make_var sh_gcc_tarball_type`
export NEWLIB_TARBALL_TYPE=`get_make_var newlib_tarball_type`
export GDB_TARBALL_TYPE=`get_make_var gdb_tarball_type`
export INSIGHT_TARBALL_TYPE=`get_make_var insight_tarball_type`
export ARM_BINUTILS_TARBALL_TYPE=`get_make_var arm_binutils_tarball_type`
export ARM_GCC_TARBALL_TYPE=`get_make_var arm_gcc_tarball_type`

export SH_BINUTILS_URL=`get_make_var sh_binutils_url`
export SH_GCC_URL=`get_make_var sh_gcc_url`
export NEWLIB_URL=`get_make_var newlib_url`
export GDB_URL=`get_make_var gdb_url`
export INSIGHT_URL=`get_make_var insight_url`
export ARM_BINUTILS_URL=`get_make_var arm_binutils_url`
export ARM_GCC_URL=`get_make_var arm_gcc_url`

export DOWNLOAD_PROTOCOL="`get_make_var download_protocol`://"

export USE_CUSTOM_DEPENDENCIES=`get_make_var use_custom_dependencies`

export SH_GMP_VER=`get_make_var sh_gmp_ver`
export SH_MPFR_VER=`get_make_var sh_mpfr_ver`
export SH_MPC_VER=`get_make_var sh_mpc_ver`
export SH_ISL_VER=`get_make_var sh_isl_ver`
export ARM_GMP_VER=`get_make_var arm_gmp_ver`
export ARM_MPFR_VER=`get_make_var arm_mpfr_ver`
export ARM_MPC_VER=`get_make_var arm_mpc_ver`
export ARM_ISL_VER=`get_make_var arm_isl_ver`

export SH_GMP_TARBALL_TYPE=`get_make_var sh_gmp_tarball_type`
export SH_MPFR_TARBALL_TYPE=`get_make_var sh_mpfr_tarball_type`
export SH_MPC_TARBALL_TYPE=`get_make_var sh_mpc_tarball_type`
export SH_ISL_TARBALL_TYPE=`get_make_var sh_isl_tarball_type`
export ARM_GMP_TARBALL_TYPE=`get_make_var arm_gmp_tarball_type`
export ARM_MPFR_TARBALL_TYPE=`get_make_var arm_mpfr_tarball_type`
export ARM_MPC_TARBALL_TYPE=`get_make_var arm_mpc_tarball_type`
export ARM_ISL_TARBALL_TYPE=`get_make_var arm_isl_tarball_type`

export SH_GMP_URL=`get_make_var sh_gmp_url`
export SH_MPFR_URL=`get_make_var sh_mpfr_url`
export SH_MPC_URL=`get_make_var sh_mpc_url`
export SH_ISL_URL=`get_make_var sh_isl_url`
export ARM_GMP_URL=`get_make_var arm_gmp_url`
export ARM_MPFR_URL=`get_make_var arm_mpfr_url`
export ARM_MPC_URL=`get_make_var arm_mpc_url`
export ARM_ISL_URL=`get_make_var arm_isl_url`

# Retrieve the web downloader program available in this system.
export IS_CURL=0
export WEB_DOWNLOADER=
curl_cmd=`get_make_var curl_cmd scripts/init.mk`
wget_cmd=`get_make_var wget_cmd scripts/init.mk`
force_downloader=`get_make_var force_downloader`
if [ -z "$force_downloader" ]; then
  if command -v curl > /dev/null 2>&1; then
    export WEB_DOWNLOADER=${curl_cmd}
    export IS_CURL=1
  elif command -v wget > /dev/null 2>&1; then
    export WEB_DOWNLOADER=${wget_cmd}
  else
    echo >&2 "You must have either Wget or cURL installed!" || exit 1    
  fi
else
  if [ "$force_downloader" == "curl" ]; then
    export WEB_DOWNLOADER=${curl_cmd}
    export IS_CURL=1	
  elif [ "$force_downloader" == "wget" ]; then
    export WEB_DOWNLOADER=${wget_cmd}      
  else
    echo >&2 "Only Wget or cURL are supported!" || exit 1    
  fi
fi
