cmake_minimum_required(VERSION 3.10)

# Project name and supported languages
project(hello_project LANGUAGES CXX)

# Specify the C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Add executable target from main.cpp
add_executable(hello main.cpp)
