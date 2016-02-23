CMAKE_MINIMUM_REQUIRED(VERSION 2.8)
PROJECT(OCLINT_DRIVER)

find_package(OCLintCore REQUIRED)

SET(CMAKE_MODULE_PATH
    ${CMAKE_MODULE_PATH}
    ${OCLINT_CORE_CMAKE_DIR}
    )

INCLUDE(OCLintConfig)

INCLUDE_DIRECTORIES(${OCLINT_CORE_INCLUDE_DIRS}
	${OCLINT_DRIVER_SOURCE_DIR}/include
)

ADD_SUBDIRECTORY(lib)

IF(MINGW)
    ADD_EXECUTABLE(oclint-${OCLINT_VERSION_RELEASE}
        main.cpp
        reporters_windows_port.cpp
        rules_windows_port.cpp
        )
ELSE()
    ADD_EXECUTABLE(oclint-${OCLINT_VERSION_RELEASE}
        main.cpp
        reporters_dlfcn_port.cpp
        rules_dlfcn_port.cpp
        )
ENDIF()

TARGET_LINK_LIBRARIES(oclint-${OCLINT_VERSION_RELEASE}
    OCLintDriver
    ${OCLINT_CORE_LIBRARIES}
    clangStaticAnalyzerFrontend
    clangStaticAnalyzerCheckers
    clangStaticAnalyzerCore
    clangRewriteFrontend
    clangRewrite
    ${CLANG_LIBRARIES}
    ${REQ_LLVM_LIBRARIES}
    ${CMAKE_DL_LIBS}
    )


# Offer the user the choice of overriding the installation directories
set(INSTALL_LIB_DIR lib CACHE PATH "Installation directory for libraries")
set(INSTALL_BIN_DIR bin CACHE PATH "Installation directory for executables")
set(INSTALL_INCLUDE_DIR include CACHE PATH
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

INSTALL(TARGETS oclint-${OCLINT_VERSION_RELEASE}
	RUNTIME DESTINATION "${INSTALL_BIN_DIR}"
)
 
install(DIRECTORY include/oclint
	DESTINATION "${INSTALL_INCLUDE_DIR}" COMPONENT dev)

# Add all targets to the build-tree export set
export(TARGETS OCLintDriver
  FILE "${PROJECT_BINARY_DIR}/OCLintDriverTargets.cmake")
 
# Export the package for use from the build-tree
# (this registers the build-tree with a global CMake-registry)
export(PACKAGE OCLintDriver)

# Create the OCLintDriverConfig.cmake and OCLintDriverConfigVersion files
file(RELATIVE_PATH REL_INCLUDE_DIR "${INSTALL_CMAKE_DIR}"
   "${INSTALL_INCLUDE_DIR}")
# ... for the build tree
set(CONF_INCLUDE_DIRS "${PROJECT_SOURCE_DIR}/include" )
configure_file(OCLintDriverConfig.cmake.in
  "${PROJECT_BINARY_DIR}/OCLintDriverConfig.cmake" @ONLY)
# ... for the install tree
set(CONF_INCLUDE_DIRS "\${OCLINT_CORE_CMAKE_DIR}/${REL_INCLUDE_DIR}")
configure_file(OCLintDriverConfig.cmake.in
  "${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/OCLintDriverConfig.cmake" @ONLY)
# ... for both
#configure_file(OCLintDriverConfigVersion.cmake.in
#  "${PROJECT_BINARY_DIR}/OCLintDriverConfigVersion.cmake" @ONLY)
 
# Install the OCLintDriverConfig.cmake and OCLintDriverConfigVersion.cmake
install(FILES
  "${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/OCLintDriverConfig.cmake"
#  "${PROJECT_BINARY_DIR}/OCLintDriverConfigVersion.cmake"
  DESTINATION "${INSTALL_CMAKE_DIR}" COMPONENT dev)
 
# Install the export set for use with the install-tree
install(EXPORT OCLintDriverTargets DESTINATION
  "${INSTALL_CMAKE_DIR}" COMPONENT dev)
