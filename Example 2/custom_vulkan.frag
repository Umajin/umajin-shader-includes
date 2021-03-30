#version 450
#extension GL_GOOGLE_include_directive : enable
#include "vulkan_common.glsl"

TEXTURE_INPUT

layout(location = 0) in vec2 inTex;

layout(location = 0) out vec4 outColor;

void main()
{
	outColor = texture(sampler2D(textures[DIFFUSE_INDEX], samp), inTex);
	outColor.rgb = vec3(1,1,1) - outColor.rgb;
}