#EOC
#------------------------------------------------------------------------------
#          Harvard University Atmospheric Chemistry Modeling Group            !
#------------------------------------------------------------------------------
#BOP
#
# !IROUTINE: Makefile_header.mk
#
# !DESCRIPTION: This sub-makefile defines the variables which specify
# compilation options for the different supported compiler/platform
# combinations.  Also, the default makefile compilation rules are specified 
# here.
#\\
#\\
# !REMARKS:
# To build the programs, call "make" with the following syntax:
#                                                                             .
#   make TARGET [ OPTIONAL-FLAGS ]
#
# To display a complete list of options, type "make help".
#                                                                             .
# The following variables are exported to the main-level Makefile:
#                                                                             .
# Variable   Description
# --------   -----------
# CC         Contains the default C compilation commands (for PGI only)
# F90        Contains the Fortran compilation commands
# FREEFORM   Contains the command to force F90 "free format" compilation
# LD         Contains the command to link to libraries & make executable
# LINK       Contains the commands to link to GEOS-Chem built libraries
# R8         Contains the command to force REAL -> REAL*8
# SHELL      Contains the default Unix shell to use when building code
#                                                                             .
# FFLAGS is a local variable that is not returned to the "outside world", 
# but is only used locally.  COMPILER, HDF5, and OMP are all input via the
# command line or via environment variables.
#                                                                             .
# NOTE: We now use SHELL := /bin/bash as the default Unix shell.  This allows
# us to extend the Makefile ifeq statements so that we can test for more than
# one string.  The following example is used to ensure that the met field name
# selected by the user is case-insensitive:
# 
#   # %%%%% GEOS-5 %%%%%
#   ifdef MET
#   REGEXP    := ((^[Gg][Ee][Oo][Ss])?5|.5)
#   ifeq ($(shell [[ $(MET) =~ $(REGEXP) ]] && echo true),true)
#   USER_DEFS += -DGEOS_5
#   endif
#   endif
#                                                                             .
# The [[ ]] in bash is an evauluation.  The above ifeq statement uses regular
# expressions to test if the MET variable matches the string "GEOS" (case-
# insensitive) and either "5" or "any character and then a 5".  This will
# return true (via the "echo true" statement) for combinations like "GEOS-5", 
# "geos5", "Geos-5", "GeOs.5", etc.  This is a robust way of evaluating
# the user's input, and will make errors less likely.
#
# !REVISION HISTORY: 
#  16 Sep 2009 - R. Yantosca - Initial version
#  22 Sep 2009 - R. Yantosca - Bug fix, added -I$(HDR) to F90 compilation lines
#  24 Sep 2009 - R. Yantosca - added NONUMA option for PGI compiler
#  07 Oct 2009 - R. Yantosca - Replaced .SUFFIXES section w/ pattern rules
#  19 Nov 2009 - R. Yantosca - Now use OMP variable to determine whether to
#                              turn on OpenMP parallelization options 
#  23 Nov 2009 - R. Yantosca - Now use -module $(MOD) instead of -I$(MOD) to 
#                              specify the directory for *.mod files on both
#                              IFORT and PGI compilers.
#  23 Nov 2009 - R. Yantosca - Now use -moddir=$(MOD) and -M$(MOD) instead of
#                              -I$(MOD) to specify the directory for *.mod 
#                              files on the SunStudio compiler.
#  23 Nov 2009 - R. Yantosca - Change DEBUG to allow for new version of 
#                              Totalview which doesn't choke when debugging
#                              parallel code (Totalview 8.6.1-1)
#  02 Dec 2009 - R. Yantosca - Added SUN32 switch for building 32-bit 
#                              executbable on the SunStudio compiler
#  11 Dec 2009 - R. Yantosca - Now define SHELL here and export to other 
#                              Makefiles, so as to have a single place where
#                              the Unix shell name is defined.
#  21 Dec 2009 - R. Yantosca - Add H5I and H5L variables to specify the
#                              HDF5 library and include paths.  Also set
#                              the default to not link to the HDF5 libraries.
#  21 Dec 2009 - R. Yantosca - Now pass LINK back to the outside world, so
#                              that the Makefile that builds the executable
#                              can reference it.
#  19 Jan 2010 - R. Yantosca - Minor fix, add -m64 if SUN32 is not defined.
#  25 Jan 2010 - R. Yantosca - Now add -DTOMAS to FFLAGS if necessary
#  28 Jan 2010 - C. Carouge  - Add -lIsoropia to LINK, for ISORROPIA II
#  16 Feb 2011 - R. Yantosca - Now add -DAPM to FFLAGS if necessary
#  25 Aug 2011 - R. Yantosca - Add "-fp-model source" to FFLAGS for IFORT 
#                              compiler.  This will prevent aggressive 
#                              optimizations from changing numerical results.
#  25 Aug 2011 - R. Yantosca - Add -CU (check for uninit'd variables) to 
#                              FFLAGS when using IFORT w/ the DEBUG option.
#  26 Aug 2011 - R. Yantosca - Allow for deactivation of the "-fp-model source"
#                              option by using the PRECISE=no env variable
#  24 Jan 2012 - R. Yantosca - If NETCDF=yes, GEOS-Chem will link and include
#                              to the netCDF dir paths that are specified
#  24 Jan 2012 - R. Yantosca - Now use := for makefile assignment statements
#  10 Feb 2012 - R. Yantosca - When compiling with NETCDF=yes or HDF5=yes,
#                              we must also add the flags -mcmodel=medium 
#                              -i-dynamic to FFLAGS in order to avoid memory 
#                              errors (for IFORT only)
#  10 Feb 2012 - R. Yantosca - Remove -CU from the DEBUG option (IFORT only)
#  19 Mar 2012 - R. Yantosca - Add optional NO_ISO switch, which will turn off
#                              the ISORROPIA ATE package for testing
#  05 Apr 2012 - R. Yantosca - Now assume netCDF is always used
#  05 Apr 2012 - R. Yantosca - Change BL_INC_NETCDF to INC_NETCDF
#  05 Apr 2012 - R. Yantosca - Change BL_INC_HDF5   to INC_HDF5
#  05 Apr 2012 - R. Yantosca - Change BL_LIB_NETCDF to LIB_NETCDF
#  05 Apr 2012 - R. Yantosca - Change BL_LIB_HDF5   to LIB_HDF5
#  30 Apr 2012 - R. Yantosca - Add NETCDF3=[yes|no] makefile option
#  30 Apr 2012 - R. Yantosca - Use separate netCDF link and include paths
#                              for netCDF3 and for netCDF4
#  30 Apr 2012 - R. Yantosca - Also add -mcmodel=medium flag for PGI compiler
#  09 May 2012 - R. Yantosca - Now try to get the proper linking sequence 
#                              for netCDF etc w/ nf-config and nc-config.
#  11 May 2012 - R. Yantosca - Now export NCL (netCDF linking sequence)
#  07 Sep 2012 - R. Yantosca - Now add OPT variable to set global opt levels
#  07 Sep 2012 - R. Yantosca - Also set TRACEBACK for PGI compiler
#  25 Feb 2013 - S. Farina   - Add flag for TOMAS40
#  22 Apr 2013 - R. Yantosca - TOMAS40=yes option now sets -DTOMAS -DTOMAS40
#  28 Apr 2013 - S. Farina   - Add flags for TOMAS15 and TOMAS12
#  13 Aug 2013 - R. Yantosca - Removed "define.h"; now set all GEOS-Chem
#                              user options via the Make command
#  14 Aug 2013 - R. Yantosca - Now use regular expressions to test the
#                              validity of command-line inputs
#EOP
#------------------------------------------------------------------------------
#BOC

