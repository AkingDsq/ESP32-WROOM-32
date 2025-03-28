# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

# If CMAKE_DISABLE_SOURCE_CHANGES is set to true and the source directory is an
# existing directory in our source tree, calling file(MAKE_DIRECTORY) on it
# would cause a fatal error, even though it would be a no-op.
if(NOT EXISTS "D:/git/work/ESP32-WROOM-32/APP/MIMO/build/Qt_6_8_2_Clang_arm64_v8a-Debug/_deps/android_openssl-src")
  file(MAKE_DIRECTORY "D:/git/work/ESP32-WROOM-32/APP/MIMO/build/Qt_6_8_2_Clang_arm64_v8a-Debug/_deps/android_openssl-src")
endif()
file(MAKE_DIRECTORY
  "D:/git/work/ESP32-WROOM-32/APP/MIMO/build/Qt_6_8_2_Clang_arm64_v8a-Debug/_deps/android_openssl-build"
  "D:/git/work/ESP32-WROOM-32/APP/MIMO/build/Qt_6_8_2_Clang_arm64_v8a-Debug/_deps/android_openssl-subbuild/android_openssl-populate-prefix"
  "D:/git/work/ESP32-WROOM-32/APP/MIMO/build/Qt_6_8_2_Clang_arm64_v8a-Debug/_deps/android_openssl-subbuild/android_openssl-populate-prefix/tmp"
  "D:/git/work/ESP32-WROOM-32/APP/MIMO/build/Qt_6_8_2_Clang_arm64_v8a-Debug/_deps/android_openssl-subbuild/android_openssl-populate-prefix/src/android_openssl-populate-stamp"
  "D:/git/work/ESP32-WROOM-32/APP/MIMO/build/Qt_6_8_2_Clang_arm64_v8a-Debug/_deps/android_openssl-subbuild/android_openssl-populate-prefix/src"
  "D:/git/work/ESP32-WROOM-32/APP/MIMO/build/Qt_6_8_2_Clang_arm64_v8a-Debug/_deps/android_openssl-subbuild/android_openssl-populate-prefix/src/android_openssl-populate-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "D:/git/work/ESP32-WROOM-32/APP/MIMO/build/Qt_6_8_2_Clang_arm64_v8a-Debug/_deps/android_openssl-subbuild/android_openssl-populate-prefix/src/android_openssl-populate-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "D:/git/work/ESP32-WROOM-32/APP/MIMO/build/Qt_6_8_2_Clang_arm64_v8a-Debug/_deps/android_openssl-subbuild/android_openssl-populate-prefix/src/android_openssl-populate-stamp${cfgdir}") # cfgdir has leading slash
endif()
