@echo OFF
REM Copyright 2021 The Khronos Group Inc.
REM SPDX-License-Identifier: Apache-2.0

if NOT EXIST C:\Tools\vcpkg\packages\openimageio* (
    echo "Installing OpenImageIO package and its dependencies."
    REM --triplet not supported in VS2015 environment so use older style.
    REM vcpkg install --triplet=x64-windows openimageio
    vcpkg install openimageio:x64-windows
) else (
    echo "Upgrading OpenImageIO package and its dependencies."
    vcpkg upgrade
)