#==============================================================================
# Default values for variables
#==============================================================================

# Set default shell to bash, for use with the Makefile conditionals
SHELL     := /bin/bash

# Library include path
NCI       := -I$(GC_INCLUDE)

# Library link path: first try to get the list of proper linking flags
# for this build of netCDF with nf-config and nc-config. 
NCL       := $(shell $(GC_BIN)/nf-config --flibs)
NCL       += $(shell $(GC_BIN)/nc-config --libs)
NCL       := $(filter -l%,$(NCL))

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%%% NOTE TO GEOS-CHEM USERS: If you do not have netCDF-4.2 installed
#%%%% Then you can add/modify the linking sequence here.  (This sequence
#%%%% is a guess, but is probably good enough for other netCDF builds.)
ifeq ($(NCL),) 
NCL       := -lnetcdf -lhdf5_hl -lhdf5 -lz
endif
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Prepend the library directory path to the linking sequence
NCL       := -L$(GC_LIB) $(NCL)

# Command to link to the various library files (-lHeaders should be last!)
LINK      := -L$(LIB) -lKpp -lIsoropia -lGeosUtil -lHeaders
LINK      := $(LINK) -lNcUtils $(NCL)

# Commands to link to libraries, for GTMM code (-lHeaders should be last!)
LHG       := -L$(LIB) -lKpp -lIsoropia -lHg -lGeosUtil -lHeaders
LHG       := $(LINK) -lNcUtils $(NCL)

