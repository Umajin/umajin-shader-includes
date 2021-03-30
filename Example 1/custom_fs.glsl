uniform sampler2D DiffuseMap;

varying HIGH_PRECISION vec2 texc;

void main(void)
{
   vec4 output = texture2D(DiffuseMap, texc);
   output.rgb = vec3(1,1,1) - output.rgb;
   
   gl_FragColor = output;
}