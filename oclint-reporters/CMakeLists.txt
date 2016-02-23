CMAKE_MINIMUM_REQUIRED(VERSION 2.8)
PROJECT(OCLINT_REPORTERS)

find_package(OCLintCore REQUIRED)

SET(CMAKE_MODULE_PATH
    ${CMAKE_MODULE_PATH}
    ${OCLINT_CORE_CMAKE_DIR}
    )

INCLUDE(OCLintConfig)

INCLUDE_DIRECTORIES(${OCLINT_CORE_INCLUDE_DIRS}
	${OCLINT_DRIVER_SOURCE_DIR}/include
)

IF(TEST_BUILD)
    INCLUDE_DIRECTORIES(${OCLINT_REPORTERS_SOURCE_DIR}/reporters)
    ADD_SUBDIRECTORY(test)
ELSE(TEST_BUILD)
    ADD_SUBDIRECTORY(reporters)
ENDIF()


# Offer the user the choice of overriding the installation directories
set(INSTALL_LIB_DIR lib/oclint CACHE PATH "Installation directory for libraries")
set(INSTALL_BIN_DIR bin/oclint CACHE PATH "Installation directory for executables")
set(INSTALL_INCLUDE_DIR include/oclint CACHE PATH
  "Installation directory for header files")
if(WIN32 AND NOT CYGWIN)
  set(DEF_INSTALL_CMAKE_DIR CMake)
else()
  set(DEF_INSTALL_CMAKE_DIR lib/cmake/oclint)
endif()
set(INSTALL_CMAKE_DIR ${DEF_INSTALL_CMAKE_DIR} CACHE PATH
  "Installation directory for CMake files")
 
# Make relative paths absolute (needed later on)
foreach(p LIB BIN INCLUDE CMAKE)
  set(var INSTALL_${p}_DIR)
  if(NOT IS_ABSOLUTE "${${var}}")
    set(${var} "${CMAKE_INSTALL_PREFIX}/${${var}}")
  endif()
endforeach()

 #Add all targets to the build-tree export set
export(EXPORT OCLintReportersTargets
  FILE "${PROJECT_BINARY_DIR}/OCLintReportersTargets.cmake")
 
# Export the package for use from the build-tree
# (this registers the build-tree with a global CMake-registry)
export(PACKAGE OCLintReporters)

# Create the OCLintReportersConfig.cmake and OCLintReportersConfigVersion files
file(RELATIVE_PATH REL_INCLUDE_DIR "${INSTALL_CMAKE_DIR}"
   "${INSTALL_INCLUDE_DIR}")
# ... for the build tree
set(CONF_INCLUDE_DIRS "${PROJECT_SOURCE_DIR}/include" )
configure_file(OCLintReportersConfig.cmake.in
  "${PROJECT_BINARY_DIR}/OCLintReportersConfig.cmake" @ONLY)
# ... for the install tree
set(CONF_INCLUDE_DIRS "\${OCLINT_CORE_CMAKE_DIR}/${REL_INCLUDE_DIR}")
configure_file(OCLintReportersConfig.cmake.in
  "${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/OCLintReportersConfig.cmake" @ONLY)
# ... for both
#configure_file(OCLintReportersConfigVersion.cmake.in
#  "${PROJECT_BINARY_DIR}/OCLintReportersConfigVersion.cmake" @ONLY)
 
# Install the OCLintReportersConfig.cmake and OCLintReportersConfigVersion.cmake
install(FILES
  "${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/OCLintReportersConfig.cmake"
#  "${PROJECT_BINARY_DIR}/OCLintReportersConfigVersion.cmake"
  DESTINATION "${INSTALL_CMAKE_DIR}" COMPONENT dev)
 
# Install the export set for use with the install-tree
install(EXPORT OCLintReportersTargets DESTINATION
  "${INSTALL_CMAKE_DIR}" COMPONENT dev)
