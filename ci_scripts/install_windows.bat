@echo OFF
REM Copyright 2021 The Khronos Group Inc.
REM SPDX-License-Identifier: Apache-2.0

if NOT DEFINED OPENGL_ES_EMULATOR_WIN set OPENGL_ES_EMULATOR_WIN=C:\Imagination\Windows_x86_64
if NOT DEFINED VULKAN_SDK_VER set VULKAN_SDK_VER=1.2.176.1

echo ON
@if not "%appveyor_build_worker_image%" == "Visual Studio 2019" (
    @echo "Install Doxygen"
    cinst doxygen.install
)

@REM Don't use PowerShell for this because its curl is completely different.
@echo "Download PowerVR OpenGL ES Emulator libraries (latest version)."
md %OPENGL_ES_EMULATOR_WIN%
pushd %OPENGL_ES_EMULATOR_WIN%
curl -L -O https://github.com/powervr-graphics/Native_SDK/raw/master/lib/Windows_x86_64/libGLES_CM.dll
curl -L -O https://github.com/powervr-graphics/Native_SDK/raw/master/lib/Windows_x86_64/libGLES_CM.lib
curl -L -O https://github.com/powervr-graphics/Native_SDK/raw/master/lib/Windows_x86_64/libGLESv2.dll
curl -L -O https://github.com/powervr-graphics/Native_SDK/raw/master/lib/Windows_x86_64/libGLESv2.lib
curl -L -O https://github.com/powervr-graphics/Native_SDK/raw/master/lib/Windows_x86_64/libEGL.dll
curl -L -O https://github.com/powervr-graphics/Native_SDK/raw/master/lib/Windows_x86_64/libEGL.lib
popd
@echo

@echo "Install VulkanSDK"
pushd C:\
curl -o VulkanSDK-Installer.exe https://sdk.lunarg.com/sdk/download/%VULKAN_SDK_VER%/windows/VulkanSDK-%VULKAN_SDK_VER%-Installer.exe?Human=true
.\VulkanSDK-Installer.exe /S
@echo "Refresh the environment to pick up Doxygen & VulkanSDK changes."
@REM If we call `refreshenv` the script exits immediately after.
call RefreshEnv.cmd
popd
@echo

@echo "APPVEYOR_BUILD_FOLDER = %APPVEYOR_BUILD_FOLDER%"
@echo "Current directory is"
@cd

@echo OFF
REM Should we at some point need a newer version of vcpkg than is in
REM build worker image, do the following.
REM echo "Update vcpkg"
REM pushd C:\Tools\vcpkg
REM git pull
REM .\bootstrap-vcpkg.bat
REM popd

REM vcpkg cannnot be called from PowerShell in Appveyor environment because
REM in the VS2015 and VS2017 build environments, Boost's cmake configuration
REM prints a warning about file name lengths that causes PS to stop even when
REM the shell's $ErrorActionPreference = Continue. I suspect vcpkg is invoking
REM a subshell.
@echo ON
@if NOT EXIST C:\Tools\vcpkg\packages\openimageio* (
    @echo "Install OpenImageIO package and its dependencies."
    @REM --triplet not supported in VS2015 environment so use older style.
    @REM vcpkg install --triplet=x64-windows openimageio
    vcpkg install openimageio:x64-windows
) else (
    @echo "Upgrade OpenImageIO package and its dependencies."
    vcpkg upgrade
)

@echo "APPVEYOR_BUILD_FOLDER = %APPVEYOR_BUILD_FOLDER%"
@echo "Current directory is"
@cd
