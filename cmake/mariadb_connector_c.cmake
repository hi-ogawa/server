IF(NOT EXISTS ${CMAKE_SOURCE_DIR}/libmariadb/CMakeLists.txt AND GIT_EXECUTABLE)
  EXECUTE_PROCESS(COMMAND "${GIT_EXECUTABLE}" submodule init
                  WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}")
  EXECUTE_PROCESS(COMMAND "${GIT_EXECUTABLE}" submodule update
                  WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}")
ENDIF()
IF(NOT EXISTS ${CMAKE_SOURCE_DIR}/libmariadb/CMakeLists.txt)
  MESSAGE(FATAL_ERROR "No MariaDB Connector/C! Run
    git submodule init
    git submodule update
Then restart the build.
")
ENDIF()

SET(OPT CONC_)

IF (CMAKE_BUILD_TYPE STREQUAL "Debug")
  SET(CONC_WITH_RTC ON)
ENDIF()

SET(CONC_WITH_SIGNCODE ${SIGNCODE})
SET(SIGN_OPTIONS ${SIGNTOOL_PARAMETERS})

IF(TARGET zlib)
  GET_PROPERTY(ZLIB_LIBRARY_LOCATION TARGET zlib PROPERTY LOCATION)
ELSE()
  SET(ZLIB_LIBRARY_LOCATION ${ZLIB_LIBRARY})
ENDIF()

IF(SSL_DEFINES MATCHES "YASSL")
  IF(WIN32)
    SET(CONC_WITH_SSL "SCHANNEL")
  ELSE()
    SET(CONC_WITH_SSL "GNUTLS") # that's what debian wants, right?
  ENDIF()
ELSE()
  SET(CONC_WITH_SSL "OPENSSL")
  SET(OPENSSL_FOUND TRUE)
ENDIF()

SET(CONC_WITH_CURL OFF)
SET(CONC_WITH_MYSQLCOMPAT ON)

IF (INSTALL_LAYOUT STREQUAL "RPM")
  SET(CONC_INSTALL_LAYOUT "RPM")
ELSE()
  SET(CONC_INSTALL_LAYOUT "DEFAULT")
ENDIF()

SET(PLUGIN_INSTALL_DIR ${INSTALL_PLUGINDIR})
SET(MARIADB_UNIX_ADDR ${MYSQL_UNIX_ADDR})

MESSAGE("== Configuring MariaDB Connector/C")
ADD_SUBDIRECTORY(libmariadb)
