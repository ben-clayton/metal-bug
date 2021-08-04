cmake_minimum_required(VERSION 3.0)

project(MetalBug
    LANGUAGES OBJC
)

add_executable(metal-bug main.m MetalBug.m MetalBug.h)
target_compile_options(metal-bug PRIVATE "-fmodules" "-fcxx-modules")
target_link_options(metal-bug PRIVATE "-framework" "CoreGraphics")

set(SHADER_METAL "${CMAKE_CURRENT_SOURCE_DIR}/shader.metal")
set(SHADER_METALLIB "shader.metallib")

add_custom_command(OUTPUT ${SHADER_METALLIB}
  COMMAND xcrun metal "${SHADER_METAL}" -o "${SHADER_METALLIB}"
  WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
  DEPENDS "${SHADER_METAL}"
  COMMENT "Compiling ${SHADER_METAL}"
  VERBATIM
)
add_custom_target(metal-bug-shader DEPENDS ${SHADER_METALLIB})
add_dependencies(metal-bug metal-bug-shader)
