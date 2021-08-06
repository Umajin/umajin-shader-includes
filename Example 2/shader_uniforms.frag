#version 450
#extension GL_GOOGLE_include_directive : enable
#include "../vulkan_common.glsl"

TEXTURE_INPUT

layout(std140, set = 2, binding = 0) uniform CustomUniform
{
	layout(offset = 0)  float uv_scale;
	layout(offset = 16) vec2  uv_offset;
	layout(offset = 32) vec3  pos_shift;
	layout(offset = 48) vec4  color_shift;
} customUniform;

layout(set = 2, binding = 1) uniform texture2D extra_texture;

layout(location = 0) in vec2 inTex;

layout(location = 0) out vec4 outColor;

void main()
{
	vec2 texCoords = (inTex + customUniform.uv_offset) * customUniform.uv_scale.xx;
	texCoords = mod(texCoords, vec2(1,1));
	vec4 diffuse = texture(sampler2D(DiffuseMap, samp), texCoords);
	diffuse += texture(sampler2D(extra_texture, samp), inTex);
	
	outColor = diffuse + customUniform.color_shift;
}