#==============================================================================
# Set C-preprocessor switches representing user options.  These are not
# specific to any compiler, but are general options for the simulation.
#
# NOTE: To make the user input more robust, we use regular expression syntax
# to match characters in the various Makefile variables.  See this web page
# for more info: http://www.tldp.org/LDP/abs/html/x17046.html
#==============================================================================

#---------------------------------------
# Compiler settings
#---------------------------------------

# %%%%% OpenMP parallelization default) %%%%%
ifndef OMP
OMP       := yes
endif

# %%%%% IFORT compiler (default) %%%%%
ifndef COMPILER
COMPILER  := ifort
endif
REGEXP    := (^[Ii][Ff][Oo][Rr][Tt])
ifeq ($(shell [[ $(COMPILER) =~ $(REGEXP) ]] && echo true),true)
USER_DEFS += -DLINUX_IFORT
endif

# %%%%% PGI compiler %%%%%
REGEXP    := (^[Pp][Gg][Ii])
ifeq ($(shell [[ $(COMPILER) =~ $(REGEXP) ]] && echo true),true)
USER_DEFS += -DLINUX_PGI
endif

#---------------------------------------
# Met field settings
#---------------------------------------

# Exit if the user has not selected a met field type
# Skip this error check for "make clean, make distclean, make realclean"
REGEXP := ([clean])
ifneq ($(shell [[ $(MAKECMDGOALS) =~ $(REGEXP) ]] && echo true),true)
ifndef MET
$(error Select a met field: MET=gcap, MET=geos4, MET=geos5, MET=merra, MET=geos-fp)
endif
endif

# %%%%% GCAP %%%%%
ifdef MET
REGEXP    := (^[Gg][Cc][Aa][Pp])
ifeq ($(shell [[ $(MET) =~ $(REGEXP) ]] && echo true),true)
USER_DEFS += -DGCAP
endif
endif

# %%%%% GEOS-4 %%%%%
ifdef MET
REGEXP    := ((^[Gg][Ee][Oo][Ss])?4|.4)
ifeq ($(shell [[ $(MET) =~ $(REGEXP) ]] && echo true),true)
USER_DEFS += -DGEOS_4
endif
endif

# %%%%% GEOS-5 %%%%%
ifdef MET
REGEXP    := ((^[Gg][Ee][Oo][Ss])?5|.5)
ifeq ($(shell [[ $(MET) =~ $(REGEXP) ]] && echo true),true)
USER_DEFS += -DGEOS_5
endif
endif

# %%%%% MERRA %%%%%
ifdef MET
REGEXP    := (^[Mm][Ee][Rr][Rr][Aa])
ifeq ($(shell [[ $(MET) =~ $(REGEXP) ]] && echo true),true)
USER_DEFS += -DMERRA
endif
endif

# %%%%% GEOS-FP %%%%%
ifdef MET
REGEXP    := (^[Gg][Ee][Oo][Ss][Ff][Pp])|(^[Gg][Ee][Oo][Ss].[Ff][Pp])
ifeq ($(shell [[ $(MET) =~ $(REGEXP) ]] && echo true),true)
USER_DEFS += -DGEOS_57
endif
endif

# %%%%% REDUCED VERTICAL GRID %%%%
# Assume a reduced vertical grid, unless specified otherwise
ifndef NO_REDUCED
USER_DEFS += -DGRIDREDUCED
else
REGEXP := (^[Yy]|^[Yy][Ee][Ss])
ifeq ($(shell [[ $(NO_REDUCED) =~ $(REGEXP) ]] && echo true),true)
endif
endif

