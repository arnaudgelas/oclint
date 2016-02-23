ADD_SUBDIRECTORY(helper)
ADD_SUBDIRECTORY(util)

SET (AbstractSource
    AbstractASTMatcherRule.cpp
    AbstractASTRuleBase.cpp
    AbstractSourceCodeReaderRule.cpp
)

IF (MINGW)
    ADD_LIBRARY(OCLintAbstractRule SHARED
        ${AbstractSource}
        helper/AttributeHelper.cpp
        helper/EnforceHelper.cpp
        helper/SuppressHelper.cpp
        util/ASTUtil.cpp
        util/StdUtil.cpp)
    TARGET_LINK_LIBRARIES(OCLintAbstractRule
        OCLintCore
        OCLintRuleSet
        ${CLANG_LIBRARIES}
        ${REQ_LLVM_LIBRARIES}
    )
    SET_TARGET_PROPERTIES(OCLintAbstractRule
        PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin
    )

    TARGET_LINK_LIBRARIES(OCLintAbstractRule LINK_INTERFACE_LIBRARIES OCLintRuleSet)
ELSE()
    ADD_LIBRARY(OCLintAbstractRule ${AbstractSource})
ENDIF()

install(TARGETS OCLintAbstractRule
  # IMPORTANT: Add the foo library to the "export-set"
  EXPORT OCLintRulesTargets
  ARCHIVE DESTINATION "${INSTALL_LIB_DIR}" COMPONENT lib
  RUNTIME DESTINATION "${INSTALL_BIN_DIR}" COMPONENT bin
  LIBRARY DESTINATION "${INSTALL_LIB_DIR}" COMPONENT lib
)

