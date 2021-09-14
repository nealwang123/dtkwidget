if (${CMAKE_SYSTEM_PROCESSOR} MATCHES "mips64")
    target_compile_options(${PROJECT_NAME} PRIVATE
        -O3
        -ftree-vectorize
        -march=loongson3a
        -mhard-float
        -mno-micromips
        -mno-mips16
        -flax-vector-conversions
        -mloongson-ext2
        -mloongson-mmi
    )

    set(CMAKE_SHARED_LINKER_FLAGS ${CMAKE_SHARED_LINKER_FLAGS} "-Wl,-z,noexecstack")
endif()