#---------------------------------------
# Horizontal grid settings
#---------------------------------------

# Exit if the user has not selected a met field type
# Skip this error check for "make clean, make distclean, make realclean"
REGEXP := ([clean])
ifneq ($(shell [[ $(MAKECMDGOALS) =~ $(REGEXP) ]] && echo true),true)
ifndef GRID
$(error Select a horizontal grid: GRID=4x5. GRID=2x25, GRID=05x0666, GRID=025x03125)
endif
endif

# %%%%% 4 x 5 %%%%%
ifdef GRID
REGEXP    := (^4.5|^4\.0.5\.0)
ifeq ($(shell [[ $(GRID) =~ $(REGEXP) ]] && echo true),true)
USER_DEFS += -DGRID4x5
endif
endif

# %%%%% 2 x 2.5 %%%%%
ifdef GRID
REGEXP    := (^2.25|^2.2\.5|^2\.0.2\.5)
ifeq ($(shell [[ $(GRID) =~ $(REGEXP) ]] && echo true),true)
USER_DEFS += -DGRID2x25
endif
endif

# %%%%% 1 x 1.25 %%%%%
ifdef GRID
REGEXP    := (^1.125|^1.1\.25|^1\.0.1\.25)
ifeq ($(shell [[ $(GRID) =~ $(REGEXP) ]] && echo true),true)
USER_DEFS += -DGRID1x125
endif
endif

# %%%%% 0.5 x 0.666 %%%%%
ifdef GRID
REGEXP    := (^05.066.|^0\.5.0\.066.)
ifeq ($(shell [[ $(GRID) =~ $(REGEXP) ]] && echo true),true)

# Ensure that MET=geos5
ifdef MET
REGEXP    := ((^[Gg][Ee][Oo][Ss])?5|.5)
ifneq ($(shell [[ $(MET) =~ $(REGEXP) ]] && echo true),true)
$(error When GRID=05x0666, you can only use MET=geos5)
endif
endif

# Ensure that a nested-grid option is selected
ifndef NEST
$(error Please select a nested grid option, e.g. NEST=ch, NEST=eu, NEST=na)
else
USER_DEFS += -DGRID05x0666
endif
endif
endif

# %%%%% 0.25 x 0.3125 %%%%%
ifdef GRID
REGEXP    := (^025.03125|^0\.25.0\.3125)
ifeq ($(shell [[ $(GRID) =~ $(REGEXP) ]] && echo true),true)

# Ensure that MET=geos-fp
ifdef MET
REGEXP    := (^[Gg][Ee][Oo][Ss][Ff][Pp])|(^[Gg][Ee][Oo][Ss].[Ff][Pp])
ifneq ($(shell [[ $(MET) =~ $(REGEXP) ]] && echo true),true)
$(error When GRID=025x03125, you can only use MET=geos-fp)
endif
endif

# Ensure that a nested-grid option is selected
ifndef NEST
$(error Please select a nested grid option, e.g. NEST=ch, NEST=eu, NEST=na)
else
USER_DEFS += -DGRID025x03125
endif
endif
endif

#---------------------------------------
# Nested grid settings
#---------------------------------------

# %%%%% China (CH) %%%%%
ifdef NEST
REGEXP    := (^[Cc][Hh])
ifeq ($(shell [[ $(NEST) =~ $(REGEXP) ]] && echo true),true)
USER_DEFS += -DNESTED_CH
endif
endif

# %%%%% Europe (EU) %%%%%
ifdef NEST
REGEXP    := (^[Ee][Uu])
ifeq ($(shell [[ $(NEST) =~ $(REGEXP) ]] && echo true),true)
USER_DEFS += -DNESTED_EU
endif
endif

# %%%%% North America (NA) %%%%%
ifdef NEST
REGEXP    := (^[Nn][Aa])
ifeq ($(shell [[ $(NEST) =~ $(REGEXP) ]] && echo true),true)
USER_DEFS += -DNESTED_NA
endif
endif

#---------------------------------------
# Aerosol microphysics settings
#---------------------------------------

# %%%%% TOMAS, 30 bins (default) %%%%%
ifdef TOMAS
REGEXP    := (^[Yy]|^[Yy][Ee][Ss])
ifeq ($(shell [[ $(TOMAS) =~ $(REGEXP) ]] && echo true),true)
USER_DEFS += -DTOMAS
endif
endif

