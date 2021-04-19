uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;
uniform sampler2D iChannel3;

uniform float umajin_time;
uniform vec2 umajin_window_size;
uniform vec3 umajin_cursor;
uniform vec3 background_color;
uniform vec3 ring_color;
uniform vec3 ball_color;
uniform float ring_thickness;

varying HIGH_PRECISION vec2 texc;

#define iTime umajin_time
#define iResolution umajin_window_size
#define iMouse umajin_cursor

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
    
    return vec4(ball_color.r, ball_color.g, ball_color.b, solidFill(d));
}

vec4 spinningBallShadow(vec2 pos)
{
    vec2 p = pos;
    p = translate(p, vec2(0.005,-0.005));
    p = rotate(p, mod(2.5*iTime, radians(360.)));
    p = translate(p, vec2(0.75,0.));
    float d = circle(p, 0.09);
    
    return vec4(0., 0., 0., softLine(d, 0.01,0.01)*0.5);
}

vec4 centerRing(vec2 pos)
{
    float d = circle(pos, 0.75);
    return vec4(ring_color.r, ring_color.g, ring_color.b, solidLine(d,ring_thickness));
}

vec4 centerRingShadow(vec2 pos)
{
    vec2 p = translate(pos, vec2(0.005,-0.005));
    float d = circle(p, 0.75);
    return vec4(0., 0., 0., softLine(d, ring_thickness * 0.95, ring_thickness) * 0.5);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    vec3 col = background_color;
    
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

void main(void)
{
   vec4 colorOut = vec4(0,0,0,1);
   mainImage(colorOut, texc * umajin_window_size);
   gl_FragColor = colorOut;
}