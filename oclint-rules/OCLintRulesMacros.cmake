MACRO(build_dynamic_rule name)
    IF (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
        SET(CMAKE_SHARED_LINKER_FLAGS "-undefined dynamic_lookup")
    ENDIF()

    ADD_LIBRARY(${name}Rule SHARED ${name}Rule.cpp)

    SET_TARGET_PROPERTIES(${name}Rule
        PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/rules.dl
                   RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/rules.dl
        )

    IF (MINGW)
        TARGET_LINK_LIBRARIES(${name}Rule
            OCLintAbstractRule
            OCLintMetric
        )
    ELSE()
        TARGET_LINK_LIBRARIES(${name}Rule OCLintAbstractRule)

        TARGET_LINK_LIBRARIES(${name}Rule
            clangASTMatchers
        ) # TODO: might be redundant

        TARGET_LINK_LIBRARIES(${name}Rule
            OCLintMetric
            OCLintHelper
            OCLintUtil
            OCLintCore
        )

        IF (${CMAKE_SYSTEM_NAME} MATCHES "FreeBSD")
            TARGET_LINK_LIBRARIES(${name}Rule
                ${CLANG_LIBRARIES}
                ${REQ_LLVM_LIBRARIES}
                OCLintRuleSet
            )
        ENDIF()
    ENDIF()

    INSTALL(TARGETS ${name}Rule
	# EXPORT OCLintRulesTargets
	#ARCHIVE DESTINATION "${INSTALL_LIB_DIR}" COMPONENT lib
	RUNTIME DESTINATION "${INSTALL_BIN_DIR}/oclint/rules.dl" COMPONENT bin
	LIBRARY DESTINATION "${INSTALL_LIB_DIR}/oclint/rules.dl" COMPONENT lib
    )
ENDMACRO(build_dynamic_rule)

MACRO(build_dynamic_rules rules)
    FOREACH(it ${rules})
        BUILD_DYNAMIC_RULE(${it})
    ENDFOREACH(it)
ENDMACRO(build_dynamic_rules)

MACRO(add_rule_category_directory category)
    IF(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${category}/CMakeLists.txt)
        ADD_SUBDIRECTORY(${category})
    ENDIF()
ENDMACRO(add_rule_category_directory)


