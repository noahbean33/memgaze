# -*-Mode: makefile;-*-

#*BeginPNNLCopyright*********************************************************
#
# $HeadURL$
# $Id$
#
#***********************************************************EndPNNLCopyright*

#****************************************************************************
#
#****************************************************************************

#****************************************************************************
# Package defs
#****************************************************************************

include ../../Makefile-defs.mk

#****************************************************************************
# Recursion
#****************************************************************************

MK_SUBDIRS = 

#****************************************************************************
# 
#****************************************************************************

#----------------------------------------------------------------------------
# Build
#----------------------------------------------------------------------------

CXX = g++ -Wall -g -O3


#****************************************************************************

mg_analyze := memgaze-analyze-loc

MK_PROGRAMS_CXX = $(mg_analyze)

$(mg_analyze)_SRCS = \
	src/main.cpp \
	src/structure.cpp \
	src/BlockInfo.cpp \
	src/SpatialRUD.cpp \
	src/memoryanalysis.cpp \

# src/memoryanalysis.h \
# src/memorymodeling.h\
# src/structure.h\
# src/TraceLine.hpp\
# src/BlockInfo.hpp\
# src/SpatialRUD.hpp

$(mg_analyze)_CXXFLAGS =  

$(mg_analyze)_LDFLAGS =

$(mg_analyze)_LDADD =


#****************************************************************************
# Template Rules
#****************************************************************************

include ../../Makefile-template.mk


#****************************************************************************
# Local Rules
#****************************************************************************

info.local :

install.local :
	$(INSTALL) -d $(PREFIX_LIBEXEC)
	$(INSTALL) memgaze-analyze-loc $(PREFIX_LIBEXEC)      

check.local :
