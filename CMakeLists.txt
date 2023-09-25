cmake_minimum_required(VERSION 3.26)
project(test_asm_first C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O2")

add_executable(test_asm_first main.c)
