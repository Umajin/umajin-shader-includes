%VK_SDK_PATH%/Bin/glslangValidator.exe -V "Example 1/custom_vulkan.vert" -o "Example 1/custom_vert.sprv"
%VK_SDK_PATH%/Bin/glslangValidator.exe -V "Example 1/custom_vulkan.frag" -o "Example 1/custom_frag.sprv"

fxc /nologo /O3 /T fx_5_0 /Fo "Example 1/custom.fxc" "Example 1/custom.fx"

pause