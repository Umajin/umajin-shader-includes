glslangValidator -V "Example 1/custom_vulkan.vert" -o "Example 1/custom_vert.sprv"
glslangValidator -V "Example 1/custom_vulkan.frag" -o "Example 1/custom_frag.sprv"

glslangValidator -V "Example 2/shader_uniforms.vert" -o "Example 2/shader_uniforms_vert.sprv"
glslangValidator -V "Example 2/shader_uniforms.frag" -o "Example 2/shader_uniforms_frag.sprv"

glslangValidator -V "ShaderToy Example/shader_toy.vert" -o "ShaderToy Example/shader_toy_vert.sprv"
glslangValidator -V "ShaderToy Example/shader_toy.frag" -o "ShaderToy Example/shader_toy_frag.sprv"
