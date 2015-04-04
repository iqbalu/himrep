# Copyright: 2008-2010 RobotCub Consortium
# Author: Vadim Tikhanoff
# CopyPolicy: Released under the terms of the GNU GPL v2.0.

# Created:
# SIFTGPU_INCLUDE_DIRS - Directories to include to use SIFT
# SIFTGPU_LIBRARIES    - Default library to link against to use SIFT
# SIFTGPU_LINK_FLAGS   - Flags to be added to linker's options
# SIFTGPU_FOUND        - If false, don't try to use SIFT

IF (NOT SIFTGPU_DIR)
	SET (SIFTGPU_ENV_DIR $ENV{SIFTGPU_DIR})
	IF (SIFTGPU_ENV_DIR)
		FIND_PATH(SIFTGPU_DIR src/SiftGPU/SiftGPU.h ${SIFTGPU_ENV_DIR})
	ELSE (SIFTGPU_ENV_DIR)
		FIND_PATH(SIFTGPU_DIR src/SiftGPU/SiftGPU.h ${CMAKE_PROJECT_DIR})
	ENDIF (SIFTGPU_ENV_DIR)

        FIND_PATH(SIFTGPU_INCLUDE_DIRS SiftGPU.h ${SIFTGPU_DIR}/src/SiftGPU)
        MARK_AS_ADVANCED(SIFTGPU_INCLUDE_DIRS)
ENDIF (NOT SIFTGPU_DIR)

#SET (SIFTGPU_SYSTEM_LIBS)
#SET (SIFTGPU_SYSTEM_LIBS_FOUND FALSE)
SET (SIFTGPU_FOUND FALSE)

if (WIN32)
    message (STATUS "windows not supported")
    FIND_PATH(SIFTGPU_INCLUDE_DIRS NAMES GL/glut.h 
    PATHS ${SIFTGPU_DIR})
    FIND_LIBRARY(SIFTGPU_LIBRARIES NAMES glut glut32
    PATHS
    ${SIFTGPU_DIR}
	)
	message(${SIFTGPU_LIBRARIES})
	if (SIFTGPU_INCLUDE_DIR AND SIFTGPU_LIBRARIES)
		set(GLUT_FOUND TRUE CACHE BOOL "SIFTGPU found?")
	endif(SIFTGPU_INCLUDE_DIR AND SIFTGPU_LIBRARIES)
else(WIN32)

    FIND_LIBRARY(SIFTGPU_LIBRARIES libsiftgpu.so "${SIFTGPU_DIR}/bin")
    if(SIFTGPU_LIBRARIES)
        SET (SIFTGPU_FOUND TRUE)    
        MARK_AS_ADVANCED(SIFTGPU_LIBRARIES)
    endif()
    
    FIND_PACKAGE(OpenGL)
    if (OPENGL_FOUND)
        SET (SIFTGPU_SYSTEM_LIBS ${OPENGL_LIBRARIES})
        SET (SIFTGPU_SYSTEM_LIBS_FOUND ${OPENGL_FOUND})
    else()
        message(STATUS "Cannot find OpenGL")
        set(SIFTGPU_FOUND FALSE)
    endif()
endif(WIN32)

if (SIFTGPU_FOUND)
    set(SIFTGPU_INCLUDE_DIRS ${SIFTGPU_INCLUDE_DIR})
endif(SIFTGPU_FOUND)

# push back original CMAKE_MODULE_PATH
set(CMAKE_MODULE_PATH ${_CMAKE_MODULE_PATH})

