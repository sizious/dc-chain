#!/usr/bin/env bash

# Getting configuration from Makefile
source ./scripts/common.sh

print_banner "Cleaner"

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    case $PARAM in
        --including-logs)
            DELETE_LOGS=1
            ;;
        --keep-downloads)
            KEEP_DOWNLOADS=1
            ;;
        *)
            echo "error: unknown parameter \"$PARAM\""
            exit 1
            ;;
    esac
    shift
done

function cleanup_dependency()
{
  local type="$1"
  local dep_name="$2"  
  local dep_ver="$3"
  local dep_type="$4"

  local dep="${dep_name}-${dep_ver}"

  if [ -n "$dep_ver" ]; then
    if [ "$type" == "package" ]; then
      rm -f "${dep}.tar.${dep_type}"
	else
	  rm -rf "${dep}"
    fi
  fi
}

function cleanup_dependencies()
{
  local arch=$1
  local type=$2

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

  if [ "$USE_CUSTOM_DEPENDENCIES" == "1" ]; then
    cleanup_dependency "$type" "GMP"  "$gmp_ver"  "$gmp_tarball_type"
    cleanup_dependency "$type" "MPFR" "$mpfr_ver" "$mpfr_tarball_type"
    cleanup_dependency "$type" "MPC"  "$mpc_ver"  "$mpc_tarball_type"
    cleanup_dependency "$type" "ISL"  "$isl_ver"  "$isl_tarball_type"
  fi
}

if [ -z $KEEP_DOWNLOADS ]; then
  # Clean up downloaded tarballs...
  echo "Deleting downloaded packages..."

  rm -f binutils-$SH_BINUTILS_VER.tar.$SH_BINUTILS_TARBALL_TYPE \
        binutils-$ARM_BINUTILS_VER.tar.$ARM_BINUTILS_TARBALL_TYPE \
        gcc-$SH_GCC_VER.tar.$SH_GCC_TARBALL_TYPE \
        gcc-$ARM_GCC_VER.tar.$ARM_GCC_TARBALL_TYPE \
        newlib-$NEWLIB_VER.tar.$NEWLIB_TARBALL_TYPE

  if [ "$USE_CUSTOM_DEPENDENCIES" == "1" ]; then
    cleanup_dependencies "sh" "package"
    cleanup_dependencies "arm" "package"
  fi

  if [ -f "gdb-$GDB_VER.tar.$GDB_TARBALL_TYPE" ]; then
    rm -f gdb-$GDB_VER.tar.$GDB_TARBALL_TYPE
  fi

  if [ -f "insight-${INSIGHT_VER}a.tar.$INSIGHT_TARBALL_TYPE" ]; then
    rm -f insight-${INSIGHT_VER}a.tar.$INSIGHT_TARBALL_TYPE
  fi

  echo "Done!"
  echo "---------------------------------------"
fi

# Clean up unpacked sources...
echo "Deleting unpacked package sources..."
rm -rf binutils-$SH_BINUTILS_VER binutils-$ARM_BINUTILS_VER \
       gcc-$SH_GCC_VER gcc-$ARM_GCC_VER \
       newlib-$NEWLIB_VER \
       *.stamp	   

if [ "$USE_CUSTOM_DEPENDENCIES" == "1" ]; then
  cleanup_dependencies "sh" "dir"
  cleanup_dependencies "arm" "dir"
fi

if [ -d "gdb-$GDB_VER" ]; then
  rm -rf gdb-$GDB_VER
fi

if [ -d "insight-$INSIGHT_VER" ]; then
  rm -rf insight-$INSIGHT_VER
fi

echo "Done!"
echo "---------------------------------------"

# Clean up any stale build directories.
echo "Cleaning up build directories..."

make="make"
if ! [ -z "$(command -v gmake)" ]; then
  make="gmake"
fi

# Cleaning up build directories.
${make} clean > /dev/null 2>&1

echo "Done!"
echo "---------------------------------------"

# Clean up the logs
if [ "$DELETE_LOGS" == "1" ]; then
  echo "Cleaning up build logs..."

  if [ -d "logs/" ]; then
    rm -f logs/*.log
    rmdir logs/
  fi

  echo "Done!"
  echo "---------------------------------------"
fi

if [ -z $KEEP_DOWNLOADS ]; then
  # Clean up config.guess
  echo "Cleaning up ${CONFIG_GUESS}..."

  if [ -f ${CONFIG_GUESS} ]; then
    rm -f "${CONFIG_GUESS}"
  fi

  echo "Done!"
fi
