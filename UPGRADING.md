# Upgrading versions

This document will list the changes between versions and include information for
upgrading your shader code when the vulkan_common.glsl file has breaking changes.


Umajin 6.2.0 Coromandel
=======================

This is the first breaking change for the vulkan shader interface to Umajin.  The main change
for this release is to allow for shader reflection from Umajin when loading shaders.  This means
that scripts uniforms do not need to perfectly match the declared order in the shader.  The uniform
textures have also changed how they are exposed.

* Uniform Textures

Uniform textures are no longer exposed through the other_tex array.  Instead they are now defined
by individual names in layout set 2, bindings 1 -> 8
   
```
// Custom shader textures
layout(set = 2, binding = 1) uniform texture2D shader_uniform_name_here;
layout(set = 2, binding = 2) uniform texture2D shader_uniform_name_here;
layout(set = 2, binding = 3) uniform texture2D shader_uniform_name_here;
layout(set = 2, binding = 4) uniform texture2D shader_uniform_name_here;
layout(set = 2, binding = 5) uniform texture2D shader_uniform_name_here;
layout(set = 2, binding = 6) uniform texture2D shader_uniform_name_here;
layout(set = 2, binding = 7) uniform texture2D shader_uniform_name_here;
layout(set = 2, binding = 8) uniform texture2D shader_uniform_name_here;
```

So change all references to `other_tex[]` and now directly name a uniform texture2D and use it
via its name.

* New Defines

New defines have been added align the Vulkan uniform names with those exposed to OpenGL and DirectX.
The legacy defines are still added to provide backwards compatibility.

|Old                                    | New                                                 |
|---------------------------------------| ----------------------------------------------------|
|ubo.proj                               | Projection                                          |
|ubo.view                               | View                                                |
|dynamicUBO.world                       | World                                               |
|TINT                                   | Tint                                                |
|mat4 skinningMatrix = SKINNING_MATRIX; | SkinningMatrix *Note: Is also now actually a mat4*  |
|LIGHT_POSITION[x]                      | LightPosition[x]                                    |
|LIGHT_DIRECTION[x]                     | LightDirection[x]                                   |
|LIGHT_COLOR[x]                         | LightColor[x]                                       |
|ubo.eyePos                             | EyePos                                              |
|SHADER_UNIFORM[1-4]                    | ShaderUniform[1-4]                                  |
|textures[DIFFUSE_INDEX]                | DiffuseMap                                          |
|textures[AMBIENT_INDEX]                | AmbientMap                                          |
|textures[NORMAL_INDEX]                 | NormalMap                                           |
|textures[SPECULAR_INDEX]               | SpecularMap                                         |
