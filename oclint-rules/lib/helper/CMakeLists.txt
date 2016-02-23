IF (NOT MINGW)
    ADD_LIBRARY(OCLintHelper
        AttributeHelper.cpp
        EnforceHelper.cpp
        SuppressHelper.cpp
    )

install(TARGETS OCLintHelper
  # IMPORTANT: Add the foo library to the "export-set"
  EXPORT OCLintRulesTargets
  ARCHIVE DESTINATION "${INSTALL_LIB_DIR}" COMPONENT lib
  RUNTIME DESTINATION "${INSTALL_BIN_DIR}" COMPONENT bin
  LIBRARY DESTINATION "${INSTALL_LIB_DIR}" COMPONENT lib
)

ENDIF()
