message(STATUS "Using the MinGW toolchain file")

set(CMAKE_SYSTEM_NAME Windows)

set(targ "mingw")
set(targ_os "windows")
if(WIN32)
  set(sep ";") # needed for appends to the PATH
else()
  set(sep ":")
endif()

# Choose an appropriate compiler prefix

if(NOT DEFINED MINGW_TYPE)
  if(CMAKE_SYSTEM_PROCESSOR MATCHES "amd64|x86_64|AMD64")
      set(MINGW_TYPE "x86_64" CACHE DOC "Cross compilation MinGW type, can be classic, i686 or x86_64" FORCE)
  else()
      set(MINGW_TYPE "i686" CACHE DOC "Cross compilation MinGW type, can be classic, i686 or x86_64" FORCE)
  endif()

  # Special Scenario on Windows 64 bit (since cmake_system_processor is really inaccurate)
  if($ENV{PROCESSOR_ARCHITEW6432} MATCHES "x86|IA64|AMD64")
      set(MINGW_TYPE "x86_64" CACHE DOC "Cross compilation MinGW type, can be classic, i686 or x86_64" FORCE)
  else()
      set(MINGW_TYPE "i686" CACHE DOC "Cross compilation MinGW type, can be classic, i686 or x86_64" FORCE)
  endif()
  message(STATUS "set a replacement MINGW_TYPE: ${MINGW_TYPE}")
endif()

if(${MINGW_TYPE} STREQUAL "i686")
    set(COMPILER_PREFIX "i686-w64-mingw32")
    set(SHORT_ARCH "win32")
elseif(${MINGW_TYPE} STREQUAL "x86_64")
    set(COMPILER_PREFIX "x86_64-w64-mingw32")
    set(SHORT_ARCH "win64")
elseif(${MINGW_TYPE} STREQUAL "classic")
    message(FATAL_ERROR "Sorry, classic MinGW is no longer supported. Use https://mingw-w64.sourceforge.net")
else()
    message(FATAL_ERROR "Invalid MINGW_TYPE")
endif()

if(NOT WIN32)
  message(STATUS "Cross compiling for Windows!")

  # which compilers to use for C and C++
  find_program(CMAKE_RC_COMPILER NAMES ${COMPILER_PREFIX}-windres)
  find_program(CMAKE_C_COMPILER NAMES ${COMPILER_PREFIX}-gcc)
  find_program(CMAKE_CXX_COMPILER NAMES ${COMPILER_PREFIX}-g++)

  # here is the target environment located
  SET(CMAKE_FIND_ROOT_PATH  /usr/${COMPILER_PREFIX})

  # adjust the default behaviour of the FIND_XXX() commands:
  # search headers and libraries in the target environment,
  # search programs in the host environment
  set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
  set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
  set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
endif()

get_filename_component(PLATFORM_REPO_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
include(${PLATFORM_REPO_DIR}/common.cmake)
