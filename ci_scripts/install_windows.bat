REM Copyright 2021 The Khronos Group Inc.
REM SPDX-License-Identifier: Apache-2.0
echo OFF

if NOT EXIST C:\Tools\vcpkg\packages\openimageio* (
    echo "Installing OpenImageIO package and its dependencies."
    vcpkg install --triplet=x64-windows openimageio
) else (
    echo "Upgrading OpenImageIO package and its dependencies."
    vcpkg upgrade
)

