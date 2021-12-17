#version 450
#extension GL_GOOGLE_include_directive : enable
#include "../vulkan_common.glsl"

TEXTURE_INPUT

layout(location = 0) in vec2 inTex;

layout(location = 0) out vec4 outColor;

layout(std140, set = 2, binding = 0) uniform CustomUniform
{
	// Umajin does not tightly pack values into the custom uniform buffer currently.
	// Each member will be at a 16 byte offset from the previous member regardless of size.
	layout(offset = 0)   float umajin_time;
	layout(offset = 16)  vec2  umajin_window_size;
	layout(offset = 32)  vec3  umajin_cursor;
	layout(offset = 48)  vec3  background_color;
	layout(offset = 64)  vec3  ring_color;
	layout(offset = 80)  vec3  ball_color;
	layout(offset = 96)  float ring_thickness;
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


// For reading on using Signed Distance Fields see
// https://www.ronja-tutorials.com/post/034-2d-sdf-basics/
// This follows the basics of that tutorial, converted into GLSL

// Positioning functions
vec2 translate(vec2 pos, vec2 offset)
{
    return pos - offset;
}

vec2 scale(vec2 pos, float scale)
{
    return pos / scale;
}

vec2 rotate(vec2 pos, float rot)
{
    float angle = -rot;
    float sine = sin(angle);
    float cosine = cos(angle);
    
    return vec2(cosine * pos.x + sine * pos.y, cosine * pos.y - sine * pos.x);
}

// Shape functions
float circle(vec2 pos, float radius)
{
    return length(pos) - radius;
}

float rectangle(vec2 pos, vec2 halfSize)
{
    vec2 componentWiseEdgeDistance = abs(pos) - halfSize;
    float outsideDistance = length(max(componentWiseEdgeDistance, vec2(0)));
    float insideDistance = min(max(componentWiseEdgeDistance.x, componentWiseEdgeDistance.y), 0.);
    
    return outsideDistance + insideDistance;
}
    
// Fill/line drawing functions
float solidFill(float d)
{
    float ddx = fwidth(d) * 0.5;
    return 1.0 - smoothstep(-ddx, ddx, d);
}

float solidLine(float d, float width)
{
    float line = abs(d) - width;
    float ddx = fwidth(line) * 0.5;
    return 1.0 - smoothstep(-ddx, ddx, line);
}

float softLine(float d, float width, float softness)
{
    return 1.0 - smoothstep(-softness, softness, abs(d) - width);
}

// Parts which make up the scene.
vec4 spinningBall(vec2 pos)
{
    vec2 p = pos;
    p = rotate(p, mod(2.5*iTime, radians(360.)));
    p = translate(p, vec2(0.75,0.));
    float d = circle(p, 0.1);
    
    vec3 c = customUniform.ball_color;
    vec4 res = vec4(c.r, c.g, c.b, solidFill(d));
    return res;
}

vec4 spinningBallShadow(vec2 pos)
{
    vec2 p = pos;
    p = translate(p, vec2(0.005,-0.005));
    p = rotate(p, mod(2.5*iTime, radians(360.)));
    p = translate(p, vec2(0.75,0.));
    float d = circle(p, 0.09);
    
    vec4 res = vec4(0., 0., 0., softLine(d, 0.01,0.01)*0.5);
    return res;
}

vec4 centerRing(vec2 pos)
{
    float d = circle(pos, 0.75);
    vec3 c = customUniform.ring_color;
    return vec4(c.r, c.g, c.b, solidLine(d, customUniform.ring_thickness));
}

vec4 centerRingShadow(vec2 pos)
{
    vec2 p = translate(pos, vec2(0.005,-0.005));
    float d = circle(p, 0.75);
    return vec4(0., 0., 0., softLine(d, customUniform.ring_thickness*0.95, customUniform.ring_thickness) * 0.5);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    vec3 col = customUniform.background_color;
    
    vec2 p = (2.0*fragCoord-iResolution.xy)/iResolution.y;

    // Here we build the scene using all the parts.  Each part is
    // mixed with the previous to alpha blend the scene together.
    vec4 ringShadow = centerRingShadow(p);
    col = mix(col, ringShadow.xyz, ringShadow.a);
    
    vec4 ring = centerRing(p);
    col = mix(col, ring.xyz, ring.a);
    
    vec4 ballShadow = spinningBallShadow(p);
    col = mix(col, ballShadow.xyz, ballShadow.a);
    
    vec4 colorBall = spinningBall(p);
    col = mix(col, colorBall.xyz, colorBall.a);
    
    fragColor = vec4(col, 1.0);
}


//-----------------------------------------------------------------------------
//  Place ShaderToy code above here
//-----------------------------------------------------------------------------

void main()
{
	mainImage(outColor, inTex * customUniform.umajin_window_size);
}