#We're going to create a proper target for matplotlib with its required python dependencies

#find_package is the CMake command to find a third-party library. In Linux this generally just works but in windows you need
#to provide path hints (unless installed by vcpkg and "vcpkg integrate install" has been called)
#Python3 is the name of the library we're looking. COMPONENTS tells find_package that we're looking for specific components of
#that library, in this case the Development component. REQUIRED means that the CMake configure step will fail if it is not found
find_package(Python3 COMPONENTS Development REQUIRED)

#vcpkg tells us to use find_path, but it's general usage in CMake is to build find_modules that create proper targets, like we're
#doing here. It looks for the location of the file given in a series of default folders, you may provide additional hint paths,
#and vcpkg integrate install sets its own set of default folders to look for things. The resulting directory containing the file
#will be placed in the variable you specify. In this case MatplotLib_INCLUDE_DIR will have the location of matplotlibcpp.h
find_path(MatplotLib_INCLUDE_DIR "matplotlibcpp.h")

#FindPackageHandleStandardArgs is a module containing a helper for generating find_package cmake modules.
include(FindPackageHandleStandardArgs)
#in this case we're going to create a package called MatplotLib, and the variable that will indicate whether that package was found
#is going to be called MatplotLib_FOUND. In this case, the condition for saying that we have found matplotLib_FOUND is that
#the required var MatplotLib_INCLUDE_DIR has been populated
find_package_handle_standard_args(MatplotLib
	FOUND_VAR MatplotLib_FOUND
	REQUIRED_VARS
		MatplotLib_INCLUDE_DIR
)

#We're only going to create the target if we found the library
if(MatplotLib_FOUND)
	#We're going to set the variable MatplotLib_INCLUDE_DIRS to the path containing the header file of the library
	set(MatplotLib_INCLUDE_DIRS ${MatplotLib_INCLUDE_DIR})
	#add_library creates a new library target (as opposed to an executable)
	#The first argument is the name of the target, in this case, MatplotLib::MatplotLib
	#The second argument is the type of library we're creating:
	#INTERFACE means it's a header-only library, so really the target only contains information on where to find the headers
	#STATIC is a library for static linking
	#SHARED is a library for dynamic linking (I recommend against that for ELCT 350, because Windows requires you to manually export
	#functions in a dll, and manually import the functions using _dllexport and _dllimport, and it may be too much work for the
	#students for little benefit)
	#finally we add the IMPORTED keyword, meaning we're not telling CMake to build this target, we're importing a package from an
	#already existing location
	add_library(MatplotLib::MatplotLib INTERFACE IMPORTED)
	#target_link_libraries specify what libraries to link with the target
	#In this case, we're not actually linking a library to MatplotLib::MatplotLib, since it's an imported target anyway.
	#The first argument is the target name
	#The second argument is one of
	#PUBLIC - Anyone linking this target will also link to the specified libraries
	#PRIVATE - The linking will only happen to this library, but not to the others that link to this library
	#INTERFACE - We're not linking to this library (this is a header-only library, so we can't), but we're saying anyone
	#	that links to this library must link to these libraries in order to execute
	#The subsequent arguments are the libraries we depend on
	target_link_libraries(MatplotLib::MatplotLib INTERFACE Python3::Python)
	#We can add any compile definitions to the target.
	#The first argument is the target name
	#the second argument can be onee of:
	#PUBLIC -- the compile definition will carry through to anyone that links to this target
	#PRIVATE -- the compile definition will NOT carry through to those taht link to this target
	#INTERFACE -- this is a header-only library, so it won't be compiled. So the compile definition is really for whoever links it
	#In this case, unless you install the c++ numpy stuff in vcpkg, you must define WITHOUT_NUMPY, so I went this route
	target_compile_definitions(MatplotLib::MatplotLib INTERFACE WITHOUT_NUMPY)
	#We're setting any additional properties that go along with our target. In this case, the include directory containing the headers
	#This way anyone setting MatplotLib::MatplotLib as a link dependency won't need to know the actual path, it will be automatic
	set_target_properties(MatplotLib::MatplotLib PROPERTIES
		INTERFACE_INCLUDE_DIRECTORIES "${MatplotLib_INCLUDE_DIR}"
	)
endif(MatplotLib_FOUND)

#We're saying MatplotLib_INCLUDE_DIR is not to be shown to the user in the list of cached variables by default, unless as they want
#to see the advanced variables
mark_as_advanced(
	MatplotLib_INCLUDE_DIR
)