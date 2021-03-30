#version 450
#extension GL_GOOGLE_include_directive : enable
#include "../vulkan_common.glsl"

VERTEX_INPUT

layout(std140, set = 2, binding = 0) uniform CustomUniform
{
	layout(offset = 0)  float uv_scale;
	layout(offset = 16) vec2  uv_offset;
	layout(offset = 32) vec3  pos_shift;
	layout(offset = 48) vec4  color_shift;
} customUniform;

layout(location = 0) out vec2 outTex;

void main()
{
	vec4 model_pos = vec4(inPosition + customUniform.pos_shift, 1);
	gl_Position = ubo.proj * ubo.view * dynamicUBO.world * model_pos;
	outTex = inTexCoord;
}