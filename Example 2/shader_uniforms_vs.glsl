uniform mat4 World;
uniform mat4 View;
uniform mat4 Projection;

uniform float uv_scale;
uniform vec2 uv_offset;
uniform vec3 pos_shift;
uniform vec4 color_shift;

attribute vec3 Pos;
attribute vec2 TexCoord;

varying HIGH_PRECISION vec2 texc;

void main(void)
{
   vec4 modelPos = vec4(Pos, 1.0);
   modelPos.xyz += pos_shift;

   gl_Position = modelPos * World * View * Projection;

   texc.xy = TexCoord;
}