CMAKE_MINIMUM_REQUIRED(VERSION 2.8)
PROJECT(OCLINT_RULES)

find_package(OCLintCore REQUIRED)

SET(CMAKE_MODULE_PATH
    ${CMAKE_MODULE_PATH}
    ${OCLINT_CORE_CMAKE_DIR}
    )

INCLUDE(OCLintConfig)

find_package(OCLintMetrics REQUIRED)

INCLUDE_DIRECTORIES(
    ${OCLINT_CORE_INCLUDE_DIRS}
    ${OCLINT_METRICS_DIR}/include
    ${OCLINT_RULES_SOURCE_DIR}/include
    ${OCLINT_RULES_INCLUDE_DIRS}
    )

include(OCLintRulesMacros.cmake)

ADD_SUBDIRECTORY(lib)

IF(TEST_BUILD)
    INCLUDE_DIRECTORIES(${OCLINT_RULES_SOURCE_DIR}/test/headers)
    ADD_SUBDIRECTORY(test)
ELSE(TEST_BUILD)
    ADD_SUBDIRECTORY(rules)
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

install(DIRECTORY include/oclint
	DESTINATION "${INSTALL_INCLUDE_DIR}" COMPONENT dev)

 #Add all targets to the build-tree export set
export(EXPORT OCLintRulesTargets
  FILE "${PROJECT_BINARY_DIR}/OCLintRulesTargets.cmake")
 
# Export the package for use from the build-tree
# (this registers the build-tree with a global CMake-registry)
export(PACKAGE OCLintRules)

# Create the OCLintRulesConfig.cmake and OCLintRulesConfigVersion files
file(RELATIVE_PATH REL_INCLUDE_DIR "${INSTALL_CMAKE_DIR}"
   "${INSTALL_INCLUDE_DIR}")
# ... for the build tree
set(CONF_INCLUDE_DIRS "${PROJECT_SOURCE_DIR}/include" )
configure_file(OCLintRulesConfig.cmake.in
  "${PROJECT_BINARY_DIR}/OCLintRulesConfig.cmake" @ONLY)
# ... for the install tree
set(CONF_INCLUDE_DIRS "\${OCLINT_CORE_CMAKE_DIR}/${REL_INCLUDE_DIR}")
configure_file(OCLintRulesConfig.cmake.in
  "${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/OCLintRulesConfig.cmake" @ONLY)
# ... for both
#configure_file(OCLintRulesConfigVersion.cmake.in
#  "${PROJECT_BINARY_DIR}/OCLintRulesConfigVersion.cmake" @ONLY)
 
# Install the OCLintRulesConfig.cmake and OCLintRulesConfigVersion.cmake
install(FILES
  "${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/OCLintRulesConfig.cmake"
#  "${PROJECT_BINARY_DIR}/OCLintRulesConfigVersion.cmake"
  DESTINATION "${INSTALL_CMAKE_DIR}" COMPONENT dev)
 
# Install the export set for use with the install-tree
install(EXPORT OCLintRulesTargets DESTINATION
  "${INSTALL_CMAKE_DIR}" COMPONENT dev)
