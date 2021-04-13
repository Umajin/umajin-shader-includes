uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;
uniform sampler2D iChannel3;

uniform float umajin_time;
uniform vec2 umajin_window_size;
uniform vec3 umajin_cursor;

varying HIGH_PRECISION vec2 texc;

#define iTime umajin_time
#define iResolution umajin_window_size
#define iMouse umajin_cursor

//-----------------------------------------------------------------------------
//  Place ShaderToy code below here
//-----------------------------------------------------------------------------



//-----------------------------------------------------------------------------
//  Place ShaderToy code above here
//-----------------------------------------------------------------------------

void main(void)
{
   vec4 colorOut = vec4(0,0,0,1);
   mainImage(colorOut, texc * umajin_window_size);
   gl_FragColor = colorOut;
}