uniform mat4 World;
uniform mat4 View;
uniform mat4 Projection;

attribute vec3 Pos;
attribute vec2 TexCoord;

varying HIGH_PRECISION vec2 texc;

void main(void)
{
   gl_Position = vec4(Pos, 1.0) * World * View * Projection;

   texc.xy = TexCoord;
}