# %%%%% TOMAS, 40 bins %%%%%
ifdef TOMAS40
REGEXP    := (^[Yy]|^[Yy][Ee][Ss])
ifeq ($(shell [[ $(TOMAS40) =~ $(REGEXP) ]] && echo true),true)
USER_DEFS += -DTOMAS -DTOMAS40
endif
endif

# %%%%% TOMAS, 15 bins %%%%% 
ifdef TOMAS15
REGEXP    := (^[Yy]|^[Yy][Ee][Ss])
ifeq ($(shell [[ $(TOMAS15) =~ $(REGEXP) ]] && echo true),true)
USER_DEFS += -DTOMAS -DTOMAS15
endif
endif

# %%%%% TOMAS, 12 bins %%%%%
ifdef TOMAS12
REGEXP    := (^[Yy]|^[Yy][Ee][Ss])
ifeq ($(shell [[ $(TOMAS12) =~ $(REGEXP) ]] && echo true),true)
USER_DEFS += -DTOMAS -DTOMAS12
endif
endif

# %%%%% APM %%%%%
ifdef APM
REGEXP    := (^[Yy]|^[Yy][Ee][Ss])
ifeq ($(shell [[ $(APM) =~ $(REGEXP) ]] && echo true),true)
USER_DEFS += -DAPM
endif
endif

#---------------------------------------
# Special chemistry settings
#---------------------------------------

# Specify GTMM mercury model
ifdef GTMM_Hg
REGEXP    := (^[Yy]|^[Yy][Ee][Ss])
ifeq ($(shell [[ $(GTMM_Hg) =~ $(REGEXP) ]] && echo true),true)
USER_DEFS += -DGTMM_Hg
endif
endif

# Option to turn off ISORROPIA for testing
ifdef NO_ISO
REGEXP    := (^[Yy]|^[Yy][Ee][Ss])
ifeq ($(shell [[ $(NO_ISO) =~ $(REGEXP) ]] && echo true),true)
USER_DEFS += -DNO_ISORROPIA
endif
endif

#---------------------------------------
# Grid-Independent GEOS-Chem settings
#---------------------------------------

# %%%%% DEVEL %%%%%
ifdef DEVEL
REGEXP    := (^[Yy]|^[Yy][Ee][Ss])
ifeq ($(shell [[ $(DEVEL) =~ $(REGEXP) ]] && echo true),true)
USER_DEFS += -DDEVEL
endif
endif

# %%%%% EXTERNAL_GRID %%%%%
ifdef EXTERNAL_GRID
REGEXP    := (^[Yy]|^[Yy][Ee][Ss])
ifeq ($(shell [[ $(EXTERNAL_GRID) =~ $(REGEXP) ]] && echo true),true)
USER_DEFS += -DEXTERNAL_GRID
endif
endif

# %%%%% EXTERNAL_FORCING %%%%%
ifdef EXTERNAL_FORCING
REGEXP    := (^[Yy]|^[Yy][Ee][Ss])
ifeq ($(shell [[ $(EXTERNAL_FORCING) =~ $(REGEXP) ]] && echo true),true)
USER_DEFS += -DEXTERNAL_FORCING
endif
endif

#==============================================================================
# IFORT compilation options (default)
#==============================================================================
ifeq ($(COMPILER),ifort) 

# Default optimization level for all routines (-O2)
ifndef OPT
OPT       := -O2
endif

# Pick compiler options for debug run or regular run 
ifdef DEBUG
FFLAGS    := -cpp -w -O0 -auto -noalign -convert big_endian -g -DDEBUG -check arg_temp_created
TRACEBACK := yes
else
FFLAGS    := -cpp -w $(OPT) -auto -noalign -convert big_endian -vec-report0 
endif

# Turn on OpenMP parallelization
ifeq ($(OMP),yes) 
FFLAGS    += -openmp
endif

# Get Operating System (Linux = Linux; Darwin = MacOSX)
ifndef UNAME
UNAME     := $(shell uname)
endif

# OSX compilation options
ifeq ($(UNAME),Darwin)
FFLAGS    += -Wl,-stack_size,0x2cb410000 # Allow 12GB of stack space
ifdef DEBUG
FFLAGS    += -g0 -debug -save-temps -fpic -Wl,-no_pie
endif
endif

