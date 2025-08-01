#!/bin/bash

# Set base directory for source files and compiled outputs
SRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MODDIR=$SRCDIR

# Set compiler and options
FC=gfortran
FFLAGS="-O3 -cpp -J$MODDIR"

# Name of the output executable
EXE=$SRCDIR/msis2.1_test.exe

# List of Fortran source files
SRC="$SRCDIR/msis_constants.F90 $SRCDIR/msis_utils.F90 \
$SRCDIR/msis_init.F90 $SRCDIR/msis_gfn.F90 \
$SRCDIR/msis_tfn.F90 $SRCDIR/msis_dfn.F90 \
$SRCDIR/msis_calc.F90 $SRCDIR/msis_gtd8d.F90 \
$SRCDIR/msis2.1_test.F90"

# Compile command
echo "Compiling MSIS model..."
$FC $FFLAGS -o $EXE $SRC

# Check compilation status
if [ $? -eq 0 ]; then
    echo "Compilation successful. Executable: $EXE"
else
    echo "Compilation failed."
fi
