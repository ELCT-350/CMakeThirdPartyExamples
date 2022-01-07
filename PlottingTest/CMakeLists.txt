#To build and run this you will need to:
#If using sciplot:
#To Build:
#vcpkg install sciplot
#To run:
#have gnuplot installed, and gnuplot executable in your path (windows installer will handle this)

#If using matplotlib:
#To Build:
#vcpkg install python3
#vcpkg install matplotlib-cpp
#To run:
#python -m pip install matplotlib
#Will only run on release configuration, not debug

#To find the third-party targets, we use find_package
#here we're looking to find sciplot. Sciplot is a cmake package and they include a config file, so we also specify CONFIG
#REQUIRED means the configuration will fail if sciplot is not foind
find_package(sciplot CONFIG REQUIRED)

#alternatively, you can search for matplot lib
#find_package(MatplotLib REQUIRED)

#We're creating and setting a variable for the location of our header files
set(PLOTTING_TEST_INCLUDE_DIR "${CMAKE_CURRENT_LIST_DIR}/include")
#We're going to recurse through the given folders looking for hpp files and any found will be added to the PLOTTING_TEST_HEADERS
#variable
file(GLOB_RECURSE PLOTTING_TEST_HEADERS ${PLOTTING_TEST_INCLUDE_DIR}/*.hpp)
#We're going to recurse through the given folders looking for cpp files and any found will be added to the PLOTTING_TEST_SOURCE
#variable
file(GLOB_RECURSE PLOTTING_TEST_SOURCE "${CMAKE_CURRENT_LIST_DIR}/src/*.cpp")

#Here we're going to create an executable target (as opposed to a library). We must pass a list of all the source files
#and in this case, they're contained in the PLOTTING_TEST_SOURCE variable. The PLOTTING_TEST_HEADERS is not necessary to add
#to this command, because they will not be directly compiled, but some IDEs using CMake will only display the header files if they
#have been added here
add_executable(PlottingTest ${PLOTTING_TEST_HEADERS} ${PLOTTING_TEST_SOURCE})
#We tell CMake which additional directories to look for header files in, by default. The PRIVATE keyword means anyone linking to
#PlottingTest will not have that directory added to their search path (which makes sense for an executable)
#Libraries will generally have a public include dir, and can optionally also have a private include dir
target_include_directories(PlottingTest PRIVATE ${PLOTTING_TEST_INCLUDE_DIR})
#Here we say that PlottingTest has sciplot as a dependency. This will automatically add the search path for sciplot headers to the
#header search paths, and will automatically link the sciplot library
target_link_libraries(PlottingTest sciplot::sciplot)

#alternatively, you could link to MatplotLib::MatplotLib target created in the findMatplotLib.cmake module I generated,
#which also ensures the python dependency will be carried over
#target_link_libraries(PlottingTest MatplotLib::MatplotLib)