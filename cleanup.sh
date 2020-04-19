#!/usr/bin/env bash

# Getting configuration from Makefile
source ./scripts/common.sh

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    case $PARAM in
        --including-logs)
            DELETE_LOGS=1
            ;;
        --keep-downloads)
            KEEP_DOWNLOADS=1
            ;;
        --no-gmp)
            unset SH_GMP_VER
            unset ARM_GMP_VER
            ;;
        --no-mpfr)
            unset SH_MPFR_VER
            unset ARM_MPFR_VER
            ;;
        --no-mpc)
            unset SH_MPC_VER
            unset ARM_MPC_VER
            ;;
        --no-deps)
            unset SH_GMP_VER
            unset ARM_GMP_VER
            unset SH_MPFR_VER
            unset ARM_MPFR_VER
            unset SH_MPC_VER
            unset ARM_MPC_VER
            ;;
        *)
            echo "error: unknown parameter \"$PARAM\""
            exit 1
            ;;
    esac
    shift
done

if [ -z $KEEP_DOWNLOADS ]; then

  # Clean up downloaded tarballs...
  echo "Deleting downloaded packages..."

  rm -f binutils-$SH_BINUTILS_VER.tar.$SH_BINUTILS_TARBALL_TYPE \
        binutils-$ARM_BINUTILS_VER.tar.$ARM_BINUTILS_TARBALL_TYPE \
        gcc-$SH_GCC_VER.tar.$SH_GCC_TARBALL_TYPE \
        gcc-$ARM_GCC_VER.tar.$ARM_GCC_TARBALL_TYPE \
        newlib-$NEWLIB_VER.tar.$NEWLIB_TARBALL_TYPE

  if [ "$USE_CUSTOM_DEPENDENCIES" == "1" ]; then

    if [ -n "$SH_GMP_VER" ]; then
      rm -f gmp-$SH_GMP_VER.tar.$SH_GMP_TARBALL_TYPE
    fi

    if [ -n "$SH_MPFR_VER" ]; then
      rm -f mpfr-$SH_MPFR_VER.tar.$SH_MPFR_TARBALL_TYPE
    fi

    if [ -n "$SH_MPC_VER" ]; then
      rm -f mpc-$SH_MPC_VER.tar.$SH_MPC_TARBALL_TYPE
    fi

    if [ -n "$ARM_GMP_VER" ]; then
      rm -f gmp-$ARM_GMP_VER.tar.$ARM_GMP_TARBALL_TYPE
    fi

    if [ -n "$ARM_MPFR_VER" ]; then
      rm -f mpfr-$ARM_MPFR_VER.tar.$ARM_MPFR_TARBALL_TYPE
    fi

    if [ -n "$ARM_MPC_VER" ]; then
      rm -f mpc-$ARM_MPC_VER.tar.$ARM_MPC_TARBALL_TYPE
    fi

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

  if [ -n "$SH_GMP_VER" ]; then
    rm -rf gmp-$SH_GMP_VER
  fi

  if [ -n "$SH_MPFR_VER" ]; then
    rm -rf mpfr-$SH_MPFR_VER
  fi

  if [ -n "$SH_MPC_VER" ]; then
    rm -rf mpc-$SH_MPC_VER
  fi

  if [ -n "$ARM_GMP_VER" ]; then
    rm -rf gmp-$ARM_GMP_VER
  fi

  if [ -n "$ARM_MPFR_VER" ]; then
    rm -rf mpfr-$ARM_MPFR_VER
  fi

  if [ -n "$ARM_MPC_VER" ]; then
    rm -rf mpc-$ARM_MPC_VER
  fi

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
${make} clean

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
