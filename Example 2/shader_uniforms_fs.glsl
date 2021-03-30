
uniform sampler2D DiffuseMap;
uniform sampler2D extra_texture;

uniform float uv_scale;
uniform vec2 uv_offset;
uniform vec3 pos_shift;
uniform vec4 color_shift;

varying HIGH_PRECISION vec2 texc;

void main(void)
{
   vec4 output = texture2D(DiffuseMap, mod((texc + uv_offset) * uv_scale.xx, vec2(1,1)) );
   output += texture2D(extra_texture, texc) * 0.25;

   output += color_shift;
   gl_FragColor = output;
}