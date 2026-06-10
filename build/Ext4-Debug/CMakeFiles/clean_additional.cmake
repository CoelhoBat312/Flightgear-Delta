# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles/Flightgear_Delta_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/Flightgear_Delta_autogen.dir/ParseCache.txt"
  "Flightgear_Delta_autogen"
  )
endif()
