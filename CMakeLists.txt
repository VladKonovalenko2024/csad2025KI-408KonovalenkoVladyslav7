cmake_minimum_required(VERSION 3.10)

# Назва проєкту
project(hello_project LANGUAGES CXX)

# Вказати стандарт C++
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Додати виконуваний файл
add_executable(hello main.cpp)