# Add options for medium memory model.  This is to prevent G-C from 
# running out of memory at hi-res, especially when using netCDF I/O.
ifneq ($(UNAME),Darwin)
FFLAGS    += -mcmodel=medium -shared-intel
endif

# Turn on floating-point exceptions
ifdef FPE
FFLAGS    += -debug parallel -fpe3 -ftrapuv
endif

# Prevent any optimizations that would change numerical results
# This is needed to prevent numerical noise from ISORROPIA (bmy, 8/25/11)
FFLAGS    += -fp-model source

# Add special IFORT optimization commands
ifdef IPO
FFLAGS    += -ipo -static
endif

# Add option for "array out of bounds" checking
ifdef BOUNDS
FFLAGS    += -CB
endif

# Also add traceback option
ifdef TRACEBACK
FFLAGS    += -traceback
endif

# Append the user options in USER_DEFS to FFLAGS
FFLAGS    += $(USER_DEFS)

# Include options (i.e. for finding *.h, *.mod files)
INCLUDE   := -I$(HDR) -module $(MOD) $(NCI)

# Set the standard compiler variables
CC        :=
F90       := ifort $(FFLAGS) $(INCLUDE)
LD        := ifort $(FFLAGS)
FREEFORM  := -free
R8        := -r8

endif

#==============================================================================
# Portland Group (PGI) compilation options
#==============================================================================
ifeq ($(COMPILER),pgi) 

# Default optimization level for all routines (-fast)
ifndef OPT
OPT       := -fast
endif

# Pick compiler options for debug run or regular run 
ifdef DEBUG 
FFLAGS    := -byteswapio -Mpreprocess -Bstatic -g -O0 
else
FFLAGS    := -byteswapio -Mpreprocess -Bstatic $(OPT)
endif

# Add options for medium memory model.  This is to prevent G-C from 
# running out of memory at hi-res, especially when using netCDF I/O.
FFLAGS    += -mcmodel=medium

# Turn on OpenMP parallelization
ifeq ($(OMP),yes) 
FFLAGS    += -mp -Mnosgimp -Dmultitask
endif

# Add option for suppressing PGI non-uniform memory access (numa) library 
ifeq ($(NONUMA),yes) 
FFLAGS    += -mp=nonuma
endif

# Add option for "array out of bounds" checking
ifdef BOUNDS
FFLAGS    += -C
endif

# Also add traceback option
ifdef TRACEBACK
FFLAGS    += -traceback
endif

# Append the user options in USER_DEFS to FFLAGS
FFLAGS    += $(USER_DEFS)

# Include options (i.e. for finding *.h, *.mod files)
INCLUDE   := -I$(HDR) -module $(MOD) $(NCI)

# Set the standard compiler variables
CC        := gcc
F90       := pgf90 $(FFLAGS) $(INCLUDE)
LD        := pgf90 $(FFLAGS)
FREEFORM  := -Mfree
R8        := -Mextend -r8

endif

#==============================================================================
# Specify pattern rules for compiliation 
# (i.e. tell "make" how to compile different types of source code files)
#==============================================================================
%.o : %.f
	$(F90) -c $<
%.o : %.F
	$(F90) -c $<
%.o : %.f90
	$(F90) -c $(FREEFORM) $<
%.o : %.F90
	$(F90) -c $(FREEFORM) $<
%.o : %.c
	$(CC) -c $*.c

#==============================================================================
# Export global variables so that the main Makefile will see these
#==============================================================================
export CC
export F90
export FREEFORM
export LD
export LINK
export R8
export SHELL
export NCL

#EOC
#==============================================================================
# Print variables for testing/debugging purposes (uncomment if necessary)
#=============================================================================
#headerinfo:
#	@@echo '####### in Makefile_header.mk ########' 
#	@@echo "compiler: $(COMPILER)"
#	@@echo "debug   : $(DEBUG)"
#	@@echo "bounds  : $(BOUNDS)"
#	@@echo "f90     : $(F90)"
#	@@echo "cc      : $(CC)"
#	@@echo "include : $(INCLUDE)"
#	@@echo "link    : $(LINK)"
#	@@echo "userdefs: $(USER_DEFS)"
