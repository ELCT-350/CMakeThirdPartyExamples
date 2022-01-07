#The first command in the root CMakeLists.txt file must be cmake_minimum_required, specifying the minimum version of CMake that can
#process this file
cmake_minimum_required(VERSION 3.20)

#Setting the CMAKE_MODULE_PATH directory tells CMake where to look for any custom CMake modules.
#In this case, vcpkg's matplotlib depends is a header-only library, but it depends on python, and they didn't set up that dependency
#properly. So I created a FindMatplotLib.cmake module that finds the header file as recommended by vcpkg, but also creates a target
#that includes that dependency, so it will be properly handled by anyone that links to it. That module is located in the directory
#below. CMAKE_CURRENT_SOURCE_DIR evaluates to the directory where the currently processing CMakeLists.txt file is located.
#You use the ${VARIABLE_NAME} syntax to access to the contents of the variables
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/CMakeModules")

#A Project is a just a collection of targets to build that may have dependencies among each other. You must have one root project,
#but it is allowable to create projects within projects
Project(ThirdPartyLibsExample)

#the add_subdirectory command tells CMake to process the CMakeLists.txt file in the given subdirectory. Order matters when
#specifying dependencies. Any subsequent add_subdirectory call will be able to use targets defined by previous add_subdirectory calls
add_subdirectory(PlottingTest)