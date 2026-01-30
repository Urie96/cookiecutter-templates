cmake_minimum_required(VERSION 3.10)

include_directories(${CMAKE_SOURCE_DIR}/include)

file(GLOB_RECURSE TEST_SOURCES "*.c")
foreach(test_source ${TEST_SOURCES})
    get_filename_component(test_name ${test_source} NAME_WE)
    add_executable(${test_name} ${test_source})
    target_link_libraries(${test_name} PRIVATE {{cookiecutter.project_slug}}_lib)
    add_test(NAME ${test_name} COMMAND ${test_name})
endforeach()
