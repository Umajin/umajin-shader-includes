#version 450
#extension GL_GOOGLE_include_directive : enable
#include "vulkan_common.glsl"

VERTEX_INPUT

layout(location = 0) out vec2 outTex;

void main()
{
	gl_Position = ubo.proj * ubo.view * dynamicUBO.world * vec4(inPosition, 1.0);
	outTex = inTexCoord;
}