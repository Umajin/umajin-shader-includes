#version 450
#extension GL_GOOGLE_include_directive : enable
#include "../vulkan_common.glsl"

TEXTURE_INPUT

layout(location = 0) in vec2 inTex;

layout(location = 0) out vec4 outColor;

layout(std140, set = 2, binding = 0) uniform CustomUniform
{
	layout(offset = 0)  float umajin_time;
	layout(offset = 16) vec2  umajin_window_size;
	layout(offset = 32) vec3  umajin_cursor;
} customUniform;

layout(set = 2, binding = 1) uniform texture2D ichannel0;
layout(set = 2, binding = 2) uniform texture2D ichannel1;
layout(set = 2, binding = 3) uniform texture2D ichannel2;
layout(set = 2, binding = 4) uniform texture2D ichannel3;

#define iTime customUniform.umajin_time
#define iResolution customUniform.umajin_window_size
#define iMouse customUniform.umajin_cursor
#define iChannel0 sampler2D(ichannel0, samp)
#define iChannel1 sampler2D(ichannel1, samp)
#define iChannel2 sampler2D(ichannel2, samp)
#define iChannel3 sampler2D(ichannel3, samp)


//-----------------------------------------------------------------------------
//  Place ShaderToy code below here
//-----------------------------------------------------------------------------




//-----------------------------------------------------------------------------
//  Place ShaderToy code above here
//-----------------------------------------------------------------------------

void main()
{
	mainImage(outColor, inTex * customUniform.umajin_window_size);
}