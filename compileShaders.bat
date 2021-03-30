%VK_SDK_PATH%/Bin/glslangValidator.exe -V "Example 1/custom_vulkan.vert" -o "Example 1/custom_vert.sprv"
%VK_SDK_PATH%/Bin/glslangValidator.exe -V "Example 1/custom_vulkan.frag" -o "Example 1/custom_frag.sprv"

fxc /nologo /O3 /T fx_5_0 /Fo "Example 1/custom.fxc" "Example 1/custom.fx"

%VK_SDK_PATH%/Bin/glslangValidator.exe -V "Example 2/shader_uniforms.vert" -o "Example 2/shader_uniforms_vert.sprv"
%VK_SDK_PATH%/Bin/glslangValidator.exe -V "Example 2/shader_uniforms.frag" -o "Example 2/shader_uniforms_frag.sprv"

fxc /nologo /O3 /T fx_5_0 /Fo "Example 2/shader_uniforms.fxc" "Example 2/shader_uniforms.fx"


pause