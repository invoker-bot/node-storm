cmake_minimum_required(VERSION 3.12)
project(NodeStorm VERSION 0.0)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR} "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(CMakeJSSetup)
include(CMakeJSNodeAddonAPI)
include(CMakeJSAddLibrary)

set(STORM_SOURCE_FILES main.cc)

cmakejs_add_library(${PROJECT_NAME} ${STORM_SOURCE_FILES})

