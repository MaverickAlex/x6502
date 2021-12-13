cmake_minimum_required(VERSION 3.0.0)
project(6502Emulator VERSION 0.1.0)

include(CTest)
enable_testing()


find_package(Curses REQUIRED)

include_directories(${CURSES_INCLUDE_DIR})

include_directories ( src )
include_directories( src/opcode_handlers)

add_executable(6502Emulator src/main.c)

target_link_libraries(6502Emulator ${CURSES_LIBRARIES})

target_sources(6502Emulator PRIVATE 
    src/cpu.c
    src/emu.c
    src/gui.c
    src/io.c
    src/keys.c
    src/lcd.c
    src/opcodes.c
    src/via.c
)


set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
include(CPack)
