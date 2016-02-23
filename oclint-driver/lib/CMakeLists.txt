ADD_LIBRARY(OCLintDriver
    CompilerInstance.cpp
    ConfigFile.cpp
    DiagnosticDispatcher.cpp
    Driver.cpp
    GenericException.cpp
    Logger.cpp
    Options.cpp
    RulesetBasedAnalyzer.cpp
    RulesetFilter.cpp
    )

install(TARGETS OCLintDriver
  # IMPORTANT: Add the foo library to the "export-set"
  EXPORT OCLintDriverTargets
  ARCHIVE DESTINATION "${INSTALL_LIB_DIR}" COMPONENT lib
  RUNTIME DESTINATION "${INSTALL_BIN_DIR}" COMPONENT bin
  LIBRARY DESTINATION "${INSTALL_LIB_DIR}" COMPONENT lib
)


